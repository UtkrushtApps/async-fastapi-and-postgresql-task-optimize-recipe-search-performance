from pydantic import BaseModel
from typing import List

class Recipe(BaseModel):
    id: int
    title: str
    category_id: int
    instructions: str

class RecipeCreate(BaseModel):
    title: str
    category_id: int
    instructions: str
    ingredient_ids: List[int]

class Ingredient(BaseModel):
    id: int
    name: str

class RecipeListResponse(BaseModel):
    recipes: List[Recipe]
