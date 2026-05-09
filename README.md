# Phantasm-8.3 (Microservice Kit)

[🇮🇩 Versi Indonesia di bawah](#versi-indonesia)

Phantasm is a Docker-based *Microservice Local Development Kit*. Unlike traditional monolithic stacks, Phantasm strictly separates the **Core Infrastructure** (Database, MQTT Broker) from the **Applications/Microservices** (Nginx, PHP-FPM).

This decentralized approach is designed specifically to solve:
1. **Extreme RAM/Storage Savings**: 10 Laravel projects no longer require 10 instances of MariaDB running simultaneously.
2. **Zero Port Collisions**: Each application is allocated a clean, distinct host port.
3. **Production-like Connectivity**: It utilizes a centralized Docker network (`mirage-net`) for inter-service communication, mimicking a real production environment.

## 🏗️ Repository Structure

This repository is a **kit**. When you clone it, you will get:
- `infra/` — The heart of Phantasm. Contains shared services (MariaDB, phpMyAdmin, Mosquitto MQTT).
- `8000-boilerplate/` — The base template for every new microservice application (Alpine Linux + Nginx + PHP 8.3 FPM).
- `create-project.sh` — A magic script to automate the creation of new applications.

---

## 🚀 Usage Guide

### Step 1: Ignite the Core Infrastructure
Before creating any applications, you **must** start the `infra` to make the `mirage-net` network and database available.

```bash
cd infra
docker compose up -d
```
*(By default, this only starts MariaDB and phpMyAdmin. You only need to run this once on your machine. Never stop this infra if other applications are still running).*

**Optional Services (Profiles):**
You can enable additional infrastructure services using Docker Compose profiles:
- With MQTT Broker: `docker compose --profile mqtt up -d`
- With PostgreSQL: `docker compose --profile postgres up -d`
- With Redis: `docker compose --profile redis up -d`

**Accessing Infra:**
- phpMyAdmin: `http://localhost:7001`
- MQTT Explorer (if `mqtt` profile is active): `http://localhost:7002`

### Step 2: Forging a New Project
Do not modify the contents of the `8000-boilerplate` folder directly. Use the automation script to generate new projects.

Command format: `./create-project.sh <AVAILABLE_PORT> <PROJECT_NAME>`

**Example:**
```bash
./create-project.sh 8008 online-store
```

The script will automatically create a `~/projects/8008-online-store` folder on your machine, rename the containers, and set the port to `8008`.

### Step 3: Running Your New Project
Navigate to the newly created project folder, insert your code, and start it up!

```bash
# Navigate to your new project
cd ../projects/8008-online-store

# Place your application source code inside the src/ folder
git clone <your-app-repo> src/

# Start the containers
docker compose up -d --build
```

### Step 4: Database & MQTT Connections
Inside your Laravel/App `.env` file, ensure you use the `infra` hostnames (not `127.0.0.1` or `localhost`):

```env
DB_CONNECTION=mysql
DB_HOST=infra-mariadb
DB_PORT=3306

MQTT_HOST=infra-mqtt
MQTT_PORT=1883
```

---

<a name="versi-indonesia"></a>
# 🇮🇩 Versi Indonesia

Phantasm adalah ekosistem *Microservice Local Development Kit* berbasis Docker. Tidak seperti tumpukan (*stack*) monolitik tradisional, Phantasm memisahkan antara **Infrastruktur Inti** (Database, Broker MQTT) dengan **Aplikasi/Microservice** (Nginx, PHP-FPM).

Pendekatan desentralisasi ini dirancang khusus untuk memecahkan masalah:
1. **Penghematan RAM/Storage Ekstrem**: 10 proyek Laravel tidak lagi membutuhkan 10 MariaDB yang berjalan bersamaan.
2. **Bebas Tabrakan Port**: Setiap aplikasi akan mendapat alokasi port *host* yang rapi.
3. **Konektivitas Mirip Production**: Menggunakan *Docker network* (`mirage-net`) untuk komunikasi antar layanan yang semirip mungkin dengan *environment* asli.

## 🏗️ Struktur Repositori

Repositori ini adalah sebuah **kit** (peralatan). Saat kamu meng-*clone* repositori ini, kamu akan mendapatkan:
- `infra/` — Jantung dari Phantasm. Berisi layanan *shared* (MariaDB, phpMyAdmin, Mosquitto MQTT).
- `8000-boilerplate/` — Template/Cetakan dasar untuk setiap aplikasi *microservice* yang akan kamu buat (Alpine Linux + Nginx + PHP 8.3 FPM).
- `create-project.sh` — Skrip ajaib untuk mengotomatisasi pembuatan aplikasi baru.

---

## 🚀 Panduan Penggunaan

### Langkah 1: Nyalakan Jantung Infrastruktur
Sebelum membuat aplikasi apa pun, kamu **wajib** menyalakan `infra` terlebih dahulu agar jaringan `mirage-net` dan *database* tersedia.

```bash
cd infra
docker compose up -d
```
*(Secara default, ini hanya akan menyalakan MariaDB dan phpMyAdmin. Cukup jalankan ini sekali saja di PC kamu. Jangan pernah mematikan infra ini jika masih ada aplikasi lain yang berjalan).*

**Layanan Opsional (Profiles):**
Kamu bisa mengaktifkan infrastruktur tambahan menggunakan Docker Compose profiles:
- Berserta Broker MQTT: `docker compose --profile mqtt up -d`
- Berserta PostgreSQL: `docker compose --profile postgres up -d`
- Berserta Redis: `docker compose --profile redis up -d`

**Akses Infra:**
- phpMyAdmin: `http://localhost:7001`
- MQTT Explorer (jika profil `mqtt` aktif): `http://localhost:7002`

### Langkah 2: Mencetak Proyek Baru
Jangan menyentuh isi folder `8000-boilerplate` secara langsung. Gunakan *script* otomatis untuk meng-*generate* proyek baru.

Format perintah: `./create-project.sh <PORT_BEBAS> <NAMA_PROYEK>`

**Contoh:**
```bash
./create-project.sh 8008 toko-online
```

*Script* di atas akan otomatis membuat folder `~/projects/8008-toko-online` di PC kamu, me-rename nama *container*, dan mengatur *port* menjadi `8008`.

### Langkah 3: Menjalankan Proyek Barumu
Pindah ke folder proyek yang baru saja dibuat oleh *script*, masukkan kodemu, dan nyalakan!

```bash
# Pindah ke proyek barumu
cd ../projects/8008-toko-online

# Letakkan source code aplikasimu di dalam folder src/
git clone <repo-aplikasimu> src/

# Nyalakan kontainernya
docker compose up -d --build
```

### Langkah 4: Sambungan Database & MQTT
Di dalam file `.env` Laravel/Aplikasi milikmu, pastikan kamu menggunakan *hostname* dari `infra` (bukan `127.0.0.1` atau `localhost`):

```env
DB_CONNECTION=mysql
DB_HOST=infra-mariadb
DB_PORT=3306

MQTT_HOST=infra-mqtt
MQTT_PORT=1883
```

---
*Selamat membangun ekosistem yang terdistribusi dan efisien!*
