local t = require(script.t)

local Stat = require(script.Parent.Stat)

type StatHolder = Stat.StatHolder

local NumberStat = {}
setmetatable(NumberStat, {__index = Stat})

function NumberStat.new(container: Instance, name: string, initValue: number, max: number?, min: number?)
	t.strict(t.optional(t.number))(max)
	t.strict(t.optional(t.number))(min)

	local self = Stat.new(container, name, "number", initValue)
	self._max = max or math.huge
	self._min = min or -math.huge
	return setmetatable(self, {__index = NumberStat})
end

function NumberStat:set(holder: StatHolder, value: number)
	local currrentValue = self:get(holder)
	local minValue = self:getMin()
	local maxValue = self:getMax()

	local newValue = math.clamp(value, minValue, maxValue)
	self.__index.set(self, holder, newValue)
end
function NumberStat:add(holder: StatHolder, value: number)
	local currrentValue = self:get(holder)
	self:set(holder, currrentValue + value)
end
function NumberStat:sub(holder: StatHolder, value: number)
	local currrentValue = self:get(holder)
	self:set(holder, currrentValue - value)
end
function NumberStat:multiply(holder: StatHolder, value: number)
	local currrentValue = self:get(holder)
	self:set(holder, currrentValue * value)
end
function NumberStat:round(holder: StatHolder)
	local currrentValue = self:get(holder)
	self:set(holder, math.round(currrentValue))
end

function NumberStat:bindToIncrease(holder: StatHolder, functionToBind: (prev: number, new: number) -> ()): RBXScriptConnection
	local previousValue = self:get(holder)

	local connection
	connection = self:bindToChange(holder, function()
		local newValue = self:get(holder)
		local currentPreviousValue = previousValue
		previousValue = newValue

		if currentPreviousValue < newValue then
			functionToBind(currentPreviousValue, newValue)
		end
	end)

	return connection
end
function NumberStat:bindToDecrease(holder: StatHolder, functionToBind: (prev: number, new: number) -> ()): RBXScriptConnection
	local previousValue = self:get(holder)

	local connection
	connection = self:bindToChange(holder, function()
		local newValue = self:get(holder)
		local currentPreviousValue = previousValue
		previousValue = newValue

		if currentPreviousValue > newValue then
			functionToBind(currentPreviousValue, newValue)
		end
	end)

	return connection
end
function NumberStat:getMax()
	return self._max :: number
end
function NumberStat:getMin()
	return self._min :: number
end

return NumberStat