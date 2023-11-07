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

-- 2)
SELECT
  SUM(CASE WHEN "ReservationStatus" = 'Active' THEN 1 ELSE 0 END) AS "SuccessfulReservations",
  SUM(CASE WHEN "ReservationStatus" = 'Expired' THEN 1 ELSE 0 END) AS "UnpaidExpiredReservations"
FROM "Reservation"
WHERE "ReservationDate" >= '2023-10-11';

-- 3)
SELECT COUNT(d."DeceasedId") AS "TotalDeceased"
FROM "Deceased" d
JOIN "Grave" g ON d."FK_GraveId" = g."GraveId"
JOIN "Sector" s ON g."FK_SectorId" = s."SectorId"
JOIN "Faith" f ON d."FK_FaithName" = f."FaithName"
WHERE s."SectorName" = 'tylno-wschodni' AND f."FaithName" = 'Katolicka';

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

-- 6)
select S.*  
FROM "User" U
JOIN "Purchase" P ON U."UserId" = P."FK_UserId"
JOIN "Service" S ON P."FK_ServiceId" = S."ServiceId"
WHERE U."UserId" = 17465;

-- 7)
SELECT D."DeceasedId", D."DeceasedFirstName", D."DeceasedLastName", F."FaithName"
FROM "Deceased" D
LEFT JOIN "Funeral" FUN ON D."DeceasedId" = FUN."FK_DeceasedId"
JOIN "Faith" F ON D."FK_FaithName" = F."FaithName"
WHERE FUN."FuneralId" IS NULL;

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

-- 9)
SELECT D.*, DH."HistoryDescription", DH."DateAdded"
FROM "Deceased" D
JOIN "DeceasedHistory" DH ON D."DeceasedId" = DH."FK_DeceasedId"
WHERE D."DeceasedFirstName" = 'Paweł' AND D."DeceasedLastName" = 'Nowak';

-- 10)
SELECT Ser."ServiceName" AS "ServiceName", Sub."ServiceStartTime" AS "StartDate", Sub."ServiceEndTime" AS "EndDate", Pay."PaymentStatus" AS "PaymentStatus"
FROM "Subscription" Sub
JOIN "Service" Ser ON Sub."FK_ServiceId" = Ser."ServiceId"
JOIN "Payment" Pay ON Sub."FK_PaymentId" = Pay."PaymentId"
WHERE Sub."FK_GraveId" = 12331; 
