#Configuración de la base de datos y creación de la sesión SQLAlchemy

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

#Crear el motor de base de datos
engine = create_engine("postgresql://postgres:password_usuario@localhost:5432/clientes", echo = False)

#Definir la base para modelos ORM
Base = declarative_base()

#Configuración de la sesión
Session = sessionmaker(bind = engine)
session = Session()