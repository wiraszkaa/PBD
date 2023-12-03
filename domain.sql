CREATE DOMAIN Pesel AS varchar(11) NOT NULL CHECK (value ~ '^[0-9]{11}$');
CREATE DOMAIN Money AS decimal(9,2) NOT NULL CHECK(value >= 0);
CREATE DOMAIN Email AS varchar(50) NOT NULL CHECK (value ~ '^[^@]+@[^\.@]+\..+$');
CREATE DOMAIN Password AS varchar(50) NOT NULL CHECK (value ~ '^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+])[a-zA-Z0-9!@#$%^&*()_+]{8,}$');
CREATE DOMAIN PhoneNumber AS varchar(9) NOT NULL CHECK (value ~ '^[0-9]{9}$');
CREATE TYPE UserRole AS ENUM ('user', 'employee');