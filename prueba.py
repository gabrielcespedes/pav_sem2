import psycopg2

#Conectar con la base de datos PostgreSQL
conn = psycopg2.connect(
    dbname = "example",
    user = "postgres",
    password = "password_usuario",
    host = "localhost",
    port = "5432"
)

#Crear un cursor para ejecutar consultas SQL
cursor = conn.cursor()

#Crear una tabla si no existe
cursor.execute(
    """
    CREATE TABLE IF NOT EXISTS usuariospg (
        id SERIAL PRIMARY KEY,
        nombre TEXT NOT NULL,
        correo TEXT UNIQUE NOT NULL
    )
    """
)

#Insertar usuario
cursor.execute(
    """
    INSERT INTO usuariospg (nombre, correo)
    VALUES ('javier', 'javier@mail.com'), ('maria', 'maria@mail.com');
    """
)

#Consultar por usuarios
cursor.execute("SELECT * FROM usuariospg")
usuarios = cursor.fetchall()

#Mostrar usuarios por consola
for usuario in usuarios:
    print(usuario)

#Guardar cambios y cerrar conexión
conn.commit()
conn.close()
