
CREATE TABLE Pantheon (
    Name varchar(255) NOT NULL,
    Region varchar(255) NOT NULL,
    Primary Key(Name)
);
CREATE TABLE Class (
    Name varchar(255) NOT NULL,
    DamageType varchar(255) NOT NULL,
    TypicalAttack varchar(255) NOT NULL,
    Primary Key(Name)
);
CREATE TABLE Position (
    Name varchar(255) NOT NULL,
    Role varchar(255) NOT NULL,
    StartLocation varchar(255) NOT NULL,
    BuffCamp varchar(255),
    Primary Key(Name)
);

CREATE TABLE GodPool (
    Name varchar(255) NOT NULL,
    ID int NOT NULL,
    Pantheon varchar(255) NOT NULL,
    Class varchar(255) NOT NULL,
    Ability1 varchar(255) NOT NULL,
    Ability2 varchar(255) NOT NULL,
    Ability3 varchar(255) NOT NULL,
    Ability4 varchar(255) NOT NULL,
    Primary Key(Name),
    Foreign Key(Pantheon) References Pantheon(Name),
    Foreign Key(Class) References Class(Name),
    Foreign Key(Ability1) References Ability(Type),
    Foreign Key(Ability2) References Ability(Type),
    Foreign Key(Ability3) References Ability(Type),
    Foreign Key(Ability4) References Ability(Type)
);

CREATE TABLE Ability (
    Type varchar(255) NOT NULL,
    Purpose varchar(255) NOT NULL,
    Primary Key(Type)
);

CREATE TABLE PositionPlayed (
    Name varchar(255) NOT NULL,
    PrimaryPos varchar(255) NOT NULL,
    SecondaryPos varchar(255),
    Primary Key(Name),
    Foreign Key(PrimaryPos) References smite.Position(Name),
    Foreign Key(SecondaryPos) References smite.Position(Name)
);

ALTER TABLE godpool
ADD CHECK (id < 112);
ALTER TABLE class
ADD CHECK (DamageType IN ('Physical', 'Magical'));
ALTER TABLE class
ADD CHECK (TypicalAttack IN ('Ranged', 'Melee'));
ALTER TABLE position
ADD CHECK (Role IN ('Offence', 'Defence', 'Hybrid'));
ALTER TABLE position
ADD CHECK (
        StartLocation IN ('duel lane', 'mid lane', 'jungle', 'solo lane')
    );
ALTER TABLE ability
ADD CHECK (
        Purpose IN ('mobility', 'damage', 'support')
    );
INSERT INTO pantheon
VALUES('Arthurian', 'British Isles');
INSERT INTO pantheon
VALUES('Celtic', 'British Isles');
INSERT INTO pantheon
VALUES('Chinese', 'China');
INSERT INTO pantheon
VALUES('Egyptian', 'Egypt');
INSERT INTO pantheon
VALUES('Great Old Ones', 'Fiction');
INSERT INTO pantheon
VALUES('Greek', 'Greece');
INSERT INTO pantheon
VALUES('Hindu', 'Earth');
INSERT INTO pantheon
VALUES('Japanese', 'Japan');
INSERT INTO pantheon
VALUES('Mayan', 'America');
INSERT INTO pantheon
VALUES('Norse', 'Scandanavia');
INSERT INTO pantheon
VALUES('Polynesian', 'Polynesia');
INSERT INTO pantheon
VALUES('Roman', 'Rome');
INSERT INTO pantheon
VALUES('Slavic', 'Europe');
INSERT INTO pantheon
VALUES('Voodoo', 'Earth');
INSERT INTO pantheon
VALUES('Yoruba', 'Africa');
INSERT INTO class
VALUES('Hunter', 'Physical', 'Ranged');
INSERT INTO class
VALUES('Guardian', 'Magical', 'Melee');
INSERT INTO class
VALUES('Mage', 'Magical', 'Ranged');
INSERT INTO class
VALUES('Assassin', 'Physical', 'Melee');
INSERT INTO class
VALUES('Warrior', 'Physical', 'Melee');
INSERT INTO position
VALUES('ADC', 'Offence', 'Duel Lane', 'Purple');
INSERT INTO position
VALUES('Support', 'Defence', 'Duel Lane', NULL);
INSERT INTO position
VALUES('Mid', 'Offence', 'Mid Lane', 'Red');
INSERT INTO position
VALUES('Jungle', 'Offence', 'Jungle', 'Yellow');
INSERT INTO position
VALUES('Solo', 'Hybrid', 'Solo Lane', 'Blue');
INSERT INTO positionPlayed
VALUES('Ra', 'Mid', 'Support');
INSERT INTO positionPlayed
VALUES('Xbalanque', 'ADC', NULL);
INSERT INTO positionPlayed
VALUES('Ymir', 'Support', 'Solo');
INSERT INTO positionPlayed
VALUES('Hercules', 'Solo', 'Support');
INSERT INTO positionPlayed
VALUES('Bakasura', 'Jungle', 'Solo');
INSERT INTO positionPlayed
VALUES('Merlin', 'Mid', 'ADC');
INSERT INTO Ability
VALUES('Leap', 'Mobility');
INSERT INTO Ability
VALUES('Dash', 'Mobility');
INSERT INTO Ability
VALUES('Line', 'Damage');
INSERT INTO Ability
VALUES('Cone', 'Damage');
INSERT INTO Ability
VALUES('AOE', 'Damage');
INSERT INTO Ability
VALUES('Heal', 'Support');
INSERT INTO Ability
VALUES('Buff', 'Support');
INSERT INTO Ability
VALUES('Debuff', 'Support');
INSERT INTO Ability
VALUES('Wall', 'Support');
INSERT INTO Ability
VALUES('Stance Switch', 'Support');


INSERT INTO godpool
VALUES(
        'Ra',
        1,
        'Egyptian',
        'Mage',
        'Line',
        'AOE',
        'Heal',
        'Line'
    );


INSERT INTO godpool
VALUES(
        'Xbalanque',
        2,
        'Mayan',
        'Hunter',
        'Buff',
        'Cone',
        'Leap',
        'Debuff'
    );


INSERT INTO godpool
VALUES(
        'Ymir',
        3,
        'Norse',
        'Guardian',
        'Wall',
        'Line',
        'Cone',
        'AOE'
    );



INSERT INTO godpool
VALUES(
        'Hercules',
        4,
        'Roman',
        'Warrior',
        'Dash',
        'Line',
        'Heal',
        'Line'
    );



INSERT INTO godpool
VALUES(
        'Bakasura',
        5,
        'Hindu',
        'Assassin',
        'Leap',
        'Heal',
        'Buff',
        'Buff'
    );



INSERT INTO godpool
VALUES(
        'Merlin',
        6,
        'Arthurian',
        'Mage',
        'Line',
        'AOE',
        'Leap',
        'Stance Switch'
    );




CREATE VIEW ClassPositions AS
SELECT g.Class,
    p.PrimaryPos,
    p.SecondaryPos
FROM Godpool g,
    PositionPlayed p
WHERE g.name = p.name



DELIMITER $$
CREATE TRIGGER GodAdded
AFTER INSERT 
ON godpool FOR EACH ROW 
BEGIN 
	IF NEW.class = 'Mage' THEN
		INSERT INTO positionplayed 
        VALUES(NEW.name, 'Mid', NULL) ;
	ELSEIF NEW.class = 'Hunter' THEN
		INSERT INTO positionplayed(Type, PrimaryPos, SecondaryPos)
        VALUES(NEW.name, 'ADC', NULL) ;
	ELSEIF NEW.class = 'Warrior' THEN
		INSERT INTO positionplayed(Type, PrimaryPos, SecondaryPos)
        VALUES(NEW.name, 'Solo', NULL);
	ELSEIF NEW.class = 'Assassin' THEN
		INSERT INTO positionplayed(Type, PrimaryPos, SecondaryPos)
        VALUES(NEW.name, 'Jungle', NULL) ;
	ELSE
		INSERT INTO positionplayed(Type, PrimaryPos, SecondaryPos) 
        VALUES(NEW.name, 'Support', NULL);
	END IF;
END$$
DELIMITER ;




CREATE ROLE LeadDeveloper;
CREATE ROLE Developer;
CREATE ROLE ContentCreator;
CREATE ROLE Smite;

GRANT LeadDeveloper TO PonPon;
GRANT ALL PRIVILEGES ON Smite.* TO LeadDeveloper;
GRANT SELECT,INSERT ON Smite.* TO Developer;
GRANT SELECT,INSERT ON Smite.* TO ContentCreator;
GRANT SELECT ON Smite.* TO Smite;





-- //// Fixes to code
-- alter table position drop constraint position_chk_1 ;
-- ALTER TABLE position ADD CHECK	( Role 			IN ( 'Offence', 'Defence', 'Hybrid') );
--DELETE FROM Ability WHERE type = 'leap';
-- ////