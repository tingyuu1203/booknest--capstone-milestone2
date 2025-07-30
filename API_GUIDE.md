
# BookNest API Testing Document

## Table of Contents
1. [Environment Preparation](#Environment Preparation)
2. [Database Table Structure](#Database Table Structure)
3. [API Interface Testing](#api-Interface Testing)
4. [Test Cases](#Test Cases)

## Environment Preparation

### 1. Install Dependencies
bash
cd api
pip install -r requirements.txt

### 2. Database Preparation
Ensure the MySQL database webapp exists and create the following table structure.


### 3. Start the API server
```bash
python run.py
```

The server will start at `http://localhost:5000`.

## Database table structure

### users table
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

### books table
```sql
CREATE TABLE `books` ( 
`id` INT AUTO_INCREMENT PRIMARY KEY, 
`title` VARCHAR(255) NOT NULL, 
`author` VARCHAR(255) NOT NULL, 
`description` TEXT, `stock` INT UNSIGNED NOT NULL DEFAULT 0, 
`cover_image_url` VARCHAR(255), 
`created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
`updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### borrow_records table
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

## API Test

### 1. Health Check

**GET** `/api/health`

```bash
curl -X GET http://localhost:5000/api/health
```

**Response Example:**
```json
{
"success": true,
"message": "BookNest API is running normally",
"version": "1.0.0"
}
```

### 2. Authentication API

#### User Registration
**POST** `/api/auth/register`

```bash
curl -X POST http://localhost:5000/api/auth/register \
-H "Content-Type: application/json" \
-d '{
"username": "Test User",
"email": "test@example.com",
"password": "123456"
}'
```

#### User Login
**POST** `/api/auth/login`

```bash
curl -X POST http://localhost:5000/api/auth/login \
-H "Content-Type: application/json" \
-d '{
"email": "test@example.com",
"password": "123456"
}'
```

### 3. Book Management Interface

#### Get All Books
**GET** `/api/books`

```bash
# Get All Books
curl -X GET http://localhost:5000/api/books

# Search by Title
curl -X GET "http://localhost:5000/api/books?title=Python"

# Search by Author
curl -X GET "http://localhost:5000/api/books?author=张三"
```

#### Get a single book
**GET** `/api/books/{id}`

```bash
curl -X GET http://localhost:5000/api/books/1
```

#### Add a book
**POST** `/api/books`

```bash
curl -X POST http://localhost:5000/api/books \
-H "Content-Type: application/json" \
-d '{
"title": "Python Programming",
"author": "Zhang San",
"description": "Python Getting Started Tutorial",
"stock": 10,
"cover_image_url": "http://example.com/cover.jpg"
}'
```

#### Update a book
**PUT** `/api/books/{id}`

```bash
curl -X PUT http://localhost:5000/api/books/1 \
-H "Content-Type: application/json" \
-d '{
"title": "Advanced Python Programming",
"author": "Zhang San",
"description": "Advanced Python Tutorial",
"stock": 8
}'
```

#### Deleting a Book
**DELETE** `/api/books/{id}`

```bash
curl -X DELETE http://localhost:5000/api/books/1
```

### 4. Borrowing Management Interface

#### Applying for Borrowing a Book
**POST** `/api/borrows`

```bash
curl -X POST http://localhost:5000/api/borrows \
-H "Content-Type: application/json" \
-d '{
"user_id": 1,
"book_id": 1
}'
```

#### Retrieving a User's Borrowing History
**GET** `/api/borrows/user/{user_id}`

```bash
curl -X GET http://localhost:5000/api/borrows/user/1
```

#### Get all borrowing records
**GET** `/api/borrows`

```bash
# Get all records
curl -X GET http://localhost:5000/api/borrows

# Filter by status
curl -X GET "http://localhost:5000/api/borrows?status=requested"
```

#### Update borrowing status
**PUT** `/api/borrows/{record_id}/status`

```bash
# Approve borrowing request
curl -X PUT http://localhost:5000/api/borrows/1/status \
-H "Content-Type: application/json" \
-d '{"status": "borrowed"}'

# Handle the return
curl -X PUT http://localhost:5000/api/borrows/1/status \
-H "Content-Type: application/json" \
-d '{"status": "returned"}'
```

## Test Case

### Complete Process Test

1. **Creating an Admin User**
```bash
curl -X POST http://localhost:5000/api/auth/register \
-H "Content-Type: application/json" \
-d '{
"username": "Admin",
"email": "admin@qq.com",
"password": "admin",
"role": "admin"
}'
```

2. **Admin Login**
```bash
curl -X POST http://localhost:5000/api/auth/login \
-H "Content-Type: application/json" \
-d '{
"email": "admin@qq.com",
"password": "admin"
}'
```

3. **Add Books**
```bash
curl -X POST http://localhost:5000/api/books \
-H "Content-Type: application/json" \
-d '{
"title": "JavaScript: The Definitive Guide",
"author": "David Flanagan",
"description": "JavaScript: A Classic Tutorial",
"stock": 5
}'
```

4. **Create a Normal User**
```bash
curl -X POST http://localhost:5000/api/auth/register \
-H "Content-Type: application/json" \
-d '{
"username": "Xiaoming",
"email": "xiaoming@example.com",
"password": "123456"
}'
```

5. **User applies for borrowing a book**
```bash
curl -X POST http://localhost:5000/api/borrows \
-H "Content-Type: application/json" \
-d '{
"user_id": 2,
"book_id": 1
}'
```

6. **Administrator approves borrowing a book**
```bash
curl -X PUT http://localhost:5000/api/borrows/1/status \
-H "Content-Type: application/json" \
-d '{"status": "borrowed"}'
```

7. **View user borrowing history**
```bash
curl -X GET http://localhost:5000/api/borrows/user/2
```
### Error Handling Test

1. **Testing for a Non-Existent API**
```bash
curl -X GET http://localhost:5000/api/nonexistent
# Should return a 404 error
```

2. **Testing for Missing Required Fields**
```bash
curl -X POST http://localhost:5000/api/books \
-H "Content-Type: application/json" \
-d '{"title": "Test Books"}'
# Should return a 400 error indicating a missing required field
```

3. **Testing for Duplicate Registration**
```bash
# Register a user first
curl -X POST http://localhost:5000/api/auth/register \
-H "Content-Type: application/json" \
-d '{
"username": "test",
"email": "duplicate@example.com",
"password": "123456"
}'

# Register the same email address again
curl -X POST http://localhost:5000/api/auth/register \
-H "Content-Type: application/json" \
-d '{
"username": "Test2",
"email": "duplicate@example.com",
"password": "123456"
}'
# Should return a 400 error, indicating that the email address has already been registered.
```