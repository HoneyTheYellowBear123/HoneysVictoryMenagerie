-- joyous_victory
-- Author: HoneyTheBear
-- DateCreated: 10/6/2022 9:01:42 AM
--------------------------------------------------------------




local joyousVictoryEnabled = GameConfiguration.GetValue("CONFIG_JOYOUS_VIC")
local joyousVictoryTotalNecessary = GameConfiguration.GetValue("CONFIG_JOYOUS_VIC_TOTAL")
local joyousVictoryConcurrentNecessary = GameConfiguration.GetValue("CONFIG_JOYOUS_VIC_CONCURRENT")


function initJoyousVictory()

  local amenityTable = {}
  for playerid, playerobject in pairs(Players) 

	if playerobject:IsMajor() then

		--set to zero if the property doesn't exist yet. If it does exist, assume everything is good.
		if playerobject:GetProperty("JoyousVictoryTotalTurnsHappiest") == nil then
			playerobject:SetProperty("JoyousVictoryTotalTurnsHappiest",0)
			playerobject:SetProperty("JoyousVictoryTotalTurnsConcurrent",0)
		end

	end

  end

end


function updateJoyousVictoryProgress()  

  --loop through each player, in each of their cities, and find out how happy everybody is.
  local amenityTable = {}
  for playerid, playerobject in pairs(Players) do

		if ( playerobject:IsMajor() and playerobject:IsAlive() ) then

		playerCityMembers = playerObject:GetCities()
		local populationSum = 0
		local amenitiesSum = 0

		for i, cityObject in playerCityMembers:Members() do
    
			local population = cityObject:GetPopulation()
			local amenities = tomCity:GetGrowth():GetAmenities()
			

			populationSum = populationSum + population
			amenitiesSum = amenitiesSum + amenities
		end
		local amenityRatio = 0
		if (not populationSum == 0 ) then
			amenityRatio = (amenitiesSum / populationSum)
		end
		local playerEntry = { amenityRatio, playerobject }
		table.insert( amenityTable, playerEntry )
		end
	end

	--find the best ratio
	local best_ratio = 0
	for i, tableEntry in amenityTable do
		if tableEntry[1] > best_ratio  then
			best_ratio = tableEntry[1]
		end
	end
	
	--increase values for everyone with best ratio, break streak for anyone not there, and check victory for the happy ones
	for i, tableEntry in amenityTable do
		if tableEntry[1] == best_ratio  then
			tableEntry[2]:SetProperty("JoyousVictoryTotalTurnsHappiest", (tableEntry[2]:GetProperty("JoyousVictoryTotalTurnsHappiest") + 1))
			tableEntry[2]:SetProperty("JoyousVictoryTotalTurnsConcurrent", (tableEntry[2]:GetProperty("JoyousVictoryTotalTurnsConcurrent") + 1))
			if ( (tableEntry[2]:GetProperty("JoyousVictoryTotalTurnsHappiest") >= joyousVictoryTotalNecessary) and (tableEntry[2]:GetProperty("JoyousVictoryTotalTurnsConcurrent") >= joyousVictoryConcurrentNecessary)
				grantJoyousVictoryWin(tableEntry[2])
			end		
		else
			tableEntry[2]:SetProperty("JoyousVictoryTotalTurnsConcurrent", 0)
		end
	end 
end 


local joyousBuildingIndex = GameInfo.Buildings["BUILDING_JOYOUS_VICTORY"].Index;


function grantJoyousVictoryWin(playerobject)

	print("grant joyous victory started")
	print("ending game")
	--give the player the building that grants victory but cannot be built manually
	local capital = playerobject:GetCities():GetCapitalCity();
	if capital ~= nil then
		if capital:GetBuildings():HasBuilding(charismaBuildingIndex) ~= true then
			local plotCapital = Map.GetPlot(capital:GetX(), capital:GetY());
			capital:GetBuildQueue():CreateIncompleteBuilding(joyousBuildingIndex, plotCapital:GetIndex(), 100);
			capital:GetBuildings():RemoveBuilding(joyousBuildingIndex);
		end
	end
end


if joyousVictoryEnabled then
	print("Joyous Victory Enabled!")
	initJoyousVictory()
	Events.TurnEnd.Add(updateJoyousVictoryProgress)
end

print("Joyous Victory Lua Script Loaded!")