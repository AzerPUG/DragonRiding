if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["DragonRider"] = 6
if AZP.DragonRider == nil then AZP.DragonRider = {} end

local EventFrame, CustomVigorFrame = nil, nil
local SavedVigor = 0
local MaxVigor = 0
local SavedRecharge = 0
local VigorGemWidth, VigorGemHeight = 30, 32

local hidden = false

function AZP.DragonRider:OnLoad()
    EventFrame = CreateFrame("Frame", nil, UIParent)
    EventFrame:RegisterEvent("VARIABLES_LOADED")
    EventFrame:RegisterEvent("ADDON_LOADED")
    EventFrame:SetScript("OnEvent", function(...) AZP.DragonRider:OnEvent(...) end)
end

local NewDragonRidingTextures =
{
    "dragonriding_vigor_background-2x",
    "dragonriding_vigor_decor-2x",
    "dragonriding_vigor_fill-2x",
    "dragonriding_vigor_flash-2x",
    "dragonriding_vigor_frame-2x",
    "dragonriding_vigor_spark-2x",
}

local frameTextureKitRegions = {
	BG = "%s_background",
	Frame = "%s_frame",
	Spark = "%s_spark",
	SparkMask = "%s_mask",
	Flash = "%s_flash",
};

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

    AZP.DragonRider:Hide()


    C_Timer.NewTicker(1, function() AZP.DragonRider:FillVigorFrame() end)
end

function AZP.DragonRider:Show(numVig)
    if hidden then
        CustomVigorFrame:Show()
        for i = 1, numVig do
            CustomVigorFrame.VigorGemsSlots[i]:SetSize(VigorGemWidth, VigorGemHeight)
        end
        -- for i = 1, numVig do
        --     if i == 1 then CustomVigorFrame.VigorGemsSlots[i]:SetPoint("TOPLEFT", CustomVigorFrame, "TOPLEFT", 0, -35)
        --     else CustomVigorFrame.VigorGemsSlots[i]:SetPoint("LEFT", CustomVigorFrame.VigorGemsSlots[i-1], "RIGHT", 12, 0) end
        -- end
        hidden = false
    end
end

function AZP.DragonRider:Hide()
    if not hidden then
        CustomVigorFrame:Hide()
        hidden = true
    end
end

function AZP.DragonRider:FillVigorFrame()
    local curRecharge = AZP.DragonRider:GetRechargePercent()
    local curVigor = AZP.DragonRider:GetCurrentVigor()

    if AZP.DragonRider:IsDragonRiding() == true then
        SavedVigor = curVigor
        AZP.DragonRider:Hide()
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
        if i <= SavedVigor then CustomVigorFrame.VigorGemsSlots[i].Bar:SetValue(100)
        elseif i == NextVigor then CustomVigorFrame.VigorGemsSlots[i].Bar:SetValue(curRecharge)
        else CustomVigorFrame.VigorGemsSlots[i].Bar:SetValue(0) end
        CustomVigorFrame.VigorGemsSlots[i].Spark:SetShown(i == SavedVigor + 1)
    end
    --CustomVigorFrame.VigorGemsSlots[i].Spark:SetShown(NextVigor and curRecharge > 0 and curRecharge < 100)
    if curRecharge ~= 0 then SavedRecharge = curRecharge end
end

function AZP.DragonRider:IsDragonRiding()
    -- local widgetInfo = C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo(2108);
	-- if widgetInfo and widgetInfo.shownState ~= Enum.WidgetShownState.Hidden then
    --     print("true")
    --     return true
    -- else
    --     print("false")
    --     return false
    -- end

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

function AZP.DragonRider:OnEvent(_, event, ...)
    if event == "VARIABLES_LOADED" then
        C_Timer.After(2, function()
            AZP.DragonRider:BuildVigorFrame()
            AZP.DragonRider:LoadPosition()
        end)
    end
end

AZP.DragonRider:OnLoad()
