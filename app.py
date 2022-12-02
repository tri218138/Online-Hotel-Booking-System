from flask import Flask

app = Flask(__name__, template_folder='view/templates')

# from controller.person import person
from controller.controller import *

if __name__ == "__main__":
    app.run(debug=True, use_reloader=False)