-- -----------------------------------------------------------------------------
-- VICTORY MENAGERIE ADVANCED OPTIONS
-- -----------------------------------------------------------------------------
INSERT INTO Parameters 
	    (ParameterId,                Name,                                 Description,                        Domain,      DefaultValue, ConfigurationGroup, ConfigurationId,             GroupId, SortIndex) 
VALUES  ('PARAMETER_GOLD_VIC', 'LOC_VICTORY_RICHES_NAME',          'LOC_VICTORY_RICHES_DESCRIPTION',          'bool',           1,             'Game',      'CONFIG_GOLD_VIC',               'Victories', 601),
		('PARAMETER_GOLD_VIC_EARNINGS', 'LOC_VICTORY_RICHES_EARNINGS_NAME', 'LOC_VICTORY_RICHES_EARNINGS_DESCRIPTION', 'uint',    200000,             'Game',    'CONFIG_GOLD_VIC_EARNINGS',        'Victories', 602),
		('PARAMETER_GOLD_VIC_STOCKPILE', 'LOC_VICTORY_RICHES_STOCKPILE_NAME', 'LOC_VICTORY_RICHES_STOCKPILE_DESCRIPTION', 'uint',   50000,             'Game',    'CONFIG_GOLD_VIC_STOCKPILE',        'Victories', 603),
		('PARAMETER_CHARISMA_VIC', 'LOC_VICTORY_CHARISMA_NAME',          'LOC_VICTORY_CHARISMA_DESCRIPTION',          'bool',           1,             'Game',      'CONFIG_CHARISMA_VIC',               'Victories', 701),
		('PARAMETER_CHARISMA_VIC_PEOPLE_REQ', 'LOC_VICTORY_CHARISMA_PEOPLE_REQ_NAME', 'LOC_VICTORY_CHARISMA_PEOPLE_REQ_DESCRIPTION', 'uint',    50,             'Game',    'CONFIG_CHARISMA_VIC_PEOPLE_REQ',        'Victories', 702);


INSERT INTO ParameterCriteria 
	(ParameterId, ConfigurationGroup, ConfigurationId, Operator, ConfigurationValue) 
VALUES  ('PARAMETER_GOLD_VIC_STOCKPILE', 'Game', 'CONFIG_GOLD_VIC', 'Equals', 1),
		('PARAMETER_GOLD_VIC_EARNINGS', 'Game', 'CONFIG_GOLD_VIC', 'Equals', 1);
