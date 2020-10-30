import pymysql
import pyrebase

# THIS FILE WILL NOT CHECK IF THE QUERIES ARE CORRECT
# BEFORE CALLING THE FUNCTIONS, PLEASE MAKE SURE THAT THE VALUES
# SUCH AS (asin/overall/reviewerID) ARE IN THE CORRECT FORM
# OTHERWISE IT WILL RETURN NOTHING

class mysql_review:
    def __init__(self):

        config = {
        "apiKey": "AIzaSyDl_6GZJ-JsdcwVSKDW02qbfIueg04sY0Y",
        "authDomain": "dbproject-f258b.firebaseapp.com",
        "databaseURL": "https://dbproject-f258b.firebaseio.com/",
        "storageBucket": "dbproject-f258b"
        }

        firebase = pyrebase.initialize_app(config)

        db = firebase.database()

        # busy wait till database is configured and ready to go
        while ((db.child("my_sql").get().val())['created'] != 'yes'):
            pass

        #host is the endpoint of the ec2
        #it can only be obtained when the ec2 is created
        host = (db.child("my_sql").get().val())['endpoint']
        user = 'userall'
        password = 'password'
        database = 'mydb'

        self.connection = pymysql.connect(host, user, password, database)

    def _execute(self, command):
        rows = None
        try:
            with self.connection.cursor() as cur:
                cur.execute(command)
                rows = cur.fetchall()
            return rows
    
        except Exception as e:
            print(e)
        return rows
            

    def get_by_asid(self, asin):
        # asin should be in the form like: B000FA64PK

        # maybe can just select all?
        # like: query_statement = "SELECT * FROM * WHERE `asin`={}".format(asin)
        query_statement = "SELECT `helpful`, `overall`, `reviewText`, `reviewerID`, `reviewerName`, `unixReviewTime` FROM * WHERE `asin`={}".format(asin)
        return_query = self._execute(query_statement)
        return return_query

    def get_by_overall(self, rating):
        # rating should be an integer from 1-5
        query_statement = "SELECT `asin`, `helpful`, `reviewText`, `reviewerID`, `reviewerName`, `unixReviewTime` FROM * WHERE `overall`={}".format(rating)
        return_query = self._execute(query_statement)
        return return_query

    def get_everything(self):
        # this probably shouldn't be done
        query_statement = "SELECT * FROM *"
        return_query = self._execute(query_statement)
        return return_query

    def close(self):
        self.connection.close()
        return 0

