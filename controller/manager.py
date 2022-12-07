from flask import Blueprint, request, render_template, session, redirect, url_for
from model.dbms import dbms
from controller.main import TOKEN, defineToken

manager_bp = Blueprint('manager_bp', __name__, template_folder="./views")

@manager_bp.before_request
def auth():
    if request.endpoint == 'main_bp.login':
        return
    if 'idlogin' not in session:
        return redirect(url_for('main_bp.login'))
    global auth
    sign, auth = defineToken(session["idlogin"])
    if not sign:
        return redirect(url_for('main_bp.login'))
    

@manager_bp.route('/', methods=['GET', 'POST'])
@manager_bp.route('/home', methods=['GET', 'POST'])
# @login_required
def home():
    header = render_template('components/header.html')
    footer = render_template('components/footer.html')
    container = render_template('pages/home.html')
    content = render_template('layout/container.html', header=header, container=container, footer=footer)
    return render_template('index.html', content=content)

@manager_bp.route('/hotel', methods=['GET','POST'])
def hotel():
    data = {}
    data["hotel"] = dbms.selectDataModel()
    data["city"] = dbms.selectDataCity()
    # print(data)
    header = render_template('components/header.html')
    footer = render_template('components/footer.html')
    container = render_template('pages/hotel.html', data=data)
    content = render_template('layout/container.html', header=header, container=container, footer=footer)
    return render_template('index.html', content=content)

@manager_bp.route('/hotel/search', methods=['GET','POST'])
def hotelSearch():
    container = None
    if request.method == "GET":
        req = request.args.to_dict()
        if "city" in req:
            data = {}
            data["hotel"] = dbms.selectDataHotelInCity(req["city"])
            data["city"] = dbms.selectDataCity()
            container = render_template('pages/hotel.html', data=data)
    header = render_template('components/header.html')
    content = render_template('layout/container.html', header=header, container=container)
    return render_template('index.html', content=content)

@manager_bp.route('/hotel/detail', methods=['GET','POST'])
def hotelDetail():
    header = render_template('components/header.html')
    footer = render_template('components/footer.html')
    if request.method == "GET":
        req = request.args.to_dict()
        if "mode" in req and "hotel_id" in req:
            if req["mode"] == "edit":
                data = dbms.selectHotelById(req["hotel_id"])
                container = render_template('pages/detail.html', data=data, mode="edit")
                content = render_template('layout/container.html', header=header, container=container, footer=footer)
                return render_template('index.html', content=content)
        if "id" in req:
            print('select hotel id', req["id"])
            data = dbms.selectHotelById(req["id"])
            container = render_template('pages/detail.html', data=data)
            content = render_template('layout/container.html', header=header, container=container, footer=footer)
            return render_template('index.html', content=content)
    print("request.path", request.path)
    if request.method == "POST":
        req = request.form.to_dict()
        if req["request"] == "save":
            data = req
            data["price"] = int(float(data["price"]))
            dbms.saveHotelDetail(req["hotel_id"], data=data)
            return redirect(f'{request.path}?id={data["hotel_id"]}')
        elif req["request"] == "cancel":
            data = req
            return redirect(f'{request.path}?id={data["hotel_id"]}')

    return redirect(url_for('manager_bp.hotel'))


@manager_bp.route('/hotel/booking', methods=['GET', 'POST'])
def hotelBooking():
    container = None
    if request.method == "GET":
        req = request.args.to_dict()
        if "id" in req: #hotel id
            data = {}
            data["hotel"] = dbms.selectHotelById(req["id"])
            container = render_template('pages/booking.html', data=data)
        elif "fill" in req: 
            print(req)
            # confirm booking
    elif request.method == "POST":
        req = request.form
        if "fill" in req:
            data = {}
            data["user_id"] = "user0"
            data["form"] = req
            data["time"] = "03/12/2022-22:34"
            dbms.storeBooking(req)
            return redirect('/hotel', code=302)
    header = render_template('components/header.html')
    content = render_template('layout/container.html', header=header, container=container if container is not None else "")
    return render_template('index.html', content=content)

@manager_bp.route('/mybooking', methods=['GET','POST'])
def mybooking():
    container = None
    if request.method == 'GET':
        data = {}
        data["mybooking"] = dbms.selectBusinessBooking()
        for b in data["mybooking"]:
            b["hotel_name"] = dbms.selectHotelById(b["hotel_id"])["name"]
        container = render_template('pages/mybooking.html', data=data)
    header = render_template('components/header.html')
    content = render_template('layout/container.html', header=header, container=container if container is not None else "")
    return render_template('index.html', content=content) 


@manager_bp.route('/profile', methods=['GET','POST'])
def personalInfomation():
    header = render_template('components/header.html')
    data = dbms.selectUserProfile(auth["username"])
    container = render_template('pages/profile.html', data=data)
    if request.method == "GET":
        req = request.args.to_dict()
        if "mode" in req:
            if req["mode"] == "edit":
                container = render_template('pages/profile.html', data=data, mode="edit")
    
    elif request.method == "POST":
        req = request.form.to_dict()
        if req["request"] == "save":
            dbms.saveUserName(auth["username"], data=req)
            return redirect(url_for("manager_bp.personalInfomation"))
        elif req["request"] == "cancel":
            return redirect(url_for("manager_bp.personalInfomation"))
    content = render_template('layout/container.html', header=header, container=container if container is not None else "")
    return render_template('index.html', content=content)  


@manager_bp.errorhandler(404)
def page_not_found(e):
    return redirect(url_for('manager_bp.home'))
