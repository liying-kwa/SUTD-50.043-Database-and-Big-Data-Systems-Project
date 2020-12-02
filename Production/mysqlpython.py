import pymysql
import pyrebase
import time

# THIS FILE WILL NOT CHECK IF THE QUERIES ARE CORRECT
# BEFORE CALLING THE FUNCTIONS, PLEASE MAKE SURE THAT THE VALUES
# SUCH AS (asin/overall/reviewerID) ARE IN THE CORRECT FORM
# OTHERWISE IT WILL RETURN NOTHING

class mysql_review:
    def __init__(self):

        self.tablename = "KRTable"

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
            

    def get_by_asin(self, asin):
        # asin should be in the form like: B000FA64PK

        # used to display reviews, so we need username and reviewTime
        query_statement = "SELECT `asin`, `reviewText`, `reviewerName`, `reviewTime` FROM {} WHERE asin='{}'".format(self.tablename, asin)
        return_query = self._execute(query_statement)
        list_of_reviews = []
        if return_query:
            for i in range(len(return_query)):
                dict_return_query = {'asin': return_query[i][0], 'reviewText': return_query[i][1], 'reviewerName': return_query[i][2], 'reviewTime': return_query[i][3]}
                list_of_reviews.append(dict_return_query)
        return list_of_reviews

    def get_by_overall(self, rating):
        # rating should be an integer from 1-5
        query_statement = "SELECT `asin`, `helpful`, `reviewText`, `reviewerID`, `reviewerName`, `unixReviewTime`, `overall` FROM {} WHERE `overall`='{}'".format(self.tablename, rating)
        return_query = self._execute(query_statement)
        return return_query

    def insert_new_review(self, asin, helpful, overall, reviewText, reviewerID, reviewerName, summary):
        # we probably have a better way to do this I'm sorry
        reviewTime = time.strftime("%d %m, %Y", time.gmtime())
        unixReviewTime = int(time.time())
        query_statement = "INSERT INTO {} (`asin`, `helpful`, `overall`, `reviewText`, `reviewTime`, `reviewerID`, `reviewerName`, `summary`, `unixReviewTime`) VALUES ('{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}')".format(self.tablename, asin, helpful, overall, reviewText, reviewTime, reviewerID, reviewerName, summary, unixReviewTime)
        self._execute(query_statement)
        return 0

    def get_review_by_asin(self, asin):
        # asin should be in the form like: B000FA64PK
        query_statement = "SELECT `reviewText`, `asin` FROM {} WHERE `asin`='{}'".format(self.tablename, asin)
        return_query = self._execute(query_statement)
        # I am assuming that the `reviewText` returned is a string
        return return_query

    #def get_everything(self):
        # this probably shouldn't be done
        #query_statement = "SELECT * FROM KRTable"
        #return_query = self._execute(query_statement)
        #return return_query

    def close(self):
        self.connection.close()
        return 0

