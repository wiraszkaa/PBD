-- 1)
SELECT 
    S."ServiceName" AS "Usługa", 
    Sub."ServiceStartTime" AS "Czas rozpoczecia", 
    Sub."ServiceEndTime" AS "Czas zakonczenia", 
    MAX(Sub."ServiceEndTime" - Sub."ServiceStartTime") AS "Czas"
FROM 
    "Subscription" AS Sub
JOIN 
    "Service" AS S ON Sub."FK_ServiceId" = S."ServiceId"
GROUP BY 
    S."ServiceName", Sub."ServiceStartTime", Sub."ServiceEndTime"
ORDER BY "Czas" DESC
LIMIT 1;
CREATE INDEX idx_subscription_serviceid ON "Subscription" ("FK_ServiceId");
CREATE INDEX idx_service_serviceid ON "Service" ("ServiceId"); -- for join
CREATE INDEX idx_subscription_servicestarttime ON "Subscription" ("ServiceStartTime");
CREATE INDEX idx_subscription_serviceendtime ON "Subscription" ("ServiceEndTime"); -- for calculating duration and sorting
-- Default to B-tree as it involves sorting and range queries:

-- 2)
SELECT
  SUM(CASE WHEN "ReservationStatus" = 'Active' THEN 1 ELSE 0 END) AS "SuccessfulReservations",
  SUM(CASE WHEN "ReservationStatus" = 'Expired' THEN 1 ELSE 0 END) AS "UnpaidExpiredReservations"
FROM "Reservation"
WHERE "ReservationDate" >= '2023-10-11';
CREATE INDEX idx_reservation_date ON "Reservation" ("ReservationDate"); -- for where
-- B-tree for range query on dates:
-- 3)
SELECT COUNT(d."DeceasedId") AS "TotalDeceased"
FROM "Deceased" d
JOIN "Grave" g ON d."FK_GraveId" = g."GraveId"
JOIN "Sector" s ON g."FK_SectorId" = s."SectorId"
JOIN "Faith" f ON d."FK_FaithName" = f."FaithName"
WHERE s."SectorName" = 'tylno-wschodni' AND f."FaithName" = 'Katolicka';

CREATE INDEX idx_deceased_graveid ON "Deceased" ("FK_GraveId");
CREATE INDEX idx_grave_graveid ON "Grave" ("GraveId");
CREATE INDEX idx_grave_sectorid ON "Grave" ("FK_SectorId");
CREATE INDEX idx_sector_sectorid ON "Sector" ("SectorId"); -- for joins
CREATE INDEX idx_sector_name ON "Sector" ("SectorName");
CREATE INDEX idx_faith_name ON "Faith" ("FaithName"); -- for where
-- B-tree for equality and range queries:
-- 4)
SELECT  c."ChapelId", c."ChapelName"
FROM  "Sector" s
JOIN  "Chapel" c ON c."FK_SectorId" = s."SectorId"
WHERE  s."SectorName" = 'tylno-wschodni';

SELECT c."ChapelName", COUNT(f."FuneralId") AS "NumberOfFunerals"
FROM  "Chapel" c
JOIN  "Funeral" f ON c."ChapelId" = f."FK_ChapelId"
JOIN  "Sector" s ON c."FK_SectorId" = s."SectorId"
WHERE  s."SectorName" = 'centralny' AND c."ChapelName" = 'Kaplica_7104' AND f."FuneralDate" >= '1900-01-01'
GROUP BY  c."ChapelName";
CREATE INDEX idx_chapel_sectorid ON "Chapel" ("FK_SectorId"); -- for join
CREATE INDEX idx_funeral_chapelid ON "Funeral" ("FK_ChapelId"); -- for join
CREATE INDEX idx_sector_name2 ON "Sector" ("SectorName"); --for where
CREATE INDEX idx_funeral_date ON "Funeral" ("FuneralDate");
CREATE INDEX idx_chapel_name2 ON "Chapel" ("ChapelName"); -- for where
-- B-tree is suitable for sorting and range queries:
-- 5)
SELECT 
    s."ServiceId", 
    s."ServiceName", 
    s."ServiceDescription", 
    s."ServicePrice"
FROM  
    "Service" s
JOIN 
    "Purchase" p ON s."ServiceId" = p."FK_ServiceId"
JOIN 
    "User" u ON p."FK_UserId" = u."UserId"
WHERE 
    s."ServicePrice" = (
        SELECT MAX(s2."ServicePrice")
        FROM "Service" s2
        JOIN "Purchase" p2 ON s2."ServiceId" = p2."FK_ServiceId"
        JOIN "User" u2 ON p2."FK_UserId" = u2."UserId"
        WHERE u2."UserEmail" = 'sophia_wilson452485396871@outlook.com'
    )
AND u."UserEmail" = 'sophia_wilson452485396871@outlook.com'
LIMIT 1;
CREATE INDEX idx_service_serviceid2 ON "Service" ("ServiceId");
CREATE INDEX idx_purchase_serviceid ON "Purchase" ("FK_ServiceId"); -- join
CREATE INDEX idx_user_userid ON "User" ("UserId"); -- for join
CREATE INDEX idx_purchase_userid ON "Purchase" ("FK_UserId"); -- for join
CREATE INDEX idx_user_email ON "User" ("UserEmail"); -- for where
CREATE INDEX idx_service_serviceprice ON "Service" ("ServicePrice"); -- for where
-- B-tree for equality and range queries on prices and IDs:

-- 6)
select S.*  
FROM "User" U
JOIN "Purchase" P ON U."UserId" = P."FK_UserId"
JOIN "Service" S ON P."FK_ServiceId" = S."ServiceId"
WHERE U."UserId" = 17465;

CREATE INDEX idx_user_userid2 ON "User" ("UserId"); -- for where
CREATE INDEX idx_purchase_userid2 ON "Purchase" ("FK_UserId"); -- for join
CREATE INDEX idx_service_serviceid3 ON "Service" ("ServiceId");
-- B-tree for JOIN operations on IDs:
-- 7)
SELECT D."DeceasedId", D."DeceasedFirstName", D."DeceasedLastName", F."FaithName"
FROM "Deceased" D
LEFT JOIN "Funeral" FUN ON D."DeceasedId" = FUN."FK_DeceasedId"
JOIN "Faith" F ON D."FK_FaithName" = F."FaithName"
WHERE FUN."FuneralId" IS NULL;

CREATE INDEX idx_deceased_faithname ON "Deceased" ("FK_FaithName"); -- for join
CREATE INDEX idx_faith_faithname ON "Faith" ("FaithName");
CREATE INDEX idx_deceased_deceasedid ON "Deceased" ("DeceasedId");
CREATE INDEX idx_funeral_deceasedid ON "Funeral" ("FK_DeceasedId");
CREATE INDEX idx_funeral_funeralid ON "Funeral" ("FuneralId");
-- B-tree for JOINs and WHERE clauses:
-- 8)
SELECT 
    R."ReservationDate",
    R."FK_GraveId",
    R."ReservationStatus",
    R."ReservationExpirationDate",
    G."GraveType",
    G."GraveStatus",
    G."PaymentExpirationDate"
FROM "Reservation" R
JOIN "Grave" G ON R."FK_GraveId" = G."GraveId"
WHERE R."FK_UserId" = 88640;
CREATE INDEX idx_reservation_graveid ON "Reservation" ("FK_GraveId");
CREATE INDEX idx_grave_graveid2 ON "Grave" ("GraveId");
CREATE INDEX idx_reservation_userid ON "Reservation" ("FK_UserId");
-- B-tree for range queries and JOIN conditions:

-- 9)
SELECT D.*, DH."HistoryDescription", DH."DateAdded"
FROM "Deceased" D
JOIN "DeceasedHistory" DH ON D."DeceasedId" = DH."FK_DeceasedId"
WHERE D."DeceasedFirstName" = 'Paweł' AND D."DeceasedLastName" = 'Nowak';
CREATE INDEX idx_deceased_deceasedid2 ON "Deceased" ("DeceasedId");
CREATE INDEX idx_deceasedhistory_deceasedid ON "DeceasedHistory" ("FK_DeceasedId");
CREATE INDEX idx_deceased_firstname ON "Deceased" ("DeceasedFirstName");
CREATE INDEX idx_deceased_lastname ON "Deceased" ("DeceasedLastName");
-- B-tree for text-based searches and JOINs:
-- 10)
SELECT Ser."ServiceName" AS "ServiceName", Sub."ServiceStartTime" AS "StartDate", Sub."ServiceEndTime" AS "EndDate", Pay."PaymentStatus" AS "PaymentStatus"
FROM "Subscription" Sub
JOIN "Service" Ser ON Sub."FK_ServiceId" = Ser."ServiceId"
JOIN "Payment" Pay ON Sub."FK_PaymentId" = Pay."PaymentId"
WHERE Sub."FK_GraveId" = 12331; 
-- B-tree for range queries on dates and JOINs:
CREATE INDEX idx_subscription_serviceid2 ON "Subscription" ("FK_ServiceId");
CREATE INDEX idx_service_serviceid4 ON "Service" ("ServiceId");
CREATE INDEX idx_subscription_paymentid ON "Subscription" ("FK_PaymentId");
CREATE INDEX idx_payment_paymentid ON "Payment" ("PaymentId");
CREATE INDEX idx_subscription_graveid ON "Subscription" ("FK_GraveId");

-- For your queries, B-tree indexes are the most beneficial due to the nature of the operations (equality, range queries, and sorting). However, other index types like GiST, SP-GiST, GIN, and BRIN are more suitable for specific use cases like full-text search, geospatial data, or tables with large, unsorted data where BRIN can efficiently summarize data ranges.
