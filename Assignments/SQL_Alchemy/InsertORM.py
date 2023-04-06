from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from CreateORM import Company, Employee, Base, engine

Base.metadata.bind = engine
DBSession = sessionmaker(bind=engine)
session = DBSession()

# Creating a new company
company = Company(name="TekSystems Global Services")

employee1 = Employee(name="Pusthakala Dharan Tej")
employee2 = Employee(name="Yatendra Kumar")
company.employees.append(employee1)
company.employees.append(employee2)

session.add(company)
session.commit()
session.close()