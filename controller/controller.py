from flask import Flask, render_template, request, jsonify, get_template_attribute, make_response, redirect, url_for
from app import app
from controller.person import person
from model.dbms import dbms
from view.view import view

@app.route('/', methods=['GET','POST'])
def home():
    if not person.defined():
        return redirect("/signin", code=302)
    if person.getRole() == 'admin':
        return view.render_template('/')
    elif person.getRole() == 'user':
        return view.render_template('/')

@app.route('/signin', methods=['GET','POST'])
def signin():
    if not person.defined():
        if request.method == 'POST':
            un = request.form['username']
            ps = request.form['password']
            res, personId, role = dbms.checkLogin(un, ps)
            if res:
                person.definePerson(personId, role)
                view.setRole(role)
                dbms.setRole(role)
                return redirect('/', code=302)
            else:
                print('failure')
                return view.render_template('signin', {'check':False})
        else:
            return view.render_template('signin', {'check':True})
    else:
        return redirect("/", code=302)

@app.route('/model', methods=['GET','POST'])
def model():
    if not person.defined():
        return redirect("/signin", code=302)
    if person.getRole() == 'admin':
        #data = dbms.getHotelGallery()
        # view.setHotelGallery()
        pass
    elif person.getRole() == 'user':
        data = dbms.selectFromTable('hotel', ['model_urlImage','model_name','model_description'])
    return view.render_template('model', data)

@app.route('/build', methods=['GET','POST'])
def build():
    if not person.defined():
        return redirect("/signin", code=302)
    if request.method == "POST":
        form = request.form.to_dict()
        form = json.dumps(form)
        dbms.Cursor.execute(f"INSERT INTO onlinebookingcar.orderList (components) VALUES ('{form}')")
        dbms.Database.commit()
        return redirect("/build", code=302)
    if request.method == "GET":
        navBarBuild = render_template('build/navbar.html')
        demo = '''
            <img id="demo-img-car" src="http://drive.google.com/uc?export=view&id=1Z2gn9zjGLk599lp8QKKiP4gO1Q724uI8"
                class="w-100 shadow-1-strong rounded mb-4" alt="Boat on Calm Water" />
        '''
        data = {}
        data["design"] = dbms.selectTable('component', ['id','component_name','component_description','urlImage'], {'component_type' : 'design'})
        # dbms.Cursor.execute("SELECT id,component_name,component_description,urlImage FROM onlinebookingcar.component WHERE component_type = 'design'")
        # data["design"] = dbms.Cursor.fetchall()
        dbms.Cursor.execute("SELECT id,component_name,component_description,urlImage FROM onlinebookingcar.component WHERE component_type = 'interior'")
        data["interior"] = dbms.Cursor.fetchall()
        tmp = render_template('/build/sidebar.html', data=data)
        return render_template('index.html', header=templates.headerHTML, content=demo, navBarBuild = navBarBuild, sidebar=tmp)

@app.route('/order', methods=['GET', 'POST'])
def orderPage():
    if not person.defined():
        return redirect("/signin", code=302)
    # ##############################
    if person.getRole() == 'admin':
        if request.method == "POST":
            form = request.form.to_dict()
            dbms.Cursor.execute(f"DELETE FROM onlinebookingcar.orderList WHERE orderID = '{form['orderID']}'")
            dbms.Database.commit()
            print(form)

        dbms.Cursor.execute("SELECT * FROM orderList")
        dataList = dbms.Cursor.fetchall()
        for rec in dataList:
            rec["components"] = json.loads(rec["components"])
            for field in ["design", "exterior", "interior"]:
                if field in rec["components"]:
                    rec[field] = rec["components"][field]

        # dataOrderList = [{
        #     'orderID': 'SOFA1XQ',
        #     'userId': 'user0',
        #     'design': 'design1',
        #     'exterior' : 'exterior2',
        #     'interior' : 'interior1',
        #     'orderTime' : '15/12/2022'
        # }]
        templates.setOrderHTML(dataList)
        return render_template('index.html', header=templates.headerHTML, order = templates.orderHTML)
    else:
        dataOrderList = [{
            'orderID': 'SOFA1XQ',
            'design': 'design1',
            'exterior' : 'exterior2',
            'interior' : 'interior1',
            'orderTime' : '15/12/2022'
        }]
        templates.setOrderHTML(dataOrderList)
        return render_template('index.html', header=templates.headerHTML, order = templates.orderHTML)

@app.route('/logout', methods=['GET'])
def logout():
    if not person.defined():
        return redirect("/signin", code=302)
    else:
        person.quit()
        return redirect('/', 302)


@app.errorhandler(404)
def page_not_found(e):
    return redirect('/', 302)

