import random
from datetime import datetime, timedelta
import uuid

grave_types = ["FAMILY", "SINGLE", "MULTIPLE", "URN", "FIELD", "Catacombs", "CRYPT"]

grave_statuses = [
    "RESERVED" for _ in range(20)] + [
        "EMPTY" for _ in range(15)] + [
            "OCCUPIED" for _ in range(60)] + [
                "UNKNOWN" for _ in range(5)
            ]


def generate_random_date():
    current_year = datetime.now().year
    year_range = list(range(current_year, 2061))
    random_year = random.choice(year_range)
    random_month = random.randint(1, 12)
    random_day = random.randint(1, 28)

    return datetime(random_year, random_month, random_day)


def insert_graves(session, sector_range, n_per_sector_range=[1, 100]):
    n_per_sector = random.choice(n_per_sector_range)
    for _ in sector_range:
        for _ in range(n_per_sector):
            id = str(uuid.uuid4())
            g_type = random.choice(grave_types)
            g_status = random.choice(grave_statuses)
            expiration_date = generate_random_date()
            
            create_grave_node_query = """
            CREATE (:Grave {
            GraveId: $id,
            GraveType: $g_type, 
            GraveStatus: $g_status, 
            PaymentExpirationDate: $expiration_date
            });
            """
            session.execute_write(lambda tx: tx.run(create_grave_node_query,
                                                    id=id,
                                                    g_type=g_type,
                                                    g_status=g_status,
                                                    expiration_date=expiration_date))
    
            print(f"Graves inserted for id: {id}!")
            