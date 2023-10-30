import random
from sqlalchemy.orm import Session
from sqlalchemy.sql import text
from datetime import date, timedelta

# List of common Polish names and surnames
polish_first_names = [
    "Anna", "Maria", "Katarzyna", "Małgorzata", "Agnieszka",
    "Jan", "Andrzej", "Paweł", "Krzysztof", "Tomasz"
]

polish_last_names = [
    "Nowak", "Kupiec", "Panko", "Kowal", "Szechnik",
    "Wójcik", "Bielan", "Kowalczyk", "Madej", "Litwin"
]

names = [
    "Katolicka", "Protestancka", "Buddyzm", "Islam",
    "Judaizm", "Hinduizm", "Taoizm", "Sikhizm", "Szamanizm"
]

causes_of_death = [
    "Natural causes", "Accident", "Disease", "Unknown"
]

def generate_pesel():
    return ''.join(random.choice('0123456789') for _ in range(11))

def insert_deceased_for_grave(session: Session, grave_id: int, grave_type: str):
    num_deceased = {
        "SINGLE": 1,
        "URN": 1,
        "FIELD": 1,
        "FAMILY": random.randint(2, 6),
        "MULTIPLE": random.randint(2, 4),
        "Catacombs": random.randint(30, 80),
        "CRYPT": random.randint(15, 35)
    }.get(grave_type, 1)

    for _ in range(num_deceased):
        first_name = random.choice(polish_first_names)
        last_name = random.choice(polish_last_names)
        dob = date.today() - timedelta(days=random.randint(365, 365*100))  # Between 1 and 100 years ago
        dod = dob + timedelta(days=random.randint(1, (date.today() - dob).days))  # Any day after dob
        faith = random.choice(names)
        cause = random.choice(causes_of_death)
        pesel = generate_pesel()

        session.execute(
            text(
                f"""INSERT INTO "Deceased" 
                ("DeceasedFirstName", "DeceasedLastName", "DateOfDeath", "DateOfBirth", "CauseOfDeath", "DeceasedPESEL", "FK_GraveId", "FK_FaithName") 
                VALUES ('{first_name}', '{last_name}', '{dod}', '{dob}', '{cause}', '{pesel}', {grave_id}, '{faith}');"""
            )
        )

def insert_deceased(session: Session):
    occupied_graves = session.execute(text("SELECT \"GraveId\", \"GraveType\" FROM \"Grave\" WHERE \"GraveStatus\" = 'OCCUPIED';")).fetchall()

    for grave in occupied_graves:
        grave_id = grave[0]
        grave_type = grave[1]
        insert_deceased_for_grave(session, grave_id, grave_type)
