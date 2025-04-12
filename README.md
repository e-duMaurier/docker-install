# Ubuntu VPS Setup Script for Docker, Portainer, and Nginx Proxy Manager

## Overview
This script automates the installation of **Docker**, **Portainer-CE**, and **Nginx Proxy Manager** on an Ubuntu-based VPS. It was originally inspired by Brian’s script from [Opensource is Awesome](https://wiki.opensourceisawesome.com), but has been modified to:
- **Support only Ubuntu** (instead of multiple Linux distributions).
- **Exclude additional software installations** to allow manual setup of extra applications as needed.
- **Run non-interactively** without user prompts, ensuring a smooth automated process.

## Features
- **Installs Docker-CE & Docker-Compose** if they are not already installed.
- **Sets up Nginx Proxy Manager** with default credentials.
- **Deploys Portainer-CE for Docker container management**.
- **Creates a default Docker network** for easy container networking.

## Installation
### 1. Clone or Download the Script
You can clone this repository or copy the script to your VPS.
```bash
git clone https://github.com/e-duMaurier/docker-setup.git
```

### 2. Run the Script
Ensure your VPS is running Ubuntu, then execute:

```bash
chmod +x setup-docker-apps.sh
./setup-docker-apps.sh
```

## 3. Access Services
After installation, you can access the following services:

### 🔹 Nginx Proxy Manager
- **URL:** `http://<server-ip>:81`
- **Default Login Credentials:**
  - **Username:** `admin@example.com`
  - **Password:** `changeme`

### 🔹 Portainer-CE
- **URL:** `http://<server-ip>:9000`
- **First-time setup:** You will be prompted to create an admin account upon first login.

## Why This Script?
Originally, I used a more comprehensive setup script from [Opensource is Awesome](https://wiki.opensourceisawesome.com), but I modified it for my specific needs:
1. **Ubuntu is my preferred OS for VPS**—I didn’t need multi-distro support.
2. **I prefer installing additional applications manually** to gain experience setting them up myself.
3. **This streamlined script automates just the essentials**—Docker, Portainer, and Nginx Proxy Manager—without unnecessary complexity.

## Future Plans
- Possibly add configurations for **firewall rules** to enhance security.
- Expand the script to support **additional containerized applications**.
- Provide an **optional configuration file** for more flexible setups.

## Credits
- Inspired by [Opensource is Awesome](https://wiki.opensourceisawesome.com).
- Modified and maintained for personal use.
