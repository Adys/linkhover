---------------
-- LinkHover --
---------------
-- Show tooltips when hovering all kind of links in chat.
-- Written by Jerome Leclanche <jerome@leclan.ch>
-- LinkHover is hereby placed in the Public Domain.

local _, LinkHover = ...

LinkHover.show = {
	achievement    = GameTooltip,
	battlepet      = BattlePetTooltip,
	battlePetAbil  = SharedPetBattleAbilityTooltip,
	currency       = GameTooltip,
	enchant        = GameTooltip,
	glyph          = GameTooltip,
	item           = GameTooltip,
	instancelock   = GameTooltip,
	quest          = GameTooltip,
	spell          = GameTooltip,
	talent         = GameTooltip,
	unit           = GameTooltip,
}

local function tonumber_all(v, ...)
	if select('#', ...) == 0 then
		return tonumber(v)
	else
		return tonumber(v), tonumber_all(...)
	end
end

function LinkHover:OnHyperlinkEnter(frame, linkData, link)
	local tt = self.show[linkData:match("^(.-):")]
	if tt then
		if tt == BattlePetTooltip then
			local x, y = GetCursorPosition()
			local scale = UIParent:GetEffectiveScale()
			x = x / scale
			y = y / scale
			GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
			GameTooltip:SetPoint(
				"BOTTOMLEFT", UIParent, "BOTTOMLEFT", x - GameTooltip:GetWidth() / 2, y
			)
			BattlePetToolTip_Show(tonumber_all(select(2, strsplit(":", linkData))))
		elseif tt == SharedPetBattleAbilityTooltip then
			-- TODO: Get someone fired
		else
			ShowUIPanel(tt)
			tt:SetOwner(UIParent, "ANCHOR_CURSOR")
			tt:SetHyperlink(link)
			tt:Show()
		end
	end
end

function LinkHover:OnHyperlinkLeave(frame, linkData, link)
	local tt = self.show[linkData:match("^(.-):")]
	if tt then
		tt:Hide()
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
