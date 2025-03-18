from crud import inicializar_bd, obtener_clientes


inicializar_bd()

usuarios = obtener_clientes()

for usuario in usuarios:
    print(f'ID: {usuario.id}, Nombre: {usuario.nombre}, Correo: {usuario.correo}')