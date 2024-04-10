import json
import random
from datetime import date, timedelta
import time
import uuid


def random_time(min_range, max_range):
    return f"{random.randint(min_range, max_range):02}:{random.choice(['00', '30'])}"


def load_description(entity_name):
    try:
        with open(f'resources/{entity_name}_description.json', 'r', encoding='utf-8') as file:
            return json.load(file)["descriptions"]
    except FileNotFoundError:
        return []


def random_opening_hours():
    start_time = random_time(6, 12)
    end_time = random_time(13, 21)
    return f"{start_time} - {end_time}"


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


def generate_data_for_sectors(session, sector_range):
    monument_descriptions = load_description('monument')
    gate_descriptions = load_description('gate')

    for sector_id in sector_range:
        print("sector_id: " + str(sector_id))

        # Generate Chapels
        num_chapels = random.choices([0, 1, 2, 3], [0.3, 0.3, 0.2, 0.2])[0]
        for _ in range(num_chapels):
            id = str(uuid.uuid4())
            random.seed(time.time())
            chapel_name = f"Kaplica_{random.randint(1, 10000)}"
            architectural_style = random.choice(architectural_styles)
            create_chapel_node_query = """
                CREATE (:Chapel {
                    ChapelId: $id,
                    ChapelName: $chapel_name, 
                    ArchitecturalStyle: $architectural_style
                });
                """
            session.execute_write(
                lambda text: text.run(create_chapel_node_query, id=id, chapel_name=chapel_name,
                                      architectural_style=architectural_style))
            print("Chapels generated")

            # Generate Monuments
            num_monuments = random.randint(0, 7)
            for _ in range(num_monuments):
                id = str(uuid.uuid4())
                random.seed(time.time())
                monument_name = f"Monument_{random.randint(1, 10000)}"
                monument_description = random.choice(
                    monument_descriptions) if monument_descriptions else 'Default Description'
                create_monument_node_query = """
                CREATE (:Monument {
                     MonumentId: $id,
                     MonumentName: $monument_name, 
                     MonumentDescription: $monument_description
                    }); 
                """
                session.execute_write(
                    lambda text: text.run(create_monument_node_query,
                                          id=id,
                                          monument_name=monument_name,
                                          monument_description=monument_description))
            print("Monuments generated")

            # Generate Cameras
            num_cameras = random.randint(0, 14)
            for _ in range(num_cameras):
                id = str(uuid.uuid4())
                random.seed(time.time())
                camer_model = f"Model_{random.randint(1, 500)}"
                installation_date = date.today() - timedelta(days=random.randint(0, 365))
                camera_manufacturer = random.choice(camera_manufacturers)
                is_dummy = random.choice([True, False])
                create_camera_node_query = """
                    CREATE (:Camera {
                    CameraId: $id,
                    CameraModel: $camer_model, 
                    CameraManufacturer: $camera_manufacturer, 
                    InstallationDate: $installation_date, 
                    IsDummy: $is_dummy
                });
                """
                session.execute_write(
                    lambda text: text.run(create_camera_node_query,
                                          id=id,
                                          camer_model=camer_model,
                                          camera_manufacturer=camera_manufacturer,
                                          installation_date=installation_date,
                                          is_dummy=is_dummy))
            print("Cameras generated")

            # Generate Gates
            num_gates = random.choices([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                                       [0.2, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08])[0]
            for _ in range(num_gates):
                id = str(uuid.uuid4())
                random.seed(time.time())
                gate_name = f"Brama_{random.randint(1, 10000)}"
                description = random.choice(gate_descriptions) if gate_descriptions else 'Default Description'
                opening_hours = random_opening_hours()
                create_gate_node = """
                CREATE (:Gate {
                GateId: $id,
                GateName: $gate_name, 
                GateDescription: $description, 
                OpeningHours: $opening_hours
                });
                """
                session.execute_write(
                    lambda text: text.run(create_gate_node,
                                          id=id,
                                          gate_name=gate_name,
                                          description=description,
                                          opening_hours=opening_hours)
                )
            print("Gates generated")
