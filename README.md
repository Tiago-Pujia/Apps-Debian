# 🐧 Apps Debian / Ubuntu - Post-Installation Setup Script

Un script interactivo en Bash diseñado para automatizar la configuración inicial, actualización y la instalación de software esencial en distribuciones **Debian**, **Ubuntu** y sus derivados.

---

## 📦 Software Incluido

### 🔧 Desarrollo & Terminal
- **Java (OpenJDK 17)**
- **.NET SDK (`dotnet`)**
- **Git & GitHub CLI (`gh`)**
- **Node.js (LTS) & npm**
- **Docker & Docker Compose**
- **OpenCode (CLI & Desktop)**
- **Antigravity**
- **Visual Studio Code**
- **Postman**
- **JQ**
- **Vim, Htop, Btop**

### 🌐 Navegadores Web
- **Brave Browser**
- **Vivaldi**
- **Zen Browser**

### 💬 Comunicación & Social
- **Discord** + **Vencord**
- **Teams for Linux**

### 🎵 Multimedia, Juegos & Diseño
- **Spotify** + **Spicetify**
- **Steam**
- **OBS Studio**
- **Pinta**
- **Draw.io**
- **LM Studio**
- **TLauncher**

### 📄 Ofimática & Herramientas
- **Obsidian**
- **OnlyOffice Desktop Editors**
- **Mousepad**
- **FileZilla**
- **GitHub Desktop**

---

## 🚀 Uso e Instalación

1. **Clonar el repositorio**:
   ```bash
   git clone git@github.com:Tiago-Pujia/Apps-Debian.git
   cd "Apps-Debian"
   ```

2. **Asignar permisos de ejecución**:
   ```bash
   chmod +x "apps debian.sh"
   ```

3. **Ejecutar el script**:
   ```bash
   ./"apps debian.sh"
   ```
   *o alternativamente:*
   ```bash
   bash "apps debian.sh"
   ```

---

## 🧹 Limpieza y Optimización

Al finalizar las instalaciones, el script opcionalmente:
- Desinstala LibreOffice preinstalado (`apt-get remove --purge libreoffice*`).
- Ejecuta la limpieza de caché de paquetes (`sudo apt clean`).
- Remueve paquetes huérfanos innecesarios (`sudo apt autoremove`).
- Muestra el informe de hardware del sistema utilizando `fastfetch`.