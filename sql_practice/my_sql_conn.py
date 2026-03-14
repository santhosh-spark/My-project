import pymysql

try:
    connection = pymysql.connect(
        host= 'localhost',
        user = 'root',
        password= 'Santmysql@1229',
        database='test',
        cursorclass= pymysql.cursors.DictCursor
    )

    
    # cursor = connection.cursor()
    with connection.cursor() as cursor: 

        create_query = """
        create table if not exists employees (
        id int auto_increment primary key,
        name varchar(50),
        department varchar(50)
        )
        """

        cursor.execute(create_query)


        insert_query = " insert into employees (name,department) values (%s,%s)"
        values = [("santhosh","AIML"), ("Linkesh","Data science"),("Maddy","Embeeded systems")]

        cursor.executemany(insert_query,values)
        connection.commit()

        #step 4: select data

        select_query  = "select * from employees"
        cursor.execute(select_query)
        result = cursor.fetchall()

        with open("employee_output.txt","w") as file:
            for row in result:
                file.write(f'{row}\n')

except Exception as e:
    print("Error while connecting to the database",e)

finally:
    connection.close()