CREATE DOMAIN Pesel AS varchar(11) NOT NULL CHECK (value ~ '^[0-9]{11}$');
CREATE DOMAIN Money AS decimal(9,2) NOT NULL CHECK(value >= 0);
CREATE DOMAIN Email AS varchar(50) NOT NULL CHECK (value ~ '^[^@]+@[^\.@]+\..+$');
CREATE DOMAIN Password AS varchar(50) NOT NULL CHECK (value ~ '^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+])[a-zA-Z0-9!@#$%^&*()_+]{8,}$');
CREATE DOMAIN PhoneNumber AS varchar(9) NOT NULL CHECK (value ~ '^[0-9]{9}$');
CREATE TYPE UserRole AS ENUM ('user', 'employee');

CREATE TABLE "Sector" (
  "SectorId" bigserial PRIMARY KEY,
  "SectorName" varchar(50) NOT NULL,
  "SectorDescription" varchar(250),
  "FK_FaithName" varchar(50)
);

CREATE TABLE "Faith" (
  "FaithName" varchar(50) PRIMARY KEY,
  "FaithDescription" varchar(100) NOT NULL,
  "NumberOfBelievers" integer CHECK ("NumberOfBelievers" >= 0)
);

CREATE TABLE "Monument" (
  "MonumentId" bigserial PRIMARY KEY,
  "MonumentName" varchar(50) NOT NULL,
  "MonumentDescription" varchar(250),
  "FK_SectorId" integer NOT NULL
);

CREATE TABLE "Gate" (
  "GateId" bigserial PRIMARY KEY,
  "GateName" varchar(50) NOT NULL,
  "GateDescription" varchar(250),
  "OpeningHours" varchar(20),
  "FK_SectorId" integer NOT NULL
);

CREATE TABLE "Camera" (
  "CameraId" bigserial PRIMARY KEY,
  "CameraModel" varchar(50) NOT NULL,
  "CameraManufacturer" varchar(50),
  "InstallationDate" date NOT NULL,
  "IsDummy" boolean,
  "FK_SectorId" integer NOT NULL
);

CREATE TABLE "Grave" (
  "GraveId" bigserial PRIMARY KEY,
  "GraveType" varchar(20) NOT NULL,
  "GraveStatus" varchar(10) NOT NULL,
  "PaymentExpirationDate" date,
  "FK_SectorId" integer NOT NULL
);

CREATE TABLE "Chapel" (
  "ChapelId" bigserial PRIMARY KEY,
  "ChapelName" varchar(50) NOT NULL,
  "ArchitecturalStyle" varchar(50),
  "FK_SectorId" integer NOT NULL
);

CREATE TABLE "Funeral" (
  "FuneralId" bigserial PRIMARY KEY,
  "FuneralDate" date NOT NULL,
  "FuneralDescription" varchar(250),
  "FK_ChapelId" integer NOT NULL,
  "FK_DeceasedId" integer UNIQUE NOT NULL,
  "FK_PaymentId" integer UNIQUE
);

CREATE TABLE "Deceased" (
  "DeceasedId" bigserial PRIMARY KEY,
  "DeceasedFirstName" varchar(20) NOT NULL,
  "DeceasedLastName" varchar(30) NOT NULL,
  "DateOfDeath" date NOT NULL,
  "DateOfBirth" date NOT NULL CHECK ("DateOfBirth" < "DateOfDeath"),
  "CauseOfDeath" varchar(50),
  "DeceasedPESEL" Pesel UNIQUE,
  "FK_GraveId" integer NOT NULL,
  "FK_FaithName" varchar(50) NOT NULL
);

CREATE TABLE "Payment" (
  "PaymentId" bigserial PRIMARY KEY,
  "Amount" Money,
  "PaymentDate" date NOT NULL CHECK ("PaymentDate" <= date('now')),
  "PaymentStatus" varchar(10) NOT NULL,
  "PaymentMethod" varchar(20) NOT NULL,
  "PaymentDescription" varchar(200)
);

CREATE TABLE "Reservation" (
  "ReservationId" bigserial PRIMARY KEY,
  "ReservationDescription" varchar(150) NOT NULL,
  "ReservationDate" date NOT NULL,
  "ReservationExpirationDate" date NOT NULL CHECK ("ReservationExpirationDate" > "ReservationDate"),
  "ReservationStatus" varchar(20) NOT NULL,
  "FK_UserId" integer NOT NULL,
  "FK_GraveId" integer UNIQUE NOT NULL,
  "FK_PaymentId" integer UNIQUE NOT NULL
);


CREATE TABLE "User" (
  "UserId" bigserial PRIMARY KEY,
  "UserFirstName" varchar(20) NOT NULL,
  "UserLastName" varchar(30) NOT NULL,
  "UserEmail" Email UNIQUE,
  "UserPassword" Password,
  "UserPhoneNumber" PhoneNumber,
  "UserRole" UserRole
);

CREATE TABLE "Service" (
  "ServiceId" bigserial PRIMARY KEY,
  "ServiceName" varchar(20) NOT NULL,
  "ServiceDescription" varchar(100) NOT NULL,
  "ServicePrice" Money
);

CREATE TABLE "DeceasedHistory" (
  "DeceasedHistoryId" bigserial PRIMARY KEY,
  "HistoryDescription" varchar(500) NOT NULL,
  "DateAdded" date NOT NULL,
  "FK_DeceasedId" integer UNIQUE
);

CREATE TABLE "Subscription" (
  "SubscriptionId" bigserial PRIMARY KEY,
  "ServiceStartTime" date NOT NULL,
  "ServiceEndTime" date NOT NULL CHECK ("ServiceEndTime" > "ServiceStartTime"),
  "FK_GraveId" integer NOT NULL,
  "FK_ServiceId" integer NOT NULL,
  "FK_PaymentId" integer UNIQUE
);

CREATE TABLE "Purchase" (
  "PurchaseId" bigserial PRIMARY KEY,
  "FK_ServiceId" integer NOT NULL,
  "FK_UserId" integer
);






ALTER TABLE "Sector" ADD FOREIGN KEY ("FK_FaithName") REFERENCES "Faith" ("FaithName")  ON DELETE SET NULL;
ALTER TABLE "Monument" ADD FOREIGN KEY ("FK_SectorId") REFERENCES "Sector" ("SectorId") ON DELETE SET NULL;
ALTER TABLE "Gate" ADD FOREIGN KEY ("FK_SectorId") REFERENCES "Sector" ("SectorId") ON DELETE CASCADE;
ALTER TABLE "Camera" ADD FOREIGN KEY ("FK_SectorId") REFERENCES "Sector" ("SectorId") ON DELETE CASCADE;
ALTER TABLE "Grave" ADD FOREIGN KEY ("FK_SectorId") REFERENCES "Sector" ("SectorId");
ALTER TABLE "Chapel" ADD FOREIGN KEY ("FK_SectorId") REFERENCES "Sector" ("SectorId");
ALTER TABLE "Funeral" ADD FOREIGN KEY ("FK_ChapelId") REFERENCES "Chapel" ("ChapelId");
ALTER TABLE "Funeral" ADD FOREIGN KEY ("FK_DeceasedId") REFERENCES "Deceased" ("DeceasedId");
ALTER TABLE "Funeral" ADD FOREIGN KEY ("FK_PaymentId") REFERENCES "Payment" ("PaymentId");
ALTER TABLE "Deceased" ADD FOREIGN KEY ("FK_GraveId") REFERENCES "Grave" ("GraveId");
ALTER TABLE "Deceased" ADD FOREIGN KEY ("FK_FaithName") REFERENCES "Faith" ("FaithName");
ALTER TABLE "Reservation" ADD FOREIGN KEY ("FK_GraveId") REFERENCES "Grave" ("GraveId");
ALTER TABLE "Reservation" ADD FOREIGN KEY ("FK_UserId") REFERENCES "User" ("UserId");
ALTER TABLE "Reservation" ADD FOREIGN KEY ("FK_PaymentId") REFERENCES "Payment" ("PaymentId");
ALTER TABLE "DeceasedHistory" ADD FOREIGN KEY ("FK_DeceasedId") REFERENCES "Deceased" ("DeceasedId");
ALTER TABLE "Subscription" ADD FOREIGN KEY ("FK_GraveId") REFERENCES "Grave" ("GraveId");
ALTER TABLE "Subscription" ADD FOREIGN KEY ("FK_ServiceId") REFERENCES "Service" ("ServiceId");
ALTER TABLE "Subscription" ADD FOREIGN KEY ("FK_PaymentId") REFERENCES "Payment" ("PaymentId");
ALTER TABLE "Purchase" ADD FOREIGN KEY ("FK_UserId") REFERENCES "User" ("UserId") ON DELETE CASCADE;
ALTER TABLE "Purchase" ADD FOREIGN KEY ("FK_ServiceId") REFERENCES "Service" ("ServiceId") ON DELETE CASCADE;
