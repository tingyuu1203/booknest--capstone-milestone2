# MySQL Database Connection Utility

import pymysql
from config import Config

class Database:
    def __init__(self):
        self.host = Config.MYSQL_HOST
        self.port = Config.MYSQL_PORT
        self.user = Config.MYSQL_USER
        self.password = Config.MYSQL_PASSWORD
        self.database = Config.MYSQL_DATABASE
        
    def get_connection(self):
        """Establish and return a database connection"""
        try:
            connection = pymysql.connect(
                host=self.host,
                port=self.port,
                user=self.user,
                password=self.password,
                database=self.database,
                charset='utf8mb4',
                cursorclass=pymysql.cursors.DictCursor
            )
            return connection
        except Exception as e:
            print(f"Database connection failed: {e}")
            return None
    
    def execute_query(self, query, params=None):
        """Execute a SELECT query"""
        connection = self.get_connection()
        if not connection:
            return None
            
        try:
            with connection.cursor() as cursor:
                cursor.execute(query, params)
                result = cursor.fetchall()
                return result
        except Exception as e:
            print(f"Query execution failed: {e}")
            return None
        finally:
            connection.close()
    
    def execute_update(self, query, params=None):
        """Execute an INSERT, UPDATE, or DELETE statement"""
        connection = self.get_connection()
        if not connection:
            return False
            
        try:
            with connection.cursor() as cursor:
                cursor.execute(query, params)
                connection.commit()
                return cursor.rowcount
        except Exception as e:
            print(f"Update execution failed: {e}")
            connection.rollback()
            return False
        finally:
            connection.close()

# Global database instance
db = Database()
