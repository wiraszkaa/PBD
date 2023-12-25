import random
import uuid

from datetime import datetime


def generate_random_date():
    current_year = datetime.now().year
    year_range = list(range(current_year, 2061))
    random_year = random.choice(year_range)
    random_month = random.randint(1, 12)
    random_day = random.randint(1, 28)

    return datetime(random_year, random_month, random_day)


def insert_purchases(session):
    users = session.read_transaction(fetch_all_users)
    users_ids = [row["UserId"] for row in users]

    services = session.read_transaction(fetch_all_services)
    services_ids = [row["ServiceId"] for row in services]

    random.shuffle(users_ids)
    half_users = int(len(users_ids) * 0.5)
    thirty_percent_users = int(len(users_ids) * 0.3)

    for index, user_id in enumerate(users_ids):
        if index < half_users:
            service_id = random.choice(services_ids)
            purchase_id = str(uuid.uuid4())
            purchase_date = generate_random_date()
            create_purchase_node = """
                MATCH (s:Service {ServiceId: $service_id})
                MATCH (u:User {UserId: $user_id})
                CREATE (:Purchase {
                    PurchaseId: $purchase_id,
                    PurchaseDate: $purchase_date
                })
                CREATE (pu)-[:MADE_BY]->(u)
                CREATE (pu)-[:FOR]->(se)
            """
            session.execute_write(lambda tx: tx.run(create_purchase_node,
                                                    service_id=service_id,
                                                    user_id=user_id,
                                                    purchase_id=purchase_id,
                                                    purchase_date=purchase_date))
        elif index < half_users + thirty_percent_users:
            for _ in range(2):
                service_id = random.choice(services_ids)
                purchase_date = generate_random_date()
                purchase_id = str(uuid.uuid4())
                create_purchase_node = """
                               MATCH (s:Service {ServiceId: $service_id})
                               MATCH(u:User {UserId: $user_id})
                               CREATE (pu:Purchase {
                               PurchaseId: $purchase_id,
                               PurchaseDate: $purchase_date
                               })
                                CREATE (pu)-[:MADE_BY]->(u)
                                CREATE (pu)-[:FOR]->(se)
                           """
                session.execute_write(lambda tx: tx.run(create_purchase_node,
                                                        service_id=service_id,
                                                        user_id=user_id,
                                                        purchase_id=purchase_id,
                                                        purchase_date=purchase_date))
        else:
            for _ in range(random.randint(3, len(services_ids))):
                service_id = random.choice(services_ids)
                purchase_date = generate_random_date()
                purchase_id = str(uuid.uuid4())
                create_purchase_node = """
                                    MATCH (s:Service {ServiceId: $service_id})
                                    MATCH(u:User {UserId: $user_id})
                                    CREATE (pu:Purchase {
                                    PurchaseId: $purchase_id,
                                    PurchaseDate: $purchase_date
                                    })
                                     CREATE (pu)-[:MADE_BY]->(u)
                                     CREATE (pu)-[:FOR]->(se)
                                """
                session.execute_write(lambda tx: tx.run(create_purchase_node,
                                                        service_id=service_id,
                                                        user_id=user_id,
                                                        purchase_id=purchase_id,
                                                        purchase_date=purchase_date))
    print("Inserted Purchase!")


def fetch_all_users(tx):
    query = "MATCH (u:User) RETURN u"
    result = tx.run(query)
    return [record["u"] for record in result]


def fetch_all_services(tx):
    query = "MATCH (s:Service) RETURN s"
    result = tx.run(query)
    return [record["s"] for record in result]
