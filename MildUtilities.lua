
MildUtilities = {};
MildUtilities.fully_loaded = false;
MildUtilities.default_options = {

	-- main frame position
	frameRef = "CENTER",
	frameX = 0,
	frameY = 0,
	hide = false,

	-- sizing
	frameW = 200,
	frameH = 200,
};


function MildUtilities.OnReady()

	-- set up default options
	_G.MildUtilitiesPrefs = _G.MildUtilitiesPrefs or {};

	for k,v in pairs(MildUtilities.default_options) do
		if (not _G.MildUtilitiesPrefs[k]) then
			_G.MildUtilitiesPrefs[k] = v;
		end
	end

	MildUtilities.CreateUIFrame();

	disableTalkingHead();
end

function MildUtilities.OnSaving()

	if (MildUtilities.UIFrame) then
		local point, relativeTo, relativePoint, xOfs, yOfs = MildUtilities.UIFrame:GetPoint()
		_G.MildUtilitiesPrefs.frameRef = relativePoint;
		_G.MildUtilitiesPrefs.frameX = xOfs;
		_G.MildUtilitiesPrefs.frameY = yOfs;
	end
end

function MildUtilities.OnUpdate()
	if (not MildUtilities.fully_loaded) then
		return;
	end

	if (MildUtilitiesPrefs.hide) then 
		return;
	end

	MildUtilities.UpdateFrame();
end

function MildUtilities.OnEvent(frame, event, ...)

	if (event == 'ADDON_LOADED') then
		local name = ...;
		if name == 'MildUtilities' then
			MildUtilities.OnReady();
		end
		return;
	end

	if (event == 'PLAYER_LOGIN') then

		MildUtilities.fully_loaded = true;
		return;
	end

	if (event == 'PLAYER_LOGOUT') then
		MildUtilities.OnSaving();
		return;
	end
end

function MildUtilities.CreateUIFrame()

	-- create the UI frame
	MildUtilities.UIFrame = CreateFrame("Frame",nil,UIParent);
	MildUtilities.UIFrame:SetFrameStrata("BACKGROUND")
	MildUtilities.UIFrame:SetWidth(_G.MildUtilitiesPrefs.frameW);
	MildUtilities.UIFrame:SetHeight(_G.MildUtilitiesPrefs.frameH);

	-- make it black
	MildUtilities.UIFrame.texture = MildUtilities.UIFrame:CreateTexture();
	MildUtilities.UIFrame.texture:SetAllPoints(MildUtilities.UIFrame);
	MildUtilities.UIFrame.texture:SetTexture(0, 0, 0);

	-- position it
	MildUtilities.UIFrame:SetPoint(_G.MildUtilitiesPrefs.frameRef, _G.MildUtilitiesPrefs.frameX, _G.MildUtilitiesPrefs.frameY);

	-- make it draggable
	MildUtilities.UIFrame:SetMovable(true);
	MildUtilities.UIFrame:EnableMouse(true);

	-- create a button that covers the entire addon
	MildUtilities.Cover = CreateFrame("Button", nil, MildUtilities.UIFrame);
	MildUtilities.Cover:SetFrameLevel(128);
	MildUtilities.Cover:SetPoint("TOPLEFT", 0, 0);
	MildUtilities.Cover:SetWidth(_G.MildUtilitiesPrefs.frameW);
	MildUtilities.Cover:SetHeight(_G.MildUtilitiesPrefs.frameH);
	MildUtilities.Cover:EnableMouse(true);
	MildUtilities.Cover:RegisterForClicks("AnyUp");
	MildUtilities.Cover:RegisterForDrag("LeftButton");
	MildUtilities.Cover:SetScript("OnDragStart", MildUtilities.OnDragStart);
	MildUtilities.Cover:SetScript("OnDragStop", MildUtilities.OnDragStop);
	MildUtilities.Cover:SetScript("OnClick", MildUtilities.OnClick);

	-- add a main label - just so we can show something
	MildUtilities.Label = MildUtilities.Cover:CreateFontString(nil, "OVERLAY");
	MildUtilities.Label:SetPoint("CENTER", MildUtilities.UIFrame, "CENTER", 2, 0);
	MildUtilities.Label:SetJustifyH("LEFT");
	MildUtilities.Label:SetFont([[Fonts\FRIZQT__.TTF]], 12, "OUTLINE");
	MildUtilities.Label:SetText(" ");
	MildUtilities.Label:SetTextColor(1,1,1,1);
	MildUtilities.SetFontSize(MildUtilities.Label, 20);
end

function MildUtilities.SetFontSize(string, size)

	local Font, Height, Flags = string:GetFont()
	if (not (Height == size)) then
		string:SetFont(Font, size, Flags)
	end
end

function MildUtilities.OnDragStart(frame)
	MildUtilities.UIFrame:StartMoving();
	MildUtilities.UIFrame.isMoving = true;
	GameTooltip:Hide()
end

function MildUtilities.OnDragStop(frame)
	MildUtilities.UIFrame:StopMovingOrSizing();
	MildUtilities.UIFrame.isMoving = false;
end

function MildUtilities.OnClick(self, aButton)
	if (aButton == "RightButton") then
		print("show menu here!");
	end
end

function MildUtilities.UpdateFrame()

	-- update the main frame state here
	MildUtilities.Label:SetText(string.format("%d", GetTime()));
end


MildUtilities.EventFrame = CreateFrame("Frame");
MildUtilities.EventFrame:Show();
MildUtilities.EventFrame:SetScript("OnEvent", MildUtilities.OnEvent);
MildUtilities.EventFrame:SetScript("OnUpdate", MildUtilities.OnUpdate);
MildUtilities.EventFrame:RegisterEvent("ADDON_LOADED");
MildUtilities.EventFrame:RegisterEvent("PLAYER_LOGIN");
MildUtilities.EventFrame:RegisterEvent("PLAYER_LOGOUT");
