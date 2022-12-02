import pymysql.cursors
import json
import itertools

from model.database import *

class DBMS:
    def __init__(self):
        # self.Database = pymysql.connect(
        #     host="localhost",
        #     user="root",
        #     password="280818",
        #     database="onlinebookinghotel",
        #     cursorclass=pymysql.cursors.DictCursor
        # )
        # self.Cursor = self.Database.cursor()
        self.role = ''
        pass
    def setRole(self, role):
        self.role = role
    def checkLogin(self, un, ps):
        if un == 'admin' and ps == 'admin':
            return True, '101', 'admin'
        else:
            return True, '102', 'user'
    def selectFromTable(self, tableName, attributes):
        data = [
            {'model_urlImage': '12ErGeQbcynlEMSYmZLsuD2larYZb7-_X', 'model_name' : 'Hòn Ngọc Biển'},
            {'model_urlImage': '1lwEa6NwurxPFaOy5MUcEXqrMIv0I2-O0', 'model_name' : 'Hồng Ngọc'},
            {'model_urlImage': '173okLB1DJHIDra_DisuaB-7fpBrDoqyT', 'model_name' : 'Sóng xanh'},
            {'model_urlImage': '15jX1xXlCnIOmpNOQIlKvzUz7WUQQj051', 'model_name' : 'Biển'},
        ]
        return data
dbms = DBMS()