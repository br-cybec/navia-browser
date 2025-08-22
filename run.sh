#!/bin/bash

# -------------------------------------------
# FoxGTK.run - Instalador y lanzador automático
# -------------------------------------------

# Cambiar al directorio del script
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# Dependencias requeridas
DEPENDENCIAS=(python3 python3-gi gir1.2-webkit2-4.1 libwebkit2gtk-4.1-0)

FALTAN=()

echo "🔍 Verificando dependencias del sistema..."

# Verificar una por una
for pkg in "${DEPENDENCIAS[@]}"; do
    if ! dpkg -s "$pkg" &> /dev/null; then
        FALTAN+=("$pkg")
    fi
done

# Si faltan dependencias
if [ ${#FALTAN[@]} -ne 0 ]; then
    # Verificar que Zenity esté presente
    if ! command -v zenity &>/dev/null; then
        echo "⚠️ Zenity no está instalado. Instalándolo para mostrar interfaz gráfica..."
        sudo apt update && sudo apt install -y zenity
    fi

    FALTANTES=$(IFS=$'\n'; echo "${FALTAN[*]}")
    zenity --question --width=400 --title="FoxGTK - Dependencias faltantes" \
        --text="Se requieren los siguientes paquetes para ejecutar el navegador:\n\n$FALTANTES\n\n¿Deseas instalarlos?"

    if [ $? -eq 0 ]; then
        echo "🛠 Instalando dependencias..."
        sudo apt update
        sudo apt install -y "${FALTAN[@]}"
    else
        zenity --error --width=300 --text="No se instalaron las dependencias. El navegador no puede iniciarse."
        exit 1
    fi
fi

# Ejecutar navegador
echo "🚀 Iniciando FoxGTK..."
python3 "$DIR/main.py"
