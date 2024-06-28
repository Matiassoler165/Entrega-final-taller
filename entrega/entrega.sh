# Entrega Matías Soler - 338858
#!/bin/bash
# Archivos de datos
USER_FILE="usuarios.txt"
DICT_FILE="diccionario.txt"
REPORT_FILE="reporte.txt"

# Inicializar archivo de usuarios
if [ ! -f "$USER_FILE" ]; then
    echo "admin:admin" > "$USER_FILE"
    echo "user1:password1" >> "$USER_FILE"
    echo "user2:password2" >> "$USER_FILE"
    echo "user3:password3" >> "$USER_FILE"
    echo "user4:password4" >> "$USER_FILE"
fi

# Función para autenticar usuarios
autenticar() {
    echo -n "Usuario: "
    read usuario
    echo -n "Contraseña: "
    read -s contrasena
    echo

    if grep -q "^$usuario:$contrasena$" "$USER_FILE"; then
        return 0
    else
        echo "Autenticación fallida."
        return 1
    fi
}

# Función para listar usuarios
listar_usuarios() {
    echo "Usuarios registrados:"
    cut -d':' -f1 "$USER_FILE"
}

# Función para agregar usuario
agregar_usuario() {
    echo -n "Ingrese nuevo nombre de usuario: "
    read nuevo_usuario
    if grep -q "^$nuevo_usuario:" "$USER_FILE"; then
        echo "El usuario ya existe."
    else
        echo -n "Ingrese contraseña: "
        read -s nueva_contrasena
        echo
        echo "$nuevo_usuario:$nueva_contrasena" >> "$USER_FILE"
        echo "Usuario agregado exitosamente."
    fi
}

# Variables de configuración
letra_inicio=""
letra_fin=""
letra_contenida=""
vocal=""

# Configurar letra de inicio
configurar_letra_inicio() {
    echo -n "Ingrese letra de inicio: "
    read letra_inicio
}

# Configurar letra de fin
configurar_letra_fin() {
    echo -n "Ingrese letra de fin: "
    read letra_fin
}

# Configurar letra contenida
configurar_letra_contenida() {
    echo -n "Ingrese letra contenida: "
    read letra_contenida
}

# Consultar diccionario
consultar_diccionario() {
    if [[ -z $letra_inicio || -z $letra_fin || -z $letra_contenida ]]; then
        echo "Debe configurar las letras de inicio, fin y contenida antes de consultar el diccionario."
        return
    fi

    palabras_filtradas=$(grep "^$letra_inicio.*$letra_contenida.*$letra_fin$" "$DICT_FILE")
    total_palabras_filtradas=$(echo "$palabras_filtradas" | wc -l)
    total_palabras_diccionario=$(wc -l < "$DICT_FILE")
    porcentaje= $(echo "scale=2; $total_palabras_filtradas / $total_palabras_diccionario * 100" | bc )
    echo "$palabras_filtradas" > "$REPORT_FILE"
    echo "Fecha de ejecución: $(date)" >> "$REPORT_FILE"
    echo "Cantidad de palabras totales: $total_palabras_filtradas" >> "$REPORT_FILE"
    echo "Cantidad de palabras en el diccionario: $total_palabras_diccionario" >> "$REPORT_FILE"
    echo "Porcentaje de palabras que cumplen el criterio:" $porcentaje% >> "$REPORT_FILE"
    echo "Usuario: $usuario" >> "$REPORT_FILE"

    cat "$REPORT_FILE"
}

# Ingresar vocal
ingresar_vocal() {
    echo -n "Ingrese vocal: "
    read vocal
}

# Listar palabras con vocal específica
listar_palabras_vocal() {
    if [[ -z $vocal ]]; then
        echo "Debe configurar la vocal antes de consultar."
        return
    fi

    grep "^[^$vocal]*$vocal[^$vocal]*$" "$DICT_FILE"
}

# Algoritmo 1: Promedio, mínimo y máximo
algoritmo1() {
    echo -n "¿Cuántos datos desea ingresar?: "
    read n
    if [[ ! $n =~ ^[0-9]+$ ]]; then
        echo "Entrada no válida."
        return
    fi

    sum=0
    max=0
    min=0
    for (( i=0; i<n; i++ )); do
        echo -n "Ingrese dato $((i+1)): "
        read dato
        if [[ ! $dato =~ ^-?[0-9]+$ ]]; then
            echo "Entrada no válida."
            return
        fi
        sum=$((sum + dato))
        if (( i == 0 )); then
            max=$dato
            min=$dato
        else
            if (( dato > max )); then
                max=$dato
            fi
            if (( dato < min )); then
                min=$dato
            fi
        fi
    done
    promedio= $(echo "scale=2; $sum / $n" | bc)
    echo "Promedio: $promedio"
    echo "Máximo: $max"
    echo "Mínimo: $min"
}

# Algoritmo 2: Palabra capicúa
algoritmo2() {
    echo -n "Ingrese una palabra:"
    read word
    reversed_word =$(reverse_string "$word")
    if [[ $word == $reversed_word ]]; then
        echo "La palabra es capicúa."
    else
        echo "La palabra no es capicúa."
    fi
}

# Menú principal
while true; do
    if autenticar; then
        while true; do
            echo "Menú Principal"
            echo "1. Listar usuarios registrados"
            echo "2. Dar de alta un usuario"
            echo "3. Configurar letra de inicio"
            echo "4. Configurar letra de fin"
            echo "5. Configurar letra contenida"
            echo "6. Consultar diccionario"
            echo "7. Ingresar vocal"
            echo "8. Listar palabras del diccionario con vocal específica"
            echo "9. Algoritmo 1: Promedio, mínimo y máximo"
            echo "10. Algoritmo 2: Palabra capicúa"
            echo "0. Salir"
            echo -n "Seleccione una opción: "
            read opcion

            case $opcion in
                1) listar_usuarios ;;
                2) agregar_usuario ;;
                3) configurar_letra_inicio ;;
                4) configurar_letra_fin ;;
                5) configurar_letra_contenida ;;
                6) consultar_diccionario ;;
                7) ingresar_vocal ;;
                8) listar_palabras_vocal ;;
                9) algoritmo1 ;;
                10) algoritmo2 ;;
                0) exit 0 ;;
                *) echo "Opción no válida." ;;
            esac
        done
    else
        echo "Intente nuevamente."
    fi
done
