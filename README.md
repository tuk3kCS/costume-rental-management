# Giới thiệu

Bài tập lớn môn Phân tích và Thiết kế Hệ thống thông tin (INT1342_CLC), HVCNBCVT.
Chức năng:
- Quản lý thông tin nhà cung cấp
- Nhập trang phục về từ nhà cung cấp
- Xem thống kê nhà cung cấp theo doanh chi

## Chuẩn bị

### Yêu cầu

- IDE bất kì, dự án này sẽ sử dụng Eclipse.
- [Apache Tomcat 9.0.112](https://tomcat.apache.org/download-90.cgi)
- MySQL 8.0 (Server, Router và Workbench)
- MySQL Connector (```mysql-connector-java-8.0.30.jar```)

### Thiết lập

1. **Clone hoặc tải file zip của dự án này về**
    ```bash
    git clone https://github.com/tuk3kCS/costume-rental-management
    cd costume-rental-management
    ```

2. **Thiết lập cơ sở dữ liệu**

- Tạo connection mới trong Workbench với tên ```costume-rental-management```, cổng 3306.
- Tạo database và các schema mới bằng file ```database_export.sql```.

3. **Thiết lập kết nối tới cơ sở dữ liệu**

- Thiết lập file ```src\main\java\dao\DAO.java``` như sau:

    ```bash
    String dbUrl = "jdbc:mysql://localhost:3306/costume_rental_management?autoReconnect=true&useSSL=false";
	String dbClass = "com.mysql.jdbc.Driver";
    con = DriverManager.getConnection (dbUrl, "root", "<mật khẩu MySQL đã thiết lập>");
    ```

4. **Khởi chạy ứng dụng**

- Cấu hình Tomcat Server trong IDE và thêm ```mysql-connector-java-8.0.30.jar``` vào thư viện.
- Khởi chạy file ```src\main\java\webapp\login.jsp```.