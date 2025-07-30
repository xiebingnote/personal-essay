create table cdc_table
(
    id        int auto_increment
  primary key,
    name      varchar(255) null,
    create_at datetime default CURRENT_TIMESTAMP null
);

create table c_table
(
    id        int,
    name      varchar(255),
    create_at datetime
);

CREATE TABLE cdc_table
(
    id        INT,
    name      STRING,
    create_at TIMESTAMP,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'mysql-cdc',
      'hostname' = '172.20.0.3',
      'port' = '3306',
      'username' = 'root',
      'password' = '123456',
      'database-name' = 'test',
      'table-name' = 'cdc_table',
      'server-id' = '5401-5500',
      'scan.startup.mode' = 'initial'
      );
    'scan.startup.mode' = 'initial'
    'scan.startup.mode' = 'latest-offset'

CREATE TABLE c_table
(
    id        INT,
    name      STRING,
    create_at TIMESTAMP,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'starrocks',
      'jdbc-url' = 'jdbc:mysql://172.20.0.4:9030',
      'load-url' = '172.20.0.4:8080',
      'username' = 'root',
      'password' = '',
      'database-name' = 'test',
      'table-name' = 'c_table',
      'sink.properties.format' = 'json',
      'sink.properties.strip_outer_array' = 'true',
      'sink.buffer-flush.interval-ms' = '3000',
      'sink.buffer-flush.max-rows' = '65000',
      'sink.semantic' = 'exactly-once'
      );

INSERT INTO c_table
SELECT id, name, create_at
FROM cdc_table;

DROP USER 'root'@'172.20.0.2';

mysql -h 127.0.0.1 -P 3306 -u root -p123456
SELECT user, host FROM mysql.user WHERE user = 'root';
CREATE USER 'root'@'172.20.0.3' IDENTIFIED WITH mysql_native_password BY '123456';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'172.20.0.3' WITH GRANT OPTION;
ALTER USER 'root'@'172.20.0.3' IDENTIFIED WITH mysql_native_password BY '123456';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
FLUSH PRIVILEGES;
SELECT user, host FROM mysql.user WHERE user = 'root';

SHOW VARIABLES LIKE 'log_bin';
SHOW MASTER STATUS;
SHOW VARIABLES LIKE 'server_id';

execution.checkpointing.interval: 3000