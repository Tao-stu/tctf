# TCTF

[使用文档](https://taoi.me/tctf.html)

> 精简 CTF 竞赛平台 Docker 一键部署

## 使用截图

### index

![image-20260508152640479](G:\Desktop\tctf\README.assets\image-20260508152640479.png)

### 登录

![image-20260508152721823](G:\Desktop\tctf\README.assets\image-20260508152721823.png)

### 题目

![image-20260508152810123](G:\Desktop\tctf\README.assets\image-20260508152810123.png)

### 竞赛功能

![image-20260508153138454](G:\Desktop\tctf\README.assets\image-20260508153138454.png)

![image-20260508153213591](G:\Desktop\tctf\README.assets\image-20260508153213591.png)

![image-20260508153232862](G:\Desktop\tctf\README.assets\image-20260508153232862.png)

![image-20260508153311084](G:\Desktop\tctf\README.assets\image-20260508153311084.png)

### 后台管理

![image-20260508153340453](G:\Desktop\tctf\README.assets\image-20260508153340453.png)

### 提建议

![image-20260508153407366](G:\Desktop\tctf\README.assets\image-20260508153407366.png)

## 功能特性

- CTF 题目管理（Web、Pwn、Crypto、Reverse、Misc 等）
- 用户注册登录、积分排行
- 竞赛系统，支持定时开关
- 讨论区功能
- 动态靶机（Docker 容器）
- 理论题（竞赛专用）

## 快速部署

在项目文件夹打开终端

### 安装

install.sh是基于kali2026.1写的，如果使用其它linux版本自行换源和安装docker和docker-compose

```bash
chmod +x install.sh
./install.sh
```

访问 `http://localhost:5000`

### 后续启动

```bash
docker-compose up -d
```

## 服务架构

| 服务 | 端口 | 说明 |
|------|------|------|
| web | 5000 | Flask 应用 |
| mysql | 3306 | MySQL 8.2 数据库 |
| redis | 6379 | Redis 7 缓存 |

## 默认账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | admin123 |

## 目录结构

```
upfile/
├── avatars/      # 用户头像
├── challenges/   # 题目附件
└── files/        # 其他文件
```

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| DB_HOST | mysql | 数据库主机 |
| DB_PORT | 3306 | 数据库端口 |
| DB_USER | tctf_user | 数据库用户名 |
| DB_PASSWORD | tctf_password | 数据库密码 |
| DB_NAME | tctf | 数据库名 |
| REDIS_HOST | redis | Redis 主机 |
| REDIS_PORT | 6379 | Redis 端口 |

## 常用命令

```bash
# 查看日志
docker-compose logs -f tctf-web
```

## 数据持久化

- `mysql_data` - MySQL 数据卷
- `redis_data` - Redis 数据卷

## 系统要求

- debian系里的linux
- 需要安装docker.io和docker-compose
- 十分推荐使用kali，构建版本为kali26.1
