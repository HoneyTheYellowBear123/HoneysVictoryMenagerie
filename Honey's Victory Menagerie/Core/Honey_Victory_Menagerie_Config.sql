-- -----------------------------------------------------------------------------
-- VICTORY MENAGERIE ADVANCED OPTIONS
-- -----------------------------------------------------------------------------
INSERT INTO Parameters 
	    (ParameterId,                Name,                                 Description,                        Domain,      DefaultValue, ConfigurationGroup, ConfigurationId,             GroupId, SortIndex) 
VALUES  ('PARAMETER_GOLD_VIC', 'LOC_VICTORY_RICHES_NAME',          'LOC_VICTORY_RICHES_DESCRIPTION',          'bool',           0,             'Game',      'CONFIG_GOLD_VIC',               'Victories', 601),
		('PARAMETER_GOLD_VIC_EARNINGS', 'LOC_VICTORY_RICHES_EARNINGS_NAME', 'LOC_VICTORY_RICHES_EARNINGS_DESCRIPTION', 'uint',    200000,             'Game',    'CONFIG_GOLD_VIC_EARNINGS',        'Victories', 602),
		('PARAMETER_GOLD_VIC_STOCKPILE', 'LOC_VICTORY_RICHES_STOCKPILE_NAME', 'LOC_VICTORY_RICHES_STOCKPILE_DESCRIPTION', 'uint',   50000,             'Game',    'CONFIG_GOLD_VIC_STOCKPILE',        'Victories', 603),
		('PARAMETER_CHARISMA_VIC', 'LOC_VICTORY_CHARISMA_NAME',          'LOC_VICTORY_CHARISMA_DESCRIPTION',          'bool',           0,             'Game',      'CONFIG_CHARISMA_VIC',               'Victories', 701),
		('PARAMETER_CHARISMA_VIC_PEOPLE_REQ', 'LOC_VICTORY_CHARISMA_PEOPLE_REQ_NAME', 'LOC_VICTORY_CHARISMA_PEOPLE_REQ_DESCRIPTION', 'uint',    50,             'Game',    'CONFIG_CHARISMA_VIC_PEOPLE_REQ',        'Victories', 702),
		('PARAMETER_JOYOUS_VIC', 'LOC_VICTORY_JOYOUS_NAME',					'LOC_VICTORY_JOYOUS_DESCRIPTION',          'bool',           0,             'Game',      'CONFIG_JOYOUS_VIC',               'Victories', 801),
		('PARAMETER_JOYOUS_VIC_TOTAL', 'LOC_VICTORY_JOYOUS_TOTAL_NAME',		'LOC_VICTORY_JOYOUS_TOTAL_DESCRIPTION',			'uint',    200,             'Game',    'CONFIG_JOYOUS_VIC_TOTAL',        'Victories', 802),
		('PARAMETER_JOYOUS_VIC_CONCURRENT', 'LOC_VICTORY_JOYOUS_CONCURRENT_NAME', 'LOC_VICTORY_JOYOUS_CONCURRENT_DESCRIPTION', 'uint',   50,             'Game',    'CONFIG_JOYOUS_VIC_CONCURRENT',        'Victories', 803),
		('PARAMETER_MEGALOPOLIS_VIC', 'LOC_VICTORY_MEGALOPOLIS_NAME',					'LOC_VICTORY_MEGALOPOLIS_DESCRIPTION',          'bool',           0,             'Game',      'CONFIG_MEGALOPOLIS_VIC',               'Victories', 901),
		('PARAMETER_MEGALOPOLIS_VIC_CITIES', 'LOC_VICTORY_MEGALOPOLIS_CITIES',		'LOC_VICTORY_MEGALOPOLIS_CITIES_DESCRIPTION',			'uint',    3,             'Game',    'CONFIG_MEGALOPOLIS_VIC_CITIES',        'Victories', 902),
		('PARAMETER_MEGALOPOLIS_VIC_POPULATION', 'LOC_VICTORY_MEGALOPOLIS_POPULATION', 'LOC_VICTORY_MEGALOPOLIS_POPULATION_DESCRIPTION', 'uint',   20,             'Game',    'CONFIG_MEGALOPOLIS_VIC_POPULATION',        'Victories', 903);


INSERT INTO ParameterCriteria 
	(ParameterId, ConfigurationGroup, ConfigurationId, Operator, ConfigurationValue) 
VALUES  ('PARAMETER_GOLD_VIC_STOCKPILE', 'Game', 'CONFIG_GOLD_VIC', 'Equals', 1),
		('PARAMETER_GOLD_VIC_EARNINGS', 'Game', 'CONFIG_GOLD_VIC', 'Equals', 1),
		('PARAMETER_CHARISMA_VIC_PEOPLE_REQ', 'Game', 'CONFIG_CHARISMA_VIC', 'Equals', 1),
		('PARAMETER_JOYOUS_VIC_TOTAL', 'Game', 'CONFIG_JOYOUS_VIC', 'Equals', 1),
		('PARAMETER_JOYOUS_VIC_CONCURRENT', 'Game', 'CONFIG_JOYOUS_VIC', 'Equals', 1);
		('PARAMETER_MEGALOPOLIS_VIC_CITIES', 'Game', 'CONFIG_MEGALOPOLIS_VIC', 'Equals', 1),
		('PARAMETER_MEGALOPOLIS_VIC_POPULATION', 'Game', 'CONFIG_MEGALOPOLIS_VIC', 'Equals', 1);
