--// CONFIGURATION
local tweenSpeed = 0 -- seconds per tween (control how fast your character moves)
local waitBetweenChecks = 0 -- how often to scan when no folders are present

--// SERVICES
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

--// Setup character reference
local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart")
end
local hrp = getHRP()

--// Get all folders inside orbFolder that are Models with a PrimaryPart
local function getFolderModels()
	local orbFolder = workspace:FindFirstChild("orbFolder")
	if not orbFolder then return {} end

	local models = {}
	for _, obj in ipairs(orbFolder:GetChildren()) do
		if obj:IsA("Model") and obj.PrimaryPart then
			table.insert(models, obj)
		end
	end
	return models
end

--// Tween to the model's PrimaryPart
local function tweenToModel(model)
	local tweenInfo = TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(hrp, tweenInfo, {
		CFrame = model:GetPrimaryPartCFrame()
	})
	tween:Play()
	tween.Completed:Wait()
end

--// Main tweening loop
task.spawn(function()
	while true do
		local folders = getFolderModels()
		if #folders == 0 then
			task.wait(waitBetweenChecks)
		else
			for _, model in ipairs(folders) do
				if model and model.Parent then
					tweenToModel(model)
					-- model:Destroy() -- uncomment to remove after visit
					task.wait(0)
				end
			end
		end
	end
end)
