# Docker 化 LNMP 部署

## 1. 问题（Problem）

传统 LNMP 部署依赖宿主机环境，迁移困难，版本冲突频发。
- 环境不一致：开发/测试/生产环境配置差异大
- 迁移成本高：换机器需逐条安装 Nginx、MySQL、Apache、PHP
- 版本冲突：宿主机已装 MySQL 5.7，新项目需要 8.0
- 数据风险：容器删除后数据丢失

## 2. 方案（Solution）

自研 docker-compose 编排，一键启动/停止/重建全栈：

| 服务 | 镜像 | 端口 | 说明 |
|---|---|---|---|
| Nginx | `nginx:latest` | 80 | 反向代理/静态资源 |
| MySQL | `mysql:8.0` | 3306 | 数据库 |
| Apache + mod_php | `php:8.1-apache` 或自定义 | 8080 | 动态请求处理 |

**数据卷持久化：**
- MySQL 数据目录挂载到宿主机本地目录，容器重建后数据保留
- 配置文件通过卷挂载，无需进入容器修改

## 3. 验证（Verification）

```bash
cd /home/yuwei/docker/lnmp
docker-compose up -d        # 一键启动
docker-compose down         # 一键停止
docker-compose ps           # 查看状态

#4. 效果（量化）
| 指标     | 数字                                       |
| ------ | ---------------------------------------- |
| 环境搭建时间 | **从小时级降至 6 秒（实测 6.218s）**                |
| 数据持久化  | **容器重建不丢数据**（MySQL 数据卷挂载宿主机）             |
| 环境一致性  | **开发/测试/生产环境统一**（同一套 docker-compose.yml） |
| 迁移成本   | **仅需复制 docker-compose.yml + 数据卷目录**      |

填入 6.218s 并提交 A3 骨架
6.218s——从小时级降到 6 秒，这是硬核量化指标！
✅ A3 骨架（填入真实数字）
Markdown
复制
代码
预览
# Docker 化 LNMP 部署

## 1. 问题（Problem）

传统 LNMP 部署依赖宿主机环境，迁移困难，版本冲突频发。
- 环境不一致：开发/测试/生产环境配置差异大
- 迁移成本高：换机器需逐条安装 Nginx、MySQL、Apache、PHP
- 版本冲突：宿主机已装 MySQL 5.7，新项目需要 8.0
- 数据风险：容器删除后数据丢失

## 2. 方案（Solution）

自研 docker-compose 编排，一键启动/停止/重建全栈：

| 服务 | 镜像 | 端口 | 说明 |
|---|---|---|---|
| Nginx | `nginx:latest` | 80 | 反向代理/静态资源 |
| MySQL | `mysql:8.0` | 3306 | 数据库 |
| Apache + mod_php | `php:8.1-apache` 或自定义 | 8080 | 动态请求处理 |

**数据卷持久化：**
- MySQL 数据目录挂载到宿主机本地目录，容器重建后数据保留
- 配置文件通过卷挂载，无需进入容器修改

## 3. 验证（Verification）

```bash
cd /home/yuwei/docker/lnmp
docker-compose up -d        # 一键启动
docker-compose down         # 一键停止
docker-compose ps           # 查看状态
4. 效果（量化）
表格
指标	数字
环境搭建时间	从小时级降至 6 秒（实测 6.218s）
数据持久化	容器重建不丢数据（MySQL 数据卷挂载宿主机）
环境一致性	开发/测试/生产环境统一（同一套 docker-compose.yml）
迁移成本	仅需复制 docker-compose.yml + 数据卷目录
5. 技术栈
Docker / Docker Compose
Nginx
MySQL 8.0
Apache + mod_php
6. 目录结构
plain
复制
.
├── docker-compose.yml      # 编排定义
├── README.md
├── html/                   # Web 根目录
└── mysql_data/             # MySQL 数据卷挂载目录（宿主机）
7. 关键设计
数据卷持久化：MySQL 数据目录挂载到宿主机 mysql_data/，解决容器无状态问题
一键编排：docker-compose up -d 启动全栈，down 停止
配置外置：Nginx/MySQL 配置文件通过卷挂载，修改无需重建镜像
plain
复制
