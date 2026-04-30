# docker-lnmp

## 1.标题和描述
LNMP网络架构容器化 解决传统LNMP部署环境不一致问题

## 2. 架构拓扑 
基于Linux的nginx+php+mysql的网络架构
用户-> nginx(8080)-> Apache(80）-> mysql(3306)


## 3. 技术栈
使用了Docker、Docker Compose、Nginx、MySQL apache mod_php 等等 

## 4. 核心功能
实现在Linux系统上面使用docker一键部署lnmp 反向代理 网络架构 服务隔离、数据持久化、端口映射等

## 5. 快速开始
使用docker-compose up -d启动容器 使用curl：192.168.229.136：8080快速验证是否启动成功
MySQL用户名密码参考docker-compose.yml

## 6. 项目结构
docker-lnmp/
├── docker-compose.yml      # 容器编排配置（Nginx→Apache→MySQL）
├── nginx/
│   └── default.conf        # Nginx反向代理配置（proxy_pass到Apache）
├── html/
│   └── index.php           # PHP测试文件
└── README.md               # 项目文档
