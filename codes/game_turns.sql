-- Round 1
INSERT INTO BaseAudit
	VALUES (0, 1, 3, 3);
SELECT * FROM BaseAudit;
SELECT * FROM CurrentSituation;
SELECT * FROM gameview;
SELECT * FROM AuditTrail;


INSERT INTO BaseAudit
	VALUES (0, 1, 4, 1);
SELECT * FROM BaseAudit;
SELECT * FROM CurrentSituation;
SELECT * FROM gameview;
SELECT * FROM AuditTrail;


INSERT INTO BaseAudit
	VALUES (0, 1, 1, 4);
SELECT * FROM BaseAudit;
SELECT * FROM CurrentSituation;
SELECT * FROM gameview;
SELECT * FROM AuditTrail;


INSERT INTO BaseAudit (RoundNum, ActivePlayerID, DieRoll)
	VALUES (1, 2, 2);
SELECT * FROM BaseAudit;
SELECT * FROM CurrentSituation;
SELECT * FROM PropertiesOwner;
SELECT * FROM gameview;
SELECT * FROM AuditTrail;


-- Round 2
INSERT INTO BaseAudit (RoundNum, ActivePlayerID, DieRoll)
	VALUES (2, 3, 5);
SELECT * FROM BaseAudit;
SELECT * FROM CurrentSituation;
SELECT * FROM gameview;
SELECT * FROM AuditTrail;


INSERT INTO BaseAudit (RoundNum, ActivePlayerID, DieRoll)
	VALUES (2, 4, 4);
SELECT * FROM BaseAudit;
SELECT * FROM CurrentSituation;
SELECT * FROM gameview;
SELECT * FROM AuditTrail;


INSERT INTO BaseAudit (RoundNum, ActivePlayerID, DieRoll)
	VALUES (2, 1, 11);
SELECT * FROM BaseAudit;
SELECT * FROM CurrentSituation;
SELECT * FROM gameview;
SELECT * FROM AuditTrail;


INSERT INTO BaseAudit (RoundNum, ActivePlayerID, DieRoll)
	VALUES (2, 2, 9);
SELECT * FROM BaseAudit;
SELECT * FROM CurrentSituation;
SELECT * FROM gameview;
SELECT * FROM AuditTrail;
