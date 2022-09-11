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

local textureKitRegionFormatStrings = {
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
    
    TestVar = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(4220)
    CustomVigorFrame.RegenBar = CreateFrame("StatusBar", nil, CustomVigorFrame)
    CustomVigorFrame.RegenBar:SetSize(240, 25)
    CustomVigorFrame.RegenBar:SetStatusBarTexture("widgetstatusbar-Fill-white")
    CustomVigorFrame.RegenBar:SetStatusBarColor(RARE_BLUE_COLOR:GetRGB())
    CustomVigorFrame.RegenBar:SetPoint("TOP", 1, -5)
    CustomVigorFrame.RegenBar:SetMinMaxValues(0, 100)
    CustomVigorFrame.RegenBar:SetValue(0)

    -- local fillAtlasInfo = C_Texture.GetAtlasInfo("widgetstatusbar-Fill-white");
	-- if fillAtlasInfo then
	-- 	CustomVigorFrame.RegenBar:SetHeight(fillAtlasInfo.height);
	-- 	CustomVigorFrame.RegenBar:GetStatusBarTexture():SetHorizTile(fillAtlasInfo.tilesHorizontally);
	-- end


    CustomVigorFrame.RegenBar.BGLeft = CustomVigorFrame.RegenBar:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RegenBar.BGCenter = CustomVigorFrame.RegenBar:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RegenBar.BGRight = CustomVigorFrame.RegenBar:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RegenBar.BGLeft:SetAtlas("widgetstatusbar-BGLeft")
    CustomVigorFrame.RegenBar.BGCenter:SetAtlas("widgetstatusbar-BGCenter")
    CustomVigorFrame.RegenBar.BGRight:SetAtlas("widgetstatusbar-BGRight")
    CustomVigorFrame.RegenBar.BGLeft:SetPoint("LEFT", CustomVigorFrame.RegenBar, "LEFT", 0, 0)
    CustomVigorFrame.RegenBar.BGLeft:SetPoint("TOP", CustomVigorFrame.RegenBar, "TOP", 0, 0)
    CustomVigorFrame.RegenBar.BGLeft:SetPoint("BOTTOM", CustomVigorFrame.RegenBar, "BOTTOM", 0, 0)
    CustomVigorFrame.RegenBar.BGCenter:SetPoint("LEFT", CustomVigorFrame.RegenBar.BGLeft, "LEFT", 0, 0)
    CustomVigorFrame.RegenBar.BGCenter:SetPoint("TOP", CustomVigorFrame.RegenBar, "TOP", 0, 0)
    CustomVigorFrame.RegenBar.BGCenter:SetPoint("BOTTOM", CustomVigorFrame.RegenBar, "BOTTOM", 0, 0)
    CustomVigorFrame.RegenBar.BGRight:SetPoint("LEFT", CustomVigorFrame.RegenBar.BGCenter, "LEFT", 0, 0)
    CustomVigorFrame.RegenBar.BGRight:SetPoint("TOP", CustomVigorFrame.RegenBar, "TOP", 0, 0)
    CustomVigorFrame.RegenBar.BGRight:SetPoint("BOTTOM", CustomVigorFrame.RegenBar, "BOTTOM", 0, 0)

    CustomVigorFrame.RegenBar.BorderLeft = CustomVigorFrame.RegenBar:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RegenBar.BorderCenter = CustomVigorFrame.RegenBar:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RegenBar.BorderRight = CustomVigorFrame.RegenBar:CreateTexture(nil, "BACKGROUND")
    CustomVigorFrame.RegenBar.BorderLeft:SetAtlas("widgetstatusbar-BorderLeft")
    CustomVigorFrame.RegenBar.BorderCenter:SetAtlas("widgetstatusbar-BorderCenter")
    CustomVigorFrame.RegenBar.BorderRight:SetAtlas("widgetstatusbar-BorderRight")
    CustomVigorFrame.RegenBar.BorderLeft:SetSize(20, 25)
    -- CustomVigorFrame.RegenBar.BorderCenter:SetSize(200, 25)
    CustomVigorFrame.RegenBar.BorderRight:SetSize(20, 25)
    CustomVigorFrame.RegenBar.BorderLeft:SetPoint("LEFT", CustomVigorFrame.RegenBar, "LEFT", 8, 0)
    CustomVigorFrame.RegenBar.BorderLeft:SetPoint("TOP", CustomVigorFrame.RegenBar, "TOP", 0, 0)
    CustomVigorFrame.RegenBar.BorderLeft:SetPoint("BOTTOM", CustomVigorFrame.RegenBar, "BOTTOM", 0, 0)
    CustomVigorFrame.RegenBar.BorderCenter:SetPoint("LEFT", CustomVigorFrame.RegenBar.BorderLeft, "LEFT", 0, 0)
    CustomVigorFrame.RegenBar.BorderCenter:SetPoint("TOP", CustomVigorFrame.RegenBar, "TOP", 0, 0)
    CustomVigorFrame.RegenBar.BorderCenter:SetPoint("BOTTOM", CustomVigorFrame.RegenBar, "BOTTOM", 0, 0)
    CustomVigorFrame.RegenBar.BorderRight:SetPoint("LEFT", CustomVigorFrame.RegenBar.BorderCenter, "LEFT", 0, 0)
    CustomVigorFrame.RegenBar.BorderRight:SetPoint("RIGHT", CustomVigorFrame.RegenBar, "RIGHT", -8, 0)
    CustomVigorFrame.RegenBar.BorderRight:SetPoint("TOP", CustomVigorFrame.RegenBar, "TOP", 0, 0)
    CustomVigorFrame.RegenBar.BorderRight:SetPoint("BOTTOM", CustomVigorFrame.RegenBar, "BOTTOM", 0, 0)

    -- CustomVigorFrame.RegenBar.BG:SetVertexColor(1, 0, 0)
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
        local SpellName, _, _, _, _, _, _, _, _, SpellID  = UnitBuff("PLAYER", i)
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
    if event == "ADDON_LOADED" then
        if ... == "AzerPUGsDragonRider" then
            AZP.DragonRider:BuildVigorFrame()
        end
    end
end

AZP.DragonRider:OnLoad()
