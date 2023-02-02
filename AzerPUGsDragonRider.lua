if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["DragonRider"] = 24
if AZP.DragonRider == nil then AZP.DragonRider = {} end

local EventFrame, CustomVigorFrame = nil, nil
local SavedVigor = 0
local MaxVigor = 0
local SavedRecharge = 0
local VigorGemWidth, VigorGemHeight = 30, 32
local hidden = false
local ZonesInWhichAddonIsActive = {2022, 2023, 2024, 2025, 2107, 2112}
local CurrentZone = nil
local Ticker = nil
local optionFrame = nil

function AZP.DragonRider:OnLoad()
    if VigorFrameScale == nil then
        VigorFrameScale = 1.0
    end

    EventFrame = CreateFrame("Frame", nil, UIParent)
    EventFrame:RegisterEvent("VARIABLES_LOADED")
    EventFrame:RegisterEvent("ADDON_LOADED")
    EventFrame:RegisterEvent("ZONE_CHANGED")
    EventFrame:RegisterEvent("QUEST_REMOVED")
    EventFrame:SetScript("OnEvent", function(...) AZP.DragonRider:OnEvent(...) end)

    AZP.DragonRider:BuildRacesFrame()
end

function AZP.DragonRider:BuildRacesFrame()
    local RaceFrameWidth, RaceFrameHeight = 500, 628
    local RaceFrameCornerSize = 166
    local RaceFrameBorderWidth = 30
    RaceFrame = CreateFrame("Frame", nil, ExpansionLandingPage)
    RaceFrame:SetSize(RaceFrameWidth, RaceFrameHeight)
    RaceFrame:SetPoint("TOPLEFT", ExpansionLandingPage, "TOPRIGHT", 10, 5)

    RaceFrame.Background = RaceFrame:CreateTexture(nil, "BACKGROUND")
    RaceFrame.Background:SetSize(RaceFrameWidth, RaceFrameHeight)
    RaceFrame.Background:SetPoint("CENTER", RaceFrame, "CENTER", 0, 0)
    --ExpansionLandingPage.RaceFrame.Background:SetAtlas("UI-Frame-Dragonflight-CardParchment")
    RaceFrame.Background:SetAtlas("Dragonflight-Landingpage-Background")

    RaceFrame.TopLeft = RaceFrame:CreateTexture(nil, "BORDER")
    RaceFrame.TopLeft:SetSize(RaceFrameCornerSize, RaceFrameCornerSize)
    RaceFrame.TopLeft:SetPoint("TOPLEFT", RaceFrame, "TOPLEFT", 0, 0)
    RaceFrame.TopLeft:SetAtlas("Dragonflight-NineSlice-CornerTopLeft")

    RaceFrame.Top = RaceFrame:CreateTexture(nil, "BORDER")
    RaceFrame.Top:SetSize(RaceFrameWidth - (2 * RaceFrameCornerSize), RaceFrameBorderWidth)
    RaceFrame.Top:SetPoint("TOP", RaceFrame, "TOP", 0, 0)
    RaceFrame.Top:SetAtlas("_Dragonflight-NineSlice-EdgeTop")

    RaceFrame.TopRight = RaceFrame:CreateTexture(nil, "BORDER")
    RaceFrame.TopRight:SetSize(RaceFrameCornerSize, RaceFrameCornerSize)
    RaceFrame.TopRight:SetPoint("TOPRIGHT", RaceFrame, "TOPRIGHT", 0, 0)
    RaceFrame.TopRight:SetAtlas("Dragonflight-NineSlice-CornerTopRight")

    RaceFrame.Left = RaceFrame:CreateTexture(nil, "BORDER")
    RaceFrame.Left:SetSize(RaceFrameBorderWidth, RaceFrameHeight - (2 * RaceFrameCornerSize))
    RaceFrame.Left:SetPoint("LEFT", RaceFrame, "LEFT", 0, 0)
    RaceFrame.Left:SetAtlas("!Dragonflight-NineSlice-EdgeLeft")

    RaceFrame.Right = RaceFrame:CreateTexture(nil, "BORDER")
    RaceFrame.Right:SetSize(RaceFrameBorderWidth, RaceFrameHeight - (2 * RaceFrameCornerSize))
    RaceFrame.Right:SetPoint("RIGHT", RaceFrame, "RIGHT", 0, 0)
    RaceFrame.Right:SetAtlas("!Dragonflight-NineSlice-EdgeRight")

    RaceFrame.BottomLeft = RaceFrame:CreateTexture(nil, "BORDER")
    RaceFrame.BottomLeft:SetSize(RaceFrameCornerSize, RaceFrameCornerSize)
    RaceFrame.BottomLeft:SetPoint("BOTTOMLEFT", RaceFrame, "BOTTOMLEFT", 0, 0)
    RaceFrame.BottomLeft:SetAtlas("Dragonflight-NineSlice-CornerBottomLeft")

    RaceFrame.Bottom = RaceFrame:CreateTexture(nil, "BORDER")
    RaceFrame.Bottom:SetSize(RaceFrameWidth - (2 * RaceFrameCornerSize), RaceFrameBorderWidth)
    RaceFrame.Bottom:SetPoint("BOTTOM", RaceFrame, "BOTTOM", 0, 0)
    RaceFrame.Bottom:SetAtlas("_Dragonflight-NineSlice-EdgeBottom")

    RaceFrame.BottomRight = RaceFrame:CreateTexture(nil, "BORDER")
    RaceFrame.BottomRight:SetSize(RaceFrameCornerSize, RaceFrameCornerSize)
    RaceFrame.BottomRight:SetPoint("BOTTOMRIGHT", RaceFrame, "BOTTOMRIGHT", 0, 0)
    RaceFrame.BottomRight:SetAtlas("Dragonflight-NineSlice-CornerBottomRight")

    RaceFrame.TitleFrame = RaceFrame:CreateTexture(nil, "ARTWORK")
    RaceFrame.TitleFrame:SetSize(RaceFrameWidth - 90, 60)
    RaceFrame.TitleFrame:SetPoint("TOP", RaceFrame, "TOP", 0, 25)
    RaceFrame.TitleFrame:SetAtlas("UI-Frame-Dragonflight-Ribbon")

    RaceFrame.TitleFrame.Text = RaceFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    RaceFrame.TitleFrame.Text:SetPoint("CENTER", RaceFrame.TitleFrame, "CENTER", 0, 1)
    RaceFrame.TitleFrame.Text:SetText(string.format("|cff00ffffAzerPUG's DragonRider - v%d|r", AZP.VersionControl["DragonRider"]))
    RaceFrame.TitleFrame.Text:SetShadowColor(0, 0, 0, 1)
    RaceFrame.TitleFrame.Text:SetShadowOffset(2, -1)

    RaceFrame.HeaderFrame = CreateFrame("FRAME", nil, RaceFrame)
    RaceFrame.HeaderFrame:SetSize(RaceFrameWidth - 100, 50)
    RaceFrame.HeaderFrame:SetPoint("TOP", RaceFrame, "TOP", 0, 0)

    RaceFrame.HeaderFrame.Text = RaceFrame.HeaderFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge4Outline")
    RaceFrame.HeaderFrame.Text:SetPoint("TOP", RaceFrame.HeaderFrame, "TOP", 0, -40)
    RaceFrame.HeaderFrame.Text:SetText("Dragon Race Data")

    RaceFrame.HeaderFrame.Divider = RaceFrame.HeaderFrame:CreateTexture(nil, "ARTWORK")
    RaceFrame.HeaderFrame.Divider:SetSize(RaceFrameWidth - 125, 10)
    RaceFrame.HeaderFrame.Divider:SetPoint("TOP", RaceFrame.HeaderFrame.Text, "BOTTOM", 0, -15)
    RaceFrame.HeaderFrame.Divider:SetAtlas("dragonriding-talents-line")

    RaceFrame.RaceDataFrame = CreateFrame("FRAME", nil, RaceFrame)
    RaceFrame.RaceDataFrame:SetSize(RaceFrameWidth - 20, RaceFrameHeight - 100)
    RaceFrame.RaceDataFrame:SetPoint("TOP", RaceFrame, "TOP", 0, -100)

    RaceFrame.RaceDataFrame.Frames = {}

    local ZoneIndex, TypeIndex = 0, 0
    local LastZoneFrame, LastTypeFrame, LastRaceFrame = nil, nil, nil
    local HeaderHeight, RaceHeight = 30, 16

    for ZoneID, ZoneData in pairs(AZP.DragonRider.RaceData) do
        ZoneIndex = ZoneIndex + 1
        local ZoneName = C_Map.GetMapInfo(ZoneID).name
        local curZoneFrame = CreateFrame("FRAME", nil, RaceFrame.RaceDataFrame)
        curZoneFrame:SetSize(RaceFrame.RaceDataFrame:GetWidth() - 25, 30)
        if ZoneIndex == 1 then
            curZoneFrame:SetPoint("TOP", RaceFrame.RaceDataFrame, "TOP", 0, -5)
        else
            curZoneFrame:SetPoint("TOP", LastZoneFrame, "BOTTOM", 0, 0)
        end
        curZoneFrame.Header = curZoneFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
        curZoneFrame.Header:SetSize(curZoneFrame:GetWidth(), HeaderHeight)
        curZoneFrame.Header:SetPoint("TOP", curZoneFrame, "TOP", 0, 0)
        curZoneFrame.Header:SetText(ZoneName)

        for RaceType, TypeData in pairs(ZoneData) do
            TypeIndex = TypeIndex + 1
            local curTypeFrame = CreateFrame("FRAME", nil, curZoneFrame)
            curTypeFrame:SetSize(curZoneFrame:GetWidth(), 30)
            if TypeIndex == 1 then
                curTypeFrame:SetPoint("TOP", curZoneFrame.Header, "BOTTOM", 0, 0)
            else
                curTypeFrame:SetPoint("TOP", LastTypeFrame, "BOTTOM", 0, -5)
            end
            curTypeFrame.Header = curTypeFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
            curTypeFrame.Header:SetSize(curTypeFrame:GetWidth(), HeaderHeight)
            curTypeFrame.Header:SetPoint("TOP", curTypeFrame, "TOP", 0, 0)
            curTypeFrame.Header:SetText(string.format("%s Races", RaceType))

            curZoneFrame:SetHeight(curZoneFrame:GetHeight() + HeaderHeight)

            for curRaceIndex, curRaceData in ipairs(TypeData) do
                local curRaceFrame = CreateFrame("FRAME", nil, RaceFrame.RaceDataFrame)
                RaceFrame.RaceDataFrame.Frames[curRaceData.ID] = curRaceFrame
                curRaceFrame:SetSize(curTypeFrame:GetWidth(), RaceHeight)
                if curRaceIndex == 1 then
                    curRaceFrame:SetPoint("TOP", curTypeFrame.Header, "BOTTOM", 0, 0)
                else
                    curRaceFrame:SetPoint("TOP", LastRaceFrame, "BOTTOM", 0, 0)
                end

                curRaceFrame.Name = curRaceFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                curRaceFrame.Name:SetSize(200, curRaceFrame:GetHeight())
                curRaceFrame.Name:SetPoint("LEFT", curRaceFrame, "LEFT", 0, 0)
                curRaceFrame.Name:SetText(curRaceData.Name)

                curRaceFrame.Best = curRaceFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                curRaceFrame.Best:SetSize(75, curRaceFrame:GetHeight())
                curRaceFrame.Best:SetPoint("LEFT", curRaceFrame.Name, "RIGHT", 10, 0)
                local curRaceBestTime = C_CurrencyInfo.GetCurrencyInfo(curRaceData.ID).quantity / 1000
                curRaceFrame.Best:SetText(curRaceBestTime)

                curRaceFrame.Silver = curRaceFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                curRaceFrame.Silver:SetSize(75, curRaceFrame:GetHeight())
                curRaceFrame.Silver:SetPoint("LEFT", curRaceFrame.Best, "RIGHT", 10, 0)
                curRaceFrame.Silver:SetText(curRaceData.Silver)

                curRaceFrame.Gold = curRaceFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                curRaceFrame.Gold:SetSize(75, curRaceFrame:GetHeight())
                curRaceFrame.Gold:SetPoint("LEFT", curRaceFrame.Silver, "RIGHT", 10, 0)
                curRaceFrame.Gold:SetText(curRaceData.Gold)

                curZoneFrame:SetHeight(curZoneFrame:GetHeight() + RaceHeight)
                curTypeFrame:SetHeight(curTypeFrame:GetHeight() + RaceHeight)

                LastRaceFrame = curRaceFrame
            end

            LastTypeFrame = curTypeFrame
        end

        LastZoneFrame = curZoneFrame
    end
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
    AZP.DragonRider:LockUnlockPosition()
end

function AZP.DragonRider:BuildOptionsPanel()
    optionFrame = CreateFrame("FRAME")
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
    optionFrame.WingsHideCheckbox:SetScript("OnClick",
    function()
        if optionFrame.WingsHideCheckbox:GetChecked() == true then
            HideSideWings = true
            CustomVigorFrame.LeftWing:Hide()
            CustomVigorFrame.RightWing:Hide()
        else
            HideSideWings = false
            CustomVigorFrame.LeftWing:Show()
            CustomVigorFrame.RightWing:Show()
        end
    end)

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

    optionFrame.hideGlyphsText = optionFrame:CreateFontString("OpenOptionsFrameText", "ARTWORK", "GameFontNormalLarge")
    optionFrame.hideGlyphsText:SetPoint("TOPLEFT", 30, -125)
    optionFrame.hideGlyphsText:SetJustifyH("LEFT")
    optionFrame.hideGlyphsText:SetText("Hide Glyph location Pins")

    optionFrame.hideGlyphsCheckbox = CreateFrame("CheckButton", nil, optionFrame, "ChatConfigCheckButtonTemplate")
    optionFrame.hideGlyphsCheckbox:SetSize(20, 20)
    optionFrame.hideGlyphsCheckbox:SetPoint("RIGHT", optionFrame.hideGlyphsText, "LEFT", 0, 0)
    optionFrame.hideGlyphsCheckbox:SetHitRectInsets(0, 0, 0, 0)
    optionFrame.hideGlyphsCheckbox:SetChecked(AZPHideGlyphs)
    optionFrame.hideGlyphsCheckbox:SetScript("OnClick", function() AZPHideGlyphs = optionFrame.hideGlyphsCheckbox:GetChecked() AZP.DragonRider:ZoneChanged() end)

    optionFrame.hideRostrumsText = optionFrame:CreateFontString("OpenOptionsFrameText", "ARTWORK", "GameFontNormalLarge")
    optionFrame.hideRostrumsText:SetPoint("TOPLEFT", 30, -150)
    optionFrame.hideRostrumsText:SetJustifyH("LEFT")
    optionFrame.hideRostrumsText:SetText("Hide rostrum of transformation location Pins")

    optionFrame.hideRostrumsCheckbox = CreateFrame("CheckButton", nil, optionFrame, "ChatConfigCheckButtonTemplate")
    optionFrame.hideRostrumsCheckbox:SetSize(20, 20)
    optionFrame.hideRostrumsCheckbox:SetPoint("RIGHT", optionFrame.hideRostrumsText, "LEFT", 0, 0)
    optionFrame.hideRostrumsCheckbox:SetHitRectInsets(0, 0, 0, 0)
    optionFrame.hideRostrumsCheckbox:SetChecked(AZPHideRostrums)
    optionFrame.hideRostrumsCheckbox:SetScript("OnClick", function() AZPHideRostrums = optionFrame.hideRostrumsCheckbox:GetChecked() AZP.DragonRider:ZoneChanged() end)

    optionFrame.lockPositionText = optionFrame:CreateFontString("OpenOptionsFrameText", "ARTWORK", "GameFontNormalLarge")
    optionFrame.lockPositionText:SetPoint("TOPLEFT", 30, -175)
    optionFrame.lockPositionText:SetJustifyH("LEFT")
    optionFrame.lockPositionText:SetText("Lock Position")

    optionFrame.lockPositionCheckbox = CreateFrame("CheckButton", nil, optionFrame, "ChatConfigCheckButtonTemplate")
    optionFrame.lockPositionCheckbox:SetSize(20, 20)
    optionFrame.lockPositionCheckbox:SetPoint("RIGHT", optionFrame.lockPositionText, "LEFT", 0, 0)
    optionFrame.lockPositionCheckbox:SetHitRectInsets(0, 0, 0, 0)
    optionFrame.lockPositionCheckbox:SetChecked(AZPLockPosition)
    optionFrame.lockPositionCheckbox:SetScript("OnClick", function() AZP.DragonRider:LockUnlockPosition() end)

    optionFrame.VigorFrameScaleText = optionFrame:CreateFontString("OpenOptionsFrameText", "ARTWORK", "GameFontNormalLarge")
    optionFrame.VigorFrameScaleText:SetPoint("TOPLEFT", 30, -250)
    optionFrame.VigorFrameScaleText:SetJustifyH("LEFT")
    optionFrame.VigorFrameScaleText:SetText("Custom Vigor Frame Scale:")

    optionFrame.VigorFrameScaleSlider = CreateFrame("SLIDER", "VigorFrameScaleSlider", optionFrame, "OptionsSliderTemplate")
    optionFrame.VigorFrameScaleSlider:SetHeight(20)
    optionFrame.VigorFrameScaleSlider:SetWidth(200)
    optionFrame.VigorFrameScaleSlider:SetOrientation('HORIZONTAL')
    optionFrame.VigorFrameScaleSlider:SetPoint("TOPLEFT", optionFrame.VigorFrameScaleText, "BOTTOMLEFT", 0, -20)
    optionFrame.VigorFrameScaleSlider:EnableMouse(true)
    optionFrame.VigorFrameScaleSlider.tooltipText = 'Scale for mana bars'
    VigorFrameScaleSliderLow:SetText('small')
    VigorFrameScaleSliderHigh:SetText('big')
    VigorFrameScaleSliderText:SetText('Scale')

    optionFrame.VigorFrameScaleSlider:Show()
    optionFrame.VigorFrameScaleSlider:SetMinMaxValues(0.5, 2)
    optionFrame.VigorFrameScaleSlider:SetValueStep(0.1)

    optionFrame.VigorFrameScaleSlider:SetScript("OnValueChanged", AZP.DragonRider.setScale)

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
    local PowerBarChildren = {UIWidgetPowerBarContainerFrame:GetChildren()}
    if PowerBarChildren[3] ~= nil then
        PowerBarSubChildren = {PowerBarChildren[3]:GetRegions()}
        for _, child in ipairs(PowerBarSubChildren) do
            if HideSideWings == true then
                child:SetAlpha(0)
            else
                child:SetAlpha(1)
            end
        end
    end
end

function AZP.DragonRider:FillVigorFrame()
    local curRecharge = AZP.DragonRider:GetRechargePercent()
    if curRecharge == nil then
        AZP.DragonRider:Hide()
        return
    end
    local curVigor = AZP.DragonRider:GetCurrentVigor()

    if AZP.DragonRider:IsDragonRiding() == true then
        SavedVigor = curVigor
        AZP.DragonRider:Show(MaxVigor)

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
        local name, _, _, _, _, _, _, _, _, SpellID = UnitBuff("PLAYER", i)
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

function AZP.DragonRider:LockUnlockPosition()
    if optionFrame.lockPositionCheckbox:GetChecked() == true then
        CustomVigorFrame:EnableMouse(false)
        CustomVigorFrame:SetMovable(false)
        CustomVigorFrame:RegisterForDrag()
        CustomVigorFrame:SetScript("OnDragStart", nil)
        CustomVigorFrame:SetScript("OnDragStop", nil)
        AZPLockPosition = true
    else
        CustomVigorFrame:EnableMouse(true)
        CustomVigorFrame:SetMovable(true)
        CustomVigorFrame:RegisterForDrag("LeftButton")
        CustomVigorFrame:SetScript("OnDragStart", CustomVigorFrame.StartMoving)
        CustomVigorFrame:SetScript("OnDragStop", function() AZP.DragonRider:SavePosition() CustomVigorFrame:StopMovingOrSizing() end)
        AZPLockPosition = false
    end
end

function AZP.DragonRider:GetRechargePercent()
    local val = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(4220)
    if val == nil then
        return nil
    else
        return val.barValue
    end
end

function AZP.DragonRider:GetMaxVigor()
    return #C_UIWidgetManager.GetTextureAndTextRowVisualizationInfo(4216).entries
end

function AZP.DragonRider:GetCurrentVigor()
    return #C_UIWidgetManager.GetTextureAndTextRowVisualizationInfo(4217).entries
end

function AZP.DragonRider:ZoneChanged()
    CurrentZone = C_Map.GetBestMapForUnit("PLAYER")

    if not VigorFrameAutoHideInWrongZone then
        if Ticker == nil or Ticker:IsCancelled() then
            if CustomVigorFrame == nil then
                AZP.DragonRider:BuildVigorFrame()
                AZP.DragonRider:LoadPosition()
            end
            Ticker = C_Timer.NewTicker(1, function() AZP.DragonRider:FillVigorFrame() end)
        end
    end

    if VigorFrameAutoHideInWrongZone and tContains(ZonesInWhichAddonIsActive, CurrentZone) then
        if Ticker == nil or Ticker:IsCancelled() then
            if CustomVigorFrame == nil then
                AZP.DragonRider:BuildVigorFrame()
                AZP.DragonRider:LoadPosition()
            end
            Ticker = C_Timer.NewTicker(1, function() AZP.DragonRider:FillVigorFrame() end)
        end
    end

    if VigorFrameAutoHideInWrongZone and not tContains(ZonesInWhichAddonIsActive, CurrentZone) then
        if Ticker ~= nil then
            Ticker:Cancel()
        end
        if CustomVigorFrame ~= nil then AZP.DragonRider:Hide() end
        return
    end
end

function AZP.DragonRider:setScale(scale)
    VigorFrameScale = scale
    CustomVigorFrame:SetScale(scale)
end

function AZP.DragonRider:OnEvent(_, event, ...)
    if event == "VARIABLES_LOADED" then
        C_Timer.After(2, function()
            if VigorFrameAutoHideInWrongZone == nil then VigorFrameAutoHideInWrongZone = true end
            AZP.DragonRider:BuildOptionsPanel()
            AZP.DragonRider:ZoneChanged()
            VigorFrameScaleSlider:SetValue(VigorFrameScale)
        end)
    elseif event == "ZONE_CHANGED" then
        AZP.DragonRider:ZoneChanged()
    elseif event == "QUEST_REMOVED" then
        local curID = ...
        if AZP.DragonRider.RaceQuestIDs[curID] ~= nil then
            local curRaceData = AZP.DragonRider.RaceQuestIDs[curID]
            local curRaceBestTime = C_CurrencyInfo.GetCurrencyInfo(curRaceData.ID).quantity / 1000
            RaceFrame.RaceDataFrame.Frames[curRaceData.ID].Best:SetText(curRaceBestTime)
        end

        if TempDataGathering == nil then TempDataGathering = {} end

        local QuestID = C_CurrencyInfo.GetCurrencyInfo(2018).quantity
        local SilverTime = C_CurrencyInfo.GetCurrencyInfo(2019).quantity
        local GoldTime = C_CurrencyInfo.GetCurrencyInfo(2020).quantity
        local QuestName = C_QuestLog.GetTitleForQuestID(QuestID)
        if TempDataGathering[QuestID] == nil then TempDataGathering[QuestID] = {Silver = SilverTime, Gold = GoldTime, Name = QuestName} end
    end
end

AZP.DragonRider:OnLoad()
