from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import sessionmaker

import deceased
import deceased_history
import faith
import funeral
import grave
import purchases
import reservation
import sector
import sector_dependent_entities
import services
import subscription
import user
import funeral

DATABASE_URL = "postgresql://localhost:5432/projectPBD"

engine = create_engine(DATABASE_URL)
Base = declarative_base()
SessionLocal = sessionmaker(bind=engine)

with SessionLocal() as session:
    # faith.insert_faiths(session)
    # sector.insert_sectors(session)
    # sector_dependent_entities.generate_data_for_sectors(session)
    # grave.insert_graves(session)
    # deceased.insert_deceased(session)
    # funeral.insert_funerals(session)
    # user.insert_users(session, "user", 98703)
    # deceased_history.insert_deceased_history(session)
    # services.insert_services(session)
    # purchases.insert_purchases(session)
    # reservation.insert_reservation(session)
    # subscription.insert_subscription(session)
    funeral.insert_funerals(session)
    session.commit()
