local last
local mail = CreateFrame"Frame"
mail:RegisterEvent"UPDATE_PENDING_MAIL"
mail:RegisterEvent"PLAYER_UPDATE_RESTING"
mail:SetScript("OnEvent", function(self, event)
	local senders = (", "):join(GetLatestThreeSenders())
	if(HasNewMail()) then
		AddNotification("Unread mail!", senders)
	end
end)
