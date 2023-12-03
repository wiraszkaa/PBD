CREATE TABLE "GraveSnapshot" (
  "GraveSnapshotId" bigserial PRIMARY KEY,
  "GraveType" varchar(20) NOT NULL,
  "OccupationStartDate" date NOT NULL,
  "OccupationEndDate" date,
  "PaymentExpirationDate" date,
  "FK_DeceasedId" integer NOT NULL,
  "FK_GraveId" integer NOT NULL
);

ALTER TABLE "GraveSnapshot" ADD FOREIGN KEY ("FK_DeceasedId") REFERENCES "Deceased" ("DeceasedId");
ALTER TABLE "GraveSnapshot" ADD FOREIGN KEY ("FK_GraveId") REFERENCES "Grave" ("GraveId");