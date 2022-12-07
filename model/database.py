Database = {
    "city": [
        {"id" : '0', "name": "Vũng Tàu", "description": "aassa"},
        {"id" : '1', "name": "Đà Lạt", "description": "aassa"},
        {"id" : '2', "name": "Nha Trang", "description": "aassa"},
        {"id" : '3', "name": "Phú Quốc", "description": "aassa"}
    ],

    "authentication": [
        { "username": "smithdavid", "password": "admin" },
        { "username": "admin", "password": "admin" },
        { "username": "admin", "password": "admin" },
        { "username": "admin", "password": "admin" },
        { "username": "admin", "password": "admin" }
    ],

    "customer" : [
        {"username": "customer0", "name": "Nguyễn Trọng Khánh", "phone": "091323134", "email": "khanh@gmail.com", "age": 14, "address":""},
        {"username": "manager0", "name": "Lương Thế Vĩnh", "phone": "091323134", "email": "vinh@gmail.com", "age": 22, "address":"Long Xuyên"}
    ],

    "hotel" : [
        {"id": '0', "name": "Citadines Bayfront", "rank" : 5, "price": 1632958, "city_id": '2',
        "address" : "62 Trần Phú, Phường Lộc Thọ, Lộc Thọ, Nha Trang, Khánh Hòa, Việt Nam",
        "urlImageId": "12ErGeQbcynlEMSYmZLsuD2larYZb7-_X"},
        {"id": '1', "name": "Virgo Hotel", "rank" : 5, "price": 1000000, "city_id": '1',
        "address" : "62 Trần Phú, Phường Lộc Thọ, Lộc Thọ, Nha Trang, Khánh Hòa, Việt Nam",
        "urlImageId": "1lwEa6NwurxPFaOy5MUcEXqrMIv0I2-O0"},
        {"id": '2', "name": "Mường Thanh Luxury", "rank" : 5, "price": 1632958, "city_id": '2',
        "address" : "62 Trần Phú, Phường Lộc Thọ, Lộc Thọ, Nha Trang, Khánh Hòa, Việt Nam",
        "urlImageId": "173okLB1DJHIDra_DisuaB-7fpBrDoqyT"},
        {"id": '3', "name": "Boton Blue Hotel & Spa", "rank" : 5, "price": 1000000, "city_id": '0',
        "address" : "62 Trần Phú, Phường Lộc Thọ, Lộc Thọ, Nha Trang, Khánh Hòa, Việt Nam",
        "urlImageId": "15jX1xXlCnIOmpNOQIlKvzUz7WUQQj051"}
    ],

    "booking" : [
        {"id" : "0", "time": "", "username": "smithdavid0301", "hotel_id": "0", "email": "thai@gmail.com", "name": "Thái", "phone": "09130313", 'child' : '1', "adult" : '2', "datestart" : "", "dateend": "", "cost": 2100000, "method": ""},
        {"id" : "1", "time": "05/12/2022-12:12", "username": "customer0", "hotel_id": "0", "email": "thai@gmail.com", "name": "Thái", "phone": "09130313", 'child' : '1', "adult" : '2', "datestart" : "05/12/2022", "dateend": "06/12/2022", "cost": 2100000, "method": "Tiền mặt"},
        {"id" : "2", "time": "07/12/2022-13:29", "username": "customer0", "hotel_id": "1", "email": "thai@gmail.com", "name": "Thái", "phone": "09130313", 'child' : '1', "adult" : '2', "datestart" : "", "dateend": "", "cost": 2100000, "method": "Tiền mặt"},
    ]
}