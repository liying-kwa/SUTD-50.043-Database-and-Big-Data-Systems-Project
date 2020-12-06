
import pyrebase


metadata_endpoint = open("metadata_endpoint.txt", "r").read()
#print('metadata_endpoint is ', metadata_endpoint)

logs_endpoint = open("logs_endpoint.txt", "r").read()
#print('logs_endpoint is ', logs_endpoint)

my_sql_endpoint = open("my_sql_endpoint.txt", "r").read()
#print('my_sql_endpoint is ', my_sql_endpoint)

webapp_endpoint = open("webapp_endpoint.txt", "r").read()
#print('webapp_endpoint is ', webapp_endpoint)


config = {
  "apiKey": "AIzaSyDl_6GZJ-JsdcwVSKDW02qbfIueg04sY0Y",
  "authDomain": "dbproject-f258b.firebaseapp.com",
  "databaseURL": "https://dbproject-f258b.firebaseio.com/",
  "storageBucket": "dbproject-f258b"
}

firebase = pyrebase.initialize_app(config)

db = firebase.database()

data = {'endpoint': (my_sql_endpoint.rstrip()).strip("\"")}
db.child("my_sql").update(data)

data = {'endpoint': (metadata_endpoint.rstrip()).strip("\"")}
db.child("metadata").update(data)

data = {'endpoint': (logs_endpoint.rstrip()).strip("\"")}
db.child("logs").update(data)

data = {'endpoint': (webapp_endpoint.rstrip()).strip("\"")}
db.child("webapp").update(data)

#to_print = db.child("my_sql").get().val()
#print(to_print)
