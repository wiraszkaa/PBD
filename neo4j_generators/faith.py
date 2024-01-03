import json
import uuid


def insert_faiths(session):
    with open('resources/faith.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
        faiths = data['faiths']

    for faith in faiths:
        id = str(uuid.uuid4())
        name = faith['name']
        description = faith['description']

        create_faith_node_query = """
            CREATE (:Faith {
                FaithId: $id,
                FaithName: $name,
                FaithDescription: $description
            })
        """

        session.execute_write(lambda text: text.run(create_faith_node_query, id=id, name=name, description=description))
    print("Inserted Faiths to neo4j databse")
