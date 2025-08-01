-- =====================================================
-- USER WATCHLIST TABLE CREATION
-- =====================================================

USE cargo_management;

-- Create user watchlist table
CREATE TABLE IF NOT EXISTS user_watchlist (
    watchlist_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    tracking_number VARCHAR(50) NOT NULL,
    cargo_number VARCHAR(50),
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes for better performance
    INDEX idx_username (username),
    INDEX idx_tracking_number (tracking_number),
    INDEX idx_cargo_number (cargo_number),
    
    -- Prevent duplicate entries for same user and tracking number
    UNIQUE KEY unique_user_tracking (username, tracking_number),
    
    -- Foreign key constraint (optional - only if you want to enforce user exists)
    FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE
);

-- Insert some sample data (optional)
-- INSERT INTO user_watchlist (username, tracking_number, cargo_number) VALUES 
-- ('testuser', 'CRG2024011700001', 'CRG001'),
-- ('testuser', 'CRG2024011700002', 'CRG002');
