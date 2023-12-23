
CREATE (:Sector {
    SectorId: 1, 
    SectorName: "Education", 
    SectorDescription: "Sector focusing on educational services"
});

CREATE (:Faith {
    FaithName: "Christianity", 
    FaithDescription: "A spiritual tradition that focuses on personal spiritual development and the attainment of a deep insight into the true nature of life.", 
    NumberOfBelievers: 520000000
});

CREATE (:Monument {
    MonumentId: 1, 
    MonumentName: "Liberty Statue", 
    MonumentDescription: "A famous monument located in New York City"
});

CREATE (:Gate {
    GateId: 1, 
    GateName: "Main Entrance", 
    GateDescription: "The primary entrance for visitors", 
    OpeningHours: "09:00 - 17:00"
});

CREATE (:Camera {
    CameraId: 1, 
    CameraModel: "Nikon D3500", 
    CameraManufacturer: "Nikon", 
    InstallationDate: date("2023-01-01"), 
    IsDummy: false
});

CREATE (:Grave {
    GraveId: 1, 
    GraveType: "Single", 
    GraveStatus: "Occupied", 
    PaymentExpirationDate: date("2024-01-01")
});

CREATE (:Chapel {
    ChapelId: 1, 
    ChapelName: "Saint Paul's Chapel", 
    ArchitecturalStyle: "Gothic"
});

CREATE (:Funeral {
    FuneralId: 1, 
    FuneralDate: date("2023-05-01"), 
    FuneralDescription: "Funeral of a renowned philanthropist"
});

CREATE (:Deceased {
    DeceasedId: 1, 
    DeceasedFirstName: "John", 
    DeceasedLastName: "Doe", 
    DateOfDeath: date("2023-04-30"), 
    DateOfBirth: date("1950-01-01"), 
    CauseOfDeath: "Natural causes", 
    DeceasedPESEL: "12345678901"
});

CREATE (:Payment {
    PaymentId: 1, 
    Amount: 100.00, 
    PaymentDate: date("2023-05-01"), 
    PaymentStatus: "Completed", 
    PaymentMethod: "Credit Card", 
    PaymentDescription: "Funeral service payment"
});

CREATE (:Reservation {
    ReservationId: 1, 
    ReservationDescription: "Grave reservation", 
    ReservationDate: date("2023-04-01"), 
    ReservationExpirationDate: date("2023-06-01"), 
    ReservationStatus: "Active"
});

CREATE (:User {
    UserId: 1, 
    UserFirstName: "Alice", 
    UserLastName: "Smith", 
    UserEmail: "alice.smith@example.com", 
    UserPassword: "password123", 
    UserPhoneNumber: "+123456789", 
    UserRole: "Administrator"
});

CREATE (:Service {
    ServiceId: 1, 
    ServiceName: "Grave Maintenance", 
    ServiceDescription: "Regular cleaning and flower placement", 
    ServicePrice: 50.00
});

CREATE (:DeceasedHistory {
    DeceasedHistoryId: 1, 
    HistoryDescription: "Documented life achievements and milestones", 
    DateAdded: date("2023-05-02")
});

CREATE (:Subscription {
    SubscriptionId: 1, 
    ServiceStartTime: date("2023-05-01"), 
    ServiceEndTime: date("2023-05-31")
});

CREATE (:Purchase {
    PurchaseId: 1
});



CREATE CONSTRAINT FOR (s:Sector) REQUIRE s.SectorId IS UNIQUE;
CREATE CONSTRAINT FOR (f:Faith) REQUIRE f.FaithName IS UNIQUE;
CREATE CONSTRAINT FOR (m:Monument) REQUIRE m.MonumentId IS UNIQUE;
CREATE CONSTRAINT FOR (g:Gate) REQUIRE g.GateId IS UNIQUE;
CREATE CONSTRAINT FOR (c:Camera) REQUIRE c.CameraId IS UNIQUE;
CREATE CONSTRAINT FOR (gr:Grave) REQUIRE gr.GraveId IS UNIQUE;
CREATE CONSTRAINT FOR (ch:Chapel) REQUIRE ch.ChapelId IS UNIQUE;
CREATE CONSTRAINT FOR (fu:Funeral) REQUIRE fu.FuneralId IS UNIQUE;
CREATE CONSTRAINT FOR (d:Deceased) REQUIRE d.DeceasedId IS UNIQUE;
CREATE CONSTRAINT FOR (p:Payment) REQUIRE p.PaymentId IS UNIQUE;
CREATE CONSTRAINT FOR (r:Reservation) REQUIRE r.ReservationId IS UNIQUE;
CREATE CONSTRAINT FOR (u:User) REQUIRE u.UserId IS UNIQUE;
CREATE CONSTRAINT FOR (se:Service) REQUIRE se.ServiceId IS UNIQUE;
CREATE CONSTRAINT FOR (dh:DeceasedHistory) REQUIRE dh.DeceasedHistoryId IS UNIQUE;
CREATE CONSTRAINT FOR (sub:Subscription) REQUIRE sub.SubscriptionId IS UNIQUE;
CREATE CONSTRAINT FOR (pu:Purchase) REQUIRE pu.PurchaseId IS UNIQUE;

MATCH (s:Sector), (f:Faith) CREATE (s)-[:HAS_FAITH]->(f);
MATCH (m:Monument), (s:Sector) CREATE (m)-[:LOCATED_IN]->(s);
MATCH (g:Gate), (s:Sector) CREATE (g)-[:LOCATED_IN]->(s);
MATCH (c:Camera), (s:Sector) CREATE (c)-[:LOCATED_IN]->(s);
MATCH (gr:Grave), (s:Sector) CREATE (gr)-[:LOCATED_IN]->(s);
MATCH (ch:Chapel), (s:Sector) CREATE (ch)-[:LOCATED_IN]->(s);
MATCH (fu:Funeral), (ch:Chapel) CREATE (fu)-[:USES]->(ch);
MATCH (fu:Funeral), (d:Deceased) CREATE (fu)-[:FOR]->(d);
MATCH (fu:Funeral), (p:Payment) CREATE (fu)-[:PAID_BY]->(p);
MATCH (d:Deceased), (gr:Grave) CREATE (d)-[:BURIED_IN]->(gr);
MATCH (d:Deceased), (f:Faith) CREATE (d)-[:BELIVES]->(f);
MATCH (r:Reservation), (gr:Grave) CREATE (r)-[:RESERVES]->(gr);
MATCH (r:Reservation), (u:User) CREATE (r)-[:MADE_BY]->(u);
MATCH (r:Reservation), (p:Payment) CREATE (r)-[:PAID_BY]->(p);
MATCH (dh:DeceasedHistory), (d:Deceased) CREATE (dh)-[:HISTORY_OF]->(d);
MATCH (sub:Subscription), (gr:Grave) CREATE (sub)-[:FOR]->(gr);
MATCH (sub:Subscription), (se:Service) CREATE (sub)-[:USES]->(se);
MATCH (sub:Subscription), (p:Payment) CREATE (sub)-[:PAID_BY]->(p);
MATCH (pu:Purchase), (u:User) CREATE (pu)-[:MADE_BY]->(u);
MATCH (pu:Purchase), (se:Service) CREATE (pu)-[:FOR]->(se);

//Zapytania
//Informacje o wszystkich kamerach zainstalowanych w sektorze Edukacja:
MATCH (c:Camera)-[:LOCATED_IN]->(s:Sector {SectorName: "Education"})
RETURN c.CameraId, c.CameraModel, c.InstallationDate;

//Wyświeltenie wszyskitch nodeów i relacji
MATCH (n)-[r]->(m) RETURN n,r,m;

// Informacje o wszystkich pogrzebach, które odbyły się w określonej kaplicy:
MATCH (ch:Chapel {ChapelName: "Saint Paul's Chapel"})<-[:USES]-(fu:Funeral)
RETURN fu.FuneralId, fu.FuneralDate, fu.FuneralDescription;

MATCH (fu:Funeral)-[:USES]->(ch:Chapel {ChapelName: "Saint Paul's Chapel"})
RETURN fu.FuneralId, fu.FuneralDate, fu.FuneralDescription;


