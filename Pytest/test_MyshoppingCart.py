from jedi.plugins import pytest

from myshoppingcart import MyShoppingCart


def test_add_to_cart():
    cart = MyShoppingCart()
    cart.add_to_cart("Nike Air-force1")
    # debugging the code in python using assert
    assert cart.size() == 1


def test_when_item_added_then_cart_contains_item():
    cart = MyShoppingCart()
    cart.add_to_cart("Nike Air-force1")
    # test if product is in cart.get_items()
    assert "Adidas Superstar" in cart.get_items()


def test_when_add_more_than_max_items_should_fail():
    cart = MyShoppingCart(5)
    with pytest.raises(OverflowError):
        for _ in range(7):
            cart.add_to_cart("Nike Air-force1")
