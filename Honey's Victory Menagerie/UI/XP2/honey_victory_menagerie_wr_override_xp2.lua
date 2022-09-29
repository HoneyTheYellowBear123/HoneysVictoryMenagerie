-- Copyright 2018, Firaxis Games
-- This is roughly a copy of WorldRankings_Expansion2.lua with a few things from WorldRankings.lua to make it work, and new modded values.


-- ===========================================================================
-- Includes
-- ===========================================================================
include("TabSupport");
include("InstanceManager");
include("SupportFunctions");
include("AnimSidePanelSupport");
include("TeamSupport");
include("CivilizationIcon");
include("Colors");
include("WorldRankings");

-- ===========================================================================
-- Constants
-- ===========================================================================

--MOD FROM BASE GAME/
local m_ShowScoreDetails:boolean = false;
local m_GenericHeaderIM:table = InstanceManager:new("GenericHeaderInstance", "HeaderTop");
local m_OverallIM:table = InstanceManager:new("OverallInstance", "ButtonBG", Controls.OverallViewStack);
local m_ScoreIM:table = InstanceManager:new("ScoreInstance", "ButtonBG", Controls.ScoreViewStack);
local m_ScoreTeamIM:table = InstanceManager:new("ScoreTeamInstance", "ButtonFrame", Controls.ScoreViewStack);
--MOD FROM BASE GAME\



--MOD/
local victoryEarningsAmount = GameConfiguration.GetValue("CONFIG_GOLD_VIC_EARNINGS");  
local victoryStockpileAmount = GameConfiguration.GetValue("CONFIG_GOLD_VIC_STOCKPILE");
local richesVictoryEnabled = GameConfiguration.GetValue("CONFIG_GOLD_VIC");

local victoryRecruitmentAmount = GameConfiguration.GetValue("CONFIG_CHARISMA_VIC_PEOPLE_REQ");
local charismaVictoryEnabled = GameConfiguration.GetValue("CONFIG_CHARISMA_VIC");
--MOD\




--MOD FROM BASE GAME/


local REQUIREMENT_CONTEXT:string = "VictoryProgress";
local DATA_FIELD_SELECTION:string = "Selection";
local DATA_FIELD_HEADER_HEIGHT:string = "HeaderHeight";
local DATA_FIELD_HEADER_RESIZED:string = "HeaderResized";
local DATA_FIELD_HEADER_EXPANDED:string = "HeaderExpanded";
local DATA_FIELD_OVERALL_PLAYERS_IM:string = "OverallPlayersIM";
local DATA_FIELD_DOMINATED_CITIES_IM:string = "DominatedCitiesIM";
local DATA_FIELD_RELIGION_CONVERTED_CIVS_IM:string = "ConvertedCivsIM";

local PADDING_HEADER:number = 10;
local PADDING_CULTURE_HEADER:number = 90;
local PADDING_GENERIC_ITEM_BG:number = 25;
local PADDING_TAB_BUTTON_TEXT:number = 17;
local PADDING_ADVISOR_TEXT_BG:number = 20;
local PADDING_RELIGION_NAME_BG:number = 42;
local PADDING_RELIGION_BG_HEIGHT:number = 26;
local PADDING_VICTORY_GRADIENT:number = 45;
local PADDING_VICTORY_LABEL_UNDERLINE:number = 90;
local PADDING_SCORE_DETAILS_BUTTON_WIDTH:number = 40;
local OFFSET_VIEW_CONTENTS:number = 130;
local OFFSET_ADVISOR_ICON_Y:number = 5;
local OFFSET_ADVISOR_TEXT_Y:number = 70;
local OFFSET_HIDDEN_SCROLLBAR:number = 7;
local OFFSET_CONTRACT_BUTTON_Y:number = 63;
local SIZE_OVERALL_TOP_PLAYER_ICON:number = 48;
local SIZE_OVERALL_PLAYER_ICON:number = 36;
local SIZE_OVERALL_BG_HEIGHT:number = 100;
local SIZE_OVERALL_INSTANCE:number = 40;
local SIZE_VICTORY_ICON_SMALL:number = 64;
local SIZE_RELIGION_BG_HEIGHT:number = 55;
local SIZE_RELIGION_ICON_SMALL:number = 22;
local SIZE_GENERIC_ITEM_MIN_Y:number = 54;
local SIZE_LOCAL_PLAYER_BORDER_PADDING:number = 9;
local SIZE_STACK_DEFAULT:number = 225;
local SIZE_HEADER_DEFAULT:number = 60;
local SIZE_HEADER_MIN_Y:number = 46;
local SIZE_HEADER_ICON:number = 80;
local SIZE_LEADER_ICON:number = 55;
local SIZE_CIV_ICON:number = 36;
local SIZE_DETAILS_SPACING:number = 10;
local SIZE_DEFAULT_CIVNAME:number = 150;

local TEAM_RIBBON_PREFIX:string = "ICON_TEAM_RIBBON_";
local TEAM_RIBBON_SIZE_TOP_TEAM:number = 53;
local TEAM_RIBBON_SIZE:number = 44;

local TEAM_ICON_PREFIX:string = "Team";
local TEAM_ICON_SIZE_TOP_TEAM:number = 38;
local TEAM_ICON_SIZE:number = 28;



--MOD FROM BASE GAME\













local m_ScienceIM:table = InstanceManager:new("ScienceInstance", "ButtonBG", Controls.ScienceViewStack);
local m_ScienceTeamIM:table = InstanceManager:new("ScienceTeamInstance", "ButtonFrame", Controls.ScienceViewStack);
local m_ScienceHeaderIM:table = InstanceManager:new("ScienceHeaderInstance", "HeaderTop", Controls.ScienceViewHeader);

local SPACE_PORT_DISTRICT_INFO:table = GameInfo.Districts["DISTRICT_SPACEPORT"];
local EARTH_SATELLITE_EXP2_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_EARTH_SATELLITE"]
};
local MOON_LANDING_EXP2_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_MOON_LANDING"]
};
local MARS_COLONY_EXP2_PROJECT_INFOS:table = { 
	GameInfo.Projects["PROJECT_LAUNCH_MARS_BASE"],
};
local EXOPLANET_EXP2_PROJECT_INFOS:table = {
	GameInfo.Projects["PROJECT_LAUNCH_EXOPLANET_EXPEDITION"],
};
local SCIENCE_PROJECTS_EXP2:table = {
	EARTH_SATELLITE_EXP2_PROJECT_INFOS,
	MOON_LANDING_EXP2_PROJECT_INFOS,
	MARS_COLONY_EXP2_PROJECT_INFOS,
	EXOPLANET_EXP2_PROJECT_INFOS
};

local SCIENCE_ICON:string = "ICON_VICTORY_TECHNOLOGY";
local SCIENCE_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_VICTORY");
local SCIENCE_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_DETAILS_EXP2");
local SCIENCE_REQUIREMENTS:table = {
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_1"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_2"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_3"),
	Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_4")
};



--MOD/
TAB_RICHES = Locale.Lookup("LOC_WORLD_RANKINGS_RICHES_TAB");
TAB_CHARISMA = Locale.Lookup("LOC_WORLD_RANKINGS_CHARISMA_TAB");
--MOD\

--MOD/
local RICHES_ICON:string = "ICON_VICTORY_RICHES";
local RICHES_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_RICHES_VICTORY");
local RICHES_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_RICHES_DETAILS");
local RICHES_REQUIREMENTS:table = {
	Locale.Lookup("LOC_WORLD_RANKINGS_RICHES_EARNINGS_REQUIREMENT",victoryEarningsAmount),
	Locale.Lookup("LOC_WORLD_RANKINGS_RICHES_STOCKPILE_REQUIREMENT",victoryStockpileAmount)
};

local CHARISMA_ICON:string = "ICON_VICTORY_CHARISMA";
local CHARISMA_TITLE:string = Locale.Lookup("LOC_WORLD_RANKINGS_CHARISMA_VICTORY");
local CHARISMA_DETAILS:string = Locale.Lookup("LOC_WORLD_RANKINGS_CHARISMA_DETAILS",victoryRecruitmentAmount);
--MOD\

--MOD/
local m_RichesHeaderIM	:table = InstanceManager:new("RichesHeaderInstance", "HeaderTop", Controls.RichesViewHeader);
local m_RichesIM:table = InstanceManager:new("RichesInstance", "ButtonBG", Controls.RichesViewStack);
local m_RichesTeamIM:table = InstanceManager:new("RichesTeamInstance", "ButtonFrame", Controls.RichesViewStack);

local m_CharismaHeaderIM	:table = InstanceManager:new("CharismaHeaderInstance", "HeaderTop", Controls.CharismaViewHeader);
local m_CharismaIM:table = InstanceManager:new("CharismaInstance", "ButtonBG", Controls.CharismaViewStack);
local m_CharismaTeamIM:table = InstanceManager:new("CharismaTeamInstance", "ButtonFrame", Controls.CharismaViewStack);
--MOD\



-- ===========================================================================
-- Cached Functions
-- ===========================================================================
BASE_PopulateTabs = PopulateTabs;
BASE_AddTab = AddTab;
BASE_AddExtraTab = AddExtraTab;
BASE_OnTabClicked = OnTabClicked;
BASE_PopulateGenericInstance = PopulateGenericInstance;
BASE_PopulateGenericTeamInstance = PopulateGenericTeamInstance;
BASE_GetDefaultStackSize = GetDefaultStackSize;
BASE_GetCulturalVictoryAdditionalSummary = GetCulturalVictoryAdditionalSummary;

g_victoryData.VICTORY_DIPLOMATIC = {
	GetText = function(p) 
		local total = GlobalParameters.DIPLOMATIC_VICTORY_POINTS_REQUIRED;
		local current = 0;
		if (p:IsAlive()) then
			current = p:GetStats():GetDiplomaticVictoryPoints();
		end

		return Locale.Lookup("LOC_WORLD_RANKINGS_DIPLOMATIC_POINTS_TT", current, total);
	end,
	GetScore = function(p)
		local current = 0;
		if (p:IsAlive()) then
			current = p:GetStats():GetDiplomaticVictoryPoints();
		end

		return current;
	end,
	AdditionalSummary = function(p) return GetDiplomaticVictoryAdditionalSummary(p) end
};


--MOD/
g_victoryData.VICTORY_RICHES = {
	Primary = {
		GetText = function(p) 
			local total = victoryEarningsAmount
			local current = 0;
			local returntext = "";
			if (p:GetProperty("RichesVictoryEarnings")) then
				current = p:GetProperty("RichesVictoryEarnings");
			end

			returntext = Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_RICHES_EARNINGS", current, total);

			if (current > total) then 
				--current = total;

				returntext = Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_RICHES_EARNINGS_ACCOMPLISHED", current, total); 
			end

			return returntext;
		end,

		GetScore = function(p) 
			local current = 0;
			local total = victoryEarningsAmount
			if (p:GetProperty("RichesVictoryEarnings")) then
				current = p:GetProperty("RichesVictoryEarnings");
			end

			if (current > total) then --once the condition has been met, excess does not give you an advantage.
				current = total;
			end
		return current; end
	},

		
	Secondary = {
		GetText = function(p) 
			local total = victoryStockpileAmount
			local current = 0;
			local returntext = "";
			if (p:GetProperty("CurrentGoldStockpile")) then
				current = p:GetProperty("CurrentGoldStockpile");
			end

			returntext = Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_RICHES_STOCKPILE", current, total);

			if (current > total) then --once the condition has been met, stop displaying bigger numbers and give a cute checkmark
				--current = total;

				returntext = Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_RICHES_STOCKPILE_ACCOMPLISHED", current, total); 
			end

			return returntext;
		end,

		GetScore = function(p) 
			local current = 0;
			local total = victoryStockpileAmount
			if (p:GetProperty("CurrentGoldStockpile")) then
				current = p:GetProperty("CurrentGoldStockpile");
			end

			if (current > total) then --once the condition has been met, excess does not give you an advantage.
				current = total;
			end
		return current; end
	},
	AdditionalSummary = function(p) return GetRichesVictoryAdditionalSummary(p) end
}



g_victoryData.VICTORY_CHARISMA = {
	GetText = function(p) 
		local total = victoryRecruitmentAmount
		local current = 0;
		local returntext = "";
		if (p:GetProperty("CharismaVictoryPeopleRecruited")) then
			current = p:GetProperty("CharismaVictoryPeopleRecruited");
		end

		returntext = Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_CHARISMA_RECRUITMENT", current, total);

		return returntext;
	end,

	GetScore = function(p) 
		local current = 0;
		local total = victoryRecruitmentAmount
		if (p:GetProperty("CharismaVictoryPeopleRecruited")) then
			current = p:GetProperty("CharismaVictoryPeopleRecruited");
		end

		if (current > total) then --once the condition has been met, excess does not give you an advantage.
			current = total;
		end
	return current; end,
	AdditionalSummary = function(p) return GetCharismaVictoryAdditionalSummary(p) end
}

--MOD\

--MOD/
function GetRichesVictoryAdditionalSummary(pPlayer:table)
	-- Add or override in expansions
	return "";
end

function GetCharismaVictoryAdditionalSummary(pPlayer:table)
	-- Add or override in expansions
	return "";
end
--MOD\

-- ===========================================================================
-- Overrides
-- ===========================================================================
function OnTabClicked(tabInst:table, onClickCallback:ifunction)
	return function()
		DeselectPreviousTab();
		DeselectExtraTabs();
		tabInst.Selection:SetHide(false);
		onClickCallback();
	end
end


--MOD FROM BASE GAME/
function ResetState(newView:ifunction)
	g_activeheader = nil;
	m_ActiveViewUpdate = newView;
	Controls.OverallView:SetHide(true);
	Controls.ScoreView:SetHide(true);
	Controls.ScienceView:SetHide(true);
	Controls.CultureView:SetHide(true);
	Controls.DominationView:SetHide(true);
	Controls.ReligionView:SetHide(true);
	Controls.GenericView:SetHide(true);
	--MOD/
	Controls.RichesView:SetHide(true);
	Controls.CharismaView:SetHide(true);
	--MOD\

	-- Reset tourism lens unless we're now view the Culture tab
	if newView ~= ViewCulture then
		ResetTourismLens();
	end

	DeactivateReligionLens();
end

function ViewOverall()
	ResetState(ViewOverall);
	Controls.OverallView:SetHide(false);

	m_OverallIM:ResetInstances();

	-- Add default victory types in a pre-determined order
	if(Game.IsVictoryEnabled("VICTORY_TECHNOLOGY")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_TECHNOLOGY", "SCIENCE");
	end
	if(Game.IsVictoryEnabled("VICTORY_CULTURE")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_CULTURE", "CULTURE");
	end
	if(Game.IsVictoryEnabled("VICTORY_CONQUEST")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_CONQUEST", "DOMINATION");
	end
	if(Game.IsVictoryEnabled("VICTORY_RELIGIOUS")) then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_RELIGIOUS", "RELIGION");
	end

	-- Add custom (modded) victory types
	--MOD/
	if richesVictoryEnabled then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_RICHES", "RICHES")
	end
	if charismaVictoryEnabled then
		PopulateOverallInstance(m_OverallIM:GetInstance(), "VICTORY_CHARISMA", "CHARISMA")
	end
	
	for row in GameInfo.Victories() do
		local victoryType:string = row.VictoryType;
		if IsCustomVictoryType(victoryType) and Game.IsVictoryEnabled(victoryType) and (not (victoryType == "VICTORY_RICHES")) and (not (victoryType == "VICTORY_CHARISMA") ) then		
			PopulateOverallInstance(m_OverallIM:GetInstance(), victoryType);
		end
	end
	--MOD\

	Controls.OverallViewStack:CalculateSize();
	Controls.OverallViewStack:ReprocessAnchoring();
	Controls.OverallViewScrollbar:CalculateInternalSize();
	Controls.OverallViewScrollbar:ReprocessAnchoring();

	if(Controls.OverallViewScrollbar:GetScrollBar():IsHidden()) then
		Controls.OverallViewStack:SetOffsetX(-3);
	else
		Controls.OverallViewStack:SetOffsetX(-5);
	end
end

--MOD FROM BASE GAME\


function PopulateGenericTeamInstance(instance:table, teamData:table, victoryType:string)
	PopulateTeamInstanceShared(instance, teamData.TeamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("GenericInstance", "ButtonBG", instance.PlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	for i, playerData in ipairs(teamData.PlayerData) do
		PopulateGenericInstance(instance.PlayerStackIM:GetInstance(), playerData, victoryType, true);
	end

	local requirementSetID:number = Game.GetVictoryRequirements(teamData.TeamID, victoryType);
	if requirementSetID ~= nil and requirementSetID ~= -1 then

		local detailsText:string = "";
		local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);
	
		for _, requirementID in ipairs(innerRequirements) do

			if detailsText ~= "" then
				detailsText = detailsText .. "[NEWLINE]";
			end

			local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, "VictoryProgress");
			local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);

			if requirementText ~= nil then
				detailsText = detailsText .. requirementText;
				local civIconClass = CivilizationIcon:AttachInstance(instance.CivilizationIcon or instance);
				if playerData ~= nil then
					civIconClass:SetLeaderTooltip(playerData.PlayerID, requirementText);
				end
			else
				local requirementState:string = GameEffects.GetRequirementState(requirementID);
				local requirementDetails:table = GameEffects.GetRequirementDefinition(requirementID);
				if requirementState == "Met" or requirementState == "AlwaysMet" then
					detailsText = detailsText .. "[ICON_CheckmarkBlue] ";
				else
					detailsText = detailsText .. "[ICON_Bolt]";
				end
				detailsText = detailsText .. requirementDetails.ID;
			end
			instance.Details:SetText(detailsText);
		end
	else
		instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
	end

	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end
	
	instance.ButtonFrame:SetSizeY(itemSize);
end

function PopulateGenericInstance(instance:table, playerData:table, victoryType:string, showTeamDetails:boolean )
	PopulatePlayerInstanceShared(instance, playerData.PlayerID);
	
	if showTeamDetails then
		local requirementSetID:number = Game.GetVictoryRequirements(Players[playerData.PlayerID]:GetTeam(), victoryType);
		if requirementSetID ~= nil and requirementSetID ~= -1 then

			local detailsText:string = "";
			local innerRequirements:table = GameEffects.GetRequirementSetInnerRequirements(requirementSetID);
	
			if innerRequirements ~= nil then
				for _, requirementID in ipairs(innerRequirements) do

					if detailsText ~= "" then
						detailsText = detailsText .. "[NEWLINE]";
					end

					local requirementKey:string = GameEffects.GetRequirementTextKey(requirementID, "VictoryProgress");
					local requirementText:string = GameEffects.GetRequirementText(requirementID, requirementKey);

					if requirementText ~= nil then
						detailsText = detailsText .. requirementText;
						local civIconClass = CivilizationIcon:AttachInstance(instance.CivilizationIcon or instance);
						civIconClass:SetLeaderTooltip(playerData.PlayerID, requirementText);
					else
						local requirementState:string = GameEffects.GetRequirementState(requirementID);
						local requirementDetails:table = GameEffects.GetRequirementDefinition(requirementID);
						if requirementState == "Met" or requirementState == "AlwaysMet" then
							detailsText = detailsText .. "[ICON_CheckmarkBlue] ";
						else
							detailsText = detailsText .. "[ICON_Bolt]";
						end
						detailsText = detailsText .. requirementDetails.ID;
					end
				end
			else
				detailsText = "";
			end
			instance.Details:SetText(detailsText);
		else
			instance.Details:LocalizeAndSetText("LOC_OPTIONS_DISABLED");
		end
	else
		instance.Details:SetText("");
	end

	local itemSize:number = instance.Details:GetSizeY() + PADDING_GENERIC_ITEM_BG;
	if itemSize < SIZE_GENERIC_ITEM_MIN_Y then
		itemSize = SIZE_GENERIC_ITEM_MIN_Y;
	end
	
	instance.ButtonBG:SetSizeY(itemSize);
end

-- ===========================================================================
--	Culture victory update
-- ===========================================================================
function GetCulturalVictoryAdditionalSummary(pPlayer:table)
	if (g_LocalPlayer == nil) then
		return "";	
	end

	local iPlayerID:number = pPlayer:GetID();
	local pLocalPlayerCulture:table = g_LocalPlayer:GetCulture();
	local pOtherPlayerCulture:table = pPlayer:GetCulture();
	if (pLocalPlayerCulture == nil or pOtherPlayerCulture == nil) then
		return "";	
	end

	local tSummaryStrings = {};

	-- Base game additional summary, if any
	local baseDetails:string = BASE_GetCulturalVictoryAdditionalSummary(pPlayer);
	if (baseDetails ~= nil and baseDetails ~= "") then
		table.insert(tSummaryStrings, baseDetails);
	end

	-- Cultural Dominance summaries

	-- This is us, show the quantity of civs we dominate or that dominate us
	if (iPlayerID == g_LocalPlayerID) then		
		local iNumWeDominate:number = 0;
		local iNumDominateUs:number = 0;
		for _, iLoopID in ipairs(PlayerManager.GetAliveMajorIDs()) do
			if (iLoopID ~= g_LocalPlayerID) then
				if (pLocalPlayerCulture:IsDominantOver(iLoopID)) then
					iNumWeDominate = iNumWeDominate + 1;
				else
					local pLoopPlayerCulture = Players[iLoopID]:GetCulture();
					if (pLoopPlayerCulture ~= nil and pLoopPlayerCulture:IsDominantOver(g_LocalPlayerID)) then
						iNumDominateUs = iNumDominateUs + 1;
					end
				end
			end
		end

		if iNumWeDominate > 0 then
			table.insert(tSummaryStrings, Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_NUM_WE_DOMINATE", iNumWeDominate));
		end
		if iNumDominateUs > 0 then
			table.insert(tSummaryStrings, Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_NUM_DOMINATE_US", iNumDominateUs));
		end
	else
		-- Are we/they culturally dominant
		if (pLocalPlayerCulture:IsDominantOver(iPlayerID)) then
			table.insert(tSummaryStrings, Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_WE_ARE_DOMINANT"));
		elseif (pOtherPlayerCulture:IsDominantOver(g_LocalPlayerID)) then
			table.insert(tSummaryStrings, Locale.Lookup("LOC_WORLD_RANKINGS_OVERVIEW_CULTURE_THEY_ARE_DOMINANT"));
		end
	end

	return FormatTableAsNewLineString(tSummaryStrings);
end

-- ===========================================================================
--	Called when Science tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewScience()
	ResetState(ViewScience);
	Controls.ScienceView:SetHide(false);

	ChangeActiveHeader("VICTORY_TECHNOLOGY", m_ScienceHeaderIM, Controls.ScienceViewHeader);
	PopulateGenericHeader(RealizeScienceStackSize, SCIENCE_TITLE, "", SCIENCE_DETAILS, SCIENCE_ICON);
	
	local totalCost:number = 0;
	local currentProgress:number = 0;
	local progressText:string = "";
	local progressResults:table = { 0, 0, 0, 0 }; -- initialize with 3 elements
	local finishedProjects:table = { {}, {}, {}, {} };
	
	local bHasSpaceport:boolean = false;
	if (g_LocalPlayer ~= nil) then
		for _,district in g_LocalPlayer:GetDistricts():Members() do
			if (district ~= nil and district:IsComplete() and district:GetType() == SPACE_PORT_DISTRICT_INFO.Index) then
				bHasSpaceport = true;
				break;
			end
		end

		local pPlayerStats:table = g_LocalPlayer:GetStats();
		local pPlayerCities:table = g_LocalPlayer:GetCities();
		for _, city in pPlayerCities:Members() do
			local pBuildQueue:table = city:GetBuildQueue();
			-- 1st milestone - satellite launch
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(EARTH_SATELLITE_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[1][i] = projectProgress == projectCost;
			end
			progressResults[1] = currentProgress / totalCost;

			-- 2nd milestone - moon landing
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(MOON_LANDING_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[2][i] = projectProgress == projectCost;
			end
			progressResults[2] = currentProgress / totalCost;
		
			-- 3rd milestone - mars landing
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(MARS_COLONY_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[3][i] = projectProgress == projectCost;
			end
			progressResults[3] = currentProgress / totalCost;

			-- 4th milestone - exoplanet expeditiion
			totalCost = 0;
			currentProgress = 0;
			for i, projectInfo in ipairs(EXOPLANET_EXP2_PROJECT_INFOS) do
				local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
				local projectProgress:number = projectCost;
				if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
					projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
				end
				totalCost = totalCost + projectCost;
				currentProgress = currentProgress + projectProgress;
				finishedProjects[4][i] = projectProgress == projectCost;
			end
			progressResults[4] = currentProgress / totalCost;
		end
	end

	local nextStep:string = "";
	for i, result in ipairs(progressResults) do
		if(result < 1) then
			progressText = progressText .. "[ICON_Bolt]";
			if(nextStep == "") then
				nextStep = GetNextStepForScienceProject(g_LocalPlayer, SCIENCE_PROJECTS_EXP2[i], bHasSpaceport, finishedProjects[i]);
			end
		else
			progressText = progressText .. "[ICON_CheckmarkBlue] ";
		end
		progressText = progressText .. SCIENCE_REQUIREMENTS[i] .. "[NEWLINE]";
	end

	-- Final milestone - Earning Victory Points (Light Years)
	local totalLightYears:number = g_LocalPlayer:GetStats():GetScienceVictoryPointsTotalNeeded();
	local lightYears = g_LocalPlayer:GetStats():GetScienceVictoryPoints();
	if (lightYears < totalLightYears) then
		progressText = progressText .. "[ICON_Bolt]";
	else
		progressText = progressText .. "[ICON_CheckmarkBlue]";
	end
	progressText = progressText .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_REQUIREMENT_FINAL", totalLightYears);

	g_activeheader.AdvisorTextCentered:SetText(progressText);
    if (nextStep ~= "") then
        g_activeheader.AdvisorTextNextStep:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP", nextStep));
	else
		-- If the user One More Turns, this keeps rolling in the DLL and makes us look goofy.
		if lightYears > totalLightYears then
			lightYears = totalLightYears;
		end

        g_activeheader.AdvisorTextNextStep:SetText(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_HAS_MOVED", lightYears, totalLightYears));
    end

	m_ScienceIM:ResetInstances();
	m_ScienceTeamIM:ResetInstances();

	for teamID, team in pairs(Teams) do
		if teamID >= 0 then
			if #team > 1 then
				PopulateScienceTeamInstance(m_ScienceTeamIM:GetInstance(), teamID);
			else
				local pPlayer = Players[team[1]];
				if (pPlayer:IsAlive() == true and pPlayer:IsMajor() == true) then
					PopulateScienceInstance(m_ScienceIM:GetInstance(), pPlayer);
				end
			end
		end
	end

	RealizeScienceStackSize();
end

function GetNextStepForScienceProject(pPlayer:table, projectInfos:table, bHasSpaceport:boolean, finishedProjects:table)

	if(not bHasSpaceport) then 
		return Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_BUILD", Locale.Lookup(SPACE_PORT_DISTRICT_INFO.Name));
	end

	local playerTech:table = pPlayer:GetTechs();
	local numProjectInfos:number = table.count(projectInfos);
	for i, projectInfo in ipairs(projectInfos) do

		if(projectInfo.PrereqTech ~= nil) then
			local tech:table = GameInfo.Technologies[projectInfo.PrereqTech];
			if(not playerTech:HasTech(tech.Index)) then
				return Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_RESEARCH", Locale.Lookup(tech.Name));
			end
		end

		if(not finishedProjects[i]) then
			return Locale.Lookup(projectInfo.Name);
		end
	end
	return "";
end

function PopulateScienceInstance(instance:table, pPlayer:table)
	local playerID:number = pPlayer:GetID();
	PopulatePlayerInstanceShared(instance, playerID);
	
	-- Progress Data to be returned from function
	local progressData = nil; 

	local bHasSpaceport:boolean = false;
	for _,district in pPlayer:GetDistricts():Members() do
		if (district ~= nil and district:IsComplete() and district:GetType() == SPACE_PORT_DISTRICT_INFO.Index) then
			bHasSpaceport = true;
			break;
		end
	end

	local pPlayerStats:table = pPlayer:GetStats();
	local pPlayerCities:table = pPlayer:GetCities();
	local projectTotals:table = { 0, 0, 0, 0 };
	local projectProgresses:table = { 0, 0, 0, 0 };
	local finishedProjects:table = { {}, {}, {}, {} };
	for _, city in pPlayerCities:Members() do
		local pBuildQueue:table = city:GetBuildQueue();

		-- 1st milestone - satelite launch
		for i, projectInfo in ipairs(EARTH_SATELLITE_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[1][i] = false;
			if projectProgress ~= 0 then
				projectTotals[1] = projectTotals[1] + projectCost;
				projectProgresses[1] = projectProgresses[1] + projectProgress;
				finishedProjects[1][i] = projectProgress == projectCost;
			end
		end

		-- 2nd milestone - moon landing
		for i, projectInfo in ipairs(MOON_LANDING_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[2][i] = false;
			if projectProgress ~= 0 then
				projectTotals[2] = projectTotals[2] + projectCost;
				projectProgresses[2] = projectProgresses[2] + projectProgress;
				finishedProjects[2][i] = projectProgress == projectCost;
			end
		end

		-- 3rd milestone - mars landing
		for i, projectInfo in ipairs(MARS_COLONY_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[3][i] = false;
			projectTotals[3] = projectTotals[3] + projectCost;
			if projectProgress ~= 0 then
				projectProgresses[3] = projectProgresses[3] + projectProgress;
				finishedProjects[3][i] = projectProgress == projectCost;
			end
		end

		-- 4th milestone - exoplanet expedition
		for i, projectInfo in ipairs(EXOPLANET_EXP2_PROJECT_INFOS) do
			local projectCost:number = pBuildQueue:GetProjectCost(projectInfo.Index);
			local projectProgress:number = projectCost;
			if pPlayerStats:GetNumProjectsAdvanced(projectInfo.Index) == 0 then
				projectProgress = pBuildQueue:GetProjectProgress(projectInfo.Index);
			end
			finishedProjects[4][i] = false;
			projectTotals[4] = projectTotals[4] + projectCost;
			if projectProgress ~= 0 then
				projectProgresses[4] = projectProgresses[4] + projectProgress;
				finishedProjects[4][i] = projectProgress == projectCost;
			end
		end
	end

	-- Save data to be returned
	progressData = {};
	progressData.playerID = playerID;
	progressData.projectTotals = projectTotals;
	progressData.projectProgresses = projectProgresses;
	progressData.bHasSpaceport = bHasSpaceport;
	progressData.finishedProjects = finishedProjects;

	PopulateScienceProgressMeters(instance, progressData);

	return progressData;
end

function GetTooltipForScienceProject(pPlayer:table, projectInfos:table, bHasSpaceport:boolean, finishedProjects:table)

	local result:string = "";

	-- Only show spaceport for first tooltip
	if bHasSpaceport ~= nil then
		if(bHasSpaceport) then 
			result = result .. "[ICON_CheckmarkBlue]";
		else
			result = result .. "[ICON_Bolt]";
		end
		result = result .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_BUILD", Locale.Lookup(SPACE_PORT_DISTRICT_INFO.Name)) .. "[NEWLINE]";
	end

	local playerTech:table = pPlayer:GetTechs();
	local numProjectInfos:number = table.count(projectInfos);
	for i, projectInfo in ipairs(projectInfos) do

		if(projectInfo.PrereqTech ~= nil) then
			local tech:table = GameInfo.Technologies[projectInfo.PrereqTech];
			if(playerTech:HasTech(tech.Index)) then
				result = result .. "[ICON_CheckmarkBlue]";
			else
				result = result .. "[ICON_Bolt]";
			end
			result = result .. Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NEXT_STEP_RESEARCH", Locale.Lookup(tech.Name)) .. "[NEWLINE]";
		end

		if(finishedProjects[i]) then
			result = result .. "[ICON_CheckmarkBlue]";
		else
			result = result .. "[ICON_Bolt]";
		end
		result = result .. Locale.Lookup(projectInfo.Name);
		if(i < numProjectInfos) then result = result .. "[NEWLINE]"; end
	end

	return result;
end

function PopulateScienceProgressMeters(instance:table, progressData:table)
	local pPlayer = Players[progressData.playerID];

	for i = 1, 4 do
		instance["ObjHidden_" .. i]:SetHide(true);
		instance["ObjFill_" .. i]:SetHide(progressData.projectProgresses[i] == 0);
		instance["ObjBar_" .. i]:SetPercent(progressData.projectProgresses[i] / progressData.projectTotals[i]);
		instance["ObjToggle_ON_" .. i]:SetHide(progressData.projectTotals[i] == 0 or progressData.projectProgresses[i] ~= progressData.projectTotals[i]);
	end
	
    instance["ObjHidden_5"]:SetHide(true);
    -- if bar 4 is at 100%, light up bar 5
    if ((progressData.projectProgresses[4] >= progressData.projectTotals[4]) and (progressData.projectTotals[4] ~= 0)) then
		local lightYears = pPlayer:GetStats():GetScienceVictoryPoints();
		local lightYearsPerTurn = pPlayer:GetStats():GetScienceVictoryPointsPerTurn();
		local totalLightYears = g_LocalPlayer:GetStats():GetScienceVictoryPointsTotalNeeded();

		instance["ObjFill_5"]:SetHide(false);
        instance["ObjToggle_ON_5"]:SetHide(lightYears == 0 or lightYears < lightYearsPerTurn);
        -- my test save returns a larger value for light years than for years needed, so guard against drawing errors
        if lightYears > totalLightYears then
            lightYears = totalLightYears;
        end
        instance["ObjBar_5"]:SetPercent(lightYears/totalLightYears);
		instance.ObjBG_5:SetToolTipString(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_IS_MOVING", lightYearsPerTurn));
    else
        instance["ObjFill_5"]:SetHide(true);
        instance["ObjToggle_ON_5"]:SetHide(true);
        instance["ObjBar_5"]:SetPercent(0);
		instance.ObjBG_5:SetToolTipString(Locale.Lookup("LOC_WORLD_RANKINGS_SCIENCE_NO_LAUNCH"));
    end
    		
	instance.ObjBG_1:SetToolTipString(GetTooltipForScienceProject(pPlayer, EARTH_SATELLITE_EXP2_PROJECT_INFOS, progressData.bHasSpaceport, progressData.finishedProjects[1]));
	instance.ObjBG_2:SetToolTipString(GetTooltipForScienceProject(pPlayer, MOON_LANDING_EXP2_PROJECT_INFOS, nil, progressData.finishedProjects[2]));
	instance.ObjBG_3:SetToolTipString(GetTooltipForScienceProject(pPlayer, MARS_COLONY_EXP2_PROJECT_INFOS, nil, progressData.finishedProjects[3]));
	instance.ObjBG_4:SetToolTipString(GetTooltipForScienceProject(pPlayer, EXOPLANET_EXP2_PROJECT_INFOS, nil, progressData.finishedProjects[4]));
end

-- ===========================================================================
--	Called once during Init
-- ===========================================================================
function PopulateTabs()

	-- Clean up previous data
	m_ExtraTabs = {};
	m_TotalTabSize = 0;
	m_MaxExtraTabSize = 0;
	g_ExtraTabsIM:ResetInstances();
	g_TabSupportIM:ResetInstances();
	
	-- Deselect previously selected tab
	if g_TabSupport then
		g_TabSupport.SelectTab(nil);
		DeselectPreviousTab();
		DeselectExtraTabs();
	end

	-- Create TabSupport object
	g_TabSupport = CreateTabs(Controls.TabContainer, 42, 44, UI.GetColorValueFromHexLiteral(0xFF331D05));

	local defaultTab = AddTab(TAB_OVERALL, ViewOverall);

	-- Add default victory types in a pre-determined order
	if(GameConfiguration.IsAnyMultiplayer() or Game.IsVictoryEnabled("VICTORY_SCORE")) then
		BASE_AddTab(TAB_SCORE, ViewScore);
	end
	if(Game.IsVictoryEnabled("VICTORY_TECHNOLOGY")) then
		AddTab(TAB_SCIENCE, ViewScience);
	end
	if(Game.IsVictoryEnabled("VICTORY_CULTURE")) then
		g_CultureInst = AddTab(TAB_CULTURE, ViewCulture);
	end
	if(Game.IsVictoryEnabled("VICTORY_CONQUEST")) then
		AddTab(TAB_DOMINATION, ViewDomination);
	end
	if(Game.IsVictoryEnabled("VICTORY_RELIGIOUS")) then
		AddTab(TAB_RELIGION, ViewReligion);
	end

	-- Add custom (modded) victory types
	--MOD/
	if richesVictoryEnabled then
		AddTab(TAB_RICHES, ViewRiches);
	end

	if charismaVictoryEnabled then
		AddTab(TAB_CHARISMA, ViewCharisma);
	end

	-- Add custom (modded) victory types
	for row in GameInfo.Victories() do
   	local victoryType:string = row.VictoryType;
		if IsCustomVictoryType(victoryType) and Game.IsVictoryEnabled(victoryType) then
            if (victoryType == "VICTORY_DIPLOMATIC") then
                AddTab(Locale.Lookup("LOC_TOOLTIP_DIPLOMACY_CONGRESS_BUTTON"), function() ViewDiplomatic(victoryType); end);
            elseif ( (not (victoryType == "VICTORY_RICHES")) and (not (victoryType == "VICTORY_CHARISMA"))  ) then				
				AddTab(Locale.Lookup(row.Name), function() ViewGeneric(victoryType); end);
            end
		end
	end

	--MOD\

	if m_TotalTabSize > (Controls.TabContainer:GetSizeX()*2) then
		Controls.ExpandExtraTabs:SetHide(false);
		for _, tabInst in pairs(m_ExtraTabs) do
			tabInst.Button:SetSizeX(m_MaxExtraTabSize);
		end
	else
		Controls.ExpandExtraTabs:SetHide(true);
	end

	Controls.ExpandExtraTabs:SetHide(true);

	g_TabSupport.SelectTab(defaultTab);
	g_TabSupport.CenterAlignTabs(0, 450, 32);
end

function AddTab(label:string, onClickCallback:ifunction)

	local tabInst:table = g_TabSupportIM:GetInstance();
	tabInst.Button[DATA_FIELD_SELECTION] = tabInst.Selection;

	tabInst.Button:SetText(label);
	local textControl = tabInst.Button:GetTextControl();
	textControl:SetHide(false);

	local textSize:number = textControl:GetSizeX();
	tabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	tabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	tabInst.Selection:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT + 4);

	m_TotalTabSize = m_TotalTabSize + tabInst.Button:GetSizeX();
	if m_TotalTabSize > (Controls.TabContainer:GetSizeX() * 2) then
		g_TabSupportIM:ReleaseInstance(tabInst);
		AddExtraTab(label, onClickCallback);
	else
		g_TabSupport.AddTab(tabInst.Button, OnTabClicked(tabInst, onClickCallback));
	end

	return tabInst.Button;
end

function AddExtraTab(label:string, onClickCallback:ifunction)
	local extraTabInst:table = g_ExtraTabsIM:GetInstance();
	
	extraTabInst.Button:SetText(label);
	extraTabInst.Button:RegisterCallback(Mouse.eLClick, OnExtraTabClicked(extraTabInst, onClickCallback));

	local textControl = extraTabInst.Button:GetTextControl();
	local textSize:number = textControl:GetSizeX();
	extraTabInst.Button:SetSizeX(textSize + PADDING_TAB_BUTTON_TEXT);
	extraTabInst.Button:RegisterCallback(Mouse.eMouseEnter,	function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	local tabSize:number = extraTabInst.Button:GetSizeX();
	if tabSize > m_MaxExtraTabSize then
		m_MaxExtraTabSize = tabSize;
	end

	table.insert(m_ExtraTabs, extraTabInst);
end

function ViewDiplomatic(victoryType:string)
	ResetState(function() ViewDiplomatic(victoryType); end);
	Controls.GenericView:SetHide(false);

	ChangeActiveHeader("GENERIC", m_GenericHeaderIM, Controls.GenericViewHeader);

	local victoryInfo:table = GameInfo.Victories[victoryType];
    if victoryInfo.Icon ~= nil then
        PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, victoryInfo.Description, victoryInfo.Icon);
    else
        PopulateGenericHeader(RealizeGenericStackSize, victoryInfo.Name, nil, victoryInfo.Description, ICON_GENERIC);
    end

	local genericData:table = GatherGenericData();

	g_GenericIM:ResetInstances();
	g_GenericTeamIM:ResetInstances();

	local ourData:table = {};

	for i, teamData in ipairs(genericData) do
		local ourTeamData:table = { teamData, score };

		ourTeamData.teamData = teamData;
		local progress = Game.GetVictoryProgressForTeam(victoryType, teamData.TeamID);
		if progress == nil then
			progress = 0;
		end
		ourTeamData.score = progress;

		table.insert(ourData, ourTeamData);
	end

	table.sort(ourData, function(a, b)
		return a.score > b.score;
	end);

	for i, theData in ipairs(ourData) do
		if #theData.teamData.PlayerData > 1 then
			PopulateGenericTeamInstance(g_GenericTeamIM:GetInstance(), theData.teamData, victoryType);
		else
			local uiGenericInstance:table = g_GenericIM:GetInstance();
			local pPlayer:table = Players[theData.teamData.PlayerData[1].PlayerID];
			if pPlayer ~= nil then
				local pStats:table = pPlayer:GetStats();
				if pStats == nil then
					UI.DataError("Stats not found for PlayerID:" .. theData.teamData.PlayerData[1].PlayerID .. "! WorldRankings XP2");
					return;
				end
				uiGenericInstance.ButtonBG:SetToolTipString(pStats:GetDiplomaticVictoryPointsTooltip());
			end
			PopulateGenericInstance(uiGenericInstance, theData.teamData.PlayerData[1], victoryType, true);
		end
	end

	RealizeGenericStackSize();
end

function GetDiplomaticVictoryAdditionalSummary(pPlayer:table)
	-- Add or override in expansions
	return "";
end

function GetDefaultStackSize()
    return 265;
end








--MOD/

-- ===========================================================================
--	Called when Riches tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewRiches()
	ResetState(ViewRiches);
	Controls.RichesView:SetHide(false);

	ChangeActiveHeader("VICTORY_RICHES", m_RichesHeaderIM, Controls.RichesViewHeader);
	PopulateGenericHeader(RealizeRichesStackSize, RICHES_TITLE, "", RICHES_DETAILS, RICHES_ICON);
	
	local totalCost:number = 0;
	local currentProgress:number = 0;
	local progressText:string = "";
	local progressResults:table = { 0, 0 }; -- initialize with 2 elements
	local finishedProjects:table = { {}, {} };
	
	--local bHasSpaceport:boolean = false;


	if (g_LocalPlayer ~= nil) then

		--Earnings
		totalCost = victoryEarningsAmount  
		if (g_LocalPlayer:GetProperty("RichesVictoryEarnings")) then
			currentProgress = g_LocalPlayer:GetProperty("RichesVictoryEarnings");
		end
		progressResults[1] = currentProgress / totalCost;

		--StockPile
		totalCost = victoryStockpileAmount
		currentProgress = 0
		if (g_LocalPlayer:GetProperty("CurrentGoldStockpile")) then
			currentProgress = g_LocalPlayer:GetProperty("CurrentGoldStockpile");
		end
		progressResults[2] = currentProgress / totalCost;

	end

	


	local nextStep:string = "";
	for i, result in ipairs(progressResults) do
		if(result < 1) then
			progressText = progressText .. "[ICON_Bolt]";

		else
			progressText = progressText .. "[ICON_CheckmarkBlue] ";
		end
		progressText = progressText .. RICHES_REQUIREMENTS[i];


		if(i < 2) then progressText = progressText .. "[NEWLINE]"; end
	end

	g_activeheader.AdvisorTextCentered:SetText(progressText);


	m_RichesIM:ResetInstances();
	m_RichesTeamIM:ResetInstances();

	
	local teamIDs = GetAliveMajorTeamIDs();
	for _, teamID in ipairs(teamIDs) do
		local team = Teams[teamID];
		if (team ~= nil) then
			if #team > 1 then
				PopulateRichesTeamInstance(m_RichesTeamIM:GetInstance(), teamID);
			else 
				local pPlayer = Players[team[1]];
				if (pPlayer:IsAlive() == true and pPlayer:IsMajor() == true) then
					PopulateRichesInstance(m_RichesIM:GetInstance(), pPlayer);
				end
			end
		end
	end
	

	RealizeRichesStackSize();
end


function PopulateRichesTeamInstance(instance:table, teamID:number)

	PopulateTeamInstanceShared(instance, teamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("RichesInstance", "ButtonBG", instance.RichesPlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	local teamProgressData:table = {};
	for i, playerID in ipairs(Teams[teamID]) do
		if IsAliveAndMajor(playerID) then
			local pPlayer:table = Players[playerID];
			local progressData = PopulateRichesInstance(instance.PlayerStackIM:GetInstance(), pPlayer);
			if progressData then
				table.insert(teamProgressData, progressData);
			end
		end
	end

	--TODO/

	-- Sort team progress data
	table.sort(teamProgressData, function(a, b)
		-- Compare stage 1 progress
		local aScore = a.richesGoalsProgress[1] / victoryEarningsAmount;
		local bScore = b.richesGoalsProgress[1] / victoryEarningsAmount;
		if aScore == bScore then
			-- Compare stage 2 progress
			aScore = a.richesGoalsProgress[2] / victoryStockpileAmount;
			bScore = b.richesGoalsProgress[2] / victoryStockpileAmount;
			if aScore == bScore then
				return a.playerID < b.playerID;
			end
		end
		return aScore > bScore;
	end);

	-- Populate the team progress with the progress of the furthest player
	if teamProgressData and #teamProgressData > 0 then
		PopulateRichesProgressMeters(instance, teamProgressData[1]);
	end

	--TODO\
end

function PopulateRichesInstance(instance:table, pPlayer:table)
	local playerID:number = pPlayer:GetID();
	PopulatePlayerInstanceShared(instance, playerID);
	
	-- Progress Data to be returned from function
	local progressData = nil; 

	local richesGoalsTotals = { 0 , 0 };
	local richesGoalsProgress = { 0 , 0 };
	local richesGoalsFinished = { {} , {} };

	--Earnings Progress
	richesGoalsProgress[1] = 0
	richesGoalsTotals[1] = 0
	if pPlayer:GetProperty("RichesVictoryEarnings") then
		richesGoalsProgress[1] = pPlayer:GetProperty("RichesVictoryEarnings")
		richesGoalsTotals[1] = pPlayer:GetProperty("RichesVictoryEarnings")
	end

	if richesGoalsProgress[1] > victoryEarningsAmount then
		richesGoalsProgress[1] = victoryEarningsAmount
	end

	--Stockpile Progress

	richesGoalsProgress[2] = 0
	richesGoalsTotals[2] = 50
	if pPlayer:GetProperty("CurrentGoldStockpile") then
		richesGoalsProgress[2] = pPlayer:GetProperty("CurrentGoldStockpile")
		richesGoalsTotals[2] = pPlayer:GetProperty("CurrentGoldStockpile")
	end

	if richesGoalsProgress[2] > victoryStockpileAmount then
		richesGoalsProgress[2] = victoryStockpileAmount
	end


	

	-- Save data to be returned
	progressData = {}; --most progress being saved as player variables
	progressData.richesGoalsTotals = richesGoalsTotals;
	progressData.richesGoalsProgress = richesGoalsProgress;
	progressData.richesGoalsFinished = richesGoalsFinished; 
	progressData.playerID = playerID;


	PopulateRichesProgressMeters(instance, progressData);

	return progressData;
end

function PopulateRichesProgressMeters(instance:table, progressData:table)

	
	instance.ObjBG_1:SetToolTipString( Locale.Lookup("RICHES_VICTORY_EARNINGS_TOOLTIP", victoryEarningsAmount, progressData.richesGoalsTotals[1]) );
	instance.ObjBG_2:SetToolTipString( Locale.Lookup("RICHES_VICTORY_STOCKPILE_TOOLTIP", victoryStockpileAmount, progressData.richesGoalsTotals[2]) );

	--Earnings 
	local denom1 = victoryEarningsAmount
	if denom1 < 1 then
		denom1 = 1
		progressData.richesGoalsProgress[1] = 1
	end

	instance["ObjHidden_" .. 1]:SetHide(true);
	instance["ObjFill_" .. 1]:SetHide(progressData.richesGoalsProgress[1] == 0);
	instance["ObjBar_" .. 1]:SetPercent(progressData.richesGoalsProgress[1] / denom1);
	instance["ObjToggle_ON_" .. 1]:SetHide(progressData.richesGoalsProgress[1] < victoryEarningsAmount);

	--Stockpile
	local denom2 = victoryStockpileAmount
	if denom2 < 1 then
		denom2 = 1
		progressData.richesGoalsProgress[2] = 1
	end

	instance["ObjHidden_" .. 2]:SetHide(true);
	instance["ObjFill_" .. 2]:SetHide(progressData.richesGoalsProgress[2] == 0);
	instance["ObjBar_" .. 2]:SetPercent(progressData.richesGoalsProgress[2] / denom2);
	instance["ObjToggle_ON_" .. 2]:SetHide(progressData.richesGoalsProgress[2] < victoryStockpileAmount);

	
end

function RealizeRichesStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(g_activeheader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = g_activeheader[DATA_FIELD_HEADER_HEIGHT];
		headerHeight = headerHeight + g_activeheader.AdvisorTextCentered:GetSizeY() + g_activeheader.AdvisorTextNextStep:GetSizeY() + (PADDING_HEADER * 2);
		g_activeheader.AdvisorIcon:SetOffsetY(OFFSET_ADVISOR_ICON_Y + headerHeight);
		g_activeheader.HeaderFrame:SetSizeY(OFFSET_ADVISOR_TEXT_Y + headerHeight);
		g_activeheader.ContractHeaderButton:SetOffsetY(OFFSET_CONTRACT_BUTTON_Y + headerHeight);
		Controls.RichesViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.RichesViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
		g_activeheader.AdvisorTextCentered:SetHide(false);
		g_activeheader.AdvisorTextNextStep:SetHide(false);
	else
		Controls.RichesViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.RichesViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
		g_activeheader.AdvisorTextCentered:SetHide(true);
		g_activeheader.AdvisorTextNextStep:SetHide(true);
	end

	RealizeStackAndScrollbar(Controls.RichesViewStack, Controls.RichesViewScrollbar, true);

	--local textSize:number = Controls.ScienceDetailsButton:GetTextControl():GetSizeX();
	--Controls.ScienceDetailsButton:SetSizeX(textSize + PADDING_SCORE_DETAILS_BUTTON_WIDTH);
end


















-- ===========================================================================
--	Called when Charisma tab is selected (or when screen re-opens if selected)
-- ===========================================================================
function ViewCharisma()
	ResetState(ViewCharisma);
	Controls.CharismaView:SetHide(false);

	ChangeActiveHeader("VICTORY_CHARISMA", m_CharismaHeaderIM, Controls.CharismaViewHeader);
	PopulateGenericHeader(RealizeCharismaStackSize, CHARISMA_TITLE, "", CHARISMA_DETAILS, CHARISMA_ICON);
	
	local totalCost:number = 0;
	local currentProgress:number = 0;
	local progressText:string = "";
	local progressResults:table = { 0 }; -- initialize with 2 elements
	local finishedProjects:table = { {} };
	
	--local bHasSpaceport:boolean = false;


	if (g_LocalPlayer ~= nil) then

		--Earnings
		totalCost = victoryEarningsAmount  
		if (g_LocalPlayer:GetProperty("CharismaVictoryPeopleRecruited")) then
			currentProgress = g_LocalPlayer:GetProperty("CharismaVictoryPeopleRecruited");
		end
		progressResults[1] = currentProgress / totalCost;

	end

	


	--local nextStep:string = "";
	--for i, result in ipairs(progressResults) do
	--	if(result < 1) then
	--		progressText = progressText .. "[ICON_Bolt]";
	--
	--	else
	--		progressText = progressText .. "[ICON_CheckmarkBlue] ";
	--	end
	--	progressText = progressText .. RICHES_REQUIREMENTS[i];
	--
	--
	--	if(i < 2) then progressText = progressText .. "[NEWLINE]"; end
	--end

	--g_activeheader.AdvisorTextCentered:SetText(progressText);


	m_CharismaIM:ResetInstances();
	m_CharismaTeamIM:ResetInstances();

	
	local teamIDs = GetAliveMajorTeamIDs();
	for _, teamID in ipairs(teamIDs) do
		local team = Teams[teamID];
		if (team ~= nil) then
			if #team > 1 then
				PopulateCharismaTeamInstance(m_CharismaTeamIM:GetInstance(), teamID);
			else 
				local pPlayer = Players[team[1]];
				if (pPlayer:IsAlive() == true and pPlayer:IsMajor() == true) then
					PopulateCharismaInstance(m_CharismaIM:GetInstance(), pPlayer);
				end
			end
		end
	end
	

	RealizeCharismaStackSize();
end


function PopulateCharismaTeamInstance(instance:table, teamID:number)

	PopulateTeamInstanceShared(instance, teamID);

	-- Add team members to player stack
	if instance.PlayerStackIM == nil then
		instance.PlayerStackIM = InstanceManager:new("CharismaInstance", "ButtonBG", instance.CharismaPlayerInstanceStack);
	end

	instance.PlayerStackIM:ResetInstances();

	local teamProgressData:table = {};
	for i, playerID in ipairs(Teams[teamID]) do
		if IsAliveAndMajor(playerID) then
			local pPlayer:table = Players[playerID];
			local progressData = PopulateCharismaInstance(instance.PlayerStackIM:GetInstance(), pPlayer);
			if progressData then
				table.insert(teamProgressData, progressData);
			end
		end
	end

	

	-- Sort team progress data
	table.sort(teamProgressData, function(a, b)
		-- Compare stage 1 progress
		local aScore = a.richesGoalsProgress[1] / victoryEarningsAmount;
		local bScore = b.richesGoalsProgress[1] / victoryEarningsAmount;
		if aScore == bScore then
			return a.playerID < b.playerID;
		end
		return aScore > bScore;
	end);

	-- Populate the team progress with the progress of the furthest player
	if teamProgressData and #teamProgressData > 0 then
		PopulateCharismaProgressMeters(instance, teamProgressData[1]);
	end

	
end

function PopulateCharismaInstance(instance:table, pPlayer:table)
	local playerID:number = pPlayer:GetID();
	PopulatePlayerInstanceShared(instance, playerID);
	
	-- Progress Data to be returned from function
	local progressData = nil; 

	local charismaGoalsTotals = { 0 };
	local charismaGoalsProgress = { 0  };
	local charismaGoalsFinished = { {}  };

	
	charismaGoalsProgress[1] = 0
	charismaGoalsTotals[1] = 0
	if pPlayer:GetProperty("CharismaVictoryPeopleRecruited") then
		charismaGoalsProgress[1] = pPlayer:GetProperty("CharismaVictoryPeopleRecruited")
		charismaGoalsTotals[1] = pPlayer:GetProperty("CharismaVictoryPeopleRecruited")
	end

	if charismaGoalsProgress[1] > victoryRecruitmentAmount then
		charismaGoalsProgress[1] = victoryRecruitmentAmount
	end


	

	-- Save data to be returned
	progressData = {}; --most progress being saved as player variables
	progressData.charismaGoalsTotals = charismaGoalsTotals;
	progressData.charismaGoalsProgress = charismaGoalsProgress;
	progressData.charismaGoalsFinished = charismaGoalsFinished; 
	progressData.playerID = playerID;


	PopulateCharismaProgressMeters(instance, progressData);

	return progressData;
end

function PopulateCharismaProgressMeters(instance:table, progressData:table)

	
	instance.ObjBG_1:SetToolTipString( Locale.Lookup("CHARISMA_VICTORY_RECRUITMENT_TOOLTIP", victoryRecruitmentAmount, progressData.charismaGoalsTotals[1]) );
	--instance.ObjBG_2:SetToolTipString( Locale.Lookup("RICHES_VICTORY_STOCKPILE_TOOLTIP", victoryStockpileAmount, progressData.richesGoalsTotals[2]) );

	--Earnings 
	local denom1 = victoryRecruitmentAmount
	if denom1 < 1 then
		denom1 = 1
		progressData.charismaGoalsProgress[1] = 1
	end

	instance["ObjHidden_" .. 1]:SetHide(true);
	instance["ObjFill_" .. 1]:SetHide(progressData.charismaGoalsProgress[1] == 0);
	instance["ObjBar_" .. 1]:SetPercent(progressData.charismaGoalsProgress[1] / denom1);
	instance["ObjToggle_ON_" .. 1]:SetHide(progressData.charismaGoalsProgress[1] < victoryRecruitmentAmount);


	
end

function RealizeCharismaStackSize()
	local _, screenY:number = UIManager:GetScreenSizeVal();

	if(g_activeheader[DATA_FIELD_HEADER_EXPANDED]) then
		local headerHeight:number = g_activeheader[DATA_FIELD_HEADER_HEIGHT];
		--headerHeight = headerHeight + g_activeheader.AdvisorTextCentered:GetSizeY() + g_activeheader.AdvisorTextNextStep:GetSizeY() + (PADDING_HEADER * 2);
		g_activeheader.AdvisorIcon:SetOffsetY(OFFSET_ADVISOR_ICON_Y + headerHeight);
		g_activeheader.HeaderFrame:SetSizeY(OFFSET_ADVISOR_TEXT_Y + headerHeight);
		g_activeheader.ContractHeaderButton:SetOffsetY(OFFSET_CONTRACT_BUTTON_Y + headerHeight);
		Controls.CharismaViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS + headerHeight + PADDING_HEADER);
		Controls.CharismaViewScrollbar:SetSizeY(screenY - (SIZE_STACK_DEFAULT + (headerHeight + PADDING_HEADER)));
		g_activeheader.AdvisorTextCentered:SetHide(false);
		--g_activeheader.AdvisorTextNextStep:SetHide(false);
	else
		Controls.CharismaViewContents:SetOffsetY(OFFSET_VIEW_CONTENTS);
		Controls.CharismaViewScrollbar:SetSizeY(screenY - SIZE_STACK_DEFAULT);
		g_activeheader.AdvisorTextCentered:SetHide(true);
		--g_activeheader.AdvisorTextNextStep:SetHide(true);
	end

	RealizeStackAndScrollbar(Controls.CharismaViewStack, Controls.CharismaViewScrollbar, true);

	--local textSize:number = Controls.ScienceDetailsButton:GetTextControl():GetSizeX();
	--Controls.ScienceDetailsButton:SetSizeX(textSize + PADDING_SCORE_DETAILS_BUTTON_WIDTH);
end











--Mod\



-- ===========================================================================
-- Constructor
-- ===========================================================================
function Initialize()
	ToggleExtraTabs(); -- Start with extra tabs opened so DiplomaticVictory tab is visible by default
end
Initialize();

print("xp2 wr override was loaded")