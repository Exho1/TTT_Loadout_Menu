---- TTT Weapon Loadouts ----
-- Author: Exho
-- V: 8/17/14	

------ CONFIGURATION ------
-- Loadout panel stuff
local Panel_Header 		= Color(34, 42, 60) -- Where it says "Primary", "Secondary", and "Grenade"
local Panel_Content 	= Color(44, 62, 80) -- Where the gun icons are located
local Panel_Body		= Color(0, 0, 10, 230) -- The actual panel background. Alpha is used in this one only
local Panel_Category	= Color(255, 255, 255) -- Category name color
local Panel_Title		= "Weapon Loadout Menu" -- Title of the panel

-- Blacklist
-- Usergroups that are unable to use the loadout menu, "user" or "admin" for example. Leave empty if not used
local Blacklist 	= {}
local Deny_MSG 		= "Your group cannot use the loadout menu! Sorry :(" -- Blacklist deny message (if used)

-- Primary
local WEAPON_1 	= "weapon_ttt_m16" -- Gun class
local ICON_1 	= "vgui/ttt/icon_m16.vtf" -- Gun icon path
local WEAPON_2 	= "weapon_zm_shotgun"
local ICON_2	= "vgui/ttt/icon_shotgun.vtf"
local WEAPON_3	= "weapon_zm_sledge"
local ICON_3 	= "vgui/ttt/icon_m249.vtf"
local WEAPON_4	= "weapon_zm_mac10"
local ICON_4 	= "vgui/ttt/icon_mac.vtf"
local WEAPON_5	= "weapon_zm_rifle"
local ICON_5	= "vgui/ttt/icon_scout.vtf"
-- Secondary
local WEAPON_6	= "weapon_zm_pistol"
local ICON_6 	= "vgui/ttt/icon_pistol.vtf"
local WEAPON_7	= "weapon_ttt_glock"
local ICON_7	= "vgui/ttt/icon_glock.vtf"
local WEAPON_8	= "weapon_zm_revolver"
local ICON_8 	= "vgui/ttt/icon_deagle.vtf"
-- Grenades
local WEAPON_9	= "weapon_zm_molotov"
local ICON_9 	= "vgui/ttt/icon_nades.vtf" -- There is no icon for these and I am not artistic.
local WEAPON_10 = "weapon_ttt_confgrenade" -- The tool tips will tell you which grenades are which
local ICON_10 	="vgui/ttt/icon_nades.vtf"
local WEAPON_11	= "weapon_ttt_smokegrenade"
local ICON_11	= "vgui/ttt/icon_nades.vtf"
------ //END CONFIGURATION//------

-- Only edit below this if you actually know what you are doing... 

function CanUseLoadout(ply)
	if #Blacklist == 0 then return true end -- No groups on the blacklist
	for k, group in pairs(Blacklist) do
		if ply:IsUserGroup(group) then
			return false
		end
	end
	return true
end

if SERVER then -- Our serverside stuff
	AddCSLuaFile()
	-- Creating our network stuff
	util.AddNetworkString( "OpenLoadoutMenu" )
	util.AddNetworkString( "LoadoutSubmit" )
	util.AddNetworkString( "LoadoutPrint" )
	-- Adding all the icons
	resource.AddFile("vgui/ttt/icon_m16.vmt")
	resource.AddFile("vgui/ttt/icon_glock.vmt")
	resource.AddFile("vgui/ttt/icon_m249.vmt")
	resource.AddFile("vgui/ttt/icon_mac.vmt")
	resource.AddFile("vgui/ttt/icon_pistol.vmt")
	resource.AddFile("vgui/ttt/icon_scout.vmt")
	resource.AddFile("vgui/ttt/icon_shotgun.vmt")
	resource.AddFile("vgui/ttt/icon_deagle.vmt")
	resource.AddFile("vgui/ttt/icon_nades.vmt")
	
	Loadouts = Loadouts or {}
	
	net.Receive( "LoadoutSubmit", function( len, ply )
		-- Serverside grabbing of the loadout data
		local tab = net.ReadTable()
		print("Recieved new loadout from "..ply:Nick())
		Loadouts[ply:SteamID()] = { primary = tab.primary, secondary = tab.secondary, grenade = tab.grenade }
		ply:SetPData("TTTLoadoutOn", "true") -- PData persists so we use it for a more permanent approach
		ply:SetPData("TTTPrimary", tab.primary)
		ply:SetPData("TTTSecondary", tab.secondary)
		ply:SetPData("TTTGrenade", tab.grenade)
	end )
	
	hook.Add( "TTTBeginRound", "Givestuff", function()
		print("**Giving loadouts...**")
		Loadouts = Loadouts or {} -- This is redundant but it scares me not to have it
		for k,v in pairs(player.GetAll()) do
			if v:GetPData("TTTLoadoutOn", "false") == "true" then -- Pulls PData to use in the current table
				local p = v:GetPData("TTTPrimary", "")
				local s = v:GetPData("TTTSecondary", "")
				local g = v:GetPData("TTTGrenade", "")
				Loadouts[v:SteamID()] = { primary = p, secondary = s, grenade = g }
			end
			for key, value in pairs(Loadouts) do -- Now we check each player to the current loadout table
				if v:SteamID() == key then
					if v:IsSpec() or not v:Alive() then return end -- Only give to the living
					if not CanUseLoadout(v) then return end
					print(v:Nick().." has recieved their loadout!")
					-- Gives the loadout. Funny enough, this was the easiest part of the entire project...
					local weps = value
					v:Give(weps.primary)
					v:Give(weps.secondary)
					v:Give(weps.grenade)
				end
			end
		end
		print("**Loadouts finished!**") -- Recordkeeping in console
	end)
	
	hook.Add( "PlayerSay", "LoadoutMenu", function(ply, text, public)
		local text = string.lower(text) -- Chat command to open the menu
		if (string.sub(text, 1, 8) == "!loadout") then
			ply:ConCommand("wl_open")
		end
	end)
	concommand.Add( "wl_open", function(ply)
		-- The console command it uses
		net.Start("OpenLoadoutMenu")
		net.Send(ply)
	end )
	
	hook.Add( "PlayerSay", "LoadoutChecker", function(ply, text, public)
		local text = string.lower(text) -- Chat command to tell the player what their current loadout is
		if (string.sub(text, 1, 13) == "!loadoutprint") then
			local p = ply:GetPData("TTTPrimary", "none") -- I wonder if grabbing Pdata this much is bad...
			local s = ply:GetPData("TTTSecondary", "none")
			local g = ply:GetPData("TTTGrenade", "none")
			local tab = {p,s,g}
			net.Start("LoadoutPrint")
				net.WriteTable(tab)
			net.Send(ply)
			return false
		end
	end)
end



if CLIENT then -- And switching over to the client
	local p = 1
	local s = 2
	local g = 3 
	-- Function to make my life easier when writing all those messages. 
	local function Text(slot, args)
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
		local msg = table.concat(tab, ", ")
		Text(0, "Your loadout includes: "..msg)
	end)
	
	function OpenLoadoutMenu()
		local ply = LocalPlayer()
		local pChoice = pChoice or "" -- Declaring our choices. The 'or' part is left over from an idea I had
		local sChoice = sChoice or "" -- It isnt hurting anyone so might as well keep it
		local gChoice = gChoice or ""
		
		if not CanUseLoadout(ply) then return Text(0, Deny_MSG) end
		
		-- Creating the actual frame
		local Frame = vgui.Create( "DFrame" )
		Frame:SetPos( 700, 400 )
		Frame:SetSize( 500, 300 )
		Frame:SetTitle( Panel_Title )
		Frame:SetVisible( true )
		Frame:MakePopup()
		Frame.Paint = function()
			-- The actual panel and then the primary area. Colors are defined above
			draw.RoundedBox( 8, 0, 0, Frame:GetWide(), Frame:GetTall(), Panel_Body )
			draw.RoundedBox( 0, 10, 30, Frame:GetWide() - 30, 30, Panel_Header )
			draw.RoundedBox( 0, 10, 65, Frame:GetWide() - 30, 75, Panel_Content )
			-- Secondary area
			draw.RoundedBox( 0, 10, 150, Frame:GetWide() / 2.3, 30, Panel_Header  )
			draw.RoundedBox( 0, 10, 185, Frame:GetWide() / 2.3, 75, Panel_Content )
			-- Grenade area
			draw.RoundedBox( 0, 263, 150, Frame:GetWide() / 2.3, 30,Panel_Header  )
			draw.RoundedBox( 0, 263, 185, Frame:GetWide() / 2.3, 75, Panel_Content )
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
		Close:SetText( "Disable" )
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
		label1:SetColor(Panel_Category) 
		label1:SetFont("WeaponCategory")
		label1:SetText("Primary") 
		label1:SizeToContents()
		
		local Wep1 = vgui.Create( "DImageButton", Frame )
		Wep1:SetPos( 20, 70 )     
		Wep1:SetSize( 64, 64 )       
		Wep1:SetImage( ICON_1 ) 
		Wep1:SetTooltip("M16")        
		Wep1.DoClick = function()
			pChoice = WEAPON_1
			Text(p, "Selected M16!")
		end
		
		local Wep2 = vgui.Create( "DImageButton", Frame )
		Wep2:SetPos( 90, 70 )                      
		Wep2:SetSize( 64, 64 )       
		Wep2:SetImage( ICON_2 )   
		Wep2:SetTooltip("Shotgun")		
		Wep2.DoClick = function()
			pChoice = WEAPON_2
			Text(p, "Selected Shotgun!")
		end
		
		local Wep3 = vgui.Create( "DImageButton", Frame )
		Wep3:SetPos( 160, 70 )                      
		Wep3:SetSize( 64, 64 )       
		Wep3:SetImage( ICON_3 )   
		Wep3:SetTooltip("HUGE")
		Wep3.DoClick = function()
			pChoice = WEAPON_3
			Text(p, "Selected HUGE!")
		end
		
		local Wep4 = vgui.Create( "DImageButton", Frame )
		Wep4:SetPos( 230, 70 )                      
		Wep4:SetSize( 64, 64 )       
		Wep4:SetImage( ICON_4 )   
		Wep4:SetTooltip("Mac10")
		Wep4.DoClick = function()
			pChoice = WEAPON_4
			Text(p, "Selected Mac10!")
		end
		
		local Wep5 = vgui.Create( "DImageButton", Frame )
		Wep5:SetPos( 300, 70 )                      
		Wep5:SetSize( 64, 64 )       
		Wep5:SetImage( ICON_5 )   
		Wep5:SetTooltip("Scout")
		Wep5.DoClick = function()
			pChoice = WEAPON_5
			Text(p, "Selected Scout!")
		end
		
		
		------ SECONDARY WEAPONS ------
		local label2 = vgui.Create("DLabel", Frame)
		label2:SetPos(20,157) 
		label2:SetColor(Panel_Category) 
		label2:SetFont("WeaponCategory")
		label2:SetText("Secondary") 
		label2:SizeToContents() 
		
		local Wep6 = vgui.Create( "DImageButton", Frame )
		Wep6:SetPos( 15, 190 )                      
		Wep6:SetSize( 64, 64 )       
		Wep6:SetImage( ICON_6 )  
		Wep6:SetTooltip("Five Seven")
		Wep6.DoClick = function()
			sChoice = WEAPON_6
			Text(s, "Selected Five Seven!")
		end
		
		local Wep7 = vgui.Create( "DImageButton", Frame )
		Wep7:SetPos( 85, 190 )                      
		Wep7:SetSize( 64, 64 )       
		Wep7:SetImage( ICON_7 )   
		Wep7:SetTooltip("Glock")
		Wep7.DoClick = function()
			sChoice = WEAPON_7
			Text(s,"Selected Glock!")
		end
		
		local Wep8 = vgui.Create( "DImageButton", Frame )
		Wep8:SetPos( 155, 190 )                      
		Wep8:SetSize( 64, 64 )       
		Wep8:SetImage( ICON_8 )    
		Wep8:SetTooltip("Deagle")
		Wep8.DoClick = function()
			sChoice = WEAPON_8
			Text(s,"Selected Deagle!")
		end
		
		
		------ GRENADES -------
		local label3 = vgui.Create("DLabel", Frame)
		label3:SetPos(275,157) 
		label3:SetColor(Panel_Category) 
		label3:SetFont("WeaponCategory")
		label3:SetText("Grenade") 
		label3:SizeToContents() 
		
		local Wep9 = vgui.Create( "DImageButton", Frame )
		Wep9:SetPos( 270, 190 )                      
		Wep9:SetSize( 64, 64 )       
		Wep9:SetImage( ICON_9 )     
		Wep9:SetTooltip("Incendinary") -- Tool tips are useful here because I dont have icons for the grenades
		Wep9.DoClick = function()
			gChoice = WEAPON_9
			Text(g, "Selected Incendinary Grenade")
		end
		
		local Wep10 = vgui.Create( "DImageButton", Frame )
		Wep10:SetPos( 340, 190 )                      
		Wep10:SetSize( 64, 64 )       
		Wep10:SetImage( ICON_10 )   
		Wep10:SetTooltip("Discombobulator")
		Wep10.DoClick = function()
			gChoice = WEAPON_10
			Text(g,"Selected Discombobulator Grenade!")
		end
		
		local Wep11 = vgui.Create( "DImageButton", Frame )
		Wep11:SetPos( 410, 190 )                      
		Wep11:SetSize( 64, 64 )       
		Wep11:SetImage( ICON_10 ) 
		Wep11:SetTooltip("Smoke")
		Wep11.DoClick = function()
			gChoice = WEAPON_10
			Text(g,"Selected Smoke Grenade!")
		end
	end
	net.Receive( "OpenLoadoutMenu", function( len, ply ) 
		OpenLoadoutMenu()
	end)
end
-- fin
