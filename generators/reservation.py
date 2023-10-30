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
    description = "Payment for funeral services."

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


def insert_reservation(session):
    reserved_graves = session.execute(
        text("SELECT \"GraveId\" FROM \"Grave\" WHERE \"GraveStatus\" = 'RESERVED';")).fetchall()
    users = session.execute(text("SELECT \"UserId\" FROM \"User\";")).fetchall()

    for grave in reserved_graves:
        user_id = random.choice(users)[0]
        reservation_date = date.today() + timedelta(days=random.randint(1, 365))
        expiration_date = reservation_date + timedelta(days=30)
        description = "Reservation for a grave."
        payment_id = insert_payment(session)

        session.execute(text(
            f"""INSERT INTO "Reservation" 
            ("ReservationDescription", "ReservationDate", "ReservationExpirationDate", "ReservationStatus", "FK_UserId", "FK_GraveId", "FK_PaymentId")
            VALUES (:desc, '{reservation_date}', '{expiration_date}', 'Active', {user_id}, {grave[0]}, {payment_id});"""),
            {'desc': description}
        )
        print(f"Reservation inserted for grave {grave[0]}")

