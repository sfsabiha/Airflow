#!/bin/bash

sudo apt-get update
sudo apt-get install -y python3-pip
pip3 install -U setuptools
pip3 install --upgrade pip setuptools wheel
sudo apt-get -s dist-upgrade
sudo apt-get upgrade --fix-missing
sudo apt-get install -y python-psycopg2
sudo apt-get install -y postgresql postgresql-contrib
sudo -u postgres psql
CREATE ROLE ubuntu;
CREATE DATABASE airflow;
GRANT ALL PRIVILEGES on database airflow to ubuntu;
ALTER ROLE ubuntu SUPERUSER;
ALTER ROLE ubuntu CREATEDB;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public to ubuntu;
ALTER ROLE "ubuntu" WITH LOGIN;
sudo vi /etc/postgresql/10/main/pg_hba.conf
change md5 to trust for IPV4 connection
sudo service postgresql restart
export AIRFLOW_HOME=~/airflow
sudo apt-get install -y libmysqlclient-dev
sudo apt-get install -y libssl-dev
sudo apt-get install -y libkrb5-dev
sudo apt-get install -y libsasl2-dev 
sudo apt install  -y redis-server
sudo python3 -m pip install redis
sudo python3 -m pip install apache-airflow[postgres,slack,celery] --ignore-installed PyYAML 
airflow initdb
change in airflow.cfg
executor = CeleryExecutor
sql_alchemy_conn = postgresql+psycopg2://ubuntu@localhost:5432/airflow
broker_url = redis://127.0.0.1:6379/1
result_backend = db+postgresql://ubuntu@localhost:5432/airflow
airflow initdb
airflow webserver -D
airflow scheduler -D
airflow worker -D
airflow flower -D


