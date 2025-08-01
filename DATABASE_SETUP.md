# Database Setup Guide for Eclipse

## Quick Setup Steps

### 1. **Database Creation**
```sql
-- Run this first to create the database
CREATE DATABASE cargo_management;
USE cargo_management;
```

### 2. **Execute Main Schema**
- Import and run: `database/complete_cargo_schema.sql`
- This will create all tables, sample data, views, and stored procedures

### 3. **Database Configuration in Eclipse**
Update your `DbConfig.java` with these settings:
```java
private static final String URL = "jdbc:mysql://localhost:3306/cargo_management";
private static final String USERNAME = "root";  // Your MySQL username
private static final String PASSWORD = "";      // Your MySQL password
```

### 4. **Default Login Credentials**
After database setup, you can login with:
- **Username:** `admin`
- **Password:** `admin`
- **Username:** `manager`  
- **Password:** `manager`

## Database Structure Overview

### **Core Tables:**

1. **users** - User authentication and roles
   - Stores admin, employee, and customer accounts
   - Password encryption support

2. **cargo_type** - Cargo categories and pricing
   - 15 predefined cargo types (Electronics, Furniture, etc.)
   - Rate per kg and special handling flags

3. **cargo** - Main cargo shipment records
   - Comprehensive sender/receiver information
   - Status tracking (Pending → Delivered)
   - Financial calculations and tracking numbers

4. **cargo_status_history** - Status change tracking
   - Audit trail for all status changes
   - Location and timestamp tracking

### **Key Features:**
- ✅ Auto-generated tracking numbers
- ✅ Status workflow management
- ✅ Cost calculations (shipping + insurance + extras)
- ✅ Full address management
- ✅ Search and filtering capabilities
- ✅ Report generation views
- ✅ Data integrity with foreign keys

### **Sample Data Included:**
- 4 users (1 admin, 2 employees, 1 customer)
- 15 cargo types with different rates
- 5 sample cargo shipments
- Status history for tracking demo

## Running in Eclipse

1. **Import Project:** File → Import → Existing Projects
2. **Configure Server:** Add Tomcat server in Eclipse
3. **Deploy:** Right-click project → Run As → Run on Server
4. **Access:** http://localhost:8080/cargoo

The system is ready to use immediately after database setup!
