#Definición del modelo de la tabla 'usuarios' en SQLAlchemy

from sqlalchemy import Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import relationship

from database import Base

class Cliente(Base):
    __tablename__ = 'clientes' #Define el nombre en la base de datos

    id = Column(Integer, primary_key = True)
    nombre = Column(String(50), nullable = False)
    correo = Column(String(100), unique = True, nullable = False)

    #Relación con facturas (un cliente tiene muchas facturas)
    facturas = relationship("Factura", back_populates = "cliente", cascade = "all, delete")

class Factura(Base):
    __tablename__ = 'facturas'

    id = Column(Integer, primary_key = True)
    cliente_id = Column(Integer, ForeignKey('clientes.id'))
    monto = Column(Float, nullable = False)
    fecha = Column(String, nullable = False)

    #Relación inversa con cliente (una factura pertenece a un cliente)
    cliente = relationship("Cliente", back_populates = "facturas")