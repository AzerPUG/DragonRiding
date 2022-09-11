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
    EventFrame:RegisterEvent("VARIABLES_LOADED")
    EventFrame:RegisterEvent("ADDON_LOADED")
    EventFrame:SetScript("OnEvent", function(...) AZP.DragonRider:OnEvent(...) end)
end

local textureKitRegionFormatStrings =
{
    ["BorderLeft"] = "%s-BorderLeft",
    ["BorderRight"] = "%s-BorderRight",
    ["BorderCenter"] = "%s-BorderCenter",
    ["BGLeft"] = "%s-BGLeft",
    ["BGRight"] = "%s-BGRight",
    ["BGCenter"] = "%s-BGCenter",
    ["Spark"] = "%s-Spark",
    ["SparkMask"] = "%s-spark-mask",
    ["BackgroundGlow"] = "%s-BackgroundGlow",
    ["GlowLeft"] = "%s-Glow-BorderLeft",
    ["GlowRight"] = "%s-Glow-BorderRight",
    ["GlowCenter"] = "%s-Glow-BorderCenter",
}


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
        CustomVigorFrame.RegenBar:SetValue(AZP.DragonRider:GetRechargePercent())
    else
        CustomVigorFrame.RegenBar:SetValue(0)
    end

    local curRecharge = AZP.DragonRider:GetRechargePercent()
    local curVigor = AZP.DragonRider:GetCurrentVigor()

    if IsMounted() == true then
        if AZP.DragonRider:IsDragonRiding() == true then
            SavedVigor = curVigor
        end
    else
        if curRecharge < SavedRecharge and curRecharge ~= 0 then
            if SavedVigor < MaxVigor then
                SavedVigor = SavedVigor + 1
            end
        end
    end


    for i = 1, MaxVigor do
        if i <= SavedVigor then CustomVigorFrame.VigorGems[i]:Show()
        else CustomVigorFrame.VigorGems[i]:Hide() end
    end
    if curRecharge ~= 0 then SavedRecharge = curRecharge end
end

function AZP.DragonRider:IsDragonRiding()
    for i = 1, 40 do
        local _, _, _, _, _, _, _, _, _, SpellID  = UnitBuff("PLAYER", i)
        if SpellID == nil then return false end

        if SpellID == 368896 then
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
