import random
import json
from sqlalchemy.orm import Session
from sqlalchemy.sql import text
from datetime import timedelta, date

PAYMENT_STATUSES = ["PAID", "DUE", "LATE", "PENDING"]
PAYMENT_METHODS = ["CASH", "CREDIT", "TRANSFER", "ONLINE"]


def insert_payment(session: Session):
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


def insert_funerals(session: Session):
    with open("resources/funeral_description.json", "r") as file:
        data = json.load(file)
        descriptions = data["descriptions"]

    deceased = session.execute(text("SELECT \"DeceasedId\", \"DateOfDeath\" FROM \"Deceased\";")).fetchall()

    for individual in deceased:
        if random.random() < 0.98:
            deceased_id = individual[0]
            date_of_death = individual[1]

            funeral_date = date_of_death + timedelta(days=random.randint(1, 365))
            chapel_id = random.randint(433, 493)
            payment_id = insert_payment(session)
            description = random.choice(descriptions)

            session.execute(
                text(
                    f"""INSERT INTO "Funeral" 
                    ("FuneralDate", "FuneralDescription", "FK_ChapelId", "FK_DeceasedId", "FK_PaymentId")
                    VALUES ('{funeral_date}', :desc, {chapel_id}, {deceased_id}, {payment_id});"""
                ),
                {'desc': description}
            )
            print("Funeral inserted for deceased" + str(deceased_id))
