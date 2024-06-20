local Stat = require(script.Parent.Stat)

type StatHolder = Stat.StatHolder

local Flag = {}
setmetatable(Flag, {__index = Stat})

function Flag.new(container: Instance, name: string, initValue: boolean, readonly: false?)
    local self = Stat.new(container, name, "boolean", initValue, readonly)
    return setmetatable(self, {__index = Flag})
end

function Flag:negate(holder: StatHolder)
    local currentValue = self:get(holder)
    self:set(holder, not currentValue)
end
function Flag:on(holder: StatHolder)
    self:set(holder, true)
end
function Flag:off(holder: StatHolder)
    self:set(holder, false)
end

return Flag