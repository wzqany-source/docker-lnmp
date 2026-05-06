# Docker 化 LNMP 部署（工程化升级版）

---

## 1. 问题（Problem）

传统 LNMP 部署依赖宿主机环境，迁移困难，版本冲突频发，配置管理混乱。

- **环境不一致**：开发 / 测试 / 生产环境配置差异大
- **迁移成本高**：换机器需逐条安装 Nginx、MySQL、Apache、PHP
- **密码硬编码**：`docker-compose.yml` 直接写密码，提交即泄露
- **日志易丢失**：容器删除后日志消失，无法追溯
- **无健康检查**：容器挂了不知道，服务异常无感知
- **无备份策略**：数据只依赖卷挂载，缺少定时备份

---

## 2. 方案（Solution）

自研 docker-compose 编排，经过 D1–D4 工程化升级：

| 升级项 | 实现方式 | 效果 |
|---|---|---|
| **D1 健康检查** | Nginx: `curl -f http://localhost/` / MySQL: `mysqladmin ping` | 容器自诊断，3 次失败标记 unhealthy |
| **D2 自定义网络** | `lnmp-net` bridge 网络 | 容器间通过服务名 DNS 解析，不依赖 IP |
| **D2 环境变量外置** | `.env` 存放密码，`docker-compose.yml` 用 `${}` 引用 | 密码不硬编码，排除提交 |
| **D3 日志持久化** | `./logs/nginx/` 和 `./logs/mysql/` 挂载到宿主机 | 容器重建日志文件到指定挂载目录 |
| **D4 定时备份** | `docker-backup.sh` 调用容器内 `mysqldump` | 生成 `ops_db_时间戳.sql`，备份到 `./backup/` |

**一键启动：**

```bash
docker-compose up -d
docker-compose ps          # 查看 health 状态
```

---

## 3. 验证（Verification）

- **健康状态**：`docker-compose ps` 显示 `Up (healthy)`
- **日志查看**：`tail -f ./logs/nginx/access.log`
- **备份验证**：`ls ./backup/` 查看 `.sql` 文件
- **网络连通**：容器内 `ping nginx` / `ping mysql` 可通

---

## 4. 效果（量化）

| 指标 | 数字 |
|---|---|
| 环境搭建时间 | 从小时级降至 6 秒（实测 6.218s） |
| 健康检查 | 30 秒间隔，3 次失败标记 unhealthy，40 秒缓冲期 |
| 密码安全 | 环境变量外置到 `.env`，`.gitignore` 保护不泄露 |
| 日志持久化 | 宿主机 `./logs/` 实时查看，容器重建不丢 |
| 数据备份 | 一键生成 `ops_db_时间戳.sql` |
| 网络管理 | 自定义 bridge，DNS 自动解析 |

---

## 5. 技术栈

- Docker / Docker Compose
- Nginx / Apache / PHP-FPM
- MySQL 8.0
- Bash / Shell

---

## 6. 目录结构（升级后）

```plaintext
.
├── docker-compose.yml      # 编排定义（无硬编码密码）
├── .env                    # 环境变量（密码等敏感配置）
├── .env.template           # 模板文件（供新用户参考）
├── .gitignore              # 排除 .env 和 mysql_data/
├── docker-backup.sh        # MySQL 一键备份脚本
├── README.md
├── html/                   # Web 根目录
├── logs/                   # 日志持久化目录（nginx + mysql）
├── backup/                 # 备份输出目录
├── nginx/                  # Nginx 配置
└── mysql_data/             # MySQL 数据卷（bind mount）
```

---

## 7. 关键设计

- **健康检查**：Nginx 每 30s 自检首页，MySQL 每 30s 自检心跳，连续 3 次失败标记 unhealthy
- **安全实践**：密码外置 `.env`，`.gitignore` 排除，GitHub 上无敏感信息
- **日志持久化**：Nginx `access/error.log` 挂载到宿主机，便于实时分析和审计
- **数据备份**：`docker-backup.sh` 调用容器内 `mysqldump`，生成带时间戳的 SQL 文件
- **自定义网络**：`lnmp-net` 替代默认 bridge，容器间通过服务名通信，IP 变化不影响
