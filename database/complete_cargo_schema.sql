-- =====================================================
-- CARGO MANAGEMENT SYSTEM - COMPLETE DATABASE SCHEMA
-- =====================================================

-- Create Database
CREATE DATABASE IF NOT EXISTS cargo_management 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE cargo_management;

-- Drop existing tables if they exist (in correct order due to foreign key constraints)
DROP TABLE IF EXISTS user_tracking_watchlist;
DROP TABLE IF EXISTS cargo_status_history;
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS cargo_type;
DROP TABLE IF EXISTS users;

-- =====================================================
-- TABLE 1: USERS
-- =====================================================
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    role ENUM('admin', 'employee', 'customer') DEFAULT 'customer',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
);

-- =====================================================
-- TABLE 2: CARGO_TYPE
-- =====================================================
CREATE TABLE cargo_type (
    cargo_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    rate_per_kg DECIMAL(10, 2) DEFAULT 0.00,
    category VARCHAR(50) DEFAULT 'General',
    is_fragile BOOLEAN DEFAULT FALSE,
    requires_special_handling BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_category (category),
    INDEX idx_active (is_active)
);

-- =====================================================
-- TABLE 3: CARGO (Main table)
-- =====================================================
CREATE TABLE cargo (
    cargo_id INT PRIMARY KEY AUTO_INCREMENT,
    cargo_number VARCHAR(50) NOT NULL UNIQUE,
    
    -- Sender Information
    sender_name VARCHAR(100) NOT NULL,
    sender_address TEXT NOT NULL,
    sender_phone VARCHAR(15) NOT NULL,
    sender_email VARCHAR(100),
    sender_city VARCHAR(50),
    sender_state VARCHAR(50),
    sender_postal_code VARCHAR(10),
    
    -- Receiver Information
    receiver_name VARCHAR(100) NOT NULL,
    receiver_address TEXT NOT NULL,
    receiver_phone VARCHAR(15) NOT NULL,
    receiver_email VARCHAR(100),
    receiver_city VARCHAR(50),
    receiver_state VARCHAR(50),
    receiver_postal_code VARCHAR(10),
    
    -- Cargo Details
    description TEXT NOT NULL,
    weight DECIMAL(10, 3) NOT NULL,
    dimensions VARCHAR(100),
    declared_value DECIMAL(12, 2),
    cargo_type_id INT NOT NULL,
    
    -- Status and Dates
    status ENUM('Pending', 'Confirmed', 'Picked Up', 'In Transit', 'Out for Delivery', 'Delivered', 'Cancelled', 'Lost', 'Damaged') DEFAULT 'Pending',
    priority ENUM('Low', 'Normal', 'High', 'Urgent') DEFAULT 'Normal',
    shipment_date DATE,
    pickup_date DATE,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    
    -- Financial Information
    shipping_cost DECIMAL(10, 2) NOT NULL,
    insurance_cost DECIMAL(10, 2) DEFAULT 0.00,
    additional_charges DECIMAL(10, 2) DEFAULT 0.00,
    total_cost DECIMAL(10, 2) GENERATED ALWAYS AS (shipping_cost + insurance_cost + additional_charges) STORED,
    payment_status ENUM('Pending', 'Paid', 'Partial', 'Refunded') DEFAULT 'Pending',
    
    -- Tracking and Notes
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    barcode VARCHAR(100),
    qr_code VARCHAR(500),
    notes TEXT,
    special_instructions TEXT,
    
    -- System Fields
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    FOREIGN KEY (cargo_type_id) REFERENCES cargo_type(cargo_type_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (updated_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    
    -- Indexes for Performance
    INDEX idx_cargo_number (cargo_number),
    INDEX idx_tracking_number (tracking_number),
    INDEX idx_status (status),
    INDEX idx_shipment_date (shipment_date),
    INDEX idx_expected_delivery (expected_delivery_date),
    INDEX idx_sender_phone (sender_phone),
    INDEX idx_receiver_phone (receiver_phone),
    INDEX idx_cargo_type (cargo_type_id),
    INDEX idx_created_at (created_at),
    INDEX idx_composite_status_date (status, shipment_date)
);

-- =====================================================
-- TABLE 4: USER_TRACKING_WATCHLIST
-- =====================================================
CREATE TABLE user_tracking_watchlist (
    watchlist_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    tracking_number VARCHAR(50) NOT NULL,
    cargo_number VARCHAR(50),
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Indexes
    INDEX idx_username (username),
    INDEX idx_tracking_number (tracking_number),
    UNIQUE KEY unique_user_tracking (username, tracking_number)
);

-- =====================================================
-- TABLE 5: CARGO_STATUS_HISTORY (Optional - for tracking status changes)
-- =====================================================
CREATE TABLE cargo_status_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    cargo_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    remarks TEXT,
    changed_by INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (cargo_id) REFERENCES cargo(cargo_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    
    INDEX idx_cargo_id (cargo_id),
    INDEX idx_changed_at (changed_at)
);

-- =====================================================
-- INSERT SAMPLE DATA
-- =====================================================

-- Insert Cargo Types
INSERT INTO cargo_type (name, description, rate_per_kg, category, is_fragile, requires_special_handling) VALUES
('Electronics', 'Electronic items, gadgets, computers, and accessories', 15.00, 'Technology', TRUE, TRUE),
('Furniture', 'Household and office furniture, chairs, tables, cabinets', 8.00, 'Household', FALSE, TRUE),
('Clothing', 'Textiles, garments, shoes, and fashion accessories', 5.00, 'Fashion', FALSE, FALSE),
('Food Items', 'Perishable and non-perishable food products', 12.00, 'Food', FALSE, TRUE),
('Documents', 'Important papers, certificates, legal documents', 20.00, 'Official', FALSE, TRUE),
('Medical Equipment', 'Healthcare devices, medicines, medical supplies', 25.00, 'Healthcare', TRUE, TRUE),
('Automotive Parts', 'Vehicle parts, accessories, and automotive supplies', 10.00, 'Automotive', FALSE, FALSE),
('Books', 'Educational materials, books, magazines, publications', 6.00, 'Education', FALSE, FALSE),
('Fragile Items', 'Glass, ceramics, artwork, and other breakable items', 18.00, 'Special', TRUE, TRUE),
('General Cargo', 'Miscellaneous items and general merchandise', 7.00, 'General', FALSE, FALSE),
('Jewelry', 'Precious metals, gems, watches, and valuable accessories', 50.00, 'Luxury', TRUE, TRUE),
('Sports Equipment', 'Athletic gear, exercise equipment, sporting goods', 9.00, 'Sports', FALSE, FALSE),
('Chemicals', 'Industrial chemicals, cleaning supplies, hazardous materials', 30.00, 'Industrial', FALSE, TRUE),
('Art & Antiques', 'Paintings, sculptures, antique items, collectibles', 35.00, 'Art', TRUE, TRUE),
('Textiles', 'Fabrics, carpets, curtains, and textile materials', 8.00, 'Textile', FALSE, FALSE);

-- Insert Users (with AES-GCM encrypted passwords)
INSERT INTO users (username, password, first_name, last_name, email, phone, role) VALUES
('admin', 'admin', 'System', 'Administrator', 'admin@cargo.com', '9812345678', 'admin'),
('manager', 'manager', 'John', 'Manager', 'manager@cargo.com', '9876543210', 'employee'),
('employee1', 'emp1', 'Sarah', 'Johnson', 'sarah@cargo.com', '9811111111', 'employee'),
('customer1', 'cust1', 'Mike', 'Wilson', 'mike@email.com', '9822222222', 'customer');

-- Insert Sample Cargo
INSERT INTO cargo (
    cargo_number, sender_name, sender_address, sender_phone, sender_email, sender_city, sender_state, sender_postal_code,
    receiver_name, receiver_address, receiver_phone, receiver_email, receiver_city, receiver_state, receiver_postal_code,
    description, weight, dimensions, declared_value, cargo_type_id, status, priority,
    shipment_date, pickup_date, expected_delivery_date, shipping_cost, insurance_cost, tracking_number, notes, created_by
) VALUES
-- Cargo 1: Electronics
('CRG001', 'John Doe Electronics', '123 Main Street, Tech Plaza', '9812345678', 'john@techstore.com', 'Kathmandu', 'Bagmati', '44600',
 'Jane Smith', '456 Oak Avenue, Residential Area', '9876543210', 'jane@email.com', 'Pokhara', 'Gandaki', '33700',
 'Dell Laptop Computer with accessories and warranty documents', 2.500, '40x30x5 cm', 75000.00, 1, 'In Transit', 'High',
 '2024-01-15', '2024-01-15', '2024-01-20', 150.00, 75.00, 'CRG2024011500001', 'Handle with extreme care - fragile electronics', 1),

-- Cargo 2: Furniture
('CRG002', 'Ram Furniture House', '789 Hill Road, Furniture District', '9811111111', 'ram@furniture.com', 'Lalitpur', 'Bagmati', '44700',
 'Sita Poudel', '321 Valley Street, New Town', '9822222222', 'sita@email.com', 'Chitwan', 'Bagmati', '44200',
 'Handcrafted wooden dining chair with traditional design', 15.000, '80x50x90 cm', 12000.00, 2, 'Pending', 'Normal',
 '2024-01-16', NULL, '2024-01-21', 120.00, 12.00, 'CRG2024011600002', 'Traditional wooden furniture - protect from moisture', 2),

-- Cargo 3: Clothing
('CRG003', 'Hari Fashion Store', '555 Ring Road, Fashion Hub', '9833333333', 'hari@fashion.com', 'Bhaktapur', 'Bagmati', '44800',
 'Gita Shrestha', '777 Park Lane, City Center', '9844444444', 'gita@email.com', 'Biratnagar', 'Province 1', '56613',
 'Traditional wedding dress with accessories and jewelry box', 3.200, '50x40x20 cm', 25000.00, 3, 'Delivered', 'High',
 '2024-01-10', '2024-01-10', '2024-01-15', 80.00, 25.00, 'CRG2024011000003', 'Special occasion wear - handle with care', 1),

-- Cargo 4: Medical Equipment
('CRG004', 'MediCare Supplies', '100 Hospital Road, Medical District', '9855555555', 'orders@medicare.com', 'Kathmandu', 'Bagmati', '44600',
 'Dr. Binod Clinic', '200 Health Street, Medical Complex', '9866666666', 'dr.binod@clinic.com', 'Dharan', 'Province 1', '56700',
 'Digital Blood Pressure Monitor and Medical Supplies', 1.800, '25x20x15 cm', 8500.00, 6, 'Out for Delivery', 'Urgent',
 '2024-01-17', '2024-01-17', '2024-01-19', 200.00, 85.00, 'CRG2024011700004', 'Medical equipment - temperature sensitive', 3),

-- Cargo 5: Documents
('CRG005', 'Legal Associates', '300 Court Road, Legal District', '9877777777', 'legal@associates.com', 'Kathmandu', 'Bagmati', '44600',
 'Government Office', '400 Admin Street, Government Complex', '9888888888', 'admin@gov.np', 'Janakpur', 'Madhesh', '45600',
 'Important legal documents and certificates in sealed envelope', 0.500, '35x25x2 cm', 5000.00, 5, 'Confirmed', 'Urgent',
 '2024-01-18', NULL, '2024-01-20', 100.00, 50.00, 'CRG2024011800005', 'Confidential documents - signature required on delivery', 2);

-- Insert Status History for Tracking
INSERT INTO cargo_status_history (cargo_id, old_status, new_status, location, remarks, changed_by) VALUES
(1, 'Pending', 'Confirmed', 'Kathmandu Depot', 'Cargo received and confirmed', 1),
(1, 'Confirmed', 'Picked Up', 'Kathmandu Depot', 'Picked up by delivery vehicle', 2),
(1, 'Picked Up', 'In Transit', 'Highway Checkpoint', 'In transit to destination', 2),
(3, 'Pending', 'Confirmed', 'Bhaktapur Branch', 'Payment received, cargo confirmed', 1),
(3, 'Confirmed', 'Picked Up', 'Bhaktapur Branch', 'Picked up for delivery', 3),
(3, 'Picked Up', 'In Transit', 'Hetauda Transit', 'Moving towards destination', 3),
(3, 'In Transit', 'Out for Delivery', 'Biratnagar Depot', 'Out for final delivery', 3),
(3, 'Out for Delivery', 'Delivered', 'Customer Location', 'Successfully delivered to customer', 3);

-- =====================================================
-- USEFUL VIEWS FOR REPORTING
-- =====================================================

-- View for Cargo Summary
CREATE VIEW cargo_summary AS
SELECT 
    c.cargo_id,
    c.cargo_number,
    c.tracking_number,
    c.sender_name,
    c.receiver_name,
    ct.name AS cargo_type,
    c.status,
    c.weight,
    c.total_cost,
    c.shipment_date,
    c.expected_delivery_date,
    c.created_at
FROM cargo c
JOIN cargo_type ct ON c.cargo_type_id = ct.cargo_type_id
ORDER BY c.created_at DESC;

-- View for Pending Deliveries
CREATE VIEW pending_deliveries AS
SELECT 
    c.cargo_id,
    c.cargo_number,
    c.tracking_number,
    c.sender_name,
    c.receiver_name,
    c.receiver_phone,
    c.status,
    c.expected_delivery_date,
    DATEDIFF(c.expected_delivery_date, CURDATE()) AS days_to_delivery
FROM cargo c
WHERE c.status IN ('Pending', 'Confirmed', 'Picked Up', 'In Transit', 'Out for Delivery')
ORDER BY c.expected_delivery_date ASC;

-- View for Revenue Summary
CREATE VIEW revenue_summary AS
SELECT 
    DATE(c.created_at) AS date,
    COUNT(*) AS total_shipments,
    SUM(c.total_cost) AS total_revenue,
    AVG(c.total_cost) AS average_cost,
    SUM(CASE WHEN c.status = 'Delivered' THEN c.total_cost ELSE 0 END) AS delivered_revenue
FROM cargo c
GROUP BY DATE(c.created_at)
ORDER BY date DESC;

-- =====================================================
-- STORED PROCEDURES (Optional)
-- =====================================================

DELIMITER //

-- Procedure to update cargo status
CREATE PROCEDURE UpdateCargoStatus(
    IN p_cargo_id INT,
    IN p_new_status VARCHAR(50),
    IN p_location VARCHAR(100),
    IN p_remarks TEXT,
    IN p_changed_by INT
)
BEGIN
    DECLARE v_old_status VARCHAR(50);
    
    -- Get current status
    SELECT status INTO v_old_status FROM cargo WHERE cargo_id = p_cargo_id;
    
    -- Update cargo status
    UPDATE cargo 
    SET status = p_new_status, updated_by = p_changed_by 
    WHERE cargo_id = p_cargo_id;
    
    -- Insert into history
    INSERT INTO cargo_status_history (cargo_id, old_status, new_status, location, remarks, changed_by)
    VALUES (p_cargo_id, v_old_status, p_new_status, p_location, p_remarks, p_changed_by);
END //

-- Function to generate tracking number
CREATE FUNCTION GenerateTrackingNumber() 
RETURNS VARCHAR(50)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_tracking VARCHAR(50);
    DECLARE v_count INT DEFAULT 0;
    
    -- Generate tracking number based on current timestamp
    SET v_tracking = CONCAT('CRG', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(FLOOR(RAND() * 10000), 4, '0'));
    
    -- Check if tracking number already exists
    SELECT COUNT(*) INTO v_count FROM cargo WHERE tracking_number = v_tracking;
    
    -- If exists, add random suffix
    WHILE v_count > 0 DO
        SET v_tracking = CONCAT(v_tracking, LPAD(FLOOR(RAND() * 100), 2, '0'));
        SELECT COUNT(*) INTO v_count FROM cargo WHERE tracking_number = v_tracking;
    END WHILE;
    
    RETURN v_tracking;
END //

DELIMITER ;

-- =====================================================
-- INDEXES FOR OPTIMIZATION
-- =====================================================

-- Additional composite indexes for common queries
CREATE INDEX idx_cargo_status_date ON cargo(status, shipment_date);
CREATE INDEX idx_cargo_sender_receiver ON cargo(sender_name, receiver_name);
CREATE INDEX idx_cargo_cost_range ON cargo(total_cost);
CREATE INDEX idx_cargo_weight_range ON cargo(weight);

-- Full-text search indexes for descriptions
ALTER TABLE cargo ADD FULLTEXT(description, notes);
ALTER TABLE cargo_type ADD FULLTEXT(name, description);

-- =====================================================
-- DISPLAY SETUP SUMMARY
-- =====================================================

SELECT 'Database Setup Complete!' as Message;
SELECT COUNT(*) as 'Cargo Types Created' FROM cargo_type;
SELECT COUNT(*) as 'Users Created' FROM users;
SELECT COUNT(*) as 'Sample Cargo Created' FROM cargo;
SELECT COUNT(*) as 'Status History Records' FROM cargo_status_history;

-- Show table sizes
SELECT 
    table_name AS 'Table Name',
    table_rows AS 'Row Count',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.tables 
WHERE table_schema = 'cargo_management'
ORDER BY (data_length + index_length) DESC;
