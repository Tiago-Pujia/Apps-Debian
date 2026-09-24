# 🐧 Apps Debian / Ubuntu - Post-Installation Setup Script

Un script interactivo en Bash diseñado para automatizar la configuración inicial, actualización y la instalación de software esencial en distribuciones **Debian**, **Ubuntu** y derivadas (Kubuntu, Linux Mint, Pop!_OS, etc.).

---

## 🌟 Características Principales

- 🛠️ **Interactivo**: Permite confirmar (`Y/y`) o omitir (`N/n`) cada paquete de forma individual.
- 📦 **Multi-Gestor**: Soporta instalaciones nativas mediante `apt`, paquetes `Flatpak` (Flathub), `Snap` y paquetes `.deb` descargados automáticamente.
- 🎨 **Estética Visual**: Salida en terminal con colores ANSI y resumen del sistema al finalizar mediante `fastfetch`.
- 🖼️ **Soporte KDE**: Incluye guía paso a paso para configurar **Wallpaper Engine** en escritorios KDE mediante el plugin Waywallen.

---

## 📦 Software Incluido

### 🔧 Desarrollo & Terminal
- **Java (OpenJDK 17)**: Kit de desarrollo Java.
- **Git & GitHub CLI (`gh`)**: Control de versiones e integración con GitHub.
- **Node.js (LTS) & npm**: Entorno de ejecución JavaScript vía NodeSource.
- **Docker & Docker Compose**: Plataforma de contenedores oficial (con asignación de grupo al usuario).
- **OpenCode (CLI & Desktop)**: Editor y herramientas asistidas por IA.
- **Antigravity**: Instalación manual vía Tarball en `/opt/antigravity` con launcher `.desktop` e icono de app.
- **Visual Studio Code**: Editor de código fuente oficial de Microsoft.
- **Postman**: Plataforma de pruebas API (vía Snap).
- **JQ**: Procesador JSON para línea de comandos.
- **Vim, Htop, Btop**: Edición de texto y monitoreo de recursos del sistema.

### 🌐 Navegadores Web
- **Brave Browser**
- **Vivaldi**
- **Zen Browser** (Flatpak)

### 💬 Comunicación & Social
- **Discord** (Flatpak) + **Vencord** (Instalador cliente)
- **Teams for Linux** (Flatpak)

### 🎵 Multimedia, Juegos & Diseño
- **Spotify** (Flatpak)
- **Spicetify**: Personalizador visual y de temas/extensiones para Spotify (CLI & Marketplace).
- **Steam**
- **OBS Studio** (Flatpak)
- **Pinta** (Edición gráfica en Flatpak)
- **Draw.io** (Diagramación en Flatpak)
- **LM Studio** (Ejecución de modelos de IA locales)
- **TLauncher** (Launcher de Minecraft)

### 📄 Ofimática & Herramientas
- **Obsidian**: Notas y gestión del conocimiento en Markdown (Flatpak).
- **OnlyOffice Desktop Editors** (Alternativa a LibreOffice)
- **Mousepad** (Editor de texto liviano)
- **FileZilla** (Cliente FTP)
- **GitHub Desktop** (Flatpak)

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

---

## 📜 Licencia

Este proyecto está disponible de forma pública para ser usado y modificado según tus necesidades.
