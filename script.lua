

local Library = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau'
    )
)()

-- 🪟 Create Main Window
local Window = Library:Window({
    Title = 'Banna Town',
    Desc = 'Nexon Hub on top',
    Icon = 105059922903197,
    Theme = 'Dark',
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400),
    },
    CloseUIButton = {
        Enabled = true,
        Text = 'Nexon Hub',
    },
})

-- 📁 Common Services
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local VirtualUser = game:GetService('VirtualUser')
local VirtualInputManager = game:GetService('VirtualInputManager')
local LocalPlayer = Players.LocalPlayer

-----------------------------------------------------
-- 🏠 หน้าแรก
-----------------------------------------------------
local Tab = Window:Tab({ Title = 'หน้าแรก', Icon = 'star' })
do
    Tab:Section({ Title = 'ฟังก์ชันต่าง ๆ' })

    -- ✅ Anti-AFK Toggle
    local AntiAfkConnection
    Tab:Toggle({
        Title = 'ป้องกันหลุด (Anti-AFK)',
        Desc = 'หยุดระบบหลุดออกจากเกมอัตโนมัติ',
        Value = false,
        Callback = function(enabled)
            if enabled then
                AntiAfkConnection = LocalPlayer.Idled:Connect(function()
                    VirtualUser:Button2Down(
                        Vector2.new(0, 0),
                        workspace.CurrentCamera.CFrame
                    )
                    task.wait(1)
                    VirtualUser:Button2Up(
                        Vector2.new(0, 0),
                        workspace.CurrentCamera.CFrame
                    )
                    print(
                        '🛡️ ป้องกัน AFK: ส่ง input จำลองแล้ว'
                    )
                end)
            else
                if AntiAfkConnection then
                    AntiAfkConnection:Disconnect()
                    AntiAfkConnection = nil
                    print('🛑 Anti-AFK ปิดแล้ว')
                end
            end
        end,
    })

    -- ✅ Auto Jump AFK Bypass
    task.spawn(function()
        while true do
            VirtualInputManager:SendKeyEvent(
                true,
                Enum.KeyCode.Space,
                false,
                game
            )
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(
                false,
                Enum.KeyCode.Space,
                false,
                game
            )
            task.wait(60)
        end
    end)

    -- ✅ Respawn without cooldown
    Tab:Button({
        Title = 'เกิดใหม่ Nocooldown',
        Desc = 'ใช้แล้วออโต้ฟามจะพัง ต้องรีเกม',
        Callback = function()
            ReplicatedStorage:WaitForChild('Events')
                :WaitForChild('OnDeathEvent')
                :FireServer('LoadCharacter')
        end,
    })

    -- ✅ Spam Twitter
    local spamMessage = 'Hello!'
    local spamEnabled = false
    local spamTask

    Tab:Textbox({
        Title = 'ข้อความ Twitter',
        Desc = 'พิมพ์ข้อความที่จะส่ง',
        Placeholder = 'เช่น: ขายของตลาดโลก',
        Value = 'Hello!',
        ClearTextOnFocus = false,
        Callback = function(text)
            spamMessage = text
        end,
    })




    Tab:Toggle({
        Title = 'สแปม Twitter',
        Desc = 'ส่งข้อความ Twitter ซ้ำ ๆ',
        Value = false,
        Callback = function(state)
            spamEnabled = state
            if state then
                spamTask = task.spawn(function()
                    while spamEnabled do
                        ReplicatedStorage:WaitForChild('Events')
                            :WaitForChild('PhoneEvent')
                            :FireServer('SendTwitter', spamMessage)
                        task.wait(0.2)
                    end
                end)
            else
                spamEnabled = false
            end
        end,
    })

-- ตัวแปรสถานะการเปิด/ปิดฟีเจอร์
local cooldownConnection = nil

-- ฟังก์ชันเปิดใช้งาน bypass cooldown
local function enableBypassCooldown()
    cooldownConnection = game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
        prompt.HoldDuration = 0
    end)
end

-- ฟังก์ชันปิดการใช้งาน bypass cooldown
local function disableBypassCooldown()
    if cooldownConnection then
        cooldownConnection:Disconnect()
        cooldownConnection = nil
    end
end


Tab:Toggle({
    Title = "Bypass Nocooldown จกปูนไว+สายไฟ",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            enableBypassCooldown()
            print("Bypass Enabled")
        else
            disableBypassCooldown()
            print("Bypass Disabled")
        end
    end
})



    -- ✅ Toggle GUI
    Tab:Toggle({
        Title = 'ที่ซื้อรถ',
        Desc = '',
        Value = false,
        Callback = function(state)
            local gui = LocalPlayer:WaitForChild('PlayerGui')
                :FindFirstChild('CarShopMenu')
            if gui then
                gui.Enabled = state
            end
        end,
    })

    Tab:Toggle({
        Title = 'ร้านค้า',
        Desc = '',
        Value = false,
        Callback = function(state)
            local gui = LocalPlayer:WaitForChild('PlayerGui')
                :FindFirstChild('Menu')
                :FindFirstChild('SHOPFrame')
            if gui then
                gui.Visible = state
            end
        end,
    })

    Tab:Toggle({
        Title = 'ช็อป ปืน',
        Desc = '',
        Value = false,
        Callback = function(state)
            local gui = LocalPlayer:WaitForChild('PlayerGui')
                :FindFirstChild('Menu')
                :FindFirstChild('WeaponsShopFrame')
            if gui then
                gui.Visible = state
            end
        end,
    })

    Tab:Toggle({
        Title = 'ตลาดโลก',
        Desc = '',
        Value = false,
        Callback = function(state)
            local gui = LocalPlayer:WaitForChild('PlayerGui')
                :FindFirstChild('Menu')
                :FindFirstChild('SellSHOPFrame')
            if gui then
                gui.Visible = state
            end
        end,
    })

    -- ✅ ปลดล็อคปืน
    Tab:Button({
        Title = 'ปลดล็อคปืนทั้งหมด',
        Desc = '',
        Callback = function()
            local folder = LocalPlayer:FindFirstChild('WeaponFolder')
            if folder then
                for _, item in ipairs(folder:GetChildren()) do
                    if item:IsA('BoolValue') then
                        item.Value = true
                    end
                end
                Window:Notify({
                    Title = '✅ Success',
                    Desc = 'ปลดล็อคอาวุธเรียบร้อย!',
                    Time = 3,
                })
            else
                Window:Notify({
                    Title = '⚠️ ไม่พบ WeaponFolder',
                    Desc = 'อาจยังไม่โหลด หรือไม่มีใน Player',
                    Time = 3,
                })
            end
        end,
    })

    -- ✅ ปลดล็อครถ
    Tab:Button({
        Title = 'ปลดล็อครถทั้งหมด (อัปเดต)',
        Desc = '',
        Callback = function()
            local folder = LocalPlayer:FindFirstChild('WeaponFolder')
            if folder then
                for _, item in ipairs(folder:GetChildren()) do
                    if item:IsA('BoolValue') then
                        item.Value = true
                    end
                end
                Window:Notify({
                    Title = '✅ Success',
                    Desc = 'ปลดล็อครถเรียบร้อย!',
                    Time = 3,
                })
            else
                Window:Notify({
                    Title = '⚠️ ไม่พบ WeaponFolder',
                    Desc = 'อาจยังไม่โหลด หรือไม่มีใน Player',
                    Time = 3,
                })
            end
        end,
    })
end

Window:Line()

-----------------------------------------------------
local Black = Window:Tab({Title = "งานดำ", Icon = "tag"}) do
    Black:Section({Title = "สายงานดำ ฟารม์"})

local currentIndex = 0 -- เริ่มยังไม่เลือก

-- ✅ ฟังก์ชันวาร์ปไปยัง MeshWire แบบไม่ซ้ำ
local function TeleportNextWire()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end

    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local wiresFolder = workspace:FindFirstChild("Grey_Jobs") 
        and workspace.Grey_Jobs:FindFirstChild("Wires")

    if not wiresFolder then
        warn("❌ ไม่พบ workspace.Grey_Jobs.Wires")
        return
    end

    local children = wiresFolder:GetChildren()
    if #children == 0 then
        warn("❌ ไม่มี MeshWire ใน Wires")
        return
    end

    -- ✅ ไป index ถัดไป
    currentIndex = currentIndex + 1
    if currentIndex > #children then
        currentIndex = 1
    end

    local target = children[currentIndex]
    if target and target:IsA("BasePart") then
        hrp.CFrame = target.CFrame + Vector3.new(0, 5, 0) -- ยืนเหนือ +5 studs
        print("⚡ วาร์ปไป MeshWire หมายเลข:", currentIndex, target.Name)
    else
        warn("❌ target ไม่ใช่ BasePart")
    end
end


-- ✅ ปุ่ม UI (เปลี่ยน White เป็น Tab ของคุณ)
Black:Button({
    Title = "ขโมยสายไฟ",
    Desc = "",
    Callback = function()
         TeleportNextWire()
    end
})



    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local greyJobs = workspace:WaitForChild("Grey_Jobs", 10)
    local cementsFolder = greyJobs and greyJobs:WaitForChild("CementsFolder", 10)

    if not cementsFolder then
        Black:Label("❌ ไม่พบ CementsFolder")
        return
    end

    local cementModels = {}
    for _, model in ipairs(cementsFolder:GetChildren()) do
        if model:IsA("Model") and model.Name == "Cement" then
            -- ✅ เงื่อนไข: ต้องมี BasePart เป็นถุงซีเมนต์ ไม่ใช่แค่ฐานไม้
            local hasCementBag = false
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "Pallet" then -- หรือกรองชื่ออื่นที่เป็นถุง
                    hasCementBag = true
                    break
                end
            end

            if hasCementBag then
                table.insert(cementModels, model)
            end
        end
    end

    if #cementModels == 0 then
        Black:Label("📭 ไม่มี Cement ที่ยังมีถุงอยู่")
        return
    end

    for i, model in ipairs(cementModels) do
        local cf, _ = model:GetBoundingBox()

        Black:Button({
            Title = "วาร์ปไปจกปูน " .. i,
            Desc = "กดเพื่อวาร์ปไปตำแหน่งนี้",
            Callback = function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                hrp.CFrame = cf + Vector3.new(0, 3, 0)

                Window:Notify({
                    Title = "✅ วาร์ปสำเร็จ",
                    Desc = "ไปยัง Cement #" .. i,
                    Time = 2
                })
            end
        })
    end
end





local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local CaptureTab = Window:Tab({Title = "จับผู้ร้าย", Icon = "target"}) do
    CaptureTab:Section({Title = "🎯 ผู้เล่นที่ติด WANTED"})

    local selectedPlayer = nil
    local dropdownRef = nil
    local captureToggleRef = nil
    local captureTask = nil

    -- ✅ ฟังก์ชันดึงรายชื่อผู้เล่นที่ติด WANTED
    local function GetWantedPlayers()
        local wantedPlayers = {}

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    local head = character:FindFirstChild("Head")
                    if head then
                        local nameTag = head:FindFirstChild("NameTag")
                        if nameTag then
                            local wanted = nameTag:FindFirstChild("WANTED")
                            if wanted and wanted:IsA("GuiObject") and wanted.Visible == true then
                                table.insert(wantedPlayers, player.Name)
                            end
                        end
                    end
                end
            end
        end

        return wantedPlayers
    end

    -- ✅ Dropdown รายชื่อ
    dropdownRef = CaptureTab:Dropdown({
        Title = "เลือกผู้ร้าย (ยังไม่เสร็จ 100%)",
        List = GetWantedPlayers(),
        Value = nil,
        Callback = function(selected)
            selectedPlayer = selected
            print("🎯 เลือกเป้าหมาย:", selected)
        end
    })

    -- ✅ รีเฟรชอัตโนมัติทุก 1 วิ
    task.spawn(function()
        while true do
            local wantedList = GetWantedPlayers()

            -- ถ้าเป้าหมายที่เลือกหลุดจาก WANTED, ให้ยกเลิก toggle
            if selectedPlayer and not table.find(wantedList, selectedPlayer) then
                if captureToggleRef then
                    captureToggleRef:SetValue(false)
                end
                selectedPlayer = nil
            end

            if dropdownRef then
                dropdownRef:Refresh(wantedList)
            end
            task.wait(1)
        end
    end)

    -- ✅ ปุ่ม Refresh รายชื่อด้วยตนเอง
    CaptureTab:Button({
        Title = "🔁 รีเฟรชรายชื่อ",
        Desc = "อัปเดตรายชื่อผู้เล่นที่ติด WANTED ทันที",
        Callback = function()
            local wantedList = GetWantedPlayers()
            if dropdownRef then
                dropdownRef:Refresh(wantedList)
                Window:Notify({
                    Title = "🔄 รีเฟรชแล้ว",
                    Desc = "อัปเดตรายชื่อผู้ร้ายล่าสุดแล้ว!",
                    Time = 2
                })
            end
        end
    })

    -- ✅ Toggle จับผู้ร้ายแบบลอย + spam
    captureToggleRef = CaptureTab:Toggle({
        Title = "🚨 จับผู้ร้ายแบบรัว ๆ",
        Desc = "เปิดเพื่อจับเป้าหมายแบบลอยตาม + รัวคำสั่งจับ",
        Value = false,
        Callback = function(state)
            if not state then
                if captureTask then
                    task.cancel(captureTask)
                    captureTask = nil
                    Window:Notify({
                        Title = "⛔️ หยุดจับแล้ว",
                        Desc = "ยกเลิกการตามจับ",
                        Time = 2
                    })
                end
                return
            end

            if not selectedPlayer then
                Window:Notify({
                    Title = "⚠️ ยังไม่ได้เลือกผู้เล่น",
                    Desc = "โปรดเลือกผู้ร้ายจาก Dropdown ก่อน",
                    Time = 3
                })
                if captureToggleRef then
                    captureToggleRef:SetValue(false)
                end
                return
            end

            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            if not targetPlayer or not targetPlayer.Character then
                Window:Notify({
                    Title = "❌ ไม่พบผู้เล่น",
                    Desc = selectedPlayer .. " อาจออกเกมไปแล้ว",
                    Time = 3
                })
                if captureToggleRef then
                    captureToggleRef:SetValue(false)
                end
                return
            end

            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not (hrp and targetHrp) then return end

            local cuffs = LocalPlayer:FindFirstChild("Backpack"):FindFirstChild("Handcuffs")
            if not (cuffs and cuffs:FindFirstChild("RemoteFunction")) then
                warn("❌ ไม่พบ Handcuffs หรือ RemoteFunction")
                if captureToggleRef then
                    captureToggleRef:SetValue(false)
                end
                return
            end

            captureTask = task.spawn(function()
                local carrying = cuffs:WaitForChild("Carrying")

                while carrying.Value ~= selectedPlayer do
                    -- ลอยตามหัวเป้าหมายแบบติด ๆ เหนือพื้น 5 studs
                    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                        hrp.Velocity = Vector3.zero
                        hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
                    end

                    -- spam จับ
                    local args = {Players:WaitForChild(selectedPlayer)}
                    cuffs.RemoteFunction:InvokeServer(unpack(args))

                    task.wait(0.15)
                end

                Window:Notify({
                    Title = "✅ จับสำเร็จ!",
                    Desc = selectedPlayer .. " ถูกจับแล้ว!",
                    Time = 3
                })
                print("✅ จับสำเร็จ:", selectedPlayer)

                if captureToggleRef then
                    captureToggleRef:SetValue(false)
                end
                captureTask = nil
            end)
        end
    })
end



    CaptureTab:Button({
        Title = "สมัครตำรวจ (Police)",
        Desc = "วาร์ปไปโรงพัก",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(770, 14, -22)
        end
    })



local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ปุ่มวาร์ปแบบลอยไปตำแหน่ง
CaptureTab:Button({
    Title = "ลอยไปเข้าคุก",
    Desc = "",
    Callback = function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        -- จุดเป้าหมาย
        local targetCFrame = CFrame.new(853, 14, -19)

        -- ตั้ง Tween
        local tweenInfo = TweenInfo.new(
            3, -- ระยะเวลา 3 วินาที (เปลี่ยนได้)
            Enum.EasingStyle.Linear, -- เคลื่อนเส้นตรง
            Enum.EasingDirection.Out
        )

        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()

        tween.Completed:Connect(function()
            Window:Notify({
                Title = "✅ สำเร็จ!",
                Desc = "คุณถูกลอยไปยังตำแหน่งที่กำหนดแล้ว",
                Time = 3
            })
        end)
    end
})




-----------------------------------------------------
-- 🧺 งานขาว (Placeholder)
-----------------------------------------------------
local White = Window:Tab({ Title = 'หาเงิน (อาชีพต่างๆ)', Icon = 'tag' })
    White:Section({ Title = 'ยังไม่มีฟังก์ชัน' })


do

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local root = Character:WaitForChild("HumanoidRootPart")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")

local running = false

-- ✅ ลบ cooldown เวลาเก็บ/กดปุ่ม E
local function Nocooldown()
	ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
		prompt.HoldDuration = 0
	end)
end

-- ✅ กดปุ่ม E จำลอง
local function pressE(times)
	times = times or 1
	for i = 1, times do
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
		task.wait(0.05)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
		task.wait(0.1)
	end
end

-- ✅ ฟังก์ชันหา Customer Part ที่แม่นยำ
local function FindCustomerTarget()
	local folder = workspace:FindFirstChild("Customer_" .. LocalPlayer.Name)
	if not folder then
		return nil
	end

	-- หาส่วนที่เป็น BasePart ที่ใกล้สุด
	local closestPart, closestDist = nil, math.huge
	for _, obj in pairs(folder:GetDescendants()) do
		if obj:IsA("BasePart") then
			local dist = (root.Position - obj.Position).Magnitude
			if dist < closestDist then
				closestDist = dist
				closestPart = obj
			end
		end
	end

	return closestPart
end

-- ✅ ฟังก์ชัน Tween วาร์ปลอยไปหาเป้าหมาย
local function TweenToTarget(targetCFrame)
	if not root then return end
	local tweenInfo = TweenInfo.new(
		1.5, -- เวลาเคลื่อน
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
end

-- ✅ ฟังก์ชันวาร์ป ส่งของ
local function WarpAndDeliver()
	Nocooldown()

	local character = LocalPlayer.Character
	if not character then return end

	local hasBox = character:FindFirstChild("Box") ~= nil

	if not hasBox then
		-- 🔹 วาร์ปไปจุดเก็บกล่อง
		root.CFrame = CFrame.new(33, 7, -186)
		task.wait(0.3)

		-- 🔹 กด E เพื่อรับกล่อง
		pressE(1)

		-- 🔹 หยิบจาก Backpack
		local backpack = LocalPlayer:FindFirstChild("Backpack")
		local box = backpack and backpack:FindFirstChild("Box")
		if box and box:IsA("Tool") then
			box.Parent = character
			print("📦 หยิบกล่อง Box ขึ้นมา")
		else
			warn("❌ ไม่พบ Box ใน Backpack")
			return
		end

		task.wait(1.5)
	else
		print("📦 พบ Box ในตัวแล้ว → ข้ามขั้นตอนรับ")
	end

	task.wait(3.5)

	-- 🔹 หา Customer Part
	local targetPart = FindCustomerTarget()
	if targetPart then
		-- 🔹 Tween ลอยไปหาเป้าหมาย
		local targetCFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
		TweenToTarget(targetCFrame)
		print("✅ ลอยไปที่ Customer_" .. LocalPlayer.Name)

		-- 🔹 กด E จำลองเพื่อส่งของ
		pressE(4)
	else
		warn("❌ ไม่พบตำแหน่งลูกค้า Customer_" .. LocalPlayer.Name)
	end
end

-- ✅ เริ่มลูปอัตโนมัติ
local function StartAutoDeliverLoop()
	Nocooldown()
	task.spawn(function()
		while running do
			pcall(WarpAndDeliver)
			task.wait(2)
		end
	end)
end

-- ✅ ปุ่ม Toggle UI
White:Toggle({
	Title = "📦 ออโต้ส่งจดหมาย",
	Desc = "",
	Value = false,
	Callback = function(v)
		running = v
		print("🔁 Auto Deliver:", running and "เริ่มทำงาน" or "หยุดแล้ว")
		if running then
			StartAutoDeliverLoop()
		end
	end
})



-- ✅ ปุ่ม Toggle UI
White:Toggle({
	Title = "ตกปลา (กำลังทำอยู่)",
	Desc = "",
	Value = false,
	Callback = function(v)
	
	end
})



end

Window:Line()



local FoodsAll = Window:Tab({Title = "ฟามหาเงิน", Icon = "tag"}) do
    FoodsAll:Section({Title = "ออโต้ฟาม สตอรเบอรรี่"})



local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local fruitData = {
    Strawberry = {
        Folder = workspace.Plants:WaitForChild("Strawberry"),
        FarmPos = Vector3.new(-4462, 36, 563),
        CraftPos = Vector3.new(-4529, 36, 614),
        ModelPath = "Model",
        Category = "🍓 ผลไม้เบอร์รี่"
    },
    Banana = {
        Folder = workspace.Plants:WaitForChild("Banana"),
        FarmPos = Vector3.new(-4564, 24, -2843),
        CraftPos = Vector3.new(-4583, 17, -2676),
        ModelPath = "Model",
        Category = "🍌 ผลไม้กล้วย"
    },

   Corn = {
        Folder = workspace.Plants:WaitForChild("Corn"),
        FarmPos = Vector3.new(-4875, 36, -3704),
        CraftPos = Vector3.new(-4848, 37, -3787),
        ModelPath = "Model",
        Category = "🌽 ผลไม้ข้าวโพด"
    },


    Apple = {
        Folder = workspace.Plants:WaitForChild("Apple"),
        FarmPos = Vector3.new(-2126, 16, -3279),
        CraftPos = Vector3.new(-2048, 17, -3191),
        ModelPath = "Model.Trunk",
        Category = "🍎 ผลไม้ทั่วไป"
    },
    Orange = {
        Folder = workspace.Plants:WaitForChild("Orange"),
        FarmPos = Vector3.new(-3620, 15, -3893),
        CraftPos = Vector3.new(-3612, 17, -3875),
        ModelPath = "Model",
        Category = "🍊 ผลไม้ส้ม"
    },
    Durian = {
        Folder = workspace.Plants:WaitForChild("Durian"),
        FarmPos = Vector3.new(-1823, 16, -1911),
        CraftPos = Vector3.new(-1869, 17, -1876),
        ModelPath = "Model",
        Category = "🥭 ผลไม้ทุเรียน"
    },
    Grape = {
        Folder = workspace.Plants:WaitForChild("Grape"),
        FarmPos = Vector3.new(-3555, 37, -167),
        CraftPos = Vector3.new(-3441, 37, -152),
        ModelPath = "Model",
        Category = "🍇 ผลไม้เบอร์รี่"
    },
    Mango = {
        Folder = workspace.Plants:WaitForChild("Mango"),
        FarmPos = Vector3.new(-1675, 39, -38),
        CraftPos = Vector3.new(-1865, 37, -126),
        ModelPath = "Model.Model",
        Category = "🥭 ผลไม้มะม่วง"
    },
Rice = {
    Folder = workspace.Plants:WaitForChild("Rice"),
    FarmPos = Vector3.new(-1434, 16, 929),
    CraftPos = Vector3.new(-1411, 17, 1081),
    ModelPath = "Model",
    Category = "🌾 พืชผลทางการเกษตร",
    ToolName = "Sickle", -- ใช้สำหรับฟาร์ม
    CraftItemName = "Wheat" -- ✅ ใช้ตรงนี้เพื่อกำหนดชื่อไอเท็มสำหรับคราฟ
},

}

local farmFlags, craftFlags = {}, {}

for name in pairs(fruitData) do
    farmFlags[name] = { enabled = false, running = false }
    craftFlags[name] = { enabled = false, running = false }
end

-- ฟังก์ชันวาร์ปแบบใหม่
local function safeTeleport(cframe)
    local Character = LocalPlayer.Character
    if not Character then 
        Character = LocalPlayer.CharacterAdded:Wait()
        task.wait(1)
    end
    
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return false end
    
    HRP.CFrame = cframe
    task.wait(0.5)
    return true
end

local function isInventoryFullByText()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return false end
    
    local menu = gui:FindFirstChild("Menu")
    if not menu then return false end
    
    local backpackFrame = menu:FindFirstChild("BackpackFrame")
    if not backpackFrame then return false end
    
    local top1 = backpackFrame:FindFirstChild("TOP1")
    if not top1 then return false end
    
    local allItem = top1:FindFirstChild("AllItem")
    if not allItem then return false end
    
    local text = allItem.Text or ""
    local current, max = text:match("^(%d+)/(%d+)$")
    return tonumber(current) and tonumber(max) and tonumber(current) >= tonumber(max)
end
local function equipOrRequestTool(toolName)
    local Character = LocalPlayer.Character
    if not Character then
        Character = LocalPlayer.CharacterAdded:Wait()
    end

    local Backpack = LocalPlayer:WaitForChild("Backpack")
    local tool = Backpack:FindFirstChild(toolName) or Character:FindFirstChild(toolName)

    if tool then
        if Backpack:FindFirstChild(toolName) then
            tool.Parent = Character
        end
    else
        local inventoryEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("InventoryEvent")
        inventoryEvent:FireServer("Use", toolName)
        task.wait(1)
    end
end

-- ฟังก์ชันค้นหา ProximityPrompt และ Part ที่แก้ไขแล้ว
local function findFruitPrompt(model, modelPath)
    -- ค้นหา ProximityPrompt ก่อน
    local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not prompt then
        return nil, nil
    end
    
    -- หา Part ที่มี Position (ต้องเป็น BasePart)
    local targetPart = nil
    
    -- ลองหา Part จาก parent ของ prompt ก่อน
    local parent = prompt.Parent
    if parent and parent:IsA("BasePart") then
        targetPart = parent
    else
        -- ถ้า parent ไม่ใช่ BasePart ให้หา BasePart ใน model
        for _, descendant in pairs(model:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
                targetPart = descendant
                break
            end
        end
    end
    
    return prompt, targetPart
end

local function collectFruit(name, data)
    local flags = farmFlags[name]
    if flags.running then return end
    flags.running = true

    local Character = LocalPlayer.Character
    if not Character then
        Character = LocalPlayer.CharacterAdded:Wait()
        task.wait(1)
    end
    
    local HRP = Character:WaitForChild("HumanoidRootPart")
    
    print("เริ่มฟาร์ม: " .. name)
    
    -- วาร์ปไปยังตำแหน่งฟาร์ม
    local farmCFrame = CFrame.new(data.FarmPos)
    if safeTeleport(farmCFrame) then
        print("วาร์ปไปฟาร์ม " .. name .. " สำเร็จ")
    else
        print("วาร์ปไปฟาร์ม " .. name .. " ล้มเหลว")
        flags.running = false
        return
    end
    
    task.wait(2)

equipOrRequestTool(data.ToolName or "Basket")

    task.wait(1)

    while flags.enabled do
        if isInventoryFullByText() then
            warn("Inventory เต็ม — หยุดชั่วคราว: " .. name)
            while isInventoryFullByText() and flags.enabled do 
                task.wait(5) 
            end
            if not flags.enabled then break end
        end

        local foundFruit = false
        for _, model in pairs(data.Folder:GetChildren()) do
            if not flags.enabled then break end
            if isInventoryFullByText() then break end

            local prompt, part = findFruitPrompt(model, data.ModelPath)
            
            -- ตรวจสอบว่า part เป็น BasePart จริงๆ
            if prompt and part and part:IsA("BasePart") then
                foundFruit = true
                
                print("พบผลไม้ " .. name)
                
                -- ตั้งค่า ProximityPrompt
                prompt.HoldDuration = 0
                prompt.RequiresLineOfSight = false
                prompt.MaxActivationDistance = 100
                
                -- วาร์ปไปยังผลไม้ (ใช้ Position จาก BasePart)
                local fruitCFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                
                if safeTeleport(fruitCFrame) then
                    task.wait(0.5)
                    
                    -- ตรวจสอบอีกครั้งก่อนเก็บ
                    if prompt and prompt:IsA("ProximityPrompt") then
                        -- พยายามเก็บหลายครั้ง
                        for i = 1, 3 do
                            fireproximityprompt(prompt)
                            task.wait(0.1)
                        end
                        print("เก็บผลไม้ " .. name .. " สำเร็จ")
                    end
                end
                task.wait(0.3)
            end
        end

        -- ถ้าไม่พบผลไม้ให้รอสักครู่ก่อนค้นหาใหม่
        if not foundFruit then
            print("ไม่พบผลไม้ " .. name .. " รอค้นหาใหม่...")
            task.wait(3)
        else
            task.wait(1)
        end
    end

    print("หยุดฟาร์ม: " .. name)
    flags.running = false
end

local function autoCraftFruit(name, data)
    local flags = craftFlags[name]
    if flags.running then return end
    flags.running = true

    local Character = LocalPlayer.Character
    if not Character then
        Character = LocalPlayer.CharacterAdded:Wait()
    end
    
    local HRP = Character:WaitForChild("HumanoidRootPart")
    
    -- วาร์ปไปยังตำแหน่งคราฟ (ถ้ามี)
    if data.CraftPos and data.CraftPos.Magnitude > 0 then
        safeTeleport(CFrame.new(data.CraftPos))
        task.wait(1)
    end

    while flags.enabled do
        local craftEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CraftEvent")
       local itemName = data.CraftItemName or name
craftEvent:FireServer("Craft_Farm", itemName, 1)

        task.wait(0.2)
    end

    flags.running = false
end

-- 🧭 แบ่งหมวดหมู่ผลไม้
local categoryOrder = {
    "🍊 ผลไม้ส้ม",
    "🍓 ผลไม้เบอร์รี่", 
    "🍌 ผลไม้ทั่วไป",
    "🌽 ข้าวโพด",
    "🥭 ผลไม้มะม่วง",
    "🌰 ผลไม้ทุเรียน",
    "🌾 พืชผลทางการเกษตร"
}


local fruitsByCategory = {}
for name, data in pairs(fruitData) do
    if not fruitsByCategory[data.Category] then
        fruitsByCategory[data.Category] = {}
    end
    table.insert(fruitsByCategory[data.Category], {name = name, data = data})
end

-- สร้าง UI แยกตามหมวดหมู่
for _, category in ipairs(categoryOrder) do
    if fruitsByCategory[category] then
        FoodsAll:Section({Title = category})
        
        for _, fruit in ipairs(fruitsByCategory[category]) do
            local name = fruit.name
            local data = fruit.data
            
            -- ไอคอนสำหรับแต่ละผลไม้
     local icons = {
    Strawberry = "🍓",
    Banana = "🍌", 
    Corn = "🌽", 
    Apple = "🍎",
    Orange = "🍊",
    Durian = "🟤",
    Grape = "🍇",
    Mango = "🥭",
    Rice = "🌾"
}

            
            local icon = icons[name] or "🍎"
            
            FoodsAll:Toggle({
                Title = icon .. " ฟาร์ม " .. name,
                Callback = function(v)
                    farmFlags[name].enabled = v
                    if v and not farmFlags[name].running then
                        task.spawn(function()
                            collectFruit(name, data)
                        end)
                    end
                end
            })

            if data.CraftPos and data.CraftPos.Magnitude > 0 then
                FoodsAll:Toggle({
                    Title = icon .. " คราฟ " .. name,
                    Callback = function(v)
                        craftFlags[name].enabled = v
                        if v and not craftFlags[name].running then
                            task.spawn(function()
                                autoCraftFruit(name, data)
                            end)
                        end
                    end
                })
            end
        end
    end
end

-- ส่วนสำหรับผลไม้ที่ไม่มีใน categoryOrder
for category, fruits in pairs(fruitsByCategory) do
    local found = false
    for _, orderedCategory in ipairs(categoryOrder) do
        if category == orderedCategory then
            found = true
            break
        end
    end
    
    if not found then
        FoodsAll:Section({Title = category})
        
        for _, fruit in ipairs(fruits) do
            local name = fruit.name
            local data = fruit.data
            
            local icons = {
                Strawberry = "🍓",
                Banana = "🍌",
                Corn = "🌽",
                Apple = "🍎", 
                Orange = "🍊",
                Durian = "🟤",
                Grape = "🍇",
                Mango = "🥭"
            }
            
            local icon = icons[name] or "🍎"
            
            FoodsAll:Toggle({
                Title = icon .. " ฟาร์ม " .. name,
                Callback = function(v)
                    farmFlags[name].enabled = v
                    if v and not farmFlags[name].running then
                        task.spawn(function()
                            collectFruit(name, data)
                        end)
                    end
                end
            })

            if data.CraftPos and data.CraftPos.Magnitude > 0 then
                FoodsAll:Toggle({
                    Title = icon .. " คราฟ " .. name,
                    Callback = function(v)
                        craftFlags[name].enabled = v
                        if v and not craftFlags[name].running then
                            task.spawn(function()
                                autoCraftFruit(name, data)
                            end)
                        end
                    end
                })
            end
        end
    end
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local root = Character:WaitForChild("HumanoidRootPart")

-- ✅ GUI แสดงเงินเพิ่ม
local moneyGui = Instance.new("ScreenGui")
moneyGui.Name = "MoneyGainGui"
moneyGui.ResetOnSpawn = false
moneyGui.Parent = CoreGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.3, 0, 0.07, 0)
label.Position = UDim2.new(0.35, 0, 0.05, 0)
label.BackgroundTransparency = 0.3
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.TextColor3 = Color3.fromRGB(0, 255, 0)
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.Text = "เงินเพิ่ม: +0"
label.Visible = false
label.Parent = moneyGui

-- ✅ ปิด HoldDuration ปุ่ม E
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
	prompt.HoldDuration = 0
end)

-- ✅ ฟังก์ชันกด E
local function pressE()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- ✅ เตรียมมีด Butcher
local function prepareKnife()
	local buyRemote = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("BuyItemEvent")
	if buyRemote then
		buyRemote:FireServer("Butcher knife")
		print("🛒 ซื้อ Butcher knife สำเร็จ")
	end

	local basket = LocalPlayer:WaitForChild("Backpack"):FindFirstChild("Butcher knife")
	if basket and basket:IsA("Tool") then
		basket.Parent = Character
	end

	local invRemote = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("InventoryEvent")
	if invRemote then
		invRemote:FireServer("Use", "Butcher knife")
		print("🧰 ใช้งาน Butcher knife")
	end
end

local stopRequested = false

-- ✅ ฟังก์ชันแปรรูป Meat ถ้ามีใน Inventory
local function checkAndProcessMeat()
	local inventory = LocalPlayer:FindFirstChild("Inventory")
	if inventory and inventory:FindFirstChild("Meat") and inventory.Meat.Value >= 1 then
		print("🍗 พบ Meat ในตัว:", inventory.Meat.Value)

		-- วาร์ปไปจุดแปรรูป
		root.CFrame = CFrame.new(-1441, 17, -91)
		task.wait(0.5)

		local args = {
			"Craft_Farm",
			"Meat",
			1
		}
		local craft = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CraftEvent")
		craft:FireServer(unpack(args))
		print("🔧 แปรรูป Meat เรียบร้อย")

		task.wait(1)

		-- กลับไปจุดฟาร์ม
		root.CFrame = CFrame.new(-1432, 17, -157)
	end
end

-- ✅ ลูปฟาร์มวัว
local function farmCowsOnce()
	local cowFolder = workspace:WaitForChild("Plants"):WaitForChild("Cow")
	local remote = cowFolder:WaitForChild("Script"):WaitForChild("RemoteEvent")

	for _, cow in ipairs(cowFolder:GetChildren()) do
		if stopRequested then
			print("🛑 หยุดฟาร์มวัว")
			return
		end

		-- 🔄 ตรวจสอบ Meat ก่อนทุกครั้ง
		checkAndProcessMeat()

		if cow:IsA("Model") and cow:FindFirstChild("Cube") then
			local cube = cow.Cube
			root.CFrame = cube.CFrame + Vector3.new(0, 5, 0)
			task.wait(0.2)

			pressE()

			remote:FireServer(cube)
			print("💥 ฆ่าวัว:", cow.Name)

			task.wait(2)

			local craft = ReplicatedStorage.Events:FindFirstChild("CraftEvent")
			if craft then
				craft:FireServer("Craft_Farm", "Meat", 1)
				print("🍖 แปรรูป Meat")
			end

			local sell = ReplicatedStorage.Events:FindFirstChild("SellEvent")
			if sell then
				sell:FireServer("Steak", 1)
				print("💸 ขาย Steak")
			end

			label.Text = "เงินเพิ่ม: +1 Steak"
			label.Visible = true
			task.wait(0.3)
			label.Visible = false

			task.wait(0.5)
		end
	end
end

-- ✅ Toggle UI ควบคุม
local running = false


   FoodsAll:Section({Title = "🥩 ฟามเนื้อ"})
FoodsAll:Toggle({
    Title = "ฟาม เนื้อวัว",
    Desc = "",
    Value = false,
    Callback = function(state)
        running = state
        stopRequested = not state
        print("📍 สถานะ AutoFarm:", running and "เริ่มทำงาน" or "หยุดทำงาน")

        if running then
            root.CFrame = CFrame.new(-1432, 17, -157)
            prepareKnife()

            task.spawn(function()
                while running do
                    pcall(farmCowsOnce)
                    task.wait(1)
                end
            end)
        end
    end
})

    


end
    Window:Line()

local tpFoods = Window:Tab({Title = "วาร์ปไปอาชีพต่างๆ", Icon = "map"}) do 
    tpFoods:Section({Title = "📍 จุดวาร์ปทั่วไป"})

    tpFoods:Button({
        Title = "จุดเกิด",
        Desc = "วาร์ปไปจุดเกิดหลัก",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(389, 7, 240)
        end
    })

    tpFoods:Button({
        Title = "ตลาดโลก",
        Desc = "วาร์ปไปโซนขายของตลาดโลก",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(372, 7, 188)
        end
    })


    tpFoods:Button({
        Title = "สนามบิน",
        Desc = "วาร์ปไปสนามบิน",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1391, 7, -316)
        end
    })

      tpFoods:Button({
        Title = "AFK โซน",
        Desc = "วาร์ปไป AFK โซน",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(946, 7, -89)
        end
    })

      tpFoods:Button({
        Title = "วัด",
        Desc = "วาร์ปไป วัด",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(42, 7, 270)
        end
    })

     tpFoods:Button({
        Title = "โซนตกปลา",
        Desc = "วาร์ปไป โซนตกปลา",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-151, 7, -502)
        end
    })


    tpFoods:Button({
        Title = "ร้านค้า",
        Desc = "วาร์ปไปร้านค้าในเมือง",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(767, 8, 174)
        end
    })

    tpFoods:Button({
        Title = "ร้านขายปืน",
        Desc = "วาร์ปไปโซนปืน",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(495, 9, 1161)
        end
    })

    tpFoods:Button({
        Title = "ร้านรถ",
        Desc = "วาร์ปไปโชว์รูมรถ",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(277, 11, 1211)
        end
    })
    tpFoods:Button({
        Title = "ร้านขายอุปกรณ์",
        Desc = "วาร์ปร้านขายอุปกรณ์",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-303, 7, 2)
        end
    })

    tpFoods:Section({Title = "👔 วาร์ปไปอาชีพ"})

    tpFoods:Button({
        Title = "ขนส่ง",
        Desc = "วาร์ปไปจุดขนส่ง",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(20, 8, -208)
        end
    })

    tpFoods:Button({
        Title = "ตำรวจ (Police)",
        Desc = "วาร์ปไปโรงพัก",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(788, 8, -72)
        end
    })

    tpFoods:Button({
        Title = "ทหาร",
        Desc = "วาร์ปไปฐานทหาร",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2885, 7, 2571)
        end
    })

    tpFoods:Button({
        Title = "พยาบาล",
        Desc = "วาร์ปไปโรงพยาบาล",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-187, 8, 1453)
        end
    })
end

Window:Line()


local tabTP = Window:Tab({Title = "วาร์ปวัตถุดิบ", Icon = "apple"}) do
    tabTP:Section({Title = "🍉 ผลไม้"})

    tabTP:Button({
        Title = "แอปเปิ้ล",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2126, 16, -3279)
        end
    })

    tabTP:Button({
        Title = "สัปปะรด",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2349, 47, 872)
        end
    })

    tabTP:Button({
        Title = "มะม่วง",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1675, 39, -38)
        end
    })

    tabTP:Button({
        Title = "สตอเบอร์รี่",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4462, 36, 563)
        end
    })

    tabTP:Button({
        Title = "ส้ม",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3620, 15, -3893)
        end
    })

    tabTP:Button({
        Title = "ทุเรียน",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1823, 16, -1911)
        end
    })

    tabTP:Button({
        Title = "กล้วย",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4564, 24, -2843)
        end
    })

    tabTP:Button({
        Title = "องุ่น",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3555, 37, -167)
        end
    })

    tabTP:Section({Title = "🌾 พืช / ธัญพืช"})

    tabTP:Button({
        Title = "ข้าว",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1538, 15, 1012)
        end
    })

    tabTP:Button({
        Title = "ข้าวโพด",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4904, 45, -3723)
        end
    })

    tabTP:Section({Title = "🍗 สัตว์ / เนื้อ"})

    tabTP:Button({
        Title = "เนื้อ",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1394, 15, -161)
        end
    })

    tabTP:Button({
        Title = "ไก่",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3115, 20, -1576)
        end
    })

    tabTP:Section({Title = "🪵 วัสดุ"})

    tabTP:Button({
        Title = "ไม้",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1422, 32, -382)
        end
    })

        tabTP:Button({
        Title = "ถ่านหิน",
        Desc = "",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1864, 7, 3275)
        end
    })

end


Window:Line()


local Player = Window:Tab({Title = "Player", Icon = "user"}) do
    Player:Section({Title = "Player Modifications"})

    -- ตัวแปรเก็บสถานะ
    local SpeedEnabled = false
    local JumpEnabled = false
    local NoclipEnabled = false
    local InfiniteJumpEnabled = false
    local FlyEnabled = false
    local CurrentSpeed = 25
    local CurrentJumpPower = 50

    local uis = game:GetService("UserInputService")
    local rs = game:GetService("RunService")
    local player = game:GetService("Players").LocalPlayer

    -- ป้องกันการเชื่อม Event ซ้ำซ้อน
    local jumpConnection
    local flyConnection

    -- ฟังก์ชันหลัก
    local function applySpeed()
        if SpeedEnabled then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = CurrentSpeed
            end
        end
    end

    local function applyJumpPower()
        if JumpEnabled then
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = CurrentJumpPower
            end
        end
    end

    -- Noclip
    local function noclipLoop()
        while NoclipEnabled do
            rs.Stepped:Wait()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end

    -- Infinite Jump
    local function infiniteJump()
        if jumpConnection then
            jumpConnection:Disconnect()
        end

        jumpConnection = uis.JumpRequest:Connect(function()
            if InfiniteJumpEnabled and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end


    -- Reset when character respawns
    local function setupCharacterReset()
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if SpeedEnabled then applySpeed() end
            if JumpEnabled then applyJumpPower() end
            if NoclipEnabled then coroutine.wrap(noclipLoop)() end
            if FlyEnabled then startFly() end
        end)
    end
    setupCharacterReset()

    -- UI

    Player:Toggle({
        Title = "วิ่งไว",
        Value = false,
        Callback = function(v)
            SpeedEnabled = v
            if v then applySpeed()
            else
                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.WalkSpeed = 16 end
            end
        end
    })

    Player:Slider({
        Title = "ปรับวิ่ง",
        Min = 16,
        Max = 250,
        Value = 25,
        Callback = function(val)
            CurrentSpeed = val
            if SpeedEnabled then applySpeed() end
        end
    })

    Player:Toggle({
        Title = "กระโดดสูง",
        Value = false,
        Callback = function(v)
            JumpEnabled = v
            if v then applyJumpPower()
            else
                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.JumpPower = 50 end
            end
        end
    })

    Player:Slider({
        Title = "ปรับกระโดด",
        Min = 50,
        Max = 200,
        Value = 50,
        Callback = function(val)
            CurrentJumpPower = val
            if JumpEnabled then applyJumpPower() end
        end
    })

    Player:Toggle({
        Title = "เดินทะลุ",
        Value = false,
        Callback = function(v)
            NoclipEnabled = v
            if v then coroutine.wrap(noclipLoop)() end
        end
    })

    Player:Toggle({
        Title = "กระโดดไม่จำกัด",
        Value = false,
        Callback = function(v)
            InfiniteJumpEnabled = v
            if v then infiniteJump()
            elseif jumpConnection then jumpConnection:Disconnect() end
        end
    })

  
    Player:Button({
        Title = "รีเซ็ทตัว",
        Callback = function()
            SpeedEnabled = false
            JumpEnabled = false
            NoclipEnabled = false
            InfiniteJumpEnabled = false
            FlyEnabled = false

            if flyConnection then flyConnection:Disconnect() end
            if jumpConnection then jumpConnection:Disconnect() end

            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                end
            end

            -- หมายเหตุ: คุณต้องจัดการรีเฟรชสถานะของ Toggle ด้วยตัวเองที่ UI Layer
        end
    })
end



Window:Line()



local Aimbot = Window:Tab({Title = "ล็อคเป้า", Icon = "user"}) do
    Aimbot:Section({Title = "โหมดล็อคหัวออโต้"})
    
    local AimbotSettings = {
        Enabled = false,
        Range = 50
    }
    
    -- ปุ่ม Toggle เปิดปิด Aimbot
    Aimbot:Toggle({
        Title = "เปิด ล็อคหัว (ออโต้)",
        Desc = "Toggle to enable or disable aimbot",
        Value = false,
        Callback = function(v)
            AimbotSettings.Enabled = v
            if v then
                print("Aimbot Enabled - Range: " .. AimbotSettings.Range)
            else
                print("Aimbot Disabled")
            end
        end
    })
    
    -- ปุ่ม Slider กำหนดระยะ
    Aimbot:Slider({
        Title = "ปรับระยะล็อคหัว",
        Min = 10,
        Max = 200,
        Rounding = 0,
        Value = 50,
        Callback = function(val)
            AimbotSettings.Range = val
            print("Aimbot Range set to: " .. val)
        end
    })
    
    -- ปุ่มทดสอบยิง
    Aimbot:Button({
        Title = "Test Shoot",
        Callback = function()
            -- ฟังก์ชันทดสอบยิง
            local function testShoot()
                print("Testing shoot function...")
                local target = findNearestTarget()
                if target then
                    shootAtTarget(target)
                else
                    print("No target available for test")
                end
            end
            testShoot()
        end
    })
    
    -- ฟังก์ชันคำนวณระยะทาง
    local function getDistance(position1, position2)
        return (position1 - position2).Magnitude
    end

    -- ฟังก์ชันหาเป้าหมายที่ใกล้ที่สุด
    local function findNearestTarget()
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        
        if not localPlayer.Character then 
            print("No local character found")
            return nil 
        end
        
        local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localRoot then 
            print("No HumanoidRootPart found")
            return nil 
        end
        
        local nearestPlayer = nil
        local nearestDistance = AimbotSettings.Range
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local character = player.Character
                local humanoid = character:FindFirstChild("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local head = character:FindFirstChild("Head")
                
                if humanoid and humanoid.Health > 0 and rootPart and head then
                    local distance = getDistance(localRoot.Position, rootPart.Position)
                    
                    if distance <= nearestDistance then
                        nearestDistance = distance
                        nearestPlayer = player
                        print("Found target: " .. player.Name .. " Distance: " .. math.floor(distance))
                    end
                end
            end
        end
        
        return nearestPlayer
    end

    -- ฟังก์ชันยิงไปที่หัวเป้าหมาย
    local function shootAtTarget(targetPlayer)
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        
        if not targetPlayer or not targetPlayer.Character then 
            print("No target player found")
            return false 
        end
        
        local head = targetPlayer.Character:FindFirstChild("Head")
        if not head then 
            print("No head found on target")
            return false 
        end
        
        local character = localPlayer.Character
        if not character then 
            print("No local character")
            return false 
        end
        
        local glock = character:FindFirstChild("Glock")
        if not glock then 
            print("No Glock found")
            return false 
        end
        
        local shootEvent = glock:FindFirstChild("ShootEvent")
        if not shootEvent then 
            print("No ShootEvent found")
            return false 
        end
        
        -- ยิงไปที่หัวเป้าหมาย
        local args = {
            Vector3.new(head.Position.X, head.Position.Y, head.Position.Z)
        }
        
        shootEvent:FireServer(unpack(args))
        print("Shot at: " .. targetPlayer.Name)
        return true
    end

    -- ฟังก์ชันล็อคหัวอัตโนมัติ
    local function autoAim()
        local target = findNearestTarget()
        if target then
            local success = shootAtTarget(target)
            if success then
                print("Auto aim successful: " .. target.Name)
            else
                print("Auto aim failed")
            end
            return target
        else
            print("No target found in range")
            return nil
        end
    end

    -- Main Aimbot Loop
    local aimbotConnection
    local function startAimbot()
        local RunService = game:GetService("RunService")
        
        if aimbotConnection then
            aimbotConnection:Disconnect()
        end
        
        aimbotConnection = RunService.Heartbeat:Connect(function()
            if AimbotSettings.Enabled then
                autoAim()
            end
        end)
    end

    -- เริ่ม Aimbot Loop
    startAimbot()
    
    -- Auto reconnect when character respawns
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    
    localPlayer.CharacterAdded:Connect(function(character)
        print("Character respawned, reinitializing aimbot...")
        wait(2) -- รอให้ character โหลดครบ
        startAimbot()
    end)

    -- Safety features - Emergency disable
    local UserInputService = game:GetService("UserInputService")
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        -- Emergency disable with Backspace key
        if input.KeyCode == Enum.KeyCode.Backspace then
            AimbotSettings.Enabled = false
            print("EMERGENCY: Aimbot Disabled")
        end
    end)

    print("Aimbot System Loaded Successfully!")
    print("Use the toggle to enable/disable aimbot")
end
Window:Line()





    local settings = Window:Tab({Title = "ตั้งค่า", Icon = "settings"}) do
    Settings:Section({Title = ""})

end
    Window:Line()

-- 🔔 Final Notification
Window:Notify({
    Title = 'Nexon Hub',
    Desc = 'โหลดทุกอย่างเสร็จสมบูรณ์! Credit leak by Nexon Hub',
    Time = 4,
})
