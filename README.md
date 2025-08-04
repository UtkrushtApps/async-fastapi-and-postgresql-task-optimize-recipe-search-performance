# Task Overview

This project powers a basic async FastAPI service for managing recipes, their ingredients, and categories. The current system successfully stores and exposes recipes using a PostgreSQL backend, but users increasingly notice major delays when searching by ingredient (e.g., "show all recipes with garlic") or filtering by category (e.g., "dessert"). As the only backend engineer, your job is to analyze the schema and async database code to define proper relationships, add necessary keys and indexes, and optimize queries for fast, scalable discovery of recipes no matter how much data is added.

## Guidance

- The database schema is missing key relationships, constraints, and indexes, especially on frequently searched columns (ingredient name, category).
- There are inefficient SQL queries (including joins and filters) causing sequential scans that slow down app response.
- Async database interactions currently do not fully utilize efficient queries or optimal connection use.
- Focus on schema normalization, defining primary/foreign keys, correct data types, and ensuring queries use the best async patterns.
- Only modify database schemas and the async database integration logic—the API and routers are already set up.
- No need to set up FastAPI structure—the goal is practical database design and async query logic.

## Database Access

- Host: `<DROPLET_IP>`
- Port: 5432
- Database: recipesdb
- Username: recipesuser
- Password: recipespass
- You may use psql, pgAdmin, DBeaver, or any tool to examine schema and query plans

## Objectives

- Improve schema normalization: add/modify relationships, primary/foreign keys, constraints
- Add needed indexes (e.g., on ingredient name, category_id) to enable fast search/filter
- Optimize existing SQL for async access: avoid table scans, use proper JOIN patterns, minimize query latency
- Ensure all async DB interactions are efficient and non-blocking
- Confirm that searching/filtering for recipes by ingredient/category is significantly faster

## How to Verify

- Search/filter endpoints should return results nearly instantly, even with larger datasets
- Use EXPLAIN/ANALYZE to confirm that slow sequential scans have been replaced by efficient index scans
- API response time for searching or filtering by ingredient/category is vastly reduced
- Check database statistics and logs to confirm lower query execution times and improved patterns