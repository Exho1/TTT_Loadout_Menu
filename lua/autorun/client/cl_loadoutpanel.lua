local frame = nil

local function WLPrint(args)
	local color = Color(255, 255, 255, 255)
	
	chat.AddText(Color(200, 50, 200), "Loadout: ", color, args)
end

net.Receive("LoadoutPrint", function(len)
	local p = net.ReadString()
	local s = net.ReadString()
	local g = net.ReadString()

	local p = WL.Weapons[p].Name or "None selected"
	local s = WL.Weapons[s].Name or "None selected"
	local g = WL.Weapons[g].Name or "None selected"

	local str = "Your loadout includes: Primary - "..p..", Secondary - "..s..", Grenade - "..g

	WLPrint(str)
end)

net.Receive("LoadoutReceived", function(len)
	WLPrint("Loadout received! Type "..WL.ChatCommand.." to edit it!")
end)

surface.CreateFont( "WeaponCategory", {
	font = "Arial",
	size = 20,
	weight = 1000,
	antialias = true,
} )

local function WLMenu()

	local p = LocalPlayer():GetNWString("TTTPrimary", "None")
	local s = LocalPlayer():GetNWString("TTTSecondary", "None")
	local g = LocalPlayer():GetNWString("TTTGrenade", "None")

	local pchoice = p
	local schoice = s
	local gchoice = g

	frame = vgui.Create("DFrame")
	frame:SetSize(490, 300)
	frame:SetTitle(WL.Colors.Title)
	frame:Center()
	frame:MakePopup()
	function frame:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, WL.Colors.Body)
		//primary
		draw.RoundedBox(0, 10, 30, w - 24, 30, WL.Colors.TextHeadings)
		draw.RoundedBox(0, 10, 65, w - 24, 75, WL.Colors.Content)
		//secondary
		draw.RoundedBox(0, 10, 150, w / 2.3, 30, WL.Colors.TextHeadings)
		draw.RoundedBox(0, 10, 185, w / 2.3, 75, WL.Colors.Content)
		//grenade
		draw.RoundedBox(0, 263, 150, w / 2.3, 30, WL.Colors.TextHeadings)
		draw.RoundedBox(0, 263, 185, w / 2.3, 75, WL.Colors.Content)
	end

	local sub = vgui.Create("DButton", frame)
	sub:SetText("Submit")
	sub:SetPos(397, 265)
	sub:SetSize(80, 30)
	sub:SetToolTip("Confirm your loadout selection")
	function sub:DoClick()
		WLPrint("Loadout submitted!")

		net.Start("LoadoutSubmit")
			net.WriteString(pchoice)
			net.WriteString(schoice)
			net.WriteString(gchoice)
		net.SendToServer()

		frame:Remove()
	end

	local close = vgui.Create("DButton", frame)
	close:SetText("Disable")
	close:SetPos(10, 265)
	close:SetSize(80, 30)
	close:SetToolTip("Exit the loadout menu")
	function close:DoClick()
		net.Start("LoadoutDisable")
		net.SendToServer()

		WLPrint("Loadout disabled.")

		frame:Close()
	end

	local pheader = vgui.Create("DLabel", frame)
	pheader:SetPos(20, 37)
	pheader:SetColor(WL.Colors.Category)
	pheader:SetFont("WeaponCategory")
	pheader:SetText("Primary")
	pheader:SizeToContents()

	local pholder = vgui.Create("DHorizontalScroller", frame)
	pholder:SetSize(frame:GetWide() - 30, 75)
	pholder:SetPos(10, 65)

	local sheader = vgui.Create("DLabel", frame)
	sheader:SetPos(20, 157)
	sheader:SetColor(WL.Colors.Cateogry)
	sheader:SetFont("WeaponCategory")
	sheader:SetText("Secondary")
	sheader:SizeToContents()

	local sholder = vgui.Create("DHorizontalScroller", frame)
	sholder:SetSize(frame:GetWide() / 2.3, 75)
	sholder:SetPos(10, 185)

	local gheader = vgui.Create("DLabel", frame)
	gheader:SetPos(275, 157)
	gheader:SetColor(WL.Colors.Category)
	gheader:SetFont("WeaponCategory")
	gheader:SetText("Grenade")
	gheader:SizeToContents()

	local gholder = vgui.Create("DHorizontalScroller", frame)
	gholder:SetSize(frame:GetWide() / 2.3, 75)
	gholder:SetPos(263, 185)

	local cats = {};
	cats["primary"] = pholder
	cats["secondary"] = sholder
	cats["grenade"] = gholder

	local weplist = {}
	weplist["primary"] = {}
	weplist["secondary"] = {}
	weplist["grenade"] = {}

	for k,v in pairs(WL.Weapons) do
		if (!v.Class or !cats[v.Class] or !v.Icon) then continue; end
		
		local wep = vgui.Create("DImageButton", cats[v.Class])
		wep:SetSize(64, 64)
		wep:SetImage(v.Icon)
		wep:SetToolTip(v.Name)

		if (v.Class == "primary" and k == p) then wep:SetDrawBorder(true) end
		if (v.Class == "secondary" and k == s) then wep:SetDrawBorder(true) end
		if (v.Class == "grenade" and k == g) then wep:SetDrawBorder(true) end

		function wep:DoClick()

			if (v.Class == "primary") then
				pchoice = k

				for k,v in pairs(weplist["primary"]) do
					v:SetDrawBorder(false)
				end
			elseif (v.Class == "secondary") then
				schoice = k

				for k,v in pairs(weplist["secondary"]) do
					v:SetDrawBorder(false)
				end
			else
				gchoice = k
			
				for k,v in pairs(weplist["grenade"]) do
					v:SetDrawBorder(false)
				end
			end

			wep:SetDrawBorder(true)
		end

		function wep:PaintOver()
			if (self:GetDrawBorder()) then
				surface.SetDrawColor(WL.Colors.ActiveOutline)
    			surface.DrawOutlinedRect(0, 0, wep:GetWide(), wep:GetTall())
			end
		end

		table.insert(weplist[v.Class], wep)
		cats[v.Class]:AddPanel(wep)

	end
end
net.Receive("OpenLoadoutMenu", WLMenu)