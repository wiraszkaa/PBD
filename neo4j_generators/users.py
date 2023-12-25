import random
import uuid

NAMES = ["John", "Jane", "Robert", "Mia", "Oliver", "Emma", "Liam", "Sophia", "James", "Isabella"]
SURNAMES = ["Smith", "Brown", "Wilson", "Evans", "Thomas", "Johnson", "Roberts", "Lewis", "Walker", "Lee"]
PASSWORD_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+"


def generate_random_email():
    name = random.choice(NAMES).lower()
    surname = random.choice(SURNAMES).lower()
    domain = ["gmail.com", "yahoo.com", "outlook.com", "test.com", "@pwr.edu.pl"]
    return f"{name}{generate_random_email_spread()}{surname}{generate_random_email_suffix()}@{random.choice(domain)}"


def generate_random_email_spread():
    return random.choice([".", "_", "-"])


def generate_random_email_suffix():
    return ''.join(random.choices("0123456789", k=12))


def generate_random_phone_number():
    return ''.join(random.choices("0123456789", k=9))


def generate_random_password():
    password = [
        random.choice("abcdefghijklmnopqrstuvwxyz"),
        random.choice("ABCDEFGHIJKLMNOPQRSTUVWXYZ"),
        random.choice("!@#$%^&*()_+"),
    ]
    for _ in range(5):
        password.append(random.choice("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+0123456789"))
    random.shuffle(password)
    return ''.join(password)


def insert_users(session, role: str, num: int):
    for _ in range(num):
        id = str(uuid.uuid4())
        first_name = random.choice(NAMES)
        last_name = random.choice(SURNAMES)
        email = generate_random_email()
        password = generate_random_password()
        phone_number = generate_random_phone_number()
        user_role = role
        
        create_user_node_query = """
        CREATE (:User {
            UserId: $id,
            UserFirstName: $first_name, 
            UserLastName: $last_name, 
            UserEmail: $email, 
            UserPassword: $password, 
            UserPhoneNumber: $phone_number, 
            UserRole: $user_role
            });
        """
        
        session.execute_write(lambda tx: tx.run(create_user_node_query,
                                                id=id,
                                                first_name=first_name,
                                                last_name=last_name,
                                                email=email,
                                                password=password,
                                                phone_number=phone_number,
                                                user_role=user_role))
        

        print(f"User {first_name} {last_name} inserted")