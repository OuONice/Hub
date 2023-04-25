
   

local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()



----------------------------------------  Anti AFK  -------------------------------------------------------------------------------

    game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1.5)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)




---------------------------------------  Topic name  -------------------------------------------------------------------------------

local Window = Library:CreateWindow({

    Title = 'Script in Free time ',
    Center = true, 
    AutoShow = true,
})
local Tabs = {
    Main = Window:AddTab('   Main   '), 
    ['UI Settings'] = Window:AddTab('   UI Settings   '),
}



----------------------------------  TP  and Tween  Player  -------------------------------------------------------------------------
 
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('            TP Player')

LeftGroupBox:AddDropdown('MyDropdown', {
    Values = {},
    Default = 1, 
    Multi = false, 

    Text = '',
    Tooltip = '',
})


Options.MyDropdown:OnChanged(function(M)
    
    local dropdownValues = {}
    for i, player in ipairs(game:GetService("Players"):GetPlayers()) do
        table.insert(dropdownValues, player.Name)
    end
    Options.MyDropdown:SetValues(dropdownValues)
    PlayerTP = M
end)


LeftGroupBox:AddToggle('MyToggle', {
    Text = 'Tween Player',
    Default = false, 
    Tooltip = '', 
})



local function toggleChanged()
    if Toggles.MyToggle.Value then
        spawn(function()
            while Toggles.MyToggle.Value do
                local player = game.Players:FindFirstChild(PlayerTP)
                if player then
                    local destination = player.Character.HumanoidRootPart.CFrame
                    local distance = (destination.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    local speed = 350
                    local time = distance / speed
                    local TweenService = game:GetService("TweenService")
                    local Tw = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
                        CFrame = destination,
                    })
                    Tw:Play()
                    repeat 
                        wait(1) 
                    until Tw.Completed or not Toggles.MyToggle.Value
                    Tw:Cancel()
                end
                wait() 
            end
        end)
    end                     
end
          
Toggles.MyToggle:OnChanged(toggleChanged)


local MyButton = LeftGroupBox:AddButton('Refresh', function()
    local dropdownValues = {}
    for i, player in ipairs(game:GetService("Players"):GetPlayers()) do
        table.insert(dropdownValues, player.Name)
    end
    Options.MyDropdown:SetValues(dropdownValues)
end)


local MyButton2 = MyButton:AddButton('Tp Player', function()
    if PlayerTP then
        local targetPlayer = game.Players[PlayerTP]
        if targetPlayer and targetPlayer.Character then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)


----------------------------------------  Player  ----------------------------------------------------------------------------------


---No Clip


local LeftGroupBox = Tabs.Main:AddLeftGroupbox('              Mice')
LeftGroupBox:AddToggle('NOCLIP', {
    Text = 'No Clip',
    Default = false, 
    Tooltip = '', 
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function toggleChanged()
    if Toggles.NOCLIP.Value == true then
        spawn(function()
          for _, v in pairs(character:GetDescendants()) do
            pcall(function()
                if v:IsA("BasePart") then
                    v.CanCollide = false
                  end
             end)
         end
    end)
else
        if Toggles.NOCLIP.Value == false then
              spawn(function()
          for _, v in pairs(character:GetDescendants()) do
            pcall(function()
                if v:IsA("BasePart") then
                    v.CanCollide = true
                        end
                    end)
                end
            end)
        end
    end
end
Toggles.NOCLIP:OnChanged(toggleChanged)


---Click TP


LeftGroupBox:AddToggle('CLICKTP', {
    Text = 'Click TP',
    Default = false, 
    Tooltip = '', 
})

local function toggleChanged()
    if Toggles.CLICKTP.Value then
        spawn(function()
            local Player = game:GetService("Players").LocalPlayer
            local Mouse = Player:GetMouse()
            local connection
            connection = Mouse.Button1Down:connect(function()
                if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then return end
                if not Mouse.Target then return end
                Player.Character:MoveTo(Mouse.Hit.p)
            end)
            while Toggles.CLICKTP.Value do
                wait(0.1) 
            end
            connection:disconnect()
        end)
    end
end
Toggles.CLICKTP:OnChanged(toggleChanged)


---walk Speed


LeftGroupBox:AddSlider('MySlider', {
    Text = 'Walk Speed',
    Default = 16,
    Min = 16,
    Max = 250,
    Rounding = 0,
    Compact = true,
     
})


local Number = Options.MySlider.Value  

Options.MySlider:OnChanged(function()
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed  =  Options.MySlider.Value
end)


---Jump Power


LeftGroupBox:AddSlider('JUMP', {
    Text = 'JumpPower',
    Default = 45,
    Min = 45,
    Max = 250,
    Rounding = 0,
    Compact = true,
    
})


local Number = Options.JUMP.Value  
Options.JUMP:OnChanged(function()
        game.Players.LocalPlayer.Character.Humanoid.JumpPower  =  Options.JUMP.Value
end)

----------------------------------------  JOB ID  ------------------------------------------

local RightGroupBox = Tabs.Main:AddRightGroupbox('          \\\\  JOB ID  //')

RightGroupBox:AddInput('MyTextbox', {
    Default = 'Job Id Here',
    Numeric = false, 
    Finished = false, 

    Text = '',
    Tooltip = '',

    Placeholder = 'Job ID hare', 
   
})

Options.MyTextbox:OnChanged(function()

end)

local TeleService = game:GetService("TeleportService")
local Players = game:GetService("Players")


local MyButton = RightGroupBox:AddButton('GET', function()
           setclipboard(tostring(''..game.JobId..''))
end)

local MyButton2 = MyButton:AddButton('JOIN', function()
      TeleService:TeleportToPlaceInstance(game.PlaceId,Options.MyTextbox.Value,Players.LocalPlayer)
end)

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local MyButton3 = RightGroupBox:AddButton('ReJoin game', function()
    local Success, ErrorMessage = pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)

    if ErrorMessage and not Success then
        warn(ErrorMessage)
    end
end)



--------------------------------------  Save Teleport  ----------------------------------------------------------------------------

local RightGroupBox2 = Tabs.Main:AddRightGroupbox('      \\\\  Save Teleport  //')

RightGroupBox2:AddInput('MyTextbox2', {
    Default = 'Location 1',
    Numeric = false, 
    Finished = false, 

    Text = '             Place 1',
    Tooltip = '',
    Placeholder = 'Location 1', 
})

Options.MyTextbox2:OnChanged(function()

end)



RightGroupBox2:AddToggle('TWEEN1', {
    Text = 'Tween',
    Default = false, 
    Tooltip = '', 
})
local function toggleChanged()
    if Toggles.TWEEN1.Value then
        spawn(function()
            while Toggles.TWEEN1.Value do
                local coords = string.split(Options.MyTextbox2.Value, ',')
                local x = tonumber(coords[1])
                local y = tonumber(coords[2])
                local z = tonumber(coords[3])
                local destination = CFrame.new(x, y, z)
                local distance = (destination.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                local speed = 350 
                local time = distance / speed

                local TweenService = game:GetService("TweenService")
                local Tw = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
                    CFrame = destination,
                })
                Tw:Play()
                repeat wait() until not Toggles.TWEEN1.Value
                Tw:Cancel()
            end
        end)
    end
end

Toggles.TWEEN1:OnChanged(toggleChanged)


local MyButton = RightGroupBox2:AddButton('GET PLACE', function()
    local loc = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
    setclipboard(string.format("%s, %s, %s", loc.X, loc.Y, loc.Z))
end)

local MyButton2 = MyButton:AddButton('TP PLACE', function()
    local coords = string.split(Options.MyTextbox2.Value, ',')
    local x = tonumber(coords[1])
    local y = tonumber(coords[2])
    local z = tonumber(coords[3])
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
end)

----------------  save teleport ที่2
local RightGroupBox3 = Tabs.Main:AddRightGroupbox('      \\\\  Save Teleport 2  //')

RightGroupBox3:AddInput('MyTextbox3', {
    Default = 'Location 2',
    Numeric = false, 
    Finished = false, 

    Text = '             Place 2',
    Tooltip = '',
    Placeholder = 'Location 2', 
})

Options.MyTextbox3:OnChanged(function()

end)



RightGroupBox3:AddToggle('TWEEN2', {
    Text = 'Tween',
    Default = false, 
    Tooltip = '', 
})
local function toggleChanged()
    if Toggles.TWEEN2.Value then
        spawn(function()
            while Toggles.TWEEN2.Value do
                local coords = string.split(Options.MyTextbox3.Value, ',')
                local x = tonumber(coords[1])
                local y = tonumber(coords[2])
                local z = tonumber(coords[3])
                local destination = CFrame.new(x, y, z)
                local distance = (destination.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                local speed = 350 
                local time = distance / speed

                local TweenService = game:GetService("TweenService")
                local Tw = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
                    CFrame = destination,
                })
                Tw:Play()
                repeat wait() until not Toggles.TWEEN2.Value
                Tw:Cancel()
            end
        end)
    end
end

Toggles.TWEEN2:OnChanged(toggleChanged)


local MyButton22 = RightGroupBox3:AddButton('GET PLACE', function()
    local loc = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
    setclipboard(string.format("%s, %s, %s", loc.X, loc.Y, loc.Z))
end)

local MyButton222 = MyButton22:AddButton('TP PLACE', function()
    local coords = string.split(Options.MyTextbox3.Value, ',')
    local x = tonumber(coords[1])
    local y = tonumber(coords[2])
    local z = tonumber(coords[3])
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
end)

----------------  save teleport ที3
local RightGroupBox4 = Tabs.Main:AddRightGroupbox('      \\\\  Save Teleport 3  //')

RightGroupBox4:AddInput('MyTextbox4', {
    Default = 'Location 3',
    Numeric = false, 
    Finished = false, 

    Text = '             Place 3',
    Tooltip = '',
    Placeholder = 'Location 3', 
})

Options.MyTextbox4:OnChanged(function()

end)



RightGroupBox4:AddToggle('TWEEN3', {
    Text = 'Tween',
    Default = false, 
    Tooltip = '', 
})
local function toggleChanged()
    if Toggles.TWEEN3.Value then
        spawn(function()
            while Toggles.TWEEN3.Value do
                local coords = string.split(Options.MyTextbox4.Value, ',')
                local x = tonumber(coords[1])
                local y = tonumber(coords[2])
                local z = tonumber(coords[3])
                local destination = CFrame.new(x, y, z)
                local distance = (destination.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                local speed = 350 
                local time = distance / speed

                local TweenService = game:GetService("TweenService")
                local Tw = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
                    CFrame = destination,
                })
                Tw:Play()
                repeat wait() until not Toggles.TWEEN3.Value
                Tw:Cancel()
            end
        end)
    end
end

Toggles.TWEEN3:OnChanged(toggleChanged)


local MyButton33 = RightGroupBox4:AddButton('GET PLACE', function()
    local loc = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
    setclipboard(string.format("%s, %s, %s", loc.X, loc.Y, loc.Z))
end)

local MyButton333 = MyButton33:AddButton('TP PLACE', function()
    local coords = string.split(Options.MyTextbox4.Value, ',')
    local x = tonumber(coords[1])
    local y = tonumber(coords[2])
    local z = tonumber(coords[3])
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
end)

---------------------------------------  UI SETTING  ------------------------------------------------------------------------------

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
ThemeManager:SetFolder('My Hobby Script')
SaveManager:SetFolder('My Hobby Script/GameSave')
SaveManager:BuildConfigSection(Tabs['UI Settings']) 
ThemeManager:ApplyToTab(Tabs['UI Settings'])



