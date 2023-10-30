import random
from sqlalchemy.orm import Session
from sqlalchemy.sql import text
from datetime import datetime, timedelta

sector_ids = list(range(104, 154))

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


def insert_graves(session: Session, n_per_sector_range=[400, 600]):
    n_per_sector = random.choice(n_per_sector_range)
    for sector_id in sector_ids:
        for _ in range(n_per_sector):
            g_type = random.choice(grave_types)
            g_status = random.choice(grave_statuses)
            expiration_date = generate_random_date()

            session.execute(
                text(
                    f"INSERT INTO \"Grave\" (\"GraveType\", \"GraveStatus\", \"PaymentExpirationDate\", \"FK_SectorId\") VALUES ('{g_type}', '{g_status}', '{expiration_date}', {sector_id});"
                )
            )
