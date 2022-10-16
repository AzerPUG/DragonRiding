if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["DragonRider"] = 10
if AZP.DragonRider == nil then AZP.DragonRider = {} end

local EventFrame, CustomVigorFrame = nil, nil
local SavedVigor = 0
local MaxVigor = 0
local SavedRecharge = 0
local VigorGemWidth, VigorGemHeight = 30, 32
local hidden = false
local ZonesInWhichAddonIsActive = {2025}
local CurrentZone = nil
local Ticker = nil

function AZP.DragonRider:OnLoad()
    EventFrame = CreateFrame("Frame", nil, UIParent)
    EventFrame:RegisterEvent("VARIABLES_LOADED")
    EventFrame:RegisterEvent("ADDON_LOADED")
    EventFrame:RegisterEvent("ZONE_CHANGED")
    EventFrame:SetScript("OnEvent", function(...) AZP.DragonRider:OnEvent(...) end)
end

function AZP.DragonRider:BuildVigorFrame()
    CustomVigorFrame = CreateFrame("FRAME", nil, UIParent)
    CustomVigorFrame:SetSize(242, 100)
    CustomVigorFrame:SetFrameStrata("MEDIUM")
    CustomVigorFrame:SetFrameLevel(8)
    CustomVigorFrame:RegisterForDrag("LeftButton")
    CustomVigorFrame:SetMovable(true)
    CustomVigorFrame:EnableMouse(true)
    CustomVigorFrame:SetScript("OnDragStart", CustomVigorFrame.StartMoving)
    CustomVigorFrame:SetScript("OnDragStop", function() AZP.DragonRider:SavePosition() CustomVigorFrame:StopMovingOrSizing() end)

    TestVar = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(4220)

    CustomVigorFrame.VigorGemsSlots = {}
    MaxVigor = AZP.DragonRider:GetMaxVigor()
    SavedVigor = MaxVigor
    for i = 1, 6 do
        CustomVigorFrame.VigorGemsSlots[i] = CreateFrame("StatusBar", nil, CustomVigorFrame, "UIWidgetFillUpFrameTemplate")
        CustomVigorFrame.VigorGemsSlots[i]:SetSize(VigorGemWidth, VigorGemHeight)
        if i == 1 then CustomVigorFrame.VigorGemsSlots[i]:SetPoint("TOPLEFT", CustomVigorFrame, "TOPLEFT", 0, -35)
        else CustomVigorFrame.VigorGemsSlots[i]:SetPoint("LEFT", CustomVigorFrame.VigorGemsSlots[i-1], "RIGHT", 12, 0) end
        CustomVigorFrame.VigorGemsSlots[i].BG:SetAtlas("dragonriding_vigor_background")
        CustomVigorFrame.VigorGemsSlots[i].BG:SetSize(VigorGemWidth, VigorGemHeight)

        CustomVigorFrame.VigorGemsSlots[i].Bar:SetStatusBarTexture("dragonriding_vigor_fill")
        CustomVigorFrame.VigorGemsSlots[i].Bar:SetSize(VigorGemWidth, VigorGemHeight)
        CustomVigorFrame.VigorGemsSlots[i].Bar:SetMinMaxValues(0, 100)

        CustomVigorFrame.VigorGemsSlots[i].Spark:SetAtlas("dragonriding_vigor_spark")
        CustomVigorFrame.VigorGemsSlots[i].Spark:SetSize(VigorGemWidth, VigorGemHeight / 4)
        CustomVigorFrame.VigorGemsSlots[i].Spark:SetPoint("CENTER", CustomVigorFrame.VigorGemsSlots[i].Bar:GetStatusBarTexture(), "TOP", 0, 0)
        CustomVigorFrame.VigorGemsSlots[i].Spark:Hide()

        CustomVigorFrame.VigorGemsSlots[i].SparkMask:SetAtlas("dragonriding_vigor_mask")
        CustomVigorFrame.VigorGemsSlots[i].SparkMask:SetSize(VigorGemWidth * 2, VigorGemHeight * 2)

        CustomVigorFrame.VigorGemsSlots[i].Frame:SetAtlas("dragonriding_vigor_frame")
        CustomVigorFrame.VigorGemsSlots[i].Frame:SetSize(VigorGemWidth * 2, VigorGemHeight * 2)

        if i > MaxVigor then CustomVigorFrame.VigorGemsSlots[i]:Hide() end
    end

    CustomVigorFrame.LeftWing = CustomVigorFrame:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.LeftWing:SetAtlas("dragonriding_vigor_decor")
    CustomVigorFrame.LeftWing:SetTexCoord(1, 0, 0, 1)
    CustomVigorFrame.LeftWing:SetSize(46, 59)
    CustomVigorFrame.LeftWing:SetPoint("RIGHT", CustomVigorFrame, "LEFT", 14, -15)

    CustomVigorFrame.RightWing = CustomVigorFrame:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RightWing:SetAtlas("dragonriding_vigor_decor")
    CustomVigorFrame.RightWing:SetSize(46, 59)
    CustomVigorFrame.RightWing:SetPoint("LEFT", CustomVigorFrame, "RIGHT", 0, 0)
    CustomVigorFrame.RightWing:SetPoint("LEFT", CustomVigorFrame.VigorGemsSlots[MaxVigor], "RIGHT", -13, -15)

    if HideSideWings == true then
        CustomVigorFrame.LeftWing:Hide()
        CustomVigorFrame.RightWing:Hide()
    end

    AZP.DragonRider:Hide()
    AZP.DragonRider:ZoneChanged()
end

function AZP.DragonRider:BuildOptionsPanel()
    local optionFrame = CreateFrame("FRAME")
	optionFrame:SetSize(500, 500)
    optionFrame.name = "AzerPUG's Dragon Rider"
    optionFrame.parent = nil
    InterfaceOptions_AddCategory(optionFrame)

    optionFrame.title = optionFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
	optionFrame.title:SetSize(optionFrame:GetWidth(), 50)
	optionFrame.title:SetPoint("TOP")
	optionFrame.title:SetText("AzerPUG's Dragon Rider")

    optionFrame.autoHideText = optionFrame:CreateFontString("OpenOptionsFrameText", "ARTWORK", "GameFontNormalLarge")
    optionFrame.autoHideText:SetPoint("TOPLEFT", 30, -50)
    optionFrame.autoHideText:SetJustifyH("LEFT")
    optionFrame.autoHideText:SetText("Hide when maxed.")

    optionFrame.autoHideCheckbox = CreateFrame("CheckButton", nil, optionFrame, "ChatConfigCheckButtonTemplate")
    optionFrame.autoHideCheckbox:SetSize(20, 20)
    optionFrame.autoHideCheckbox:SetPoint("RIGHT", optionFrame.autoHideText, "LEFT", 0, 0)
    optionFrame.autoHideCheckbox:SetHitRectInsets(0, 0, 0, 0)
    optionFrame.autoHideCheckbox:SetChecked(VigorFrameAutoHide)
    optionFrame.autoHideCheckbox:SetScript("OnClick", function() VigorFrameAutoHide = optionFrame.autoHideCheckbox:GetChecked() end)

    optionFrame.HideWingsText = optionFrame:CreateFontString("OpenOptionsFrameText", "ARTWORK", "GameFontNormalLarge")
    optionFrame.HideWingsText:SetPoint("TOPLEFT", 30, -75)
    optionFrame.HideWingsText:SetJustifyH("LEFT")
    optionFrame.HideWingsText:SetText("Hide side wings.")

    optionFrame.WingsHideCheckbox = CreateFrame("CheckButton", nil, optionFrame, "ChatConfigCheckButtonTemplate")
    optionFrame.WingsHideCheckbox:SetSize(20, 20)
    optionFrame.WingsHideCheckbox:SetPoint("RIGHT", optionFrame.HideWingsText, "LEFT", 0, 0)
    optionFrame.WingsHideCheckbox:SetHitRectInsets(0, 0, 0, 0)
    optionFrame.WingsHideCheckbox:SetChecked(HideSideWings)
    optionFrame.WingsHideCheckbox:SetScript("OnClick", function() HideSideWings = optionFrame.WingsHideCheckbox:GetChecked() end)

    optionFrame.autoHideOutOfDragonIslesText = optionFrame:CreateFontString("OpenOptionsFrameText", "ARTWORK", "GameFontNormalLarge")
    optionFrame.autoHideOutOfDragonIslesText:SetPoint("TOPLEFT", 30, -100)
    optionFrame.autoHideOutOfDragonIslesText:SetJustifyH("LEFT")
    optionFrame.autoHideOutOfDragonIslesText:SetText("Automatically Hide outside of Dragon Isles.")

    optionFrame.autoHideOutOfDragonIslesCheckbox = CreateFrame("CheckButton", nil, optionFrame, "ChatConfigCheckButtonTemplate")
    optionFrame.autoHideOutOfDragonIslesCheckbox:SetSize(20, 20)
    optionFrame.autoHideOutOfDragonIslesCheckbox:SetPoint("RIGHT", optionFrame.autoHideOutOfDragonIslesText, "LEFT", 0, 0)
    optionFrame.autoHideOutOfDragonIslesCheckbox:SetHitRectInsets(0, 0, 0, 0)
    optionFrame.autoHideOutOfDragonIslesCheckbox:SetChecked(VigorFrameAutoHideInWrongZone)
    optionFrame.autoHideOutOfDragonIslesCheckbox:SetScript("OnClick", function() VigorFrameAutoHideInWrongZone = optionFrame.autoHideOutOfDragonIslesCheckbox:GetChecked() AZP.DragonRider:ZoneChanged() end)

    
end

function AZP.DragonRider:Show(numVig)
    if hidden then
        CustomVigorFrame:Show()
        for i = 1, numVig do
            CustomVigorFrame.VigorGemsSlots[i]:SetSize(VigorGemWidth, VigorGemHeight)
        end
        hidden = false
    end
end

function AZP.DragonRider:Hide()
    if not hidden then
        CustomVigorFrame:Hide()
        hidden = true
    end

    if HideSideWings == true then
        local PowerBarChildren = {UIWidgetPowerBarContainerFrame:GetChildren()}
        if PowerBarChildren[3] ~= nil then
            PowerBarSubChildren = {PowerBarChildren[3]:GetRegions()}
            for _, child in ipairs(PowerBarSubChildren) do
                child:Hide()
            end
        end
    end
end

function AZP.DragonRider:FillVigorFrame()
    local curRecharge = AZP.DragonRider:GetRechargePercent()
    local curVigor = AZP.DragonRider:GetCurrentVigor()

    if AZP.DragonRider:IsDragonRiding() == true then
        SavedVigor = curVigor
        AZP.DragonRider:Show(MaxVigor)

        -- AZP.DragonRider:Hide()
    else
        if curRecharge < SavedRecharge and curRecharge ~= 0 then
            if SavedVigor < MaxVigor then
                SavedVigor = SavedVigor + 1
            end
        end
        AZP.DragonRider:Show(MaxVigor)
    end

    local NextVigor = SavedVigor + 1

    for i = 1, MaxVigor do
        if i <= SavedVigor then
            CustomVigorFrame.VigorGemsSlots[i].Bar:SetValue(100)
            CustomVigorFrame.VigorGemsSlots[i].Bar:SetStatusBarTexture("dragonriding_vigor_fillfull")
        elseif i == NextVigor then
            CustomVigorFrame.VigorGemsSlots[i].Bar:SetValue(curRecharge)
            CustomVigorFrame.VigorGemsSlots[i].Bar:SetStatusBarTexture("dragonriding_vigor_fill")
        else CustomVigorFrame.VigorGemsSlots[i].Bar:SetValue(0) end
        CustomVigorFrame.VigorGemsSlots[i].Spark:SetShown(i == SavedVigor + 1)
    end
    if curRecharge ~= 0 then SavedRecharge = curRecharge end

    if VigorFrameAutoHide then
        if SavedVigor == MaxVigor then AZP.DragonRider:Hide() end
    end
end

function AZP.DragonRider:IsDragonRiding()
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, SpellID  = UnitBuff("PLAYER", i)
        if SpellID == nil then return false end
        if SpellID == 368896 or SpellID == 368899 or SpellID == 360954 or SpellID == 368901 then
            return true
        end
    end
    return false
end

function AZP.DragonRider:SavePosition()
    local v1, v2, v3, v4, v5 = CustomVigorFrame:GetPoint()
    VigorFramePosition = {v1, v2, v3, v4, v5}
end

function AZP.DragonRider:LoadPosition()
    if VigorFramePosition == nil then CustomVigorFrame:SetPoint("CENTER", 0, 0)
    else CustomVigorFrame:SetPoint(VigorFramePosition[1], VigorFramePosition[2], VigorFramePosition[3], VigorFramePosition[4], VigorFramePosition[5]) end
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

function AZP.DragonRider:ZoneChanged()
    if CustomVigorFrame == nil then 
        AZP.DragonRider:BuildVigorFrame()
        AZP.DragonRider:BuildOptionsPanel()
        AZP.DragonRider:LoadPosition()
    end

    CurrentZone = C_Map.GetBestMapForUnit("PLAYER")

    if not VigorFrameAutoHideInWrongZone then
        if Ticker == nil or Ticker:IsCancelled() then
            Ticker = C_Timer.NewTicker(1, function() AZP.DragonRider:FillVigorFrame() end)
        end
    end

    if VigorFrameAutoHideInWrongZone and tContains(ZonesInWhichAddonIsActive, CurrentZone) then
        if Ticker == nil or Ticker:IsCancelled() then
            Ticker = C_Timer.NewTicker(1, function() AZP.DragonRider:FillVigorFrame() end)
        end
    end

    if VigorFrameAutoHideInWrongZone and not tContains(ZonesInWhichAddonIsActive, CurrentZone) then
        if Ticker ~= nil then
            Ticker:Cancel()
        end
        AZP.DragonRider:Hide()
        return
    end
end

function AZP.DragonRider:OnEvent(_, event, ...)
    if event == "VARIABLES_LOADED" then
        C_Timer.After(2, function()
            AZP.DragonRider:ZoneChanged()
        end)
    elseif event == "ZONE_CHANGED" then
        AZP.DragonRider:ZoneChanged()
    end
end

AZP.DragonRider:OnLoad()
