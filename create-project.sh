#!/bin/bash

# Exit on error
set -e

# ============================================================
# Phantasm 8.3 — Project Creator
# Membuat proyek baru dari template ke dalam folder projects/
# ============================================================

TEMPLATE_DIR="template"
PROJECTS_DIR="projects"

# --- Validasi: Pastikan dijalankan dari root phantasm-8.3 ---
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo -e "\033[1;31mError: Direktori '$TEMPLATE_DIR' tidak ditemukan!\033[0m"
    echo "Tolong jalankan script ini dari root direktori phantasm-8.3"
    exit 1
fi

# --- Parsing argumen ---
PORT=$1
PROJECT_NAME=$2

if [ -z "$PORT" ] || [ -z "$PROJECT_NAME" ]; then
    echo -e "\033[1;31mPenggunaan: ./create-project.sh <PORT> <NAMA_PROYEK>\033[0m"
    echo "Contoh: ./create-project.sh 8002 dwcs-superapp"
    exit 1
fi

# --- Validasi: Port harus berupa angka ---
if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
    echo -e "\033[1;31mError: PORT harus berupa angka (contoh: 8002).\033[0m"
    exit 1
fi

# --- Validasi: Cek apakah port sudah dipakai proyek lain ---
if [ -d "$PROJECTS_DIR" ]; then
    for dir in "$PROJECTS_DIR"/*/; do
        [ -d "$dir" ] || continue
        compose_file="$dir/docker-compose.yml"
        [ -f "$compose_file" ] || continue
        if grep -q "\"${PORT}:80\"" "$compose_file" 2>/dev/null; then
            existing_project=$(basename "$dir")
            echo -e "\033[1;31mError: Port $PORT sudah digunakan oleh proyek '$existing_project'!\033[0m"
            echo "Silakan gunakan nomor port yang lain."
            exit 1
        fi
    done
fi

# --- Pastikan folder projects/ ada ---
mkdir -p "$PROJECTS_DIR"

DEST_DIR="${PROJECTS_DIR}/${PORT}-${PROJECT_NAME}"

# --- Validasi: Cek apakah direktori target sudah ada ---
if [ -d "$DEST_DIR" ]; then
    echo -e "\033[1;31mError: Direktori $DEST_DIR sudah ada!\033[0m"
    exit 1
fi

# --- Step 1: Salin template ---
echo -e "\033[1;34m[1/4] Menyalin template ke $DEST_DIR...\033[0m"
cp -r "$TEMPLATE_DIR" "$DEST_DIR"

# --- Step 2: Set permissions agar user punya full control ---
echo -e "\033[1;34m[2/4] Mengatur permissions...\033[0m"
chmod -R u+rwX,g+rwX "$DEST_DIR"

# --- Step 3: Menyesuaikan konfigurasi Docker Compose ---
echo -e "\033[1;34m[3/4] Menyesuaikan konfigurasi Docker Compose...\033[0m"

# Mengubah Port Nginx (default template: 8001)
sed -i "s/\"8001:80\"/\"${PORT}:80\"/g" "$DEST_DIR/docker-compose.yml"

# Mengubah Nama Container
sed -i "s/boilerplate-app-dev/${PROJECT_NAME}-app-dev/g" "$DEST_DIR/docker-compose.yml"
sed -i "s/boilerplate-nginx-dev/${PROJECT_NAME}-nginx-dev/g" "$DEST_DIR/docker-compose.yml"

# --- Step 4: Selesai! ---
echo -e "\033[1;32m[4/4] Selesai! Proyek baru telah siap di $DEST_DIR.\033[0m"
echo ""
echo "Langkah selanjutnya:"
echo "  1. cd $DEST_DIR"
echo "  2. Letakkan source code aplikasimu di dalam folder src/"
echo "  3. Sesuaikan file .env agar menggunakan DB_HOST=infra-mariadb"
echo "  4. Jalankan: docker compose up -d --build"
echo "  5. Buka web aplikasimu di http://localhost:$PORT"
