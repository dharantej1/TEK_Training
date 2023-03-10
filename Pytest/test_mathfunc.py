from mathfunc import add, product

def test_add():
    assert add(9, 3) == 12
    assert add(11) == 14
    assert add(3) == 7
def test_product():
    assert product(9, 3) == 27
    assert product(11) == 44
    assert product(3) == 12