local Players    = game:GetService("Players")
local player     = Players.LocalPlayer
local char       = player.Character or player.CharacterAdded:Wait()
local hrp        = char:WaitForChild("HumanoidRootPart")
local humanoid   = char:WaitForChild("Humanoid")
local root       = workspace:WaitForChild("Lenhador")

local enabled = false

-- UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name   = "ToggleGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size             = UDim2.new(0, 100, 0, 40)
toggleBtn.Position         = UDim2.new(1, -120, 0.5, -20)
toggleBtn.AnchorPoint      = Vector2.new(0, 0)
toggleBtn.BackgroundColor3 = Color3.new(1, 0, 0)
toggleBtn.AutoButtonColor = true
toggleBtn.Font             = Enum.Font.SourceSansBold
toggleBtn.TextSize         = 18
toggleBtn.TextColor3       = Color3.new(1,1,1)
toggleBtn.Text             = "Desligado"
toggleBtn.Parent           = screenGui

toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggleBtn.BackgroundColor3 = Color3.new(0, 1, 0)
        toggleBtn.Text = "Ligado"
    else
        toggleBtn.BackgroundColor3 = Color3.new(1, 0, 0)
        toggleBtn.Text = "Desligado"
    end
end)

local function teleportTo(part)
    if part and part:IsA("BasePart") then
        hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.3)
    end
end

local function equipMachado()
    local tool = player.Backpack:FindFirstChild("Machado")
    if tool then
        humanoid:EquipTool(tool)
        task.wait(0.5)
    end
end

while true do
    if enabled then
        for _, arvoreModel in ipairs(root:GetChildren()) do
            
            if not enabled then break end

            local promptFolder = arvoreModel:FindFirstChild("Prompt")
            local cutPrompt    = promptFolder and promptFolder:FindFirstChild("Lenhador")
            local treePart     = arvoreModel:FindFirstChild("Arvore")

            if cutPrompt and treePart and cutPrompt:IsA("ProximityPrompt") then
                
                teleportTo(treePart)
                fireproximityprompt(cutPrompt)
                task.wait(0.5)

                
                local troncoPrompt, start = nil, tick()
                repeat
                    if not enabled then break end
                    for _, obj in ipairs(arvoreModel:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and obj.Name == "Tronco" then
                            troncoPrompt = obj
                            break
                        end
                    end
                    task.wait(0.2)
                until troncoPrompt or tick() - start > 5 or not enabled

                if troncoPrompt and enabled then
                    teleportTo(troncoPrompt.Parent)
                    fireproximityprompt(troncoPrompt)
                    task.wait(0.5)
                end

                
                if enabled then
                    local entregaFolder = root:FindFirstChild("Entregar_Madeira")
                    if entregaFolder then
                        local entregaPrompt = entregaFolder:FindFirstChild("Entregar_Madeira")
                        if entregaPrompt and entregaPrompt:IsA("ProximityPrompt") then
                            teleportTo(entregaPrompt.Parent)
                            fireproximityprompt(entregaPrompt)
                            task.wait(0.2)
                        end
                    end
                    equipMachado()
                end
            end
        end
    end
    task.wait(0.15)
end