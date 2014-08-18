---- TTT Weapon Loadouts Clientside ----
-- Author: Exho


if CLIENT then
	local Frame = nil 
	local p = 1
	local s = 2
	local g = 3 
	local function Text(slot, args) -- Function to make my life easier when writing all those messages. 
		if slot == 1 then
			chat.AddText( Color( 200, 50, 200 ), "Loadout: ", Color( 0, 170, 0 ), args)
		elseif slot == 2 then
			chat.AddText( Color( 200, 50, 200 ), "Loadout: ", Color( 20, 20, 170 ), args)
		elseif slot == 3 then
			chat.AddText( Color( 200, 50, 200 ), "Loadout: ", Color( 170, 0, 0 ), args)
		else -- Above stuff is for guns, below is for any other messages
			chat.AddText( Color( 200, 50, 200 ), "Loadout: ", Color( 255, 255, 255 ), args)
		end
	end
	-- Create a fancy font to use
	surface.CreateFont( "WeaponCategory", {
	font = "Arial",
	size = 20,
	weight = 1000,
	antialias = true,
} )
	net.Receive( "LoadoutPrint", function( len, ply ) 
		local tab = net.ReadTable()
		local primary = tab[1]
		local secondary = tab[2]
		local grenade = tab[3]
		for k,v in pairs(WL_WEPNAMES) do
			if k == primary then
				primary = v
			elseif k == secondary then
				secondary = v
			elseif k == grenade then
				grenade = v
			end
		end
		Text(0, "Your loadout includes: "..primary..", "..secondary..", and "..grenade)
	end)
	
	net.Receive( "LoadoutGiven", function( len, ply )
		Text(0, "Recieved loadout weapons! Type !Loadout to change your loadout or disable them entirely. Have fun!!")
	end)
	
	--hook.Add("Think", "Loadoutkey", function()
	--	if input.IsKeyDown( WL_Panel_Key ) and Frame == nil then
	--		OpenLoadoutMenu()
	--	end
	--end)
	
	function OpenLoadoutMenu()
		local ply = LocalPlayer()
		local pChoice = pChoice or "" -- Declaring our choices. The 'or' part is left over from an idea I had
		local sChoice = sChoice or "" -- It isnt hurting anyone so might as well keep it
		local gChoice = gChoice or ""
		
		if not CanUseLoadout(ply) then return Text(0, WL_Deny_MSG) end
		
		-- Creating the actual frame
		Frame = vgui.Create( "DFrame" ) -- Frame was declared earlier, so this can be local	
		Frame:SetPos( 700, 400 )
		Frame:SetSize( 500, 300 )
		Frame:SetTitle( WL_Panel_Title )
		Frame:SetVisible( true )
		Frame:MakePopup()
		Frame.Paint = function()
			-- The actual panel and then the primary area. Colors are defined above
			draw.RoundedBox( 8, 0, 0, Frame:GetWide(), Frame:GetTall(), WL_Panel_Body )
			draw.RoundedBox( 0, 10, 30, Frame:GetWide() - 30, 30, WL_Panel_Header )
			draw.RoundedBox( 0, 10, 65, Frame:GetWide() - 30, 75, WL_Panel_Content )
			-- Secondary area
			draw.RoundedBox( 0, 10, 150, Frame:GetWide() / 2.3, 30, WL_Panel_Header  )
			draw.RoundedBox( 0, 10, 185, Frame:GetWide() / 2.3, 75, WL_Panel_Content )
			-- Grenade area
			draw.RoundedBox( 0, 263, 150, Frame:GetWide() / 2.3, 30, WL_Panel_Header  )
			draw.RoundedBox( 0, 263, 185, Frame:GetWide() / 2.3, 75, WL_Panel_Content )
		end
		
		
		------ BUTTONS ------
		local Submit = vgui.Create( "DButton", Frame )
		Submit:SetText( "Submit" )
		Submit:SetPos(400, 265)
		Submit:SetSize(80, 30 )
		Submit:SetTooltip("Confirm your selection of weapons for your Loadout")
		Submit.DoClick = function()
			-- Grabs choices, puts em into a table, and sends the table to the server
			Text(0, "Submitted!")
			local GunInfo = {}
			GunInfo.ply = LocalPlayer():SteamID()
			GunInfo.primary = pChoice
			GunInfo.secondary = sChoice
			GunInfo.grenade = gChoice
			net.Start( "LoadoutSubmit" )
				net.WriteTable(GunInfo)
			net.SendToServer()
			Frame:SetVisible( false ) -- Closes the frame after submitting
		end
		
		local Close = vgui.Create( "DButton", Frame )
		Close:SetText( "Disable" ) -- A close button would be redundant....
		Close:SetPos(10, 265)
		Close:SetSize(80, 30 )
		Close:SetTooltip("Disable the Loadouts until you submit new ones")
		Close.DoClick = function()
			-- Disables PData and sends an empty table to the server. 2 birds 1 stone
			Text(0, "Disabled your loadouts! Submit new ones to enable again.")
			LocalPlayer():SetPData("TTTLoadoutOn", "false")
			local GunInfo = {}
			GunInfo.primary = ""
			GunInfo.secondary = ""
			GunInfo.grenade = ""
			net.Start( "LoadoutSubmit" )
				net.WriteTable(GunInfo)
			net.SendToServer()
		end
		
		-- Below this line are all the buttons, its just copy/pasted over and over again.
		
		------ PRIMARY WEAPONS ------
		local label1 = vgui.Create("DLabel", Frame)
		label1:SetPos(20,37) 
		label1:SetColor(WL_Panel_Category) 
		label1:SetFont("WeaponCategory")
		label1:SetText("Primary") 
		label1:SizeToContents()
		
		local Wep1 = vgui.Create( "DImageButton", Frame )
		Wep1:SetPos( 20, 70 )
		Wep1:SetSize( 64, 64 )
		Wep1:SetImage( "vgui/ttt/icon_m16.vtf" ) -- Icon path
		Wep1:SetTooltip("M16") -- Tooltip in case the icon doesnt give it away
		Wep1.DoClick = function()
			pChoice = WL_WEAPON_1 -- Sets the weapon choice
			Text(p, "Selected M16!") -- Confirms in chat
		end
		
		local Wep2 = vgui.Create( "DImageButton", Frame )
		Wep2:SetPos( 90, 70 )                      
		Wep2:SetSize( 64, 64 )       
		Wep2:SetImage( "vgui/ttt/icon_shotgun.vtf" )   
		Wep2:SetTooltip("Shotgun")		
		Wep2.DoClick = function()
			pChoice = WL_WEAPON_2
			Text(p, "Selected Shotgun!")
		end
		
		local Wep3 = vgui.Create( "DImageButton", Frame )
		Wep3:SetPos( 160, 70 )                      
		Wep3:SetSize( 64, 64 )       
		Wep3:SetImage( "vgui/ttt/icon_m249.vtf" )   
		Wep3:SetTooltip("HUGE")
		Wep3.DoClick = function()
			pChoice = WL_WEAPON_3
			Text(p, "Selected HUGE!")
		end
		
		local Wep4 = vgui.Create( "DImageButton", Frame )
		Wep4:SetPos( 230, 70 )                      
		Wep4:SetSize( 64, 64 )       
		Wep4:SetImage( "vgui/ttt/icon_mac.vtf" )   
		Wep4:SetTooltip("Mac10")
		Wep4.DoClick = function()
			pChoice = WL_WEAPON_4
			Text(p, "Selected Mac10!")
		end
		
		local Wep5 = vgui.Create( "DImageButton", Frame )
		Wep5:SetPos( 300, 70 )                      
		Wep5:SetSize( 64, 64 )       
		Wep5:SetImage( "vgui/ttt/icon_scout.vtf" )   
		Wep5:SetTooltip("Scout")
		Wep5.DoClick = function()
			pChoice = WL_WEAPON_5
			Text(p, "Selected Scout!")
		end
		
		
		------ SECONDARY WEAPONS ------
		local label2 = vgui.Create("DLabel", Frame)
		label2:SetPos(20,157) 
		label2:SetColor(WL_Panel_Category) 
		label2:SetFont("WeaponCategory")
		label2:SetText("Secondary") 
		label2:SizeToContents() 
		
		local Wep6 = vgui.Create( "DImageButton", Frame )
		Wep6:SetPos( 15, 190 )                      
		Wep6:SetSize( 64, 64 )       
		Wep6:SetImage( "vgui/ttt/icon_pistol.vtf" )  
		Wep6:SetTooltip("Five Seven")
		Wep6.DoClick = function()
			sChoice = WL_WEAPON_6
			Text(s, "Selected Five Seven!")
		end
		
		local Wep7 = vgui.Create( "DImageButton", Frame )
		Wep7:SetPos( 85, 190 )                      
		Wep7:SetSize( 64, 64 )       
		Wep7:SetImage( "vgui/ttt/icon_glock.vtf" )   
		Wep7:SetTooltip("Glock")
		Wep7.DoClick = function()
			sChoice = WL_WEAPON_7
			Text(s,"Selected Glock!")
		end
		
		local Wep8 = vgui.Create( "DImageButton", Frame )
		Wep8:SetPos( 155, 190 )                      
		Wep8:SetSize( 64, 64 )       
		Wep8:SetImage( "vgui/ttt/icon_deagle.vtf" )    
		Wep8:SetTooltip("Deagle")
		Wep8.DoClick = function()
			sChoice = WL_WEAPON_8
			Text(s,"Selected Deagle!")
		end
		
		
		------ GRENADES -------
		local label3 = vgui.Create("DLabel", Frame)
		label3:SetPos(275,157) 
		label3:SetColor(WL_Panel_Category) 
		label3:SetFont("WeaponCategory")
		label3:SetText("Grenade") 
		label3:SizeToContents() 
		
		local Wep9 = vgui.Create( "DImageButton", Frame )
		Wep9:SetPos( 270, 190 )                      
		Wep9:SetSize( 64, 64 )       
		Wep9:SetImage( WL_ICON_INCEN )     
		Wep9:SetTooltip("Incendinary") -- Tool tips are useful here because I dont have icons for the grenades
		Wep9.DoClick = function()
			gChoice = WL_WEAPON_9
			Text(g, "Selected Incendinary Grenade")
		end
		
		local Wep10 = vgui.Create( "DImageButton", Frame )
		Wep10:SetPos( 340, 190 )                      
		Wep10:SetSize( 64, 64 )       
		Wep10:SetImage( WL_ICON_DISCOM )   
		Wep10:SetTooltip("Discombobulator")
		Wep10.DoClick = function()
			gChoice = WL_WEAPON_10
			Text(g,"Selected Discombobulator Grenade!")
		end
		
		local Wep11 = vgui.Create( "DImageButton", Frame )
		Wep11:SetPos( 410, 190 )                      
		Wep11:SetSize( 64, 64 )       
		Wep11:SetImage( WL_ICON_SMOKE ) 
		Wep11:SetTooltip("Smoke")
		Wep11.DoClick = function()
			gChoice = WL_WEAPON_10
			Text(g,"Selected Smoke Grenade!")
		end
	end
	net.Receive( "OpenLoadoutMenu", function( len, ply ) 
		OpenLoadoutMenu()
	end)
end
-- fin
