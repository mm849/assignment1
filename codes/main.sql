-- TASK 2
CREATE TABLE Location (
	ID INT AUTO_INCREMENT,
    Name VARCHAR(30),
    Categories VARCHAR(30),
    PRIMARY KEY (ID)
);


CREATE TABLE Bonuses (
    Name VARCHAR(30) NOT NULL,
    LocationID INT NOT NULL,
    Description TINYTEXT,
    FOREIGN KEY (LocationID)
		REFERENCES Location(ID),
	PRIMARY KEY(Name)
);

CREATE TABLE Properties (
    Name VARCHAR(30) NOT NULL,
    Location_ID INT NOT NULL,
    cost INT DEFAULT 0,
    colour VARCHAR(30) NOT NULL,
    FOREIGN KEY (Location_ID)
		REFERENCES Location(ID),
    PRIMARY KEY (Name)
);

CREATE TABLE Tokens (
	Name VARCHAR(30) NOT NULL,
    PRIMARY KEY (Name)
);
    
CREATE TABLE Players (
	ID INT AUTO_INCREMENT NOT NULL,
    Name VARCHAR(30) NOT NULL,
    PRIMARY KEY (ID)
);

-- Trigger to check the number of players
DELIMITER /
CREATE TRIGGER checkNumPlayers
BEFORE INSERT ON Players 
	FOR EACH ROW
		BEGIN
			IF NEW.ID >6 THEN 
            SIGNAL SQLSTATE '10001' SET MESSAGE_TEXT = 'Max num of players is 6.';
            DELETE FROM Players WHERE ID>6;
		END IF;
	END /
DELIMITER ;


CREATE TABLE TokenOwner (
	TokenName VARCHAR(30) NOT NULL,
    OwnerID INT NOT NULL,
    PRIMARY KEY (TokenName, OwnerID),
    FOREIGN KEY (TokenName)
		REFERENCES Tokens(Name),
	FOREIGN KEY (OwnerID)
		REFERENCES Players(ID)
);

CREATE TABLE PropertiesOwner (
	PropertyName VARCHAR(30) NOT NULL,
    OwnerID INT DEFAULT NULL,
    PRIMARY KEY (PropertyName),
    FOREIGN KEY (PropertyName)
		REFERENCES Properties(Name),
	FOREIGN KEY (OwnerID)
		REFERENCES Players(ID)
);



-- Records
CREATE TABLE BaseAudit (
	TurnID INT AUTO_INCREMENT,
    RoundNum INT NOT NULL,
    ActivePlayerID INT NOT NULL,
    DieRoll INT DEFAULT 0,
    PRIMARY KEY (TurnID, RoundNum),
    FOREIGN KEY (ActivePlayerID)
		REFERENCES Players(ID)
);


CREATE TABLE CurrentSituation (
	PlayerID INT NOT NULL,
    CurrentLocationID INT NOT NULL,
    CurrentBankBalance INT DEFAULT 0,
    FOREIGN KEY (PlayerId)
		REFERENCES Players(ID),
	FOREIGN KEY (CurrentLocationID)
		REFERENCES Location(ID),
	PRIMARY KEY (PlayerID)
);


CREATE TABLE AuditTrail (
	TurnID INT NOT NULL,
	PlayerID INT NOT NULL,
    LocationLandedOn INT NOT NULL,
    CurrentBankBalance INT DEFAULT 0,
    NumberOfGameRound INT DEFAULT 0,
    FOREIGN KEY (PlayerID)
		REFERENCES Players(ID),
	FOREIGN KEY (LocationLandedOn)
		REFERENCES Location(ID),
	FOREIGN KEY (TurnID)
		REFERENCES BaseAudit(TurnID),
	PRIMARY KEY (TurnID)
);

/*
-- Trigger to update CurrentSituation
DELIMITER / 
CREATE TRIGGER updateCurrentSituation
AFTER INSERT ON BaseAudit
	FOR EACH ROW
	BEGIN 
		-- Update Location
		SET @formerLocation = (
			SELECT CurrentLocationID FROM CurrentSituation
			WHERE PlayerID = NEW.ActivePlayerID
		);
        IF @formerLocation != 5 THEN
			SET @newLocation = @formerLocation+NEW.DieRoll;
        ELSEIF @formerLocation = 5 AND NEW.DieRoll > 6 THEN
			SET @newLocation = @formerLocation+NEW.DieRoll-6;
		ELSEIF @formerLocation = 5 AND NEW.DieRoll < 6 THEN
			SET @newLocation = @formerLocation;
		END IF ;
	
        IF @newLocation<=16 THEN
			SET @modifiedNewLocation = @newLocation;
		ELSE
			CALL go(NEW.ActivePlayerID);
			SET @modifiedNewLocation = @newLocation-16;
		END IF ;
		UPDATE CurrentSituation
			SET CurrentLocationID = @modifiedNewLocation
			WHERE PlayerID = NEW.ActivePlayerID;
		
        -- Procedures for Bonuses
        IF @modifiedNewLocation = 3 THEN
			CALL chance1(NEW.ActivePlayerID);
		ELSEIF @modifiedNewLocation = 11 THEN
			CALL chance2(NEW.ActivePlayerID);
		ELSEIF @modifiedNewLocation = 7 THEN
			CALL chest1(NEW.ActivePlayerID);
		ELSEIF @modifiedNewLocation = 15 THEN
			CALL chest2(NEW.ActivePlayerID);
		ELSEIF @modifiedNewLocation = 13 THEN
			CALL goToJail(NEW.ActivePlayerID);
		END IF ;
        -- Procedures for Properties
        SET @finalLocation = (SELECT CurrentLocationID FROM CurrentSituation WHERE PlayerID = NEW.ActivePlayerID);
        IF @finalLocation = 2 OR 
			@finalLocation = 4 OR 
            @finalLocation = 6 OR 
            @finalLocation = 8 OR 
            @finalLocation = 10 OR
            @finalLocation = 12 OR 
            @finalLocation = 14 OR
            @finalLocation = 16 THEN 
			CALL setPropertyVariables(NEW.ActivePlayerID);
			CALL property(NEW.ActivePlayerID);
		END IF ;
	END /
DELIMITER ;
*/

SHOW TRIGGERS;


-- test
DELIMITER / 
CREATE TRIGGER updateCurrentSituation
AFTER INSERT ON BaseAudit
	FOR EACH ROW
	BEGIN 
		-- Update Location
		SET @formerLocation = (
			SELECT CurrentLocationID FROM CurrentSituation
			WHERE PlayerID = NEW.ActivePlayerID
		);
        IF @formerLocation != 5 THEN
			SET @newLocation = @formerLocation+NEW.DieRoll;
        ELSEIF @formerLocation = 5 AND NEW.DieRoll > 6 THEN
			SET @newLocation = @formerLocation+NEW.DieRoll-6;
		ELSEIF @formerLocation = 5 AND NEW.DieRoll < 6 THEN
			SET @newLocation = @formerLocation;
		END IF ;
	
        IF @newLocation<=16 THEN
			SET @modifiedNewLocation = @newLocation;
		ELSE
			CALL go(NEW.ActivePlayerID);
			SET @modifiedNewLocation = @newLocation-16;
		END IF ;
		UPDATE CurrentSituation
			SET CurrentLocationID = @modifiedNewLocation
			WHERE PlayerID = NEW.ActivePlayerID;
		
		-- Procedures for Bonuses
        IF @modifiedNewLocation = 3 THEN
			CALL chance1(NEW.ActivePlayerID);
		ELSEIF @modifiedNewLocation = 11 THEN
			CALL chance2(NEW.ActivePlayerID);
		ELSEIF @modifiedNewLocation = 7 THEN
			CALL chest1(NEW.ActivePlayerID);
		ELSEIF @modifiedNewLocation = 15 THEN
			CALL chest2(NEW.ActivePlayerID);
		ELSEIF @modifiedNewLocation = 13 THEN
			CALL goToJail(NEW.ActivePlayerID);
		END IF ;
        
        -- Procedures for Properties
        SET @finalLocationID = (SELECT CurrentLocationID FROM CurrentSituation WHERE PlayerID = NEW.ActivePlayerID);
        SET @finalLocationCategory = (SELECT Categories FROM Location WHERE ID = @finalLocationID);
        IF @finalLocationCategory = "Property" THEN
			CALL setPropertyVariables(NEW.ActivePlayerID);
			CALL property(NEW.ActivePlayerID);
		END IF ;

		-- Update AuditTrail
        SET @currentBankBalance = (SELECT CurrentBankBalance FROM CurrentSItuation WHERE PlayerID = NEW.ActivePlayerID);
		INSERT INTO AuditTrail
		VALUES
			(NEW.TurnID, NEW.ActivePlayerID, @finalLocationID, @currentBankBalance, NEW.RoundNum);
	END /
DELIMITER ;



/*
CREATE TABLE Player1Audit (
	TurnID INT NOT NULL,
    RoundNum INT NOT NULL,
    IsActive BOOL,
    LocationID INT NOT NULL,
    CurrentBankBalance INT DEFAULT 0,
    PRIMARY KEY (TurnID, RoundNum),
    FOREIGN KEY (TurnID, RoundNum)
		REFERENCES BaseAudit(TurnID, RoundNum)
);

DELIMITER / -- Trigger to update Player1's audit
CREATE TRIGGER updatePlayer1Audit
AFTER INSERT ON BaseAudit 
	FOR EACH ROW
		BEGIN
			IF NEW.ActivePlayerID=1 THEN
				-- SET @newLocation = 4;
                -- SET @newBankBalance = 100;
				INSERT INTO Player1Audit
				VALUE 
					(NEW.TurnID, NEW.RoundNum, NEW.ThrowNum, 1, 4, 100);
			ELSE
				INSERT INTO Player1Audit
                VALUE
					(NEW.TurnID, NEW.RoundNum, NEW.ThrowNum, 0, 5, 200);
		END IF;
	END /
DELIMITER ;

*/

/*
CREATE VIEW overview AS
	SELECT ba.RoundNum, ba.TurnID, ba.ActivePlayerID, ba.DieRoll
    FROM BaseAudit AS ba
    ORDER BY ba.TurnID DESC
    LIMIT 1;
*/

CREATE VIEW gameView AS
	SELECT COUNT(DISTINCT ba.RoundNum) AS Round, p.Name, lo.Name AS Location, cs.CurrentBankBalance, GROUP_CONCAT(DISTINCT(po.PropertyName)) AS Property
	FROM Players AS p
	LEFT JOIN CurrentSituation AS cs ON cs.PlayerID = p.ID
    LEFT JOIN Location AS lo ON lo.ID = cs.CurrentLocationID
	LEFT JOIN PropertiesOwner AS po ON p.ID = po.OwnerID
	LEFT JOIN BaseAudit AS ba ON p.ID = ba.ActivePlayerID
	GROUP BY p.ID;

SELECT * FROM BaseAudit;

SELECT ActivePlayerID, COUNT(DISTINCT RoundNum)
FROM BaseAudit
GROUP BY ActivePlayerID;


SELECT p.Name, cs.CurrentLocationID, cs.CurrentBankBalance, GROUP_CONCAT(po.PropertyName), COUNT(DISTINCT ba.RoundNum)
FROM Players AS p
LEFT JOIN CurrentSituation AS cs ON cs.PlayerID = p.ID
LEFT JOIN PropertiesOwner AS po ON p.ID = po.OwnerID
LEFT JOIN BaseAudit AS ba ON p.ID = ba.ActivePlayerID
GROUP BY p.ID;
    
SHOW TRIGGERS;