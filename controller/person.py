class Person:
    def __init__(self):
        self.personID = ''
        self.role = ''
    def getID(self):
        return self.personID
    def getRole(self):
        return self.role
    def defined(self):
        if self.personID != '':
            return True
        else:
            return False
    def definePerson(self, personID_, role_):
        self.personID = personID_
        self.role = role_
    def quit(self):
        self.personID = ''
        self.role = ''

person = Person()