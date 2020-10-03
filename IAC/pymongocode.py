import pymongo


mongo_username = "user"
mongo_password = "password"

#endpoint of ec2
#it can only be obtained when the ec2 is created
ssh_address = "ec2-54-169-51-220.ap-southeast-1.compute.amazonaws.com"


try:
    client = pymongo.MongoClient("mongodb://"+ ssh_address+":27017")
    auth = client.admin.authenticate(mongo_username,mongo_password)
    db = client["myMongodb"]


    if(auth):
        print("MongoDB connection successful")
        col = db["meta_Kindle_Store"].find_one()
        print(col)
    else:
        print("MongoDB authentication failure: Please check the username or password")
        client.close()

except Exception as e:
    print("MongoDB connection failure: Please check the connection details")
    print(e)



