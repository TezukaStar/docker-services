# ติดตั้ง Mosquitto MQTT Broker บน Docker

คู่มือนี้จะช่วยแนะนำการตั้งค่า Mosquitto MQTT Broker บน Docker พร้อมการกำหนดค่าความปลอดภัย

## ข้อกำหนดเบื้องต้น

- ติดตั้ง Docker และ Docker Compose บนเครื่องของคุณแล้ว
- มีพื้นฐานการใช้งานคำสั่ง Command Line

## ขั้นตอนการติดตั้ง

### 1. สร้างไดเรกทอรีสำหรับการตั้งค่า Mosquitto

เริ่มต้นด้วยการสร้างไดเรกทอรีบนเครื่องโฮสต์เพื่อเก็บไฟล์การตั้งค่าของ Mosquitto:

```bash
mkdir -p ~/mosquitto/config
```

### 2. สร้างไฟล์ `mosquitto.conf`

สร้างไฟล์ `mosquitto.conf` ในไดเรกทอรีที่สร้างขึ้นมา:

```bash
touch ~/mosquitto/config/mosquitto.conf
```

เปิดไฟล์ `mosquitto.conf` และเพิ่มการตั้งค่าพื้นฐานดังนี้:

```conf
listener 1883
allow_anonymous false
password_file /mosquitto/config/passwords.txt
log_dest file /mosquitto/log/mosquitto.log
```

### 3. สร้างชื่อผู้ใช้และรหัสผ่าน

ใช้คำสั่ง `mosquitto_passwd` เพื่อสร้างไฟล์เก็บชื่อผู้ใช้และรหัสผ่าน:

```bash
mosquitto_passwd -c ~/mosquitto/config/passwords.txt username
mosquitto_passwd -c ./config/passwords.txt adcm

```

หากต้องการเพิ่มผู้ใช้เพิ่มเติม ใช้คำสั่งเดิมโดยไม่ต้องใส่ `-c`:

```bash
mosquitto_passwd ~/mosquitto/config/passwords.txt anotheruser
```

### 4. สร้างไฟล์ `docker-compose.yml`

สร้างไฟล์ `docker-compose.yml` ในไดเรกทอรี `~/mosquitto` เพื่อกำหนดค่าการทำงานของ Docker container:

```bash
touch ~/mosquitto/docker-compose.yml
```

เปิดไฟล์ `docker-compose.yml` และเพิ่มเนื้อหาดังนี้:

```yaml
version: '3.8'
services:
  mosquitto:
    image: eclipse-mosquitto:2.0.15
    container_name: mosquitto
    ports:
      - "1883:1883"
      - "9001:9001"
    volumes:
      - ~/mosquitto/config:/mosquitto/config
      - ~/mosquitto/logs:/mosquitto/log
```

### 5. เริ่มต้น Mosquitto Broker

ไปที่ไดเรกทอรี `~/mosquitto` และเริ่ม container โดยใช้ Docker Compose:

```bash
cd ~/mosquitto
docker-compose up -d
```

ตรวจสอบว่า container ทำงานอยู่หรือไม่โดยใช้คำสั่ง:

```bash
docker ps
```

### 6. ทดสอบการเชื่อมต่อ

ใช้ `mosquitto_sub` และ `mosquitto_pub` เพื่อตรวจสอบการเชื่อมต่อกับ Mosquitto Broker:

* **สมัครรับข้อความจากหัวข้อ (Subscribe):**

```bash
mosquitto_sub -h localhost -p 1883 -t test/topic -u username -P password
```

* **ส่งข้อความ (Publish):**

```bash
mosquitto_pub -h localhost -p 1883 -t test/topic -m "Hello World" -u username -P password
```

