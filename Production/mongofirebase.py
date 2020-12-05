import pyrebase
import pymongo

def get_ssh_address(name):
    config = {
    "apiKey": "AIzaSyDl_6GZJ-JsdcwVSKDW02qbfIueg04sY0Y",
    "authDomain": "dbproject-f258b.firebaseapp.com",
    "databaseURL": "https://dbproject-f258b.firebaseio.com/",
    "storageBucket": "dbproject-f258b"
    }

    firebase = pyrebase.initialize_app(config)
    db = firebase.database()

    data = db.child(name).get().val()

    print('Waiting for database to be created')
    while ((db.child(name).get().val())['created'] != 'yes'):
        pass
    print('Database created')

    ssh_address = (db.child(name).get().val())['endpoint']
    return ssh_address