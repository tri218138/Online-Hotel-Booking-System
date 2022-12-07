from flask import Blueprint, request, render_template, session, redirect, url_for

main_bp = Blueprint('main_bp', __name__)

TOKEN = [] # {"idlogin": "", "username": "", "role": ""}

def defineToken(idlogin):
    for auth in TOKEN:
        if idlogin == auth["idlogin"]:
            return True, auth
    return False, None

@main_bp.before_request
def auth():
    print("before request")
    print(session) # <SecureCookieSession {'idlogin': 'backofficer'}>
    print(request.endpoint) # main_bp.login
    print(request.path) # /login
    if request.endpoint == 'main_bp.login':        
        return 
    if 'idlogin' not in session:
        return redirect('login')
    sign, _ = defineToken(session['idlogin'])
    if not sign:
        return redirect(url_for('main_bp.login'))

@main_bp.route('/', methods=['GET', 'POST'])
@main_bp.route('/home', methods=['GET', 'POST'])
# @login_required
def home():
    header = render_template('component/header.html')
    content = render_template('layout/container.html', header=header)
    return render_template('index.html', content=content)

@main_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == "POST":
        data = request.form.to_dict()
        if "customer" in data["username"] and "customer" in data["password"]:
            session["idlogin"] = data["username"]
            TOKEN.append({"idlogin": data["username"], "username" : data["username"], "role": "customer"})
            return redirect(url_for('customer_bp.home'))
        elif "manager" in data["username"] and "manager" in data["password"]:
            session["idlogin"] = data["username"]
            TOKEN.append({"idlogin": data["username"], "username" : data["username"], "role": "manager"})
            return redirect(url_for('manager_bp.home'))
        elif "designer" in data["username"] and "designer" in data["password"]:
            session["idlogin"] = data["username"]
            TOKEN.append({"idlogin": data["username"], "username" : data["username"], "role": "designer"})
            return redirect(url_for('designer_bp.home'))
        elif "supplier" in data["username"] and "supplier" in data["password"]:
            session["idlogin"] = data["username"]
            TOKEN.append({"idlogin": data["username"], "username" : data["username"], "role": "supplier"})
            return redirect(url_for('supplier_bp.home'))
    elif request.method == 'GET':
        pass
    loginPage = render_template('pages/login.html')
    return render_template('index.html', content=loginPage)

@main_bp.route('/setting', methods=['GET', 'POST'])
def setting():
    pass

@main_bp.route('/logout')
def logout():
    print('session clear')
    session.clear()
    return redirect(url_for('main_bp.home'))

@main_bp.errorhandler(404)
def page_not_found(e):
    # print('main_bp')
    return render_template('error/404.html'), 404

@main_bp.app_errorhandler(404)
def page_not_found(e):
    # print('app')
    # print(request.path)
    # print(TOKEN)
    # print(session["idlogin"])
    err = render_template('error/404.html')
    return render_template('index.html', content=err)