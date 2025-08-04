from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List, Optional
from app.schemas.schemas import Recipe, RecipeCreate, Ingredient, RecipeListResponse
from app.database import get_db
import asyncpg

router = APIRouter()

@router.get("/recipes", response_model=RecipeListResponse)
async def list_recipes(
    ingredient: Optional[str] = Query(None),
    category_id: Optional[int] = Query(None),
    db=Depends(get_db)
):
    # Inefficient query: No proper joins/indexes, might use sequential scans
    if ingredient:
        rows = await db.fetch(
            """
            SELECT r.id, r.title, r.category_id, r.instructions
            FROM recipes r
            JOIN recipe_ingredients ri ON r.id = ri.recipe_id
            JOIN ingredients i ON ri.ingredient_id = i.id
            WHERE i.name = $1
            ORDER BY r.title
            """, ingredient
        )
    elif category_id:
        rows = await db.fetch(
            """
            SELECT id, title, category_id, instructions FROM recipes WHERE category_id = $1 ORDER BY title
            """, category_id
        )
    else:
        rows = await db.fetch(
            "SELECT id, title, category_id, instructions FROM recipes ORDER BY title")
    recipes = [Recipe(id=row['id'], title=row['title'], category_id=row['category_id'], instructions=row['instructions']) for row in rows]
    return RecipeListResponse(recipes=recipes)

@router.post("/recipes", response_model=Recipe)
async def add_recipe(recipe: RecipeCreate, db=Depends(get_db)):
    # Async insert with minimal checks and asyncpg usage
    rec_id = await db.fetchval(
        "INSERT INTO recipes (title, category_id, instructions) VALUES ($1, $2, $3) RETURNING id",
        recipe.title, recipe.category_id, recipe.instructions)
    for ing in recipe.ingredient_ids:
        await db.execute("INSERT INTO recipe_ingredients (recipe_id, ingredient_id) VALUES ($1, $2)", rec_id, ing)
    return Recipe(id=rec_id, title=recipe.title, category_id=recipe.category_id, instructions=recipe.instructions)

@router.get("/ingredients", response_model=List[Ingredient])
async def list_ingredients(db=Depends(get_db)):
    rows = await db.fetch("SELECT id, name FROM ingredients ORDER BY name")
    return [Ingredient(id=row['id'], name=row['name']) for row in rows]
