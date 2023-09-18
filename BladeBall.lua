local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local heartbeatConnection

local Window = Rayfield:CreateWindow({
   Name = "Blade Ball",
   LoadingTitle = "Universe CARALHO",
   LoadingSubtitle = "Leossin Xernous Gay",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "Universe Hub",
      FileName = "Universe Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },
   KeySystem = false,
   KeySettings = {
      Title = "",
      Subtitle = "",
      Note = "",
      FileName = "",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = ""
   }
})

local AutoParry = Window:CreateTab("Main", 13014537525)

local function startAutoParry()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local runService = game:GetService("RunService")
    local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
    local ballsFolder = workspace:WaitForChild("Balls")


    local function onCharacterAdded(newCharacter)
        character = newCharacter
    end

    player.CharacterAdded:Connect(onCharacterAdded)

    local focusedBall = nil  

    local function chooseNewFocusedBall()
        local balls = ballsFolder:GetChildren()
        focusedBall = nil
        for _, ball in ipairs(balls) do
            if ball:GetAttribute("realBall") == true then
                focusedBall = ball
                break
            end
        end
    end

    chooseNewFocusedBall()

    local function timeUntilImpact(ballVelocity, distanceToPlayer, playerVelocity)
        local directionToPlayer = (character.HumanoidRootPart.Position - focusedBall.Position).Unit
        local velocityTowardsPlayer = ballVelocity:Dot(directionToPlayer) - playerVelocity:Dot(directionToPlayer)
        
        if velocityTowardsPlayer <= 0 then
            return math.huge
        end
        
        local distanceToBeCovered = distanceToPlayer - 40
        return distanceToBeCovered / velocityTowardsPlayer
    end

    local BASE_THRESHOLD = 0.15
    local VELOCITY_SCALING_FACTOR = 0.002

    local function getDynamicThreshold(ballVelocityMagnitude)
        local adjustedThreshold = BASE_THRESHOLD - (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR)
        return math.max(0.12, adjustedThreshold)
    end

    local function checkBallDistance()
        if not character:FindFirstChild("Highlight") then return end
        local charPos = character.PrimaryPart.Position
        local charVel = character.PrimaryPart.Velocity

        if focusedBall and not focusedBall.Parent then
            chooseNewFocusedBall()
        end

        if not focusedBall then return end

        local ball = focusedBall
        local distanceToPlayer = (ball.Position - charPos).Magnitude

        if distanceToPlayer < 10 then
            parryButtonPress:Fire()
            return
        end

        local timeToImpact = timeUntilImpact(ball.Velocity, distanceToPlayer, charVel)
        local dynamicThreshold = getDynamicThreshold(ball.Velocity.Magnitude)

        if timeToImpact < dynamicThreshold then
            parryButtonPress:Fire()
        end
    end
    heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
        checkBallDistance()
    end)
end

local function stopAutoParry()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

local AutoParryToggle = AutoParry:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = false,
    Flag = "AutoParryFlag",
    Callback = function(Value)
        if Value then
            startAutoParry()
        else
            stopAutoParry()
        end
    end,
})

local Skill = Window:CreateTab("Skills", 13014537525)

local localPlayer = game.Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local abilitiesFolder = character:WaitForChild("Abilities")

    Skill:CreateButton({
        Name = "Dash",
        Callback = function()
        ChosenAbility = "Dash"
        end
    })

    Skill:CreateButton({
        Name = "Forcefield",
        Callback = function()
        ChosenAbility = "Forcefield"
        end
    })

    Skill:CreateButton({
        Name = "Invisibility",
        Callback = function()
        ChosenAbility = "Invisibility"
        end
    })

    Skill:CreateButton({
        Name = "Platform",
        Callback = function()
        ChosenAbility = "Platform"
        end
    })

    Skill:CreateButton({
        Name = "Raging Deflection",
        Callback = function()
        ChosenAbility = "Raging Deflection"
        end
    })
    Skill:CreateButton({
        Name = "Super Jump",
        Callback = function()
        ChosenAbility = "Super Jump"
        end
    })
    Skill:CreateButton({
        Name = "Telekinesis",
        Callback = function()
        ChosenAbility = "Telekinesis"
        end
    })
    Skill:CreateButton({
        Name = "Thunder Dash",
        Callback = function()
        ChosenAbility = "Thunder Dash"
        end
    })


local function onCharacterAdded(newCharacter)
    character = newCharacter
    abilitiesFolder = character:WaitForChild("Abilities")
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)

local function AbilityUpdater()
    while true do
        if abilitiesFolder then
            for _, obj in pairs(abilitiesFolder:GetChildren()) do
                if obj:IsA("LocalScript") then
                    if obj.Name == ChosenAbility then
                        obj.Disabled = false
                    else
                        obj.Disabled = true
                    end
                end
            end
        end
        task.wait()
    end
end

spawn(AbilityUpdater)

AutoParry:CreateToggle({
    Name = "Skill No CoolDown",
    CurrentValue = false, 
    Flag = "Toggle2",
    Callback = function(value)
        xx = value
    end
})

while task.wait(1) do
    if xx then
        for _, obj in pairs(abilitiesFolder:GetChildren()) do
            if obj:IsA("LocalScript") then
                obj.Disabled = not obj.Disabled
            end
        end
    end
end 
