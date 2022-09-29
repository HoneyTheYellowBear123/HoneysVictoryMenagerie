-- charisma_victory
-- Author: HoneyTheBear
-- DateCreated: 9/26/2022 3:16:35 PM
--------------------------------------------------------------



--pseudocode
--major players get a property called people gained
--	event great person gained increments it by one and checks victory condition

--percentage great people is set in game

--on game start, count up all great people, portion by type to avoid gran columbia and prophet. (but allows modded great peeps)
	--take this sum to be used in the victory check

--victory check sees if player property / sum >= percentage

--need a way to pass the sum to the WR lua... Player 0 gets a property called greatPeopleVictorySumNeeded.

--just toggle great people needed for victory. include a tooltip saying how many there are without mods.

--TODO I think it makes sense that for a team game, the great people would be added together. I can work on this later though.

local victoryRecruitmentAmount = GameConfiguration.GetValue("CONFIG_CHARISMA_VIC_PEOPLE_REQ");
local charismaVictoryEnabled = GameConfiguration.GetValue("CONFIG_CHARISMA_VIC");

local int prophetID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_PROPHET"].Index

local int comandanteGeneralID = -1000
if GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_COMANDANTE_GENERAL"] then
	comandanteGeneralID = GameInfo.GreatPersonClasses["GREAT_PERSON_CLASS_COMANDANTE_GENERAL"].Index 
end


function initCharismaVictory()

	for playerid, playerobject in pairs(Players) do

		if playerobject:IsMajor() then

			--set to zero if the property doesn't exist yet. If it does exist, assume everything is good.
			if playerobject:GetProperty("CharismaVictoryPeopleRecruited") == nil then
				playerobject:SetProperty("CharismaVictoryPeopleRecruited",0)
			end

		end
	end
end 

function incrementCharismaVictory(playerID, unitID, greatPersonClassID, greatPersonIndividualID)
	print("great person gained!")

	local player = Players[playerID]
	if (player:IsAlive() and player:IsMajor()) then
		if (not ( ( greatPersonClassID == prophetID ) or ( greatPersonClassID == comandanteGeneralID ) ) ) then

			print("great person is a valid class")
			player:SetProperty("CharismaVictoryPeopleRecruited",(player:GetProperty("CharismaVictoryPeopleRecruited") + 1 ) )

			if player:GetProperty("CharismaVictoryPeopleRecruited") >= victoryRecruitmentAmount then
				grantCharismaVictoryWin(playerID)
			end
		end
	end

end


local charismaBuildingIndex = GameInfo.Buildings["BUILDING_CHARISMA_VICTORY"].Index;


function grantCharismaVictoryWin(playerID)

	 print("grant charisma victory started")

	local winner = Players[playerID]

	print("ending game")

	--give the player the building that grants victory but cannot be built manually
	local capital = Players[playerID]:GetCities():GetCapitalCity();
	if capital ~= nil then
		if capital:GetBuildings():HasBuilding(charismaBuildingIndex) ~= true then
			local plotCapital = Map.GetPlot(capital:GetX(), capital:GetY());
			capital:GetBuildQueue():CreateIncompleteBuilding(charismaBuildingIndex, plotCapital:GetIndex(), 100);
			capital:GetBuildings():RemoveBuilding(charismaBuildingIndex);
		end
	end
end



if charismaVictoryEnabled then
	print("Charisma Victory Enabled!")
	initCharismaVictory()

	Events.UnitGreatPersonCreated.Add(incrementCharismaVictory)

end

print("Charisma Victory Lua Script Loaded!")