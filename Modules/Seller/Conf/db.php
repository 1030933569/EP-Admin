<?php
return array(
    'DB_TYPE' => 'mysqli', // 数据库类型
    'DB_HOST' => getenv('MYSQL_HOST') ?: getenv('DATABASE_HOST') ?: '127.0.0.1', // 服务器地址
    'DB_NAME' => getenv('MYSQL_DATABASE') ?: getenv('DATABASE_NAME') ?: 'eaterplanet', // 数据库名
    'DB_USER' => getenv('MYSQL_USERNAME') ?: getenv('DATABASE_USERNAME') ?: 'root', // 用户名
    'DB_PWD' => getenv('MYSQL_PASSWORD') ?: getenv('DATABASE_PASSWORD') ?: '',  // 密码
    'DB_PORT' => getenv('MYSQL_PORT') ?: getenv('DATABASE_PORT') ?: '3306', // 端口
    'DB_PREFIX' => getenv('DB_PREFIX') ?: '', // 数据库表前缀
    'DB_PARAMS' => array(
        \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
        \PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4",
    ),
);
?>