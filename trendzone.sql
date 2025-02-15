CREATE DATABASE trendzone;
USE trendzone;
CREATE TABLE USER (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    e_mail VARCHAR(100) UNIQUE NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    account_status ENUM('active', 'inactive', 'suspended') NOT NULL,
    registration_date DATE NOT NULL,
    last_password_change DATETIME
);
CREATE TABLE INVENTORY (
    inventoryId INT AUTO_INCREMENT PRIMARY KEY,
    productNum INT,
    warehouse_location VARCHAR(255),
    admin_id INT
);
CREATE TABLE PRODUCT (
    productId INT AUTO_INCREMENT PRIMARY KEY,
    description TEXT,
    product_name VARCHAR(255),
    price DECIMAL(10, 2),
    category VARCHAR(100),
    sellerId INT,
    discount DECIMAL(5, 2),
    origin_country VARCHAR(100),
    inventoryId INT,
	stock_level INT,
    FOREIGN KEY (inventoryId) REFERENCES INVENTORY(inventoryId));

CREATE TABLE PAYMENT_DETAIL (
    paymentId INT AUTO_INCREMENT PRIMARY KEY,
    payment_date DATE,
   customerId INT,
    paymentStatus VARCHAR(50),
    payment_method VARCHAR(50),
    billing_address TEXT
);
CREATE TABLE SUPPORT_TICKET (
    ticketId INT AUTO_INCREMENT PRIMARY KEY,
    description TEXT,
    status VARCHAR(50),
    solution TEXT,
    ticket_ownerId INT,
    adminId INT
);
CREATE TABLE CART (
    cartId INT AUTO_INCREMENT PRIMARY KEY,
    product_num INT,
    subtotal DECIMAL(10, 2)
);
CREATE TABLE CONTAINS (
    cartId INT,
    productId INT,
    quantity INT,
    PRIMARY KEY (cartId, productId),
    FOREIGN KEY (cartId) REFERENCES CART(cartId),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId)
);
CREATE TABLE PRODUCT_IMAGE (
    productId INT,
    image_url VARCHAR(255),
    PRIMARY KEY (productId,image_url),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId)
);
CREATE TABLE TICKET_OWNER (
    ticket_ownerId INT,
    PRIMARY KEY (ticket_ownerId)
);

CREATE TABLE CUSTOMER (
    userId INT,
    primeStatus VARCHAR(50),
    default_address VARCHAR(255),
    TR_identify_no VARCHAR(11),
    ticket_ownerId INT,
    cartId INT,
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES USER(userId) ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (cartId) REFERENCES CART(cartId),
   FOREIGN KEY(ticket_ownerId) REFERENCES TICKET_OWNER(ticket_ownerId)
);
CREATE TABLE SELLER (
    userId INT,
    store_name VARCHAR(255),
    business_type VARCHAR(100),
    store_location VARCHAR(255),
    bank_account VARCHAR(50),
    return_policy TEXT,
    rating DECIMAL(3, 2),
    ticket_ownerId INT,
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES USER(userId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(ticket_ownerId) REFERENCES TICKET_OWNER(ticket_ownerId)
);
CREATE TABLE ADMIN (
    userId INT,
    role VARCHAR(50),
    permissions TEXT,
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES USER(userId) ON DELETE CASCADE ON UPDATE CASCADE);
    
CREATE TABLE INTERNATIONAL_PRODUCT (
    productId INT,
    customsFee DECIMAL(10, 2),
    currency VARCHAR(50),
    customsStatus VARCHAR(50),
    ShippingTime INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE `ORDER` (
    userId INT,
    productId INT,
    order_date DATETIME,  
    shipping_address TEXT,
    order_status VARCHAR(50),
    shipmentNo INT,
    quantity INT,
    subtotal DECIMAL(10, 2),
    PRIMARY KEY (userId, productId, order_date),
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId)
);

CREATE TABLE `RETURN`  (
    returnId INT AUTO_INCREMENT PRIMARY KEY,
    return_status VARCHAR(50),
    return_date DATETIME,
    reason TEXT,
    userId INT,
    productId INT,
    order_date DATETIME,
    FOREIGN KEY (userId, productId, order_date) REFERENCES `ORDER`(userId, productId, order_date));
CREATE TABLE SHOPPING_LIST (
    userId INT,
    productId INT,
    list_name VARCHAR(255),
    privacy VARCHAR(50),
    is_default BOOLEAN,
    PRIMARY KEY (userId, productId, list_name),
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId));
CREATE TABLE PRODUCT_QUESTION (
    customerId INT,
    sellerId INT,
    productId INT,
    question_date DATE,
    question TEXT,
    answer TEXT,
    answer_date DATE,
    like_count INT,
    PRIMARY KEY (customerId, sellerId, productId, question_date),
    FOREIGN KEY (customerId) REFERENCES CUSTOMER(userId),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId),
    FOREIGN KEY (sellerId) REFERENCES SELLER(userId));
CREATE TABLE ADDRESS (
    userId INT,
    address VARCHAR(255),
    PRIMARY KEY (userId, address),
    FOREIGN KEY (userId) REFERENCES USER(userId)
);
CREATE TABLE DIAMOND_CUSTOMER (
    userId INT,
    membershipStartDate DATE,
    membershipFee DECIMAL(10, 2),
    diamondShipping BOOLEAN,
    diamondDiscount DECIMAL(5, 2),
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES CUSTOMER(userId) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE REVIEW (
    userId INT,
    productId INT,
    order_date DATETIME,
    review_date DATETIME,
    rating INT,
    comment TEXT,
    like_count INT,
    PRIMARY KEY (userId, productId, order_date, review_date),
    FOREIGN KEY (userId, productId, order_date) REFERENCES `ORDER`(userId, productId, order_date)
);
CREATE TABLE SHIPMENT (
    shipmentNo INT AUTO_INCREMENT PRIMARY KEY,
    deliveryStatus VARCHAR(50),
    estimatedDeliveryDate DATE,
    primeDeliveryDate DATE,
    trackingNumber VARCHAR(255),
    shippingProvider VARCHAR(100),
    sellerUserId INT,
    FOREIGN KEY (sellerUserId) REFERENCES SELLER(userId)
);
CREATE TABLE REVIEW_IMAGE (
    userId INT,
    productId INT,
    order_date DATETIME,
    review_date DATETIME,
    image_url VARCHAR(255),
    PRIMARY KEY (userId, productId, order_date, review_date, image_url),
    FOREIGN KEY (userId, productId, order_date, review_date) REFERENCES REVIEW(userId, productId, order_date, review_date)
);
CREATE TABLE FOLLOW (
    customerId INT,
    sellerId INT,
    PRIMARY KEY (customerId, sellerId),
    FOREIGN KEY (customerId) REFERENCES CUSTOMER(userId) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sellerId) REFERENCES SELLER(userId) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE FAVORITES (
    customerId INT,
    productId INT,
    PRIMARY KEY (customerId, productId),
    FOREIGN KEY (customerId) REFERENCES CUSTOMER(userId),
    FOREIGN KEY (productId) REFERENCES PRODUCT(productId));

-- eksik kalan foreign keyler
ALTER TABLE `ORDER`
    ADD FOREIGN KEY (shipmentNo) REFERENCES SHIPMENT(shipmentNo);
ALTER TABLE SUPPORT_TICKET
    ADD FOREIGN KEY (adminId) REFERENCES ADMIN(userId),
    ADD FOREIGN KEY (ticket_ownerId) REFERENCES TICKET_OWNER(ticket_ownerId);
ALTER TABLE PRODUCT
ADD FOREIGN KEY(sellerId) REFERENCES SELLER(userId);

ALTER TABLE INVENTORY
ADD FOREIGN KEY(admin_id) REFERENCES ADMIN(userId);

ALTER TABLE PAYMENT_DETAIL
ADD FOREIGN KEY(customerId) REFERENCES CUSTOMER(userId);

-- check consraints
ALTER TABLE PRODUCT 
ADD CONSTRAINT chk_discount CHECK (discount >= 0 AND discount <= 100);

ALTER TABLE REVIEW
ADD CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5), ADD CONSTRAINT chk_review_date CHECK (review_date >= order_date);

ALTER TABLE SHOPPING_LIST
ADD CONSTRAINT chk_privacy CHECK (privacy IN ('public', 'private', 'shared'));

INSERT INTO USER (username, e_mail, user_password, account_status, registration_date, last_password_change) VALUES
('Ahmet Yılmaz', 'ahmet.yilmaz@example.com', 'password123', 'active', '2024-01-01', NULL),
('Mehmet Kaya', 'mehmet.kaya@example.com', 'password123', 'active', '2024-01-02', NULL),
('Bengi İlhan','bengi.ilhan@example.com', 'password123', 'active', '2024-01-03', NULL),
('Fatma Çelik', 'fatma.celik@example.com', 'password123', 'active', '2024-01-04', NULL),
('Mahmut Karabulut','Mahmut.karabulut@example.com', 'password123', 'active', '2024-01-05', NULL),
('Alperen Uysal','alperen.uysal@example.com','password123', 'active', '2024-01-06', NULL),
('Hülya Hare', 'hülya.hare@example.com', 'password123', 'active', '2024-01-07', NULL),
('Mert Özkan', 'mert.ozkan@example.com', 'password123', 'active', '2024-01-08', NULL),
('Zeynep Koç', 'zeynep.koc@example.com', 'password123', 'active', '2024-01-09', NULL),
('Elif Yıldız', 'elif.yildiz@example.com', 'password123', 'active', '2024-01-10', NULL),
('Burak Aydın', 'burak.aydin@example.com', 'password123', 'active', '2024-01-11', NULL),
('Gökhan Aksoy', 'gokhan.aksoy@example.com', 'password123', 'active', '2024-01-12', NULL),
('Ebru Güneş', 'ebru.gunes@example.com', 'password123', 'active', '2024-01-13', NULL),
('Can Yalçın', 'can.yalcin@example.com', 'password123', 'active', '2024-01-14', NULL),
('Buse Acar', 'buse.acar@example.com', 'password123', 'active', '2024-01-15', NULL),
('İbrahim Eren', 'ibrahim.eren@example.com', 'password123', 'active', '2024-01-16', NULL),
('Hakan Öztürk', 'hakan.ozturk@example.com', 'password123', 'active', '2024-01-17', NULL),
('Emre Çalışkan', 'emre.caliskan@example.com', 'password123', 'active', '2024-01-18', NULL),
('Dilara Tunç', 'dilara.tunc@example.com', 'password123', 'active', '2024-01-19', NULL),
('Esra Tekin', 'esra.tekin@example.com', 'password123', 'active', '2024-01-20', NULL),
('Ayşe Yılmaz', 'ay.yilmaz@example.com', 'password123', 'active', '2024-01-01', NULL),
('Müge Kaya', 'müge.kaya@example.com', 'password123', 'active', '2024-01-02', NULL);

INSERT INTO ADMIN (userId, role, permissions) VALUES
(16, 'superadmin', 'all'),
(17, 'product_manager', 'manage_products'),
(18, 'support_manager', 'manage_support'),
(19, 'order_manager', 'manage_orders'),
(20, 'inventory_manager', 'manage_inventory');

INSERT INTO Inventory (productNum, warehouse_location, admin_id) VALUES
(5, 'USA',20),
(5, 'Ankara',20),
(5, 'Izmir',20),
(5, 'Bursa',20),
(5, 'Antalya', 20),
(3, 'Ankara',20),
(1, 'Ankara',20);

INSERT INTO TICKET_OWNER(ticket_ownerId) VALUES
(1),
(2),
(3),
(4),
(5);

INSERT INTO CART (cartId, product_num, subtotal) VALUES
(1, null, null),
(2, null, null),
(3, null, null),
(4, null, null),
(5, null, null),
(6, null, null),
(7, null, null),
(8, null, null),
(9, null, null),
(10, null, null);

INSERT INTO SELLER (userId, store_name, business_type, store_location, bank_account, return_policy, rating, ticket_ownerId) VALUES
(11, 'Burak Elektronik', 'elektronik', 'İstanbul, Türkiye', 'TR0011111111', '30 gün iade', 4.5, null),
(12, 'Gökhan Giyim', 'tekstil', 'Ankara, Türkiye', 'TR0022222222', '14 gün iade', 4.2, 5),
(13, 'Ebru Kitap', 'kitap', 'Muğla, Türkiye', 'TR0033333333', '10 gün iade', 4.7, null),
(14, 'Can Spor', 'spor', 'Bursa, Türkiye', 'TR0044444444', '15 gün iade', 4.8, null),
(15, 'Buse Kozmetik', 'kozmetik', 'Antalya, Türkiye', 'TR0055555555', '7 gün iade', 4.9, null);

INSERT INTO SELLER (userId, store_name, business_type, store_location, bank_account, return_policy, rating, ticket_ownerId) VALUES
(21, 'Ayşe Kozmetik', 'kozmetik', 'İstanbul, Türkiye', 'TR0011111112', '30 gün iade', 4.5, null),
(22, 'Müge Kozmetik', 'kozmetik', 'Ankara, Türkiye', 'TR0022222221', '14 gün iade', 4.2, null);
INSERT INTO CUSTOMER (userId, primeStatus, default_address, TR_identify_no, ticket_ownerId, cartId) VALUES
(1, 'standard', 'Ankara, Türkiye', '11111111111', 1, 1),
(2, 'prime', 'İstanbul, Türkiye', '22222222222', null, 2),
(3, 'standard', 'İzmir, Türkiye', '33333333333', 3, 3),
(4, 'prime', 'Bursa, Türkiye', '44444444444', null, 4),
(5, 'standard', 'Adana, Türkiye', '55555555555', null, 5),
(6, 'prime', 'İzmir, Türkiye', '66666666666', 2, 6),
(7, 'standard', 'Aydın, Türkiye', '77777777777', null, 7),
(8, 'prime', 'Gaziantep, Türkiye', '88888888888', 4, 8),
(9, 'standard', 'Kayseri, Türkiye', '99999999999', null, 9),
(10, 'prime', 'Konya, Türkiye', '00000000000', null, 10);

INSERT INTO DIAMOND_CUSTOMER (userId, membershipStartDate, membershipFee, diamondShipping, diamondDiscount) VALUES
(2, '2024-01-02', 200.00, TRUE, 10.00),
(4, '2025-01-01', 200.00, TRUE, 10.00),
(6, '2024-04-21', 200.00, TRUE, 10.00),
(8, '2024-06-06', 200.00, TRUE, 10.00),
(10, '2025-01-05', 200.00, TRUE, 10.00);

INSERT INTO SUPPORT_TICKET (description, status, solution, ticket_ownerId, adminId) VALUES
('Sipariş teslim edilmedi', 'open', NULL, 1, 16),
('Ürün hasarlı geldi', 'in progress', 'Hasarlı ürün değişimi yapılacak', 2, 17),
('Yanlış ürün gönderildi', 'closed', 'Ürün doğru ürünle değiştirildi', 3, 18),
('Kargo bilgileri güncellenmedi', 'open', NULL, 4, 19),
('İade sorunu','open', NULL, 5, 20);

INSERT INTO PRODUCT (description, product_name, price, category, sellerId, discount, origin_country, inventoryId, stock_level) VALUES
('Ergonomik bilgisayar sandalyesi', 'Bilgisayar Sandalyesi', 1100.00, 'Ofis', 11, 20.00, 'USA', 1, 25),
('16 GB DDR4 RAM', 'Yüksek Hızlı RAM', 800.00, 'Elektronik', 11, 10.00, ' USA', 1, 50),
('512 GB SSD', 'Yüksek Kapasiteli SSD', 1200.00, 'Elektronik', 11, 15.00, 'USA', 1, 35),
('Akıllı telefon', 'Telefon X', 9000.00, 'Elektronik', 13, 5.00, ' USA', 1, 20),
('Bluetooth hoparlör', 'Kablosuz Hoparlör', 600.00, 'Elektronik', 11, 8.00, ' USA', 1,40),

('Erkek gömlek', 'Gömlek', 125.50, 'tekstil', 12, 10, 'Türkiye', 2, 50),
('Kadın tişört', 'Tişört', 85.99, 'tekstil', 12, 5, 'Türkiye', 2, 7),
('Pantolon', 'Jean', 175.75, 'tekstil', 12, 8, 'Türkiye', 2, 30),
('Kadın ceket', 'Ceket', 250.99, 'tekstil', 12, 12, 'Türkiye', 2, 25),
('Spor ayakkabı', 'Ayakkabı', 375.00, 'tekstil', 12, 18, 'Türkiye', 2, 40),

('Roman', 'Kitap A', 50.99, 'kitap', 13, 5, 'Türkiye', 3, 300),
('Bilim kitabı', 'Kitap B', 75.75, 'kitap', 13, 8, 'Türkiye', 3, 200),
('Masal kitabı', 'Kitap C', 30.50, 'kitap', 13, 10, 'Türkiye', 3, 500),
('Ders kitabı', 'Kitap D', 125.25, 'kitap', 13, 7, 'Türkiye', 3, 100),
('Ansiklopedi', 'Kitap E', 250.99, 'kitap', 13, 12, 'Türkiye', 3, 20),

('Yoga matı', 'Yoga Mat', 150.50, 'spor', 14, 10, 'Türkiye', 4, 10),
('Dambıl seti', 'Dambıl', 350.75, 'spor', 14, 15, 'Türkiye', 4, 30),
('Basketbol topu', 'Top', 125.99, 'spor', 14, 8, 'Türkiye', 4, 40),
('Koşu bandı', 'Bant', 4500.75, 'spor', 14, 10, 'Türkiye', 4, 10),
('Fitness eldiveni', 'Eldiven', 75.25, 'spor', 14, 20, 'Türkiye', 4, 80),

('Ruj', 'Ruj Kırmızı', 99.50, 'kozmetik', 15, 5, 'Türkiye', 5, 100),
('Parfüm', 'Parfüm', 299.99, 'kozmetik', 15, 12, 'Türkiye', 5, 50),
('Cilt kremi', 'Krem', 125.75, 'kozmetik', 15, 8, 'Türkiye', 5, 70),
('Şampuan', 'Şampuan', 75.99, 'kozmetik', 15, 5, 'Türkiye', 5, 150),
('Saç spreyi', 'Sprey', 50.25, 'kozmetik', 15, 10, 'Türkiye', 5, 200),

('Güneş kremi', 'Güneş kremi', 300.00, 'kozmetik', 15, 0, 'Türkiye', 5, 200),
('Simli Oje', 'Oje', 30.00, 'kozmetik', 15, 0, 'Türkiye', 5, 50),
('Yüz maskesi', 'Maske', 20.00, 'kozmetik', 15, 0, 'Türkiye', 5, 200);
INSERT INTO PRODUCT (description, product_name, price, category, sellerId, discount, origin_country, inventoryId, stock_level) VALUES
('Cilt kremi', 'Krem', 100.00, 'kozmetik', 21, 8, 'Türkiye', 6, 70),
('Şampuan', 'Şampuan', 100.00, 'kozmetik', 21, 5, 'Türkiye', 6, 150),
('Güneş kremi', 'Güneş kremi', 450.00, 'kozmetik', 21, 0, 'Türkiye', 6, 200),
('Güneş kremi', 'Güneş kremi', 330.00, 'kozmetik', 22, 0, 'Türkiye', 7, 200);


INSERT INTO INTERNATIONAL_PRODUCT (productId, customsFee, currency, customsStatus, ShippingTime) VALUES
(1, 10.00, 'USD', 'Cleared', 7),
(2, 35.00, 'USD', 'Pending', 10),
(3, 60.00, 'USD', 'Cleared', 5),
(4, 150.00, 'USD', 'Pending', 14),
(5, 25.00, 'USD', 'Cleared', 5);

INSERT INTO SHIPMENT (deliveryStatus, estimatedDeliveryDate, primeDeliveryDate, trackingNumber, shippingProvider, sellerUserId) VALUES
('Shipped', '2025-01-10', '2025-01-09', '12345', 'UPS', 11),
('Shipped', '2025-01-11', '2025-01-10', '12346', 'PTT', 11),
('Delivered', '2025-01-12', '2025-01-11', '12347', 'UPS', 11),
('Delivered', '2025-01-10', '2025-01-09', '12348', 'PTT', 12),
('Delivered', '2025-01-16', '2025-01-14', '12349', 'UPS', 12),
('Delivered', '2025-01-14', '2025-01-13', '12350', 'PTT', 12),
('Shipped', '2025-01-10', '2025-01-08', '12351', 'UPS', 13),
('Delivered', '2025-01-11', '2025-01-10', '12352', 'PTT', 15),
('Delivered', '2025-01-11', '2025-01-10', '12353', 'PTT', 15),
('Shipped', '2025-01-10', '2025-01-09', '12354', 'UPS', 14),
('Delivered', '2024-12-22', '2024-01-21', '12355', 'PTT', 12),
('Delivered', '2024-12-24', '2025-01-23', '12356', 'PTT', 13),
('Delivered', '2025-01-03', '2025-01-02', '12357', 'PTT', 13),
('Delivered', '2025-01-04', '2025-01-03', '12358', 'PTT', 14);

INSERT INTO ADDRESS (userId, address) VALUES
-- Ahmet Yılmaz (Default: Ankara, Türkiye)
(1, 'Ankara, Türkiye'),
(1, 'İstanbul, Türkiye'),
(1, 'İzmir, Türkiye'),

-- Mehmet Kaya (Default: İstanbul, Türkiye)
(2, 'İstanbul, Türkiye'),
(2, 'Antalya, Türkiye'),

-- Bengi İlhan (Default: İzmir, Türkiye)
(3, 'İzmir, Türkiye'),
(3, 'Bursa, Türkiye'),

-- Fatma Çelik (Default: Bursa, Türkiye)
(4, 'Bursa, Türkiye'),
(4, 'Adana, Türkiye'),
(4, 'Mersin, Türkiye'),

-- Mahmut Karabulut (Default: Adana, Türkiye)
(5, 'Adana, Türkiye'),

-- Alperen Uysal (Default: İzmir, Türkiye)
(6, 'İzmir, Türkiye'),
(6, 'Ankara, Türkiye'),

-- Hülya Hare (Default: Aydın, Türkiye)
(7, 'Aydın, Türkiye'),

-- Mert Özkan (Default: Gaziantep, Türkiye)
(8, 'Gaziantep, Türkiye'),
(8, 'Hatay, Türkiye'),

-- Zeynep Koç (Default: Kayseri, Türkiye)
(9, 'Kayseri, Türkiye'),
(9, 'Konya, Türkiye'),

-- Elif Yıldız (Default: Konya, Türkiye)
(10, 'Konya, Türkiye'),
(10, 'Nevşehir, Türkiye');

INSERT INTO FAVORITES (customerId, productId) VALUES
(1, 1), (1, 11), (1, 16),
(2, 2), (2, 15), (2, 21),
(3, 3), (3, 12), (3, 18),
(4, 4), (4, 7), (4, 25),
(5, 5), (5, 8), (5, 13),
(6, 6), (6, 17), (6, 22),
(7, 7), (7, 23), (7, 20),
(8, 8), (8, 24), (8, 14),
(9, 9), (9, 19), (9, 10),
(10, 11), (10, 16), (10, 25);

INSERT INTO PRODUCT_IMAGE (productId, image_url) VALUES
(1, 'https://example.com/images/bilgisayar_sandalyesi.jpg'),(2, 'https://example.com/images/ram.jpg'),
(3, 'https://example.com/images/ssd.jpg'),(4, 'https://example.com/images/telefon_x.jpg'),
(5, 'https://example.com/images/hoparlor.jpg'),(6, 'https://example.com/images/gomlek.jpg'),
(7, 'https://example.com/images/tisort.jpg'),(8, 'https://example.com/images/jean.jpg'),
(9, 'https://example.com/images/ceket.jpg'),(10, 'https://example.com/images/ayakkabi.jpg'),
(11, 'https://example.com/images/kitap_a.jpg'),(12, 'https://example.com/images/kitap_b.jpg'),
(13, 'https://example.com/images/kitap_c.jpg'),(14, 'https://example.com/images/kitap_d.jpg'),
(15, 'https://example.com/images/kitap_e.jpg'),(16, 'https://example.com/images/yoga_mati.jpg'),
(17, 'https://example.com/images/dambil.jpg'),(18, 'https://example.com/images/top.jpg'),
(19, 'https://example.com/images/bant.jpg'),(20, 'https://example.com/images/eldiven.jpg'),
(21, 'https://example.com/images/ruj.jpg'),(22, 'https://example.com/images/parfum.jpg'),
(23, 'https://example.com/images/krem.jpg'),(24, 'https://example.com/images/sampuan.jpg'),
(25, 'https://example.com/images/sprey.jpg');

INSERT INTO SHOPPING_LIST (userId, productId, list_name, privacy, is_default) VALUES
(1, 1, 'Ofis İhtiyaçları', 'private', TRUE),(1, 2, 'Ofis İhtiyaçları', 'private', TRUE),
(1, 3, 'Bilgisayar Ekipmanları', 'public', FALSE),(1, 4, 'Bilgisayar Ekipmanları', 'public', FALSE),
(1, 5, 'Yeni Alışveriş', 'private', FALSE),(1, 6, 'Yeni Alışveriş', 'private', FALSE),
(2, 7, 'Yazlık Giyim', 'public', TRUE),(2, 8, 'Yazlık Giyim', 'public', TRUE),
(2, 9, 'Kışlık Giyim', 'private', FALSE),(2, 10, 'Kışlık Giyim', 'private', FALSE),
(2, 4, 'Teknolojik Ürünler', 'public', FALSE),(2, 5, 'Teknolojik Ürünler', 'public', FALSE),
(3, 20, 'Spor ve Fitness', 'private', TRUE),(3, 17, 'Spor ve Fitness', 'private', TRUE),
(3, 16, 'Yoga Ürünleri', 'private', FALSE),(3, 20, 'Yoga Ürünleri', 'private', FALSE),
(4, 11, 'Kitap Listesi', 'public', TRUE),(4, 13, 'Kitap Listesi', 'public', TRUE),
(4, 12, 'Felsefe Kitapları', 'private', FALSE),(4, 13, 'Felsefe Kitapları', 'private', FALSE),
(5, 21, 'Kozmetik Ürünleri', 'public', TRUE),(5, 22, 'Kozmetik Ürünleri', 'public', TRUE),
(5, 23, 'Cilt Bakım Ürünleri', 'private', FALSE),(5, 24, 'Cilt Bakım Ürünleri', 'private', FALSE),
(6, 11, 'Spor Ekipmanları', 'public', TRUE),(6, 12, 'Spor Ekipmanları', 'public', TRUE),
(7, 3, 'Elektronik Alışveriş', 'public', TRUE),(7, 4, 'Elektronik Alışveriş', 'public', TRUE),
(8, 6, 'Yazlık Ürünler', 'private', TRUE),(8, 7, 'Yazlık Ürünler', 'private', TRUE),
(9, 13, 'Kitaplar', 'private', FALSE),(9, 14, 'Çocuk Kitapları', 'private', FALSE),
(10, 12, 'Spor ve Sağlık', 'private', TRUE);

INSERT INTO FOLLOW (customerId, sellerId) VALUES
(1, 11),  (2, 12),  (3, 13),  (4, 14),  (5, 15),  
(6, 11),  (7, 12),  (8, 13),  (9, 14), (10, 15), 
(1, 12), (2, 13), (3, 14),  (4, 15),(5, 11);

INSERT INTO PAYMENT_DETAIL (payment_date, customerId, paymentStatus, payment_method, billing_address) VALUES
('2025-01-07', 1, 'paid', 'credit_card', 'Ankara, Türkiye'),
('2025-01-03', 2, 'paid', 'bank_transfer', 'İstanbul, Türkiye'),
('2025-01-09', 3, 'paid', 'paypal', 'İzmir, Türkiye'),
('2025-01-15', 4, 'paid', 'credit_card', 'Bursa, Türkiye'),
('2025-01-06', 5, 'paid', 'debit_card', 'Adana, Türkiye'),
('2025-01-07', 6, 'paid', 'credit_card', 'İzmir, Türkiye'),
('2025-01-08', 7, 'paid', 'paypal', 'Aydın, Türkiye'),
('2025-01-08', 7, 'paid', 'credit_card', 'İzmir, Türkiye'),
('2025-01-09', 7, 'paid', 'bank_transfer', 'İzmir, Türkiye'),
('2025-01-09', 1, 'paid', 'paypal', 'Ankara, Türkiye'),
('2024-12-20', 3, 'paid', 'credit_card', 'İzmir, Türkiye'),
('2024-12-21', 3, 'paid', 'bank_transfer', 'İzmir, Türkiye'),
('2025-01-01', 5, 'paid', 'paypal', 'Adana, Türkiye'),
('2025-01-02', 5, 'paid', 'credit_card', 'Adana, Türkiye');
INSERT INTO REVIEW (userId, productId, order_date, review_date, rating, comment, like_count) VALUES
(3, 5, '2025-01-09 16:00:00', '2025-01-12 16:00:00', 3, 'Ürün beklentilerimi tam olarak karşılamadı.', 3),
(3, 6, '2025-01-09 16:00:00', '2025-01-10 16:00:00', 4, 'İyi ürün, biraz daha dayanıklı olabilirdi.', 6),
(4, 7, '2025-01-15 11:00:00', '2025-01-16 11:00:00', 5, 'Mükemmel bir ürün, kesinlikle tavsiye ederim!', 2),
(4, 8, '2025-01-15 11:00:00', '2025-01-16 11:00:00', 4, 'Gayet iyi, fiyat/performans açısından başarılı.', 3),
(5, 9, '2025-01-06 12:00:00', '2025-01-14 12:00:00', 2, 'Beklediğim gibi çıkmadı, hayal kırıklığına uğradım.', 2),
(5, 10, '2025-01-06 12:00:00', '2025-01-14 12:00:00', 3, 'Ortalama bir ürün, daha iyi olabilir.', 4),
(6, 11, '2025-01-07 09:30:00', '2025-01-10 09:30:00', 5, 'Çok kullanışlı, teşekkür ederim!', 5),
(6, 12, '2025-01-07 09:30:00', '2025-01-10 09:30:00', 4, 'Güzel kitap', 1),
(7, 13, '2025-01-08 13:00:00', '2025-01-10 13:00:00', 5, 'Mükemmel, tavsiye ederim!', 1),
(3, 7, '2024-12-20 16:00:00', '2024-12-23 16:00:00', 5, 'Çok beğendim', 3);

INSERT INTO REVIEW_IMAGE (userId, productId, order_date, review_date, image_url) VALUES
(3, 5, '2025-01-09 16:00:00', '2025-01-12 16:00:00', 'https://example.com/images/product5_review3.jpg'),
(3, 6, '2025-01-09 16:00:00', '2025-01-10 16:00:00', 'https://example.com/images/product6_review3.jpg'),
(4, 7, '2025-01-15 11:00:00', '2025-01-16 11:00:00', 'https://example.com/images/product7_review4.jpg'),
(5, 9, '2025-01-06 12:00:00', '2025-01-14 12:00:00', 'https://example.com/images/product9_review5.jpg'),
(5, 10, '2025-01-06 12:00:00', '2025-01-14 12:00:00', 'https://example.com/images/product10_review5.jpg'),
(6, 12, '2025-01-07 09:30:00', '2025-01-10 09:30:00', 'https://example.com/images/product12_review6.jpg'),
(7, 13, '2025-01-08 13:00:00', '2025-01-10 13:00:00', 'https://example.com/images/product13_review7.jpg');

INSERT INTO PRODUCT_QUESTION (customerId, sellerId, productId, question_date, question, answer, answer_date, like_count) VALUES
(10, 11, 3, '2025-01-11', 'SSDnin okuma ve yazma hızı nedir?', null, null, 2),
(1, 11, 1, '2025-01-05', 'Bu sandalye ergonomik olarak nasıl, uzun süre kullanımı rahat mı?', 'Evet, uzun süre kullanımlar için uygun ve rahat bir tasarımı var.', '2025-01-06', 5),
(2, 11, 2, '2025-01-04', 'Bu RAM bilgisayarımı hızlandırır mı?', 'Evet, yüksek hızda veri işleme kapasitesine sahip.', '2025-01-05', 3),
(3, 11, 4, '2025-01-10', 'Telefon Xin kamerası nasıl?', 'Telefonun kamerası oldukça iyi, 48 MP çözünürlük sunuyor.', '2025-01-11', 7),
(4, 12, 6, '2025-01-12', 'Bu gömlek hangi bedende mevcut?', 'Gömlek beden seçenekleri M, L ve XL olarak mevcut.', '2025-01-13', 4),
(5, 12, 7, '2025-01-05', 'Kadın tişörtü nasıl bir kumaştan yapılmış?', 'Pamuk karışımlı, yumuşak ve rahat bir kumaşı var.', '2025-01-09', 2),
(6, 14, 16, '2025-01-07', 'Yoga matı kaymaz mı?', 'Evet, matın alt kısmı kaymaz özellikte, güvenli bir kullanım sunar.', '2025-01-08', 3),
(8, 15, 24, '2025-01-09', 'Şampuanın saç dökülmesine etkisi var mı?', 'Şampuan saç dökülmesini engellemeye yardımcı olabilecek bitkisel içeriklere sahip.', '2025-01-10', 1),
(9, 14, 17, '2025-01-13', 'Dambıl seti kaç kiloluk?', 'Dambıl seti 2 kg, 4 kg, 6 kg olarak farklı seçeneklerde sunulmaktadır.', '2025-01-14', 5);

INSERT INTO `RETURN` (return_status, return_date, reason, userId, productId, order_date)
VALUES
('returned', '2025-01-14 12:00:00', 'Product not as expected', 1, 1, '2025-01-07 10:00:00'),
('returned', '2025-01-16 11:00:00', 'Damaged item', 2, 4, '2025-01-03 14:30:00'),
('returned', '2025-01-17 16:00:00', 'Changed mind', 3, 5, '2025-01-09 16:00:00'),
('returned', '2025-01-15 12:00:00', 'Wrong size', 5, 10, '2025-01-06 12:00:00');

DELIMITER $$

CREATE TRIGGER after_insert_on_contains
AFTER INSERT ON CONTAINS
FOR EACH ROW
BEGIN
    DECLARE subtotal DECIMAL(10,2);
    DECLARE total_quantity INT;

    -- Subtotal Hesaplama: Aynı cartId'ye ait tüm ürünlerin toplam fiyatını hesapla
    SELECT SUM(P.price * C.quantity * (1 - P.discount / 100))
    INTO subtotal
    FROM CONTAINS C
    JOIN PRODUCT P ON C.productId = P.productId
    WHERE C.cartId = NEW.cartId;

    -- Product_num Hesaplama: Aynı cartId'ye ait tüm ürünlerin toplam miktarını hesapla
    SELECT SUM(C.quantity)
    INTO total_quantity
    FROM CONTAINS C
    WHERE C.cartId = NEW.cartId;

    -- CART Güncelleme: subtotal ve product_num değerlerini güncelle
    UPDATE CART
    SET subtotal = subtotal,
        product_num = total_quantity
    WHERE cartId = NEW.cartId;
END$$

DELIMITER ;


INSERT INTO CONTAINS (cartId, productId, quantity) VALUES
(1, 1, 1),(1, 3, 1), 
(2, 6, 2), (2, 9, 1),(2, 12, 1),
(3, 11, 1),(3, 12, 1), 
(4, 18, 1), 
(5, 21, 1), (5, 22, 1), (5, 25, 1), 
(6, 8, 1), (6, 13, 1),
(7, 24, 2),
(8, 13, 1),
(9, 16, 1), 
(10, 6, 1), (10, 7, 1), (10, 8, 1); 

-- order için subtotal hesaplayan trigger
DELIMITER $$

CREATE TRIGGER calculate_subtotal_before_insert
BEFORE INSERT ON `ORDER`
FOR EACH ROW
BEGIN
    DECLARE discounted_price DECIMAL(10,2);

    -- İlgili ürünün indirimli fiyatını hesapla
    SELECT price - (price * discount / 100)
    INTO discounted_price
    FROM PRODUCT
    WHERE productId = NEW.productId;

    -- Subtotal hesapla
    SET NEW.subtotal = discounted_price * NEW.quantity;
END$$

DELIMITER ;

INSERT INTO `ORDER` (userId, productId, order_date, shipping_address, order_status, shipmentNo, quantity, subtotal)
VALUES
(1, 1, '2025-01-07 10:00:00', 'Ankara, Türkiye', 'shipped', 1, 2, 0),
(1, 2, '2025-01-07 10:00:00', 'Ankara, Türkiye', 'shipped', 1, 3, 0),
(2, 3, '2025-01-03 14:30:00', 'İstanbul, Türkiye', 'shipped', 2, 1, 0),
(2, 4, '2025-01-03 14:30:00', 'İstanbul, Türkiye', 'shipped', 2, 4, 0),
(3, 5, '2025-01-09 16:00:00', 'İzmir, Türkiye', 'delivered', 3, 2, 0),
(3, 6, '2025-01-09 16:00:00', 'İzmir, Türkiye', 'delivered', 4, 1, 0),
(4, 7, '2025-01-15 11:00:00', 'Bursa, Türkiye', 'delivered', 5, 5, 0),
(4, 8, '2025-01-15 11:00:00', 'Bursa, Türkiye', 'delivered', 5, 3, 0),
(5, 9, '2025-01-06 12:00:00', 'Adana, Türkiye', 'delivered', 6, 4, 0),
(5, 10, '2025-01-06 12:00:00', 'Adana, Türkiye', 'delivered', 6, 2, 0),
(6, 11, '2025-01-07 09:30:00', 'İzmir, Türkiye', 'delivered', 7, 2, 0),
(6, 12, '2025-01-07 09:30:00', 'İzmir, Türkiye', 'delivered', 7, 1, 0),
(7, 13, '2025-01-08 13:00:00', 'Aydın, Türkiye', 'delivered', 8, 3, 0),
(7, 27, '2025-01-09 15:00:00', 'İzmir, Türkiye', 'delivered', 9, 1, 0),
(7, 26, '2025-01-09 15:00:00', 'İzmir, Türkiye', 'delivered', 9, 1, 0),
(1, 21, '2025-01-09 13:30:00', 'Ankara, Türkiye', 'shipped', 10, 1, 0),
(3, 7, '2024-12-20 16:00:00', 'İzmir, Türkiye', 'delivered', 11, 2, 0),
(3, 11, '2024-12-21 16:00:00', 'İzmir, Türkiye', 'delivered', 12, 1, 0),
(5, 11, '2025-01-01 12:00:00', 'Adana, Türkiye', 'delivered', 13, 1, 0),
(5, 19, '2025-01-02 12:00:00', 'Adana, Türkiye', 'delivered', 14, 2, 0);


 -- last_password_change update trigger
DELIMITER $$
CREATE TRIGGER update_password_change_date
BEFORE UPDATE ON user
FOR EACH ROW
BEGIN
    IF OLD.user_password != NEW.user_password THEN
        SET NEW.last_password_change = NOW();  
    END IF;
END$$
DELIMITER ;

-- user password update ile trigger çalışması örneği
UPDATE USER
SET user_password = 'newpassword123'
WHERE userId = 1;

-- örnek delete işlemi
DELETE FROM PRODUCT
WHERE productId = 28;
-- aynı isimdeki ürünlerin fiyata göre listelenmesi (join 2 table)
SELECT product_name, store_name, price
FROM PRODUCT
JOIN SELLER ON PRODUCT.sellerId = SELLER.userId
WHERE product_name = "Güneş kremi"
ORDER BY PRODUCT.price;
-- bir ürüne yapılan yorumlar (join 2 table)
SELECT product_name, comment, rating
FROM REVIEW, PRODUCT
WHERE REVIEW.productId = PRODUCT.productId AND product_name= "Tişört";
-- bir sellera sorulan soruların listelenmesi (join 2 table)
SELECT question,question_date,product_name
FROM PRODUCT_QUESTION JOIN PRODUCT ON PRODUCT_QUESTION.productId =PRODUCT.productId
WHERE PRODUCT_QUESTION.sellerId= 12;
-- ismi girilen müşterinin favorilerindeki ürünler (join 3 table)
SELECT product_name,description,price
FROM FAVORITES, PRODUCT ,USER
WHERE FAVORITES.productId = PRODUCT.productId AND FAVORITES.customerId = USER.userId 
AND USER.username= 'Mahmut Karabulut';
-- Satıcılar, ürünleri ve satılma miktarı (join 3 table)
SELECT 
    SELLER.store_name,
    PRODUCT.product_name,
    SUM(`ORDER`.quantity) AS total_sold
FROM 
    SELLER JOIN PRODUCT ON SELLER.userId = PRODUCT.sellerId 
    JOIN `ORDER` ON PRODUCT.productId = `ORDER`.productId
GROUP BY SELLER.store_name, PRODUCT.product_name;

-- hesabı aktif ve prime üyeleri üyelik tarihine göre listeleme (join 3 table)
SELECT C.userId, U.username, C.primeStatus, D.membershipStartDate, D.diamondDiscount
FROM CUSTOMER C
JOIN USER U ON C.userId = U.userId
JOIN DIAMOND_CUSTOMER D ON C.userId = D.userId
WHERE U.account_status = 'active'
ORDER BY D.membershipStartDate DESC;

-- international ürün almış kişiler (join 4 table)
SELECT USER.username, PRODUCT.product_name, PRODUCT.price, INTERNATIONAL_PRODUCT.customsFee
FROM USER
JOIN `ORDER` ON USER.userId = `ORDER`.userId
JOIN PRODUCT ON `ORDER`.productId = PRODUCT.productId
JOIN INTERNATIONAL_PRODUCT ON PRODUCT.productId = INTERNATIONAL_PRODUCT.productId;

-- Satıcıların iade edilen ürünlerini ve geri ödeme durumlarını takip eden sorgu
SELECT 
    SELLER.store_name,
    PRODUCT.product_name,
    `RETURN`.return_status,
    COUNT(`RETURN`.returnId) AS return_count
FROM 
    SELLER JOIN PRODUCT ON SELLER.userId = PRODUCT.sellerId
    JOIN `RETURN` ON PRODUCT.productId = `RETURN`.productId
GROUP BY 
    SELLER.store_name, PRODUCT.product_name, `RETURN`.return_status;
-- gönderi bazında sipariş geçmişi 
SELECT userId, order_date, 
       SUM(quantity) AS total_quantity, 
       SUM(subtotal) AS total_subtotal,
       GROUP_CONCAT(DISTINCT productId) AS productIds,
       order_status
FROM `ORDER`
WHERE userId = 3
GROUP BY userId, order_date, order_status
ORDER BY order_date DESC;
-- en çok satan 5 ürünün listelenmesi azalan sırada
SELECT 
    PRODUCT.product_name,
    PRODUCT.description,
    PRODUCT.price,
    PRODUCT.category,
    SUM(`ORDER`.quantity) AS total_quantity_sold
FROM 
    PRODUCT
JOIN 
    `ORDER` ON PRODUCT.productId = `ORDER`.productId
GROUP BY 
    PRODUCT.productId, PRODUCT.product_name, PRODUCT.description, PRODUCT.price, PRODUCT.category
ORDER BY 
    total_quantity_sold DESC
LIMIT 5;

-- customerlara ve sellerlara ait açık durumdaki destek taleplerini listeleme
SELECT 
    USER.username, 
    USER.e_mail, 
    SUPPORT_TICKET.description, 
    SUPPORT_TICKET.adminId
FROM 
    USER JOIN CUSTOMER ON CUSTOMER.userId = USER.userId
    JOIN SUPPORT_TICKET ON CUSTOMER.ticket_ownerId = SUPPORT_TICKET.ticket_ownerId
WHERE SUPPORT_TICKET.status = 'open'
UNION
SELECT 
    USER.username, 
    USER.e_mail, 
    SUPPORT_TICKET.description, 
    SUPPORT_TICKET.adminId
FROM 
    USER JOIN SELLER ON SELLER.userId = USER.userId
    JOIN  SUPPORT_TICKET ON SELLER.ticket_ownerId = SUPPORT_TICKET.ticket_ownerId
WHERE SUPPORT_TICKET.status = 'open';

-- toplam 3000 tlden daha fazla tutarda alışveriş yapmış kişilerin isimleri ve toplam tutar
SELECT 
    USER.username, 
    SUM(`ORDER`.subtotal) AS total_subtotal
FROM 
    USER JOIN `ORDER` ON USER.userId = `ORDER`.userId
GROUP BY 
    USER.userId, USER.username
HAVING SUM(`ORDER`.subtotal) > 3000
ORDER BY total_subtotal DESC;




