# Shopping Cart
# Step 1. Create a project file myshoppingcart.py

from typing import List


class MyShoppingCart:
    def __init___(self) -> None:
        self.items: List[str] = []

    def add_to_cart(self, item: str):
        self.items.append(item)

    def size(self) -> int:
        return len(self.items)

    def get_items(self) -> List[str]:
        return self.items

    def get_total_price(self, price_map):
        pass
