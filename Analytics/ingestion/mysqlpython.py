import pymysql
import pyrebase

config = {
  "apiKey": "AIzaSyDl_6GZJ-JsdcwVSKDW02qbfIueg04sY0Y",
  "authDomain": "dbproject-f258b.firebaseapp.com",
  "databaseURL": "https://dbproject-f258b.firebaseio.com/",
  "storageBucket": "dbproject-f258b"
}


firebase = pyrebase.initialize_app(config)
db = firebase.database()


data = db.child("my_sql").get().val()
#print(data['created'])


print('Waiting for database to be created')
while ((db.child("my_sql").get().val())['created'] != 'yes'):
	#busy wait
	pass
print('Database created')


#host is the endpoint of the ec2
#it can only be obtained when the database is created
host = (db.child("my_sql").get().val())['endpoint']
user = 'useralldb20'
password = 'passworddb20'
database = 'mydb'

#connection = pymysql.connect(host, user, password, database)
#
#
#try:
#
#    with connection.cursor() as cur:
#
#        cur.execute('SELECT * FROM KRTable LIMIT 5')
#        rows = cur.fetchall()
#
#        for row in rows:
#            #print(f'{row[0]} {row[1]} {row[2]}')
#            print(row)
#
#finally:
#    connection.close()


with open('/home/hadoop/sql-hostname.txt', 'w') as sqlfile:
	sqlfile.write(host)