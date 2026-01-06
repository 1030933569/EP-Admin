# Zeabur 部署指南

## 前置条件

您的代码已经准备好：
- ✅ `Dockerfile` 已配置
- ✅ `zeabur.json` 已配置
- ✅ `db.php` 支持环境变量
- ✅ 数据库备份文件已生成 (`Modules/Install/Data/init_data.sql`)

## 部署步骤

### 1. 推送代码到 GitHub

```bash
git add .
git commit -m "Ready for Zeabur deployment"
git push
```

### 2. 在 Zeabur 创建项目

1. 访问 [Zeabur](https://zeabur.com)
2. 创建新项目
3. 导入您的 GitHub 仓库

### 3. 添加 MySQL 服务

1. 在项目中点击 "Add Service"
2. 选择 "MySQL"
3. Zeabur 会自动创建数据库

### 4. 绑定服务

Zeabur 会自动注入环境变量到 Web 服务中，您的 `db.php` 会自动读取这些变量。

### 5. **重要：导入数据库**

部署完成后，您需要导入数据库：

**方法1：通过 Zeabur 控制台**
1. 进入 MySQL 服务页面
2. 点击 "Connect" 或 "Terminal"
3. 上传并导入 `Modules/Install/Data/init_data.sql`

**方法2：使用本地客户端**
1. 从 Zeabur MySQL 服务获取连接信息
2. 使用 MySQL 客户端connect：
   ```bash
   mysql -h <HOST> -P <PORT> -u <USERNAME> -p <DATABASE_NAME> < Modules/Install/Data/init_data.sql
   ```

### 6. 访问您的应用

部署完成后，使用 Zeabur 提供的域名访问：
- 登录地址：`https://your-domain/ep.php?s=/Public/login`
- 用户名：`admin`
- 密码：`123456`

## 注意事项

> [!WARNING]
> - 首次部署后**必须**导入数据库文件，否则无法登录
> - 确保数据库服务与 Web 服务已绑定
> - 建议部署后尽快修改管理员密码

## 故障排除

**问题：无法连接数据库**
- 检查 Zeabur 的 MySQL 服务是否正常运行
- 确认服务之间已正确绑定

**问题：无法登录**  
- 确保已导入 `init_data.sql`
- 检查数据库中是否有 `dejavutech_seller` 表和数据
