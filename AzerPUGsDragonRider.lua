if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["DragonRider"] = 3
if AZP.DragonRider == nil then AZP.DragonRider = {} end

local EventFrame = nil
local SavedVigor = 0
local MaxVigor = 0
local SavedRecharge = 0

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
    CustomVigorFrame:SetPoint("CENTER", 0, 0)
    CustomVigorFrame:SetSize(242, 100)
    CustomVigorFrame:SetFrameStrata("MEDIUM")
    CustomVigorFrame:SetFrameLevel(8)
    CustomVigorFrame:RegisterForDrag("LeftButton")
    CustomVigorFrame:SetMovable(true)
    CustomVigorFrame:EnableMouse(true)
    CustomVigorFrame:SetScript("OnDragStart", CustomVigorFrame.StartMoving)
    CustomVigorFrame:SetScript("OnDragStop", CustomVigorFrame.StopMovingOrSizing)

    TestVar = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(4220)
    CustomVigorFrame.RegenBar = CreateFrame("StatusBar", nil, CustomVigorFrame)
    CustomVigorFrame.RegenBar:SetSize(228, 18)
    CustomVigorFrame.RegenBar:SetStatusBarTexture("widgetstatusbar-Fill-white")
    CustomVigorFrame.RegenBar:SetStatusBarColor(RARE_BLUE_COLOR:GetRGB())
    CustomVigorFrame.RegenBar:SetPoint("TOP", 1, -5)
    CustomVigorFrame.RegenBar:SetMinMaxValues(0, 100)
    CustomVigorFrame.RegenBar:SetValue(0)

    CustomVigorFrame.RegenBar.BGL = CustomVigorFrame.RegenBar:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RegenBar.BGL:SetAtlas("widgetstatusbar-BGLeft")
    CustomVigorFrame.RegenBar.BGL:SetSize(21, 18)
    CustomVigorFrame.RegenBar.BGL:SetPoint("LEFT", CustomVigorFrame.RegenBar, "LEFT", -1, 0)

    CustomVigorFrame.RegenBar.BGC = CustomVigorFrame.RegenBar:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RegenBar.BGC:SetAtlas("widgetstatusbar-BGCenter")
    CustomVigorFrame.RegenBar.BGC:SetSize(200, 18)
    CustomVigorFrame.RegenBar.BGC:SetPoint("TOP", CustomVigorFrame.RegenBar, "TOP", 0, 0)

    CustomVigorFrame.RegenBar.BGR = CustomVigorFrame.RegenBar:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RegenBar.BGR:SetAtlas("widgetstatusbar-BGRight")
    CustomVigorFrame.RegenBar.BGR:SetSize(21, 18)
    CustomVigorFrame.RegenBar.BGR:SetPoint("RIGHT", CustomVigorFrame.RegenBar, "RIGHT", 1, 0)

    CustomVigorFrame.RegenBar.BorderL = CustomVigorFrame.RegenBar:CreateTexture(nil, "OVERLAY")
    CustomVigorFrame.RegenBar.BorderL:SetAtlas("widgetstatusbar-BorderLeft")
    CustomVigorFrame.RegenBar.BorderL:SetSize(31, 30)
    CustomVigorFrame.RegenBar.BorderL:SetPoint("LEFT", CustomVigorFrame.RegenBar, "LEFT", -7, 0)

    CustomVigorFrame.RegenBar.BorderC = CustomVigorFrame.RegenBar:CreateTexture(nil, "OVERLAY")
    CustomVigorFrame.RegenBar.BorderC:SetAtlas("widgetstatusbar-BorderCenter")
    CustomVigorFrame.RegenBar.BorderC:SetSize(180, 30)
    CustomVigorFrame.RegenBar.BorderC:SetPoint("TOP", CustomVigorFrame.RegenBar, "TOP", 0, 6)

    CustomVigorFrame.RegenBar.BorderR = CustomVigorFrame.RegenBar:CreateTexture(nil, "OVERLAY")
    CustomVigorFrame.RegenBar.BorderR:SetAtlas("widgetstatusbar-BorderRight")
    CustomVigorFrame.RegenBar.BorderR:SetSize(31, 30)
    CustomVigorFrame.RegenBar.BorderR:SetPoint("RIGHT", CustomVigorFrame.RegenBar, "RIGHT", 7, 0)

    CustomVigorFrame.VigorGems = {}
    CustomVigorFrame.VigorGemsSlots = {}
    MaxVigor = AZP.DragonRider:GetMaxVigor()
    SavedVigor = MaxVigor
    for i = 1, 6 do
        CustomVigorFrame.VigorGemsSlots[i] = CreateFrame("StatusBar", nil, CustomVigorFrame, "UIWidgetFillUpFrameTemplate")
            -- CreateTexture(nil, "BACKGROUND")
        CustomVigorFrame.VigorGemsSlots[i]:SetSize(32, 32)
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

    CustomVigorFrame.RegenBar.Percent = CustomVigorFrame.RegenBar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    CustomVigorFrame.RegenBar.Percent:SetPoint("CENTER", 0, 0)
    CustomVigorFrame.RegenBar.Percent:SetText("N/A")

    CustomVigorFrame.LeftWing = CustomVigorFrame:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.LeftWing:SetAtlas("dragonriding_vigor_decor-2x")
    CustomVigorFrame.LeftWing:SetTexCoord(1, 0, 0, 1)
    CustomVigorFrame.LeftWing:SetSize(93, 117)
    CustomVigorFrame.LeftWing:SetPoint("LEFT", CustomVigorFrame, "LEFT", 0, 0)

    CustomVigorFrame.RightWing = CustomVigorFrame:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RightWing:SetAtlas("dragonriding_vigor_decor-2x")
    CustomVigorFrame.RightWing:SetSize(93, 117)
    CustomVigorFrame.RightWing:SetPoint("RIGHT", CustomVigorFrame, "RIGHT", 0, 0)

    C_Timer.NewTicker(1, function() AZP.DragonRider:FillVigorFrame() end)
end

function AZP.DragonRider:FillVigorFrame()
    local curRecharge = AZP.DragonRider:GetRechargePercent()
    local curVigor = AZP.DragonRider:GetCurrentVigor()

    if SavedVigor < MaxVigor then
        CustomVigorFrame.RegenBar:SetValue(curRecharge)
        CustomVigorFrame.RegenBar.Percent:SetText(string.format("%d%%", curRecharge))
    else
        CustomVigorFrame.RegenBar:SetValue(0)
        CustomVigorFrame.RegenBar.Percent:SetText("0%")
    end

    if AZP.DragonRider:IsDragonRiding() == true then
        SavedVigor = curVigor
    else
        if curRecharge < SavedRecharge and curRecharge ~= 0 then
            if SavedVigor < MaxVigor then
                SavedVigor = SavedVigor + 1
            end
        end
    end

    for i = 1, MaxVigor do
        if i < SavedVigor then CustomVigorFrame.VigorGemsSlots[i]:SetValue(100)
        elseif i == SavedVigor then CustomVigorFrame.VigorGemsSlots[i]:SetValue(curRecharge)
        else CustomVigorFrame.VigorGemsSlots[i]:SetValue(0) end
    end
    if curRecharge ~= 0 then SavedRecharge = curRecharge end
end

function AZP.DragonRider:IsDragonRiding()
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, SpellID  = UnitBuff("PLAYER", i)
        if SpellID == nil then return false end
        if SpellID == 368896 or SpellID == 368899 or SpellID == 360954 or SpellID == 368901 then
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
    if event == "VARIABLES_LOADED" then
        C_Timer.After(2, function() AZP.DragonRider:BuildVigorFrame() end)
    end
end

AZP.DragonRider:OnLoad()
