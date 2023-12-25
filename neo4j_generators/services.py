import json
import random
import uuid


def insert_services(session):
    with open('resources/services.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
        services = data['services']

    for service in services:
        id = str(uuid.uuid4())
        name = service['name']
        description = service['description']
        price = round(random.uniform(50.0, 200.0), 2)
        create_service_node_query = """
        CREATE (:Service {
            ServiceId: $id,
            ServiceName: $name, 
            ServiceDescription: $description, 
            ServicePrice: $price
            });
        """
        session.execute_write(
            lambda tx: tx.run(create_service_node_query, id=id, name=name, description=description, price=price))

    print("Services inserted!")
