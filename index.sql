-- ==========================================
-- ระบบห้องสมุดออนไลน์
-- DDL สำหรับสร้างตารางใน PostgreSQL
-- ==========================================


-- ==========================================
-- 1. ตาราง MEMBER
-- ใช้เก็บข้อมูลสมาชิกของระบบ
-- ==========================================
CREATE TABLE MEMBER (
    member_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20)
);


-- ==========================================
-- 2. ตาราง AUTHOR
-- ใช้เก็บข้อมูลผู้แต่งหนังสือ
-- ==========================================
CREATE TABLE AUTHOR (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);


-- ==========================================
-- 3. ตาราง CATEGORY
-- ใช้เก็บหมวดหมู่ของหนังสือ
-- ==========================================
CREATE TABLE CATEGORY (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);


-- ==========================================
-- 4. ตาราง BOOK
-- ใช้เก็บข้อมูลหนังสือ
-- เชื่อมกับผู้แต่งและหมวดหมู่
-- ==========================================
CREATE TABLE BOOK (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,

    -- เชื่อมกับตาราง AUTHOR
    author_id INT NOT NULL,
    FOREIGN KEY (author_id)
        REFERENCES AUTHOR(author_id),

    -- เชื่อมกับตาราง CATEGORY
    category_id INT NOT NULL,
    FOREIGN KEY (category_id)
        REFERENCES CATEGORY(category_id),

    -- ปีที่หนังสือถูกตีพิมพ์
    published_year INT
);


-- ==========================================
-- 5. ตาราง BORROW
-- ใช้เก็บข้อมูลการยืมและคืนหนังสือ
-- ==========================================
CREATE TABLE BORROW (
    borrow_id SERIAL PRIMARY KEY,

    -- สมาชิกที่ยืมหนังสือ
    member_id INT NOT NULL,
    FOREIGN KEY (member_id)
        REFERENCES MEMBER(member_id),

    -- หนังสือที่ถูกยืม
    book_id INT NOT NULL,
    FOREIGN KEY (book_id)
        REFERENCES BOOK(book_id),

    -- วันที่ยืม
    borrow_date DATE NOT NULL,

    -- วันที่ต้องคืน
    due_date DATE NOT NULL,

    -- วันที่คืนจริง
    -- ถ้ายังไม่คืนจะเป็น NULL
    return_date DATE
);


-- ==========================================
-- 6. ตาราง ROOM
-- ใช้เก็บข้อมูลห้องสำหรับจอง
-- ==========================================
CREATE TABLE ROOM (
    room_id SERIAL PRIMARY KEY,

    -- ชื่อห้อง
    room_name VARCHAR(100) NOT NULL,

    -- จำนวนคนที่รองรับได้
    capacity INT NOT NULL
);


-- ==========================================
-- 7. ตาราง RESERVATION
-- ใช้เก็บข้อมูลการจองห้อง
-- ==========================================
CREATE TABLE RESERVATION (
    reservation_id SERIAL PRIMARY KEY,

    -- สมาชิกที่จองห้อง
    member_id INT NOT NULL,
    FOREIGN KEY (member_id)
        REFERENCES MEMBER(member_id),

    -- ห้องที่ถูกจอง
    room_id INT NOT NULL,
    FOREIGN KEY (room_id)
        REFERENCES ROOM(room_id),

    -- วันที่จอง
    reservation_date DATE NOT NULL,

    -- เวลาเริ่มจอง
    start_time TIME NOT NULL,

    -- เวลาสิ้นสุดการจอง
    end_time TIME NOT NULL
);


-- ==========================================
-- 8. ตาราง NOTIFICATION
-- ใช้เก็บการแจ้งเตือนสมาชิก
-- เช่น แจ้งเตือนวันคืนหนังสือ
-- ==========================================
CREATE TABLE NOTIFICATION (
    notification_id SERIAL PRIMARY KEY,

    -- สมาชิกที่จะได้รับการแจ้งเตือน
    member_id INT NOT NULL,
    FOREIGN KEY (member_id)
        REFERENCES MEMBER(member_id),

    -- ข้อความแจ้งเตือน
    message TEXT NOT NULL,

    -- วันที่และเวลาที่สร้างแจ้งเตือน
    notification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- สถานะการอ่าน
    -- FALSE = ยังไม่อ่าน
    -- TRUE = อ่านแล้ว
    is_read BOOLEAN DEFAULT FALSE
);