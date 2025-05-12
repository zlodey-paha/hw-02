# Домашнее задание к занятию "Система мониторинга Zabbix" - Попов Павел

---

### Задание 1

Установите Zabbix Server с веб-интерфейсом.

Процесс выполнения
Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
Установите PostgreSQL. Для установки достаточна та версия, что есть в системном репозитороии Debian 11.
Пользуясь конфигуратором команд с официального сайта, составьте набор команд для установки последней версии Zabbix с поддержкой PostgreSQL и Apache.
Выполните все необходимые команды для установки Zabbix Server и Zabbix Web Server.
Требования к результатам
Прикрепите в файл README.md скриншот авторизации в админке.
Приложите в файл README.md текст использованных команд в GitHub.

### Решение 1

```
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
```

`При необходимости прикрепитe сюда скриншоты`
![Вебка](https://github.com/zlodey-paha/hw-02/blob/main/Panel.png)
![Используемый код](https://github.com/zlodey-paha/hw-02/blob/main/Code.png)

---

### Задание 2

`Приведите ответ в свободной форме........`

1. `Заполните здесь этапы выполнения, если требуется ....`
2. `Заполните здесь этапы выполнения, если требуется ....`
3. `Заполните здесь этапы выполнения, если требуется ....`
4. `Заполните здесь этапы выполнения, если требуется ....`
5. `Заполните здесь этапы выполнения, если требуется ....`
6. 

```
Поле для вставки кода...
#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
	echo "Необходимы root права" >&2
	exit 1
fi

wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
apt update
apt install -y zabbix-agent2
apt install -y zabbix-agent2-plugin-mongodb zabbix-agent2-plugin-mssql zabbix-agent2-plugin-postgresql

echo "Настройка конфигурации"
ZABBIX_SERVER="192.168.100.1"
HOSTNAME=$(hostname)

sed -i "s/^Server=.*/Server=$ZABBIX_SERVER/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^ServerActive=.*/ServerActive=$ZABBIX_SERVER/" /etc/zabbix/zabbix_agent2.conf
sed -i "s/^Hostname=.*/Hostname=$HOSTNAME/" /etc/zabbox/zabbix_agent2.conf

systemctl restart zabbix-agent2
systemctl enable zabbix-agent2
```

`При необходимости прикрепитe сюда скриншоты`
![Мониторинг](https://github.com/zlodey-paha/hw-02/blob/main/monitor.png)
![Zabbix Log File](https://github.com/zlodey-paha/hw-02/blob/main/zabbix-log.png)
![Запрос данных с клиента](https://github.com/zlodey-paha/hw-02/blob/main/zabbix-client.png)
![Запрос данных с сервера](https://github.com/zlodey-paha/hw-02/blob/main/zabbix-serv.png)

---
