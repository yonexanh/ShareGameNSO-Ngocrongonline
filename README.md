# ShareGameNSO-Ngocrongonline

Hướng dẫn cài đặt và chạy source game Ngọc Rồng Online từ đầu.

## Cấu Trúc Thư Mục

```text
SRC5M/
|-- Local5m/              # Client Windows đã build sẵn
`-- Source5m/             # Source server Java/Maven
    |-- Sql/              # File database
    |-- config/           # Cấu hình game server
    |-- login/            # Login server đã build sẵn
    |-- src/              # Source Java game server
    `-- target/           # File jar build sẵn / file build ra từ Maven
```

## Yêu Cầu

- Git và Git LFS.
- Java JDK 17.
- Maven 3.8+.
- MySQL hoặc MariaDB.
- Windows nếu muốn chạy client `SRC5M/Local5m/ModLocal_Double.exe`.

Kiểm tra nhanh:

```bash
git --version
git lfs version
java -version
mvn -version
mysql --version
```

## 1. Tải Source

```bash
git clone https://github.com/yonexanh/ShareGameNSO-Ngocrongonline.git
cd ShareGameNSO-Ngocrongonline
git lfs install
git lfs pull
```

`git lfs pull` là bắt buộc vì client có file tài nguyên lớn được quản lý bằng Git LFS.

## 2. Tạo Database

Tạo database `hashirama` và import file SQL có sẵn:

```bash
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS hashirama CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -u root -p hashirama < SRC5M/Source5m/Sql/hashirama.sql
```

Nếu MySQL của bạn dùng user/password khác, hãy sửa lại ở bước cấu hình bên dưới.

## 3. Cấu Hình Game Server

Mở file:

```text
SRC5M/Source5m/config/server.properties
```

Kiểm tra các dòng chính:

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

Ghi chú:

- Nếu chạy server trên máy khác, đổi `127.0.0.1` trong `server.sv1` thành IP/domain mà client có thể kết nối.
- Nếu file chưa có `login.host` và `login.port`, game server sẽ mặc định kết nối login server tại `127.0.0.1:8888`.
- Nên đổi `api.key` trước khi public/chạy thật.

## 4. Cấu Hình Login Server

Mở file:

```text
SRC5M/Source5m/login/server.ini
```

Kiểm tra cấu hình database và port:

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

Thông tin database trong `server.ini` nên khớp với `config/server.properties`.

## 5. Build Game Server

Chạy trong thư mục `SRC5M/Source5m`:

```bash
cd SRC5M/Source5m
mvn clean package
```

Sau khi build thành công, file jar sẽ nằm ở:

```text
target/VIP-1.0-RELEASE-jar-with-dependencies.jar
```

## 6. Chạy Server

Cần chạy login server trước, sau đó mới chạy game server.

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

Mac/Linux có thể cần mở port trên firewall:

- `8888`: login server.
- `14445`: game server.
- `8080`: API nếu đang dùng.

## 7. Chạy Client Windows

Client nằm trong:

```text
SRC5M/Local5m
```

Nếu server và client cùng một máy Windows:

1. Mở `SRC5M/Local5m/RUN_GAME.bat`, hoặc chạy trực tiếp `ModLocal_Double.exe`.

Nếu server chạy trên máy khác:

1. Mở `SRC5M/Local5m/SETUP_PORTPROXY_ADMIN.bat`.
2. Sửa dòng `MAC_SERVER_IP` thành IP máy đang chạy server.
3. Bấm chuột phải file `.bat` và chọn `Run as administrator`.
4. Chạy `RUN_GAME.bat` hoặc `ModLocal_Double.exe`.

Tài khoản test trong database:

```text
admin1
admin123123123
```

## Lệnh Thường Dùng

Build lại server:

```bash
cd SRC5M/Source5m
mvn clean package
```

Chạy login server:

```bash
cd SRC5M/Source5m/login
java -jar ServerLogin.jar
```

Chạy game server:

```bash
cd SRC5M/Source5m
java -jar target/VIP-1.0-RELEASE-jar-with-dependencies.jar
```

Cập nhật source mới nhất:

```bash
git pull
git lfs pull
```

## Lỗi Thường Gặp

### Client không vào được server

- Kiểm tra login server đã chạy port `8888`.
- Kiểm tra game server đã chạy port `14445`.
- Kiểm tra `server.sv1` trong `config/server.properties` đúng IP/domain của server.
- Nếu dùng Windows portproxy, chạy `SETUP_PORTPROXY_ADMIN.bat` bằng quyền Administrator.

### Game server báo lỗi kết nối database

- Kiểm tra MySQL/MariaDB đang chạy.
- Kiểm tra database `hashirama` đã import thành công.
- Kiểm tra user/password trong `config/server.properties` và `login/server.ini`.

### Thiếu file client hoặc file tài nguyên bị lỗi

Chạy lại:

```bash
git lfs pull
```

### Port đã bị sử dụng

Đổi port trong:

- `SRC5M/Source5m/config/server.properties`
- `SRC5M/Source5m/login/server.ini`

Sau đó restart login server và game server.
