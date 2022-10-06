-- joyous_victory
-- Author: HoneyTheBear
-- DateCreated: 10/6/2022 9:01:42 AM
--------------------------------------------------------------




local joyousVictoryEnabled = GameConfiguration.GetValue("CONFIG_JOYOUS_VIC")
local joyousVictoryTotalNecessary = GameConfiguration.GetValue("CONFIG_JOYOUS_VIC_TOTAL")
local joyousVictoryConcurrentNecessary = GameConfiguration.GetValue("CONFIG_JOYOUS_VIC_CONCURRENT")


function initJoyousVictory()

  print("initing joy victory!")


  for playerid, playerobject in pairs(Players) do

	if playerobject:IsMajor() then

		--set to zero if the property doesn't exist yet. If it does exist, assume everything is good.
		if playerobject:GetProperty("JoyousVictoryTotalTurnsHappiest") == nil then
		    print("setting a player's total victory values to zero during init!")
			playerobject:SetProperty("JoyousVictoryTotalTurnsHappiest",0)
			playerobject:SetProperty("JoyousVictoryTotalTurnsConcurrent",0)
		end

	end

  end

end


function updateJoyousVictoryProgress()  

  --loop through each player, in each of their cities, and find out how happy everybody is.
  local amenityTable = {}
  local populationSum = 0
  local amenitiesSum = 0
  local population = 0
  local amenities = 0
  for playerid, playerobject in pairs(Players) do
      populationSum = 0
      amenitiesSum = 0
    
	  if ( playerobject:IsMajor() and playerobject:IsAlive() ) then

		  print("a test")

		  playerCityMembers = playerobject:GetCities()
		  for i, cityObject in playerCityMembers:Members() do
			 print("b test")
    
			 population = cityObject:GetPopulation()
			 amenities = cityObject:GetGrowth():GetAmenities()

			 print("amenities")
			 print(amenities)
			 print("population")
			 print(population)
			
			 print("population sum in loop a")
			 print(populationSum)
			 populationSum = populationSum + population
			 print("population sum in loop b")
			 print(populationSum)
			 amenitiesSum = amenitiesSum + amenities
		  end
		  print("population sum in loop c")
	      print(populationSum)
		  local amenityRatio = 0
		  if (not (populationSum == 0) ) then
			  print("c test")
			  amenityRatio = (amenitiesSum / populationSum)
		  end
		  print("amenityRatio!")
		  print(amenityRatio)
		  local playerEntry = { amenityRatio, playerobject }
		  table.insert( amenityTable, playerEntry )
	   end
	end

	--find the best ratio
	local best_ratio = 0
	for index, entry in pairs(amenityTable) do
		print("amenityvalue!")
		print(entry[1])
		if entry[1] > best_ratio  then
			best_ratio = entry[1]	
		end
	end

	print("best value is " .. best_ratio)
	
	--increase values for everyone with best ratio, break streak for anyone not there, and check victory for the happy ones
	for index, entry in pairs(amenityTable) do
		if entry[1] == best_ratio  then
			print("incrementing joyous!")
			entry[2]:SetProperty("JoyousVictoryTotalTurnsHappiest",( entry[2]:GetProperty("JoyousVictoryTotalTurnsHappiest") + 1))
			entry[2]:SetProperty("JoyousVictoryTotalTurnsConcurrent",(entry[2]:GetProperty("JoyousVictoryTotalTurnsConcurrent") + 1))
			if ( (entry[2]:GetProperty("JoyousVictoryTotalTurnsHappiest") >= joyousVictoryTotalNecessary) and (entry[2]:GetProperty("JoyousVictoryTotalTurnsConcurrent") >= joyousVictoryConcurrentNecessary) ) then
				grantJoyousVictoryWin(entry[2])
			end		
		else
			print("decrementing joyous!")
			entry[2]:SetProperty("JoyousVictoryTotalTurnsConcurrent",0)
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