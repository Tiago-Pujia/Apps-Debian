#!/bin/bash
# 1. Asignar permisos con chmod +x apps.sh
# 2. Ejecutar como ./apps.sh

# Definir colores ANSI
RED=$'\033[1;31m'
GREEN=$'\033[1;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[1;36m'
NC=$'\033[0m' # Sin color

clear

printf "%b\n" "${CYAN}==========================================================${NC}"
printf "%b\n" "${GREEN}INICIANDO SCRIPT APLICACIONES BASICAS DEBIAN${NC}"
printf "%b\n" "${CYAN}==========================================================${NC}"

# Función para pedir confirmación antes de instalar/desinstalar
prompt_install() {
  local description=$1
  shift
  read -p "$(printf '%b' "${YELLOW}\n¿Deseas $description? (Y/y = sí, N/n = no):${NC} ")" response
  if [[ "$response" == "Y" || "$response" == "y" ]]; then
    printf "%b\n" "${GREEN}✓ Instalando...${NC}"
    "$@"
  else
    printf "%b\n" "${RED}✗ Saltado${NC}"
  fi
}

# Actualizar la lista de paquetes y acceder como root #
prompt_install "actualizar la lista de paquetes (apt update)" sudo apt update
prompt_install "actualizar los paquetes instalados (apt upgrade)" sudo apt upgrade -y

# Instalar Flatpak y agregar el repositorio de Flathub #
prompt_install "instalar Flatpak" sudo apt install flatpak -y
prompt_install "agregar repositorio Flathub" sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
prompt_install "instalar fastfetch" sudo apt install fastfetch -y

# Instalar software de desarrollo #
prompt_install "instalar Java (OpenJDK 17)" sudo apt install openjdk-17-jdk -y
prompt_install "instalar Git" sudo apt install git -y
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

# Instalar aplicaciones básicas #
prompt_install "instalar Mousepad" sudo apt install mousepad -y
prompt_install "instalar Pinta (edición de imágenes)" flatpak install flathub com.github.PintaProject.Pinta -y
prompt_install "instalar Spotify" flatpak install -y flathub com.spotify.Client
prompt_install "instalar Github Desktop" flatpak install -y flathub io.github.shiftey.Desktop
prompt_install "instalar Teams" flatpak install -y flathub com.github.IsmaelMartinez.teams_for_linux
prompt_install "instalar Vivaldi" flatpak install -y flathub com.vivaldi.Vivaldi
prompt_install "instalar Zen" flatpak install -y flathub app.zen_browser.zen
prompt_install "instalar Steam" sudo apt install steam -y
prompt_install "instalar OBS Studio" flatpak install -y flathub com.obsproject.Studio
prompt_install "instalar Draw.io" flatpak install -y flathub com.jgraph.drawio.desktop
prompt_install "instalar Discord" flatpak install -y flathub com.discordapp.Discord
prompt_install "instalar Filezilla" sudo apt install filezilla

# Brave Browser #
echo ""
read -p "${YELLOW}¿Deseas instalar Brave Browser? (Y/y = sí, N/n = no):${NC} " response_brave
if [[ "$response_brave" == "Y" || "$response_brave" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando Brave...${NC}"
  curl -fsS https://dl.brave.com/install.sh | sh
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# Vencord #
echo ""
read -p "${YELLOW}¿Deseas instalar Vencord? (Y/y = sí, N/n = no):${NC} " response_vencord
if [[ "$response_vencord" == "Y" || "$response_vencord" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando Vencord...${NC}"
  sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# LM Studio #
echo ""
read -p "${YELLOW}¿Deseas instalar LM Studio? (Y/y = sí, N/n = no):${NC} " response_lmstudio
if [[ "$response_lmstudio" == "Y" || "$response_lmstudio" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando LM Studio...${NC}"
  curl -fsSL https://lmstudio.ai/install.sh | bash
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi


# Visual studio code
echo ""
read -p "${YELLOW}¿Deseas instalar Visual Studio Code? (Y/y = sí, N/n = no):${NC} " response_vscode
if [[ "$response_vscode" == "Y" || "$response_vscode" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando...${NC}"
  wget 'https://go.microsoft.com/fwlink/?LinkID=760868' -O vscode.deb
  chmod +x vscode.deb
  sudo apt install ./vscode.deb -y
  rm -f vscode.deb
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# Descargar e instalar TLauncher #
echo ""
read -p "${YELLOW}¿Deseas instalar TLauncher? (Y/y = sí, N/n = no):${NC} " response_tlauncher
if [[ "$response_tlauncher" == "Y" || "$response_tlauncher" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando...${NC}"
  wget https://tlauncher.org/installer-linux -O tlauncher.deb
  chmod +x tlauncher.deb
  sudo apt install ./tlauncher.deb -y
  rm -f tlauncher.deb
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# OnlyOffice
echo ""
read -p "${YELLOW}¿Deseas instalar OnlyOffice? (Y/y = sí, N/n = no):${NC} " response_onlyoffice
if [[ "$response_onlyoffice" == "Y" || "$response_onlyoffice" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando...${NC}"
  wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
  chmod +x onlyoffice-desktopeditors_amd64.deb
  sudo apt install ./onlyoffice-desktopeditors_amd64.deb -y
  rm -f onlyoffice-desktopeditors_amd64.deb
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# Antigravity
echo ""
read -p "${YELLOW}¿Deseas instalar Antigravity? (Y/y = sí, N/n = no):${NC} " response_antigravity
if [[ "$response_antigravity" == "Y" || "$response_antigravity" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Instalando...${NC}"
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
  echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
  sudo apt update
  sudo apt install antigravity -y
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# OpenCode (CLI y Desktop)
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


# Terminal Warp
# wget -O warp.deb "https://app.warp.dev/download?package=deb" && sudo dpkg -i warp.deb && sudo apt -f install -y
# rm -f warp.deb

# WallPaper Engine
printf "%b\n" "\n${YELLOW}--- Configurar Wallpaper Engine con KDE ---${NC}"
echo "1. Instalar Wallpaper Engine: Desde Steam"
echo "2. Instalar Waywallen: Darle click derecho al fondo de pantalla > Escritorio e imagen de fondo > Obtener nuevos complementos > Waywallen"
echo "3. Descargar Plugin: https://github.com/waywallen/open-wallpaper-engine/releases > Descargar org x86 > no descomprimir"
echo "4. Instalar Plugin: Abrir Waywallen > Plugins > Añadir > Seleccionar el zip"
echo "5. Configurar ruta de Steam: Abrir Waywallen > Library Manager > Añadir con wallpaper > Insertar ruta ~/.steam/steam/steamapps/"
echo "6. Habilitar fondo de pantalla: Darle click derecho al fondo de pantalla > Escritorio e imagen de fondo > Tipo de fondo: Waywallen"
read -p "${YELLOW}¿Deseas abrir el link del tutorial de Wallpaper Engine en el navegador? (Y/y = sí, N/n = no):${NC} " response_wallpaper
if [[ "$response_wallpaper" == "Y" || "$response_wallpaper" == "y" ]]; then
  printf "%b\n" "${GREEN}✓ Abriendo navegador...${NC}"
  xdg-open "https://youtu.be/4ZAeVub9a2I?si=pEChx449ZNi3M3bD&t=549" 2>/dev/null || printf "%b\n" "${RED}⚠ No se pudo abrir el navegador automáticamente. Abre el link manualmente: https://youtu.be/4ZAeVub9a2I?si=pEChx449ZNi3M3bD&t=549${NC}"
else
  printf "%b\n" "${RED}✗ Saltado${NC}"
fi

# Desisntalar software innecesario #
prompt_install "desinstalar LibreOffice" sudo apt-get remove --purge libreoffice*
prompt_install "limpiar caché de apt (apt clean)" sudo apt clean
prompt_install "desinstalar paquetes innecesarios (apt autoremove)" sudo apt-get autoremove

printf "%b\n" "\n${CYAN}==========================================================${NC}"
printf "%b\n" "${GREEN}✓ ¡INSTALACIONES FINALIZADAS!${NC}"
printf "%b\n" "${CYAN}==========================================================${NC}\n"

fastfetch