# Startup Script

from app import create_app

if __name__ == '__main__':
    app = create_app()
    print("=" * 50)
    print("BookNest API service is starting...")
    print("API endpoint: http://localhost:5000")
    print("Health check: http://localhost:5000/api/health")
    print("=" * 50)
    app.run(host='0.0.0.0', port=5000, debug=True)
