import random
from sqlalchemy import text


def insert_purchases(session):
    services_ids = session.execute(text("SELECT \"ServiceId\" FROM \"Service\";")).fetchall()
    services_ids = [row[0] for row in services_ids]

    users_ids = session.execute(text("SELECT \"UserId\" FROM \"User\";")).fetchall()
    users_ids = [row[0] for row in users_ids]

    random.shuffle(users_ids)
    half_users = int(len(users_ids) * 0.5)
    thirty_percent_users = int(len(users_ids) * 0.3)

    for index, user_id in enumerate(users_ids):
        if index < half_users:
            service_id = random.choice(services_ids)
            session.execute(text(f"INSERT INTO \"Purchase\" (\"FK_ServiceId\", \"FK_UserId\") VALUES ({service_id}, {user_id});"))
        elif index < half_users + thirty_percent_users:
            for _ in range(2):
                service_id = random.choice(services_ids)
                session.execute(text(f"INSERT INTO \"Purchase\" (\"FK_ServiceId\", \"FK_UserId\") VALUES ({service_id}, {user_id});"))
        else:
            for _ in range(random.randint(3, len(services_ids))):
                service_id = random.choice(services_ids)
                session.execute(text(f"INSERT INTO \"Purchase\" (\"FK_ServiceId\", \"FK_UserId\") VALUES ({service_id}, {user_id});"))
