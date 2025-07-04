--// CONFIGURATION
local tweenSpeed = 0.1 -- Duration in seconds per tween (customizable)
local checkInterval = 0.01 -- Interval between scan cycles

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

--// Fetch valid Token models
local function getTokenModels()
	local tokens = {}
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == "Token" and obj.PrimaryPart then
			table.insert(tokens, obj)
		end
	end
	return tokens
end

--// Tween to token
local function tweenToToken(token)
	local goal = {CFrame = token:GetPrimaryPartCFrame()}
	local tweenInfo = TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(hrp, tweenInfo, goal)
	tween:Play()
	tween.Completed:Wait()
end

--// Main behavior
task.spawn(function()
	while true do
		local tokens = getTokenModels()
		if #tokens == 0 then
			print("✅ All tokens collected. Preparing kick...")
			task.wait(2)
			player:Kick("All Token models have been collected!")
			break
		end

		for _, token in ipairs(tokens) do
			if token and token.Parent then
				tweenToToken(token)
				token:Destroy() -- optional: remove after reaching
				task.wait(0.1)
			end
		end

		task.wait(checkInterval)
	end
end)
