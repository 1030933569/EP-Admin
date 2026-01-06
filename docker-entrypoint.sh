#!/bin/bash
set -e

echo "==== Starting EP-Admin Application ===="

# 等待数据库就绪
echo "Waiting for database to be ready..."
max_tries=30
count=0
while [ $count -lt $max_tries ]; do
    if mysql -h"${MYSQL_HOST:-$DATABASE_HOST}" -u"${MYSQL_USERNAME:-$DATABASE_USERNAME}" -p"${MYSQL_PASSWORD:-$DATABASE_PASSWORD}" -e "SELECT 1" &>/dev/null; then
        echo "Database is ready!"
        break
    fi
    count=$((count + 1))
    echo "Waiting for database... ($count/$max_tries)"
    sleep 2
done

if [ $count -eq $max_tries ]; then
    echo "ERROR: Database is not accessible after $max_tries attempts"
    exit 1
fi

# 检查数据库是否已初始化
DB_NAME="${MYSQL_DATABASE:-$DATABASE_NAME}"
echo "Checking if database '$DB_NAME' is initialized..."

# 检查 dejavutech_seller 表是否存在且有数据
TABLE_COUNT=$(mysql -h"${MYSQL_HOST:-$DATABASE_HOST}" -u"${MYSQL_USERNAME:-$DATABASE_USERNAME}" -p"${MYSQL_PASSWORD:-$DATABASE_PASSWORD}" -D"$DB_NAME" -sse "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_NAME' AND table_name='dejavutech_seller';" 2>/dev/null || echo "0")

if [ "$TABLE_COUNT" = "0" ]; then
    echo "Database is empty. Importing initial data..."
    if [ -f "/var/www/html/Modules/Install/Data/init_data.sql" ]; then
        mysql -h"${MYSQL_HOST:-$DATABASE_HOST}" -u"${MYSQL_USERNAME:-$DATABASE_USERNAME}" -p"${MYSQL_PASSWORD:-$DATABASE_PASSWORD}" "$DB_NAME" < /var/www/html/Modules/Install/Data/init_data.sql
        echo "✓ Initial data imported successfully!"
    else
        echo "WARNING: init_data.sql not found. Database will be empty."
    fi
else
    RECORD_COUNT=$(mysql -h"${MYSQL_HOST:-$DATABASE_HOST}" -u"${MYSQL_USERNAME:-$DATABASE_USERNAME}" -p"${MYSQL_PASSWORD:-$DATABASE_PASSWORD}" -D"$DB_NAME" -sse "SELECT COUNT(*) FROM dejavutech_seller;" 2>/dev/null || echo "0")
    if [ "$RECORD_COUNT" = "0" ]; then
        echo "Table exists but is empty. Importing initial data..."
        if [ -f "/var/www/html/Modules/Install/Data/init_data.sql" ]; then
            mysql -h"${MYSQL_HOST:-$DATABASE_HOST}" -u"${MYSQL_USERNAME:-$DATABASE_USERNAME}" -p"${MYSQL_PASSWORD:-$DATABASE_PASSWORD}" "$DB_NAME" < /var/www/html/Modules/Install/Data/init_data.sql
            echo "✓ Initial data imported successfully!"
        fi
    else
        echo "✓ Database already initialized with $RECORD_COUNT admin user(s)"
    fi
fi

echo "==== Starting Apache ===="
exec apache2-foreground
