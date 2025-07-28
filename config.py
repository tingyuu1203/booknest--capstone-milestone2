class Config:
    # Localhost for MySQL on your own Mac
    MYSQL_HOST = '127.0.0.1'
    MYSQL_PORT = 3306
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = 'Cd731203'
    MYSQL_DATABASE = 'webapp'

    SECRET_KEY = 'booknest-secret-key'
    DEBUG = True
    CORS_ORIGINS = ['*', 'http://127.0.0.1:8000']
