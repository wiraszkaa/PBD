import json
import random
from sqlalchemy.orm import Session
from sqlalchemy.sql import text


with open('resources/sectors_names.json', 'r', encoding='utf-8') as file:
    sectors_names = json.load(file)["names"]

with open('resources/sectors_descriptions.json', 'r') as file:
    descriptions = json.load(file)["descriptions"]

with open('resources/faith.json', 'r') as file:
    faiths = json.load(file)["names"]


def insert_sectors(session: Session, n=50):
    for _ in range(n):
        name = random.choice(sectors_names)
        description = random.choice(descriptions)

        if random.choice([True, False]):
            faith_name = random.choice(faiths)
            session.execute(
                text(
                    f"INSERT INTO \"Sector\" (\"SectorName\", \"SectorDescription\", \"FK_FaithName\") VALUES ('{name}', '{description}', '{faith_name}');"))
        else:
            session.execute(
                text(
                    f"INSERT INTO \"Sector\" (\"SectorName\", \"SectorDescription\") VALUES ('{name}', '{description}');"))

