-- Victory Menagerie Data
-- Author: HoneyBear
-- DateCreated: 8/20/2022 11:08:09 AM
--------------------------------------------------------------

--We are following the time honored system of granting a victory building through a lua script :)




INSERT INTO Types
			(Type, Kind)
VALUES    ('VICTORY_RICHES', 'KIND_VICTORY'),
		  ('BUILDING_RICHES_VICTORY', 'KIND_BUILDING'),
		  ('VICTORY_CHARISMA', 'KIND_VICTORY'),
		  ('BUILDING_CHARISMA_VICTORY', 'KIND_BUILDING');



--Building that cannot be built, but can be granted through the lua script 		
INSERT INTO Buildings
          (BuildingType,				 Name,									 Description,                                 PrereqDistrict,				  Cost,            InternalOnly)
VALUES    ('BUILDING_RICHES_VICTORY',   'LOC_BUILDING_RICHES_VICTORY_NAME',    'LOC_BUILDING_RICHES_VICTORY_DESCRIPTION',    'DISTRICT_CITY_CENTER',          '1',              '1'     ),
		  ('BUILDING_CHARISMA_VICTORY',   'LOC_BUILDING_CHARISMA_VICTORY_NAME', 'LOC_BUILDING_CHARISMA_VICTORY_DESCRIPTION',    'DISTRICT_CITY_CENTER',        '1',              '1'     ); 








--UI will be handled via override, basic requirementsets will not show up.
INSERT INTO RequirementSets
	      (RequirementSetId,                    RequirementSetType  ) 
VALUES    ('RICHES_VICTORY_VICTORY_REQS', 'REQUIREMENTSET_TEST_ALL' ),
		  ('CHARISMA_VICTORY_VICTORY_REQS', 'REQUIREMENTSET_TEST_ALL' );


INSERT INTO RequirementSetRequirements
	      (RequirementSetId,                    RequirementId) 
VALUES    ('RICHES_VICTORY_VICTORY_REQS',		 'RICHES_VICTORY_REQ'),
		  ('CHARISMA_VICTORY_VICTORY_REQS',		 'CHARISMA_VICTORY_REQ');

INSERT INTO Requirements 
		 (RequirementId,                           RequirementType)
VALUES   ('RICHES_VICTORY_REQ',    'REQUIREMENT_PLAYER_HAS_AT_LEAST_NUM_BUILDINGS'),
		 ('CHARISMA_VICTORY_REQ',    'REQUIREMENT_PLAYER_HAS_AT_LEAST_NUM_BUILDINGS');






INSERT INTO RequirementArguments
		(RequirementId,			Name,               Value)
VALUES  ('RICHES_VICTORY_REQ',  'BuildingType',     'BUILDING_RICHES_VICTORY'),
		('RICHES_VICTORY_REQ',  'Amount',			'1'),
		('CHARISMA_VICTORY_REQ',  'BuildingType',     'BUILDING_CHARISMA_VICTORY'),
		('CHARISMA_VICTORY_REQ',  'Amount',			'1');  


INSERT INTO Victories
		 ("VictoryType",     "Name",                    "Blurb",                  "Description",                  "RequirementSetId",              "Icon",                 "CriticalPercentage") 
VALUES   ('VICTORY_RICHES', 'LOC_VICTORY_RICHES_NAME', 'LOC_VICTORY_RICHES_TEXT','LOC_VICTORY_RICHES_DESCRIPTION',      'RICHES_VICTORY_VICTORY_REQS',    'ICON_VICTORY_RICHES',       50),
		 ('VICTORY_CHARISMA', 'LOC_VICTORY_CHARISMA_NAME', 'LOC_VICTORY_CHARISMA_TEXT','LOC_CHARISMA_RICHES_DESCRIPTION',      'CHARISMA_VICTORY_VICTORY_REQS',    'ICON_VICTORY_CHARISMA',       50);