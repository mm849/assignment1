
-- Procedure for GO
DELIMITER /
CREATE PROCEDURE go(
	IN activePlayerID INT
)
BEGIN
	UPDATE CurrentSituation
    SET CurrentBankBalance = CurrentBankBalance+200
    WHERE PlayerID = activePlayerID;
END /
DELIMITER ;


-- Procedure for Chance1
DELIMITER / 
CREATE PROCEDURE chance1(
	IN activePlayerID INT
)
BEGIN
	UPDATE CurrentSituation
		SET CurrentBankBalance = CurrentBankBalance+50
        WHERE PlayerID != activePlayerID;
	UPDATE CurrentSituation
		SET CurrentBankBalance = CurrentBankBalance-50*((SELECT COUNT(*) FROM Players)-1)
        WHERE PlayerID = activePlayerID;
END /
DELIMITER ;


-- Procedure for Chance2
DELIMITER /
CREATE PROCEDURE chance2(
	IN activePlayerID INT
)
BEGIN
	UPDATE CurrentSituation
		SET CurrentLocationID = 14
		WHERE PlayerID = activePlayerID;
END /
DELIMITER ;


-- Procedure for Community Chest 1
DELIMITER /
CREATE PROCEDURE chest1(
	IN activePlayerID INT
)
BEGIN
	UPDATE CurrentSituation
		SET CurrentBankBalance = CurrentBankBalance + 100
        WHERE PlayerID = activePlayerID;
END /
DELIMITER ;

-- Procedure for Community Chest 2
DELIMITER /
CREATE PROCEDURE chest2(
	IN activePlayerID INT
)
BEGIN
	UPDATE CurrentSituation
		SET CurrentBankBalance = CurrentBankBalance - 30
        WHERE PlayerID = activePlayerID;
END /
DELIMITER ;

-- Procedure for Go To JAIL
DELIMITER /
CREATE PROCEDURE goToJail(
	IN activePlayerID INT
)
BEGIN
	UPDATE CurrentSituation
    SET CurrentLocationID = 5
    WHERE PlayerID = activePlayerID;
END /
DELIMITER ;


-- Procedure to set property variables
DELIMITER / 
CREATE PROCEDURE setPropertyVariables(
	IN activePlayerID INT
)
BEGIN
	SET @activePlayerLocation = (
		SELECT CurrentLocationID 
		FROM CurrentSituation 
        WHERE PlayerID = activePlayerID);
    SET @propName = (
		SELECT Name
		FROM Properties
		WHERE Location_ID=@activePlayerLocation);
    SET @ownerOfProp = (
		SELECT po.OwnerID 
        FROM PropertiesOwner AS po 
        LEFT JOIN Properties AS p ON po.PropertyName = p.Name
        WHERE p.Location_ID=@activePlayerLocation);
	SET @colour = (
		SELECT p.colour
        FROM Properties AS p
        LEFT JOIN PropertiesOwner AS po ON po.PropertyName = p.Name
        WHERE p.Location_ID=@activePlayerLocation);
	SET @cost = (
		SELECT p.cost
        FROM Properties AS p
        LEFT JOIN PropertiesOwner AS po ON po.PropertyName = p.Name
        WHERE p.Location_ID=@activePlayerLocation);
	SET @ownerOfTheOtherProp = (
		SELECT po.OwnerID
        FROM PropertiesOwner AS po
        LEFT JOIN Properties AS p ON po.PropertyName = p.Name
        WHERE p.colour = @colour AND p.Location_ID!=@activePlayerLocation);
END /
DELIMITER ;


-- Procedure for Property
DELIMITER / 
CREATE PROCEDURE property(
	IN activePlayerID INT
)
BEGIN
    -- If no one owns the prop
    IF @ownerOfProp IS NULL THEN
		UPDATE CurrentSituation
			SET CurrentBankBalance = CurrentBankBalance - @cost
			WHERE PlayerID=activePlayerID;
		UPDATE PropertiesOwner
			SET OwnerID = activePlayerID
			WHERE PropertyName=@propname;
    -- If the active player owns the prop -> Nothing Happens
    -- If someone owns the prop but no one owns the other prop of the colour
	ELSEIF (@ownerOfProp!=activePlayerID AND @ownerOfTheOtherProp IS NULL) THEN
		UPDATE CurrentSituation
			SET CurrentBankBalance = CurrentBankBalance - @cost
			WHERE PlayerID=activePlayerID;
		UPDATE CurrentSituation
			SET CurrentBankBalance = CurrentBankBalance + @cost
			WHERE PlayerID=@ownerOfProp;    
    -- If someone owns the prop but not the other prop of the colour
	ELSEIF (@ownerOfProp!=activePlayerID AND @ownerOfProp!=@ownerOfTheOtherProp) THEN
		UPDATE CurrentSituation
			SET CurrentBankBalance = CurrentBankBalance - @cost
			WHERE PlayerID=activePlayerID;
		UPDATE CurrentSituation
			SET CurrentBankBalance = CurrentBankBalance + @cost
			WHERE PlayerID=@ownerOfProp;
	-- If someone owns the prop and the other prop of the colour
    ELSEIF (@ownerOfProp!=activePlayerID AND @ownerOfProp=@ownerOfTheOtherProp) THEN
		UPDATE CurrentSituation
			SET CurrentBankBalance = CurrentBankBalance - (@cost*2)
			WHERE PlayerID=activePlayerID;
		UPDATE CurrentSituation
			SET CurrentBankBalance = CurrentBankBalance + (@cost*2)
			WHERE PlayerID=@ownerOfProp;
	END IF ;
END /
DELIMITER ;

