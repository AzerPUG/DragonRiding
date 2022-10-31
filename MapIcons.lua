local pins =
{
    [2022] = -- The Waking Shores
    {
        {AchieID = 15985, PosX = 75.25, PosY = 56.99, Name = "Skytop Observatory"},
        {AchieID = 15986, PosX = 74.90, PosY = 37.64, Name = "Wingrest Embassy"},
        {AchieID = 15987, PosX = 40.95, PosY = 71.86, Name = "Obsidian Bulwark"},
        {AchieID = 15988, PosX = 54.46, PosY = 74.21, Name = "Ruby Life Pools"},
        {AchieID = 15989, PosX = 46.40, PosY = 52.14, Name = "The Overflowing Spring"},
        {AchieID = 15990, PosX = 52.64, PosY = 17.14, Name = "Life-Binder Observatory"},
        {AchieID = 15991, PosX = 57.66, PosY = 54.93, Name = "Crumbling Life Archway"},
        {AchieID = 16051, PosX = 69.32, PosY = 46.20, Name = "Dragonheart Outpost"},
        {AchieID = 16052, PosX = 73.14, PosY = 20.66, Name = "Scalecracker Peak"},
        {AchieID = 16053, PosX = 21.88, PosY = 51.50, Name = "Obsidian Throne"},
        {AchieID = 16668, PosX = 74.33, PosY = 57.65, Name = "Skytop Observatory Rostrum"},
        {AchieID = 16669, PosX = 58.12, PosY = 78.61, Name = "Flashfrost Enclave"},
    },
    [2023] = -- Ohn'Ahran Plains
    {
        {AchieID = 16054, PosX = 57.93, PosY = 31.24, Name = "Ohn'Ahra's Roost"},
        {AchieID = 16055, PosX = 30.51, PosY = 36.00, Name = "Nokhudon Hold"},
        {AchieID = 16056, PosX = 30.15, PosY = 61.40, Name = "Emerald Gardens"},
        {AchieID = 16057, PosX = 29.55, PosY = 75.24, Name = "The Eternal Kurgans"},
        {AchieID = 16058, PosX = 44.69, PosY = 64.61, Name = "Szar Skeleth"},
        {AchieID = 16059, PosX = 47.23, PosY = 72.36, Name = "Mirror of the Sky"},
        {AchieID = 16060, PosX = 57.08, PosY = 80.12, Name = "Ohn'Iri Springs"},
        {AchieID = 16061, PosX = 84.43, PosY = 77.60, Name = "Dragonsprings Summit"},
        {AchieID = 16062, PosX = 86.49, PosY = 39.42, Name = "Rusza'Thar Reach"},
        {AchieID = 16063, PosX = 61.51, PosY = 64.22, Name = "Windsong Rise"},
        {AchieID = 16670, PosX = 48.80, PosY = 86.64, Name = "Rubyscale Outpost"},
        {AchieID = 16671, PosX = 78.36, PosY = 21.28, Name = "Mirewood Fen"},
    },
}

local DragonMapDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin)

function DragonMapDataProviderMixin:GetPinTemplate()
	return "DragonMapPinTemplate"
end

function DragonMapDataProviderMixin:OnAdded(...)
    MapCanvasDataProviderMixin.OnAdded(self, ...)
end

function DragonMapDataProviderMixin:OnMapChanged()
    self:RefreshAllData()
end


function DragonMapDataProviderMixin:RefreshAllData()
    local mapInfo = C_Map.GetMapInfo(self:GetMap():GetMapID());
	if FlagsUtil.IsSet(mapInfo.flags, Enum.UIMapFlag.HideVignettes) then
		self:RemoveAllData();
		return;
	end

    local newMapID = self:GetMap():GetMapID();
    local pinsForMap = pins[newMapID]
    self:RemoveAllData();
    if pinsForMap then
        for i, pinInfo in ipairs(pinsForMap) do
            local id, name, points, completed = GetAchievementInfo(pinInfo.AchieID)
            if completed  == false then
                local pin = self:GetMap():AcquirePin(self:GetPinTemplate())
                pin:SetPosition(pinInfo.PosX / 100, pinInfo.PosY / 100)
            end
        end
    else
        self:RemoveAllData();
    end
end

function DragonMapDataProviderMixin:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(self:GetPinTemplate());
end

local function OnLoad()
    WorldMapFrame:AddDataProvider(CreateFromMixins(DragonMapDataProviderMixin));
end


DragonMapPinMixin = CreateFromMixins(MapCanvasPinMixin)
function DragonMapPinMixin:OnLoad()
    self.Texture:SetTexture("Interface/ICONS/Ability_DragonRiding_Glyph01")
    self.Texture:SetSize(100, 100)
    self.Mask = self:CreateMaskTexture()
    self.Mask:SetPoint("CENTER", self.Texture, "CENTER", 0, 0)
    self.Mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    self.Mask:SetSize(90, 90)
    self.Texture:AddMaskTexture(self.Mask)
    self.HighlightTexture:SetSize(100, 100)
    self:UseFrameLevelType("PIN_FRAME_LEVEL_TOPMOST");
    self:SetScaleStyle()
end

function DragonMapPinMixin:OnReleased()
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == "Blizzard_WorldMap" then
            OnLoad()
        end
    end
end)

if IsAddOnLoaded("Blizzard_WorldMap") then
    OnLoad()
end