import random
from datetime import date, timedelta

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
    "Natural causes", "Accident", "Disease", "Unknown", "Kopniak od Pudziana"
]


def generate_pesel():
    return ''.join(random.choice('0123456789') for _ in range(11))


def insert_deceased_for_grave(session, grave_id: int, grave_type: str):
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
        dob = date.today() - timedelta(days=random.randint(365, 365 * 100))  # Between 1 and 100 years ago
        dod = dob + timedelta(days=random.randint(1, (date.today() - dob).days))  # Any day after dob
        faith_name = random.choice(names)
        cause = random.choice(causes_of_death)
        pesel = generate_pesel()
        deceased_query = """
            MATCH (f:Faith {FaithName: $faith_name})
            MATCH (g:Grave {GraveId: $grave_id})
            
            CREATE (d:Deceased {
                DeceasedPESEL: $pesel,
                DeceasedFirstName: $first_name,
                DeceasedLastName: $last_name, 
                DateOfDeath: $dob, 
                DateOfBirth: $dod, 
                CauseOfDeath: $cause
            })
            CREATE (d)-[:BURIED_IN]->(g)
            CREATE (d)-[:BELIEVES_IN]->(f)
        """

        session.execute_write(lambda tx: tx.run(deceased_query, faith_name=faith_name,
                                                grave_id=grave_id,
                                                pesel=pesel,
                                                first_name=first_name,
                                                last_name=last_name,
                                                dob=dob,
                                                dod=dod,
                                                cause=cause))


def insert_deceased(session):
    occupied_graves = session.execute_read(fetch_occupied_graves)
    for grave in occupied_graves:
        grave_id = grave["GraveId"]
        grave_type = grave["GraveType"]
        insert_deceased_for_grave(session, grave_id, grave_type)
        print("Inserted new deceased for grave")


def fetch_occupied_graves(tx):
    query = "MATCH (g:Grave) WHERE g.GraveStatus = 'OCCUPIED' RETURN g"
    result = tx.run(query)
    return [record["g"] for record in result]
