-- Indexes
CREATE INDEX idx_subscription_serviceid ON "Subscription" ("FK_ServiceId");
CREATE INDEX idx_service_serviceid ON "Service" ("ServiceId"); -- for join
CREATE INDEX idx_subscription_servicestarttime ON "Subscription" ("ServiceStartTime");
CREATE INDEX idx_subscription_serviceendtime ON "Subscription" ("ServiceEndTime"); -- for calculating duration and sorting

CREATE INDEX idx_reservation_date ON "Reservation" ("ReservationDate"); -- for where

CREATE INDEX idx_deceased_graveid ON "Deceased" ("FK_GraveId");
CREATE INDEX idx_grave_graveid ON "Grave" ("GraveId");
CREATE INDEX idx_grave_sectorid ON "Grave" ("FK_SectorId");
CREATE INDEX idx_sector_sectorid ON "Sector" ("SectorId"); -- for joins
CREATE INDEX idx_sector_name ON "Sector" ("SectorName");
CREATE INDEX idx_faith_name ON "Faith" ("FaithName"); -- for where

CREATE INDEX idx_chapel_sectorid ON "Chapel" ("FK_SectorId"); -- for join
CREATE INDEX idx_funeral_chapelid ON "Funeral" ("FK_ChapelId"); -- for join
CREATE INDEX idx_sector_name2 ON "Sector" ("SectorName"); --for where
CREATE INDEX idx_funeral_date ON "Funeral" ("FuneralDate");
CREATE INDEX idx_chapel_name2 ON "Chapel" ("ChapelName"); -- for where

CREATE INDEX idx_service_serviceid2 ON "Service" ("ServiceId");
CREATE INDEX idx_purchase_serviceid ON "Purchase" ("FK_ServiceId"); -- join
CREATE INDEX idx_user_userid ON "User" ("UserId"); -- for join
CREATE INDEX idx_purchase_userid ON "Purchase" ("FK_UserId"); -- for join
CREATE INDEX idx_user_email ON "User" ("UserEmail"); -- for where
CREATE INDEX idx_service_serviceprice ON "Service" ("ServicePrice"); -- for where

CREATE INDEX idx_user_userid2 ON "User" ("UserId"); -- for where
CREATE INDEX idx_purchase_userid2 ON "Purchase" ("FK_UserId"); -- for join
CREATE INDEX idx_service_serviceid3 ON "Service" ("ServiceId");

CREATE INDEX idx_deceased_faithname ON "Deceased" ("FK_FaithName"); -- for join
CREATE INDEX idx_faith_faithname ON "Faith" ("FaithName");
CREATE INDEX idx_deceased_deceasedid ON "Deceased" ("DeceasedId");
CREATE INDEX idx_funeral_deceasedid ON "Funeral" ("FK_DeceasedId");
CREATE INDEX idx_funeral_funeralid ON "Funeral" ("FuneralId");

CREATE INDEX idx_reservation_graveid ON "Reservation" ("FK_GraveId");
CREATE INDEX idx_grave_graveid2 ON "Grave" ("GraveId");
CREATE INDEX idx_reservation_userid ON "Reservation" ("FK_UserId");

CREATE INDEX idx_deceased_deceasedid2 ON "Deceased" ("DeceasedId");
CREATE INDEX idx_deceasedhistory_deceasedid ON "DeceasedHistory" ("FK_DeceasedId");
CREATE INDEX idx_deceased_firstname ON "Deceased" ("DeceasedFirstName");
CREATE INDEX idx_deceased_lastname ON "Deceased" ("DeceasedLastName");

CREATE INDEX idx_subscription_serviceid2 ON "Subscription" ("FK_ServiceId");
CREATE INDEX idx_service_serviceid4 ON "Service" ("ServiceId");
CREATE INDEX idx_subscription_paymentid ON "Subscription" ("FK_PaymentId");
CREATE INDEX idx_payment_paymentid ON "Payment" ("PaymentId");
CREATE INDEX idx_subscription_graveid ON "Subscription" ("FK_GraveId");