---------------
-- LinkHover --
---------------
-- Show tooltips when hovering all kind of links in chat.
-- By Jerome Leclanche <adys.wh@gmail.com>
-- LinkHover is hereby placed in the Public Domain.

local _, LinkHover = ...

LinkHover.show = {
	["achievement"] = true,
	["enchant"]     = true,
	["glyph"]       = true,
	["item"]        = true,
	["quest"]       = true,
	["spell"]       = true,
	["talent"]      = true,
	["unit"]        = true,
}

function LinkHover:OnHyperlinkEnter(frame, linkData, link)
	local t = linkData:match("^(.-):")
	if self.show[t] then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end
end

function LinkHover:OnHyperlinkLeave(frame, linkData, link)
	local t = linkData:match("^(.-):")
	if self.show[t] then
		HideUIPanel(GameTooltip)
	end
end

function LinkHover:init()
	local i
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		frame:SetScript("OnHyperlinkEnter", function(...) self:OnHyperlinkEnter(...) end)
		frame:SetScript("OnHyperlinkLeave", function(...) self:OnHyperlinkLeave(...) end)
	end
end

LinkHover:init()
