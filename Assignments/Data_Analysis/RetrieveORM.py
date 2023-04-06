from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from CreateORM import Company,Employee, Base, engine

Base.metadata.bind = engine
DBSession = sessionmaker(bind=engine)
session = DBSession()

companies = session.query(Company).all()
for company in companies:
    print("Company Name: {}".format(company.name))
    for employee in company.employees:
        print("Employee Name: {}".format(employee.name))

session.close()