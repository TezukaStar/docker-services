# Docker

## 🚀 ติดตั้งและถอนการติดตั้ง Docker บน Ubuntu

### 📌 ขั้นตอนการติดตั้ง Docker บน Ubuntu Server

#### ✅ 1. สร้างไฟล์ `install_docker.sh`

รันคำสั่งนี้ใน **Ubuntu Terminal**:
```sh
sudo nano install_docker.sh
```

📌 คัดลอกโค้ดต่อไปนี้ไปวางในไฟล์:

```sh
#!/bin/bash
set -e

# ตรวจสอบว่าสคริปต์รันด้วยสิทธิ์ root หรือไม่
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] กรุณารันสคริปต์ด้วยสิทธิ์ root หรือใช้ sudo" >&2
    exit 1
fi

# ลบ Docker เวอร์ชันเก่า (if any)
echo "[INFO] กำลังลบ Docker เวอร์ชั่นเก่า (ถ้ามี)..."
apt-get remove -y docker docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc || true

# อัปเดตแพ็กเกจ
echo "[INFO] กำลังอัปเดตแพ็กเกจ..."
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release

# เพิ่ม Docker Repository (วิธีล่าสุด)
echo "[INFO] กำลังเพิ่ม Docker repository..."
install -m 0755 -d /etc/apt/keyrings
rm -f /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# อัปเดตแพ็กเกจอีกครั้ง
echo "[INFO] กำลังอัปเดตรายการแพ็กเกจ..."
apt-get update -y

# ติดตั้ง Docker เวอร์ชั่นล่าสุด
echo "[INFO] กำลังติดตั้ง Docker เวอร์ชั่นล่าสุด..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# เปิดใช้ Docker
echo "[INFO] กำลังเปิดใช้งาน Docker service..."
systemctl enable --now docker

# เพิ่มผู้ใช้ปัจจุบันเข้ากลุ่ม docker
if [ "$SUDO_USER" ]; then
    echo "[INFO] กำลังเพิ่มผู้ใช้ $SUDO_USER เข้ากลุ่ม docker..."
    usermod -aG docker $SUDO_USER
    echo "[INFO] โปรด logout และ login ใหม่เพื่อให้การเปลี่ยนแปลงมีผล"
fi

# ตรวจสอบเวอร์ชันที่ติดตั้ง
echo "[INFO] เวอร์ชั่น Docker ที่ติดตั้ง:"
docker --version
docker compose version

echo "✅ Docker ติดตั้งเรียบร้อยแล้ว! 🚀"
```

#### ✅ 2. ให้สิทธิ์และรันไฟล์ `install_docker.sh`
```sh
chmod +x install_docker.sh
```

#### ✅ 3. รันไฟล์ติดตั้ง Docker
```sh
./install_docker.sh
```

💚 **เสร็จเล้ว!** 🚀 เมื่อติดตั้ง Docker เรียบร้อยแล้ว! 🎉

---

### ❌ ขั้นตอนการถอนการติดตั้ง Docker

#### 🔥 1. สร้างไฟล์ `uninstall_docker.sh`

รันคำสั่งนี้ใน **Ubuntu Terminal**:
```sh
sudo nano uninstall_docker.sh
```

📌 คัดลอกโค้ดต่อไปนี้ไปวางในไฟล์:

```sh
#!/bin/bash
set -e

echo "[INFO] กำลังลบ Docker..."
systemctl stop docker || true
systemctl disable docker || true
apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker.io || true
rm -rf /var/lib/docker /var/lib/containerd /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list
groupdel docker || true
echo "✅ Docker ถูกถอนการติดตั้งเรียบร้อยแล้ว!"
```

#### 🔥 2. ให้สิทธิ์และรันไฟล์ `uninstall_docker.sh`
```sh
chmod +x uninstall_docker.sh
```

#### 🔥 3. รันไฟล์ถอนการติดตั้ง Docker
```sh
./uninstall_docker.sh
```

✅ **เสร็จเรียบร้อย!** 🚀 Docker ถูกลบออกจากระบบแล้ว 🎉

