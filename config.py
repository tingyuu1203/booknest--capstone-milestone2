class Config:
    # MySQL 配置
    MYSQL_HOST = '127.0.0.1'
    MYSQL_PORT = 3306
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = 'gu681004' #按照自己的SQL密码来！！！
    MYSQL_DATABASE = 'webapp'

    SECRET_KEY = 'booknest-secret-key'  # 你现有的秘钥（用于 Flask session）

    # JWT 需要的密钥，随机生成一个足够复杂的
    JWT_SECRET_KEY = 'z5M#8uXw&2r@P!qN7vLsY^fBkJ9eRdT0'

    DEBUG = True

    # 只允许你当前前端地址跨域访问后端
    CORS_ORIGINS = [
        'http://127.0.0.1:5500'
    ]

