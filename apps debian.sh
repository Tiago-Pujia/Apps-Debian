#!/bin/bash
# 1. Asignar permisos con chmod +x "apps debian.sh"
# 2. Ejecutar como ./"apps debian.sh"

# Definir colores ANSI
RED=$'\033[1;31m'
GREEN=$'\033[1;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[1;36m'
MAGENTA=$'\033[1;35m'
NC=$'\033[0m' # Sin color

clear

printf "%b\n" "${CYAN}==========================================================${NC}"
printf "%b\n" "${GREEN}    INICIANDO SCRIPT DE APLICACIONES DEBIAN / UBUNTU    ${NC}"
printf "%b\n" "${CYAN}==========================================================${NC}"

# Función para imprimir cabeceras de sección visuales
print_section() {
  printf "\n%b\n" "${MAGENTA}==========================================================${NC}"
  printf "%b\n" "${MAGENTA} 📦 SECCIÓN: $1${NC}"
  printf "%b\n" "${MAGENTA}==========================================================${NC}"
}

# Función para pedir confirmación antes de instalar/desinstalar
prompt_install() {
  local description=$1
  shift
  read -p "$(printf '%b' "${YELLOW}\n¿Deseas $description? (Y/y = sí, N/n = no):${NC} ")" response
  if [[ "$response" == "Y" || "$response" == "y" ]]; then
    printf "%b\n" "${GREEN}✓ Instalando / Ejecutando...${NC}"
    "$@"
  else
    printf "%b\n" "${RED}✗ Saltado${NC}"
  fi
}

# ==========================================================
# 1. ACTUALIZACIÓN DEL SISTEMA Y GESTIÓN DE PAQUETES
# ==========================================================
print_section "Actualización del Sistema y Gestores de Paquetes"

prompt_install "actualizar la lista de paquetes (apt update)" sudo apt update
prompt_install "actualizar los paquetes instalados (apt upgrade)" sudo apt upgrade -y
prompt_install "instalar Flatpak" sudo apt install flatpak -y
prompt_install "agregar repositorio Flathub" sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
prompt_install "instalar Fastfetch" sudo apt install fastfetch -y

# ==========================================================
# 2. DESARROLLO & TERMINAL
# ==========================================================
print_section "Desarrollo & Terminal"

prompt_install "instalar Java (OpenJDK 17)" sudo apt install openjdk-17-jdk -y
prompt_install "instalar Git" sudo apt install git -y
prompt_install "instalar GitHub CLI (gh)" sudo apt install gh -y
prompt_install "instalar JQ (procesador JSON)" sudo apt install jq -y
prompt_install "instalar Vim" sudo apt install vim -y
prompt_install "instalar Htop" sudo apt install htop -y
prompt_install "instalar Btop" sudo apt install btop -y
prompt_install "instalar Postman" sudo snap install postman

# Node.js y npm (LTS) #
echo ""
read -p "${YELLOW}¿Deseas instalar Node.js y npm (LTS)? (Y/y = sí, N/n = no):${NC} " response_node
if [[ "$response_node" == "Y" || "$response_node" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando Node.js y npm...${NC}"
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt install nodejs -y
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# Docker y Docker Compose #
echo ""
read -p "${YELLOW}¿Deseas instalar Docker y Docker Compose? (Y/y = sí, N/n = no):${NC} " response_docker
if [[ "$response_docker" == "Y" || "$response_docker" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando Docker...${NC}"
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker $USER
  printf "%b\n" "${GREEN}✓ Docker instalado correctamente. (Nota: es posible que necesites reiniciar sesión para usar Docker sin sudo)${NC}"
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# Visual Studio Code #
echo ""
read -p "${YELLOW}¿Deseas instalar Visual Studio Code? (Y/y = sí, N/n = no):${NC} " response_vscode
if [[ "$response_vscode" == "Y" || "$response_vscode" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando Visual Studio Code...${NC}"
  wget 'https://go.microsoft.com/fwlink/?LinkID=760868' -O vscode.deb
  chmod +x vscode.deb
  sudo apt install ./vscode.deb -y
  rm -f vscode.deb
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# Antigravity #
echo ""
read -p "${YELLOW}¿Deseas instalar Antigravity? (Y/y = sí, N/n = no):${NC} " response_antigravity
if [[ "$response_antigravity" == "Y" || "$response_antigravity" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Descargando e instalando Antigravity...${NC}"
  wget "https://storage.googleapis.com/antigravity-public/antigravity-hub/2.16.0-4917332007583744/linux-x64/Antigravity.tar.gz" -O /tmp/Antigravity.tar.gz
  mkdir -p /tmp/antigravity_temp
  tar -xzf /tmp/Antigravity.tar.gz -C /tmp/antigravity_temp
  sudo rm -rf /opt/antigravity
  sudo mv /tmp/antigravity_temp/Antigravity-x64 /opt/antigravity
  rm -rf /tmp/antigravity_temp /tmp/Antigravity.tar.gz

  sudo chown root:root /opt/antigravity/chrome-sandbox
  sudo chmod 4755 /opt/antigravity/chrome-sandbox

  sudo rm -f /usr/local/bin/antigravity
  sudo ln -s /opt/antigravity/antigravity /usr/local/bin/antigravity

  sudo tee /usr/share/applications/antigravity.desktop > /dev/null <<'EOF'
[Desktop Entry]
Name=Antigravity
Comment=Antigravity 2.0 Agent Hub
Exec=/opt/antigravity/antigravity %U
Icon=/opt/antigravity/resources/app.asar.unpacked/build/icon.png
Type=Application
Categories=Development;
StartupWMClass=Antigravity
EOF

  sudo update-desktop-database /usr/share/applications 2>/dev/null || true
  printf "%b\n" "${GREEN}✓ Antigravity instalado y configurado correctamente.${NC}"
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# OpenCode (CLI y Desktop) #
echo ""
read -p "${YELLOW}¿Deseas instalar OpenCode (CLI y Desktop)? (Y/y = sí, N/n = no):${NC} " response_opencode
if [[ "$response_opencode" == "Y" || "$response_opencode" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando OpenCode CLI...${NC}"
  curl -fsSL https://opencode.ai/v2/install | bash
  printf "%b\n" "${GREEN}✓ Instalando OpenCode Desktop...${NC}"
  wget https://opencode.ai/files/bin/2.0.6/opencode-desktop-linux-amd64.deb -O opencode-desktop.deb
  chmod +x opencode-desktop.deb
  sudo apt install ./opencode-desktop.deb -y
  rm -f opencode-desktop.deb
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# ==========================================================
# 3. NAVEGADORES WEB
# ==========================================================
print_section "Navegadores Web"

# Brave Browser #
echo ""
read -p "${YELLOW}¿Deseas instalar Brave Browser? (Y/y = sí, N/n = no):${NC} " response_brave
if [[ "$response_brave" == "Y" || "$response_brave" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando Brave...${NC}"
  curl -fsS https://dl.brave.com/install.sh | sh
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

prompt_install "instalar Vivaldi" flatpak install -y flathub com.vivaldi.Vivaldi
prompt_install "instalar Zen Browser" flatpak install -y flathub app.zen_browser.zen

# ==========================================================
# 4. COMUNICACIÓN & SOCIAL
# ==========================================================
print_section "Comunicación & Social"

prompt_install "instalar Discord" flatpak install -y flathub com.discordapp.Discord

# Vencord #
echo ""
read -p "${YELLOW}¿Deseas instalar Vencord? (Y/y = sí, N/n = no):${NC} " response_vencord
if [[ "$response_vencord" == "Y" || "$response_vencord" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando Vencord...${NC}"
  sh -c "$(curl -sS https://vencord.dev/install.sh)"
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

prompt_install "instalar Teams for Linux" flatpak install -y flathub com.github.IsmaelMartinez.teams_for_linux

# ==========================================================
# 5. MULTIMEDIA, JUEGOS & IA
# ==========================================================
print_section "Multimedia, Juegos & IA"

prompt_install "instalar Spotify" flatpak install -y flathub com.spotify.Client

# Spicetify #
echo ""
read -p "${YELLOW}¿Deseas instalar Spicetify (CLI & Marketplace para Spotify)? (Y/y = sí, N/n = no):${NC} " response_spicetify
if [[ "$response_spicetify" == "Y" || "$response_spicetify" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando Spicetify CLI...${NC}"
  curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
  printf "%b\n" "${GREEN}✓ Instalando Spicetify Marketplace...${NC}"
  curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
  if [ -d "/var/lib/flatpak/app/com.spotify.Client" ]; then
    printf "%b\n" "${GREEN}✓ Ajustando permisos para Spotify Flatpak...${NC}"
    sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify 2>/dev/null
    sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/apps -R 2>/dev/null
  fi
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

prompt_install "instalar OBS Studio" flatpak install -y flathub com.obsproject.Studio
prompt_install "instalar Pinta (edición de imágenes)" flatpak install flathub com.github.PintaProject.Pinta -y
prompt_install "instalar Draw.io" flatpak install -y flathub com.jgraph.drawio.desktop

# LM Studio #
echo ""
read -p "${YELLOW}¿Deseas instalar LM Studio? (Y/y = sí, N/n = no):${NC} " response_lmstudio
if [[ "$response_lmstudio" == "Y" || "$response_lmstudio" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando LM Studio...${NC}"
  curl -fsSL https://lmstudio.ai/install.sh | bash
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

prompt_install "instalar Steam" sudo apt install steam -y

# TLauncher #
echo ""
read -p "${YELLOW}¿Deseas instalar TLauncher? (Y/y = sí, N/n = no):${NC} " response_tlauncher
if [[ "$response_tlauncher" == "Y" || "$response_tlauncher" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando TLauncher...${NC}"
  wget https://tlauncher.org/installer-linux -O tlauncher.deb
  chmod +x tlauncher.deb
  sudo apt install ./tlauncher.deb -y
  rm -f tlauncher.deb
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# ==========================================================
# 6. OFIMÁTICA & HERRAMIENTAS
# ==========================================================
print_section "Ofimática & Herramientas"

# OnlyOffice #
echo ""
read -p "${YELLOW}¿Deseas instalar OnlyOffice? (Y/y = sí, N/n = no):${NC} " response_onlyoffice
if [[ "$response_onlyoffice" == "Y" || "$response_onlyoffice" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando OnlyOffice...${NC}"
  wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
  chmod +x onlyoffice-desktopeditors_amd64.deb
  sudo apt install ./onlyoffice-desktopeditors_amd64.deb -y
  rm -f onlyoffice-desktopeditors_amd64.deb
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

prompt_install "instalar Obsidian" flatpak install -y flathub md.obsidian.Obsidian
prompt_install "instalar Mousepad" sudo apt install mousepad -y
prompt_install "instalar Filezilla" sudo apt install filezilla -y
prompt_install "instalar Github Desktop" flatpak install -y flathub io.github.shiftey.Desktop

# ==========================================================
# 7. PERSONALIZACIÓN & ENTORNO (KDE)
# ==========================================================
print_section "Personalización (Wallpaper Engine con KDE)"

printf "%b\n" "${YELLOW}Guía de configuración:${NC}"
echo "1. Instalar Wallpaper Engine: Desde Steam"
echo "2. Instalar Waywallen: Darle click derecho al fondo de pantalla > Escritorio e imagen de fondo > Obtener nuevos complementos > Waywallen"
echo "3. Descargar Plugin: https://github.com/waywallen/open-wallpaper-engine/releases > Descargar org x86 > no descomprimir"
echo "4. Instalar Plugin: Abrir Waywallen > Plugins > Añadir > Seleccionar el zip"
echo "5. Configurar ruta de Steam: Abrir Waywallen > Library Manager > Añadir con wallpaper > Insertar ruta ~/.steam/steam/steamapps/"
echo "6. Habilitar fondo de pantalla: Darle click derecho al fondo de pantalla > Escritorio e imagen de fondo > Tipo de fondo: Waywallen"

echo ""
read -p "${YELLOW}¿Deseas abrir el link del tutorial de Wallpaper Engine en el navegador? (Y/y = sí, N/n = no):${NC} " response_wallpaper
if [[ "$response_wallpaper" == "Y" || "$response_wallpaper" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Abriendo navegador...${NC}"
  xdg-open "https://youtu.be/4ZAeVub9a2I?si=pEChx449ZNi3M3bD&t=549" 2>/dev/null || printf "%b\n" "${RED}⚠ No se pudo abrir el navegador automáticamente. Abre el link manualmente: https://youtu.be/4ZAeVub9a2I?si=pEChx449ZNi3M3bD&t=549${NC}"
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# ==========================================================
# 8. LIMPIEZA & OPTIMIZACIÓN
# ==========================================================
print_section "Limpieza y Optimización del Sistema"

prompt_install "desinstalar LibreOffice" sudo apt-get remove --purge libreoffice* -y
prompt_install "limpiar caché de apt (apt clean)" sudo apt clean
prompt_install "desinstalar paquetes innecesarios (apt autoremove)" sudo apt-get autoremove -y

printf "%b\n" "\n${CYAN}==========================================================${NC}"
printf "%b\n" "${GREEN}✓ ¡INSTALACIONES FINALIZADAS!${NC}"
printf "%b\n" "${CYAN}==========================================================${NC}\n"

fastfetch
