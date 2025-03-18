#Funciones para realizar operaciones CRUD en la base de datos

from database import session
from models import Cliente, Factura

from sqlalchemy.exc import IntegrityError

def inicializar_bd():
    from database import Base, engine
    Base.metadata.create_all(engine)

def agregar_cliente(nombre, correo):
    try:
        nuevo_cliente = Cliente(nombre = nombre, correo = correo)
        session.add(nuevo_cliente)
        session.commit()
    except IntegrityError:
        session.rollback() #deshace cambios si hay error por clave única
        print(f"Error: El correo '{correo}' ya está registrado.")

def obtener_clientes():
    session.expire_all() #forzar actualizacion desde la Base de Datos
    return session.query(Cliente).all()

def buscar_cliente_correo(correo):
    return session.query(Cliente).filter_by(correo = correo).first()

def actualizar_cliente(id_cliente, nuevo_nombre, nuevo_correo):
    try:
        cliente = session.query(Cliente).filter_by(id = id_cliente).first()
        if cliente:
            #verificación si el nuevo correo ya está registrado por otro usuario
            if session.query(Cliente).filter(Cliente.correo == nuevo_correo, Cliente.id != id_cliente).first():
                print(f'Error: el correo "{nuevo_correo}" ya lo utiliza otro usuario.')
                return

            cliente.nombre = nuevo_nombre
            cliente.correo = nuevo_correo
            session.commit()
            session.refresh(cliente) #asegura que SQLAlchemy recargue los datos desde la base de datos

            print(f"Cliente con ID {id_cliente} actualizado correctamente")

        else:
            print(f'Cliente con Id {id_cliente} no encontrado.')
    except IntegrityError:
        session.rollback()
        print("No se pudo actualizar el usuario debido a una restricción de clave única.")

def eliminar_cliente(id_cliente):
    cliente = session.query(Cliente).filter_by(id = id_cliente).first()
    if cliente:
        session.delete(cliente)
        session.commit()
        session.close() #Para liberar la sesión y evitar inconsistencias
    else:
        print(f'Usuario con Id {id_cliente} no encontrado.')

def agregar_factura(cliente_id, monto, fecha):
    cliente = session.query(Cliente).filter_by(id=cliente_id).first()
    if cliente:
        nueva_factura = Factura(cliente_id=cliente_id, monto=monto, fecha=fecha)
        session.add(nueva_factura)
        session.commit()
        print(f"Factura agregada para el cliente {cliente.nombre}.")
    else:
        print(f"Error: Cliente con ID {cliente_id} no encontrado.")

def obtener_facturas(cliente_id):
    cliente = session.query(Cliente).filter_by(id=cliente_id).first()
    if cliente:
        return cliente.facturas
    else:
        print(f"Error: Cliente con ID {cliente_id} no encontrado.")
        return []