# -*- coding: utf-8 -*-
"""
Created on Fri Mar 10 17:53:55 2023

@author: vgajjala
"""

from MyshoppingCart import MyShoppingCart

def test_add_to_cart():
    cart = MyShoppingCart()
    cart.add_to_cart("Nike Airforce1")
    assert cart.size() == 1