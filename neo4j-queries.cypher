-- 1) the longest service
MATCH (service:Service)-[:USES]->(sub:Subscription)
WITH service.ServiceName AS Usługa, 
     date(sub.ServiceStartTime) AS `Czas rozpoczecia`, 
     date(sub.ServiceEndTime) AS `Czas zakonczenia`,
     duration.between(date(sub.SeraviceStartTime), date(sub.ServiceEndTime)).days AS Czas
ORDER BY Czas DESC
LIMIT 1
RETURN Usługa, 
       `Czas rozpoczecia`, 
       `Czas zakonczenia`, 
       Czas AS `Najdłuższy Czas`

-- 2) count of active and expired reservations before 2023-10-11
MATCH (r:Reservation)
WHERE r.ReservationDate >= date('2023-10-11')
RETURN 
  SUM(CASE r.ReservationStatus WHEN 'Active' THEN 1 ELSE 0 END) AS SuccessfulReservations,
  SUM(CASE r.ReservationStatus WHEN 'Expired' THEN 1 ELSE 0 END) AS UnpaidExpiredReservations

-- 3) count of deceased in the sector 'skrajny' with faith 'Katolicka'
MATCH (s:Sector)-[:HAS_FAITH]->(f:Faith), 
      (g:Grave)-[:LOCATED_IN]->(s),
      (d:Deceased)-[:BURIED_IN]->(g)
WHERE f.FaithName = 'Katolicka' AND s.SectorName = 'skrajny'
RETURN COUNT(d) AS TotalDeceased

-- 4) count of funerals in the sector 'centralny' in the chapel 'Kaplica_7104' after 1900-01-01
MATCH (ch:Chapel {ChapelName: 'Kaplica_3129'})-[:LOCATED_IN]->(s:Sector {SectorName: 'zachodni'}),
      (f:Funeral)-[:USES]->(ch)
WHERE f.FuneralDate >= date('1900-01-01')
RETURN ch.ChapelName, COUNT(f) AS NumberOfFunerals

-- 5)
MATCH (p: Purchase)-[:MADE_BY]->(u:User {UserEmail: 'oliver.brown252325883372@gmail.com'}),
      (p)-[:FOR]->(s:Service)
WITH MAX(s.ServicePrice) AS MaxPrice
MATCH (p: Purchase)-[:MADE_BY]->(u:User {UserEmail: 'oliver.brown252325883372@gmail.com'}),
      (p)-[:FOR]->(s:Service)
WHERE s.ServicePrice = MaxPrice
RETURN s.ServiceId, s.ServiceName, s.ServiceDescription, s.ServicePrice
LIMIT 1

-- 6) services bought by user with id 'bc43d4ee-401e-43aa-ae35-aa2243458ba0'
MATCH (p: Purchase)-[:MADE_BY]->(u:User {UserId: 'bc43d4ee-401e-43aa-ae35-aa2243458ba0'}),
      (p)-[:FOR]->(s:Service)
RETURN s

-- 7) deceased without funeral
MATCH (d:Deceased)-[:BURIED_IN]->(:Grave)-[:LOCATED_IN]->(s:Sector)-[:HAS_FAITH]->(f:Faith)
WHERE NOT (d)-[:FOR]->(:Funeral)
RETURN d.DeceasedPESEL, d.DeceasedFirstName, d.DeceasedLastName, f.FaithName

-- 8) reservations of user with id 88640
MATCH (r:Reservation)-[:MADE_BY]->(u:User {UserId: '73c382fa-1be9-482b-9559-fdb2579d4e2f'}),
      (r)-[:RESERVES]->(g:Grave)
RETURN r.ReservationDate, g.GraveId AS FK_GraveId, r.ReservationStatus, r.ReservationExpirationDate, g.GraveType, g.GraveStatus, g.PaymentExpirationDate

-- 9) history of deceased with name 'Agnieszka Kupiec'
MATCH (dh:DeceasedHistory)-[:HISTORY_OF]->(d:Deceased {DeceasedFirstName: 'Agnieszka', DeceasedLastName: 'Kupiec'})
RETURN d, dh.HistoryDescription, dh.DateAdded

-- 10) services used by deceased with id '34349036-2ad5-4698-a060-9b9a72c02267'
MATCH (ser:Service)-[:USES]->(s:Subscription)-[:FOR]->(g:Grave {GraveId: '34349036-2ad5-4698-a060-9b9a72c02267'})
MATCH (s)-[:PAID_FOR]->(pay:Payment)
RETURN ser.ServiceName AS ServiceName, s.ServiceStartTime AS StartDate, s.ServiceEndTime AS EndDate, pay.PaymentStatus AS PaymentStatus
