# Infrastruktur Pusat (`infra`)

Direktori ini berisi seluruh layanan penunjang (*backend infrastructure*) yang sifatnya global dan dibagikan (*shared*) ke seluruh proyek.

Dengan memusatkan infrastruktur di sini, kita bisa **menghemat resource** (tidak perlu setiap proyek menyalakan MariaDB sendiri) dan **mempermudah manajemen** data antar-*microservices*.

## 🔌 Layanan yang Berjalan

Seluruh kontainer di sini tergabung dalam jaringan Docker terpusat bernama `phantasm-net`.

### 1. MariaDB (Database Utama)
- **Container Name**: `infra-mariadb`
- **Internal Port**: `3306` (Digunakan oleh Laravel di proyek lain via `.env`: `DB_HOST=infra-mariadb`)
- **Host Port**: `6001` (Digunakan jika ingin remote SQL dari aplikasi luar seperti DBeaver)
- **Data Volume**: Menggunakan *named volume* `mysql_data`.

### 2. phpMyAdmin (GUI Database)
- **Container Name**: `infra-pma`
- **Host Port**: `7001` (Akses via browser di `http://localhost:7001`)

### 3. Mosquitto (MQTT Message Broker)
- **Container Name**: `infra-mqtt`
- **Internal Port**: `1883` (Digunakan oleh Laravel/IoT via `.env`: `MQTT_HOST=infra-mqtt`)
- **Host Port MQTT**: `6002`
- **Host Port WebSockets**: `6003`

### 4. MQTT Explorer (GUI MQTT)
- **Container Name**: `infra-mqtt-web`
- **Host Port**: `7002` (Akses via browser di `http://localhost:7002`)

---

## 📐 Standar Penomoran Port

Untuk menjaga agar *port* tidak saling bertabrakan, kita menyepakati standar penomoran port di OS *Host* berikut ini:

- **`6XXX` (Infrastruktur Core)**: Port raw untuk koneksi data (Misal: MySQL `6001`, MQTT `6002`).
- **`7XXX` (Infrastruktur GUI)**: Web interface untuk me-*manage* infrastruktur (Misal: phpMyAdmin `7001`, MQTT Explorer `7002`).
- **`8XXX` (Aplikasi Web)**: Interface proyek Laravel/Aplikasi Utama (Misal: Boilerplate `8000`, Nizar `8001`, CTC Dashboard `8002`).

---

## 🛠️ Perintah Penggunaan Dasar

**Menyalakan Seluruh Infrastruktur:**
```bash
docker compose up -d
```

**Mematikan Infrastruktur:**
```bash
docker compose down
```
