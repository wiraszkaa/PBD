import random
from datetime import date, timedelta
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


def insert_reservation(session):
    reserved_graves = session.read_transaction(fetch_reserved_graves)
    users = session.read_transaction(fetch_all_users)

    for grave in reserved_graves:
        user = random.choice(users)
        reservation_id = str(uuid.uuid4())
        reservation_date = date.today() + timedelta(days=random.randint(1, 365))
        expiration_date = reservation_date + timedelta(days=30)
        payment_id = insert_payment(session)
        create_reservation = """
        MATCH (p:Payment {PaymentId: $payment_id})
        MATCH (g:Grave {GraveId: $grave_id})
        MATCH (u:User {UserEmail: $user_email})

        CREATE (r:Reservation {
            ReservationId: $reservation_id,
            ReservationDescription: "Grave reservation", 
            ReservationDate: $reservation_date, 
            ReservationExpirationDate: $expiration_date, 
            ReservationStatus: "Active"
        })

        CREATE (r)-[:PAID_BY]->(p)
        CREATE (r)-[:MADE_BY]->(u)
        CREATE (r)-[:RESERVES]->(g)
        """

        session.execute_write(lambda tx: tx.run(create_reservation,
                                                payment_id=payment_id,
                                                grave_id=grave["GraveId"],
                                                user_email=user["UserEmail"],
                                                reservation_id=reservation_id,
                                                reservation_date=reservation_date,
                                                expiration_date=expiration_date))

        print(f"Reservation inserted for grave {grave}")


def fetch_reserved_graves(tx):
    query = "MATCH (g:Grave) WHERE g.GraveStatus = 'RESERVED' RETURN g"
    result = tx.run(query)
    return [record["g"] for record in result]


def fetch_all_users(tx):
    query = "MATCH (u:User) RETURN u"
    result = tx.run(query)
    return [record["u"] for record in result]
