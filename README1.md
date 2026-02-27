# Journalism and News Publishing System Database

## Project Description
This project represents a relational database for a journalism and news publishing system implemented in PostgreSQL.

## Database Tables
- roles
- users
- categories
- articles
- comments
- tags
- article_tags
- likes
- views

## Relationships
- 1:M between roles and users
- 1:M between users and articles
- 1:M between categories and articles
- 1:M between articles and comments
- M:N between articles and tags
- M:N between users and articles (likes)

## Indexes
Indexes were created on:
- author_id
- category_id
- status
- email
- article_id

## Testing
The database was tested using:
- JOIN queries
- GROUP BY and HAVING
- Aggregate functions
- WHERE filtering
- EXPLAIN ANALYZE

## ER Diagram
See er_diagram.png
