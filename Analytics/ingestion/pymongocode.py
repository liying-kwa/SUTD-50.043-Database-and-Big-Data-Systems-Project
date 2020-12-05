import pymongo
import pyrebase


mongo_username = "userdb20"
mongo_password = "passworddb20"

config = {
  "apiKey": "AIzaSyDl_6GZJ-JsdcwVSKDW02qbfIueg04sY0Y",
  "authDomain": "dbproject-f258b.firebaseapp.com",
  "databaseURL": "https://dbproject-f258b.firebaseio.com/",
  "storageBucket": "dbproject-f258b"
}


firebase = pyrebase.initialize_app(config)
db = firebase.database()


#this line for accessing metadata
data = db.child("metadata").get().val()
#to access the logs db, jsut change the "metadata" word to "logs"


print('Waiting for database to be created')
while ((db.child("metadata").get().val())['created'] != 'yes'):
    #busy wait
    pass
print('Database created')


#endpoint of ec2
#it can only be obtained when the ec2 is created
ssh_address = (db.child("metadata").get().val())['endpoint']

#try:
#    client = pymongo.MongoClient("mongodb://"+ ssh_address+":27017")
#    auth = client.admin.authenticate(mongo_username,mongo_password)
#    db = client["myMongodb"]
#
#
#    if(auth):
#        print("MongoDB connection successful")
#        col = db["new_kindle_metadata"].find_one()
#        print(col)
#    else:
#        print("MongoDB authentication failure: Please check the username or password")
#        client.close()
#
#except Exception as e:
#    print("MongoDB connection failure: Please check the connection details")
#    print(e)


with open('/home/hadoop/mongodb-hostname.txt', 'w') as mongofile:
	mongofile.write(ssh_address)
