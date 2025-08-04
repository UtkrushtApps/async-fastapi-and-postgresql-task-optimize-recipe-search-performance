-- Basic inefficient schema: no foreign keys, missing indexes, minimal normalization
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    title TEXT,
    category_id INTEGER,
    instructions TEXT
    -- No constraint on category_id
);

CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    name TEXT -- should be unique
);

CREATE TABLE recipe_ingredients (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER,
    ingredient_id INTEGER
    -- No foreign keys or indexes
);
