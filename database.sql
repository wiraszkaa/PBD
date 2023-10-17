CREATE TABLE "Sector" (
  "SectorId" integer PRIMARY KEY,
  "SectorName" varchar(50) NOT NULL,
  "SectorDescription" varchar(250),
  "FK_FaithId" integer
);

CREATE TABLE "Faith" (
  "FaithName" varchar(50) PRIMARY KEY,
  "FaithDescription" varchar(100) NOT NULL,
  "NumberOfBelievers" integer
);

CREATE TABLE "Monument" (
  "MonumentId" integer PRIMARY KEY,
  "MonumentName" varchar(50) NOT NULL,
  "MonumentDescription" varchar(250),
  "FK_SectorId" integer NOT NULL
);

CREATE TABLE "Gate" (
  "GateId" integer PRIMARY KEY,
  "GateName" varchar(50) NOT NULL,
  "GateDescription" varchar(250),
  "OpeningHours" varchar(20),
  "FK_SectorId" integer NOT NULL
);

CREATE TABLE "Camera" (
  "CameraId" integer PRIMARY KEY,
  "CameraModel" varchar(50) NOT NULL,
  "CameraManufacturer" varchar(50),
  "InstallationDate" date NOT NULL,
  "IsDummy" boolean,
  "FK_SectorId" integer NOT NULL
);

CREATE TABLE "Grave" (
  "GraveId" integer PRIMARY KEY,
  "GraveType" varchar(20) NOT NULL,
  "GraveStatus" varchar(10) NOT NULL,
  "PaymentExpirationDate" date,
  "FK_SectorId" integer NOT NULL
);

CREATE TABLE "Chapel" (
  "ChapelId" integer PRIMARY KEY,
  "ChapelName" varchar(50) NOT NULL,
  "ArchitecturalStyle" varchar(50),
  "FK_SectorId" integer NOT NULL
);

CREATE TABLE "Funeral" (
  "FuneralId" integer PRIMARY KEY,
  "FuneralDate" date NOT NULL,
  "FuneralDescription" varchar(250),
  "FK_ChapelId" integer NOT NULL,
  "FK_DeceasedId" integer UNIQUE NOT NULL,
  "FK_PaymentId" integer UNIQUE
);

CREATE TABLE "Deceased" (
  "DeceasedId" integer PRIMARY KEY,
  "DeceasedFirstName" varchar(20) NOT NULL,
  "DeceasedLastName" varchar(30) NOT NULL,
  "DateOfDeath" date NOT NULL,
  "DateOfBirth" date NOT NULL,
  "CauseOfDeath" varchar(50),
  "DeceasedPESEL" varchar(11) UNIQUE NOT NULL,
  "FK_GraveId" integer NOT NULL,
  "FK_FaithName" varchar(50) NOT NULL
);

CREATE TABLE "Payment" (
  "PaymentId" integer PRIMARY KEY,
  "Amount" float NOT NULL,
  "PaymentDate" date NOT NULL,
  "PaymentStatus" varchar(10) NOT NULL,
  "PaymentMethod" varchar(20) NOT NULL,
  "PaymentDescription" varchar(200)
);

CREATE TABLE "Reservation" (
  "ReservationId" integer PRIMARY KEY,
  "ReservationDescription" varchar(150) NOT NULL,
  "ReservationDate" date NOT NULL,
  "ReservationExpirationDate" date NOT NULL,
  "ReservationStatus" varchar(20) NOT NULL,
  "FK_UserId" integer NOT NULL,
  "FK_GraveId" integer UNIQUE NOT NULL,
  "FK_PaymentId" integer UNIQUE NOT NULL
);

CREATE TABLE "User" (
  "UserId" integer PRIMARY KEY,
  "UserFirstName" varchar(20) NOT NULL,
  "UserLastName" varchar(30) NOT NULL,
  "UserEmail" varchar(50) UNIQUE NOT NULL,
  "UserPassword" varchar(50) NOT NULL,
  "UserPhoneNumber" varchar(10) NOT NULL,
  "UserRole" varchar(20) NOT NULL
);

CREATE TABLE "Service" (
  "ServiceId" integer PRIMARY KEY,
  "ServiceName" varchar(20) NOT NULL,
  "ServiceDescription" varchar(100) NOT NULL,
  "ServicePrice" float NOT NULL
);

CREATE TABLE "DeceasedHistory" (
  "DeceasedHistoryId" integer PRIMARY KEY,
  "HistoryDescription" varchar(500) NOT NULL,
  "DateAdded" date NOT NULL,
  "FK_DeceasedId" integer UNIQUE,
);

CREATE TABLE "Subscription" (
  "SubscriptionId" integer PRIMARY KEY,
  "FK_GraveId" integer NOT NULL,
  "FK_ServiceId" integer NOT NULL,
  "ServiceStartTime" date NOT NULL,
  "ServiceEndTime" date NOT NULL,
  "FK_PaymentId" integer UNIQUE
);

CREATE TABLE "Purchase" (
  "PurchaseId" integer PRIMARY KEY,
  "FK_UserId" integer,
  "FK_ServiceId" integer NOT NULL
);

ALTER TABLE "Sector" ADD FOREIGN KEY ("FaithId") REFERENCES "Faith" ("FaithName");

ALTER TABLE "Monument" ADD FOREIGN KEY ("SectorId") REFERENCES "Sector" ("SectorId");

ALTER TABLE "Gate" ADD FOREIGN KEY ("SectorId") REFERENCES "Sector" ("SectorId");

ALTER TABLE "Camera" ADD FOREIGN KEY ("SectorId") REFERENCES "Sector" ("SectorId");

ALTER TABLE "Grave" ADD FOREIGN KEY ("SectorId") REFERENCES "Sector" ("SectorId");

ALTER TABLE "Chapel" ADD FOREIGN KEY ("SectorId") REFERENCES "Sector" ("SectorId");

ALTER TABLE "Funeral" ADD FOREIGN KEY ("ChapelId") REFERENCES "Chapel" ("ChapelId");

ALTER TABLE "Funeral" ADD FOREIGN KEY ("DeceasedId") REFERENCES "Deceased" ("DeceasedId");

ALTER TABLE "Funeral" ADD FOREIGN KEY ("PaymentId") REFERENCES "Payment" ("PaymentId");

ALTER TABLE "Deceased" ADD FOREIGN KEY ("GraveId") REFERENCES "Grave" ("GraveId");

ALTER TABLE "Deceased" ADD FOREIGN KEY ("FaithName") REFERENCES "Faith" ("FaithName");

ALTER TABLE "Reservation" ADD FOREIGN KEY ("GraveId") REFERENCES "Grave" ("GraveId");

ALTER TABLE "Reservation" ADD FOREIGN KEY ("UserId") REFERENCES "User" ("UserId");

ALTER TABLE "Reservation" ADD FOREIGN KEY ("PaymentId") REFERENCES "Payment" ("PaymentId");

ALTER TABLE "DeceasedHistory" ADD FOREIGN KEY ("DeceasedId") REFERENCES "Deceased" ("DeceasedId");

ALTER TABLE "DeceasedHistory" ADD FOREIGN KEY ("UserId") REFERENCES "User" ("UserId");

ALTER TABLE "Subscription" ADD FOREIGN KEY ("GraveId") REFERENCES "Grave" ("GraveId");

ALTER TABLE "Subscription" ADD FOREIGN KEY ("ServiceId") REFERENCES "Service" ("ServiceId");

ALTER TABLE "Subscription" ADD FOREIGN KEY ("PaymentId") REFERENCES "Payment" ("PaymentId");

ALTER TABLE "Purchase" ADD FOREIGN KEY ("UserId") REFERENCES "User" ("UserId");

ALTER TABLE "Purchase" ADD FOREIGN KEY ("ServiceId") REFERENCES "Service" ("ServiceId");
