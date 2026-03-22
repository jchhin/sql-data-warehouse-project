# Gold Layer Data Catalog

## Overview
The Gold layer contains the final business-ready data model used for reporting, analytics, and decision-making. It is organized into **dimension tables** and **fact tables** so the data is easier to query, understand, and use in downstream analysis.

This layer is designed to support common business questions around customers, products, and sales performance.

---

## 1. `gold.dim_customers`

**Purpose:**  
Stores customer-level information enriched with demographic and geographic attributes for reporting and analysis. :contentReference[oaicite:1]{index=1}

| Column Name     | Data Type    | Description |
|----------------|--------------|-------------|
| customer_key   | INT          | Surrogate key that uniquely identifies each row in the customer dimension. |
| customer_id    | INT          | Unique numeric identifier assigned to the customer. |
| customer_number| NVARCHAR(50) | Alphanumeric customer reference used for tracking and lookup purposes. |
| first_name     | NVARCHAR(50) | Customer’s first name as stored in the source data. |
| last_name      | NVARCHAR(50) | Customer’s last name or family name. |
| country        | NVARCHAR(50) | Country associated with the customer, such as Australia. |
| marital_status | NVARCHAR(50) | Customer marital status, such as Married or Single. |
| gender         | NVARCHAR(50) | Standardized gender value, such as Male, Female, or n/a. |
| birthdate      | DATE         | Customer date of birth in `YYYY-MM-DD` format. |
| create_date    | DATE         | Date the customer record was originally created in the source system. |

---

## 2. `gold.dim_products`

**Purpose:**  
Contains product-level descriptive attributes used to analyze catalog structure, product groupings, and performance by category or line. :contentReference[oaicite:2]{index=2}

| Column Name          | Data Type    | Description |
|---------------------|--------------|-------------|
| product_key         | INT          | Surrogate key that uniquely identifies each row in the product dimension. |
| product_id          | INT          | Unique identifier assigned to the product for internal reference. |
| product_number      | NVARCHAR(50) | Structured alphanumeric code used to identify the product. |
| product_name        | NVARCHAR(50) | Descriptive product name, often including type, color, or size details. |
| category_id         | NVARCHAR(50) | Identifier representing the product’s broader category grouping. |
| category            | NVARCHAR(50) | High-level product grouping, such as Bikes or Components. |
| subcategory         | NVARCHAR(50) | More detailed classification within the broader category. |
| maintenance_required| NVARCHAR(50) | Indicates whether the product requires maintenance, such as Yes or No. |
| cost                | INT          | Base cost of the product in whole currency units. |
| product_line        | NVARCHAR(50) | Product line classification, such as Road or Mountain. |
| start_date          | DATE         | Date the product became active or available for sale. |

---

## 3. `gold.fact_sales`

**Purpose:**  
Stores transactional sales records used for performance reporting, trend analysis, and business metric calculations. :contentReference[oaicite:3]{index=3}

| Column Name   | Data Type    | Description |
|--------------|--------------|-------------|
| order_number | NVARCHAR(50) | Unique alphanumeric identifier for each sales order, such as `SO54496`. |
| product_key  | INT          | Surrogate key linking the sale to the related product dimension record. |
| customer_key | INT          | Surrogate key linking the sale to the related customer dimension record. |
| order_date   | DATE         | Date the order was placed. |
| shipping_date| DATE         | Date the order was shipped. |
| due_date     | DATE         | Date payment for the order was due. |
| sales_amount | INT          | Total value of the sales line item in whole currency units. |
| quantity     | INT          | Number of product units included in the sales line item. |
| price        | INT          | Unit price for the product in the sales line item. |

---

## Notes
- **Dimension tables** provide descriptive business context.
- **Fact tables** store measurable business events.
- This structure supports easier reporting across customer, product, and sales-related questions. :contentReference[oaicite:4]{index=4}
