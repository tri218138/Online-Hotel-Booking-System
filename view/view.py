from flask import render_template, jsonify, get_template_attribute, url_for

class View():
    def __init__(self):
        self.role = ''
    def setRole(self, role_):
        self.role = role_
        self.setHeader(self.role)
        # self.setNavBar(self.role)
    def setHeader(self, role_):
        self.headerHTML = render_template('components/header.html', role=role_)
    def setNavBar(self):
        self.navBarHTML = render_template('components/navbar.html')
    def setSideBar(self):
        self.sideBarHTML = render_template('components/sidebar.html')        
    
    def render_template_home(self, data):
        return render_template('index.html', header=self.headerHTML)
    def render_template_signin(self, data):
        signin = render_template('pages/signin.html', check=data["check"])
        return render_template('index.html', signin=signin)
    def render_template_model(self, data_):
        self.modelGallery = render_template('pages/model.html', data=data_)
        return render_template('index.html', header=self.headerHTML, gallery=self.modelGallery)
    def render_template_order(self, data):
        pass
    def render_template(self, template, data=None):
        if template == '/':
            return self.render_template_home(data)
        elif template == 'signin':
            return self.render_template_signin(data)
        elif template == 'model':
            return self.render_template_model(data)
        elif template == 'order':
            return self.render_template_order(data)

view = View()