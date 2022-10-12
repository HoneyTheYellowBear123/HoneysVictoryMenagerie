-- megalopolis_victory
-- Author: HoneyTheBear
-- DateCreated: 10/12/2022 3:20:52 PM
--------------------------------------------------------------


local victoryMegaPopulationAmount = GameConfiguration.GetValue("CONFIG_MEGALOPOLIS_VIC_POPULATION0");
local victoryMegaCityAmount = GameConfiguration.GetValue("CONFIG_MEGALOPOLIS_VIC_CITIES");
local megalopolisVictoryEnabled = GameConfiguration.GetValue("CONFIG_MEGALOPOLIS_VIC");

function initMegalopolisVictory()

  print("initing megalopolis victory!")


  for playerid, playerobject in pairs(Players) do

	if playerobject:IsMajor() then

		--set to zero if the property doesn't exist yet. If it does exist, assume everything is good.
		if playerobject:GetProperty("MegalopolisVictoryTotalWorthyCities") == nil then
		    print("setting a player's total victory values to zero during init!")
			playerobject:SetProperty("MegalopolisVictoryTotalWorthyCities",0)

		end

	end

  end

end



function updateMegalopolisVictoryProgress()

	for playerid, playerobject in pairs(Players) do
      worthyPopulationSum = 0
    
	  if ( playerobject:IsMajor() and playerobject:IsAlive() ) then

		  playerCityMembers = playerobject:GetCities()
		  for i, cityObject in playerCityMembers:Members() do
			
    
			 population = cityObject:GetPopulation()
			 amenities = cityObject:GetGrowth():GetAmenities()

			 if population >= victoryMegaPopulationAmount then
				worthyPopulationSum = worthyPopulationSum + 1
			 end
		  end
		 
		  playerobject:SetProperty("MegalopolisVictoryTotalWorthyCities",worthyPopulationSum)
		  if (worthPopulationSum >= victoryMegaCityAmount) then
		      grantMegalopolisVictoryWin(playerobject)
		  end
	      
	   end

	end

end





local megalopolisBuildingIndex = GameInfo.Buildings["BUILDING_MEGALOPOLIS_VICTORY"].Index;


function grantMegalopolisVictoryWin(playerobject)

	print("grant megalopolis victory started")
	print("ending game")
	--give the player the building that grants victory but cannot be built manually
	local capital = playerobject:GetCities():GetCapitalCity();
	if capital ~= nil then
		if capital:GetBuildings():HasBuilding(charismaBuildingIndex) ~= true then
			local plotCapital = Map.GetPlot(capital:GetX(), capital:GetY());
			capital:GetBuildQueue():CreateIncompleteBuilding(megalopolisBuildingIndex, plotCapital:GetIndex(), 100);
			capital:GetBuildings():RemoveBuilding(joyousBuildingIndex);
		end
	end
end
if megalopolisVictoryEnabled then
	print("Megalopolis Victory Enabled!")
	initMegalopolisVictory()
	Events.TurnEnd.Add(updateMegalopolisVictoryProgress) --we could also check this every time a city population changes and also whenever a city is conquered but that seems excessive.
end

print("Megalopolis Victory Lua Script Loaded!")