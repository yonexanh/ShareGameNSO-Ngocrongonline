# ShareGameNSO-Ngocrongonline

Huong dan cai dat va chay source game Ngoc Rong Online tu dau.

## Cau truc thu muc

```text
SRC5M/
|-- Local5m/              # Client Windows da build san
`-- Source5m/             # Source server Java/Maven
    |-- Sql/              # File database
    |-- config/           # Cau hinh game server
    |-- login/            # Login server da build san
    |-- src/              # Source Java game server
    `-- target/           # File jar build san / file build ra tu Maven
```

## Yeu cau

- Git va Git LFS.
- Java JDK 17.
- Maven 3.8+.
- MySQL hoac MariaDB.
- Windows neu muon chay client `SRC5M/Local5m/ModLocal_Double.exe`.

Kiem tra nhanh:

```bash
git --version
git lfs version
java -version
mvn -version
mysql --version
```

## 1. Tai source

```bash
git clone https://github.com/yonexanh/ShareGameNSO-Ngocrongonline.git
cd ShareGameNSO-Ngocrongonline
git lfs install
git lfs pull
```

`git lfs pull` la bat buoc vi client co file tai nguyen lon duoc quan ly bang Git LFS.

## 2. Tao database

Tao database `hashirama` va import file SQL co san:

```bash
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS hashirama CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -u root -p hashirama < SRC5M/Source5m/Sql/hashirama.sql
```

Neu MySQL cua ban dung user/password khac, hay sua lai o buoc cau hinh ben duoi.

## 3. Cau hinh game server

Mo file:

```text
SRC5M/Source5m/config/server.properties
```

Kiem tra cac dong chinh:

```properties
server.db.ip=localhost
server.db.port=3306
server.db.name=hashirama
server.db.us=root
server.db.pw=

server.port=14445
server.sv1=Nro:127.0.0.1:14445:0,0,0

login.host=127.0.0.1
login.port=8888
```

Ghi chu:

- Neu chay server tren may khac, doi `127.0.0.1` trong `server.sv1` thanh IP/domain ma client co the ket noi.
- Neu file chua co `login.host` va `login.port`, game server se mac dinh ket noi login server tai `127.0.0.1:8888`.
- Nen doi `api.key` truoc khi public/chay that.

## 4. Cau hinh login server

Mo file:

```text
SRC5M/Source5m/login/server.ini
```

Kiem tra cau hinh database va port:

```ini
server.port=8888
db.port=3306
db.host=localhost
db.user=root
db.password=
db.name=hashirama
db.driver=com.mysql.cj.jdbc.Driver
admin.mode=0
```

Thong tin database trong `server.ini` nen khop voi `config/server.properties`.

## 5. Build game server

Chay trong thu muc `SRC5M/Source5m`:

```bash
cd SRC5M/Source5m
mvn clean package
```

Sau khi build thanh cong, file jar se nam o:

```text
target/VIP-1.0-RELEASE-jar-with-dependencies.jar
```

## 6. Chay server

Can chay login server truoc, sau do moi chay game server.

Terminal 1 - login server:

```bash
cd SRC5M/Source5m/login
java -jar ServerLogin.jar
```

Terminal 2 - game server:

```bash
cd SRC5M/Source5m
java -jar target/VIP-1.0-RELEASE-jar-with-dependencies.jar
```

Mac/Linux co the can mo port tren firewall:

- `8888`: login server.
- `14445`: game server.
- `8080`: API neu dang dung.

## 7. Chay client Windows

Client nam trong:

```text
SRC5M/Local5m
```

Neu server va client cung mot may Windows:

1. Mo `SRC5M/Local5m/RUN_GAME.bat`, hoac chay truc tiep `ModLocal_Double.exe`.

Neu server chay tren may khac:

1. Mo `SRC5M/Local5m/SETUP_PORTPROXY_ADMIN.bat`.
2. Sua dong `MAC_SERVER_IP` thanh IP may dang chay server.
3. Bam chuot phai file `.bat` va chon `Run as administrator`.
4. Chay `RUN_GAME.bat` hoac `ModLocal_Double.exe`.

Tai khoan test trong database:

```text
admin1
admin123123123
```

## Lenh thuong dung

Build lai server:

```bash
cd SRC5M/Source5m
mvn clean package
```

Chay login server:

```bash
cd SRC5M/Source5m/login
java -jar ServerLogin.jar
```

Chay game server:

```bash
cd SRC5M/Source5m
java -jar target/VIP-1.0-RELEASE-jar-with-dependencies.jar
```

Cap nhat source moi nhat:

```bash
git pull
git lfs pull
```

## Loi thuong gap

### Client khong vao duoc server

- Kiem tra login server da chay port `8888`.
- Kiem tra game server da chay port `14445`.
- Kiem tra `server.sv1` trong `config/server.properties` dung IP/domain cua server.
- Neu dung Windows portproxy, chay `SETUP_PORTPROXY_ADMIN.bat` bang quyen Administrator.

### Game server bao loi ket noi database

- Kiem tra MySQL/MariaDB dang chay.
- Kiem tra database `hashirama` da import thanh cong.
- Kiem tra user/password trong `config/server.properties` va `login/server.ini`.

### Thieu file client hoac file tai nguyen bi loi

Chay lai:

```bash
git lfs pull
```

### Port da bi su dung

Doi port trong:

- `SRC5M/Source5m/config/server.properties`
- `SRC5M/Source5m/login/server.ini`

Sau do restart login server va game server.
