# PostgreSQL บน Docker

## 📌 คู่มือการติดตั้ง PostgreSQL ด้วย Docker

คู่มือนี้จะช่วยให้คุณติดตั้งและใช้งาน PostgreSQL ผ่าน Docker โดยใช้ Docker Compose

---

## ✅ ข้อกำหนดเบื้องต้น

- ติดตั้ง Docker และ Docker Compose บนระบบของคุณ
- มีความเข้าใจพื้นฐานเกี่ยวกับคำสั่ง Command Line

---

## 🚀 ขั้นตอนการติดตั้ง PostgreSQL บน Docker

### 1️⃣ สร้างไดเรกทอรีสำหรับเก็บข้อมูลของ PostgreSQL

รันคำสั่งต่อไปนี้เพื่อสร้างโฟลเดอร์สำหรับเก็บข้อมูล:

```sh
mkdir -p ~/postgres
```

---

### 2️⃣ สร้างไฟล์ `docker-compose.yml`

สร้างไฟล์ `docker-compose.yml` ภายในไดเรกทอรีที่สร้างขึ้น:

```sh
touch ~/postgres/docker-compose.yml
```

เปิดไฟล์ `docker-compose.yml` และเพิ่มเนื้อหาดังนี้:

```yaml
version: '3.8'

services:
  db:
    image: postgres:15.3
    restart: always
    container_name: db-postgres
    environment:
      POSTGRES_DB: 'db'
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      TZ: Asia/Bangkok
    ports:
      - '5432:5432'
    volumes:
      - ./my-db:/var/lib/postgresql/data
```

---

### 3️⃣ เริ่มต้นใช้งาน PostgreSQL

ไปที่ไดเรกทอรีที่สร้างไว้แล้วรันคำสั่งนี้:

```sh
cd ~/postgres
docker-compose up -d
```

ตรวจสอบว่า Container กำลังทำงานอยู่ด้วยคำสั่ง:

```sh
docker ps
```

---

### 4️⃣ เชื่อมต่อไปยังฐานข้อมูล PostgreSQL

สามารถเชื่อมต่อไปยัง PostgreSQL ผ่าน Command Line ได้โดยใช้คำสั่ง:

```sh
docker exec -it db-postgres psql -U postgres -d db
```

ใส่รหัสผ่าน: `postgres`

---

### 5️⃣ หยุดและลบ Container PostgreSQL

หากต้องการหยุดและลบ Container PostgreSQL ให้ใช้คำสั่งนี้:

```sh
docker-compose down
```

---

## 🔧 การตั้งค่าเพิ่มเติม

### 📌 การจัดเก็บข้อมูลแบบถาวร (Persistent Data)

ไฟล์ `docker-compose.yml` ถูกตั้งค่าให้ใช้ Volume ของ Docker สำหรับเก็บข้อมูล PostgreSQL:

```yaml
volumes:
  - ./my-db:/var/lib/postgresql/data
```

ข้อมูลจะไม่หายไปแม้จะปิด Container

### 📌 การกำหนดค่าตัวแปรสภาพแวดล้อม

ค่าต่อไปนี้ถูกตั้งค่าใน `docker-compose.yml`:

- `POSTGRES_DB`: กำหนดชื่อฐานข้อมูลเริ่มต้น
- `POSTGRES_USER`: กำหนดชื่อผู้ใช้สำหรับเชื่อมต่อฐานข้อมูล
- `POSTGRES_PASSWORD`: รหัสผ่านของผู้ใช้
- `TZ`: ตั้งค่า Timezone ของเซิร์ฟเวอร์

---

## ❌ การถอนการติดตั้ง PostgreSQL บน Docker

### 1️⃣ หยุดและลบ Container PostgreSQL

```sh
docker-compose down -v
```

### 2️⃣ ลบไดเรกทอรีข้อมูล (ถ้าต้องการ)

```sh
rm -rf ~/postgres
```

---

## 🔍 การแก้ไขปัญหา

หากเกิดปัญหา ให้ตรวจสอบ Log ของ Container ด้วยคำสั่ง:

```sh
docker-compose logs
```

---

## 🔐 ข้อควรระวังด้านความปลอดภัย

- ควรใช้รหัสผ่านที่ปลอดภัยและซับซ้อนกว่านี้ในระบบจริง
- ควรใช้ Docker Secrets หรือไฟล์ `.env` แยกเพื่อเก็บข้อมูลสำคัญ
- จำกัดการเข้าถึงพอร์ต 5432 เฉพาะในเครือข่ายที่ปลอดภัย

---

## 📖 แหล่งข้อมูลเพิ่มเติม

- [Docker Hub - PostgreSQL](https://hub.docker.com/_/postgres)
- [เอกสาร PostgreSQL](https://www.postgresql.org/docs/)

