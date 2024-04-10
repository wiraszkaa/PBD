import json
import random
import uuid
from neo4j.exceptions import ConstraintError

with open('resources/sectors_names.json', 'r', encoding='utf-8') as file:
    sectors_names = json.load(file)["names"]

with open('resources/sectors_descriptions.json', 'r') as file:
    descriptions = json.load(file)["descriptions"]

with open('resources/faith.json', 'r') as file:
    faiths = json.load(file)["names"]


def insert_sectors(session):
    faiths = session.read_transaction(fetch_all_faiths)
    gates = session.read_transaction(fetch_all_gates)
    monuments = session.read_transaction(fetch_all_monuments)
    graves = session.read_transaction(fetch_all_graves)
    cameras = session.read_transaction(fetch_all_cameras)
    chapels = session.read_transaction(fetch_all_chapels)

    faith_names = [row["FaithName"] for row in faiths]
    monuments_ids = [row["MonumentId"] for row in monuments]
    graves_ids = [row["GraveId"] for row in graves]
    gates_id = [row["GateId"] for row in gates]
    cameras_id = [row["CameraId"] for row in cameras]
    chapels_id = [row["ChapelId"] for row in chapels]

    for name in sectors_names:
        id_s = str(uuid.uuid4())
        description = random.choice(descriptions)
        f_name = random.choice(faith_names)
        m_id = random.choice(monuments_ids)
        g_id = random.choice(graves_ids)
        ga_id = random.choice(gates_id)
        c_id = random.choice(cameras_id)
        chapel_id = random.choice(chapels_id)

        create_sector_node_query = """
            MATCH(f:Faith {FaithName: $f_name})
            MATCH(m: Monument {MonumentId: $m_id})
            MATCH(ga: Gate {GateId: $ga_id})
            MATCH(c: Camera {CameraId: $c_id})
            MATCH(g: Grave {GraveId: $g_id})
            MATCH(ch: Chapel {ChapelId: $chapel_id})
            
            CREATE (s:Sector {
            SectorId: $id_s,
            SectorName: $name, 
            SectorDescription: $description
            })
            
        CREATE(s)-[:HAS_FAITH]->(f)
        CREATE(m)-[:LOCATED_IN]->(s)
        CREATE(ga)-[:LOCATED_IN]->(s)
        CREATE(c)-[:LOCATED_IN]->(s)
        CREATE(g)-[:LOCATED_IN]->(s)
        CREATE(ch)-[:LOCATED_IN]->(s)
        """
        try:
            session.execute_write(
                lambda text: text.run(create_sector_node_query,
                                      f_name=f_name,
                                      m_id=m_id, g_id=g_id, ga_id=ga_id, c_id=c_id, chapel_id=chapel_id,
                                      id_s=id_s,
                                      name=name,
                                      description=description))
            print("---Inserted SECTOR with ID", id_s, "into neo4j database---")
        except ConstraintError as e:
            print(f"Skipping Sector with ID {id_s} due to ConstraintError: {e}")
            continue

def fetch_all_faiths(tx):
    query = "MATCH (f:Faith) RETURN f"
    result = tx.run(query)
    return [record["f"] for record in result]

def fetch_all_monuments(tx):
    query = "MATCH (m:Monument) RETURN m"
    result = tx.run(query)
    return [record["m"] for record in result]


def fetch_all_graves(tx):
    query = "MATCH (g:Grave) RETURN g"
    result = tx.run(query)
    return [record["g"] for record in result]


def fetch_all_gates(tx):
    query = "MATCH (ga:Gate) RETURN ga"
    result = tx.run(query)
    return [record["ga"] for record in result]


def fetch_all_cameras(tx):
    query = "MATCH (c:Camera) RETURN c"
    result = tx.run(query)
    return [record["c"] for record in result]


def fetch_all_chapels(tx):
    query = "MATCH(ch:Chapel) RETURN ch"
    result = tx.run(query)
    return [record["ch"] for record in result]


