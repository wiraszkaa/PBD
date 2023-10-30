import random
from datetime import date, timedelta
from sqlalchemy import text

PAYMENT_STATUSES = ["Paid", "Pending", "Overdue"]
PAYMENT_METHODS = ["Credit Card", "Bank Transfer", "Cash"]


def insert_payment(session):
    amount = round(random.uniform(100, 5000), 2)
    payment_date = date.today() - timedelta(days=random.randint(0, 30))
    payment_status = random.choice(PAYMENT_STATUSES)
    payment_method = random.choice(PAYMENT_METHODS)
    description = "Payment for subscription services."

    result = session.execute(
        text(
            f"""INSERT INTO "Payment" 
            ("Amount", "PaymentDate", "PaymentStatus", "PaymentMethod", "PaymentDescription")
            VALUES ({amount}, '{payment_date}', '{payment_status}', '{payment_method}', :desc)
            RETURNING "PaymentId";"""
        ),
        {'desc': description}
    )
    print("Payment inserted")
    return result.fetchone()[0]


def insert_subscription(session):
    graves = [item[0] for item in session.execute(text("SELECT \"GraveId\" FROM \"Grave\";")).fetchall()]
    services = [item[0] for item in session.execute(text("SELECT \"ServiceId\" FROM \"Service\";")).fetchall()]

    selected_graves = random.sample(graves, int(0.3 * len(graves)))

    for grave_id in selected_graves:
        service_id = random.choice(services)
        service_start_time = date.today() + timedelta(days=random.randint(1, 365))
        service_end_time = service_start_time + timedelta(days=random.randint(1, 365))
        payment_id = insert_payment(session)

        session.execute(text(
            f"""INSERT INTO "Subscription" 
            ("ServiceStartTime", "ServiceEndTime", "FK_GraveId", "FK_ServiceId", "FK_PaymentId")
            VALUES ('{service_start_time}', '{service_end_time}', {grave_id}, {service_id}, {payment_id});"""
        ))
        print(f"Subscription inserted for grave {grave_id} with service {service_id}")

