# Boilerplate: Standar Arsitektur Microservice Laravel

Direktori `8000-boilerplate` ini adalah *template* standar yang digunakan untuk membuat proyek-proyek web (terutama Laravel) baru agar memiliki arsitektur, lingkungan, dan *resource usage* yang seragam. 

Arsitektur ini didesain untuk **menghemat RAM dan Storage** saat memiliki puluhan *microservice*, karena menggunakan **Alpine Linux** sebagai *base OS*.

## 🏗️ Komponen Arsitektur

1. **Nginx (Web Server)**: Menangani *request* HTTP dan meneruskannya ke PHP-FPM.
2. **PHP-FPM 8.3 (App Server)**: Menjalankan kode *backend* Laravel. Dilengkapi konfigurasi khusus untuk mengizinkan unggahan file (Upload/POST size) hingga 100MB.
3. **Network Terpusat (`mirage-net`)**: Proyek tidak mengurus *database* sendiri, melainkan menyambung ke jaringan infrastruktur pusat.

## 🚀 Cara Menggunakan Boilerplate

Jika kamu ingin membuat proyek baru (misalnya: `8003-toko-online`), ikuti langkah-langkah ini:

1. **Copy Direktori Ini**
   ```bash
   cp -r 8000-boilerplate 8003-toko-online
   cd 8003-toko-online
   ```

2. **Masukkan Source Code**
   Letakkan (atau *git clone*) *source code* Laravel kamu tepat di dalam folder `src/`.

3. **Ubah Port & Nama Kontainer**
   Buka file `docker-compose.yml` dan ubah beberapa nilai berikut agar tidak bertabrakan dengan proyek lain:
   - `container_name` pada servis `app` (misal: `toko-app-dev`)
   - `container_name` pada servis `nginx` (misal: `toko-nginx-dev`)
   - *Port mapping* Nginx. Berdasarkan standar kita, port web menggunakan awalan `8XXX`. Ubah `"8000:80"` menjadi `"8003:80"`.

4. **Koneksi Database/MQTT**
   Di dalam file `.env` Laravel kamu, gunakan nama servis *infra* sebagai host-nya (karena mereka berada dalam *network* yang sama):
   - `DB_HOST=infra-mariadb`
   - `MQTT_HOST=infra-mqtt`

5. **Jalankan!**
   ```bash
   docker compose up -d --build
   ```
