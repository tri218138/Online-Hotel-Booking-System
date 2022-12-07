import pymysql.cursors
import json
import itertools
import pandas as pd
from model.database import Database


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
        pass
    def selectDataModel(self):
        # self.Cursor.execute(f"SELECT id,name,description \
        #                     FROM onlinebookinghotel.city")
        # return self.Cursor.fetchall()
        return Database["hotel"]
    def selectDataCity(self):
        return Database["city"]
    def selectDataHotelInCity(self, cityid):
        data = []
        for h in Database["hotel"]:
            # print(h['city_id'], cityid)
            if h["city_id"] == cityid:
                data.append(h)
        return data
    def selectHotelById(self, hotelid):
        for h in Database["hotel"]:
            # print(h['city_id'], cityid)
            if h["id"] == hotelid:
                return h
    def storeBooking(self, order):
        print(order)
        Database["booking"].append(order)
    def selectBusinessBooking(self):
        return Database["booking"]
    def selectUserBooking(self, username):
        ret = []
        for b in Database["booking"]:
            if b["username"] == username:
                ret.append(b)
        return ret
    def selectUserProfile(self, username):
        for c in Database["customer"]:
            if c["username"] == username:
                return c
    def saveUserName(self, username, data):
        for c in Database["customer"]:
            if c["username"] == username:
                for key in c:
                    if key in data:
                        c[key] = data[key]
                break
    def saveHotelDetail(self, hotelid, data):
        for c in Database["hotel"]:
            if c["id"] == hotelid:
                for key in c:
                    if key in data:
                        c[key] = data[key]
                break
    
dbms = DBMS()