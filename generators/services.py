import json
import random

from sqlalchemy import text
from sqlalchemy.orm import Session


def insert_services(session: Session):
    with open('resources/services.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
        services = data['services']

    for service in services:
        name = service['name']
        description = service['description']
        price = round(random.uniform(50.0, 200.0), 2)
        session.execute(text(f"INSERT INTO \"Service\" (\"ServiceName\", \"ServiceDescription\", \"ServicePrice\") VALUES ('{name}', '{description}', {price});"))


