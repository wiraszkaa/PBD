:param sector_id => 1;
:param sector_name => "Education";
:param sector_description => "Sector focusing on educational services";
:param faith_name => "Christianity";

:param faith_description => "A spiritual tradition that focuses on personal spiritual development and the attainment of a deep insight into the true nature of life.";
:param believers_count => 520000000;

:param monument_id => 1;
:param monument_name => "Liberty Statue";
:param monument_description => "A famous monument located in New York City";
:param monument_sector_id => 1;

:param gate_id => 1;
:param gate_name => "Main Entrance";
:param gate_description => "The primary entrance for visitors";
:param opening_hours => "09:00 - 17:00";
:param gate_sector_id => 1;

:param camera_id => 1;
:param camera_model => "Nikon D3500";
:param camera_manufacturer => "Nikon";
:param installation_date => date("2023-01-01");
:param is_dummy => false;
:param camera_sector_id => 1;

:param grave_id => 1;
:param grave_type => "Single";
:param grave_status => "Occupied";
:param payment_expiration_date => date("2024-01-01");
:param grave_sector_id => 1;

:param chapel_id => 1;
:param chapel_name => "Saint Paul's Chapel";
:param architectural_style => "Gothic";
:param chapel_sector_id => 1;

:param funeral_id => 1;
:param funeral_date => date("2023-05-01");
:param funeral_description => "Funeral of a renowned philanthropist";
:param funeral_chapel_id => 1;
:param funeral_deceased_id => 1;
:param funeral_payment_id => 1;

:param deceased_id => 1;
:param deceased_first_name => "John";
:param deceased_last_name => "Doe";
:param date_of_death => date("2023-04-30");
:param date_of_birth => date("1950-01-01");
:param cause_of_death => "Natural causes";
:param deceased_pesel => "12345678901";
:param deceased_grave_id => 1;
:param deceased_faith_name => 1;

:param payment_id => 1;
:param amount => 100.00;
:param payment_date => date("2023-05-01");
:param payment_status => "Completed";
:param payment_method => "Credit Card";
:param payment_description => "Funeral service payment";

:param reservation_id => 1;
:param reservation_description => "Grave reservation";
:param reservation_date => date("2023-04-01");
:param reservation_expiration_date => date("2023-06-01");
:param reservation_status => "Active";
:param reservation_user_id => 1;
:param reservation_grave_id => 1;
:param reservation_payment_id => 1;

:param user_id => 1;
:param user_first_name => "Alice";
:param user_last_name => "Smith";
:param user_email => "alice.smith@example.com";
:param user_password => "password123";
:param user_phone_number => "+123456789";
:param user_role => "Administrator";

:param service_id => 1;
:param service_name => "Grave Maintenance";
:param service_description => "Regular cleaning and flower placement";
:param service_price => 50.00;

:param deceased_history_id => 1;
:param history_description => "Documented life achievements and milestones";
:param date_added => date("2023-05-02");
:param deceased_history_deceased_id => 1;

:param subscription_id => 1;
:param service_start_time => date("2023-05-01");
:param service_end_time => date("2023-05-31");
:param subscription_grave_id => 1;
:param subscription_service_id => 1;
:param subscription_payment_id => 1;

:param purchase_id => 1;
:param purchase_service_id => 1;
:param purchase_user_id => 1;

CREATE (:Sector {
    SectorId: 1,
    SectorName: $sector_name,
    SectorDescription: $sector_description,
    FK_FaithName: $faith_name
});

CREATE (:Faith {
    FaithName: $faith_name,
    FaithDescription: $faith_description,
    NumberOfBelievers: $believers_count
});

CREATE (:Monument {
    MonumentId: $monument_id,
    MonumentName: $monument_name,
    MonumentDescription: $monument_description,
    FK_SectorId: $monument_sector_id
});

CREATE (:Gate {
    GateId: $gate_id,
    GateName: $gate_name,
    GateDescription: $gate_description,
    OpeningHours: $opening_hours,
    FK_SectorId: $gate_sector_id
});

CREATE (:Camera {
    CameraId: $camera_id,
    CameraModel: $camera_model,
    CameraManufacturer: $camera_manufacturer,
    InstallationDate: $installation_date,
    IsDummy: $is_dummy,
    FK_SectorId: $camera_sector_id
});

CREATE (:Grave {
    GraveId: $grave_id,
    GraveType: $grave_type,
    GraveStatus: $grave_status,
    PaymentExpirationDate: $payment_expiration_date,
    FK_SectorId: $grave_sector_id
});

CREATE (:Chapel {
    ChapelId: $chapel_id,
    ChapelName: $chapel_name,
    ArchitecturalStyle: $architectural_style,
    FK_SectorId: $chapel_sector_id
});

CREATE (:Funeral {
    FuneralId: $funeral_id,
    FuneralDate: $funeral_date,
    FuneralDescription: $funeral_description,
    FK_ChapelId: $funeral_chapel_id,
    FK_DeceasedId: $funeral_deceased_id,
    FK_PaymentId: $funeral_payment_id
});

CREATE (:Deceased {
    DeceasedId: $deceased_id,
    DeceasedFirstName: $deceased_first_name,
    DeceasedLastName: $deceased_last_name,
    DateOfDeath: $date_of_death,
    DateOfBirth: $date_of_birth,
    CauseOfDeath: $cause_of_death,
    DeceasedPESEL: $deceased_pesel,
    FK_GraveId: $deceased_grave_id,
    FK_FaithName: $deceased_faith_name
});

CREATE (:Payment {
    PaymentId: $payment_id,
    Amount: $amount,
    PaymentDate: $payment_date,
    PaymentStatus: $payment_status,
    PaymentMethod: $payment_method,
    PaymentDescription: $payment_description
});

CREATE (:Reservation {
    ReservationId: $reservation_id,
    ReservationDescription: $reservation_description,
    ReservationDate: $reservation_date,
    ReservationExpirationDate: $reservation_expiration_date,
    ReservationStatus: $reservation_status,
    FK_UserId: $reservation_user_id,
    FK_GraveId: $reservation_grave_id,
    FK_PaymentId: $reservation_payment_id
});

CREATE (:User {
    UserId: $user_id,
    UserFirstName: $user_first_name,
    UserLastName: $user_last_name,
    UserEmail: $user_email,
    UserPassword: $user_password,
    UserPhoneNumber: $user_phone_number,
    UserRole: $user_role
});

CREATE (:Service {
    ServiceId: $service_id,
    ServiceName: $service_name,
    ServiceDescription: $service_description,
    ServicePrice: $service_price
});

CREATE (:DeceasedHistory {
    DeceasedHistoryId: $deceased_history_id,
    HistoryDescription: $history_description,
    DateAdded: $date_added,
    FK_DeceasedId: $deceased_history_deceased_id
});

CREATE (:Subscription {
    SubscriptionId: $subscription_id,
    ServiceStartTime: $service_start_time,
    ServiceEndTime: $service_end_time,
    FK_GraveId: $subscription_grave_id,
    FK_ServiceId: $subscription_service_id,
    FK_PaymentId: $subscription_payment_id
});

CREATE (:Purchase {
    PurchaseId: $purchase_id,
    FK_ServiceId: $purchase_service_id,
    FK_UserId: $purchase_user_id
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

MATCH (s:Sector), (f:Faith) WHERE s.FK_FaithName = f.FaithName CREATE (s)-[:HAS_FAITH]->(f);
MATCH (m:Monument), (s:Sector) WHERE m.FK_SectorId = s.SectorId CREATE (m)-[:LOCATED_IN]->(s);
MATCH (g:Gate), (s:Sector) WHERE g.FK_SectorId = s.SectorId CREATE (g)-[:LOCATED_IN]->(s);
MATCH (c:Camera), (s:Sector) WHERE c.FK_SectorId = s.SectorId CREATE (c)-[:LOCATED_IN]->(s);
MATCH (gr:Grave), (s:Sector) WHERE gr.FK_SectorId = s.SectorId CREATE (gr)-[:LOCATED_IN]->(s);
MATCH (ch:Chapel), (s:Sector) WHERE ch.FK_SectorId = s.SectorId CREATE (ch)-[:LOCATED_IN]->(s);
MATCH (fu:Funeral), (ch:Chapel) WHERE fu.FK_ChapelId = ch.ChapelId CREATE (fu)-[:USES]->(ch);
MATCH (fu:Funeral), (d:Deceased) WHERE fu.FK_DeceasedId = d.DeceasedId CREATE (fu)-[:FOR]->(d);
MATCH (fu:Funeral), (p:Payment) WHERE fu.FK_PaymentId = p.PaymentId CREATE (fu)-[:PAID_BY]->(p);
MATCH (d:Deceased), (gr:Grave) WHERE d.FK_GraveId = gr.GraveId CREATE (d)-[:BURIED_IN]->(gr);
MATCH (d:Deceased), (f:Faith) WHERE d.FK_FaithName = f.FaithName CREATE (d)-[:FOLLOWS]->(f);
MATCH (r:Reservation), (gr:Grave) WHERE r.FK_GraveId = gr.GraveId CREATE (r)-[:RESERVES]->(gr);
MATCH (r:Reservation), (u:User) WHERE r.FK_UserId = u.UserId CREATE (r)-[:MADE_BY]->(u);
MATCH (r:Reservation), (p:Payment) WHERE r.FK_PaymentId = p.PaymentId CREATE (r)-[:PAID_BY]->(p);
MATCH (dh:DeceasedHistory), (d:Deceased) WHERE dh.FK_DeceasedId = d.DeceasedId CREATE (dh)-[:HISTORY_OF]->(d);
MATCH (sub:Subscription), (gr:Grave) WHERE sub.FK_GraveId = gr.GraveId CREATE (sub)-[:FOR]->(gr);
MATCH (sub:Subscription), (se:Service) WHERE sub.FK_ServiceId = se.ServiceId CREATE (sub)-[:USES]->(se);
MATCH (sub:Subscription), (p:Payment) WHERE sub.FK_PaymentId = p.PaymentId CREATE (sub)-[:PAID_BY]->(p);
MATCH (pu:Purchase), (u:User) WHERE pu.FK_UserId = u.UserId CREATE (pu)-[:MADE_BY]->(u);
MATCH (pu:Purchase), (se:Service) WHERE pu.FK_ServiceId = se.ServiceId CREATE (pu)-[:FOR]->(se);
