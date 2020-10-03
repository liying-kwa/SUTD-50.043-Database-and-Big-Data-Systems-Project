import pymysql


#host is the endpoint of the ec2
#it can only be obtained when the ec2 is created
host = 'ec2-54-179-67-110.ap-southeast-1.compute.amazonaws.com'
user = 'userall'
password = 'password'
database = 'mydb'

connection = pymysql.connect(host, user, password, database)


try:

    with connection.cursor() as cur:

        cur.execute('SELECT * FROM KRTable LIMIT 5')
        rows = cur.fetchall()

        for row in rows:
            #print(f'{row[0]} {row[1]} {row[2]}')
            print(row)

finally:
    connection.close()
