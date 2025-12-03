-- ============================================
-- 1. Bảng gốc không phụ thuộc
-- ============================================

CREATE TABLE tblUser (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255),
    password VARCHAR(255),
    fullName VARCHAR(255),
    role VARCHAR(255)
);

CREATE TABLE tblProvider (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    address VARCHAR(255),
    phoneNo VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE tblProduct (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    size VARCHAR(255),
    color VARCHAR(255)
);

-- ============================================
-- 2. Các bảng phụ thuộc Provider hoặc Product
-- ============================================

CREATE TABLE tblDiscount (
    id INT PRIMARY KEY AUTO_INCREMENT,
    discountCode VARCHAR(255),
    amount INT,
    tblProviderid INT,
    FOREIGN KEY (tblProviderid) REFERENCES tblProvider(id)
);

CREATE TABLE tblProviderProduct (
    id INT PRIMARY KEY AUTO_INCREMENT,
    unitPrice INT,
    tblProviderid INT,
    tblProductid INT,
    FOREIGN KEY (tblProviderid) REFERENCES tblProvider(id),
    FOREIGN KEY (tblProductid) REFERENCES tblProduct(id)
);

-- ============================================
-- 3. User roles (phụ thuộc tblUser)
-- ============================================

CREATE TABLE tblStaff (
    tblUserid INT PRIMARY KEY,
    FOREIGN KEY (tblUserid) REFERENCES tblUser(id)
);

CREATE TABLE tblManager (
    tblUserid INT PRIMARY KEY,
    FOREIGN KEY (tblUserid) REFERENCES tblUser(id)
);

CREATE TABLE tblImportStaff (
    tblUserid INT PRIMARY KEY,
    FOREIGN KEY (tblUserid) REFERENCES tblUser(id)
);

-- ============================================
-- 4. Receipt và bảng liên quan
-- ============================================

CREATE TABLE tblReceipt (
    id INT PRIMARY KEY AUTO_INCREMENT,
    createdDate DATE,
    tblUserid INT,
    tblDiscountid INT,
    tblProviderid INT,
    FOREIGN KEY (tblUserid) REFERENCES tblUser(id),
    FOREIGN KEY (tblDiscountid) REFERENCES tblDiscount(id),
    FOREIGN KEY (tblProviderid) REFERENCES tblProvider(id)
);

CREATE TABLE tblReceiptProduct (
    id INT PRIMARY KEY AUTO_INCREMENT,
    quantity INT,
    unitPrice INT,
    tblProductid INT,
    tblReceiptid INT,
    FOREIGN KEY (tblProductid) REFERENCES tblProduct(id),
    FOREIGN KEY (tblReceiptid) REFERENCES tblReceipt(id)
);

-- ============================================
-- 5. Bảng Many-to-Many cuối cùng (phụ thuộc hoàn toàn)
-- ============================================

CREATE TABLE tblProductDiscount (
    tblProductid INT,
    tblDiscountid INT,
    PRIMARY KEY (tblProductid, tblDiscountid),
    FOREIGN KEY (tblProductid) REFERENCES tblProduct(id),
    FOREIGN KEY (tblDiscountid) REFERENCES tblDiscount(id)
);

CREATE TABLE tblReceiptDiscount (
    tblDiscountid INT PRIMARY KEY,
    FOREIGN KEY (tblDiscountid) REFERENCES tblDiscount(id)
);
