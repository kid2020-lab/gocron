# SQLite 数据库支持指南

gocron 现已支持 SQLite 数据库，适合轻量级部署和开发测试环境。

## 特点

- **零配置** - 无需安装和配置数据库服务器
- **轻量级** - 数据库文件直接存储在本地
- **便携性** - 适合单机部署和快速测试

## 安装配置

### 方式一：通过 Web 安装界面

1. 启动 gocron：`./gocron web`
2. 访问安装页面：`http://localhost:5920/install`
3. 在"数据库选择"中选择 **SQLite**
4. 输入数据库文件路径（例如：`./data/gocron.db`）
5. 配置管理员账号
6. 点击"安装"完成

### 方式二：手动配置

1. 复制配置文件：
   ```bash
   mkdir -p ~/.gocron/conf
   cp app.ini.sqlite.example ~/.gocron/conf/app.ini
   ```

2. 编辑 `~/.gocron/conf/app.ini`：
   ```ini
   [default]
   db.engine=sqlite
   db.database=./data/gocron.db
   ```

3. 启动服务：
   ```bash
   ./gocron web
   ```

## 数据库文件路径说明

支持相对路径和绝对路径：

- **相对路径**：`./data/gocron.db`（相对于程序运行目录）
- **绝对路径**：`/var/lib/gocron/gocron.db` 或 `~/.gocron/data/gocron.db`

## 注意事项

1. **并发限制**：SQLite 适合中小规模任务调度，大规模生产环境建议使用 MySQL 或 PostgreSQL
2. **文件权限**：确保程序对数据库文件及其目录有读写权限
3. **备份**：定期备份数据库文件（直接复制 .db 文件即可）

## 数据库迁移

### 从 SQLite 迁移到 MySQL/PostgreSQL

1. 导出数据（使用第三方工具如 `sqlite3` 命令行）
2. 修改配置文件切换数据库类型
3. 导入数据到新数据库

## 性能对比

| 数据库 | 适用场景 | 并发性能 | 部署复杂度 |
|--------|----------|----------|------------|
| SQLite | 开发测试、小规模部署 | 低 | 极低 |
| MySQL | 生产环境、中大规模 | 高 | 中 |
| PostgreSQL | 生产环境、高级特性 | 高 | 中 |

## 常见问题

**Q: SQLite 数据库文件在哪里？**  
A: 默认在程序运行目录的 `data/gocron.db`，可在配置文件中自定义路径。

**Q: 可以多个 gocron 实例共享同一个 SQLite 数据库吗？**  
A: 不建议。SQLite 不适合多进程并发写入，建议使用 MySQL 或 PostgreSQL。

**Q: 如何备份 SQLite 数据库？**  
A: 直接复制 `.db` 文件即可，建议在服务停止时进行备份。
