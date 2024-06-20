local StatsFolder = SomeFolderHere

local Stat = require(script.Stat)
local StringStat = require(script.StringStat)
local NumberStat = require(script.NumberStat)
local Flag = require(script.Flag)

local PlayerStats = {}
PlayerStats.Stats = {
	SomeNumberStat = NumberStat.new(StatsFolder, "SomeNumberStat", 0, math.huge, 0),
	SomeFlag = Flag.new(StatsFolder, "SomeFlag", true, false),
	SomeStringStat = StringStat.new(StatsFolder, "SomeStringStat", "", false),
}

if RunService:IsServer() then
	function PlayerStats:_assignPlayer(holderId: number)
		for _, stat in pairs(PlayerStats.Stats) do
			stat:resetToDefault(holderId)
		end
	end
	
	function PlayerStats:_unassignPlayer(holderId: number)
		for _, stat in pairs(PlayerStats.Stats) do
			stat:remove(holderId)
		end
	end
end

return PlayerStats
