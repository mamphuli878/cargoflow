-- =====================================================
-- QUICK FIX: UPDATE EXISTING DATABASE
-- =====================================================
-- Run this script to fix the password issue

USE cargo_management;

-- Update existing user passwords to plain text
UPDATE users SET password = 'admin' WHERE username = 'admin';
UPDATE users SET password = 'manager' WHERE username = 'manager';
UPDATE users SET password = 'emp1' WHERE username = 'employee1';
UPDATE users SET password = 'cust1' WHERE username = 'customer1';

-- Verify the update
SELECT username, password, role FROM users;

-- Display message
SELECT 'Password fix applied! You can now login with admin/admin' as Message;
