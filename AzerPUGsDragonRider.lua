if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["DragonRider"] = 1
if AZP.DragonRider == nil then AZP.DragonRider = {} end

-- local EventFrame = nil
local DragonRiderMiniButton = nil

function AZP.DragonRider.OnLoad()
    -- EventFrame = CreateFrame("FRAME")
    -- EventFrame:SetScript("OnEvent", function(...) AZP.DragonRider:OnEvent(...) end)
    -- EventFrame:RegisterEvent("ADDON_LOADED")

    local SizeAndPosition = {45, 78, 30}

    DragonRiderMiniButton = CreateFrame("Button", nil, UIParent)
    DragonRiderMiniButton:SetFrameStrata("MEDIUM")
    DragonRiderMiniButton:SetPoint("CENTER", 0, 0)
    DragonRiderMiniButton:SetSize(SizeAndPosition[1], SizeAndPosition[1])
    DragonRiderMiniButton:SetFrameLevel(8)
    DragonRiderMiniButton:RegisterForDrag("LeftButton")
    DragonRiderMiniButton:SetMovable(true)
    DragonRiderMiniButton:EnableMouse(true)
    DragonRiderMiniButton:SetHighlightTexture(136477)
    DragonRiderMiniButton:SetScript("OnDragStart", DragonRiderMiniButton.StartMoving)
    DragonRiderMiniButton:SetScript("OnDragStop", function() DragonRiderMiniButton:StopMovingOrSizing() AZP.Core:SaveMiniButtonLocation() end)
    DragonRiderMiniButton:SetScript("OnClick",
    function()
        ExpansionLandingPage_LoadUI()
        ExpansionLandingPage:RefreshExpansionOverlay(65436)
    end)

    DragonRiderMiniButton.OverlayFrame = DragonRiderMiniButton:CreateTexture(nil, nil)
    DragonRiderMiniButton.OverlayFrame:SetSize(SizeAndPosition[2], SizeAndPosition[2])
    DragonRiderMiniButton.OverlayFrame:SetTexture(136430)
    DragonRiderMiniButton.OverlayFrame:SetPoint("CENTER", 16, -17)

    DragonRiderMiniButton.LogoFrame = DragonRiderMiniButton:CreateTexture(nil, nil)
    DragonRiderMiniButton.LogoFrame:SetSize(SizeAndPosition[3], SizeAndPosition[3])
    --DragonRiderMiniButton.LogoFrame:SetTexture("Interface\\ICONS\\inv_companionprotodragon.blp")
    --DragonRiderMiniButton.LogoFrame:SetTexture("Interface\\ICONS\\inv_companionpterrordaxdrake.blp")
    --DragonRiderMiniButton.LogoFrame:SetTexture("Interface\\ICONS\\inv_companiondrake.blp")
    DragonRiderMiniButton.LogoFrame:SetTexture("Interface\\ICONS\\inv_companionwyvern.blp")
    DragonRiderMiniButton.LogoFrame:SetPoint("CENTER", 0, 0)
end

-- function AZP.DragonRider:OnEvent(_, event, ...)
--     if event == "ADDON_LOADED" then
--         ExpansionLandingPage_LoadUI()
--     end
-- end

AZP.DragonRider.OnLoad()

local EventFrame = CreateFrame("FRAME")
EventFrame:SetScript("OnEvent", function(...) AZP.DragonRider:OnEvent(...) end)
EventFrame:RegisterEvent("VARIABLES_LOADED")

function AZP.DragonRider:GetCurrentRechargePercentage()
    return C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(4220).barValue
end

function AZP.DragonRider:GetMaxVigor()
    return #C_UIWidgetManager.GetTextureAndTextRowVisualizationInfo(4216).entries
end

function AZP.DragonRider:GetLastVigor()
    return #C_UIWidgetManager.GetTextureAndTextRowVisualizationInfo(4217).entries
end

WidgetInfoFound = {} --/tinspect WidgetInfoFound
local counter = 1
function AZP.DragonRider:OnEvent(_, event, ...)
    if event == "VARIABLES_LOADED" then
        C_Timer.NewTicker(1, function()
            local widgetSetID = C_UIWidgetManager.GetPowerBarWidgetSetID()
            local widgetsInSet = C_UIWidgetManager.GetAllWidgetsBySetID(widgetSetID)

            for i, widget in ipairs(widgetsInSet) do
                if widget.widgetID == 4220 then
                    WidgetInfoFound.RechargeBarPercentage = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(widget.widgetID).barValue
                end
                
                if widget.widgetType == 2 then
                    local info = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(widget.widgetID)
                    -- WidgetInfoFound[string.format("barTextEnabledState: %d", widget.widgetID)] = info.barTextEnabledState
                    -- WidgetInfoFound[string.format("barValue: %d", widget.widgetID)] = info.barValue
                    WidgetInfoFound[widget.widgetID .. "Info"] = string.format("bv:%d, tes: %d, st: %d", info.barValue, info.barTextEnabledState, info.orderIndex)
                    WidgetInfoFound[widget.widgetID] = info;

                elseif widget.widgetType == 15 then
                    local info = C_UIWidgetManager.GetTextureAndTextRowVisualizationInfo(widget.widgetID)
                    --DevTools_Dump(info)
                    WidgetInfoFound[widget.widgetID .. "Info"] = string.format("st:%d, oi: %d, ent: %s", info.shownState, info.orderIndex, #info.entries)
                    WidgetInfoFound[widget.widgetID] = info;--string.format("Entries: ", info.entries)
                end
            end
            WidgetInfoFound.Counter = counter
            counter = counter + 1
        end)
    end
end

-- /dump UIWidgetPowerBarContainerFrame.horizontalRowContainerPool