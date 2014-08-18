---- TTT Weapon Loadouts Serverside ----
-- Author: Exho


function CanUseLoadout(ply) -- Function to make life easier
	local Blacklist = WL_Blacklist
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
	util.AddNetworkString( "LoadoutGiven" )
	-- Adding all the icons
	resource.AddFile("vgui/ttt/icon_m16.vmt")
	resource.AddFile("vgui/ttt/icon_glock.vmt")
	resource.AddFile("vgui/ttt/icon_m249.vmt")
	resource.AddFile("vgui/ttt/icon_mac.vmt")
	resource.AddFile("vgui/ttt/icon_pistol.vmt")
	resource.AddFile("vgui/ttt/icon_scout.vmt")
	resource.AddFile("vgui/ttt/icon_shotgun.vmt")
	resource.AddFile("vgui/ttt/icon_deagle.vmt")
	resource.AddFile("vgui/ttt/icon_nades.vmt") -- If you do add new grenade icons, change this
	
	Loadouts = Loadouts or {}
	
	net.Receive( "LoadoutSubmit", function( len, ply )
		-- Serverside grabbing of the loadout data after its been submitted from the client
		local tab = net.ReadTable()
		print("Recieved new loadout from "..ply:Nick()) -- Recordkeeping in console
		Loadouts[ply:SteamID()] = { primary = tab.primary, secondary = tab.secondary, grenade = tab.grenade }
		ply:SetPData("TTTLoadoutOn", "true") -- PData persists so we use it for a more permanent approach
		ply:SetPData("TTTPrimary", tab.primary)
		ply:SetPData("TTTSecondary", tab.secondary)
		ply:SetPData("TTTGrenade", tab.grenade)
	end )
	
	hook.Add( "TTTBeginRound", "LetThereBeLOADOUTS", function()
		print("**Giving loadouts...**")
		Loadouts = Loadouts or {} -- This is redundant but it scares me not to have it
		for k,v in pairs(player.GetAll()) do
			if v:GetPData("TTTLoadoutOn", "false") == "true" then 
				-- Pulls PData to use in case the player does not exist in the local table
				local p = v:GetPData("TTTPrimary", "")
				local s = v:GetPData("TTTSecondary", "")
				local g = v:GetPData("TTTGrenade", "")
				Loadouts[v:SteamID()] = { primary = p, secondary = s, grenade = g }
			end
			for key, value in pairs(Loadouts) do -- Now we check each player to the current loadout table
				if v:SteamID() == key then -- The player is on the loadout table 
					if v:IsSpec() or not v:Alive() then return end -- Only give to the living
					if not CanUseLoadout(v) then return end
					print(v:Nick().." has recieved their loadout!")
					-- Gives the loadout. Funny enough, this was the easiest part of the entire project...
					local weps = value
					v:Give(weps.primary)
					v:Give(weps.secondary)
					v:Give(weps.grenade)
					net.Start("LoadoutGiven")
					net.Send(v)
				end
			end
		end
		print("**Loadouts finished!**") -- Recordkeeping in console
	end)
	
	hook.Add( "PlayerSay", "OpenSesame", function(ply, text, public)
		local text = string.lower(text) -- Chat command to open the menu
		if (string.sub(text, 1, 8) == string.lower(WL_ChatOpen)) then
			ply:ConCommand("wl_open")
		end
	end)
	hook.Add( "PlayerSay", "PrintSoHard", function(ply, text, public)
		local text = string.lower(text) -- Chat command to tell the player what their current loadout is
		if (string.sub(text, 1, 13) == "!loadoutprint") then
			ply:ConCommand("wl_print")
			return false
		end
	end)
	
	concommand.Add( "wl_open", function(ply)
		-- The console command it uses
		net.Start("OpenLoadoutMenu")
		net.Send(ply)
	end )
	concommand.Add( "wl_version", function(ply)
		-- Just cause I like to be able to tell what version a server is running
		print(ply:Nick().." requested version")
		ply:PrintMessage( HUD_PRINTCONSOLE, "**** Exho's Weapon Loadout Addon ****" )
		ply:PrintMessage( HUD_PRINTCONSOLE, "Version "..WL_ver..". Last edited on "..WL_dat)
		ply:PrintMessage( HUD_PRINTCONSOLE, "**** Contact at STEAM_0:0:53332328 ****" )
	end )
	concommand.Add( "wl_print", function(ply)
		local p = ply:GetPData("TTTPrimary", "none") -- I wonder if grabbing Pdata this much is bad...
		local s = ply:GetPData("TTTSecondary", "none")
		local g = ply:GetPData("TTTGrenade", "none")
		local tab = {p,s,g}
		net.Start("LoadoutPrint")
			net.WriteTable(tab) -- Sends the weapon table to the player
		net.Send(ply)
	end)
end

