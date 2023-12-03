from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import declarative_base
from sqlalchemy.sql import text
from os import system
from tqdm import tqdm

DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/"
DATABASE_NAME = "tecza2"
FILES_PATH = "D:/Projekty/Studia/PBD"

def create_database():
    engine = create_engine(DATABASE_URL, isolation_level="AUTOCOMMIT")
    with engine.connect() as connection:
        connection.execute(text(f'CREATE DATABASE {DATABASE_NAME}'))

def execute_sql_file(file_path, session):
    # Execute SQL commands from a file
    with open(file_path, 'r') as file:
        session.execute(text(file.read()))
        session.commit()
                
def insert_grave_snapshots(session):
    # Get list of Deceased
    deceased_list = session.execute(text("SELECT \"DeceasedId\", \"DateOfDeath\", \"FK_GraveId\" FROM \"Deceased\";")).fetchall()
    # Get their Graves
    graves = session.execute(text("SELECT \"GraveId\", \"GraveType\", \"PaymentExpirationDate\" FROM \"Grave\" WHERE \"GraveStatus\" = 'OCCUPIED';")).fetchall()

    for deceasedId, deathDate, graveId in tqdm(deceased_list, desc="Creating GraveSnapshots..."):
        _, graveType, expirationDate = list(filter(lambda grave: grave[0] == graveId, graves))[0]
        
        session.execute(
            text(
                f"""INSERT INTO "GraveSnapshot" 
                ("GraveType", "OccupationStartDate", "PaymentExpirationDate", "FK_DeceasedId", "FK_GraveId")
                VALUES ('{graveType}', '{deathDate}', '{expirationDate}', '{deceasedId}', '{graveId}');"""
            )
        )
    session.commit()

if __name__ == "__main__":
    try:
        create_database()
        print(f"Database {DATABASE_NAME} created!")
    
        # Switch to the new database
        engine = create_engine(DATABASE_URL + DATABASE_NAME)
        Base = declarative_base()
        Session = sessionmaker(bind=engine)
        session = Session()

        # Execute schema scripts
        execute_sql_file(f'{FILES_PATH}/domain.sql', session)
        print(f"Domain created!")
        
        execute_sql_file(f'{FILES_PATH}/schema.sql', session)
        print(f"Schema created!")
        
        execute_sql_file(f'{FILES_PATH}/requirementsChange/script.sql', session)
        print(f"Requirement change added!")

        # Execute data script
        system(f"psql -U postgres {DATABASE_NAME} < \"{FILES_PATH}/requirementsChange/data.sql\"")
        
        # Insert grave snapshots
        insert_grave_snapshots(session)
        print("Database migration and import successful!")

    except Exception as e:
        print("Error:", e)
    
