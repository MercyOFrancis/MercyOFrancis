-- Data definition language for SLOT nigeria
-- Database schema (3NF Normalized )

CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- globally unique identity numbers database generated

-- stores customer information
CREATE TABLE customers (
   customer_id SERIAL PRIMARY KEY,
   first_name VARCHAR(100) NOT NULL,
   last_name VARCHAR(100) NOT NULL,
   email VARCHAR(255) UNIQUE NOT NULL,
   phone VARCHAR(20) NOT NULL,
   address TEXT NOT NULL,
   state VARCHAR(20),
   date_of_birth DATE CHECK (date_of_birth <= CURRENT_DATE - INTERVAL '15 Years'), --below 15 years of age can't order
   username VARCHAR(20) UNIQUE NOT NULL,
   password_hash TEXT NOT NULL, --with bcrypt algorithm to secure passwords converts a plaintext password into a string of random characters
   salt TEXT NOT NULL, --concatenating the salt with the password before passing it through the hashing algorithm.
   reg_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
   is_active BOOLEAN DEFAULT TRUE
);

-- stores product categories
CREATE TABLE categories (
     category_id SERIAL PRIMARY KEY,
	 category_name VARCHAR(100) UNIQUE NOT NULL,
	 description TEXT NOT NULL
);

-- stores supplier information
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) UNIQUE NOT NULL,
    contact_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
	city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(20),
    email VARCHAR(100),
	homepage TEXT,
    reliability_rating DECIMAL(3,2) DEFAULT 5.0,
    last_delivery_date DATE
);

-- stores product information
CREATE TABLE products (
	 product_id SERIAL PRIMARY KEY,
     product_name VARCHAR(255) UNIQUE NOT NULL,
	 category_id INT NOT NULL,
	 description TEXT NOT NULL,
	 price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
	 cost_price DECIMAL(10,2) NOT NULL CHECK (cost_price >= 0),
	 supplier_id INT NOT NULL,
     reorder_level INT DEFAULT 10 CHECK (reorder_level >= 0),
     last_restock_date TIMESTAMP WITH TIME ZONE NOT NULL,
	 FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL -- if the supplier data its deleted it'll keep the product id info
);

-- department information for employees
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50)  UNIQUE NOT NULL,
    created_date DATE DEFAULT CURRENT_DATE
);

-- stores employee information
CREATE TABLE employees (
     employee_id SERIAL PRIMARY KEY,
     first_name VARCHAR(50) NOT NULL,
	 last_name VARCHAR(50) NOT NULL,
	 department_id INT NOT NULL,
	 position VARCHAR(50),
	 hired_date DATE NOT NULL,
	 is_active BOOLEAN DEFAULT TRUE,
	 FOREIGN KEY (department_id) REFERENCES departments(department_id),
	 UNIQUE(first_name, last_name)
);

-- stores inventory information for each product at each location
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    location VARCHAR(255),  -- e.g., warehouse, store shelf, etc.
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	employee_id INT NOT NULL,
    UNIQUE (product_id, location), -- A product should only be in one location at a time
    FOREIGN KEY (product_id) REFERENCES products(product_id),
   FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
	
-- stores order information
CREATE TABLE orders (
     order_id SERIAL PRIMARY KEY,
	 customer_id INT NOT NULL,
	 employee_id INT NOT NULL,
	 order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP CHECK (order_date <= CURRENT_TIMESTAMP),
	 order_status VARCHAR(50) DEFAULT 'pending' CHECK (order_status IN ('pending', 'completed', 'refund')),
	 order_address TEXT NOT NULL,
	 quantity INT NOT NULL, 
	 total_amount DECIMAL(12, 2) NOT NULL CHECK (total_amount > 0), -- checks to make sure theres no negative price
	 payment_method VARCHAR(50) CHECK (payment_method IN('cash', 'transfer')),
	 tracking_number UUID DEFAULT uuid_generate_v4(),
	 FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	 FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- junction table for orders and products, stores details of each product in an order
CREATE TABLE order_details ( 
     order_detail_id SERIAL PRIMARY KEY,
	 order_id INT NOT NULL,
	 product_id INT NOT NULL,
	 quantity INT NOT NULL, 
     unitprice DECIMAL(10, 2) NOT NULL CHECK (unitprice >= 0), -- current price at the time of order
	 discount DECIMAL(4,2) DEFAULT 0 CHECK (discount >= 0 and discount <= 1), -- discount percentage 0 to 1
	 subtotal DECIMAL(12,2) GENERATED ALWAYS AS (quantity * unitprice * (1 - discount)) STORED,
	 UNIQUE(order_id, product_id), -- prevents duplicate orderid for same product
	 FOREIGN KEY (order_id) REFERENCES orders(order_id),
	 FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- stores payment information
CREATE TABLE payments (
     payment_id SERIAL PRIMARY KEY,
	 order_id INT UNIQUE NOT NULL,
	 payment_date  TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
     amount DECIMAL(10,2) CHECK (amount > 0),
     payment_method VARCHAR(50) CHECK(payment_method IN ('cash', 'transfer')),
	 FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- stores customer reviews for products
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
	order_detail_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATE DEFAULT CURRENT_DATE,
	CONSTRAINT fk_reviews_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_reviews_product FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT fk_reviews_order_detail FOREIGN KEY (order_detail_id) REFERENCES order_details(order_detail_id),
	CONSTRAINT uc_customer_order_product UNIQUE(customer_id, order_detail_id)
);

-- stores state information
CREATE TABLE states(
    state_id SERIAL PRIMARY KEY,
    state_name VARCHAR(50) UNIQUE NOT NULL,
    country VARCHAR(15) NOT NULL
);

-- stores region information
CREATE TABLE region (
    region_id SMALLINT PRIMARY KEY,
    region_description VARCHAR(60) NOT NULL
);

-- companies or entities that handle the delivery of orders to customers
CREATE TABLE shippers (
    shipper_id SERIAL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    phone VARCHAR(20)
);

-- to get product availability
CREATE VIEW product_availability AS
SELECT
    p.product_id,
    p.product_name,
    p.description,
    p.price,
    COALESCE(SUM(i.quantity), 0) AS available_quantity
FROM
    products p
LEFT JOIN
    inventory i ON p.product_id = i.product_id
GROUP BY
    p.product_id, p.product_name, p.description, p.price;

/* this trigger setup ensures that whenever a new item is added to an order in the order_details table, the update_inventory_after_order() function is automatically called to reduce the corresponding product's quantity in the inventory table, while also checking for sufficient stock and preventing overselling.*/
-- automatically update inventory quantity after an order detail is inserted
CREATE OR REPLACE FUNCTION update_inventory_after_order()
RETURNS TRIGGER AS $$
BEGIN
  -- reduce inventory quantity by the ordered amount
  UPDATE inventory
  SET quantity = quantity - NEW.quantity,
      last_updated = CURRENT_TIMESTAMP
  WHERE product_id = NEW.product_id AND quantity >= NEW.quantity;

  -- raise error if inventory is insufficient
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Insufficient inventory for product %', NEW.product_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- this ensures inventory is automatically decremented when an order detail is added, preventing overselling and enforcing stock control at the database level
CREATE TRIGGER trg_update_inventory
AFTER INSERT ON order_details
FOR EACH ROW
EXECUTE FUNCTION update_inventory_after_order();

-- ensure payment amount equals the order’s total to prevent mismatches.
CREATE OR REPLACE FUNCTION trg_validate_payment_amount()
RETURNS TRIGGER AS $$
DECLARE
  order_total DECIMAL(12,2);
BEGIN
  SELECT total_amount INTO order_total FROM orders WHERE order_id = NEW.order_id;

  IF NEW.amount <> order_total THEN
    RAISE EXCEPTION 'Payment amount % does not match order total %', NEW.amount, order_total;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- to enforce payment amount validation runs trigger before inserting new row or updating in the payments table
CREATE TRIGGER trg_check_payment_amount
BEFORE INSERT OR UPDATE ON payments
FOR EACH ROW
EXECUTE FUNCTION trg_validate_payment_amount();

-- data control language
-- Create roles
CREATE ROLE sales_staff;
GRANT SELECT, INSERT ON orders, order_details TO sales_staff;

CREATE ROLE inventory_manager;
GRANT SELECT, UPDATE ON inventory, products TO inventory_manager;

CREATE ROLE accounting_staff;
GRANT SELECT ON payments TO accounting_staff;

REVOKE SELECT ON customers FROM PUBLIC;

-- Revoke access from specific roles
REVOKE SELECT ON customers FROM sales_staff, inventory_manager;

-- Create a view for limited customer access
CREATE VIEW customers_for_staff AS
SELECT
  customer_id,
  first_name,
  last_name,
  email,
  phone,
  address,
  state,
  reg_date,
  is_active
FROM customers;

GRANT SELECT ON customers_for_staff TO sales_staff;


-- Index creation section
CREATE INDEX idx_customers_name ON customers(first_name, last_name);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_supplier_id ON products(supplier_id);
CREATE INDEX idx_products_name ON products(product_name);
CREATE INDEX idx_inventory_product_location ON inventory(product_id, location);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_suppliers_name ON suppliers(supplier_name);