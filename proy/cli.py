from crud import agregar_cliente, obtener_clientes, agregar_factura, obtener_facturas, eliminar_cliente, actualizar_cliente

while True:
    print("\n--- Menú de Opciones ---")
    print("1. Agregar Cliente")
    print("2. Ver Clientes")
    print("3. Agregar Factura")
    print("4. Ver Facturas de un Cliente")
    print("5. Eliminar Cliente")
    print("6. Actualizar Cliente")
    print("7. Salir")

    opcion = input("Seleccione una opción: ")

    if opcion == "1":
        nombre = input("Ingrese nombre del cliente: ")
        correo = input("Ingrese correo del cliente: ")
        agregar_cliente(nombre, correo)

    elif opcion == "2":
        clientes = obtener_clientes()
        print("\nLista de Clientes:")
        for cliente in clientes:
            print(f"ID: {cliente.id}, Nombre: {cliente.nombre}, Correo: {cliente.correo}")

    elif opcion == "3":
        cliente_id = input("Ingrese ID del cliente: ")
        monto = input("Ingrese monto de la factura: ")
        fecha = input("Ingrese fecha de la factura (YYYY-MM-DD): ")
        agregar_factura(int(cliente_id), float(monto), fecha)

    elif opcion == "4":
        cliente_id = input("Ingrese ID del cliente: ")
        facturas = obtener_facturas(int(cliente_id))
        print(f"\nFacturas del Cliente {cliente_id}:")
        for factura in facturas:
            print(f"ID: {factura.id}, Monto: {factura.monto}, Fecha: {factura.fecha}")

    elif opcion == "5":
        cliente_id = input("Ingrese ID del cliente a eliminar: ")
        eliminar_cliente(int(cliente_id))

    elif opcion == "6":
        cliente_id = input("Ingrese ID del cliente a actualizar: ")
        nuevo_nombre = input("Ingrese el nuevo nombre: ")
        nuevo_correo = input("Ingrese el nuevo correo: ")
        actualizar_cliente(int(cliente_id), nuevo_nombre, nuevo_correo)

    elif opcion == "7":
        print("Saliendo del programa...")
        break

    else:
        print("Opción inválida. Intente nuevamente.")
