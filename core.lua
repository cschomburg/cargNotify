local cargNotify = CreateFrame("Frame", nil, UIParent)
local Prototype = CreateFrame"Button"

local metatable = {__index = Prototype}
local shown = {}
local frames = {}

function cargNotify:AddNotification(arg1, arg2, ...)
	if(type(arg1) == "table") then
		self:CreateNotification(arg1.title, arg1.description, arg1.percent, arg1)
	else
		self:CreateNotification(arg1, arg2, ...)
	end
end

function AddNotification(...) cargNotify:AddNotification(...) end
notify = AddNotification

function cargNotify:CreateNotification(title, description, percent, additional)
	local name = additional and additional.name
	local frame = name and shown[name] or self:FetchFrame(name)
	frame:SetTitle(title)
	frame:SetDescription(description)
	frame:SetProgress(percent)
	frame:UpdateLayout()
	frame:SetScript("OnClick", additional and additional.onClick)
	frame:SetScript("OnEnter", additional and additional.onEnter)
	frame:SetScript("OnLeave", additional and additional.onLeave)
	frame:EnableMouse(click ~= nil)
	frame:SetAlpha(0)
	frame:SetScript("OnHide", Prototype.OnHide)
	frame:Show()

	if(name) then
		shown[name] = frame
		frame.Name = name
	end

	if(not frame.Active) then
		shown[#shown+1] = frame
		UIFrameFlash(frame, 0.5, 3, 0.5+3+2, false, 0, 2)
	end
		
	frame.Active = true
	self:UpdateFrames()
	return frame
end

local count = 0
function cargNotify:FetchFrame()
	if(#frames > 0) then return tremove(frames) end

	count = count + 1
	local frame = CreateFrame("Button", "cargNotify"..count, self)
	frame = setmetatable(frame, metatable)
	frame:SetHeight(12)
	frame:SetBackdrop{
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	}
	frame:SetBackdropColor(0, 0, 0, .8)
	frame:SetBackdropBorderColor(0, 0, 0, 0.5)
	frame:SetWidth(200)
	return frame
end

function cargNotify:UpdateFrames()
	local prev
	for _, frame in ipairs(shown) do
		frame:ClearAllPoints()
		if(not prev) then
			frame:SetPoint("BOTTOMRIGHT")
		else
			frame:SetPoint("BOTTOM", prev, "TOP", 0, 5)
		end
		prev = frame
	end
end

function Prototype:OnHide()
	for i, frame in ipairs(shown) do
		if(frame == self) then
			tremove(shown, i)
			tinsert(frames, frame)
			frame.Active = nil
			if(frame.Name) then shown[frame.Name] = nil end
			
			return cargNotify:UpdateFrames()
		end
	end
end

function Prototype:SetTitle(text)
	local title = self.Title
	if(not title and text) then
		title = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
		title:SetWidth(self:GetWidth()-30)
		title:SetJustifyH("LEFT")
		self.Title = title
	end
	self.TitleShown = text ~= nil
	if(text) then
		title:SetText(text)
		title:Show()
	elseif(title) then
		title:Hide()
	end
end

function Prototype:SetDescription(text)
	local desc = self.Desc
	if(not desc and text) then
		desc = self:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		desc:SetWidth(self:GetWidth()-40)
		desc:SetJustifyH("LEFT")
		self.Desc = desc
	end
	self.DescShown = text ~= nil
	if(text) then
		desc:SetText(text)
		desc:Show()
	elseif(desc) then
		desc:Hide()
	end
end

function Prototype:SetProgress(percent)
	local progress = self.Progress
	if(not progress and percent) then
		progress = CreateFrame("StatusBar", nil, self)
		progress:SetMinMaxValues(0, 1)
		progress:SetHeight(32)
		progress:SetWidth(self:GetWidth()-65)
		progress:SetStatusBarTexture("Interface\\AddOns\\cargNotify\\textures\\progressbar")
		progress:SetBackdrop{
			bgFile = "Interface\\AddOns\\cargNotify\\textures\\progressbar",
			tile = false,
		}
		progress:SetBackdropColor(1, 1, 1, .1)

		progress.Value = progress:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		progress.Value:SetPoint("LEFT", progress, "RIGHT")
		progress.Value:SetWidth(35)
		self.Progress = progress
	end
	self.ProgressShown = percent~= nil
	if(percent) then
		progress:SetValue(percent)
		progress.Value:SetFormattedText("%.0f%%", percent*100)
		progress:Show()
	elseif(progress) then
		progress:Hide()
	end
end

function Prototype:UpdateLayout()
	local pos = 15
	local width = Prototype:GetWidth()

	if(self.TitleShown) then
		self.Title:ClearAllPoints()
		self.Title:SetPoint("TOPLEFT", 15, -pos)
		pos = pos + self.Title:GetHeight() + 5
	end

	if(self.DescShown) then
		self.Desc:ClearAllPoints()
		self.Desc:SetPoint("TOPLEFT", 20, -pos)
		pos = pos + self.Desc:GetHeight() + 10
	end

	if(self.ProgressShown) then
		self.Progress:ClearAllPoints()
		self.Progress:SetPoint("TOPLEFT", 20, -pos)
		pos = pos + self.Progress:GetHeight()
	end

	self:SetHeight(pos+10)
end

cargNotify:SetPoint("BOTTOMRIGHT", 0, 120)
cargNotify:SetWidth(1)
cargNotify:SetHeight(1)

getfenv(0).cargNotify = cargNotify