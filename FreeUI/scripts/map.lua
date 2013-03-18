-- Map search function by Wildbreath

local F, C, L = unpack(select(2, ...))

WORLDMAP_WINDOWED_SIZE = 0.82

local offset = 1 / WORLDMAP_WINDOWED_SIZE
local fontsize = 8 / WORLDMAP_WINDOWED_SIZE
local panelHeight = 26

local mapbg = CreateFrame ("Frame", nil, WorldMapDetailFrame)
mapbg:SetBackdrop({
	bgFile = C.media.backdrop,
})
mapbg:SetBackdropColor(0, 0, 0)

local frame = CreateFrame ("Frame", nil, WorldMapButton)
frame:SetFrameStrata("HIGH")

local panel = CreateFrame("Frame", nil, WorldMapButton)
panel:EnableMouse(true)
panel:SetScale(offset)
panel:SetFrameLevel(0)

local button = CreateFrame("Frame", nil, WorldMapButton)
button:EnableMouse(true)
button:SetSize(16, 16)
button:SetScale(offset)
button:SetPoint("BOTTOM", WorldMapDetailFrame)

local text = F.CreateFS(button, 8)
text:SetPoint("CENTER")
text:SetText("+")

local SmallerMapSkin = function()
	mapbg:SetPoint("TOPLEFT", WorldMapDetailFrame, -offset, offset)
	mapbg:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, offset, -offset)
	mapbg:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel()-1)

	panel:SetPoint("TOPLEFT", WorldMapDetailFrame, "BOTTOMLEFT", -1, panelHeight)
	panel:SetPoint("TOPRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 1, panelHeight)
	panel:SetHeight(panelHeight)
	F.CreateBD(panel)

	WorldMapFrame:SetFrameStrata("MEDIUM")
	WorldMapDetailFrame:SetFrameStrata("MEDIUM")
	WorldMapDetailFrame:ClearAllPoints()
	WorldMapDetailFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	WorldMapTitleButton:Show()
	WorldMapLevelDropDown:SetParent(panel)
	WorldMapLevelDropDown:ClearAllPoints()
	WorldMapLevelDropDown:SetPoint("RIGHT", panel, "RIGHT", 0, -2)
	WorldMapLevelDropDown:SetFrameLevel(panel:GetFrameLevel()+1)
	WorldMapLevelDropDownButton:SetFrameLevel(panel:GetFrameLevel()+1)
	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	WorldMapFrameTitle:ClearAllPoints()
	WorldMapFrameTitle:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, 9, 5);
	WorldMapFrameTitle:SetFont(C.media.font, fontsize, "OUTLINEMONOCHROME")
	WorldMapFrameTitle:SetTextColor(1, 1, 1)
	WorldMapFrameTitle:SetShadowColor(0, 0, 0, 0)
	WorldMapFrameTitle:SetParent(frame)
	WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT")
	WorldMapQuestShowObjectives.SetPoint = F.dummy
	WorldMapQuestShowObjectives:SetFrameStrata("HIGH")
	WorldMapQuestShowObjectivesText:ClearAllPoints()
	WorldMapQuestShowObjectivesText:SetPoint("RIGHT", WorldMapQuestShowObjectives, "LEFT")
	WorldMapQuestShowObjectivesText:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	WorldMapQuestShowObjectivesText:SetTextColor(1, 1, 1)
	WorldMapQuestShowObjectivesText:SetShadowColor(0, 0, 0, 0)
	WorldMapTrackQuest:SetParent(frame)
	WorldMapTrackQuest:ClearAllPoints()
	WorldMapTrackQuest:SetPoint("TOPLEFT", WorldMapDetailFrame, 9, -5)
	WorldMapTrackQuestText:SetFont(C.media.font, fontsize, "OUTLINEMONOCHROME")
	WorldMapTrackQuestText:SetTextColor(1, 1, 1)
	WorldMapTrackQuestText:SetShadowColor(0, 0, 0, 0)
	WorldMapShowDigSites:ClearAllPoints()
	WorldMapShowDigSites:SetFrameStrata("HIGH")
	WorldMapShowDigSites:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, 18)
	WorldMapShowDigSitesText:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	WorldMapShowDigSitesText:ClearAllPoints()
	WorldMapShowDigSitesText:SetPoint("RIGHT", WorldMapShowDigSites, "LEFT",-4,1)
	WorldMapShowDigSitesText:SetTextColor(1, 1, 1)
	WorldMapShowDigSitesText:SetShadowColor(0, 0, 0, 0)
	WorldMapFrameCloseButton:SetAlpha(0)
	WorldMapFrameCloseButton:EnableMouse(nil)
	WorldMapFrameSizeUpButton:SetAlpha(0)
	WorldMapFrameSizeUpButton:EnableMouse(nil)
	WorldMapShowDropDown:SetParent(panel)
	WorldMapShowDropDown:ClearAllPoints()
	WorldMapShowDropDown:SetPoint("LEFT", panel, "LEFT", 0, -2)
	WorldMapShowDropDown:SetFrameStrata("LOW")
	MapBarFrame.Description:SetFont(C.media.font, fontsize, "OUTLINEMONOCHROME")
	MapBarFrame.Description:SetShadowOffset(0, 0)
	MapBarFrame.Title:SetFont(C.media.font, fontsize, "OUTLINEMONOCHROME")
	MapBarFrame.Title:SetShadowOffset(0, 0)
end
hooksecurefunc("WorldMap_ToggleSizeDown", function() SmallerMapSkin() end)

local coords = F.CreateFS(frame, fontsize)
coords:SetPoint("LEFT", WorldMapFrameTitle, "RIGHT")
local cursorcoords = F.CreateFS(frame, fontsize)
cursorcoords:SetPoint("BOTTOMLEFT", WorldMapFrameTitle, "TOPLEFT", 0, 4)

local freq = C.performance.mapcoords
local last = 0

WorldMapDetailFrame:HookScript("OnUpdate", function(self, elapsed)
	last = last + elapsed
	if last >= freq then
		local x, y = GetPlayerMapPosition("player")
		x = math.floor(100 * x)
		y = math.floor(100 * y)
		if x ~= 0 and y ~= 0 then
			coords:SetText("("..x..", "..y..")")
		else
			coords:SetText("")
		end

		local scale = WorldMapDetailFrame:GetEffectiveScale()
		local width = WorldMapDetailFrame:GetWidth()
		local height = WorldMapDetailFrame:GetHeight()
		local centerX, centerY = WorldMapDetailFrame:GetCenter()
		local x, y = GetCursorPosition()
		local adjustedX = (x / scale - (centerX - (width/2))) / width
		local adjustedY = (centerY + (height/2) - y / scale) / height

		if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
			adjustedX = math.floor(100 * adjustedX)
			adjustedY = math.floor(100 * adjustedY)
			cursorcoords:SetText(MOUSE_LABEL..": "..adjustedX..", "..adjustedY)
		else
			cursorcoords:SetText(" ")
		end

		last = 0
	end
end)

hooksecurefunc("EncounterJournal_AddMapButtons", function()
	if WorldMapQuestShowObjectives:IsShown() then
		WorldMapShowDigSites:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, 18)
	else
		WorldMapShowDigSites:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT")
	end
end)

local editbox = CreateFrame("EditBox", "MapSearchBox", panel, "SearchBoxTemplate")
editbox:SetAutoFocus(false)
editbox:SetSize(150, 20)
editbox:SetPoint("CENTER", panel)
editbox:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
editbox:SetShadowOffset(0, 0)

editbox.db = {}
for i=1, select("#", GetMapContinents()), 1 do
	local zonesdb = {}
	for j=1, select("#", GetMapZones(i)), 1 do
		tinsert(zonesdb, {id=j, name=select(j, GetMapZones(i))})
	end
	tinsert(editbox.db, {id=i, name=select(i, GetMapContinents()), zones = zonesdb })
end

editbox:SetScript("OnHide", BagSearch_OnHide)

editbox:SetScript("OnTextChanged", function(self)
	local searchdata = self:GetText()
	if searchdata == "" then return end
	for i, v in pairs(self.db) do
		if v.name:lower():find(searchdata:lower()) then
			SetMapZoom(v.id)
			return
		end
		for j, k in pairs(v.zones) do
			if k.name:lower():find(searchdata:lower()) then
				SetMapZoom(v.id, k.id)
				return
			end
		end
	end
end)

local y = 0
local opened = false

panel.open = function()
	if opened == true then
		panel.close()
		return
	end
	opened = true
	panel:SetScript("OnUpdate", function()
		y = y + 1
		panel:SetPoint("TOPLEFT", WorldMapDetailFrame, "BOTTOMLEFT", -1, panelHeight-y)
		panel:SetPoint("TOPRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 1, panelHeight-y)
		if y == panelHeight then
			panel:SetScript("OnUpdate", nil)
			WorldMapShowDropDown:SetFrameStrata("HIGH")
			y = 0
		end
	end)
end

panel.close = function()
	opened = false
	WorldMapShowDropDown:SetFrameStrata("LOW")
	panel:SetScript("OnUpdate", function()
		y = y + 1
		panel:SetPoint("TOPLEFT", WorldMapDetailFrame, "BOTTOMLEFT", -1, 0+y)
		panel:SetPoint("TOPRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 1, 0+y)
		if y == panelHeight then
			panel:SetScript("OnUpdate", nil)
			y = 0
		end
	end)
end

button:HookScript("OnMouseDown", panel.open)