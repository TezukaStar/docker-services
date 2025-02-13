#!/bin/bash
set -e

# ตรวจสอบว่าสคริปต์รันด้วยสิทธิ์ root หรือไม่
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] กรุณารันสคริปต์ด้วยสิทธิ์ root หรือใช้ sudo" >&2
    exit 1
fi

# ลบ Docker เวอร์ชันเก่า (if any)
apt-get remove -y docker.io docker-doc docker-compose podman-docker containerd runc || true

# อัปเดตแพ็กเกจ
apt-get update -y
apt-get install -y ca-certificates curl gnupg

# เพิ่ม Docker Repository
rm -rf /etc/apt/keyrings/docker.gpg
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# อัปเดตแพ็กเกจอีกครั้ง
apt-get update -y

# ติดตั้ง Docker เวอร์ชันล่าสุด
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# เปิดใช้ Docker
systemctl enable --now docker

# เพิ่มผู้ใช้ใหม่ของแครด docker
if [ "$SUDO_USER" ]; then
    usermod -aG docker $SUDO_USER
    echo "[INFO] โปรด logout และ login ใหม่เพื่อให้แน่ใจ"
fi

echo "✅ Docker ติดตั้งเรียบร้อย! 🚀"
