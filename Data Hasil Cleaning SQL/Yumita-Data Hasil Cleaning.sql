--==============================================
-- TUGAS SQL 1
-- YUMITA
-- DATA ANALYST BATCH 3
--==============================================

--==============================================
-- CREATE TABLE
-- Membuat Struktur Tabel dan Relasi antar Tabel
-- Menentukan Primary Key dan Foreign Key
--==============================================
-- Products
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

--Orders
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

--Items
CREATE TABLE items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

--Payments
CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


--==========================================================
-- MENGECEK TIPE DATA, UKURAN DATASET, SERTA STRUKTUR TABEL
--==========================================================
-- 1. Mengecek ukuran dataset (jumlah baris per tabel)
SELECT 'products' AS nama_tabel, COUNT(*) AS jumlah_baris FROM products
UNION ALL
SELECT 'items', COUNT(*) FROM items
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'payments', COUNT(*) FROM payments;

-- 2. Mengecek struktur tabel dan tipe data
-- Products
SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'products'; 

-- Items
SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'items';

-- Orders
SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'orders';

-- Payments
SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'payments';


--==================================
-- MENGECEK MISSING VALUE (PRODUCTS)
--==================================
SELECT 'product_id' AS column_name,
	COUNT(*) filter (where product_id IS NULL) as missing_count 
FROM products 
union all
SELECT 'product_category_name',
	COUNT(*) filter (where product_category_name IS null or trim(product_category_name) = '')  
FROM products 
union all
SELECT 'product_name_lenght',
	COUNT(*) filter (where product_name_lenght IS NULL)  
FROM products 
union all
SELECT 'product_description_lenght',
	COUNT(*) filter (where product_description_lenght IS NULL)  
FROM products 
union all
SELECT 'product_photos_qty',
	COUNT(*) filter (where product_photos_qty IS NULL)  
FROM products 
union all
SELECT 'product_weight_g',
	COUNT(*) filter (where product_weight_g IS NULL)  
FROM products 
union all
SELECT 'product_length_cm',
	COUNT(*) filter (where product_length_cm IS NULL)  
FROM products 
union all
SELECT 'product_height_cm',
	COUNT(*) filter (where product_height_cm IS NULL)  
FROM products 
union all
SELECT 'product_width_cm',
	COUNT(*) filter (where product_width_cm IS NULL)
FROM products 

	
--==================================
-- MENGECEK MISSING VALUE (ITEMS)
--==================================
SELECT 'order_id' AS column_name,
	COUNT(*) filter (where order_id IS NULL) as missing_count 
FROM items 
union all
SELECT 'order_item_id',
	COUNT(*) filter (where order_item_id IS NULL)  
FROM items 
union all
SELECT 'product_id',
	COUNT(*) filter (where product_id IS NULL)  
FROM items 
union all
SELECT 'seller_id',
	COUNT(*) filter (where seller_id IS NULL)  
FROM items 
union all
SELECT 'shipping_limit_date',
	COUNT(*) filter (where shipping_limit_date IS NULL)  
FROM items 
union all
SELECT 'price',
	COUNT(*) filter (where price IS NULL)  
FROM items 
union all
SELECT 'freight_value',
	COUNT(*) filter (where freight_value IS NULL) 
FROM items


--==================================
-- MENGECEK MISSING VALUE (ORDERS)
--==================================
SELECT 'order_id' AS column_name,
	COUNT(*) filter (where order_id IS NULL) as missing_count 
FROM orders 
union all
SELECT 'customer_id',
	COUNT(*) filter (where customer_id IS NULL)  
FROM orders 
union all
SELECT 'order_status',
	COUNT(*) filter (where order_status IS NULL)  
FROM orders 
union all
SELECT 'order_purchase_timestamp',
	COUNT(*) filter (where order_purchase_timestamp IS NULL)  
FROM orders 
union all
SELECT 'order_approved_at',
	COUNT(*) filter (where order_approved_at IS NULL)  
FROM orders 
union all
SELECT 'order_delivered_carrier_date',
	COUNT(*) filter (where order_delivered_carrier_date IS NULL)  
FROM orders 
union all
SELECT 'order_delivered_customer_date',
	COUNT(*) filter (where order_delivered_customer_date IS NULL)  
FROM orders 
union all
SELECT 'order_estimated_delivery_date',
	COUNT(*) filter (where order_estimated_delivery_date IS NULL)  
FROM orders 


--==================================
-- MENGECEK MISSING VALUE (PAYMENTS)
--==================================
SELECT 'order_id' AS column_name,
	COUNT(*) filter (where order_id IS NULL) as missing_count 
FROM payments 
union all
SELECT 'payment_sequential',
	COUNT(*) filter (where payment_sequential IS NULL)  
FROM payments
union all
SELECT 'payment_type',
	COUNT(*) filter (where payment_type IS NULL)  
FROM payments
union all
SELECT 'payment_installments',
	COUNT(*) filter (where payment_installments IS NULL)  
FROM payments
union all
SELECT 'payment_value',
	COUNT(*) filter (where payment_value IS NULL)  
FROM payments 

--=======================
-- MENGECEK DATA DUPLIKAT 
--=======================
-- PRODUCTS
SELECT product_id, COUNT(*)
FROM products 
group by product_id 
having COUNT(*) > 1;

-- ITEMS
SELECT order_id, order_item_id, COUNT(*)
FROM items 
group by order_id, order_item_id
having COUNT(*) > 1;

-- ORDERS
SELECT order_id, COUNT(*)
FROM orders 
group by order_id
having COUNT(*) > 1;

-- PAYMENTS
SELECT order_id, payment_sequential, COUNT(*)
FROM payments
group by order_id, payment_sequential
having COUNT(*) > 1;


--====================================
--MENGHITUNG JUMLAH OUTLIER (PRODUCTS)
--====================================
-- Hitung Jumlah Outlier Kolom (product_name_lenght)
WITH stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY product_name_lenght) AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY product_name_lenght) AS q3
    FROM products
),
bounds AS (
    SELECT
        (q1 - 1.5 * (q3 - q1)) AS lower_bound,
        (q3 + 1.5 * (q3 - q1)) AS upper_bound
    FROM stats
)

SELECT
    COUNT(*) AS total_outlier
FROM products d
CROSS JOIN bounds
WHERE d.product_name_lenght < lower_bound
   OR d.product_name_lenght > upper_bound;


--====================================
--OUTLIER KOLOM NUMERIK TABEL PRODUCTS
--====================================

-- 1. Hitung Q1 dan Q3 untuk semua kolom numerik pada tabel product sekaligus bersamaan
WITH stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY product_name_lenght) AS name_len_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY product_name_lenght) AS name_len_q3,
        
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY product_description_lenght) AS desc_len_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY product_description_lenght) AS desc_len_q3,
        
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY product_photos_qty) AS photos_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY product_photos_qty) AS photos_q3,
        
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY product_weight_g) AS weight_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY product_weight_g) AS weight_q3,
        
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY product_length_cm) AS length_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY product_length_cm) AS length_q3,
        
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY product_height_cm) AS height_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY product_height_cm) AS height_q3,
        
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY product_width_cm) AS width_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY product_width_cm) AS width_q3
    FROM products
),

-- 2. Hitung Lower Bound dan Upper Bound untuk semua kolom numerik pada tabel products
bounds AS (
    SELECT
        (name_len_q1 - 1.5 * (name_len_q3 - name_len_q1)) AS name_len_lower,
        (name_len_q3 + 1.5 * (name_len_q3 - name_len_q1)) AS name_len_upper,
        
        (desc_len_q1 - 1.5 * (desc_len_q3 - desc_len_q1)) AS desc_len_lower,
        (desc_len_q3 + 1.5 * (desc_len_q3 - desc_len_q1)) AS desc_len_upper,
        
        (photos_q1 - 1.5 * (photos_q3 - photos_q1)) AS photos_lower,
        (photos_q3 + 1.5 * (photos_q3 - photos_q1)) AS photos_upper,
        
        (weight_q1 - 1.5 * (weight_q3 - weight_q1)) AS weight_lower,
        (weight_q3 + 1.5 * (weight_q3 - weight_q1)) AS weight_upper,
        
        (length_q1 - 1.5 * (length_q3 - length_q1)) AS length_lower,
        (length_q3 + 1.5 * (length_q3 - length_q1)) AS length_upper,
        
        (height_q1 - 1.5 * (height_q3 - height_q1)) AS height_lower,
        (height_q3 + 1.5 * (height_q3 - height_q1)) AS height_upper,
        
        (width_q1 - 1.5 * (width_q3 - width_q1)) AS width_lower,
        (width_q3 + 1.5 * (width_q3 - width_q1)) AS width_upper
    FROM stats
)

-- 3. Hitung total outlier masing-masing kolom numerik pada tabel products dalam satu baris dengan output horizontal
-- Disini menggunakan SUM(CASE WHEN) karena mengecek outlier banyak kolom sekaligus dalam satu query
-- Jika COUNT(*) WHERE itu digunakan jika hanya mengecek 1 kolom saja seperti diatas
SELECT
    SUM(CASE WHEN p.product_name_lenght < b.name_len_lower OR p.product_name_lenght > b.name_len_upper THEN 1 ELSE 0 END) AS outlier_name_lenght,
    SUM(CASE WHEN p.product_description_lenght < b.desc_len_lower OR p.product_description_lenght > b.desc_len_upper THEN 1 ELSE 0 END) AS outlier_description_lenght,
    SUM(CASE WHEN p.product_photos_qty < b.photos_lower OR p.product_photos_qty > b.photos_upper THEN 1 ELSE 0 END) AS outlier_photos_qty,
    SUM(CASE WHEN p.product_weight_g < b.weight_lower OR p.product_weight_g > b.weight_upper THEN 1 ELSE 0 END) AS outlier_weight_g,
    SUM(CASE WHEN p.product_length_cm < b.length_lower OR p.product_length_cm > b.length_upper THEN 1 ELSE 0 END) AS outlier_length_cm,
    SUM(CASE WHEN p.product_height_cm < b.height_lower OR p.product_height_cm > b.height_upper THEN 1 ELSE 0 END) AS outlier_height_cm,
    SUM(CASE WHEN p.product_width_cm < b.width_lower OR p.product_width_cm > b.width_upper THEN 1 ELSE 0 END) AS outlier_width_cm
FROM products p
CROSS JOIN bounds b;

--=================================
--OUTLIER KOLOM NUMERIK TABEL ITEMS
--=================================
-- 1. Hitung Q1 dan Q3 untuk semua kolom numerik pada tabel items sekaligus bersamaan
WITH stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) AS price_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) AS price_q3,
        
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY freight_value) AS freight_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY freight_value) AS freight_q3
    FROM items
),

-- 2. Hitung Lower Bound dan Upper Bound untuk semua kolom numerik pada tabel items
bounds AS (
    SELECT
        (price_q1 - 1.5 * (price_q3 - price_q1)) AS price_lower,
        (price_q3 + 1.5 * (price_q3 - price_q1)) AS price_upper,
        
        (freight_q1 - 1.5 * (freight_q3 - freight_q1)) AS freight_lower,
        (freight_q3 + 1.5 * (freight_q3 - freight_q1)) AS freight_upper
    FROM stats
)

-- 3. Hitung total outlier masing-masing kolom numerik pada tabel items dalam satu baris dengan output horizontal
-- Disini menggunakan SUM(CASE WHEN) karena mengecek outlier banyak kolom sekaligus dalam satu query
-- Jika COUNT(*) WHERE itu digunakan jika hanya mengecek 1 kolom saja seperti diatas
SELECT
    SUM(CASE WHEN i.price < b.price_lower OR i.price > b.price_upper THEN 1 ELSE 0 END) AS outlier_price,
    SUM(CASE WHEN i.freight_value < b.freight_lower OR i.freight_value > b.freight_upper THEN 1 ELSE 0 END) AS outlier_freight_value
FROM items i
CROSS JOIN bounds b;


--==================================
--OUTLIER KOLOM NUMERIK TABEL ORDERS
--==================================
-- Dari tabel orders tidak ada kolom yang bertype numerik jadi tidak ada yang di cek outliernya dengan IQR
-- Berikut uji coba cek outlier untuk kolom bertype
SELECT 
    COUNT(*) AS total_data_error
FROM orders
WHERE order_approved_at < order_purchase_timestamp                   -- Waktu pesanan disetujui mendahului waktu pembelian
   OR order_delivered_customer_date < order_delivered_carrier_date;  -- Barang diterima pelanggan sebelum diserahkan ke kurir

--====================================
--OUTLIER KOLOM NUMERIK TABEL PAYMENTS
--====================================
-- 1. Hitung Q1 dan Q3 untuk semua kolom numerik pada tabel payments sekaligus bersamaan
WITH stats AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment_sequential) AS seq_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment_sequential) AS seq_q3,
        
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment_installments) AS inst_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment_installments) AS inst_q3,
        
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment_value) AS val_q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment_value) AS val_q3
    FROM payments
),

-- 2. Hitung Lower Bound dan Upper Bound untuk semua kolom numerik pada tabel payments
bounds AS (
    SELECT
        (seq_q1 - 1.5 * (seq_q3 - seq_q1)) AS seq_lower,
        (seq_q3 + 1.5 * (seq_q3 - seq_q1)) AS seq_upper,
        
        (inst_q1 - 1.5 * (inst_q3 - inst_q1)) AS inst_lower,
        (inst_q3 + 1.5 * (inst_q3 - inst_q1)) AS inst_upper,
        
        (val_q1 - 1.5 * (val_q3 - val_q1)) AS val_lower,
        (val_q3 + 1.5 * (val_q3 - val_q1)) AS val_upper
    FROM stats
)

-- 3. Hitung total outlier masing-masing kolom numerik pada tabel payments dalam satu baris dengan output horizontal
-- Disini menggunakan SUM(CASE WHEN) karena mengecek outlier banyak kolom sekaligus dalam satu query
-- Jika COUNT(*) WHERE itu digunakan jika hanya mengecek 1 kolom saja seperti diatas
SELECT
    SUM(CASE WHEN p.payment_sequential < b.seq_lower OR p.payment_sequential > b.seq_upper THEN 1 ELSE 0 END) AS outlier_payment_sequential,
    SUM(CASE WHEN p.payment_installments < b.inst_lower OR p.payment_installments > b.inst_upper THEN 1 ELSE 0 END) AS outlier_payment_installments,
    SUM(CASE WHEN p.payment_value < b.val_lower OR p.payment_value > b.val_upper THEN 1 ELSE 0 END) AS outlier_payment_value
FROM payments p
CROSS JOIN bounds b;


--=============================
-- MENGECEK INKONSISTENSI DATA
--=============================
--==============================================================
-- 1. TABEL PRODUCTS : Mengecek inkonsistensi penulisan kategori
--==============================================================
-- Dari tabel product_category_name ingin dideteksi untuk nama kategori yang berantakan
-- karena salah ketik (typo), perbedaan huruf besar/kecil, atau spasi pada teks
select product_category_name, COUNT(*) as total_produk
from products
group by product_category_name
order by product_category_name;

-- Memastikan jumlah data "" dalam kolom product_category_name
SELECT COUNT(*) 
FROM products 
WHERE product_category_name = '';

-- INTERPRETASI
-- Pada kolom product_category_name tidak ditemukan missing value berupa NULL
-- Namun, ditemukan masalah inkonsistensi data berupa string kosong (empty string '') sebanyak 277 data
-- Jumlah inkonsistensi ini sama dengan data missing pada spesifikasi produk lainnya

--============================================================
-- 2. TABEL ORDERS : Mengecek inkonsistensi alur waktu dataset
--============================================================
-- Tujuan untuk melihat data yang tanggalnya tidak sesuai atau melompat 
-- Karena secara urutan proses bisnis (beli --> disetujui --> masuk kurir --> diterima customer)
-- Maka perlu dicek bagaimana urutan waktunya apakah sesuai atau tidak sesuai
select 
	SUM (case when order_approved_at < order_purchase_timestamp then 1 else 0 END) as approved_mendahului_beli,
	SUM (case when order_delivered_carrier_date < order_purchase_timestamp then 1 else 0 END) as dikirim_mendahului_beli,
	SUM (case when order_delivered_customer_date < order_delivered_carrier_date then 1 else 0 END) as diterima_mendahului_dikirim
from orders;

-- INTERPRETASI
-- Terdapat 31 transaksi yang dikirim_mendahului_beli
-- ARTINYA : ada 31 transaksi yang tanggal penyerahan barang ke kurir (order_delivered_carrier_date) tercatat lebih dulu 
--           daripada tanggal barang itu dibeli (order_purchase_timestamp)
-- Dan 2 transaksi yang diterima_mendahului_dikirim
-- ARTINYA : ada 2 transaksi yang tanggal barangya sampai di rumah pelanggan (order_delivered_customer_date) tercatat lebih dulu 
--           daripada tanggal barang itu dikirim oleh kurur/penjual (order_delivered_carrier_date)

--=================================================
-- 3. TABEL ITEMS & PRODUCTS : Mengecek hubungan ID
--=================================================
-- Tujuannya untuk mengecek apakah ada produk yang terjual di tabel items
-- tetapi di product_id tidak terdaftar di tabel master products
SELECT COUNT(DISTINCT i.product_id) AS total_id_produk_gaib
FROM items i
LEFT JOIN products p ON i.product_id = p.product_id
WHERE p.product_id IS NULL AND i.product_id IS NOT NULL;

--===============================================================
-- 4. TABEL PAYMENTS & ITEMS : Mengecek sinkronisasi nominal uang
--===============================================================
-- Membandingkan apakah total uang yang dibayar konsumen di tabel payments sudah klop (sama nilainya)
-- dengan total harga barang + ongkir di tabel items
WITH total_belanja AS (
    SELECT order_id, SUM(price + freight_value) AS seharusnya_bayar
    FROM items
    GROUP BY order_id
),
total_bayar AS (
    SELECT order_id, SUM(payment_value) AS total_dibayarkan
    FROM payments
    GROUP BY order_id
)

SELECT COUNT(*) AS total_transaksi_tidak_klop
FROM total_belanja b
JOIN total_bayar p ON b.order_id = p.order_id
WHERE ABS(b.seharusnya_bayar - p.total_dibayarkan) > 0.01; -- Mengantisipasi sedikit selisih pembulatan desimal

--INTERPRETASI
-- Terdapat 499 transaksi (order_id) di dalam database yang jumlah uangnya TIDAK SESUAI
-- antara catatan di tabel transaksi (items) dengan yang dibayarkan konsumen di tabel keuangan (payments)
-- INTINYA : ada 499 transaksi yang penjumlahan s(harga barang+ongkir) di tabel items
--           tidak sama nilainya dengan nomial pembayaran aslinya di tabel payments.


--=======================
-- TAHAP DATA CLEANING --
--=======================

--=================================
-- Mengubah Primery Key Tabel Items
--=================================
--Pada create tabel sebelumnya untuk tabel items terdapat 2 primery keys
--Tahap ini dilakukan untuk mengubah primery key menjadi 1 kolom saja
--Tujuannya untuk memudahkan data nantinya untuk proses query JOIN 
--Karena 2 primery key boleh dan sah secara teori database jika datanya saling bergantung/berhubungan
--Tetapi 1 primery key akan membuat dataset/table lebih ringan dan rapi untuk menjalannkan query lainnya

ALTER TABLE items DROP CONSTRAINT items_pkey;                    -- drop constraint untuk menghapus aturan primary key gabungan yang lama saat create table
ALTER TABLE items ADD COLUMN item_unique_id SERIAL PRIMARY KEY;  -- membuat kolom baru untuk dijadikan primary key (PK) dan uniq, perintah serial akan membuat urut no 1,2,3 dst

-- Kolom baru item_unique_id untuk dijadikan PK tunggal yang baru

--====================================
-- Mengubah Primery Key Tabel Payments
--====================================
--Pada create tabel sebelumnya untuk tabel payments terdapat 2 primery keys
--Tahap ini dilakukan untuk mengubah primery key menjadi 1 kolom saja
--Tujuannya untuk memudahkan data nantinya untuk proses query JOIN 
--Karena 2 primery key boleh dan sah secara teori database jika datanya saling bergantung/berhubungan
--Tetapi 1 primery key akan membuat dataset/table lebih ringan dan rapi untuk menjalannkan query lainnya

ALTER TABLE payments DROP CONSTRAINT payments_pkey;                   -- drop constraint untuk menghapus aturan primary key gabungan yang lama saat create table
ALTER table payments ADD COLUMN payments_unique_id SERIAL PRIMARY KEY;   -- membuat kolom baru untuk dijadikan primary key (PK) dan uniq, perintah serial akan membuat urut no 1,2,3 dst

-- Kolom baru payments_unique_id untuk dijadikan PK tunggal yang baru

--===================================================
-- Mengecek kembali tabel yang ditambah kolom barunya
--===================================================
-- Items
SELECT * FROM items LIMIT 10;  -- mengecek 10 data teratas

-- Payments
SELECT * FROM payments LIMIT 10;  -- mengecek 10 data teratas


--===============================
--Handling Missing Value Products
--===============================
-- Membuat table salinan baru untuk mengisi missing value
-- Membuat kolom pengisian missing value table products
-- 1. Membuat tabel baru 
create table clean_products as 
select * from products;

-- 2. Update kolom kategori teks (menangani NULL dan spasi kosong)
update clean_products
set product_category_name = 'unknown' -- isi unknown untuk nama kategori produk yang kosong
where product_category_name is null 
	or trim(product_category_name) = '';

-- 3. Update kolom-kolom info produk angka (ubah NULL jadi 0)
-- isi 0 untuk panjang karakter nama produk yang kosong
update clean_products set product_name_lenght = 0 where product_name_lenght is null;

-- isi 0 untuk panjang karakter deskripsi produk yang kosong
update clean_products set product_description_lenght = 0 where product_description_lenght is null;

-- isi 0 untuk jumlah foto produk yang kosong
update clean_products set product_photos_qty = 0 where product_photos_qty is null;

-- 4. Update kolom berat dan dimensi produk angka (ubah NULL jadi 0)
update clean_products set product_weight_g = 0 where product_weight_g is null;
update clean_products set product_length_cm = 0 where product_length_cm is null;
update clean_products set product_height_cm = 0 where product_height_cm is null;
update clean_products set product_width_cm = 0 where product_width_cm is null;

-- 5. Cek kembali missing value setelah di handling
SELECT 'product_id' AS column_name, COUNT(*) filter (where product_id IS NULL) as missing_count 
FROM clean_products 
union all
SELECT 'product_category_name', COUNT(*) filter (where product_category_name IS null or trim(product_category_name) = '') 
FROM clean_products 
union all
SELECT 'product_name_lenght', COUNT(*) filter (where product_name_lenght IS NULL)  
FROM clean_products 
union all
SELECT 'product_description_lenght', COUNT(*) filter (where product_description_lenght IS NULL)  
FROM clean_products 
union all
SELECT 'product_photos_qty', COUNT(*) filter (where product_photos_qty IS NULL)  
FROM clean_products
union all
SELECT 'product_weight_g', COUNT(*) filter (where product_weight_g IS NULL)  
FROM clean_products 
union all
SELECT 'product_length_cm', COUNT(*) filter (where product_length_cm IS NULL)  
FROM clean_products 
union all
SELECT 'product_height_cm', COUNT(*) filter (where product_height_cm IS NULL)  
FROM clean_products 
union all
SELECT 'product_width_cm', COUNT(*) filter (where product_width_cm IS NULL)
FROM clean_products 

INTERPRETASI :
-- Terdapat tabel baru bernama clean_products yang isinya table yang sudah dibersihkan/dihandling missing valuenya yang sebelumnya terdapat pada tabel products
-- Setelah di handling maka dilakukan pengecekan kembali terhadap jumlah missing value maka dapat diketahui bahwa semua kolomnya sudah tidak ada (0) missing valuenya
-- Alasan dilakukan handling value tabel product karena :
-- (1). menghindari "error" saat perhitungan statistik
-- (2). supaya hasil analisisnya tidak bias
-- (3). mempermudah proses pengelompokan (grouping)

--=============================
--Handling Missing Value Orders
--=============================
-- Pada tabel orders data yang ada missing valuenya bertype TIMESTAMP yang tidak bisa diisi "unknown" atau angka 0
-- Data tanggal kosongnya bukan disebabkan karena data yang rusak/kotor tetapi karena proses transaksinya memang belum sampai di tahap tersebut
-- Jadi untuk kolom items missing valuenya dibiarkan tetap NULL (apa adanya) 
-- Hal ini pada kolom tanggal transaksi akan bermakna sah dimana proses tersebut belum terjadi

--================
--Handling Outlier
--================
-- TABEL PRODUCTS : Terdapat outlier terbanyak pada kolom berat barang sebanyak 2.074 data
--                  Hal ini wajar karena variasi produk dari yang ringan misalnya baju sampai super berat (kulkas/kasur)
-- TABEL ITEMS : Terdapat outlier pada kolom harga sebanyak 1.135 data dan kolom ongkir sebanyak 1.613 data
--                Hal ini wajar karena harga barang kecil dan besar berbeda dan untuk ongkir beda wilayah juga akan jauh berbeda berdasarkan jarak pengiriman
-- TABEL PAYMENTS : Terdapat outlier terbanyak pada kolom nilai pembayaran sebanyak 1.151 data
--                   Hal ini juga dipengaruhi oleh jenis barang yang dipesan dan harga barang tentu jauh berbeda tergantung jenisnya
-- KESIMPULAN : Data outlier pada tabel products, items, dan payments dibiarkan saja tidak dihapus maupun diubah
--              Karena data tersebut aman dibiarkan apa adanya karena merupakan data transaksi rill (valid) dari pelanggan olist


-- TABEL ORDERS : Terdapat 2 outlier yang 
--                - waktu pesanan disetujui mendahului waktu pembelian, atau
--                - barang diterima pelanggan sebelum diserahkan ke kurir
-- Jadi perlu di handling dengan mengeliminasi atau membuang 2 baris data yang error
-- Membuat tabel clean_orders yang bebas dari kesalahan ketentuan tanggal
CREATE TABLE clean_orders AS
SELECT * FROM orders
WHERE NOT (
    order_approved_at < order_purchase_timestamp
    OR order_delivered_customer_date < order_delivered_carrier_date
) 
OR order_approved_at IS NULL 
OR order_delivered_customer_date IS NULL;

-- Mengecek kembali jumlah baris tabel clean_orders setelah di handling
SELECT 'orders', COUNT(*) FROM clean_orders;

-- Mengecek kembali jumlah data errornya
SELECT COUNT(*) AS sisa_data_error 
FROM clean_orders 
WHERE order_approved_at < order_purchase_timestamp
   OR order_delivered_customer_date < order_delivered_carrier_date;

--INTRERPRETASI
-- Setelah dilakukan handling outlier dengan menghapus barisnya maka didapatkan untuk tabel clean_orders jumlah barisnya menjadi 14.998 baris.
-- Dan setelah dicek kembali jumlah data errornya adalah 0

-- MELAKUKAN MANIPULASI SKEMA TABEL CLEAN_ORDERS
-- Hal ini untuk membuktikan pemahaman struktur database
-- Data dummu dihapus kembali, baru lanjut ke bagian analisis bisnis dengan data yang murni bersih

--================
--PROSES DDL & DML
--================
-- 1. Menambahkan constraint UNIQUE pada tabel clean orders yang sudah ada
ALTER TABLE clean_orders 
ADD CONSTRAINT unique_order_id UNIQUE (order_id);

-- 2. Membuktikan perintah insert untuk memasukkan data simulasi baru
INSERT INTO clean_orders (
    order_id, customer_id, order_status, order_purchase_timestamp, 
    order_approved_at, order_delivered_carrier_date, 
    order_delivered_customer_date, order_estimated_delivery_date
)
VALUES (
    'order_simulasi_99999', 'cust_dummy_12345', 'delivered', '2026-05-28 10:00:00', 
    '2026-05-28 10:15:00', '2026-05-28 14:00:00', 
    '2026-05-28 17:30:00', '2026-05-30 00:00:00'
);

-- 3. Mengecek data simulasi sukses masuk
SELECT * FROM clean_orders 
WHERE order_id = 'order_simulasi_99999';

-- 4. Menghapus kembali data simulasi agar tidak merusak perhitungan analisis bisnisnya
DELETE FROM clean_orders 
WHERE order_id = 'order_simulasi_99999';

--=================--
-- ANALISIS BISNIS --
--=================--

-- Melakukan analisis bisnis yang dianalisis berdasarkan tabel clean_products, items, clean_orders, payments
-- Analisis data e-commerce olist

--============================================================
-- 1. Ringkasan performa finansial Perusahaan e-commerce olist
--============================================================
SELECT 
    COUNT(order_id) AS total_transaksi,
    SUM(payment_value) AS total_omset,
    ROUND(AVG(payment_value), 2) AS rata_rata_nominal_belanja,
    MIN(payment_value) AS transaksi_paling_murah,
    MAX(payment_value) AS transaksi_paling_mahal
FROM payments;

--INTERPRETASI 
-- 1. Total transaksi pada tabel payment terdapat 15.000 transaksi
-- 2. Dengan total omsetnya R$2.287.826,69
-- 3. Rata-rata nomimal belanja customer adalah R$152,52
-- 4. Transaksi paling murah yaitu 0 
-- 5. Transaksi paling mahal adalah R$6.929,31

--=========================================================================
-- 2. TOP 5 kategori produk yang menghasilkan omset terbesar (Best Selling)
--=========================================================================
SELECT 
    p.product_category_name AS kategori_produk,
    COUNT(i.product_id) AS total_barang_terjual,
    ROUND(SUM(i.price)) AS total_omset_pendapatan
FROM items i
JOIN clean_products p ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_omset_pendapatan desc
LIMIT 5;

--INTERPRETASI 
-- Terdapat top 5 kategori produk dengan omset terbesar yaitu :
-- 1. Kecantikan dan kesehatan (beleza_saude)
--    --> Menempati peringkat TOP 1 dengan total omset R$72.759 dengan total barang terjual 596 barang

-- 2. Jam tangan dan kado (Relogios_presentes)
--    --> Berada pada posisi kedua dengan total omset R$68.699 dengan total barang terjual 319 barang

-- 3. Perlengkapan tempat tidur dan kamar mandi (Cama_mesa_banho)
--    --> Total omset R$62.769 dengan kategori volume penjualan terbanyak di top 5 yaitu sebanyak 642 barang

-- 4. Olahraga dan rekreasi (Esporte_lazer)
--    --> Memiliki total omset R$57.312 dengan total barang terjual 520 barang

-- 5. Aksesoris informatika (Informatica_acessorios)
--    --> Penutup top 5 dengan omset R$47.289 dari total penjual barang 437 barang

--INSIGHT
-- 1. Strategi high-value, low-volume (kategori jam tangan)
-- --> Kondisi menunjukkan total omset tertinggi kedua dan total barang yang terjual paling sedikit di TOP 5
--     Hal ini menunjukkan harga rata-rata produknya sangat mahal (premium product)
--     Karena kategori produk ini memiliki margin keuntungan yang sangat tinggi per barangnya

-- 2. Strategi high-volume, low-value (kategori Perlengkapan tempat tidur dan kamar mandi)
-- --> Kondisi menunjukkan barang paling banyak dibeli (TOP 1, paling laris) tetapi untuk omset berada diperingkat ketiga
--     Hal ini menandakan kategori ini harganya relatif murah dan bersifat kebutuhan sehari-hari sehingga perputarannya cepat

-- 3. Kategori Kecantikan dan kesehatan
-- --> Kondisi menjadi TOP 1 untuk omset yang membuktikan bahwa pasar produk perawatan tubuh, kosmetik, dan kesehatan
--     memiliki demand/tuntutan yang sangat stabil dan laku di paltform e-commerce olist 

--REKOMENDASI
-- 1. Menggencarkan promosi produk jam tangan menjelang hari raya ataupun sebagai kado
--    Karena ini sangat membantu untuk meningkatkan omset perusahaan

-- 2. Melakukan  bundling untuk perlengkapan rumah
--    Karena volume penjualan yang tinggi membuat strategi paket hemat misal beli seprei gratis sarung bantal
--    Hal ini bertujuan agar rata-rata uang yang dikeluarkan pembeli sekali transaksi bisa meningkat

-- 3. Mengamankan stok (supply chain) untuk produk kecantikan
--    Hal ini supaya tidak terjadi stock-out (kehabisan barang) 
--    Karena kategori ini paling laku di pasaran dan menjadi TOP 1 kategori barang dengan omset tertinggi

--===================================================
-- 3. Tren pertumbuhan omset dan pesanan bulanan toko
--===================================================
-- 3.1 Mengurutkan data sesuai urutan bulan transaksi dari awal sampai akhir
SELECT 
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS bulan_transaksi,
    COUNT(DISTINCT o.order_id) AS total_pesanan_sukses,
    ROUND(SUM(i.price)) AS total_omset_bulanan
FROM clean_orders o
JOIN items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY bulan_transaksi
ORDER BY bulan_transaksi ASC;

-- 3.2 Mengurutkan data dari total omset bulanan tertinggi 
SELECT 
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS bulan_transaksi,
    COUNT(DISTINCT o.order_id) AS total_pesanan_sukses,
    ROUND(SUM(i.price)) AS total_omset_bulanan
FROM clean_orders o
JOIN items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY bulan_transaksi
ORDER BY total_omset_bulanan DESC;

--INTERPRETASI
-- 1. Data transaksi berdasarkan tabel pemesanan tercatat bahwa data ini berisi pemesanan barang dari September 2016-Agustus 2018 
--    Tetapi dapat dilihat tidak ada bulan transaksi terjadi pada November dan Desember 2016
-- 2. Dari tabel orders diketahui bahwa data transaksi tercatat 
--    - 2 bulan transaksi 2016
--    - 12 bulan transaksi 2017
--    - 8 bulan transaksi 2018
--    - Total semua transasi tercatat sebanyak 22 bulan
-- 3. Total pesanan transasi 
--    - Tahun 2016 meningkat dari september yang awalnya 1 pesanan pada oktober menjadi 2 pesanan
--    - Tahun 2017 pada januari sampai maret transaksi meningkat namun bulan april terjadi penurunan
--      tetapi pada bulan mei kembali meningkat dan menurun lagi pada bulan juni, kembali meningkat 
--      pada bulan juli-september tetapi terjadi penurunan pada oktober dan kembali meningkat pada november-desember
--    - Tahun 2017 total pesanan terbanyak yaitu bulan November yaitu 154 pesanan
--    - Tahun 2018 pesanan meningkat dari tahun sebelumnya dengan range 126-167
--      dengan pesanan terbanyak pada bulan Februari yaitu 167 pesanan dan pesanan sedikit pada bulan agustus yaitu 126 pesanan
-- 4. Dilihat dari urutan total omset bulanan dari yang tertinggi ke terendah
--    - urutan 3 bulan tertinggi untuk total omset bulanan yaitu Mei, Juli, April 2018
--    - urutan 3 bulan terendah untuk total omset bulanan yaitu September, Oktober 2016 dan Januari 2017

--INSIGHT
-- 1. Efek peak season akhir tahun
--    Terjadi lonjakan penjualan tertinggi pada November 2017 didorong oleh momentum diskon global persiapan natal/tahun baru
-- 2. Bisnis mulai stabil 
--    Memasuki 2018 performa toko mulai stabil di angka tinggi (126-167 pesanan/bulan) yang menandakan brand awareness platform sudah kuat
-- 3. Pergeseran ke produk premium
--    Meskipun November 2017 menang secara jumlah pesanan, omset terbesar justru didominasi oleh bulan-bulan di tahun 2018 (Mei, Juli, April)
--    Hal ini menandakan konsumen mulai beralih membeli barang-barang dengan harga yang lebih mahal (high-ticket items)

--REKOMENDASI
-- 1. Mengamankan stok premium
--    Optimalkan pengadaan produk berharga mahal (seperti eloktronik/jam tangan) pada bulan Maret 
--    untuk menyambut puncak omset di bulan April dan Mei
-- 2. Siapkan logistik untuk lonjakan akhir tahun
--    Belajar dari hilangnya data di akhir tahun 2016, kapasitas kurir dan sistem gudang harus diperketat
--    sejak Oktober untuk mengantisipasi overload pesanan Black Friday di bulan November
-- 3. Evaluasi penurunan di bulan Agustus
--    Lakukan investigasi internal mengapa penjualan di agustus 2018 turun ke angka terendah (126 pesanan)
--    disebabkan karena  kurangnya promo, kehabisan stok, atau masalah teknis pada aplikasi.

--===============================================
-- 4. Analisis 3 kategori produk utama tiap tahun
--===============================================
-- Analisis 3 kategori produk utama tiap tahun
WITH omset_produk_per_tahun AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS tahun_transaksi,
        p.product_category_name AS kategori_produk,
        SUM(i.price) AS total_omset_kategori
    FROM clean_orders o
    JOIN items i ON o.order_id = i.order_id
    JOIN clean_products p ON i.product_id = p.product_id
    WHERE o.order_status = 'delivered' AND p.product_category_name IS NOT NULL
    GROUP BY tahun_transaksi, kategori_produk
),
ranking_produk_per_tahun AS (
    SELECT 
        tahun_transaksi,
        kategori_produk,
        ROUND(total_omset_kategori) AS total_omset,
        DENSE_RANK() OVER (
            PARTITION BY tahun_transaksi 
            ORDER BY total_omset_kategori DESC
        ) AS urutan_ranking
    FROM omset_produk_per_tahun
)
SELECT * FROM ranking_produk_per_tahun
WHERE urutan_ranking <= 3
ORDER BY tahun_transaksi ASC, urutan_ranking ASC;

--INTERPRETASI
-- 1. Performa kategori produk dipecah secara spesifik per tahun transaksi untuk melihat pergeseran tren pasar.
-- 2. Pada tahun 2016 (awal mula e-commerce berjalan), transaksi masih sangat minimal yaitu kategori 'utilidades_domesticas' (peralatan rumah tangga)
--    memimpin di peringkat pertama dengan omzet sebesar R$110.
-- 3. Pada tahun 2017, terjadi lonjakan performa yang masif dengan peta persaingan baru:
--    - Peringkat 1 adalah kategori 'cama_mesa_banho' (kebutuhan tempat tidur & kamar mandi) dengan omset mencapai R$5.115
--    - Peringkat 2 ditempati oleh 'cool_stuff' dengan omset sebesar R$5.059
--    - Peringkat 3 ditempati oleh 'beleza_saude' (kecantikan & kesehatan) dengan omset sebesar R$4.263
-- 4. Pada tahun 2018, terjadi pergeseran tren atau "shifting market" yang cukup menarik
--    - Kategori 'pcs' (komputer/gadget) menjadi peringkat 1 dengan total omset tertinggi sebesar R$7.349
--    - Kategori 'beleza_saude' naik kelas ke peringkat 2 dengan omset sebesar R$6.001
--    - Sementara juara tahun lalu, 'cama_mesa_banho', turun ke peringkat 3 dengan omset 5.811.
-- 5. Kesimpulan Bisnis: Kategori 'beleza_saude' dan 'cama_mesa_banho' merupakan produk yang paling stabil dan selalu diminati 
--    karena konsisten bertahan di posisi Top 3 selama dua tahun berturut-turut (2017-2018)
--    Namun, lonjakan omset tertinggi secara personal dipegang oleh kategori 'pcs' pada tahun 2018.

--===================================================================
-- 5. Analisis karakteristik nilai transaksi di atas rata-rata global
--===================================================================
SELECT 
    order_id, 
    payment_value AS total_belanja
FROM payments
WHERE payment_value > (
    SELECT AVG(payment_value) FROM payments
)
ORDER BY payment_value DESC;

-- INTERPRETASI
-- 1. Berdasarkan hasilnya sistem berhasil menyaring pesanan-pesanan yang memiliki 
--    nilai transaksi di atas rata-rata nilai pembayaran konsumen secara global.
-- 2. Melalui hasil filter tersebut, dapat diidentifikasi nilai transaksi tertinggi (paling premium) yang terjadi di platform
--    e-commerce ini yaitu oleh order_id '0812eb902a67711a1cb742b3cdaa65...' dengan total belanja fantastis mencapai R$6.929,31.
-- 3. Pola data menunjukkan adanya segmentasi pelanggan kelas atas (high-value customers) yang melakukan transaksi dengan nominal 
--    berkisar antara 2.600 hingga hampir 7.000 dalam sekali transaksi, jauh melampaui rata-rata keranjang belanja normal pada umumnya.
-- 4. Kesimpulan Bisnis: Data transaksi bernilai tinggi ini sangat krusial bagi tim marketing untuk mengidentifikasi kelompok pelanggan loyal/VIP. 
--    Informasi ini dapat digunakan sebagai dasar program retensi khusus, pemberian reward eksklusif, atau penawaran promo personalisasi guna 
--    menjaga retensi transaksi premium ke depannya.

--==========================================================
-- 6. Jenis pembayaran yang paling sering digunakan pembeli
--==========================================================
SELECT 
    payment_type AS metode_pembayaran,
    COUNT(*) AS total_penggunaan,
    ROUND(SUM(payment_value)) AS total_perputaran_uang
FROM payments
GROUP BY payment_type
ORDER BY total_penggunaan DESC;

--INTERPRETASI
-- Berdasarkan tabel hasil query metode pembayaran urutan penggunaannya adalah :
-- 1. Credit card menjadi pilihan utama dalam penggunaan yaitu sebanyak 11.073 kali dengan total perputaran uangnya mencapai R$ 11.073
-- 2. Boleto berada diposisi kedua dengan 2.847 kali penggunaan dan perputaran uangnya R$406.614
-- 3. Voucher berada diposisi ketiga dengan penggunaan 875 kali dan total perputaran uangnya 56.640
-- 4. Debit card hanya digunakan 204 kali dengan nilai perputaran uang R$26.802
-- 5. Terakhir terdapat 1 transaksi yang tidak terdefenisi dengan nilai 0

--INSIGHT
-- 1. Lebih 70% transaksi menggunakan credit card yang menandakan mayoritas pembeli di platform ini lebih menyukai opsi cicilan
-- 2. Meskipun boleto transaksi tradisional khas brazil menjadi pilihan kedua yang kuat
-- 3. Kartu debit kurang diminati, penggunaan kartu debit sangat rendah, hal ini berkemungkinan
--    karena konsumen lebih memilih menahan uang tunai mereka atau tidak adanya opsi cicilan pada kartu debit

--REKOMENDASI
-- 1. Promo khusus kartu kredit (kerja sama bank)
-- 2. Optimalkan sistem pembayran boleto, memastikan konfirmsi pembayaran via boleto bisa berjalan lebih cepat (otomatis)
-- 3. Gencarkan penggunaan voucher untuk retention, memanfaatkan strategi voucher cashback untuk menarik konsumen melakukan pembelian kedua (repeat order)
--    untuk melihat penggunaan voucher yang sudah cukup aktif di platform


--=============--
-- CREATE VIEW --
--=============--

--===============================================================================
-- VIEW 1 : TOP 5 kategori produk yang menghasilkan omset terbesar (Best Selling)
--===============================================================================
CREATE OR REPLACE VIEW Top_5_Produk AS
SELECT 
    p.product_category_name AS kategori_produk,
    COUNT(i.product_id) AS total_barang_terjual,
    ROUND(SUM(i.price)) AS total_omset_pendapatan
FROM items i
JOIN clean_products p ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_omset_pendapatan desc
LIMIT 5;

--=========================================================
-- VIEW 2.1 : Tren pertumbuhan omset dan pesanan bulanan toko
--=========================================================
CREATE OR REPLACE VIEW tren_pesanan_bulan AS
SELECT 
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS bulan_transaksi,
    COUNT(DISTINCT o.order_id) AS total_pesanan_sukses,
    ROUND(SUM(i.price)) AS total_omset_bulanan
FROM clean_orders o
JOIN items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY bulan_transaksi
ORDER BY bulan_transaksi ASC;

--===========================================================
-- VIEW 2.2 : Tren pertumbuhan omset dan pesanan bulanan toko
--===========================================================
CREATE OR REPLACE VIEW total_omset_bulanan AS
SELECT 
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS bulan_transaksi,
    COUNT(DISTINCT o.order_id) AS total_pesanan_sukses,
    ROUND(SUM(i.price)) AS total_omset_bulanan
FROM clean_orders o
JOIN items i ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY bulan_transaksi
ORDER BY total_omset_bulanan DESC;

--=====================================================
-- VIEW 3 : Analisis 3 kategori produk utama tiap tahun
--=====================================================
CREATE OR REPLACE VIEW kategori_produk_utama AS
WITH omset_produk_per_tahun AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS tahun_transaksi,
        p.product_category_name AS kategori_produk,
        SUM(i.price) AS total_omset_kategori
    FROM clean_orders o
    JOIN items i ON o.order_id = i.order_id
    JOIN clean_products p ON i.product_id = p.product_id
    WHERE o.order_status = 'delivered' AND p.product_category_name IS NOT NULL
    GROUP BY tahun_transaksi, kategori_produk
),
ranking_produk_per_tahun AS (
    SELECT 
        tahun_transaksi,
        kategori_produk,
        ROUND(total_omset_kategori) AS total_omset,
        DENSE_RANK() OVER (
            PARTITION BY tahun_transaksi 
            ORDER BY total_omset_kategori DESC
        ) AS urutan_ranking
    FROM omset_produk_per_tahun
)
SELECT * FROM ranking_produk_per_tahun
WHERE urutan_ranking <= 3
ORDER BY tahun_transaksi ASC, urutan_ranking ASC;

--===============================================================
-- VIEW 4 : Jenis pembayaran yang paling sering digunakan pembeli
--===============================================================
CREATE OR REPLACE view jenis_pembayaran AS
SELECT 
    payment_type AS metode_pembayaran,
    COUNT(*) AS total_penggunaan,
    ROUND(SUM(payment_value)) AS total_perputaran_uang
FROM payments
GROUP BY payment_type
ORDER BY total_penggunaan DESC;