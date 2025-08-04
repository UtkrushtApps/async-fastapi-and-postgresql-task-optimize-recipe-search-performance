-- Sample categories
INSERT INTO categories (name) VALUES
('Dessert'), ('Main'), ('Soup'), ('Salad'), ('Snack');

-- Sample ingredients
INSERT INTO ingredients (name) VALUES
('sugar'),('flour'),('egg'),('milk'),('chicken'),('oil'),('lettuce'),('tomato'),('cheese'),('garlic');

-- Sample recipes and associations
DO $$
DECLARE r_id INTEGER;
BEGIN
  -- Recipe 1: Chocolate Cake (Dessert)
  INSERT INTO recipes (title, category_id, instructions) VALUES ('Chocolate Cake', 1, 'Mix and bake.');
  SELECT currval('recipes_id_seq') INTO r_id;
  INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (r_id, 1), (r_id, 2), (r_id, 3), (r_id, 4);

  -- Recipe 2: Chicken Salad (Salad)
  INSERT INTO recipes (title, category_id, instructions) VALUES ('Chicken Salad', 4, 'Toss and mix.');
  SELECT currval('recipes_id_seq') INTO r_id;
  INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (r_id, 5), (r_id, 7), (r_id, 8), (r_id, 10);

  -- Recipe 3: Omelette (Main)
  INSERT INTO recipes (title, category_id, instructions) VALUES ('Omelette', 2, 'Beat and fry.');
  SELECT currval('recipes_id_seq') INTO r_id;
  INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES (r_id, 3), (r_id, 4), (r_id, 9);

  -- Add more recipes for data volume
  FOR i IN 1..40 LOOP
    INSERT INTO recipes (title, category_id, instructions) VALUES ('Recipe '||i, ((i % 5)+1), 'Do step '||i);
    SELECT currval('recipes_id_seq') INTO r_id;
    INSERT INTO recipe_ingredients (recipe_id, ingredient_id)
      SELECT r_id, ((random()*9)::integer)+1 FROM generate_series(1, 3);
  END LOOP;
END $$;
