local DefaultReachLimit = 33
local IncreasedReachDistance = 100

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function Reconnect()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local registry = debug.getregistry()
    for _, func in pairs(registry) do
        if type(func) == "function" then
            local success, isMacsploit = pcall(function()
                return is_macsploit_function(func)
            end)
          --shouldContinue = true
            if not success or not isMacsploit then
                local upvalues = {}
                for i = 1, math.min(50, debug.getinfo(func).nups or 0) do
                    local success, value = pcall(debug.getupvalue, func, i)
                    if success then
                        upvalues[i] = value
                        if type(value) == "number" and value == 20 then
                            pcall(debug.setupvalue, func, i, DefaultReachLimit)
                        end
                    end
                end
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(Reconnect)
if LocalPlayer.Character then
    task.spawn(Reconnect)
end
local function AdjustReach(distance)
    local registry = debug.getregistry()
    for _, func in pairs(registry) do
        if type(func) == "function" then
            local info = debug.getinfo(func)
            if info.name == "grab" then
                local constants = {}
                for i = 1, math.min(50, info.nconstants or 0) do
                    constants[i] = debug.getconstant(func, i)
                end
                
                if table.find(constants, "make") then
                    for i = 1, math.min(20, info.nups or 0) do
                        local success, value = pcall(debug.getupvalue, func, i)
                        if success and type(value) == "number" and value == DefaultReachLimit then
                            pcall(debug.setupvalue, func, i, distance)
                        end
                    end
                end
            end
        end
    end
end

local namecallHook
namecallHook = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and method == "FireServer" and self.Name == "Beam" then
        local action = tostring(args[1])
        
        if action == "make" then
            task.spawn(AdjustReach, IncreasedReachDistance)
        elseif action == "destroy" then
            task.spawn(AdjustReach, DefaultReachLimit)
        end
    end
    
    return namecallHook(self, ...)
end)

game:GetService("UserInputService").WindowFocused:Connect(function()
    task.wait(1)
    if not namecallHook then
        namecallHook = hookmetamethod(game, "__namecall", function(self, ...)
        end)
    end
end)

--This is a further reach currently works on all executor with hookmetamethodand debug.setupvalue and ebug.getupvalue
