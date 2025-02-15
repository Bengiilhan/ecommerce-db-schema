# E-Commerce Database Schema

A comprehensive relational database schema designed for an e-commerce platform, incorporating essential features such as user management, product catalog, order processing, and payment handling.

## Features
- **User Management**: Customers, Sellers, and Admin roles
- **Product Catalog**: Categories, brands, and detailed product information
- **Order Processing**: Order placement, tracking, and fulfillment
- **Payments**: Secure transaction handling
- **Inventory Management**: Stock levels and supplier relations
- **EER Diagram & Relational Model**: Visual representation of database structure

## Files Included
- **`trendzone.sql`** → Full MySQL database schema
- **`combineEer.drawio.pdf`** → EER Diagram
- **`relation.Model.pdf`** → Relational Model

## Technologies Used
- **Database:** MySQL
- **Schema Design:** MySQL Workbench, Draw.io

## Installation & Setup
### 1Clone the repository
```sh
git clone https://github.com/YOUR_GITHUB_USERNAME/ecommerce-db-schema.git
cd ecommerce-db-schema
```

### Import the Database Schema
Open your MySQL terminal or client and run:
```sql
source trendzone.sql;
```
This will create all necessary tables and relationships.

## Database Overview
The database follows a structured design to ensure scalability and efficiency:
- **Users Table:** Stores customer, seller, and admin information
- **Products Table:** Contains product details, categories, and stock levels
- **Orders Table:** Tracks customer purchases and order status
- **Payments Table:** Manages payment transactions securely
- **Reviews & Ratings:** Allows customers to leave feedback on products

## EER Diagram & Relational Model
For a visual representation of the database design:
- Open **`combineEer.drawio.pdf`** for the **EER Diagram**
- Open **`relation.Model.pdf`** for the **Relational Model**

## License
This project is open-source and available under the MIT License.


