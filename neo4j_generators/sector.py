import json
import random
import uuid

with open('resources/sectors_names.json', 'r', encoding='utf-8') as file:
    sectors_names = json.load(file)["names"]

with open('resources/sectors_descriptions.json', 'r') as file:
    descriptions = json.load(file)["descriptions"]

with open('resources/faith.json', 'r') as file:
    faiths = json.load(file)["names"]


def insert_sectors(session, sector_range):
    for _ in sector_range:
        id = str(uuid.uuid4())
        name = random.choice(sectors_names)
        description = random.choice(descriptions)

        create_sector_node_query = """
            CREATE (:Sector {
            SectorId: $id,
            SectorName: $name, 
            SectorDescription: $description
            });
        """
        session.execute_write(
            lambda text: text.run(create_sector_node_query, id=id, name=name, description=description))
    print("---Inserted SECTORS to neo4j databse---")
