echo "[INFO] กำลังลบ Docker..."
systemctl stop docker || true
systemctl disable docker || true
apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker.io || true
rm -rf /var/lib/docker /var/lib/containerd /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list
groupdel docker || true
echo "✅ Docker ถูกถอนการติดตั้งเรียบร้อยแล้ว!"