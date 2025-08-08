from flask import Flask,request,jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from config import Config
from models import User

# 导入蓝图
from routes.auth import auth_bp
from routes.books import books_bp
from routes.borrows import borrows_bp

def create_app():
    app = Flask(__name__)

    # 载入配置
    app.config.from_object(Config)

    # 初始化 JWT 管理器
    jwt = JWTManager(app)

    # 允许跨域访问，只允许你的前端地址
    CORS(app, origins=Config.CORS_ORIGINS)

    # 注册蓝图
    app.register_blueprint(auth_bp)
    app.register_blueprint(books_bp)
    app.register_blueprint(borrows_bp)

    @app.route('/api/health', methods=['GET'])
    def health_check():
        return {
            'success': True,
            'message': 'BookNest API is running properly',
            'version': '1.0.0'
        }

    @app.errorhandler(404)
    def not_found(error):
        return {
            'success': False,
            'message': 'API endpoint not found'
        }, 404

    @app.errorhandler(500)
    def internal_error(error):
        return {
            'success': False,
            'message': 'Internal server error'
        }, 500

    @app.route('/api/users', methods=['GET'])
    def search_users():
        query = request.args.get('query', '').strip()
        if not query:
            return jsonify(success=False, message="Query parameter required"), 400

        results = User.search(query)

        users = [{"id": r['id'], "username": r['username'], "email": r['email']} for r in results]

        return jsonify(success=True, data=users)
    
    return app

if __name__ == '__main__':
    app = create_app()

    print('\nAvailable routes:')
    for rule in app.url_map.iter_rules():
        print(f"{rule.methods} -> {rule}")

    app.run(host='0.0.0.0', port=5000, debug=True)
