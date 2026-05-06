#!/bin/bash
# Author: yuwei
# Description: Docker MySQL 定时备份脚本
# Version: 1.0
# Usage: ./docker-backup.sh
source .env
set -euo pipefail
BACKUP_FILE="./backup/ops_db_$(date +%Y%m%d_%H%M%S).sql"

docker exec lnmp-mysql sh -c 'mysqldump -u root -p"${MYSQL_ROOT_PASSWORD}" ops_db' > "$BACKUP_FILE"
 
