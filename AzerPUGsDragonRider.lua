if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["DragonRider"] = 1
if AZP.DragonRider == nil then AZP.DragonRider = {} end


function AZP.DragonRider.OnLoad()
end


AZP.DragonRider.OnLoad()


function AZP.DragonRider:GetCurrentRechargePercentage()
    return C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo(4220).barValue
end

function AZP.DragonRider:GetMaxVigor()
    return #C_UIWidgetManager.GetTextureAndTextRowVisualizationInfo(4216).entries
end

function AZP.DragonRider:GetLastVigor()
    return #C_UIWidgetManager.GetTextureAndTextRowVisualizationInfo(4217).entries
end

function AZP.DragonRider:OnEvent(_, event, ...)
    end
end

AZP.DragonRider:OnLoad()