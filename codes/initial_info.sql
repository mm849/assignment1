
INSERT INTO Location(Name, Categories)
VALUES
	('GO', 'Other'),
    ('Kilburn', 'Property'),
    ('CHANCE 1', 'Bonuse'),
    ('Uni Place', 'Property'),
    ('JAIL', 'Other'),
    ('Victoria', 'Property'),
    ('COMMUNITY CHEST 1', 'Bonuse'),
    ('Piccadilly', 'Property'),
    ('FREE PARKING', 'Other'),
    ('Oak House', 'Property'),
    ('CHANCE 2', 'Bonuse'),
    ('Owens Park', 'Property'),
    ('GO TO JAIL', 'Other'),
    ('AMBS', 'Property'),
    ('COMMUNITY CHEST 2', 'Bonuse'),
    ('Co-op', 'Property');

INSERT INTO Bonuses
VALUES
	('Chance 1', 3, 'Pay each of the other players £50'), 
    ('Chance 2', 11, 'Move forward 3 spaces'),
    ('Community Chest 1', 7, 'For winning a Beauty Contest, you win £100'),
    ('Community Chest 2', 15, 'Your library books are overdue. Play a fine of £30'),
    ('Free Parking', 9, 'No action'),
    ('Go to Jail', 13, 'Go to Jail, do not pass GO, do not collect £200'),
    ('GO', 1, 'Collect £200');
    
INSERT INTO Properties
VALUES
	('Oak House', 10, 100, 'Orange'),
    ('Owens Park', 12, 30, 'Orange'),
    ('AMBS', 14, 400, 'Blue'),
    ('Co-Op', 16, 30, 'Blue'),
    ('Kilburn', 2, 120, 'Yellow'),
    ('Uni Place', 4, 100, 'Yellow'),
    ('Victoria', 6, 75, 'Green'),
    ('Piccadilly', 8, 35, 'Green');

INSERT INTO Tokens
VALUES
	('Dog'),
    ('Car'),
    ('Battleship'),
    ('Top hat'),
    ('Thimble'),
    ('Boot');
    
INSERT INTO Players(Name)
VALUES
	('Mary'),
    ('Bill'),
    ('Jane'),
    ('Norman');
    
INSERT INTO TokenOwner
VALUES
	('Battleship', 1),
    ('Dog', 2),
    ('Car', 3),
    ('Thimble', 4);

INSERT INTO PropertiesOwner
VALUES
	('Oak House', 4),
    ('Owens Park', 4),
    ('AMBS', NULL),
    ('Co-Op', 3),
    ('Kilburn',NULL),
    ('Uni Place', 1),
    ('Victoria', 2),
    ('Piccadilly', NULL);
    
INSERT INTO CurrentSituation
VALUES
	(1, 9, 190),
    (2, 12, 500),
    (3, 14, 150),
    (4, 2, 250);
    
