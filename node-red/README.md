# การติดตั้ง Node-RED บน Docker

เอกสารนี้จะแนะนำขั้นตอนการติดตั้ง Node-RED บน Docker โดยใช้ Docker Compose

## ข้อกำหนดเบื้องต้น

- ติดตั้ง Docker และ Docker Compose บนระบบของคุณ
- มีความรู้พื้นฐานเกี่ยวกับ Command Line

## ขั้นตอนการติดตั้ง

### 1. สร้างไดเรกทอรีสำหรับ Node-RED

เริ่มต้นด้วยการสร้างไดเรกทอรีบนเครื่องโฮสต์เพื่อใช้เก็บไฟล์การตั้งค่าของ Node-RED:

```bash
mkdir -p ~/node-red
```

### 2. สร้างไฟล์ `docker-compose.yml`

สร้างไฟล์ `docker-compose.yml` ในไดเรกทอรีที่สร้างขึ้น:

```bash
touch ~/node-red/docker-compose.yml
```

เปิดไฟล์ `docker-compose.yml` และเพิ่มเนื้อหาต่อไปนี้:

```yaml
version: '3'
services:
  nodered:
    image: nodered/node-red:3.1.0
    container_name: node-red
    ports:
      - "1880:1880"
    volumes:
      - node_red_flows:/data  
      - node_red_logs:/logs   
    environment:
      - NODE_RED_LOG_DIR=/logs  

volumes:
  node_red_flows:  
  node_red_logs:   
```

### 3. เริ่มต้นใช้งาน Node-RED

ไปที่ไดเรกทอรี `~/node-red` และเริ่มคอนเทนเนอร์โดยใช้ Docker Compose:

```bash
cd ~/node-red
docker-compose up -d
```

เพื่อตรวจสอบว่าคอนเทนเนอร์ทำงานอยู่หรือไม่ ใช้คำสั่ง:

```bash
docker ps
```

### 4. การเข้าถึง Node-RED

เปิดเว็บเบราว์เซอร์และไปที่:

```
http://localhost:1880
```

คุณจะพบกับอินเทอร์เฟซของ Node-RED

### 5. การหยุดใช้งาน Node-RED

หากต้องการหยุดคอนเทนเนอร์ ใช้คำสั่ง:

```bash
docker-compose down
```

## การตั้งค่าเพิ่มเติม

### การจัดเก็บข้อมูลถาวร

ไฟล์ `docker-compose.yml` ถูกตั้งค่าให้ใช้ Docker Volumes เพื่อเก็บข้อมูลถาวร:

- `node_red_flows`: เก็บ Flow และการตั้งค่าต่างๆ ของ Node-RED
- `node_red_logs`: เก็บไฟล์บันทึก (Logs) ของ Node-RED

Volumes เหล่านี้จะถูกสร้างขึ้นโดยอัตโนมัติเมื่อคุณรัน `docker-compose up -d` ครั้งแรก

### การปรับแต่ง Node-RED

หากต้องการปรับแต่งการตั้งค่า Node-RED คุณสามารถสร้างไฟล์ `settings.js` ในไดเรกทอรี `~/node-red/data` และ Node-RED จะใช้ไฟล์นี้โดยอัตโนมัติ

### การอัปเดต Node-RED

หากต้องการอัปเดต Node-RED เป็นเวอร์ชันใหม่ ให้แก้ไขหมายเลขเวอร์ชันในไฟล์ `docker-compose.yml` แล้วรันคำสั่ง:

```bash
docker-compose up -d
```

## การแก้ไขปัญหา

หากพบปัญหา สามารถตรวจสอบบันทึก (Logs) ได้โดยใช้คำสั่ง:

```bash
docker-compose logs
```

หรือตรวจสอบไฟล์บันทึกใน Volume `node_red_logs`

## แหล่งข้อมูลเพิ่มเติม

- [Node-RED Documentation](https://nodered.org/docs/)
- [Node-RED Docker Documentation](https://nodered.org/docs/getting-started/docker)

