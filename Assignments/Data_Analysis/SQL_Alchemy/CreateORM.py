from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship

engine = create_engine('sqlite:///companyEmployeeSQL.db', echo=True)
Base = declarative_base()

class Company(Base):
    __tablename__ = 'companies'

    id = Column(Integer, primary_key=True)
    name = Column(String)
    employees = relationship("Employee", back_populates="company")

class Employee(Base):
    __tablename__ = 'employees'
    
    id = Column(Integer, primary_key=True)
    name = Column(String)
    company_id = Column(Integer, ForeignKey('companies.id'))
    company = relationship("Company", back_populates="employees")

Base.metadata.create_all(bind=engine)