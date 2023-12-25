from neo4j import GraphDatabase
import faith
import sector
import users
import grave
import services
import sector_dependent_entites
import subscription
import reservation
import purchase
import decease
import deceased_history
import funeral

AURA_CONNECTION_URI = "neo4j+s://43fb0ebb.databases.neo4j.io"
AURA_USERNAME = "neo4j"
AURA_PASSWORD = "6AT_UMoHXxkFiMIPl0AYuZYVJvb-C1HCIazkyjbgbkU"


SECTOR_RANGE = list(range(61,71))

driver = GraphDatabase.driver(
    AURA_CONNECTION_URI,
    auth=(AURA_USERNAME, AURA_PASSWORD)
)


def delete_all_nodes(session):
    query = """
            MATCH (n)
            OPTIONAL MATCH (n)-[r]-()
            DELETE n, r
        """
    session.execute_write(lambda tx: tx.run(query))


def set_up_constrains(session):
    queries = [
        "CREATE CONSTRAINT FOR (f:Faith) REQUIRE f.FaithId IS UNIQUE",
        "CREATE CONSTRAINT FOR (d:Deceased) REQUIRE d.DeceasedPESEL IS UNIQUE",
        "CREATE CONSTRAINT FOR (u:User) REQUIRE u.UserEmail IS UNIQUE",
        "CREATE CONSTRAINT FOR (pu:Purchase) REQUIRE pu.PurchaseId IS UNIQUE",
        "CREATE CONSTRAINT FOR (su:Subscription) REQUIRE su.SubscriptionId IS UNIQUE",
        "CREATE CONSTRAINT FOR (de:DeceasedHistory) REQUIRE de.DeceasedHistoryId IS UNIQUE",
        "CREATE CONSTRAINT FOR (se:Service) REQUIRE se.ServiceId IS UNIQUE",
        "CREATE CONSTRAINT FOR (re:Reservation) REQUIRE re.ReservationId IS UNIQUE",
        "CREATE CONSTRAINT FOR (p:Payment) REQUIRE p.PaymentId IS UNIQUE",
        "CREATE CONSTRAINT FOR (fu:Funeral) REQUIRE fu.FuneralId IS UNIQUE",
        "CREATE CONSTRAINT FOR (ch:Chapel) REQUIRE ch.ChapelId IS UNIQUE",
        "CREATE CONSTRAINT FOR (g:Grave) REQUIRE g.GraveId IS UNIQUE",
        "CREATE CONSTRAINT FOR (c:Camera) REQUIRE c.CameraId IS UNIQUE",
        "CREATE CONSTRAINT FOR (ga:Gate) REQUIRE ga.GateId IS UNIQUE",
        "CREATE CONSTRAINT FOR (mo:Monument) REQUIRE mo.MonumentId IS UNIQUE",
        "CREATE CONSTRAINT FOR (s:Sector) REQUIRE s.SectorId IS UNIQUE"]

    for query in queries:
        session.execute_write(lambda tx: tx.run(query))

    print("Rules added!")


def main():
    with driver.session() as session:
        # set_up_constrains(session)
        # delete_all_nodes(session)

        # faith.insert_faiths(session)
        # sector.insert_sectors(session, SECTOR_RANGE)
        # sector_dependent_entites.generate_data_for_sectors(session, SECTOR_RANGE)

        # users.insert_users(session, "user", 1000)

        # grave.insert_graves(session, SECTOR_RANGE)

        # services.insert_services(session)
        # subscription.insert_subscription(session)

        # reservation.insert_reservation(session)
        # purchase.insert_purchases(session)
        # decease.insert_deceased(session)
        # deceased_history.insert_deceased_history(session)
        # funeral.insert_funerals(session)
        driver.close()
        session.close()


if __name__ == "__main__":
    main()
