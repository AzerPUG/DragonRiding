if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["DragonRider"] = 1
if AZP.DragonRider == nil then AZP.DragonRider = {} end

local EventFrame = nil
local SavedVigor = 0
local MaxVigor = 0
local SavedRecharge = 0

function AZP.DragonRider:OnLoad()
    EventFrame = CreateFrame("Frame", nil, UIParent)
    EventFrame:RegisterEvent("ADDON_LOADED")
    EventFrame:SetScript("OnEvent", function(...) AZP.DragonRider:OnEvent(...) end)
end

function AZP.DragonRider:BuildVigorFrame()
    print("Max Vigor:", AZP.DragonRider:GetMaxVigor())

    CustomVigorFrame = CreateFrame("FRAME", nil, UIParent)
    CustomVigorFrame:SetPoint("CENTER", 0, 0)
    CustomVigorFrame:SetSize(242, 100)
    CustomVigorFrame:SetFrameStrata("MEDIUM")
    CustomVigorFrame:SetFrameLevel(8)
    CustomVigorFrame:RegisterForDrag("LeftButton")
    CustomVigorFrame:SetMovable(true)
    CustomVigorFrame:EnableMouse(true)
    CustomVigorFrame:SetScript("OnDragStart", CustomVigorFrame.StartMoving)
    CustomVigorFrame:SetScript("OnDragStop", CustomVigorFrame.StopMovingOrSizing)

    CustomVigorFrame.RegenBar = CreateFrame("StatusBar", nil, CustomVigorFrame)
    CustomVigorFrame.RegenBar:SetSize(240, 25)
    CustomVigorFrame.RegenBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
    CustomVigorFrame.RegenBar:SetPoint("TOP", 1, -5)
    CustomVigorFrame.RegenBar:SetMinMaxValues(0, 100)
    CustomVigorFrame.RegenBar:SetValue(0)

    CustomVigorFrame.RegenBar.BG = CustomVigorFrame.RegenBar:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RegenBar.BG:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
    CustomVigorFrame.RegenBar.BG:SetAllPoints(true)
    CustomVigorFrame.RegenBar.BG:SetVertexColor(1, 0, 0)
    -- CustomVigorFrame.RegenBar.PercentText = CustomVigorFrame.RegenBar:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    -- CustomVigorFrame.RegenBar.PercentText:SetText(string.format("%d%%", CustomVigorFrame.RegenBar:GetValue()))
    -- CustomVigorFrame.RegenBar.PercentText:SetPoint("CENTER", 0, 0)
    -- CustomVigorFrame.RegenBar.PercentText:SetSize(50, 20)

    CustomVigorFrame.VigorGems = {}
    CustomVigorFrame.VigorGemsSlots = {}
    MaxVigor = AZP.DragonRider:GetMaxVigor()
    SavedVigor = MaxVigor
    for i = 1, 6 do
        CustomVigorFrame.VigorGemsSlots[i] = CustomVigorFrame:CreateTexture(nil, "BACKGROUND")
        CustomVigorFrame.VigorGemsSlots[i]:SetSize(32, 64)
        if i == 1 then CustomVigorFrame.VigorGemsSlots[i]:SetPoint("TOPLEFT", CustomVigorFrame, "TOPLEFT", 0, -35)
        else CustomVigorFrame.VigorGemsSlots[i]:SetPoint("LEFT", CustomVigorFrame.VigorGemsSlots[i-1], "RIGHT", 10, 0) end
        CustomVigorFrame.VigorGemsSlots[i]:SetAtlas("jailerstower-score-disabled-gem-icon")

        if i > MaxVigor then CustomVigorFrame.VigorGemsSlots[i]:Hide() end

        CustomVigorFrame.VigorGems[i] = CustomVigorFrame:CreateTexture(nil, "BACKGROUND")
        CustomVigorFrame.VigorGems[i]:SetSize(32, 64)
        CustomVigorFrame.VigorGems[i]:SetPoint("CENTER", CustomVigorFrame.VigorGemsSlots[i], "CENTER", 0, 0)
        CustomVigorFrame.VigorGems[i]:SetAtlas("jailerstower-score-gem-icon")
        CustomVigorFrame.VigorGems[i]:Hide()
    end

    C_Timer.NewTicker(1, function() AZP.DragonRider:FillVigorFrame() end)
end

function AZP.DragonRider:FillVigorFrame()
    if SavedVigor < MaxVigor then
        --CustomVigorFrame.RegenBar:Show()
        CustomVigorFrame.RegenBar:SetValue(AZP.DragonRider:GetRechargePercent())
        --CustomVigorFrame.RegenBar.PercentText:SetText(string.format("%d%%", CustomVigorFrame.RegenBar:GetValue()))
    else
        --CustomVigorFrame.RegenBar:Hide()
        CustomVigorFrame.RegenBar:SetValue(0)
        --CustomVigorFrame.RegenBar.PercentText:SetText("0%")
    end

    local curRecharge = AZP.DragonRider:GetRechargePercent()
    local curVigor = AZP.DragonRider:GetCurrentVigor()

    if IsMounted() == true then
        if AZP.DragonRider:IsDragonRiding() == true then
            --CustomVigorFrame:Hide()
            SavedVigor = curVigor
        end
    else
        --CustomVigorFrame:Show()
        if curRecharge < SavedRecharge and curRecharge ~= 0 then
            if SavedVigor < MaxVigor then
                SavedVigor = SavedVigor + 1
            end
        end
    end

    -- if curRecharge < SavedRecharge and curRecharge ~= 0 then
    --     print("Recharge Passed 100%")
    --     if curVigor ~= 0 then
    --         print("CurVigor =", curVigor)
    --         SavedVigor = curVigor
    --     else
    --         if SavedVigor < MaxVigor then
    --             SavedVigor = SavedVigor + 1
    --         end
    --     end
    -- end

    for i = 1, MaxVigor do
        if i <= SavedVigor then CustomVigorFrame.VigorGems[i]:Show()
        else CustomVigorFrame.VigorGems[i]:Hide() end
    end
    if curRecharge ~= 0 then SavedRecharge = curRecharge end
end

function AZP.DragonRider:IsDragonRiding()
    for i = 1, 40 do
        local SpellName, _, _, _, _, _, _, _, _, SpellID  = UnitBuff("PLAYER", i)
        if SpellID == nil then return false end
        --if SpellID ~= 335148 then print(SpellName, ":", SpellID) end

        if SpellID == 368896 then
            -- 368896 == Renewed Proto-Drake
            -- ? == Highland Drake
            -- ? == ??
            -- ? == ??
            return true
        end
    end
end

function AZP.DragonRider:GetRechargePercent()
    return C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(4220).barValue
end

function AZP.DragonRider:GetMaxVigor()
    return #C_UIWidgetManager.GetTextureAndTextRowVisualizationInfo(4216).entries
end

function AZP.DragonRider:GetCurrentVigor()
    return #C_UIWidgetManager.GetTextureAndTextRowVisualizationInfo(4217).entries
end

function AZP.DragonRider:OnEvent(_, event, ...)
    if event == "ADDON_LOADED" then
        if ... == "AzerPUGsDragonRider" then
            print("AzerPUGsDragonRider Loaded!")
            AZP.DragonRider:BuildVigorFrame()
        end
    end
end

AZP.DragonRider:OnLoad()