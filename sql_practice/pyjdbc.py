import pymysql

def connect_to_mysql():
    connection = None
    try:
        connection = pymysql.connect(
            host='localhost',
            user='root',
            password='Santmysql@1229',
            database='test',
            cursorclass=pymysql.cursors.DictCursor
        )
        print("Connected to MySQL successfully")

    except pymysql.MySQLError as e:
        # This block will catch any MySQL-related errors
        print(f"Error connecting to MySQL: {e}")

    except Exception as e:
        # This block will catch any other unexpected errors
        print(f"An unexpected error occurred: {e}")

    finally:
        # This block always runs, whether an error occurred or not
        if connection:
            connection.close()
            print("MySQL connection closed.")

if __name__ == '__main__':
    connect_to_mysql()