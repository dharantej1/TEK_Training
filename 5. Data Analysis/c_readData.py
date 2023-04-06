from sqlalchemy import Column, Integer, String
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

from a_base import MenuItem

if __name__=='__main__':
    engine = create_engine('sqlite:///restaurantmenu.db',echo=True)
    Session = sessionmaker(bind=engine)
    session=Session()
    result = session.query(MenuItem).all()
    result=result[:5]
    for row in result:
        print("Name: {}, Description: {}, Restaurant ID: {}".format(row.name, row.description, row.restaurant_id))