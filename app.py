from flask import Flask, render_template, g
from controller.main import main_bp
from controller.customer import customer_bp
from controller.manager import manager_bp

app = Flask(
    __name__,
    template_folder='./views/',
    static_folder = './views/static'
)

app.register_blueprint(main_bp)
app.register_blueprint(customer_bp, url_prefix='/customer')
app.register_blueprint(manager_bp, url_prefix='/manager')

if __name__ == '__main__':
    app.secret_key = ".."
    app.run('0.0.0.0', port=5000, debug=True)
