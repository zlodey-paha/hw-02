#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
	echo "Необходимы root права" >&2
	exit 1
fi

apt update
apt install -y  postgresql
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
apt update

apt install zabbix-server-pgsql zabbix-frontend-php php8.3-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent

su - postgres -c 'psql --command "CREATE USER zabbix WITH PASSWORD '\'123\'';"'
su - postgres -c 'psql --command "CREATE DATABASE zabbix OWNER zabbix;"'
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix
sed -i 's/# DBPassword=/DBPassword=123/g' /etc/zabbix/zabbix_server.conf
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2

echo "Проверка сервиса"
echo -e "\nZabbix Server, PostgreSQL, Apache2 - Успех"
echo "Доступ к вебке: http://$(hostname -I | awk '{print $1}')/zabbix"
echo "Логин: Admin"
echo "Пароль: zabbix"
