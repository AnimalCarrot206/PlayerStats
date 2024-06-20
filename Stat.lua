local t = require(script.t)

export type StatHolder = Player | number

local function getHolder(holder: StatHolder)
	if t.instance("Player")(holder) then
		return tostring(holder.UserId)
	elseif t.number(holder) then
		return tostring(holder)
	end
	error("StatHolder expected, got " .. typeof(holder))
end

local Stat = {}
Stat.REMOVED_VALUE = "REMOVED"
Stat.__index = Stat

function Stat.new(container: Folder, name: string, type: string, initValue: any, readonly: false?)
	assert(t.Instance(container))
	assert(t.string(name))
	assert(t.string(type))
	assert(t.typeof(type)(initValue))
	
	if not t.boolean(readonly) then
		readonly = false
	end

	local folder
	if RunService:IsClient() then
		folder = container:WaitForChild(name)
	else
		folder = Instance.new("Folder")
		folder.Name = name
	end

	local newStat = {
		name = name,
		type = type,
		initValue = initValue,
		readonly = readonly,
		folder = folder,
	}

	folder.Parent = container

	return setmetatable(newStat, Stat)
end

function Stat:get(holder: StatHolder)
	holder = getHolder(holder)
	local folder = self.folder
	local value = folder:GetAttribute(holder)
	if value == nil or value == Stat.REMOVED_VALUE then
		value = self.initValue
	end
	return value
end

function Stat:set(holder: StatHolder, value: any)
	holder = getHolder(holder)
	assert(t.typeof(self.type)(value))
	assert(self.readonly == false)
	
	local folder = self.folder
	folder:SetAttribute(holder, value)
end

function Stat:resetToDefault(holder: StatHolder)
	holder = getHolder(holder)

	local folder = self.folder
	folder:SetAttribute(holder, self.initValue)
end
function Stat:remove(holder: StatHolder)
	holder = getHolder(holder)

	local folder = self.folder
	folder:SetAttribute(holder, Stat.REMOVED_VALUE)
end

function Stat:bindToChange(holder: StatHolder, functionToBind: (newValue: any) -> ()): RBXScriptConnection
	holder = getHolder(holder)
	assert(t.callback(functionToBind))
	
	local folder = self.folder :: Folder

	local connection
	connection = folder:GetAttributeChangedSignal(holder):Connect(function()
		local value = folder:GetAttribute(holder)
		if value == Stat.REMOVED_VALUE then
			connection:Disconnect()
			folder:SetAttribute(holder, nil)
			return
		end
		functionToBind(value)
	end)
	return connection
end

return Stat
