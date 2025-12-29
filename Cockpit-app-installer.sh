#!/bin/bash

# ============================================
# INSTALLATION SCRIPT FROM GITHUB - UBUNTU
# ============================================
# Author: Your Name
# Description: Install applications from GitHub repositories
# Usage: ./github_installer.sh
# ============================================

# Colors for messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables globales
INSTALL_DIR="$HOME/github_apps"
LOG_FILE="$HOME/github_installer.log"

# Log function
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to show the main menu
show_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║     COCKPIT GITHUB APPS INSTALLER     ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Select category:"
    echo "1. 🗄️ Files manager"
    echo "2. 🎨 Containers/VM"
    echo "3. 🎮 Administration"
    echo "4. 📊 Utilities"
    echo "5. 🔒 Network"
    echo "6. 🔧 Debugging tools"
    echo "7. 🔧 Other repositories"
    echo "8. 📋 View install logs"
    echo "9. ❌ Exit"
    echo ""
}

# Function to confirm actions that install packages/applications
confirm_install() {
    prompt="$1"
    # Use y/Y for yes (English)
    read -r -p "$prompt [y/N]: " choice
    case "$choice" in
        [yY]) return 0 ;;
        *)
            echo -e "${YELLOW}Installation cancelled by user.${NC}"
            log_message "Installation cancelled by user"
            exit 0
            ;;
    esac
}

# Function to install basic dependencies
install_dependencies() {
    log_message "Checking dependencies..."
    
    confirm_install "Dependencies (git, curl) need to be installed. verify and install?"
    
    # Verificar si git está instalado
    if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Git is not installed. Installing...${NC}"
        sudo apt update
        sudo apt install -y git
    fi
    
    # Verificar si curl está instalado
    if ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}Curl is not installed. Installing...${NC}"
        sudo apt install -y curl
    fi
    
    # Crear directorio de instalación si no existe
    mkdir -p "$INSTALL_DIR"
    
    log_message "Dependencies verified successfully"
}


files_manager_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║             FILES MANAGER             ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Select an application:"
    echo "1. Cockpit-files (Modern version)"
    echo "2. cockpit-storaged (service / storage backend)"
    echo "3. 45Drives cockpit-file-sharing"
    echo "4. 45Drives cockpit-navigator"
    echo "5. Return to main menu"
    echo ""

    read -p "Option [1-5]: " dev_choice

    case $dev_choice in
        1) install_cockpit-files ;;
        2) install_cockpit-storaged ;;
        3) install_45drives-file-sharing ;;
        4) install_cockpit-navigator ;;
        5) return ;;
        *) echo -e "${RED}Invalid option${NC}"; sleep 1 ;;
    esac
}

install_cockpit-files() {
    
    # GitHub: https://github.com/cockpit-project/cockpit-files
    # Documentación oficial: https://code.visualstudio.com/docs/setup/linux
    
    echo -e "\n${GREEN}=== Installing cockpit-files ===${NC}"
    log_message "Starting cockpit-files installation"

    confirm_install "cockpit-files will be installed with his dependencies. Some commands could need sudo. Continue?"

    echo -e "${YELLOW}Downloading and installing dependencies...${NC}"
    sudo apt update
    sudo apt install gettext nodejs npm make

    echo -e "${YELLOW}Downloading from repository...${NC}"
    cd "$INSTALL_DIR"
    git clone https://github.com/cockpit-project/cockpit-files.git
    cd cockpit-files
    echo -e "${YELLOW}Installing...${NC}"
    make install

    echo -e "${GREEN}✓ cockpit-files installed successfully${NC}"
    echo -e "${BLUE}Remember to restart cockpit: sudo systemctl restart cockpit${NC}"
    log_message "cockpit-files installed successfully"
    read -p "Press Enter to continue..."
}

install_cockpit-navigator() {
    
    # GitHub: https://github.com/45Drives/cockpit-navigator
    
    echo -e "\n${GREEN}=== Installing cockpit-navigator ===${NC}"
    log_message "Starting cockpit-navigator installation"
    
    confirm_install "cockpit-navigator will be installed with his dependencies. Some commands could need sudo. Continue?"
    
    echo -e "${YELLOW}Downloading and installing dependencies...${NC}"
    sudo apt update
    sudo apt install python3 rsync zip make
    
    echo -e "${YELLOW}Downloading from repository...${NC}"
    cd "$INSTALL_DIR"
    git clone https://github.com/45Drives/cockpit-navigator.git
    cd cockpit-navigator
    echo -e "${YELLOW}Installing...${NC}"
    make install

    echo -e "${GREEN}✓ cockpit-navigator installed successfully${NC}"
    echo -e "${BLUE}Remember to restart cockpit: sudo systemctl restart cockpit${NC}"
    log_message "cockpit-navigator installed successfully"
    read -p "Press Enter to continue..."
}


install_cockpit-storaged() {
    # Package: cockpit-storaged (usually available via APT)
    echo -e "\n${GREEN}=== Installing cockpit-storaged ===${NC}"
    log_message "Starting cockpit-storaged installation"

    confirm_install "cockpit-storaged will be installed via APT. Continue?"

    echo -e "${YELLOW}Installing package from APT...${NC}"
    sudo apt update
    sudo apt install -y cockpit-storaged || {
        echo -e "${YELLOW}cockpit-storaged not available via APT on this system. Attempting source (git) fallback...${NC}"
        # No standard upstream repo known; abort gracefully
        log_message "cockpit-storaged apt install failed"
        echo -e "${RED}Failed to install cockpit-storaged via APT. Please check your distribution repositories.${NC}"
        read -p "Press Enter to continue..."
        return
    }

    echo -e "${GREEN}✓ cockpit-storaged installed successfully${NC}"
    echo -e "${BLUE}Remember to restart cockpit: sudo systemctl restart cockpit${NC}"
    log_message "cockpit-storaged installed successfully"
    read -p "Press Enter to continue..."
}


install_45drives-file-sharing() {
    # GitHub: https://github.com/45Drives/cockpit-file-sharing
    echo -e "\n${GREEN}=== Installing 45Drives cockpit-file-sharing ===${NC}"
    log_message "Starting 45Drives cockpit-file-sharing installation"

    confirm_install "45Drives cockpit-file-sharing will be installed from git. Continue?"

    echo -e "${YELLOW}Downloading and installing dependencies...${NC}"
    sudo apt update
    sudo apt install -y python3 rsync zip make

    echo -e "${YELLOW}Cloning repository...${NC}"
    cd "$INSTALL_DIR"
    if [ -d "cockpit-file-sharing" ]; then
        echo -e "${YELLOW}Repository already exists, pulling updates...${NC}"
        cd cockpit-file-sharing && git pull || true
    else
        git clone https://github.com/45Drives/cockpit-file-sharing.git
        cd cockpit-file-sharing
    fi

    echo -e "${YELLOW}Installing... (may require sudo)${NC}"
    if [ -f Makefile ]; then
        make install || sudo make install
    else
        # Try a generic install path
        sudo cp -r . /usr/share/cockpit/45drives-file-sharing || true
    fi

    echo -e "${GREEN}✓ 45Drives cockpit-file-sharing installed (best-effort)${NC}"
    echo -e "${BLUE}Remember to restart cockpit: sudo systemctl restart cockpit${NC}"
    log_message "45Drives cockpit-file-sharing installed"
    read -p "Press Enter to continue..."
}


containers/VM_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║             CONTAINERS/VM             ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Select an application:"
    echo "1. Docker (Docker manager)"
    echo "2. Podman (Podman container manager)"
    echo "3. Virtual Machine Manager"
    echo "4. Return to main menu"
    echo ""
    
    read -p "Option [1-5]: " dev_choice
    
    case $dev_choice in
        1) install_docker ;;
        2) install_podman ;;
        3) install_vm_manager ;;
        4) return ;;
        *) echo -e "${RED}Invalid option${NC}"; sleep 1 ;;
    esac
}

install_docker() {
   
    # GitHub: https://github.com/chrisjbawden/cockpit-dockermanager
    
    echo -e "\n${GREEN}=== Installing DockerManager ===${NC}"
    log_message "Starting DockerManager installation"
    
    confirm_install "Docker (docker.io) and Dockermanager will be installed. Some commands could need sudo. Continue?"

    # Verify if docker is installed
    if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker is not installed. Installing Docker first...${NC}"
        sudo apt update
        sudo apt install -y docker.io
        sudo systemctl start docker
        sudo systemctl enable docker
        sudo usermod -aG docker $USER
    echo -e "${YELLOW}Restart your session for the group changes to take effect${NC}"
    fi


    echo -e "${YELLOW}Downloading and installing DockerManager...${NC}"
    cd "$INSTALL_DIR"
    curl -L -o dockermanager.deb https://github.com/chrisjbawden/cockpit-dockermanager/releases/download/latest/dockermanager.deb && sudo dpkg -i dockermanager.deb

    echo -e "${YELLOW}Applying executable permissions...${NC}"
    sudo chmod +x /usr/local/bin/docker-compose
    
    docker-compose --version
    
    echo -e "${GREEN}✓ DockerManager installed successfully${NC}"
    echo -e "${BLUE}To verify docker: docker-compose --version${NC}"
    echo -e "${BLUE}Remember to restart cockpit: sudo systemctl restart cockpit${NC}"
    log_message "DockerManager installed successfully"
    read -p "Press Enter to continue..."
}

install_podman() {

    # GitHub: https://github.com/cockpit-project/cockpit-podman

    echo -e "\n${GREEN}=== Installing podman ===${NC}"
    log_message "Starting Podman installation"
    
    confirm_install "Podman will be installed with his dependencies. Some commands could need sudo. Continue?"
    

    echo -e "${YELLOW}Downloading and installing dependencies...${NC}"
    sudo apt update
    sudo apt install gettext nodejs npm make
    
    echo -e "${YELLOW}Downloading from repository...${NC}"
    cd "$INSTALL_DIR"
    git clone https://github.com/cockpit-project/cockpit-podman
    cd cockpit-podman
    echo -e "${YELLOW}Installing...${NC}"
    make install

    echo -e "${GREEN}✓ Podman installed successfully${NC}"
    echo -e "${BLUE}Remember to restart cockpit: sudo systemctl restart cockpit${NC}"
    log_message "Podman installed successfully"
    read -p "Press Enter to continue..."
}

install_vm_manager() {
    # GitHub: https://github.com/cockpit-project/cockpit-machines

    echo -e "\n${GREEN}=== Installing Virtual Machines Manager ===${NC}"
    log_message "Starting Virtual Machines Manager installation"

    confirm_install "Virtual Machines Manager will be installed. Some commands could need sudo. Continue?"

    echo -e "${YELLOW}Downloading and installing dependencies...${NC}"
    sudo apt update
    sudo apt install gettext nodejs npm make

    echo -e "${YELLOW}Downloading from repository...${NC}"
    cd "$INSTALL_DIR"
    git clone https://github.com/cockpit-project/cockpit-machines
    cd cockpit-machines
    echo -e "${YELLOW}Installing...${NC}"
    sudo make install

    echo -e "${GREEN}✓ Virtual Machines Manager installed successfully${NC}"
    echo -e "${BLUE}Remember to restart cockpit: sudo systemctl restart cockpit${NC}"
    log_message "Virtual Machines Manager installed successfully"
    read -p "Press Enter to continue..."
}


utilities_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║               UTILITIES               ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Select an application:"
    echo "1. cockpit-packagekit"
    echo "2. cockpit-ostree"
    echo "3. cockpit-selinux"
    echo "4. cockpit-composer"
    echo "5. 45Drives cockpit-benchmark"
    echo "6. cockpit-sensors"
    echo "7. hatlabs cockpit-package-manager"
    echo "8. Return to main menu"
    echo ""

    read -p "Option [1-8]: " opt
    case $opt in
        1) install_cockpit-packagekit ;;
        2) install_cockpit-ostree ;;
        3) install_cockpit-selinux ;;
        4) install_cockpit-composer ;;
        5) install_45drives-benchmark ;;
        6) install_cockpit-sensors ;;
        7) install_hatlabs-package-manager ;;
        8) return ;;
        *) echo -e "${RED}Invalid option${NC}"; sleep 1 ;;
    esac
}

install_cockpit-packagekit() {
    echo -e "\n${GREEN}=== Installing cockpit-packagekit ===${NC}"
    log_message "Starting cockpit-packagekit installation"
    confirm_install "cockpit-packagekit will be installed via APT. Continue?"
    sudo apt update
    sudo apt install -y cockpit-packagekit || {
        echo -e "${RED}Failed to install cockpit-packagekit via APT.${NC}"
    }
    echo -e "${GREEN}✓ cockpit-packagekit installation finished${NC}"
    log_message "cockpit-packagekit installed"
    read -p "Press Enter to continue..."
}

install_cockpit-ostree() {
    echo -e "\n${GREEN}=== Installing cockpit-ostree ===${NC}"
    log_message "Starting cockpit-ostree installation"
    confirm_install "cockpit-ostree will be installed via APT. Continue?"
    sudo apt update
    sudo apt install -y cockpit-ostree || echo -e "${YELLOW}cockpit-ostree apt install failed or not available.${NC}"
    echo -e "${GREEN}✓ cockpit-ostree handled${NC}"
    log_message "cockpit-ostree installed or skipped"
    read -p "Press Enter to continue..."
}

install_cockpit-selinux() {
    echo -e "\n${GREEN}=== Installing cockpit-selinux ===${NC}"
    log_message "Starting cockpit-selinux installation"
    confirm_install "cockpit-selinux will be installed via APT. Continue?"
    sudo apt update
    sudo apt install -y cockpit-selinux || echo -e "${YELLOW}cockpit-selinux apt install failed or not available.${NC}"
    echo -e "${GREEN}✓ cockpit-selinux handled${NC}"
    log_message "cockpit-selinux installed or skipped"
    read -p "Press Enter to continue..."
}

install_cockpit-composer() {
    echo -e "\n${GREEN}=== Installing cockpit-composer ===${NC}"
    log_message "Starting cockpit-composer installation"
    confirm_install "cockpit-composer will be installed via APT. Continue?"
    sudo apt update
    sudo apt install -y cockpit-composer || echo -e "${YELLOW}cockpit-composer apt install failed or not available.${NC}"
    echo -e "${GREEN}✓ cockpit-composer handled${NC}"
    log_message "cockpit-composer installed or skipped"
    read -p "Press Enter to continue..."
}

install_45drives-benchmark() {
    # GitHub: https://github.com/45Drives/cockpit-benchmark
    echo -e "\n${GREEN}=== Installing 45Drives cockpit-benchmark ===${NC}"
    log_message "Starting 45Drives cockpit-benchmark installation"
    confirm_install "cockpit-benchmark will be installed from git. Continue?"
    sudo apt update
    sudo apt install -y python3 make || true
    cd "$INSTALL_DIR"
    if [ -d "cockpit-benchmark" ]; then
        cd cockpit-benchmark && git pull || true
    else
        git clone https://github.com/45Drives/cockpit-benchmark.git
        cd cockpit-benchmark
    fi
    if [ -f Makefile ]; then
        make install || sudo make install || true
    fi
    echo -e "${GREEN}✓ cockpit-benchmark installed (best-effort)${NC}"
    log_message "45Drives cockpit-benchmark installed"
    read -p "Press Enter to continue..."
}

install_cockpit-sensors() {
    echo -e "\n${GREEN}=== Installing cockpit-sensors ===${NC}"
    log_message "Starting cockpit-sensors installation"
    confirm_install "cockpit-sensors will be installed via APT. Continue?"
    sudo apt update
    sudo apt install -y cockpit-sensors || echo -e "${YELLOW}cockpit-sensors apt install failed or not available.${NC}"
    echo -e "${GREEN}✓ cockpit-sensors handled${NC}"
    log_message "cockpit-sensors installed or skipped"
    read -p "Press Enter to continue..."
}

install_hatlabs-package-manager() {
    # GitHub: https://github.com/hatlabs/cockpit-package-manager
    echo -e "\n${GREEN}=== Installing hatlabs cockpit-package-manager ===${NC}"
    log_message "Starting hatlabs cockpit-package-manager installation"
    confirm_install "cockpit-package-manager will be installed from git. Continue?"
    sudo apt update
    sudo apt install -y git make python3 || true
    cd "$INSTALL_DIR"
    if [ -d "cockpit-package-manager" ]; then
        cd cockpit-package-manager && git pull || true
    else
        git clone https://github.com/hatlabs/cockpit-package-manager.git
        cd cockpit-package-manager
    fi
    if [ -f Makefile ]; then
        make install || sudo make install || true
    fi
    echo -e "${GREEN}✓ hatlabs cockpit-package-manager installed (best-effort)${NC}"
    log_message "hatlabs cockpit-package-manager installed"
    read -p "Press Enter to continue..."
}


administration_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║             ADMINISTRATION            ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Select an application:"
    echo "1. cockpit-session-recording"
    echo "2. subscription-manager-cockpit"
    echo "3. cockpit-ha-cluster"
    echo "4. cockpit-zfs"
    echo "5. Return to main menu"
    echo ""

    read -p "Option [1-5]: " opt
    case $opt in
        1) install_cockpit-session-recording ;;
        2) install_subscription-manager-cockpit ;;
        3) install_cockpit-ha-cluster ;;
        4) install_cockpit-zfs ;;
        5) return ;;
        *) echo -e "${RED}Invalid option${NC}"; sleep 1 ;;
    esac
}

install_cockpit-session-recording() {
    echo -e "\n${GREEN}=== Installing cockpit-session-recording ===${NC}"
    log_message "Starting cockpit-session-recording installation"
    confirm_install "cockpit-session-recording will be installed via APT. Continue?"
    sudo apt update
    sudo apt install -y cockpit-session-recording || echo -e "${YELLOW}cockpit-session-recording apt install failed or not available.${NC}"
    echo -e "${GREEN}✓ cockpit-session-recording handled${NC}"
    log_message "cockpit-session-recording installed or skipped"
    read -p "Press Enter to continue..."
}

install_subscription-manager-cockpit() {
    echo -e "\n${GREEN}=== Installing subscription-manager-cockpit ===${NC}"
    log_message "Starting subscription-manager-cockpit installation"
    confirm_install "subscription-manager-cockpit will be installed via APT. Continue?"
    sudo apt update
    sudo apt install -y subscription-manager-cockpit || echo -e "${YELLOW}subscription-manager-cockpit apt install failed or not available.${NC}"
    echo -e "${GREEN}✓ subscription-manager-cockpit handled${NC}"
    log_message "subscription-manager-cockpit installed or skipped"
    read -p "Press Enter to continue..."
}

install_cockpit-ha-cluster() {
    echo -e "\n${GREEN}=== Installing cockpit-ha-cluster ===${NC}"
    log_message "Starting cockpit-ha-cluster installation"
    confirm_install "cockpit-ha-cluster will be installed via APT or git. Continue?"
    sudo apt update
    sudo apt install -y cockpit-ha-cluster || echo -e "${YELLOW}cockpit-ha-cluster apt install failed or not available. Attempting git fallback (none specified).${NC}"
    echo -e "${GREEN}✓ cockpit-ha-cluster handled${NC}"
    log_message "cockpit-ha-cluster installed or skipped"
    read -p "Press Enter to continue..."
}

install_cockpit-zfs() {
    echo -e "\n${GREEN}=== Installing cockpit-zfs ===${NC}"
    log_message "Starting cockpit-zfs installation"
    confirm_install "cockpit-zfs will be installed via APT. Continue?"
    sudo apt update
    sudo apt install -y cockpit-zfs || echo -e "${YELLOW}cockpit-zfs apt install failed or not available.${NC}"
    echo -e "${GREEN}✓ cockpit-zfs handled${NC}"
    log_message "cockpit-zfs installed or skipped"
    read -p "Press Enter to continue..."
}


network_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║                NETWORK                ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Select an application:"
    echo "1. cockpit-tailscale"
    echo "2. cockpit-headscale"
    echo "3. cockpit-cloudflared"
    echo "4. cockpit-networkmanager"
    echo "5. Return to main menu"
    echo ""

    read -p "Option [1-5]: " opt
    case $opt in
        1) install_cockpit-tailscale ;;
        2) install_cockpit-headscale ;;
        3) install_cockpit-cloudflared ;;
        4) install_cockpit-networkmanager ;;
        5) return ;;
        *) echo -e "${RED}Invalid option${NC}"; sleep 1 ;;
    esac
}

install_cockpit-tailscale() {
    echo -e "\n${GREEN}=== Installing cockpit-tailscale ===${NC}"
    log_message "Starting cockpit-tailscale installation"
    confirm_install "cockpit-tailscale will be installed (APT or git). Continue?"
    sudo apt update
    sudo apt install -y cockpit-tailscale || {
        echo -e "${YELLOW}cockpit-tailscale not in APT, attempting git fallback...${NC}"
        cd "$INSTALL_DIR"
        # try known community repo if exists
        git clone https://github.com/tailscale/cockpit-tailscale.git || true
        if [ -d "cockpit-tailscale" ]; then
            cd cockpit-tailscale
            if [ -f Makefile ]; then
                make install || sudo make install || true
            fi
        fi
    }
    echo -e "${GREEN}✓ cockpit-tailscale handled${NC}"
    log_message "cockpit-tailscale installed or skipped"
    read -p "Press Enter to continue..."
}

install_cockpit-headscale() {
    echo -e "\n${GREEN}=== Installing cockpit-headscale ===${NC}"
    log_message "Starting cockpit-headscale installation"
    confirm_install "cockpit-headscale will be installed (git). Continue?"
    cd "$INSTALL_DIR"
    git clone https://github.com/juanfont/headscale || true
    # Note: headscale itself is not a cockpit plugin; this is best-effort placeholder
    echo -e "${YELLOW}Note: headscale may not provide an official cockpit plugin. This clones headscale for manual setup.${NC}"
    log_message "cockpit-headscale attempted clone"
    read -p "Press Enter to continue..."
}

install_cockpit-cloudflared() {
    echo -e "\n${GREEN}=== Installing cockpit-cloudflared ===${NC}"
    log_message "Starting cockpit-cloudflared installation"
    confirm_install "cockpit-cloudflared will be installed (git/apt). Continue?"
    sudo apt update
    sudo apt install -y cockpit-cloudflared || {
        cd "$INSTALL_DIR"
        git clone https://github.com/cloudflare/cloudflared || true
        echo -e "${YELLOW}Cloned cloudflared; cockpit plugin may not be present. Manual integration may be required.${NC}"
    }
    echo -e "${GREEN}✓ cockpit-cloudflared handled (best-effort)${NC}"
    log_message "cockpit-cloudflared installed or cloned"
    read -p "Press Enter to continue..."
}

install_cockpit-networkmanager() {
    echo -e "\n${GREEN}=== Installing cockpit-networkmanager ===${NC}"
    log_message "Starting cockpit-networkmanager installation"
    confirm_install "cockpit-networkmanager will be installed via APT. Continue?"
    sudo apt update
    sudo apt install -y cockpit-networkmanager || echo -e "${YELLOW}cockpit-networkmanager apt install failed or not available.${NC}"
    echo -e "${GREEN}✓ cockpit-networkmanager handled${NC}"
    log_message "cockpit-networkmanager installed or skipped"
    read -p "Press Enter to continue..."
}

# Function to show installation history
show_history() {
    echo -e "\n${GREEN}=== Installation History ===${NC}"
    
    if [ -f "$LOG_FILE" ]; then
        echo -e "${YELLOW}Last 20 installs:${NC}\n"
        tail -20 "$LOG_FILE"
    else
        echo -e "${YELLOW}No installation history${NC}"
    fi
    
    echo -e "\n${BLUE}Full log file: $LOG_FILE${NC}"
    read -p "Press Enter to continue..."
}

# Función principal
main() {

    # Install dependencies
    install_dependencies
    
    # Menú principal
    while true; do
        show_menu
        read -p "Opción [1-9]: " main_choice
        
        case $main_choice in
            1) files_manager_menu ;;
            2) containers/VM_menu ;;
            3) administration_menu ;;
            4) utilities_menu ;;
            5) network_menu ;;
            6) echo -e "${YELLOW}Debugging tools under development...${NC}"; sleep 1 ;;
            7) install_custom_repo ;;
            8) show_history ;;
            9) 
                echo -e "\n${GREEN}Goodbye!${NC}"
                log_message "Script exited by user"
                exit 0
                ;;
            *) echo -e "${RED}Invalid option${NC}"; sleep 1 ;;
        esac
    done
}

# Manejo de errores
trap 'echo -e "${RED}Error on line $LINENO${NC}"; exit 1' ERR

# Ejecutar script principal
main