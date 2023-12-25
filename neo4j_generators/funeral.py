import random
import json
from datetime import datetime, timedelta, date
import uuid

PAYMENT_STATUSES = ["Paid", "Pending", "Overdue"]
PAYMENT_METHODS = ["Credit Card", "Bank Transfer", "Cash"]


def create_payment_node_query_helper(tx, payment_id, amount, payment_date, payment_status, payment_method, description):
    create_payment_node = """
      CREATE (:Payment {
            PaymentId: $payment_id,     
            Amount: $amount, 
            PaymentDate: $payment_date, 
            PaymentStatus: $payment_status, 
            PaymentMethod: $payment_method, 
            PaymentDescription: $description
        });
        """
    tx.run(create_payment_node,
           payment_id=payment_id,
           amount=amount,
           payment_date=payment_date,
           payment_status=payment_status,
           payment_method=payment_method,
           description=description)


def insert_payment(session):
    payment_id = str(uuid.uuid4())
    amount = round(random.uniform(100, 5000), 2)
    payment_date = date.today() - timedelta(days=random.randint(0, 30))
    payment_status = random.choice(PAYMENT_STATUSES)
    payment_method = random.choice(PAYMENT_METHODS)
    description = "Payment for subscription services."

    session.execute_write(create_payment_node_query_helper, payment_id,
                          amount,
                          payment_date,
                          payment_status,
                          payment_method,
                          description)
    print("Payment inserted")
    return payment_id


def insert_funerals(session):
    with open("resources/funeral_description.json", "r") as file:
        data = json.load(file)
        descriptions = data["descriptions"]

    deceased = session.read_transaction(fetch_all_deceased)
    chapels = session.read_transaction(fetch_all_chapels)

    chapels_ids = [row["ChapelId"] for row in chapels]

    for individual in deceased:
        if random.random() < 0.98:
            deceased_id = individual["DeceasedPESEL"]
            date_of_death = individual["DateOfDeath"]

            date_of_death_python = date(date_of_death.year, date_of_death.month, date_of_death.day)
            funeral_date = date_of_death_python + timedelta(days=random.randint(1, 365))

            chapel_id = random.choice(chapels_ids)
            payment_id = insert_payment(session)
            description = random.choice(descriptions)
            f_id = str(uuid.uuid4())
            query = """
            MATCH (p: Payment {PaymentId: $payment_id})
            MATCH (ch: Chapel {ChapelId: $chapel_id})
            MATCH (d: Deceased {DeceasedPESEL: $deceased_id})
            CREATE (fu:Funeral {
                FuneralId: $f_id,
                FuneralDate: $funeral_date, 
                FuneralDescription: $description
            })
            CREATE (fu)-[:USES]->(ch)
            CREATE (fu)-[:FOR]->(d)
            CREATE (fu)-[:PAID_BY]->(p)
            """

            session.execute_write(lambda tx: tx.run(query, payment_id=payment_id, chapel_id=chapel_id, deceased_id=deceased_id, f_id=f_id,
                                  funeral_date=funeral_date, description=description))
            print("Funeral inserted for deceased with pesel: " + str(deceased_id))


def fetch_all_deceased(tx):
    query = "MATCH(d:Deceased) RETURN d"
    result = tx.run(query)
    return [record["d"] for record in result]


def fetch_all_chapels(tx):
    query = "MATCH(ch:Chapel) RETURN ch"
    result = tx.run(query)
    return [record["ch"] for record in result]
