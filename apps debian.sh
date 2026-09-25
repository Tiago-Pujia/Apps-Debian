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
# FUNCIONES DE INSTALACIÓN COMPLEJAS
# ==========================================================

install_dotnet() {
  printf "%b\n" "${GREEN}✓ Intentando instalar .NET SDK vía apt...${NC}"
  if sudo apt install dotnet-sdk-8.0 -y 2>/dev/null; then
    printf "%b\n" "${GREEN}✓ .NET SDK 8.0 instalado correctamente mediante apt.${NC}"
  else
    printf "%b\n" "${YELLOW}⚠ No se encontró dotnet-sdk-8.0 en los repositorios apt directos. Usando instalador oficial de Microsoft...${NC}"
    wget -q https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh
    chmod +x /tmp/dotnet-install.sh
    sudo /tmp/dotnet-install.sh --channel 8.0 --install-dir /usr/share/dotnet
    rm -f /tmp/dotnet-install.sh
    sudo ln -sf /usr/share/dotnet/dotnet /usr/local/bin/dotnet
    
    if ! grep -q "/usr/share/dotnet" ~/.bashrc 2>/dev/null; then
      echo 'export DOTNET_ROOT=/usr/share/dotnet' >> ~/.bashrc
      echo 'export PATH=$PATH:/usr/share/dotnet' >> ~/.bashrc
    fi
    export DOTNET_ROOT=/usr/share/dotnet
    export PATH=$PATH:/usr/share/dotnet
    printf "%b\n" "${GREEN}✓ .NET SDK 8.0 instalado correctamente en /usr/share/dotnet.${NC}"
  fi
}

install_postman() {
  if command -v snap &>/dev/null; then
    sudo snap install postman
  else
    flatpak install -y flathub com.getpostman.Postman
  fi
}

install_nodejs() {
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt install nodejs -y
}

install_docker() {
  curl -fsSL https://get.docker.com | sudo sh
  sudo usermod -aG docker $USER
  printf "%b\n" "${GREEN}✓ Docker instalado correctamente. (Nota: es posible que necesites reiniciar sesión para usar Docker sin sudo)${NC}"
}

configure_vscode_password_store() {
  python3 -c '
import os
for p in [os.path.expanduser("~/.vscode/argv.json"), os.path.expanduser("~/.config/Code/User/argv.json")]:
    os.makedirs(os.path.dirname(p), exist_ok=True)
    if not os.path.exists(p):
        with open(p, "w") as f:
            f.write("{\n\t\"enable-crash-reporter\": true,\n\t\"password-store\": \"basic\"\n}\n")
    else:
        with open(p, "r") as f:
            content = f.read()
        if "password-store" not in content:
            idx = content.rfind("}")
            if idx != -1:
                pre = content[:idx].rstrip()
                if not pre.endswith(",") and not pre.endswith("{"):
                    pre += ","
                new_content = pre + "\n\t\"password-store\": \"basic\"\n" + content[idx:]
                with open(p, "w") as f:
                    f.write(new_content)
' 2>/dev/null || true
}

install_vscode() {
  wget 'https://go.microsoft.com/fwlink/?LinkID=760868' -O /tmp/vscode.deb
  chmod +x /tmp/vscode.deb
  sudo apt install /tmp/vscode.deb -y
  rm -f /tmp/vscode.deb
  configure_vscode_password_store
}

install_antigravity() {
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
}

install_opencode() {
  printf "%b\n" "${GREEN}✓ Instalando OpenCode CLI...${NC}"
  curl -fsSL https://opencode.ai/v2/install | bash
  printf "%b\n" "${GREEN}✓ Instalando OpenCode Desktop...${NC}"
  wget https://opencode.ai/files/bin/2.0.6/opencode-desktop-linux-amd64.deb -O /tmp/opencode-desktop.deb
  chmod +x /tmp/opencode-desktop.deb
  sudo apt install /tmp/opencode-desktop.deb -y
  rm -f /tmp/opencode-desktop.deb
}

install_brave() {
  curl -fsS https://dl.brave.com/install.sh | sh
}

install_vencord() {
  sh -c "$(curl -sS https://vencord.dev/install.sh)"

  local themes_dir="$HOME/.var/app/com.discordapp.Discord/config/Vencord/themes"
  mkdir -p "$themes_dir"

  printf "%b\n" "${GREEN}✓ Descargando temas para Vencord...${NC}"
  if curl -fsSL "https://drive.google.com/uc?export=download&id=1JmvCy4Yh-L6t1_pyVrMdowZNHvaIe1iW" -o "$themes_dir/Transparent.theme.css" && \
     curl -fsSL "https://betterdiscord.app/download?id=40" -o "$themes_dir/FrostedGlass.theme.css"; then
    printf "%b\n" "${GREEN}✓ Temas instalados correctamente en $themes_dir${NC}"
  else
    printf "%b\n" "${YELLOW}⚠ Ocurrió un problema al descargar los temas para Vencord.${NC}"
  fi
}

configure_spotify_kde_transparency() {
  printf "%b\n" "${GREEN}✓ Configurando regla de transparencia (90%) para Spotify en KDE Plasma...${NC}"
  python3 -c '
import configparser, os, uuid

path = os.path.expanduser("~/.config/kwinrulesrc")
os.makedirs(os.path.dirname(path), exist_ok=True)
config = configparser.RawConfigParser()
config.optionxform = str

if os.path.exists(path):
    config.read(path, encoding="utf-8")

target_sec = None
for sec in config.sections():
    if sec != "General":
        if (config.has_option(sec, "wmclass") and "spotify" in config.get(sec, "wmclass").lower()) or \
           (config.has_option(sec, "Description") and "spotify" in config.get(sec, "Description").lower()):
            target_sec = sec
            break

if not target_sec:
    target_sec = str(uuid.uuid4())
    config.add_section(target_sec)
    config.set(target_sec, "Description", "Spotify Transparente")
    config.set(target_sec, "wmclass", "spotify")
    config.set(target_sec, "wmclassmatch", "1")
    
    if not config.has_section("General"):
        config.add_section("General")
    
    current_rules = config.get("General", "rules", fallback="").strip()
    rule_list = [r.strip() for r in current_rules.split(",") if r.strip()]
    if target_sec not in rule_list:
        rule_list.append(target_sec)
    config.set("General", "rules", ",".join(rule_list))
    config.set("General", "count", str(len(rule_list)))

config.set(target_sec, "opacityactive", "90")
config.set(target_sec, "opacityactiverule", "2")
config.set(target_sec, "opacityinactive", "90")
config.set(target_sec, "opacityinactiverule", "2")

with open(path, "w", encoding="utf-8") as f:
    config.write(f)
' 2>/dev/null || true

  dbus-send --session --dest=org.kde.KWin /KWin org.kde.KWin.reconfigure 2>/dev/null || \
  qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
}

install_spicetify() {
  printf "%b\n" "${GREEN}✓ Instalando Spicetify CLI...${NC}"
  curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

  export PATH="$HOME/.spicetify:$PATH"
  if ! grep -q "$HOME/.spicetify" ~/.bashrc 2>/dev/null; then
    echo 'export PATH="$HOME/.spicetify:$PATH"' >> ~/.bashrc
  fi

  printf "%b\n" "${GREEN}✓ Instalando Spicetify Marketplace...${NC}"
  curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh

  # Buscar la ruta de Spotify Flatpak (sistema o usuario)
  local spotify_path=""
  if [ -d "/var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify" ]; then
    spotify_path="/var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify"
  elif [ -d "$HOME/.local/share/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify" ]; then
    spotify_path="$HOME/.local/share/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify"
  fi

  if [ -n "$spotify_path" ]; then
    printf "%b\n" "${GREEN}✓ Ajustando permisos e integrando con Spotify Flatpak...${NC}"
    sudo chmod a+wr "$spotify_path" 2>/dev/null || true
    sudo chmod a+wr -R "$spotify_path/Apps" 2>/dev/null || true
    sudo chmod a+wr -R "$spotify_path/apps" 2>/dev/null || true

    local prefs_path="$HOME/.var/app/com.spotify.Client/config/spotify/prefs"

    if [ -f "$HOME/.spicetify/spicetify" ]; then
      "$HOME/.spicetify/spicetify" config spotify_path "$spotify_path" 2>/dev/null || true
      "$HOME/.spicetify/spicetify" config prefs_path "$prefs_path" 2>/dev/null || true
      sudo flatpak override --filesystem="$HOME/.config/spicetify" com.spotify.Client 2>/dev/null || true
      sudo flatpak override --filesystem="$HOME/.spicetify" com.spotify.Client 2>/dev/null || true
      "$HOME/.spicetify/spicetify" backup apply 2>/dev/null || "$HOME/.spicetify/spicetify" apply 2>/dev/null || true
    fi
  else
    printf "%b\n" "${YELLOW}⚠ Nota: No se detectó Spotify instalado mediante Flatpak. Si usas Spotify de apt/snap, Spicetify se configurará automáticamente al ejecutarlo.${NC}"
  fi

  configure_spotify_kde_transparency
}


install_lmstudio() {
  curl -fsSL https://lmstudio.ai/install.sh | bash
}

install_tlauncher() {
  printf "%b\n" "${GREEN}✓ Descargando TLauncher...${NC}"
  sudo apt install unzip openjdk-17-jdk -y 2>/dev/null || true
  wget -U "Mozilla/5.0 (X11; Linux x86_64)" "https://tlauncher.org/jar" -O /tmp/TLauncher.zip
  if [ -f /tmp/TLauncher.zip ]; then
    rm -rf /tmp/tlauncher_extract
    mkdir -p /tmp/tlauncher_extract
    unzip -q /tmp/TLauncher.zip -d /tmp/tlauncher_extract
    sudo mkdir -p /opt/tlauncher

    local jar_file=$(find /tmp/tlauncher_extract -maxdepth 2 -name "*.jar" | head -n 1)
    if [ -n "$jar_file" ]; then
      sudo mv "$jar_file" /opt/tlauncher/TLauncher.jar
    fi
    rm -rf /tmp/tlauncher_extract /tmp/TLauncher.zip

    sudo tee /usr/local/bin/tlauncher > /dev/null <<'EOF'
#!/bin/bash
java -jar /opt/tlauncher/TLauncher.jar "$@"
EOF
    sudo chmod +x /usr/local/bin/tlauncher

    sudo tee /usr/share/applications/tlauncher.desktop > /dev/null <<'EOF'
[Desktop Entry]
Name=TLauncher
Comment=Minecraft Launcher
Exec=java -jar /opt/tlauncher/TLauncher.jar
Icon=utilities-terminal
Type=Application
Categories=Game;
EOF
    sudo update-desktop-database /usr/share/applications 2>/dev/null || true
    printf "%b\n" "${GREEN}✓ TLauncher instalado correctamente en /opt/tlauncher/TLauncher.jar.${NC}"
  else
    printf "%b\n" "${RED}✗ Error al descargar TLauncher.${NC}"
  fi
}

install_onlyoffice() {
  wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb -O /tmp/onlyoffice.deb
  chmod +x /tmp/onlyoffice.deb
  sudo apt install /tmp/onlyoffice.deb -y
  rm -f /tmp/onlyoffice.deb
}

open_wallpaper_tutorial() {
  xdg-open "https://youtu.be/4ZAeVub9a2I?si=pEChx449ZNi3M3bD&t=549" 2>/dev/null || printf "%b\n" "${RED}⚠ No se pudo abrir el navegador automáticamente. Abre el link manualmente: https://youtu.be/4ZAeVub9a2I?si=pEChx449ZNi3M3bD&t=549${NC}"
}

# ==========================================================
# 1. ACTUALIZACIÓN DEL SISTEMA Y GESTIÓN DE PAQUETES
# ==========================================================
print_section "Actualización del Sistema y Gestores de Paquetes"

prompt_install "actualizar la lista de paquetes (apt update)" sudo apt update
prompt_install "actualizar los paquetes instalados (apt upgrade)" sudo apt upgrade -y
prompt_install "instalar Flatpak" sudo apt install flatpak -y
prompt_install "agregar repositorio Flathub" sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
prompt_install "instalar Fastfetch" sudo apt install fastfetch -y

# ==========================================================
# 2. DESARROLLO & TERMINAL
# ==========================================================
print_section "Desarrollo & Terminal"

prompt_install "instalar Java (OpenJDK 17)" sudo apt install openjdk-17-jdk -y
prompt_install "instalar .NET SDK (dotnet)" install_dotnet
prompt_install "instalar Git" sudo apt install git -y
prompt_install "instalar GitHub CLI (gh)" sudo apt install gh -y
prompt_install "instalar JQ (procesador JSON)" sudo apt install jq -y
prompt_install "instalar Vim" sudo apt install vim -y
prompt_install "instalar Htop" sudo apt install htop -y
prompt_install "instalar Btop" sudo apt install btop -y
prompt_install "instalar Postman" install_postman
prompt_install "instalar Node.js y npm (LTS)" install_nodejs
prompt_install "instalar Docker y Docker Compose" install_docker
prompt_install "instalar Visual Studio Code" install_vscode
prompt_install "instalar Antigravity" install_antigravity
prompt_install "instalar OpenCode (CLI y Desktop)" install_opencode

# ==========================================================
# 3. NAVEGADORES WEB
# ==========================================================
print_section "Navegadores Web"

prompt_install "instalar Brave Browser" install_brave
prompt_install "instalar Vivaldi" flatpak install -y flathub com.vivaldi.Vivaldi
prompt_install "instalar Zen Browser" flatpak install -y flathub app.zen_browser.zen

# ==========================================================
# 4. COMUNICACIÓN & SOCIAL
# ==========================================================
print_section "Comunicación & Social"

prompt_install "instalar Discord" flatpak install -y flathub com.discordapp.Discord
prompt_install "instalar Vencord" install_vencord
prompt_install "instalar Teams for Linux" flatpak install -y flathub com.github.IsmaelMartinez.teams_for_linux

# ==========================================================
# 5. MULTIMEDIA, JUEGOS & IA
# ==========================================================
print_section "Multimedia, Juegos & IA"

prompt_install "instalar Spotify" flatpak install -y flathub com.spotify.Client
prompt_install "instalar Spicetify (CLI & Marketplace para Spotify)" install_spicetify
prompt_install "instalar OBS Studio" flatpak install -y flathub com.obsproject.Studio
prompt_install "instalar Pinta (edición de imágenes)" flatpak install flathub com.github.PintaProject.Pinta -y
prompt_install "instalar Draw.io" flatpak install -y flathub com.jgraph.drawio.desktop
prompt_install "instalar LM Studio" install_lmstudio
prompt_install "instalar Steam" sudo apt install steam -y
prompt_install "instalar TLauncher" install_tlauncher

# ==========================================================
# 6. OFIMÁTICA & HERRAMIENTAS
# ==========================================================
print_section "Ofimática & Herramientas"

prompt_install "instalar OnlyOffice" install_onlyoffice
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

prompt_install "abrir el tutorial de Wallpaper Engine en el navegador" open_wallpaper_tutorial

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
