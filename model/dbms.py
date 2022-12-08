import pymysql.cursors
import json
import itertools
import pandas as pd
from model.database import Database
from datetime import datetime

class DBMS:
    def __init__(self):
        self.mysql = pymysql.connect(
            host="localhost",
            user="root",
            password="280818",
            database="hotelbooking",
            cursorclass=pymysql.cursors.DictCursor
        )
        self.Cursor = self.mysql.cursor()
        self.Database = {
            "hotel": self.getDatabaseHotel(),
            "city" : self.getDatabaseCity(),
            "customer": self.getDatabaseCustomer(),
            "booking": []
        }
    def storeUpdateDatabase(self):
        # hotel = self.Database["hotel"]
        # self.Cursor.execute(f"UPDATE hotelbooking.hotel\
        #                     SET price = {hotel['price']} \
        #                     WHERE id = '{hotel['id']}'")
        self.Database.commit()
        pass

    def getDatabaseHotel(self):
        self.Cursor.execute(f"SELECT distinct `id`, `name`, `desc` as `description`, `address`, `rating` as `rank`, `city_id`, `urlImageId` \
                            FROM hotelbooking.hotels;")
        hotels = self.Cursor.fetchall()

        self.Cursor.execute(f"SELECT h.id as id, ROUND(avg(r.price),0) `price`\
                            FROM hotelbooking.hotels as h, hotelbooking.rooms as r\
                            WHERE h.id = r.hotel_id\
                            GROUP BY r.hotel_id;")
        prices = self.Cursor.fetchall()
        for h in hotels:
            for p in prices:
                if p["id"] == h["id"]:
                    h["price"] = int(p["price"])
        # print(hotels)
        return hotels    
    def getDatabaseCity(self):
        self.Cursor.execute("SELECT * FROM hotelbooking.city")
        city = self.Cursor.fetchall()
        for c in city:
            c['id'] = c['city_id']
        return city
    def getDatabaseCustomer(self):
        self.Cursor.execute("SELECT * FROM hotelbooking.users")
        customers = self.Cursor.fetchall()

        self.Cursor.execute("SELECT * FROM hotelbooking.login")
        login = self.Cursor.fetchall()
        for c in customers:
            c["name"] = c["first_name"] + ' ' + c['last_name']
            c["phone"] = c["phone_number"]
            c["address"] = ""
            for l in login:
                if l["id"] == c["id"]:
                    c["username"] = l["username"]
        return customers
    def selectDataModel(self):        
        return self.Database["hotel"]
    def selectDataCity(self):
        return self.Database["city"]
    def selectDataHotelInCity(self, cityid):
        data = []
        for h in self.Database["hotel"]:
            # print(h['city_id'], cityid)
            if h["city_id"] == cityid:
                data.append(h)
        return data
    def selectHotelById(self, hotelid):
        for h in self.Database["hotel"]:
            # print(h['city_id'], cityid)
            if h["id"] == hotelid:
                return h
    def storeBooking(self, order):
        order["time"] = datetime.today().strftime('%Y-%m-%d %H:%M:%S')
        # print(order)
        self.Database["booking"].append(order)
    def selectBusinessBooking(self):
        return self.Database["booking"]
    def selectUserBooking(self, username):
        ret = []
        for b in self.Database["booking"]:
            if b["username"] == username:
                ret.append(b)
        return ret
    def selectUserProfile(self, username):
        for c in self.Database["customer"]:
            if c["username"] == username:
                return c
    def saveUserName(self, username, data):
        for c in self.Database["customer"]:
            if c["username"] == username:
                for key in c:
                    if key in data:
                        c[key] = data[key]
                break
    def saveHotelDetail(self, hotelid, data):
        for c in self.Database["hotel"]:
            if c["id"] == hotelid:
                for key in c:
                    if key in data:
                        c[key] = data[key]
                break
    
dbms = DBMS()