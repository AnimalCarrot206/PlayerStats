local Stat = require(script.Parent.Stat)

type StatHolder = Stat.StatHolder

local StringStat = {}
setmetatable(StringStat, {__index = Stat})

function StringStat.new(container: Instance, name: string, initValue: string, readonly: false?)
    local self = Stat.new(container, name, "string", initValue, readonly)
    return setmetatable(self, {__index = StringStat})
end

function StringStat:concat(holder: StatHolder, stringToConcat: string)
    local currrentValue = self:get(holder)
	self:set(holder, currrentValue .. stringToConcat)
end

return StringStat