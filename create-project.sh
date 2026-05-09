#!/bin/bash

# Pastikan script dijalankan dari dalam phantasm-8.3
if [ ! -d "8000-boilerplate" ]; then
    echo "Error: Tolong jalankan script ini dari dalam direktori phantasm-8.3"
    exit 1
fi

PORT=$1
PROJECT_NAME=$2

if [ -z "$PORT" ] || [ -z "$PROJECT_NAME" ]; then
    echo -e "\033[1;31mPenggunaan: ./create-project.sh <PORT> <NAMA_PROYEK>\033[0m"
    echo "Contoh: ./create-project.sh 8008 dwcs-superapp"
    exit 1
fi

DEST_DIR="../projects/${PORT}-${PROJECT_NAME}"

# Cek apakah direktori target sudah ada
if [ -d "$DEST_DIR" ]; then
    echo -e "\033[1;31mError: Direktori $DEST_DIR sudah ada!\033[0m"
    exit 1
fi

echo -e "\033[1;34m[1/3] Menyalin boilerplate ke $DEST_DIR...\033[0m"
cp -r 8000-boilerplate "$DEST_DIR"

echo -e "\033[1;34m[2/3] Menyesuaikan konfigurasi Docker Compose...\033[0m"
# Mengubah Port Nginx
sed -i "s/8000:80/${PORT}:80/g" "$DEST_DIR/docker-compose.yml"

# Mengubah Nama Container
sed -i "s/boilerplate-app-dev/${PROJECT_NAME}-app-dev/g" "$DEST_DIR/docker-compose.yml"
sed -i "s/boilerplate-nginx-dev/${PROJECT_NAME}-nginx-dev/g" "$DEST_DIR/docker-compose.yml"

echo -e "\033[1;32m[3/3] Selesai! Proyek baru telah siap di $DEST_DIR.\033[0m"
echo ""
echo "Langkah selanjutnya:"
echo "1. cd $DEST_DIR"
echo "2. Letakkan source code aplikasimu di dalam folder src/"
echo "3. Sesuaikan file .env agar menggunakan DB_HOST=infra-mariadb"
echo "4. Jalankan: docker compose up -d --build"
echo "5. Buka web aplikasimu di http://localhost:$PORT"
