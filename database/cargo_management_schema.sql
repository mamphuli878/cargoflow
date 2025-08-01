-- Create Database
CREATE DATABASE IF NOT EXISTS cargo_management;
USE cargo_management;

-- Drop tables if they exist (in correct order due to foreign key constraints)
DROP TABLE IF EXISTS cargo;
DROP TABLE IF EXISTS cargo_type;
DROP TABLE IF EXISTS users;

-- Create cargo_type table
CREATE TABLE cargo_type (
    cargo_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    rate_per_kg DECIMAL(10, 2) DEFAULT 0.00,
    category VARCHAR(50) DEFAULT 'General'
);

-- Create users table for authentication
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    role ENUM('admin', 'employee', 'customer') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create cargo table
CREATE TABLE cargo (
    cargo_id INT PRIMARY KEY AUTO_INCREMENT,
    cargo_number VARCHAR(50) NOT NULL UNIQUE,
    sender_name VARCHAR(100) NOT NULL,
    sender_address TEXT NOT NULL,
    sender_phone VARCHAR(15) NOT NULL,
    receiver_name VARCHAR(100) NOT NULL,
    receiver_address TEXT NOT NULL,
    receiver_phone VARCHAR(15) NOT NULL,
    description TEXT NOT NULL,
    weight DECIMAL(10, 2) NOT NULL,
    dimensions VARCHAR(100),
    cargo_type_id INT NOT NULL,
    status ENUM('Pending', 'In Transit', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    shipment_date DATE,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    shipping_cost DECIMAL(10, 2) NOT NULL,
    tracking_number VARCHAR(50) UNIQUE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cargo_type_id) REFERENCES cargo_type(cargo_type_id) ON DELETE RESTRICT
);

-- Insert default cargo types
INSERT INTO cargo_type (name, description, rate_per_kg, category) VALUES
('Electronics', 'Electronic items and gadgets', 15.00, 'Technology'),
('Furniture', 'Household and office furniture', 8.00, 'Household'),
('Clothing', 'Textiles and garments', 5.00, 'Fashion'),
('Food Items', 'Perishable and non-perishable food', 12.00, 'Food'),
('Documents', 'Important papers and documents', 20.00, 'Official'),
('Medical Equipment', 'Healthcare and medical devices', 25.00, 'Healthcare'),
('Automotive Parts', 'Vehicle parts and accessories', 10.00, 'Automotive'),
('Books', 'Educational and recreational books', 6.00, 'Education'),
('Fragile Items', 'Glass, ceramics, and breakable items', 18.00, 'Special'),
('General Cargo', 'Miscellaneous items', 7.00, 'General');

-- Insert default admin user (password: admin encrypted)
INSERT INTO users (username, password, first_name, last_name, email, phone, role) VALUES
('admin', 'YWRtaW4=', 'System', 'Administrator', 'admin@cargo.com', '9812345678', 'admin');

-- Insert sample cargo data
INSERT INTO cargo (
    cargo_number, sender_name, sender_address, sender_phone,
    receiver_name, receiver_address, receiver_phone, description,
    weight, dimensions, cargo_type_id, status, shipment_date,
    expected_delivery_date, shipping_cost, tracking_number, notes
) VALUES
('CRG001', 'John Doe', '123 Main St, Kathmandu', '9812345678',
 'Jane Smith', '456 Oak Ave, Pokhara', '9876543210', 'Laptop Computer',
 2.5, '40x30x5 cm', 1, 'In Transit', '2024-01-15',
 '2024-01-20', 150.00, 'CRG2024011500001', 'Handle with care'),

('CRG002', 'Ram Sharma', '789 Hill Road, Lalitpur', '9811111111',
 'Sita Poudel', '321 Valley St, Chitwan', '9822222222', 'Wooden Chair',
 15.0, '80x50x90 cm', 2, 'Pending', '2024-01-16',
 '2024-01-21', 120.00, 'CRG2024011600002', 'Fragile wooden furniture'),

('CRG003', 'Hari Bahadur', '555 Ring Road, Bhaktapur', '9833333333',
 'Gita Shrestha', '777 Park Lane, Biratnagar', '9844444444', 'Traditional Clothes',
 3.2, '50x40x20 cm', 3, 'Delivered', '2024-01-10',
 '2024-01-15', 80.00, 'CRG2024011000003', 'Traditional wear for wedding');

-- Create indexes for better performance
CREATE INDEX idx_cargo_tracking ON cargo(tracking_number);
CREATE INDEX idx_cargo_status ON cargo(status);
CREATE INDEX idx_cargo_shipment_date ON cargo(shipment_date);
CREATE INDEX idx_users_username ON users(username);

-- Display summary
SELECT 'Database Setup Complete!' as Message;
SELECT COUNT(*) as 'Cargo Types Created' FROM cargo_type;
SELECT COUNT(*) as 'Users Created' FROM users;
SELECT COUNT(*) as 'Sample Cargo Created' FROM cargo;
