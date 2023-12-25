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


def insert_subscription(session):
    graves = session.read_transaction(fetch_graves)
    services = session.read_transaction(fetch_services)
    selected_graves = random.sample(graves, int(0.3 * len(graves)))

    for grave in selected_graves:
        subs_id = str(uuid.uuid4())
        service_id = random.choice(services)
        service_start_time = date.today() + timedelta(days=random.randint(1, 365))
        service_end_time = service_start_time + timedelta(days=random.randint(1, 365))
        payment_id = insert_payment(session)

        create_subscription_and_relationship_query = """
        MATCH (p:Payment {PaymentId: $payment_id})
        CREATE (s:Subscription {
            SubscriptionId: $subs_id,
            ServiceStartTime: $service_start_time, 
            ServiceEndTime: $service_end_time
        })
        CREATE (s)-[:PAID_FOR]->(p)
        """

        session.execute_write(
            lambda tx: tx.run(create_subscription_and_relationship_query, subs_id=subs_id,
                              service_start_time=service_start_time, service_end_time=service_end_time,
                              payment_id=payment_id))

        print(f"Subscription inserted for grave {grave} with service {service_id}")


def fetch_graves(tx):
    query = "MATCH (g:Grave) RETURN g"
    result = tx.run(query)
    return [record["g"] for record in result]


def fetch_services(tx):
    query = "MATCH (s:Service) RETURN s"
    result = tx.run(query)
    return [record["s"] for record in result]
