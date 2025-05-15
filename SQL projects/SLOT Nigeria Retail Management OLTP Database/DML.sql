-- Insert data into categories
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Accessories', 'Various accessories for electronic devices'),
(3, 'Office Supplies', 'Supplies for office use');

-- Insert data into suppliers
INSERT INTO suppliers (supplier_id, supplier_name, contact_name, address, city, region, postal_code, country, phone, email) VALUES
(1, 'Tech Supplies Inc.', 'Mark Taylor', '101 Tech Ave', 'Lagos', 'Lagos', '100001', 'Nigeria', '08045678901', 'supply@tech.com'),
(2, 'Gadget World', 'Linda Green', '202 Gadget Rd', 'Abuja', 'Abuja', '100002', 'Nigeria', '08056789012', 'info@gadgetworld.com');

-- Insert data into products
INSERT INTO products (product_id, product_name, category_id, description, price, cost_price, supplier_id, reorder_level, last_restock_date) VALUES
(1, 'Laptop', 1, 'High performance laptop, 16GB RAM, 512GB SSD', 150000.00, 120000.00, 1, 5, '2024-01-01 08:00:00'),
(2, 'Smartphone', 1, 'Latest model smartphone, 8GB RAM, 128GB ROM', 80000.00, 60000.00, 2, 10, '2024-02-01 09:00:00'),
(3, 'Headphones', 2, 'Noise cancelling headphones', 20000.00, 15000.00, 1, 15, '2024-03-01 10:00:00'),
(4, 'Keyboard', 2, 'Mechanical keyboard', 15000.00, 10000.00, 2, 7, '2024-04-01 11:00:00'),
(5, 'Mouse', 2, 'Wireless mouse', 10000.00, 7000.00, 2, 8, '2024-05-01 12:00:00');

-- Insert data into customers
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address, state, date_of_birth, username, password_hash, salt) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '08012345678', '123 Main St', 'Lagos', '2005-01-01', 'johndoe', 'hashed_password1', 'salt1'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '08023456789', '456 Elm St', 'Abuja', '2000-01-01', 'janesmith', 'hashed_password2', 'salt2'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', '08034567890', '789 Oak St', 'Kano', '1995-01-01', 'alicej', 'hashed_password3', 'salt3');

-- Insert data into departments
INSERT INTO departments (department_id, department_name) VALUES
(1, 'Sales'),
(2, 'Inventory'),
(3, 'Accounting');

-- Insert data into employees
INSERT INTO employees (employee_id, first_name, last_name, department_id, position, hired_date) VALUES
(1, 'Michael', 'Brown', 1, 'Sales Manager', '2023-01-10'),
(2, 'Sarah', 'Wilson', 2, 'Inventory Specialist', '2023-02-15'),
(3, 'David', 'Davis', 3, 'Accountant', '2023-03-20');

-- Insert data into inventory
INSERT INTO inventory (inventory_id, product_id, quantity, location, employee_id) VALUES
(1, 1, 50, 'Warehouse A', 2),
(2, 2, 100, 'Warehouse B', 2),
(3, 3, 75, 'Store Shelf 1', 2),
(4, 4, 60, 'Store Shelf 2', 1),
(5, 5, 80, 'Store Shelf 3', 1);

-- Insert data into orders
INSERT INTO orders (order_id, customer_id, employee_id, order_date, order_status, order_address, quantity, total_amount, payment_method) VALUES
(1, 1, 1, '2024-04-01 10:00:00', 'completed', '123 Main St', 2, 300000.00, 'cash'),
(2, 2, 1, '2024-04-02 11:00:00', 'pending', '456 Elm St', 1, 80000.00, 'transfer');

-- Insert data into order_details
INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, unitprice, discount) VALUES
(1, 1, 1, 1, 150000.00, 0.00),
(2, 1, 2, 1, 80000.00, 0.00),
(3, 2, 2, 1, 80000.00, 0.05);

-- Insert data into payments
INSERT INTO payments (payment_id, order_id, amount, payment_method) VALUES
(1, 1, 300000.00, 'cash'),
(2, 2, 80000.00, 'transfer');

-- Insert data into reviews
INSERT INTO reviews (review_id, customer_id, product_id, order_detail_id, rating, comment) VALUES
(1, 1, 1, 1, 5, 'Excellent laptop!'),
(2, 2, 2, 2, 4, 'Great smartphone.');

-- Insert data into states
INSERT INTO states (state_id, state_name, country) VALUES
(1, 'Lagos', 'Nigeria'),
(2, 'Abuja', 'Nigeria'),
(3, 'Kano', 'Nigeria');

-- Insert data into region
INSERT INTO region (region_id, region_description) VALUES
(1, 'West'),
(2, 'Central'),
(3, 'North');

-- Insert data into shippers
INSERT INTO shippers (shipper_id, company_name, phone) VALUES
(1, 'FastShip Ltd', '08011112222'),
(2, 'QuickDelivery', '08022223333'),
(3, 'Reliable Shippers', '08033334444');