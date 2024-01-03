import json
from datetime import date, timedelta
import random
import uuid


def insert_deceased_history(session):
    with open("resources/history_descriptions.json", "r") as file:
        data = json.load(file)
        histories = data["histories"]

    all_decease = session.execute_read(fetch_all_deceased)
    deceased_ids = [row["DeceasedPESEL"] for row in all_decease]

    random.shuffle(deceased_ids)
    subset_count = int(0.10 * len(deceased_ids))

    for i in range(subset_count):
        history_id = str(uuid.uuid4())

        deceased_pesel = deceased_ids[i]
        history_description = random.choice(histories)
        date_added = date.today() - timedelta(days=random.randint(0, 30))
        existing_history = session.execute_read(fetch_existing_history, deceased_pesel)
        if not existing_history:
            query = """
    MATCH (d:Deceased {DeceasedPESEL: $deceased_pesel})
    CREATE (dh:DeceasedHistory {
        DeceasedHistoryId: $history_id,
        HistoryDescription: $history_description, 
        DateAdded: $date_added
    })
    CREATE (dh)-[:HISTORY_OF]->(d)
    """

            session.execute_write(lambda tx: tx.run(query, deceased_pesel=deceased_pesel,
                                                    history_id=history_id,
                                                    history_description=history_description,
                                                    date_added=date_added))
            print(f"Inserted history for deceased of pesel: {deceased_pesel}")


def fetch_all_deceased(tx):
    query = "MATCH (d:Deceased) RETURN d"
    result = tx.run(query)
    return [record["d"] for record in result]


def fetch_existing_history(tx, d_id):
    query = """
        MATCH (d:Deceased {DeceasedPESEL: $d})-[r:HISTORY_OF]->(h:DeceasedHistory)
        RETURN r
    """
    result = tx.run(query, d=d_id)
    return [record["r"] for record in result]
