# Phantasm-8.3 (Microservice Kit)

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
*(Cukup jalankan ini sekali saja di PC kamu. Jangan pernah mematikan infra ini jika masih ada aplikasi lain yang berjalan).*

**Akses Infra:**
- phpMyAdmin: `http://localhost:7001`
- MQTT Explorer: `http://localhost:7002`

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
