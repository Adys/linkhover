---------------
-- LinkHover --
---------------
-- Show tooltips when hovering all kind of links in chat.
-- By Jerome Leclanche <adys.wh@gmail.com>
-- LinkHover is hereby placed in the Public Domain.

local _, LinkHover = ...

LinkHover.show = {
	achievement  = true,
	enchant      = true,
	glyph        = true,
	item         = true,
	instancelock = true,
	quest        = true,
	spell        = true,
	talent       = true,
	unit         = true,
}

function LinkHover:OnHyperlinkEnter(frame, linkData, link)
	if self.show[linkData:match("^(.-):")] then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end
end

function LinkHover:OnHyperlinkLeave(frame, linkData, link)
	if self.show[linkData:match("^(.-):")] then
		GameTooltip:Hide()
	end
end

function LinkHover:registerFrame(frame)
	frame:SetScript("OnHyperlinkEnter", function(...) self:OnHyperlinkEnter(...) end)
	frame:SetScript("OnHyperlinkLeave", function(...) self:OnHyperlinkLeave(...) end)
end

function LinkHover:init()
	self.eventframe = CreateFrame("Frame")
	self.eventframe:RegisterEvent("GUILDBANKFRAME_OPENED")
	self.eventframe:SetScript("OnEvent",
		function(...)
			if GuildBankMessageFrame then -- Check for addons that replace the guildbank frame
				self:registerFrame(GuildBankMessageFrame)
				self.eventframe:UnregisterEvent("GUILDBANKFRAME_OPENED")
				self.registerFrame = nil
			end
		end
	)
	local i
	for i = 1, NUM_CHAT_WINDOWS do
		self:registerFrame(_G["ChatFrame"..i])
	end
end

LinkHover:init()
LinkHover.init = nil
