-- =====================================================
--   Seed Data — Categories & Products
-- =====================================================
USE ecommerce_db;

INSERT INTO categories (category_name, parent_category) VALUES
('Electronics',''),
('Mobile Phones','Electronics'),
('Laptops','Electronics'),
('Headphones','Electronics'),
('Cameras','Electronics'),
('Fashion',''),
('Men Clothing','Fashion'),
('Women Clothing','Fashion'),
('Footwear','Fashion'),
('Home & Kitchen',''),
('Kitchen Appliances','Home & Kitchen'),
('Furniture','Home & Kitchen'),
('Books',''),
('Sports',''),
('Beauty','');

INSERT INTO products (product_name, category_id, brand, price, cost_price, stock_quantity, rating) VALUES
('iPhone 15 Pro',2,'Apple',134900,95000,50,4.8),
('Samsung Galaxy S24',2,'Samsung',79999,55000,80,4.6),
('OnePlus 12',2,'OnePlus',64999,42000,120,4.5),
('Redmi Note 13 Pro',2,'Xiaomi',24999,16000,200,4.3),
('Realme 12 Pro+',2,'Realme',27999,18000,150,4.2),
('MacBook Air M3',3,'Apple',114900,80000,30,4.9),
('Dell XPS 15',3,'Dell',189900,135000,25,4.7),
('HP Pavilion 15',3,'HP',67990,45000,60,4.3),
('Lenovo IdeaPad Slim 5',3,'Lenovo',57990,38000,75,4.4),
('Asus VivoBook 16',3,'Asus',49990,33000,90,4.2),
('Sony WH-1000XM5',4,'Sony',29990,18000,100,4.8),
('Boat Rockerz 550',4,'Boat',1799,800,500,4.1),
('JBL Tune 770NC',4,'JBL',7999,4500,200,4.3),
('Noise Buds VS104',4,'Noise',1499,700,400,3.9),
('Canon EOS R50',5,'Canon',69990,48000,20,4.6),
('Levis 511 Slim Jeans',7,'Levis',3999,1800,300,4.4),
('Nike Dri-FIT T-Shirt',7,'Nike',1999,900,400,4.3),
('Fabindia Kurta Set',8,'Fabindia',2499,1100,250,4.5),
('Biba Anarkali Dress',8,'Biba',3299,1500,180,4.2),
('Nike Air Max 270',9,'Nike',12995,7500,120,4.6),
('Prestige Induction Cooktop',11,'Prestige',3499,1800,200,4.4),
('Instant Pot Duo',11,'Instant Pot',8999,5200,80,4.7),
('Wipro LED Smart Bulb',10,'Wipro',599,250,1000,4.2),
('Godrej Refrigerator 260L',11,'Godrej',24990,17000,40,4.5),
('Atomic Habits',13,'Penguin',499,150,500,4.9),
('Rich Dad Poor Dad',13,'Plata Publishing',350,120,400,4.7),
('Cosmos - Carl Sagan',13,'Ballantine Books',450,160,300,4.8),
('Nike Running Shoes',9,'Nike',5999,3200,150,4.1),
('Yoga Mat Premium',14,'Boldfit',999,400,300,4.3),
('Maybelline Fit Me Foundation',15,'Maybelline',449,180,600,4.2);

SELECT CONCAT('Products inserted: ', COUNT(*)) AS status FROM products;