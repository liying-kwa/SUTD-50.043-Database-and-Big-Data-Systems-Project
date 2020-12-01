import pymongo
import pyrebase


mongo_username = "user"
mongo_password = "password"

config = {
  "apiKey": "AIzaSyDl_6GZJ-JsdcwVSKDW02qbfIueg04sY0Y",
  "authDomain": "dbproject-f258b.firebaseapp.com",
  "databaseURL": "https://dbproject-f258b.firebaseio.com/",
  "storageBucket": "dbproject-f258b"
}

firebase = pyrebase.initialize_app(config)

db = firebase.database()

data = db.child("logs").get().val()
#print(data['created'])

print('Waiting for database to be created')
while ((db.child("logs").get().val())['created'] != 'yes'):
    #busy wait
    pass
print('Database created')

#endpoint of ec2
#it can only be obtained when the ec2 is created
ssh_address = (db.child("logs").get().val())['endpoint']

print(ssh_address)

try:
    client = pymongo.MongoClient("mongodb://"+ ssh_address+":27017")
    auth = client.admin.authenticate(mongo_username,mongo_password)
    db = client["myMongodb"]
    
    #myclient = pymongo.MongoClient("mongodb://"+ ssh_address+":27017")

    #mydb = myclient["mydatabase"]


    if(auth):
        print("MongoDB connection successful")
        
        logs_collection = db["logs_collection"]
        result=logs_collection.insert_one({"user" : "Joe", "date" : "10/12/20", "time" : "1500"})
        #col = db["meta_Kindle_Store"].find_one()
        #col = db["new_kindle_metadata"].find_one({ 'asin': 'B00I6N664W' })
        #print(col)
        #print(db.collection_names())
    else:
        print("MongoDB authentication failure: Please check the username or password")
        client.close()

except Exception as e:
    print("MongoDB connection failure: Please check the connection details")
    print(e)


