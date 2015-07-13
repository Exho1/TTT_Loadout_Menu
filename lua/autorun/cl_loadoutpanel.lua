---- TTT Weapon Loadouts Clientside ----
-- Author: Exho

if CLIENT then
	-- Create a fancy font to use
	surface.CreateFont( "WeaponCategory", {
		font = "Arial",
		size = 20,
		weight = 1000,
		antialias = true,
	} )
	
	--// Prints a colored chat message
	local function chatMessage( args ) 
		chat.AddText( Color( 200, 50, 200 ), "Loadout: ", Color( 255, 255, 255 ), args)
	end
	
	net.Receive( "loadout_echo", function( len, client ) 
		local tab = net.ReadTable()
		local primary = tab[1]
		local secondary = tab[2]
		local grenade = tab[3]

		chatMessage( "Your loadout includes: "..primary..", "..secondary..", and "..grenade)
	end)
	
	net.Receive( "loadout_received", function( len, client )
		chatMessage( "Recieved loadout weapons! Type !loadout to change your loadout or disable them entirely.")
	end)
	
	hook.Add("Think", "loadout_keybind", function()
		if input.IsKeyDown( loadout.keyBind )  then
			openLoadoutMenu()
		end
	end)
	
	function openLoadoutMenu()
		local client = LocalPlayer()
		local pChoice, sChoice, gChoice
		
		if not client:canUseLoadout() then return chatMessage( loadout.denyMsg) end
		if IsValid(loadout.frame) then return end
		
		-- Creating the actual frame
		loadout.frame = vgui.Create( "DFrame" ) -- frame was declared earlier, so this can be local	
		loadout.frame:SetSize( 500, 300 )
		loadout.frame:Center()
		loadout.frame:SetTitle( "TTT Loadout" )
		loadout.frame:MakePopup()
		loadout.frame.Paint = function( self, w, h )
			-- The actual panel and then the primary area. Colors are defined above
			draw.RoundedBox( 8, 0, 0, w, h, Color(0, 0, 10, 230) )
			draw.RoundedBox( 0, 10, 30, w - 30, 30, Color(34, 42, 60) )
			draw.RoundedBox( 0, 10, 65, w - 30, 75, Color(44, 62, 80) )
			-- Secondary area
			draw.RoundedBox( 0, 10, 150, w / 2.3, 30, Color(34, 42, 60)  )
			draw.RoundedBox( 0, 10, 185, w / 2.3, 75, Color(44, 62, 80) )
			-- Grenade area
			draw.RoundedBox( 0, 263, 150, w / 2.3, 30, Color(34, 42, 60)  )
			draw.RoundedBox( 0, 263, 185, w / 2.3, 75, Color(44, 62, 80) )
		end
		
		local frame = loadout.frame
		
		------ BUTTONS ------
		local btnSubmit = vgui.Create( "DButton", frame )
		btnSubmit:SetText( "Submit" )
		btnSubmit:SetPos(400, 265)
		btnSubmit:SetSize(80, 30 )
		btnSubmit:SetTooltip("Confirm your selection of weapons for your loadout")
		btnSubmit.DoClick = function()
			-- Grabs choices, puts em into a table, and sends the table to the server
			chatMessage( "Loadout changes confirmed!")
			
			local tbl = {}
			tbl.primary = pChoice
			tbl.secondary = sChoice
			tbl.grenade = gChoice
			
			net.Start( "loadout_submit" )
				net.WriteTable( tbl )
			net.SendToServer()
			
			frame:Close()
		end
		
		local btnDisable = vgui.Create( "DButton", frame )
		btnDisable:SetText( "Disable" )
		btnDisable:SetPos(10, 265)
		btnDisable:SetSize(80, 30 )
		btnDisable:SetTooltip("Disables loadouts")
		btnDisable.DoClick = function()
			chatMessage( "Disabled your loadouts! Submit new ones to enable again.")
			
			net.Start( "loadout_submit" )
			net.SendToServer()
		end
		
		------ PRIMARY WEAPONS ------
		local lblPrimary = vgui.Create("DLabel", frame)
		lblPrimary:SetPos(20,37) 
		lblPrimary:SetColor( color_white ) 
		lblPrimary:SetFont("WeaponCategory")
		lblPrimary:SetText("Primary") 
		lblPrimary:SizeToContents()
		
		local scrollPrimary = vgui.Create("DHorizontalScroller", frame)
		scrollPrimary:SetSize(frame:GetWide() - 30, 65)
		scrollPrimary:SetPos(15, 70)
		
		for name, class in pairs( loadout.primary ) do
			local btnWeapon = vgui.Create( "DImageButton", frame )
			btnWeapon:SetSize( 64, 64 )
			btnWeapon:SetImage( loadout.icons[class] or "vgui/ttt/icon_nades.vtf" ) 
			btnWeapon:SetTooltip( name )
			btnWeapon.DoClick = function()
				surface.PlaySound( "buttons/button14.wav" )
				
				pChoice = class
				chatMessage( "Selected "..name.."!" )
			end
		
			scrollPrimary:AddPanel( btnWeapon )
		end
		
		------ SECONDARY WEAPONS ------
		local lblSecondary = vgui.Create("DLabel", frame)
		lblSecondary:SetPos( 20, 157 ) 
		lblSecondary:SetColor( color_white ) 
		lblSecondary:SetFont("WeaponCategory")
		lblSecondary:SetText("Secondary") 
		lblSecondary:SizeToContents() 
		
		local scrollSecondary = vgui.Create("DHorizontalScroller", frame)
		scrollSecondary:SetSize(frame:GetWide()/2 - 45, 65)
		scrollSecondary:SetPos(15, 190)
		
		for name, class in pairs( loadout.secondary ) do
			local btnWeapon = vgui.Create( "DImageButton", frame )
			btnWeapon:SetSize( 64, 64 )
			btnWeapon:SetImage( loadout.icons[class] or "vgui/ttt/icon_nades.vtf" ) 
			btnWeapon:SetTooltip( name )
			btnWeapon.DoClick = function()
				surface.PlaySound( "buttons/button14.wav" )
				
				sChoice = class
				chatMessage( "Selected "..name.."!" )
			end
		
			scrollSecondary:AddPanel( btnWeapon )
		end
		
		------ EXTRA WEAPONS ------
		local lblGrenades = vgui.Create("DLabel", frame)
		lblGrenades:SetPos(275,157) 
		lblGrenades:SetColor( color_white ) 
		lblGrenades:SetFont("WeaponCategory")
		lblGrenades:SetText("Grenade") 
		lblGrenades:SizeToContents() 
		
		local scrollGrenades = vgui.Create("DHorizontalScroller", frame)
		scrollGrenades:SetSize(frame:GetWide()/2 - 45, 65)
		scrollGrenades:SetPos(270, 190)
		
		for name, class in pairs( loadout.grenades ) do
			local btnWeapon = vgui.Create( "DImageButton", frame )
			btnWeapon:SetSize( 64, 64 )
			btnWeapon:SetImage( loadout.icons[class] or "vgui/ttt/icon_nades.vtf" ) 
			btnWeapon:SetTooltip( name )
			btnWeapon.DoClick = function()
				surface.PlaySound( "buttons/button14.wav" )
				
				gChoice = class
				chatMessage( "Selected "..name.."!" )
			end
		
			scrollGrenades:AddPanel( btnWeapon )
		end
	end
	
	net.Receive( "loadout_openmenu", function( len, client ) 
		openLoadoutMenu()
	end)
	
	concommand.Add( "wl_open", function(client)
		openLoadoutMenu()
	end)
	
	concommand.Add( "wl_version", function(client)
		print( "**** Exho's Weapon Loadout Addon ****" )
		print( "Version "..loadout.version)
		print( "**** Contact at STEAM_0:0:53332328 ****" )
	end)
end
