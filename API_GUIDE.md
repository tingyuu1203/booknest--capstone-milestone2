# BookNest API 测试文档

## 目录
1. [环境准备](#环境准备)
2. [数据库表结构](#数据库表结构)
3. [API 接口测试](#api-接口测试)
4. [测试用例](#测试用例)

## 环境准备

### 1. 安装依赖
```bash
cd api
pip install -r requirements.txt
```

### 2. 数据库准备
确保 MySQL 数据库 `webapp` 存在，并创建以下表结构。

### 3. 启动 API 服务
```bash
python run.py
```

服务将在 `http://localhost:5000` 启动。

## 数据库表结构

### users 表
```sql
CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `role` ENUM('user', 'admin') NOT NULL DEFAULT 'user',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### books 表
```sql
CREATE TABLE `books` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `author` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `stock` INT UNSIGNED NOT NULL DEFAULT 0,
  `cover_image_url` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### borrow_records 表
```sql
CREATE TABLE `borrow_records` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `book_id` INT NOT NULL,
  `borrow_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `return_date` TIMESTAMP NULL,
  `status` ENUM('borrowed', 'returned', 'requested') NOT NULL DEFAULT 'requested',
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`book_id`) REFERENCES `books`(`id`)
);
```

## API 接口测试

### 1. 健康检查

**GET** `/api/health`

```bash
curl -X GET http://localhost:5000/api/health
```

**响应示例：**
```json
{
  "success": true,
  "message": "BookNest API 运行正常",
  "version": "1.0.0"
}
```

### 2. 认证接口

#### 用户注册
**POST** `/api/auth/register`

```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "测试用户",
    "email": "test@example.com",
    "password": "123456"
  }'
```

#### 用户登录
**POST** `/api/auth/login`

```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "123456"
  }'
```

### 3. 图书管理接口

#### 获取所有图书
**GET** `/api/books`

```bash
# 获取所有图书
curl -X GET http://localhost:5000/api/books

# 按标题搜索
curl -X GET "http://localhost:5000/api/books?title=Python"

# 按作者搜索
curl -X GET "http://localhost:5000/api/books?author=张三"
```

#### 获取单本图书
**GET** `/api/books/{id}`

```bash
curl -X GET http://localhost:5000/api/books/1
```

#### 添加图书
**POST** `/api/books`

```bash
curl -X POST http://localhost:5000/api/books \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Python 编程",
    "author": "张三",
    "description": "Python 入门教程",
    "stock": 10,
    "cover_image_url": "http://example.com/cover.jpg"
  }'
```

#### 更新图书
**PUT** `/api/books/{id}`

```bash
curl -X PUT http://localhost:5000/api/books/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Python 高级编程",
    "author": "张三",
    "description": "Python 进阶教程",
    "stock": 8
  }'
```

#### 删除图书
**DELETE** `/api/books/{id}`

```bash
curl -X DELETE http://localhost:5000/api/books/1
```

### 4. 借阅管理接口

#### 申请借书
**POST** `/api/borrows`

```bash
curl -X POST http://localhost:5000/api/borrows \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "book_id": 1
  }'
```

#### 获取用户借阅历史
**GET** `/api/borrows/user/{user_id}`

```bash
curl -X GET http://localhost:5000/api/borrows/user/1
```

#### 获取所有借阅记录
**GET** `/api/borrows`

```bash
# 获取所有记录
curl -X GET http://localhost:5000/api/borrows

# 按状态过滤
curl -X GET "http://localhost:5000/api/borrows?status=requested"
```

#### 更新借阅状态
**PUT** `/api/borrows/{record_id}/status`

```bash
# 审批借书申请
curl -X PUT http://localhost:5000/api/borrows/1/status \
  -H "Content-Type: application/json" \
  -d '{"status": "borrowed"}'

# 处理归还
curl -X PUT http://localhost:5000/api/borrows/1/status \
  -H "Content-Type: application/json" \
  -d '{"status": "returned"}'
```

## 测试用例

### 完整流程测试

1. **创建管理员用户**
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "管理员",
    "email": "admin@qq.com",
    "password": "admin",
    "role": "admin"
  }'
```

2. **管理员登录**
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@qq.com",
    "password": "admin"
  }'
```

3. **添加图书**
```bash
curl -X POST http://localhost:5000/api/books \
  -H "Content-Type: application/json" \
  -d '{
    "title": "JavaScript 权威指南",
    "author": "David Flanagan",
    "description": "JavaScript 经典教程",
    "stock": 5
  }'
```

4. **创建普通用户**
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "小明",
    "email": "xiaoming@example.com",
    "password": "123456"
  }'
```

5. **用户申请借书**
```bash
curl -X POST http://localhost:5000/api/borrows \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 2,
    "book_id": 1
  }'
```

6. **管理员审批借书**
```bash
curl -X PUT http://localhost:5000/api/borrows/1/status \
  -H "Content-Type: application/json" \
  -d '{"status": "borrowed"}'
```

7. **查看用户借阅历史**
```bash
curl -X GET http://localhost:5000/api/borrows/user/2
```

### 错误处理测试

1. **测试不存在的接口**
```bash
curl -X GET http://localhost:5000/api/nonexistent
# 应返回 404 错误
```

2. **测试缺少必需字段**
```bash
curl -X POST http://localhost:5000/api/books \
  -H "Content-Type: application/json" \
  -d '{"title": "测试图书"}'
# 应返回 400 错误，提示缺少必需字段
```

3. **测试重复注册**
```bash
# 先注册一个用户
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "测试",
    "email": "duplicate@example.com",
    "password": "123456"
  }'

# 再次注册相同邮箱
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "测试2",
    "email": "duplicate@example.com",
    "password": "123456"
  }'
# 应返回 400 错误，提示邮箱已被注册
```
