local mailNote = {
	name = "mail",
	title = "Unread mail!",
}

local last
local mail = CreateFrame"Frame"
mail:RegisterEvent"UPDATE_PENDING_MAIL"
mail:RegisterEvent"PLAYER_UPDATE_RESTING"
mail:SetScript("OnEvent", function(self, event)
	if(HasNewMail()) then
		mailNote.description = (", "):join(GetLatestThreeSenders())
		AddNotification(mailNote)
	end
end)
