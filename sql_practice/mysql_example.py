import mysql.connector
from mysql.connector import Error
try:
    connection = mysql.connector.connect(
        host = "localhost",
        database = "interview_prep",
        user = "root",
        password = "Santmysql@1229"
    )
    if connection.is_connected():
        print("Connected to MySQL database")
        cursor = connection.cursor()

        query = "select * from users"

        cursor.execute(query)

        rows = cursor.fetchall()

        for row in rows:
            print(row)

except Error as e:
    print("Error while connecting to MySQL",e)

finally:
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("Mysql connection is closed")
    



