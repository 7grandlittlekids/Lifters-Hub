local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("CustomNotificationGui") or Instance.new("ScreenGui")
screenGui.Name = "CustomNotificationGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local activeNotifications = {}

local function updateNotificationPositions()
	for i, frame in ipairs(activeNotifications) do
		local targetY = -120 - ((i - 1) * 110)
		TweenService:Create(frame, TweenInfo.new(0.25), {
			Position = UDim2.new(1, -20, 1, targetY)
		}):Play()
	end
end

function showNotification(titleText, messageText, duration)
	duration = duration or 5

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 100)
	frame.Position = UDim2.new(1, 320, 1, -120)
	frame.AnchorPoint = Vector2.new(1, 1)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 30)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.Text = titleText
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextScaled = true
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

	local message = Instance.new("TextLabel")
	message.Size = UDim2.new(1, -20, 0, 40)
	message.Position = UDim2.new(0, 10, 0, 45)
	message.Text = messageText
	message.TextColor3 = Color3.new(0.9, 0.9, 0.9)
	message.TextScaled = true
	message.BackgroundTransparency = 1
	message.Font = Enum.Font.Gotham
	message.TextXAlignment = Enum.TextXAlignment.Left
	message.TextWrapped = true
	message.Parent = frame

	table.insert(activeNotifications, 1, frame)
	updateNotificationPositions()

	TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -20, 1, frame.Position.Y.Offset)
	}):Play()

	task.delay(duration, function()
		if frame and frame.Parent then
			TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(1, 320, 1, frame.Position.Y.Offset)
			}):Play()
			task.wait(0.4)
			frame:Destroy()
			for i = #activeNotifications, 1, -1 do
				if activeNotifications[i] == frame then
					table.remove(activeNotifications, i)
					break
				end
			end
			updateNotificationPositions()
		end
	end)
end
