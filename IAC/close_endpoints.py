import pyrebase


config = {
  "apiKey": "AIzaSyDl_6GZJ-JsdcwVSKDW02qbfIueg04sY0Y",
  "authDomain": "dbproject-f258b.firebaseapp.com",
  "databaseURL": "https://dbproject-f258b.firebaseio.com/",
  "storageBucket": "dbproject-f258b"
}

firebase = pyrebase.initialize_app(config)

db = firebase.database()

data = {'endpoint': 0, 'created':'destroyed'}
db.child("my_sql").update(data)

data = {'endpoint': 0, 'created':'destroyed'}
db.child("metadata").update(data)

data = {'endpoint': 0, 'created':'destroyed'}
db.child("logs").update(data)

data = {'endpoint': 0, 'created':'destroyed'}
db.child("webapp").update(data)