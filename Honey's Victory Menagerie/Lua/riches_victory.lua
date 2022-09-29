-- riches_victory
-- Author: HoneyTheBear
-- DateCreated: 8/18/2022 4:14:13 PM
--------------------------------------------------------------


--pseudocode

--1. get major civs and give them an earning property and a table with their balance
--
--2. whenever a treasury gets updated, see if it was an increase and update the earning
--
--3. First one to pass a goal gets the victory
--     NO TIE HANDLING IF PEOPLE HAVE A PROBLEM WITH IT I'LL HANDLE IT HERE
--     in tie, current gold wins
--          in the case of a doulbe tie, excess wins
--             in the case of a triple tie, gold per turn wins
--                      4x tie, fuck you alphabetical order



-- I only have to check the win condition whenever gold is earned anyway. So just update check victory with another condition for gold stockpiled.


local balanceTableGlobal = {}
-- I think it would be clearer if players set the value and it was not affected by gamespeed, otherwise people are gonna have to do math.
--local gameSpeedCostMultiplier = GameInfo.GameSpeeds[GameConfiguration.GetGameSpeedType()].CostMultiplier 
local victoryEarningsAmount = GameConfiguration.GetValue("CONFIG_GOLD_VIC_EARNINGS");  
local victoryStockpileAmount = GameConfiguration.GetValue("CONFIG_GOLD_VIC_STOCKPILE");
local richesVictoryEnabled = GameConfiguration.GetValue("CONFIG_GOLD_VIC");



--1 poorly named init function
function generate_earnings_and_balance_tables()

	local earningsTable = {}
	local balanceTable = {}

	for playerid, playerobject in pairs(Players) do

		if playerobject:IsMajor() then

			
			--if we do not yet have earnings (the game was just started) set earnings to zero and create balance table
			if playerobject:GetProperty("RichesVictoryEarnings") == nil then
	
				playerobject:SetProperty("RichesVictoryEarnings",0)
				balanceTable[playerid] = playerobject:GetTreasury():GetGoldBalance()
				print("balance table updated")			

				print("player id being used with table generation")
				print(playerid)

			--if we already have earnings (saved game was loaded) just create the balance table
			else
				
				balanceTable[playerid] = playerobject:GetTreasury():GetGoldBalance()
				print("balance table updated, earnings were detected in save already.")

				

			end			

		end


	end

	balanceTableGlobal = balanceTable
	print("earnings + balance tables generated!")
end





--general function for any change in money 2
function check_difference(playerID, yield, balance)
	print("treasury update!")


	local player = Players[playerID]
	if (player:IsAlive() and player:IsMajor()) then
		local oldtreasurybalance = balanceTableGlobal[playerID]
		local newtreasurybalance = player:GetTreasury():GetGoldBalance()
		player:SetProperty("CurrentGoldStockpile", newtreasurybalance) --used by WR UI code since I can't call GetTreasury in UI context

		print("player id being used with check difference")
		print(playerID)

		--update earnings if there was profit
		if ( (newtreasurybalance - oldtreasurybalance) > 0) then

		  local oldEarning = Players[playerID]:GetProperty("RichesVictoryEarnings")
		  local newEarning =  oldEarning + (newtreasurybalance - oldtreasurybalance)
		  Players[playerID]:SetProperty("RichesVictoryEarnings",newEarning)

		  print("new total earnings!")
		  print(newEarning)

		  check_victory(playerID,newEarning)

		end

		--update balance, even if there was a loss, so we can measure future profit accurately.
		balanceTableGlobal[playerID] = newtreasurybalance
	end
end


--check victory 3
--no tie handling yet
function check_victory(playerID,totalEarnings)
	
	
		
	if ( ( totalEarnings >= victoryEarningsAmount ) and ( Players[playerID]:GetTreasury():GetGoldBalance() >= victoryStockpileAmount ) ) then
		print("earnings maxed! granting victory")
		grant_victory(playerID)

	end

	
end



local richesBuildingIndex = GameInfo.Buildings["BUILDING_RICHES_VICTORY"].Index;

function grant_victory(playerID)
    print("grant riches victory started")

	local winner = Players[playerID]

	print("ending game")

	--give the player the building that grants victory but cannot be built manually
	local capital = Players[playerID]:GetCities():GetCapitalCity();
	if capital ~= nil then
		if capital:GetBuildings():HasBuilding(richesBuildingIndex) ~= true then
			local plotCapital = Map.GetPlot(capital:GetX(), capital:GetY());
			capital:GetBuildQueue():CreateIncompleteBuilding(richesBuildingIndex, plotCapital:GetIndex(), 100);
			capital:GetBuildings():RemoveBuilding(richesBuildingIndex);
		end
	end


end





--if the riches victory is not enabled, don't even count this nonsense.
if richesVictoryEnabled then

	print("riches victory enabled!")
	--init
	generate_earnings_and_balance_tables()
	
	Events.TreasuryChanged.Add(check_difference)
	
	
end	




print("riches victory script fully loaded")

