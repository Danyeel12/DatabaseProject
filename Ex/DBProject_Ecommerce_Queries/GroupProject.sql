DROP TABLE Address CASCADE CONSTRAINTS;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Inventory CASCADE CONSTRAINTS;
DROP TABLE OrderItem CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE Review CASCADE CONSTRAINTS;
DROP SEQUENCE addressid_seq;
DROP SEQUENCE customerid_seq;
DROP SEQUENCE inventoryid_seq;
DROP SEQUENCE orderid_seq;
DROP SEQUENCE orderitemid_seq;
DROP SEQUENCE productid_seq;
DROP SEQUENCE reviewid_seq;

--Table Sequence
CREATE SEQUENCE addressid_seq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE customerid_seq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE inventoryid_seq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE orderid_seq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE orderitemid_seq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE productid_seq START WITH 1000 INCREMENT BY 1;
CREATE SEQUENCE reviewid_seq START WITH 1000 INCREMENT BY 1;
CREATE TABLE Address (
  AddressId  number(10) NOT NULL, 
  CustomerId number(10) NOT NULL, 
  Address    varchar2(255), 
  City       varchar2(255), 
  State      varchar2(2), 
  Zip        varchar2(5), 
  PRIMARY KEY (AddressId), 
  CONSTRAINT address_zip_ck 
    CHECK (TRANSLATE(Zip, '123456789', '000000000') = '00000'), 
  CONSTRAINT address_state_ck 
    CHECK ((LENGTH(State) = 2) AND (State = UPPER(State))));
CREATE TABLE Customer (
  CustomerId       number(10) NOT NULL, 
  FirstName        varchar2(255), 
  LastName         varchar2(255), 
  Email            varchar2(255) NOT NULL, 
  Password         varchar2(255) NOT NULL, 
  SecurityQuestion varchar2(255) NOT NULL, 
  SecurityAnswer   varchar2(255) NOT NULL, 
  PRIMARY KEY (CustomerId));
CREATE TABLE Inventory (
  InventoryId      number(10) NOT NULL, 
  ProductID       number(10) NOT NULL, 
  Quantity         number(10), 
  ShelvingLocation varchar2(9), 
  PRIMARY KEY (InventoryId), 
  CONSTRAINT inventory_shelvinglocation_ck 
    CHECK (TRANSLATE(ShelvingLocation, '123456789', '000000000') = 'Shelf 000'), 
  CONSTRAINT inventory_quantity_ck 
    CHECK (Quantity >= 0)
);
CREATE INDEX Address_CustomerId 
  ON Address (CustomerId);
CREATE INDEX Address_Address 
  ON Address (Address);
CREATE INDEX Address_City 
  ON Address (City);
CREATE INDEX Address_State 
  ON Address (State);
CREATE INDEX Address_Zip 
  ON Address (Zip);
CREATE INDEX Customer_FirstName 
  ON Customer (FirstName);
CREATE INDEX Customer_LastName 
  ON Customer (LastName);
CREATE INDEX Inventory_ProductID 
  ON Inventory (ProductID);
  
CREATE TABLE OrderItem (
  OrderItemId      number(10) NOT NULL, 
  OrderId          number(10) NOT NULL, 
  ProductId        number(10) NOT NULL, 
  Quantity         number(10) NOT NULL, 
  ActualRetail number(10, 2) NOT NULL, 
  PRIMARY KEY (OrderItemId), 
  CONSTRAINT orderitem_quantity_ck 
    CHECK (Quantity >= 1), 
  CONSTRAINT orderitem_actualretail_ck 
    CHECK (ActualRetail >= 1));
CREATE TABLE Orders (
  OrderId     number(10) NOT NULL, 
  CustomerId  number(10) NOT NULL, 
  Status      varchar2(255) DEFAULT 'Inactive' NOT NULL, 
  PaymentType varchar2(255), 
  OrderDate   date DEFAULT SYSDATE, 
  ShipDate    date, 
  ShipStreet  varchar2(255), 
  ShipCity    varchar2(255), 
  ShipState   varchar2(2), 
  ShipZip     varchar2(5), 
  ShipCost    number(10, 2), 
  PRIMARY KEY (OrderId), 
  CONSTRAINT orders_shipdate_ck 
    CHECK (OrderDate <= ShipDate), 
  CONSTRAINT orders_paymenttype_ck 
    CHECK (PaymentType IN ('Debit', 'Credit', 'PayPal', 'Bitcoin')), 
  CONSTRAINT orders_status_ck 
    CHECK (Status IN ('Active', 'Inactive', 'Confirmed', 'Cancelled', 'Shipped', 'Backordered')), 
  CONSTRAINT orders_shipzip_ck 
    CHECK (TRANSLATE(ShipZip, '123456789', '000000000') = '00000'), 
  CONSTRAINT orders_shipcost_ck 
    CHECK (ShipCost >= 1), 
  CONSTRAINT orders_shipstate_ck 
    CHECK ((LENGTH(ShipState) = 2) AND (ShipState = UPPER(ShipState))));
CREATE TABLE Product (
  ProductId number(10) NOT NULL, 
  Title     varchar2(255), 
  Cost      number(10, 2), 
  Retail    number(10, 2), 
  Category  varchar2(255), 
  Description   varchar2(255), 
  Status    varchar2(255), 
  PRIMARY KEY (ProductId), 
  CONSTRAINT product_retail_ck 
    CHECK (Retail >= 1), 
  CONSTRAINT product_cost_ck 
    CHECK (Cost >= 1), 
  CONSTRAINT product_status_ck 
    CHECK (Status IN ('High Stock Level', 'Average Stock Level', 'Low Stock Level', 'Limited Stock Level', 'Out of Stock')));
CREATE TABLE Review (
  ReviewId   number(10) NOT NULL, 
  OrderId    number(10) NOT NULL, 
  CustomerId number(10) NOT NULL, 
  ProductId  number(10) NOT NULL, 
  Comments   varchar2(255) NOT NULL, 
  Rating     number(1) DEFAULT 5 NOT NULL, 
  PRIMARY KEY (ReviewId), 
  CONSTRAINT review_rating_ck 
    CHECK (Rating IN (1, 2, 3, 4, 5)));
    
---CUSTOMER, ADDRESS TABLE DATA---
--Customer, Address 1
INSERT INTO Customer (CustomerId, FirstName, LastName, Email, Password, SecurityQuestion, SecurityAnswer) 
VALUES (customerid_seq.NEXTVAL, 'Eden', 'Smith', 'edens@hotmail.com', 'e155Sden', 'When is your birthday?', 'October');

INSERT INTO Address (AddressId, CustomerId, Address, City, State, Zip) 
VALUES (addressid_seq.NEXTVAL, customerid_seq.CURRVAL, '325 Empress Avenue', 'Toronto', 'ON', '12456');

--Customer, Address 2
INSERT INTO Customer (CustomerId, FirstName, LastName, Email, Password, SecurityQuestion, SecurityAnswer) 
VALUES (customerid_seq.NEXTVAL, 'Ralph', 'Li', 'smithr12@hotmail.com', 'reel5XahR', 'What is your favorite sport?', 'Football');

INSERT INTO Address (AddressId, CustomerId, Address, City, State, Zip) 
VALUES (addressid_seq.NEXTVAL, customerid_seq.CURRVAL, '626 Sheppard Avenue W', 'Toronto', 'ON', '12456');

--Customer, Address 3
INSERT INTO Customer (CustomerId, FirstName, LastName, Email, Password, SecurityQuestion, SecurityAnswer) 
VALUES (customerid_seq.NEXTVAL, 'Tak Hing', 'Li', 'tli@yahoo.com', 'tli123456', 'What is your dog''s name?', 'zoey');

INSERT INTO Address (AddressId, CustomerId, Address, City, State, Zip) 
VALUES (addressid_seq.NEXTVAL, customerid_seq.CURRVAL, '123 Wilson Road', 'San Francisco', 'CA', '12382');

--Customer, Address 4
INSERT INTO Customer (CustomerId, FirstName, LastName, Email, Password, SecurityQuestion, SecurityAnswer) 
VALUES (customerid_seq.NEXTVAL, 'Daniel', 'Miranda', 'dmiranda@gmail.com', 'dlikem456', 'What is year is your birthday?', '2000');

INSERT INTO Address (AddressId, CustomerId, Address, City, State, Zip) 
VALUES (addressid_seq.NEXTVAL, customerid_seq.CURRVAL, '418 Willowdale Street', 'Toronto', 'ON', '21160');

--Customer, Address 5
INSERT INTO Customer (CustomerId, FirstName, LastName, Email, Password, SecurityQuestion, SecurityAnswer) 
VALUES (customerid_seq.NEXTVAL, 'Pak Hin', 'Wong', 'pwong@gmail.com', 'pwonghk', 'What is your father''s last name?', 'Wong');

INSERT INTO Address (AddressId, CustomerId, Address, City, State, Zip) 
VALUES (addressid_seq.NEXTVAL, customerid_seq.CURRVAL, '212 Empress Street', 'North York', 'ON', '12689');

--Customer, Address 6
INSERT INTO Customer (CustomerId, FirstName, LastName, Email, Password, SecurityQuestion, SecurityAnswer) 
VALUES (customerid_seq.NEXTVAL, 'Chris', 'Ma', 'chrisma@yahoo.com', 'cmarish', 'What is your dog''s name?', 'Brody');

INSERT INTO Address (AddressId, CustomerId, Address, City, State, Zip) 
VALUES (addressid_seq.NEXTVAL, customerid_seq.CURRVAL, '28 Hilda Avenue', 'North York', 'ON', '54321');

--Customer, Address 7
INSERT INTO Customer (CustomerId, FirstName, LastName, Email, Password, SecurityQuestion, SecurityAnswer) 
VALUES (customerid_seq.NEXTVAL, 'Jerick', 'Paroso', 'jparoso@gmail.com', 'parosoj', 'What is your mother''s maiden name?', 'Sally');

INSERT INTO Address (AddressId, CustomerId, Address, City, State, Zip) 
VALUES (addressid_seq.NEXTVAL, customerid_seq.CURRVAL, '4061 Tandem', 'Toronto', 'ON', '39251');

--Customer, Address 8
INSERT INTO Customer (CustomerId, FirstName, LastName, Email, Password, SecurityQuestion, SecurityAnswer) 
VALUES (customerid_seq.NEXTVAL, 'Lennox', 'Lai', 'llenox@gmail.com', 'lelailnnox', 'What is your mother''s maiden name?', 'Samantha');

INSERT INTO Address (AddressId, CustomerId, Address, City, State, Zip) 
VALUES (addressid_seq.NEXTVAL, customerid_seq.CURRVAL, '165 Gerry Street', 'Scarborough', 'ON', '35741');

--Customer, Address 9
INSERT INTO Customer (CustomerId, FirstName, LastName, Email, Password, SecurityQuestion, SecurityAnswer) 
VALUES (customerid_seq.NEXTVAL, 'John', 'Simon', 'simonjsimon@gmail.net', 'centsimon', 'What is your mother''s maiden name?', 'Joana');

INSERT INTO Address (AddressId, CustomerId, Address, City, State, Zip) 
VALUES (addressid_seq.NEXTVAL, customerid_seq.CURRVAL, '4215 Dream Drive', 'Toronto', 'ON', '31901');

--Customer, Address 10
INSERT INTO Customer (CustomerId, FirstName, LastName, Email, Password, SecurityQuestion, SecurityAnswer) 
VALUES (customerid_seq.NEXTVAL, 'Aurora', 'Simon', 'auroras@gmail.com', 'aAsimonrora', 'What is your hobby?', 'pray');

INSERT INTO Address (AddressId, CustomerId, Address, City, State, Zip) 
VALUES (addressid_seq.NEXTVAL, customerid_seq.CURRVAL, '4215 Dream Drive', 'Toronto', 'ON', '31901');


-- PRODUCT TABLE DATA ---
-- Product 1
INSERT INTO Product (ProductId, Title, Cost, Retail, Category, Description, Status)
VALUES (productid_seq.NEXTVAL, 'Ninja Foodi 2-Basket Air Fryer', 149.00, 99.99, 'Kitchen', 'The first air fryer with 2 independent baskets that lets you cook 2 foods, 2 ways, at the same time, not back to back like a traditional single-basket air fryer.', 'High Stock Level');

-- Product 2
INSERT INTO Product (ProductId, Title, Cost, Retail, Category, Description, Status)
VALUES (productid_seq.NEXTVAL, 'adidas Alliance II Sackpack', 50.00, 39.99, 'Sports', 'VP249HE 24" Full HD monitor with 100,000,000:1 high contrast ratio, ASUS-exclusive Splendid and VividPixel technologies are optimized for the finest image and color quality.', 'Average Stock Level');

-- Product 3
INSERT INTO Product (ProductId, Title, Cost, Retail, Category, Description, Status)
VALUES (productid_seq.NEXTVAL, 'Apple Watch Series 8', 445.89, 699.99, 'Watch', 'Your essential companion for a healthy life is now even more powerful. Advanced sensors provide insights to help you better understand your health. New safety features can get you help when you need it.', 'Average Stock Level');

-- Product 4
INSERT INTO Product (ProductId, Title, Cost, Retail, Category, Description, Status)
VALUES (productid_seq.NEXTVAL, 'KOORUI 24 Inch Business Computer Monitor', 105.99, 89.99, 'Computer', 'The 23.8 inch monitor adopts a new generation of VA screen, covering 99% of the SRGB color gamut and 8bit gray level over 16.7M color numbers.', 'Average Stock Level');

-- Product 5
INSERT INTO Product (ProductId, Title, Cost, Retail, Category, Description, Status)
VALUES (productid_seq.NEXTVAL, 'Canon EOS Rebel T7 DSLR Camera with 18-55mm Lens', 494.00, 783.99, 'Camera', 'Built-in Wi-Fi and NFC technology, 9-Point AF system and AI Servo AF', 'Average Stock Level');

-- Product 6
INSERT INTO Product (ProductId, Title, Cost, Retail, Category, Description, Status)
VALUES (productid_seq.NEXTVAL, 'JBL Tune 510BT: Wireless On-Ear Headphones with Purebass Sound', 100.00, 299.00, 'Headphones', 'The Tune 510BT wireless headphones feature renowned JBL Pure Bass sound, which can be found in the most famous venues all around the world.', 'Low Stock Level');

-- Product 7
INSERT INTO Product (ProductId, Title, Cost, Retail, Category, Description, Status)
VALUES (productid_seq.NEXTVAL, 'SGIN Laptop', 609.00, 428.99, 'Computer', 'Beautiful Large Display: The Windows 11 laptop adopts a 15.6-inch 1920�1080 Full HD IPS screen, the text is sharp and clear, and the colors are more vivid. Wide range of applications, suitable for study, work, entertainment, Internet surfing.', 'Low Stock Level');

-- Product 8
INSERT INTO Product (ProductId, Title, Cost, Retail, Category, Description, Status)
VALUES (productid_seq.NEXTVAL, 'Amazon Fire smart TV, stream live TV without cable', 469.00, 399.00, 'TV', '4K Ultra HD, HDR 10, and HLG deliver a clearer and more vibrant picture with brighter colors compared to 1080p Full HD.', 'Limited Stock Level');

-- Product 9
INSERT INTO Product (ProductId, Title, Cost, Retail, Category, Description, Status)
VALUES (productid_seq.NEXTVAL, 'Under Armour Mens Charged Assert 9 Running Shoe', 56.98, 99.99, 'Shoes', 'Shaft measures approximately low-top from arch.', 'Out of Stock');

-- Product 10
INSERT INTO Product (ProductId, Title, Cost, Retail, Category, Description, Status)
VALUES (productid_seq.NEXTVAL, 'Gildan Mens 5 Pack Crew', 24.99, 12.99, 'Clothing', 'Solids: 100% Cotton; Sport Grey: 90% Cotton, 10% Polyester.', 'High Stock Level');

  
  
---ORDERS, ORDERITEM, REVIEW DATA---
--Orders, OrderItem, Review 1
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1000, 
  'Cancelled', 
  'Debit', 
  TO_DATE('2019-11-30', 'YYYY-MM-DD'), 
  TO_DATE('2019-11-30', 'YYYY-MM-DD') + 11, 
  '4611 Mapleview Drive', 
  'St Petersburg', 
  'FL', 
  '33701', 
  10.00); -- Changed NULL to a numeric value for ShipCost

INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  ActualRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000, 
  3, 
  369.00);

INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1000, 
  1000, 
  'These shirts are very comfortable and I would buy again.', 
  5);

-- Repeat the same structure for the next 9 Orders, OrderItem, Review records.

--Orders, OrderItem, Review 2
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1001, 
  'Shipped', 
  'Debit', 
  TO_DATE('2019-11-30', 'YYYY-MM-DD'), 
  TO_DATE('2019-11-30', 'YYYY-MM-DD') + 6, 
  '282 Bottom Lane', 
  'Tonawanda', 
  'NY', 
  '14150', 
  8.50); -- Changed NULL to a numeric value for ShipCost

INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  ActualRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1001, 
  4, 
  1179.99);

INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1001, 
  1001, 
  'These Under Armour shoes are very well made, sturdy, and look great, but they do not provide a lot of cushioning.', 
  5);

-- Repeat the same structure for the next 8 Orders, OrderItem, Review records.

--Orders, OrderItem, Review 3
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1002, 
  'Shipped', 
  'Credit', 
  TO_DATE('2019-12-01', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-01', 'YYYY-MM-DD') + 24, 
  '893 Thunder Road', 
  'San Francisco', 
  'CA', 
  '94111', 
  12.00); -- Changed NULL to a numeric value for ShipCost

INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  ActualRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1002, 
  4, 
  149.99);

INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1002, 
  1002, 
  'I bought this tv because my Insignia 50-inch Fire tv died after exactly 3 years while it was in use.', 
  5);

-- Repeat the same structure for the next 7 Orders, OrderItem, Review records.

--Orders, OrderItem, Review 4
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1003, 
  'Active', 
  'Credit', 
  TO_DATE('2019-12-02', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-02', 'YYYY-MM-DD') + 17, 
  '4770 Jefferson Street', 
  'Norfolk', 
  'VA', 
  '23510', 
  15.00); -- Changed NULL to a numeric value for ShipCost

INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  ActualRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1003, 
  1, 
  69.99);

INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1003, 
  1003, 
  'I really like the laptop. The screen quality is very good, it is fast, useful and I really like it. Thank you!', 
  4);
-- Orders, OrderItem, Review 5
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1004, 
  'Confirmed', 
  'Credit', 
  TO_DATE('2019-12-03', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-03', 'YYYY-MM-DD') + 8, 
  '739 Rosewood Court', 
  'Anchorage', 
  'AK', 
  '99501', 
  9.00); -- Changed NULL to a numeric value for ShipCost

INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  ActualRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1004, 
  5, 
  349.00);

INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1004, 
  1004, 
  'Good headphones for the price, a little tight for my head but works well, clear voice and sound. Good Noise cancelling. Use it for work calls and works good. Recommend.', 
  4);

-- Orders, OrderItem, Review 6
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1005, 
  'Inactive', 
  'Credit', 
  TO_DATE('2019-12-05', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-05', 'YYYY-MM-DD') + 12, 
  '3406 Edsel Road', 
  'Portsmouth', 
  'NH', 
  '03801', 
  6.00);

INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  ActualRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1006, 
  3, 
  179.00);

INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1006, 
  1006, 
  'Got a new iPhone, needed the new watch hahaha came perfectly unopened new condition.', 
  5);

-- Orders, OrderItem, Review 7
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1007, 
  'Backordered', 
  'PayPal', 
  TO_DATE('2019-12-05', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-05', 'YYYY-MM-DD') + 9, 
  '4481 Kelly Street', 
  'Charlotte', 
  'NC', 
  '28202', 
  5.00);

INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  ActualRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1007, 
  1, 
  529.99);

INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1007, 
  1007, 
  'The only problem I had was battery but the latest Android update on June 2023 has addressed this issue to the most as I saw good improvement in battery retaining its power more then before June update. Overall a great phone.', 
  5);

-- Orders, OrderItem, Review 8
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1008, 
  'Cancelled', 
  'PayPal', 
  TO_DATE('2019-12-06', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-06', 'YYYY-MM-DD') + 6, 
  '1022 Emily Renzelli Boulevard', 
  'Perth Amboy', 
  'NJ', 
  '08861', 
  8.00);

INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  ActualRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1008, 
  5, 
  129.99);

INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1008, 
  1008, 
  'This is my second airfryer. This is the perfect size even for just airfreight on one side. Deep baskets and very easy to clean. Easy to use. Cooks everything perfectly. Would definitely recommend.', 
  5);

-- Orders, OrderItem, Review 9
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1009, 
  'Confirmed', 
  'Bitcoin', 
  TO_DATE('2019-12-07', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-07', 'YYYY-MM-DD') + 8, 
  '4057 North Avenue', 
  'Piscataway', 
  'NJ', 
  '08854', 
  7.00);

INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  ActualRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1009, 
  4, 
  803.99);

INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1009, 
  1009, 
  'Would definitely recommend. So smooth when playing games and so easy to setup.', 
  5);

-- Orders, OrderItem, Review 10
INSERT INTO Orders
  (OrderId, 
  CustomerId, 
  Status, 
  PaymentType, 
  OrderDate, 
  ShipDate, 
  ShipStreet, 
  ShipCity, 
  ShipState, 
  ShipZip, 
  ShipCost) 
VALUES 
  (orderid_seq.NEXTVAL, 
  1010, 
  'Active', 
  'Credit', 
  TO_DATE('2019-12-07', 'YYYY-MM-DD'), 
  TO_DATE('2019-12-07', 'YYYY-MM-DD') + 4, 
  '1152 Marcus Street', 
  'San Francisco', 
  'CA', 
  '94103', 
  5.00);

INSERT INTO OrderItem
  (OrderItemId, 
  OrderId, 
  ProductId, 
  Quantity, 
  ActualRetail) 
VALUES 
  (orderitemid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1010, 
  1, 
  399.00);

INSERT INTO Review
  (ReviewId, 
  OrderId, 
  CustomerId, 
  ProductId, 
  Comments, 
  Rating) 
VALUES 
  (reviewid_seq.NEXTVAL, 
  orderid_seq.CURRVAL, 
  1010, 
  1010, 
  'We like the versatility, that it works with our other canon lens, and beautiful pictures', 
  5);


-- Inventory 1
INSERT INTO Inventory
  (InventoryId, ProductID, Quantity, ShelvingLocation)
VALUES
  (inventoryid_seq.NEXTVAL, 1009, 0, 'Shelf 797');

-- Inventory 2
INSERT INTO Inventory
  (InventoryId, ProductID, Quantity, ShelvingLocation)
VALUES
  (inventoryid_seq.NEXTVAL, 1009, 0, 'Shelf 267');

-- Inventory 3
INSERT INTO Inventory
  (InventoryId, ProductID, Quantity, ShelvingLocation)
VALUES
  (inventoryid_seq.NEXTVAL, 1008, 0, 'Shelf 739');

-- Inventory 4
INSERT INTO Inventory
  (InventoryId, ProductID, Quantity, ShelvingLocation)
VALUES
  (inventoryid_seq.NEXTVAL, 1008, 4, 'Shelf 536');

-- Inventory 5
INSERT INTO Inventory
  (InventoryId, ProductID, Quantity, ShelvingLocation)
VALUES
  (inventoryid_seq.NEXTVAL, 1006, 11, 'Shelf 400');

-- Inventory 6
INSERT INTO Inventory
  (InventoryId, ProductID, Quantity, ShelvingLocation)
VALUES
  (inventoryid_seq.NEXTVAL, 1007, 17, 'Shelf 363');

-- Inventory 7
INSERT INTO Inventory
  (InventoryId, ProductID, Quantity, ShelvingLocation)
VALUES
  (inventoryid_seq.NEXTVAL, 1007, 0, 'Shelf 210');

-- Inventory 8
INSERT INTO Inventory
  (InventoryId, ProductID, Quantity, ShelvingLocation)
VALUES
  (inventoryid_seq.NEXTVAL, 1002, 1, 'Shelf 725');

-- Inventory 9
INSERT INTO Inventory
  (InventoryId, ProductID, Quantity, ShelvingLocation)
VALUES
  (inventoryid_seq.NEXTVAL, 1004, 1, 'Shelf 245');

-- Inventory 10
INSERT INTO Inventory
  (InventoryId, ProductID, Quantity, ShelvingLocation)
VALUES
  (inventoryid_seq.NEXTVAL, 1000, 12, 'Shelf 707');

 
  
---ADDING MORE ORDERITEM DATA---
-- OrderItem 1
INSERT INTO OrderItem
  (OrderItemId, OrderId, ProductId, Quantity, ActualRetail)
VALUES
  (orderitemid_seq.NEXTVAL, 1003, 1005, 1, 49.99);

-- OrderItem 2
INSERT INTO OrderItem
  (OrderItemId, OrderId, ProductId, Quantity, ActualRetail)
VALUES
  (orderitemid_seq.NEXTVAL, 1009, 1005, 1, 49.99);

-- OrderItem 3
INSERT INTO OrderItem
  (OrderItemId, OrderId, ProductId, Quantity, ActualRetail)
VALUES
  (orderitemid_seq.NEXTVAL, 1005, 1004, 1, 69.99);

-- OrderItem 4
INSERT INTO OrderItem
  (OrderItemId, OrderId, ProductId, Quantity, ActualRetail)
VALUES
  (orderitemid_seq.NEXTVAL, 1005, 1004, 1, 69.99);

-- OrderItem 5
INSERT INTO OrderItem
  (OrderItemId, OrderId, ProductId, Quantity, ActualRetail)
VALUES
  (orderitemid_seq.NEXTVAL, 1001, 1004, 1, 69.99);

-- OrderItem 6
INSERT INTO OrderItem
  (OrderItemId, OrderId, ProductId, Quantity, ActualRetail)
VALUES
  (orderitemid_seq.NEXTVAL, 1001, 1005, 1, 49.99);

-- OrderItem 7
INSERT INTO OrderItem
  (OrderItemId, OrderId, ProductId, Quantity, ActualRetail)
VALUES
  (orderitemid_seq.NEXTVAL, 1008, 1002, 2, 129.99);

-- OrderItem 8
INSERT INTO OrderItem
  (OrderItemId, OrderId, ProductId, Quantity, ActualRetail)
VALUES
  (orderitemid_seq.NEXTVAL, 1006, 1001, 3, 89.99);

-- OrderItem 9
INSERT INTO OrderItem
  (OrderItemId, OrderId, ProductId, Quantity, ActualRetail)
VALUES
  (orderitemid_seq.NEXTVAL, 1004, 1003, 2, 79.99);

-- OrderItem 10
INSERT INTO OrderItem
  (OrderItemId, OrderId, ProductId, Quantity, ActualRetail)
VALUES
  (orderitemid_seq.NEXTVAL, 1007, 1002, 1, 129.99);
  
--Index
CREATE INDEX Address_CustomerId 
  ON Address (CustomerId);
CREATE INDEX Address_Address 
  ON Address (Address);
CREATE INDEX Address_City 
  ON Address (City);
CREATE INDEX Address_State 
  ON Address (State);
CREATE INDEX Address_Zip 
  ON Address (Zip);
CREATE INDEX Customer_FirstName 
  ON Customer (FirstName);
CREATE INDEX Customer_LastName 
  ON Customer (LastName);
CREATE INDEX Inventory_ProductID 
  ON Inventory (ProductID);
  
 
--Triggers
/* This trigger automatically updates the status of an order based on the value of the ShipDate field. 
The status can be one of four values: 'Active', 'Confirmed', 'Inactive', or a custom status based on the business logic defined in the trigger. 
This helps in keeping the order status up-to-date and relevant to the shipping status,
which is crucial for order management and customer communication in an e-commerce system. */

CREATE OR REPLACE TRIGGER update_order_status
BEFORE UPDATE OF ShipDate ON Orders
FOR EACH ROW
BEGIN
    -- Calculate the new status based on ShipDate
    IF :NEW.ShipDate IS NOT NULL THEN
        IF :NEW.ShipDate <= SYSDATE THEN
            :NEW.Status := 'Active';
        ELSE
            :NEW.Status := 'Confirmed';
        END IF;
    ELSE
        :NEW.Status := 'Inactive';
    END IF;
END;
/

--Testing
SELECT * FROM orders;

UPDATE orders
SET shipdate = '04-08-23'
WHERE orderID = 1000;



-- Triggers
/* This trigger helps in maintaining the inventory quantity by automatically reducing the quantity of products 
in the inventory when a customer confirms an order. It ensures that the available quantity is updated 
correctly, preventing overselling or stock-related issues. */
CREATE OR REPLACE TRIGGER trg_update_inventory
AFTER INSERT ON OrderItem -- Trigger should be based on the OrderItem table
FOR EACH ROW
DECLARE
  v_quantity NUMBER;
BEGIN
  -- Get the current inventory quantity for the product
  SELECT Quantity INTO v_quantity
  FROM Inventory
  WHERE ProductID = :NEW.ProductId;

  -- Calculate the new inventory quantity after the order item is inserted
  v_quantity := v_quantity - :NEW.Quantity;

  -- Update the inventory table
  UPDATE Inventory
  SET Quantity = v_quantity
  WHERE ProductID = :NEW.ProductId;
END;
/

--Testing
INSERT INTO Inventory (InventoryID, ProductID, Quantity, Shelvinglocation)
VALUES (1010, 1001, 100, 'Shelf 207'); -- Inserting a product with ID 1 and initial quantity of 100
 select * from inventory;

INSERT INTO OrderItem (OrderItemId, ProductId, Quantity)
VALUES (1, 1, 20); -- Inserting an order item with OrderItemId 1, ProductId 1, and Quantity 20

Select * from orderitem;
INSERT INTO OrderItem (OrderItemId, Orderid, ProductId, Quantity, Actualretail)
VALUES (1020, 1000, 1000, 10, 369); -- Inserting an order item with OrderItemId 1, ProductId 1, and Quantity 20

SELECT * FROM Inventory WHERE ProductID = 1000;
--Procedure
CREATE OR REPLACE PROCEDURE STATUS_SP(
  basket_id IN NUMBER,
  status_desc OUT VARCHAR2,
  status_date OUT DATE
) IS
  v_status_desc VARCHAR2(100);
BEGIN
  SELECT
    CASE o.Status
      WHEN 'Confirmed' THEN 'Submitted and received'
      WHEN 'Active' THEN 'Confirmed, processed, sent to shipping'
      WHEN 'Inactive' THEN 'Shipped'
      WHEN 'Cancelled' THEN 'Cancelled'
      WHEN 'Backordered' THEN 'Back-ordered'
      ELSE 'No status available'
    END,
    o.OrderDate -- Replace "StatusDate" with the correct column name, for example, "OrderDate"
  INTO v_status_desc, status_date
  FROM Orders o
  WHERE o.OrderId = basket_id;

  status_desc := v_status_desc;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    status_desc := 'No status available';
    status_date := NULL;
END;
/

--testing
DECLARE
  v_status_desc VARCHAR2(100);
  v_status_date DATE;
BEGIN
  -- Test with basket ID 1000
  STATUS_SP(1000, v_status_desc, v_status_date);
  DBMS_OUTPUT.PUT_LINE('Basket ID: 1000');
  DBMS_OUTPUT.PUT_LINE('Status Description: ' || v_status_desc);
  DBMS_OUTPUT.PUT_LINE('Status Date: ' || v_status_date);
END;

DECLARE
  v_status_desc VARCHAR2(100);
  v_status_date DATE;
BEGIN
  -- Test with basket ID 1003
  STATUS_SP(1005, v_status_desc, v_status_date);
  DBMS_OUTPUT.PUT_LINE('Basket ID: 1003');
  DBMS_OUTPUT.PUT_LINE('Status Description: ' || v_status_desc);
  DBMS_OUTPUT.PUT_LINE('Status Date: ' || v_status_date);
END;
Procedure 2 is done
--Procedure with type attribute
CREATE OR REPLACE PROCEDURE ship_cost(
  p_quantity IN NUMBER,
  p_shipcost OUT NUMBER
)
AS
  -- Declare a cursor to retrieve shipping costs from a table
  CURSOR cost_cursor IS
    SELECT o.shipcost
    FROM orders o
    JOIN orderitem oi USING (orderid)
    WHERE oi.quantity >= p_quantity AND 
          oi.quantity <= (
            SELECT MIN(quantity) 
            FROM orderitem 
            WHERE quantity >= p_quantity
          );

  -- Variable to store the retrieved shipping cost
  v_shipcost orders.shipcost%TYPE;
BEGIN
  -- Initialize the shipping cost variable to a default value
  p_shipcost := 0;

  -- Use the existing IF statement to determine shipping cost based on quantity
  IF p_quantity > 1 THEN
    p_shipcost := 5;
  ELSIF p_quantity > 3 THEN
    p_shipcost := 10;
  ELSE 
    p_shipcost := 12;
  END IF;

  -- Open the cursor
  OPEN cost_cursor;

  -- Fetching data from the cursor
  FETCH cost_cursor INTO v_shipcost;

  IF cost_cursor%NOTFOUND THEN
    -- Handling the case when no data is found
    p_shipcost := -1; -- Use a special value (-1 in this case) to indicate no data found.
    DBMS_OUTPUT.PUT_LINE('No shipping cost data found for the given quantity.');
  ELSE
    -- Assign the retrieved shipping cost to the output parameter
    p_shipcost := v_shipcost;
  END IF;

  -- Closing the cursor
  CLOSE cost_cursor;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Handle any other unexpected errors
     -- Use another special value (-2 in this case) to indicate an error.
    DBMS_OUTPUT.PUT_LINE('No quantity found.');
END ship_cost;
/

--Testing
--Quantity 1
DECLARE
  v_quantity NUMBER;
  v_shipcost NUMBER;
BEGIN
  v_quantity := 1;
  ship_cost(v_quantity, v_shipcost);
  DBMS_OUTPUT.PUT_LINE('Shipping cost for Quantity ' || v_quantity || ': ' || v_shipcost);
END;
/
--Quantity 2
DECLARE
  v_quantity NUMBER;
  v_shipcost NUMBER;
BEGIN
  v_quantity := 2;
  ship_cost(v_quantity, v_shipcost);
  DBMS_OUTPUT.PUT_LINE('Shipping cost for Quantity ' || v_quantity || ': ' || v_shipcost);
END;
/
--Quantity 4
DECLARE
  v_quantity NUMBER;
  v_shipcost NUMBER;
BEGIN
  v_quantity := 4;
  ship_cost(v_quantity, v_shipcost);
  DBMS_OUTPUT.PUT_LINE('Shipping cost for Quantity ' || v_quantity || ': ' || v_shipcost);
END;
/
--Quantity 5
DECLARE
  v_quantity NUMBER;
  v_shipcost NUMBER;
BEGIN
  v_quantity := 5;
  ship_cost(v_quantity, v_shipcost);
  DBMS_OUTPUT.PUT_LINE('Shipping cost for Quantity ' || v_quantity || ': ' || v_shipcost);
END;






CREATE OR REPLACE PACKAGE BODY product_status_pkg AS
  -- Procedure 1: Retrieve the status of a single product
  PROCEDURE get_product_status(
    p_pid IN product.productid%TYPE,
    p_sta OUT product.status%TYPE
  ) IS
  BEGIN
    SELECT status 
    INTO p_sta FROM product
    WHERE productid = p_pid;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No product was found!');
  END get_product_status;
  
  -- Procedure 2: Retrieve status for all products and store them in the global variable
PROCEDURE get_product_status(
    p_pid IN product.title%TYPE,
    p_sta OUT product.status%TYPE
  ) IS
  BEGIN
    SELECT status 
    INTO p_sta FROM product
    WHERE title = p_pid;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No product was found!');
  END get_product_status;
END product_status_pkg;
/

-- Anonymous block to test the packaged procedure
DECLARE
  v_pid product.productid%TYPE;
  v_sta product.status%TYPE;
BEGIN
  -- Test Procedure 1: Retrieve the status of a single product by productid
  v_pid := 1009; -- Replace with an existing productid in your database
  product_status_pkg.get_product_status(v_pid, v_sta);
  DBMS_OUTPUT.PUT_LINE('Status for Product ' || v_pid || ': ' || v_sta);
END;
DECLARE
  v_pid product.title%TYPE;
  v_sta product.status%TYPE;
BEGIN
  -- Test Procedure 2: Retrieve the status of a single product by title
  v_pid :=  'adidas Alliance II Sackpack'; -- Replace with an existing product title in your database
  product_status_pkg.get_product_status(v_pid, v_sta);
  DBMS_OUTPUT.PUT_LINE('Status for Product Title "' || v_pid || '": ' || v_sta);
END;
/
--Functions with exception
--Make a runtest dbms in this query
CREATE OR REPLACE FUNCTION CalculateProductRevenue(product_id NUMBER)
RETURN NUMBER AS
  total_revenue NUMBER(10, 2) := 0;
BEGIN
  SELECT SUM(oi.Quantity * p.Retail) INTO total_revenue
  FROM OrderItem oi
  INNER JOIN Product p ON oi.ProductId = p.ProductId
  WHERE oi.ProductId = product_id;

  RETURN total_revenue;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;

--Runtest
-- Test 1: Calculate revenue for ProductId 1000
DECLARE
  result NUMBER(10, 2);
BEGIN
  result := CalculateProductRevenue(1000);
  DBMS_OUTPUT.PUT_LINE('Total Revenue for ProductId 1000: ' || result);
END;
/
-- Test 2: Calculate revenue for ProductId 1001
DECLARE
  result NUMBER(10, 2);
BEGIN
  result := CalculateProductRevenue(1001);
  DBMS_OUTPUT.PUT_LINE('Total Revenue for ProductId 1001: ' || result);
END;
/


--Function with exeption
CREATE OR REPLACE FUNCTION get_most_ordered_product
RETURN VARCHAR2
IS
  v_product_title VARCHAR2(255);
BEGIN
  SELECT p.Title INTO v_product_title
  FROM Product p
  JOIN OrderItem oi ON p.ProductId = oi.ProductId
  GROUP BY p.Title
  ORDER BY SUM(oi.Quantity) DESC
  FETCH FIRST 1 ROW ONLY;

  RETURN v_product_title;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'No orders or products found';
END;
/
--Testing for most oredered products
-- Test: Get the most ordered product
DECLARE
  result VARCHAR2(255);
BEGIN
  result := get_most_ordered_product();
  DBMS_OUTPUT.PUT_LINE('Most Ordered Product: ' || result);
END;
/
--Package
CREATE OR REPLACE PACKAGE product_status_pkg AS
-- Define a global variable to store the result of the status query
TYPE status_record_type IS RECORD (
p_pid product.productid%TYPE,
p_sta product.status%TYPE
);
-- Procedure 1: Retrieve the status of a single product
PROCEDURE get_product_status(
p_pid IN product.productid%TYPE,
p_sta OUT product.status%TYPE
);

-- Procedure 2: Retrieve status for all products and store them in the global variable
PROCEDURE get_product_status(
p_pid IN product.title%TYPE,
p_sta OUT product.status%TYPE
);
END product_status_pkg;
/

--Package: product_status

CREATE OR REPLACE PACKAGE BODY product_status_pkg AS
  -- Procedure 1: Retrieve the status of a single product
  PROCEDURE get_product_status(
    p_pid IN product.productid%TYPE,
    p_sta OUT product.status%TYPE
  ) IS
  BEGIN
    SELECT status 
    INTO p_sta FROM product
    WHERE productid = p_pid;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No product was found!');
  END get_product_status;
  
  -- Procedure 2: Retrieve status for all products and store them in the global variable
PROCEDURE get_product_status(
    p_pid IN product.title%TYPE,
    p_sta OUT product.status%TYPE
  ) IS
  BEGIN
    SELECT status 
    INTO p_sta FROM product
    WHERE title = p_pid;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No product was found!');
  END get_product_status;
END product_status_pkg;
/

-- Anonymous block to test the packaged procedure
DECLARE
  v_pid product.productid%TYPE;
  v_sta product.status%TYPE;
BEGIN
  -- Test Procedure 1: Retrieve the status of a single product by productid
  v_pid := 1009; -- Replace with an existing productid in your database
  product_status_pkg.get_product_status(v_pid, v_sta);
  DBMS_OUTPUT.PUT_LINE('Status for Product ' || v_pid || ': ' || v_sta);
END;
DECLARE
  v_pid product.title%TYPE;
  v_sta product.status%TYPE;
BEGIN
  -- Test Procedure 2: Retrieve the status of a single product by title
  v_pid :=  'adidas Alliance II Sackpack'; -- Replace with an existing product title in your database
  product_status_pkg.get_product_status(v_pid, v_sta);
  DBMS_OUTPUT.PUT_LINE('Status for Product Title "' || v_pid || '": ' || v_sta);
END;
/


CREATE OR REPLACE PACKAGE most_user_pkg AS
  -- Custom record type to hold product details
  TYPE product_record IS RECORD (
    title VARCHAR2(255),
    total_quantity NUMBER
  );

  -- Function to get the most ordered product details
  FUNCTION get_mostOrderedProduct RETURN product_record;

  -- Function to get the customer name for the most ordered product
  FUNCTION get_customerName RETURN VARCHAR2;
END;
/

CREATE OR REPLACE PACKAGE BODY most_user_pkg AS
  -- Function to get the most ordered product details
  FUNCTION get_mostOrderedProduct RETURN product_record IS
    v_product_title VARCHAR2(255);
    v_product_details product_record;
  BEGIN
    SELECT p.Title, SUM(oi.Quantity) AS total_quantity
    INTO v_product_title, v_product_details.total_quantity
    FROM Product p
    JOIN OrderItem oi ON p.ProductId = oi.ProductId
    GROUP BY p.Title
    ORDER BY SUM(oi.Quantity) DESC
    FETCH FIRST 1 ROW ONLY;

    v_product_details.title := v_product_title;
    RETURN v_product_details;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_product_details.title := 'No orders or products found';
      v_product_details.total_quantity := NULL;
      RETURN v_product_details;
  END;

  -- Function to get the customer name based on the most ordered product
  FUNCTION get_customerName RETURN VARCHAR2 IS
    v_customer_name VARCHAR2(255);
    v_product_title VARCHAR2(255);
  BEGIN
    -- Get the most ordered product title
    v_product_title := get_mostOrderedProduct().title;

    -- Get the customer name who ordered the most ordered product
    SELECT c.firstname || ' ' || c.lastname
    INTO v_customer_name
    FROM Customer c
    JOIN Orders o ON c.CustomerId = o.CustomerId
    JOIN OrderItem oi ON o.OrderId = oi.OrderId
    JOIN Product p ON oi.ProductId = p.ProductId
    WHERE p.Title = v_product_title
    GROUP BY c.firstname, c.lastname
    ORDER BY SUM(oi.Quantity) DESC
    FETCH FIRST 1 ROW ONLY;

    RETURN v_customer_name;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'No orders or customers found';
  END;
END;
/


-- Test: Get the most ordered product
DECLARE
  result_product most_user_pkg.product_record;
  result_customer VARCHAR2(255);
BEGIN
  result_product := most_user_pkg.get_mostOrderedProduct();
  DBMS_OUTPUT.PUT_LINE('Most Ordered Product: ' || result_product.title || ', Quantity: ' || result_product.total_quantity);

  result_customer := most_user_pkg.get_customerName();
  DBMS_OUTPUT.PUT_LINE('Customer Name for Most Ordered Product: ' || result_customer);
END;
/
