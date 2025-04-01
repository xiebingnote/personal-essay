# MySQL Usage

## MySQL 用法

### 1：根据start_time精确到分钟分组：

    SELECT DATE_FORMAT(start_time,'%Y-%m-%d %H:%i') AS start_time, SUM(receive_byte + send_byte) AS send_byte
    FROM asset_flow
    WHERE "2023-04-15 18:45:00" <= start_time AND start_time < "2023-04-20 18:45:00"
    GROUP BY DATE_FORMAT(start_time,'%Y-%m-%d %H:%i')

#### 按天聚合分组：

    SELECT risk_level, DATE_FORMAT( create_at,'%Y-%m-%d 00:00:00') AS time_interval, COUNT(asset_uuid) AS count
    FROM asset_risk_level_stat
    WHERE create_at >= '2024-10-15 00:00:00' AND create_at <= '2024-10-28 00:00:00' AND uid='41d69ad6213442b980a9be97e1218c32' AND risk_level=5
    GROUP BY risk_level, time_interval
    ORDER BY time_interval;

#### 按n天分组：

    select DATE(FROM_UNIXTIME(FLOOR(UNIX_TIMESTAMP(create_at)/(n * 86400) * (n * 86400)))) AS time_interval, risk_level, count(asset_uuid) as count
    from asset_risk_level_stat
    where create_at >= '2024-10-01 00:00:00' and create_at <= '2024-10-31 16:39:17' and uid = '41d69ad6213442b980a9be97e1218c32' and risk_level = 5
    group by time_interval, risk_level
    order by time_interval

#### 按n小时分组：

    SELECT risk_level, DATE_FORMAT(concat( date( create_at ), ' ', FLOOR(HOUR (create_at)/n)*n, ':',  MINUTE ( create_at ) ), '%Y-%m-%d %H:00' ) AS time_interval, COUNT(asset_uuid) AS count
    FROM asset_risk_level_stat
    WHERE create_at >= '2024-10-15 00:00:00' AND create_at <= '2024-10-28 00:00:00' AND uid='41d69ad6213442b980a9be97e1218c32' AND risk_level=5
    GROUP BY risk_level, time_interval
    ORDER BY time_interval;

### 2：COALESCE(e.name, '未知') AS type_name：如果e.name为空给默认值“未知”，GROUP_CONCAT(DISTINCT b.ip SEPARATOR ';') ：b.ip如有多个，以；分割并去重

    SELECT a.name, a.position, a.create_time,
    COALESCE(b.asset_id, '') AS asset_id,
    GROUP_CONCAT(DISTINCT b.ip SEPARATOR ';') AS ip,
    GROUP_CONCAT(DISTINCT b.mac_address SEPARATOR ';') AS mac_address,
    GROUP_CONCAT(DISTINCT c.port SEPARATOR ';') AS port,
    GROUP_CONCAT(DISTINCT c.app_proto SEPARATOR ';') AS app_proto,
    COALESCE(e.name, '未知') AS type_name,
    SUM(IFNULL(d.receive_byte,0) + IFNULL(d.send_byte,0)) AS total_byte,
    SUM(IFNULL(d.receive_byte,0)) AS total_receive_byte,
    SUM(IFNULL(d.send_byte,0)) AS total_send_byte
    FROM asset AS a
    INNER JOIN asset_net_config AS b ON b.asset_id = a.id
    LEFT JOIN asset_service AS c ON c.ip = b.ip
    LEFT JOIN asset_flow As d ON d.ip = b.ip
    LEFT JOIN asset_type AS e ON e.pid = a.type
    WHERE a.source LIKE "%5%"
    -- AND a.dark_asset != 2 OR a.dark_asset IS NULL
    and a.create_time between "2023-04-12 18:45:00" and "2023-04-20 18:45:00"
    GROUP BY b.asset_id

### 3：内连接

    SELECT log_alarm.*,asset.*
    FROM asset
    INNER JOIN log_alarm ON asset.id = log_alarm.asset_id
