local xpNote = {
	name = "xp",
}

local last
local xp = CreateFrame"Frame"
xp:RegisterEvent"PLAYER_XP_UPDATE"
xp:RegisterEvent"PLAYER_LEVEL_UP"
xp:SetScript("OnEvent", function(self, event)
	local min, max, rest = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
	local diff = min-(last or min)
	last = min

	xpNote.title = ("%.1f%% xp +%.1f%%"):format(min/max*100, diff/max*100)
	xpNote.description = min.." / "..max
	xpNote.percent = min/max
	AddNotification(xpNote)
end)