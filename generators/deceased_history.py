import json
from datetime import date, timedelta

from sqlalchemy import text
from sqlalchemy.orm import Session


def insert_deceased_history(session: Session):
    # Load histories from the JSON file
    with open("resources/history_descriptions.json", "r") as file:
        data = json.load(file)
        histories = data["histories"]

    # Get list of Deceased
    deceased_ids = session.execute(text("SELECT \"DeceasedId\" FROM \"Deceased\";")).fetchall()
    import random
    random.shuffle(deceased_ids)

    # Calculate 10% of the deceased count
    subset_count = int(0.10 * len(deceased_ids))

    # Insert a history for the subset of deceased
    for i in range(subset_count):
        deceased_id = deceased_ids[i][0]
        history_description = random.choice(histories)
        date_added = date.today() - timedelta(days=random.randint(0, 30))

        # Check if a history already exists for the deceased (because of the UNIQUE constraint)
        existing_history = session.execute(text(
            f"SELECT \"DeceasedHistoryId\" FROM \"DeceasedHistory\" WHERE \"FK_DeceasedId\" = {deceased_id};")).fetchone()

        if not existing_history:
            session.execute(
                text(
                    f"""INSERT INTO "DeceasedHistory" 
                    ("HistoryDescription", "DateAdded", "FK_DeceasedId")
                    VALUES (:desc, '{date_added}', {deceased_id});"""
                ),
                {'desc': history_description}
            )
            print(f"Inserted history for deceased: {deceased_id}")
