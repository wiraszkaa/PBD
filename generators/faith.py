import json
from sqlalchemy.orm import Session
from sqlalchemy.sql import text


def insert_faiths(session: Session):
    with open('resources/faith.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
        faiths = data['faiths']

    for faith in faiths:
        name = faith['name']
        description = faith['description']
        number_of_believers = 0

        query = text("""
            INSERT INTO "Faith" ("FaithName", "FaithDescription", "NumberOfBelievers")
            VALUES (:name, :description, :number_of_believers);
        """)
        session.execute(query, {'name': name, 'description': description, 'number_of_believers': number_of_believers})
