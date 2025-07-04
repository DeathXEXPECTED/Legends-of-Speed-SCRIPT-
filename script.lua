--// CONFIGURATION
local tweenSpeed = 0 -- seconds per tween (adjust to control speed)
local waitBetweenChecks = 0 -- delay between scans

--// SERVICES
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

--// Character HumanoidRootPart setup
local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end
local hrp = getHRP()

--// Get all valid models inside orbFolder > City
local function getTargetModels()
	local orbFolder = workspace:FindFirstChild("orbFolder")
	if not orbFolder then return {} end

	local cityFolder = orbFolder:FindFirstChild("City")
	if not cityFolder then return {} end

	local models = {}
	for _, obj in ipairs(cityFolder:GetChildren()) do
		if obj:IsA("Model") and obj.PrimaryPart then
			table.insert(models, obj)
		end
	end
	return models
end

--// Tween to a model's PrimaryPart
local function tweenToModel(model)
	local tweenInfo = TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(hrp, tweenInfo, {
		CFrame = model:GetPrimaryPartCFrame()
	})
	tween:Play()
	tween.Completed:Wait()
end

--// Main looped system
task.spawn(function()
	while true do
		local targets = getTargetModels()
		if #targets == 0 then
			task.wait(waitBetweenChecks)
		else
			for _, model in ipairs(targets) do
				if model and model.Parent then
					tweenToModel(model)
					-- model:Destroy() -- optional if you want to simulate collection
					task.wait(0)
				end
			end
		end
	end
end)
