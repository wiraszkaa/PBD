import json
import random
from datetime import date, timedelta
from sqlalchemy.sql import text
from sqlalchemy.orm import Session


def load_description(entity_name):
    try:
        with open(f'resources/{entity_name}_description.json', 'r', encoding='utf-8') as file:
            return json.load(file)["descriptions"]
    except FileNotFoundError:
        return []


camera_manufacturers = ["Sony", "LG", "Apple", "Samsung", "Xiaomi", "Poco", "SecurityMasters"]
architectural_styles = [
    "Gotyk",
    "Renesans",
    "Barok",
    "Rokoko",
    "Klasycyzm",
    "Neogotyk",
    "Secesja (Modernizm)",
    "Konstruktywizm",
    "Funkcjonalizm",
    "Brutalizm",
    "Bauhaus",
    "Postmodernizm",
    "Art déco",
    "Romanesque (Romanski)",
    "Kolonialny",
    "Biedermeier",
    "Neorenesans",
    "Neobarok",
    "Dekonstruktywizm",
    "Minimalizm",
    "Hi-tech",
    "Eklektyzm",
    "Organic Architecture (Architektura organiczna)",
    "Mieszczański",
    "Bioklimatyczny",
    "Neoplastycyzm",
    "Neotradycjonalizm",
    "Streamline Moderne",
    "Metabolizm",
    "Prairie Style",
    "Shingle Style",
    "Tudor Revival (Odrodzenie Tudorów)",
    "Craftsman (Rzemieślnik)",
    "Art Nouveau",
    "International Style (Styl międzynarodowy)"
]


def random_time(min_range, max_range):
    return f"{random.randint(min_range, max_range):02}:{random.choice(['00', '30'])}"


def random_opening_hours():
    start_time = random_time(6, 12)
    end_time = random_time(13, 21)
    return f"{start_time} - {end_time}"


def generate_data_for_sectors(session: Session):
    monument_descriptions = load_description('monument')
    gate_descriptions = load_description('gate')

    for sector_id in range(104, 154):
        print("sector_id: " + str(sector_id))
        # Generate Chapels
        num_chapels = random.choices([0, 1, 2, 3], [0.3, 0.3, 0.2, 0.2])[0]
        for _ in range(num_chapels):
            chapel_name = f"Kaplica_{random.randint(1, 10000)}"
            architectural_style = random.choice(architectural_styles)
            session.execute(text(f"""INSERT INTO "Chapel" ("ChapelName", "ArchitecturalStyle", "FK_SectorId") 
                                      VALUES ('{chapel_name}', '{architectural_style}', {sector_id});"""))

        print("Chapels generated")
        # Generate Monuments
        num_monuments = random.randint(0, 7)
        for _ in range(num_monuments):
            monument_name = f"Monument_{random.randint(1, 10000)}"
            description = random.choice(monument_descriptions) if monument_descriptions else 'Default Description'
            session.execute(text(f"""INSERT INTO "Monument" ("MonumentName", "MonumentDescription", "FK_SectorId") 
                                      VALUES ('{monument_name}', '{description}', {sector_id});"""))
        print("Monuments generated")

        # Generate Cameras
        num_cameras = random.randint(0, 14)
        for _ in range(num_cameras):
            camera_model = f"Model_{random.randint(1, 100)}"
            installation_date = date.today() - timedelta(days=random.randint(0, 365))
            manufacturer = random.choice(camera_manufacturers)
            is_dummy = random.choice([True, False])
            session.execute(text(f"""INSERT INTO "Camera" ("CameraModel", "InstallationDate", "FK_SectorId", "CameraManufacturer", "IsDummy") 
                                      VALUES ('{camera_model}', '{installation_date}', {sector_id}, '{manufacturer}', '{ "True" if is_dummy else "False"}');"""))
        print("Cameras generated")
        # Generate Gates
        num_gates = random.choices([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                                       [0.2, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08])[0]
        for _ in range(num_gates):
            gate_name = f"Brama_{random.randint(1, 10000)}"
            description = random.choice(gate_descriptions) if gate_descriptions else 'Default Description'
            opening_hours = random_opening_hours()
            session.execute(text(f"""INSERT INTO "Gate" ("GateName", "GateDescription", "OpeningHours", "FK_SectorId") 
                                            VALUES ('{gate_name}', '{description}', '{opening_hours}', {sector_id});"""))
        print("Gates generated")

    session.commit()
