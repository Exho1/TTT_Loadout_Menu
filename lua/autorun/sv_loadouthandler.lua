---- TTT Weapon Loadouts Serverside ----
-- Author: Exho

if SERVER then -- Our serverside stuff
	util.AddNetworkString( "loadout_openmenu" )
	util.AddNetworkString( "loadout_submit" )
	util.AddNetworkString( "loadout_echo" )
	util.AddNetworkString( "loadout_received" )
	
	net.Receive( "loadout_submit", function( len, ply )
		local tbl = net.ReadTable()
		
		if not tbl then
			ply:SetPData("TTTLoadoutOn", "false") 
			return
		end
		
		ply:SetPData("TTTLoadoutOn", "true") -- PData persists so we use it for a more permanent approach
		ply:SetPData("TTTPrimary", tbl.primary or "")
		ply:SetPData("TTTSecondary", tbl.secondary or "")
		ply:SetPData("TTTGrenade", tbl.grenade or "")
	end )
	
	hook.Add( "TTTBeginRound", "loadout_distribute", function()
		for k, ply in pairs( player.GetAll() ) do 
			-- Checks if the player has loadouts enabled
			if ply:GetPData("TTTLoadoutOn", "false") == "true" and IsValid(ply) and ply:IsTerror() and not ply:IsSpec() and ply:canUseLoadout() then 
				-- Grab the loadouts from PData
				local p = ply:GetPData("TTTPrimary", "")
				local s = ply:GetPData("TTTSecondary", "")
				local g = ply:GetPData("TTTGrenade", "")
			
				print(ply:Nick().." has been given a loadout!")
					
				for _, wep in pairs(ply:GetWeapons()) do
					if wep.Kind == WEAPON_HEAVY and p then
						ply:StripWeapon(wep:GetClass())
						ply:Give( p )
					end
					if wep.Kind == WEAPON_PISTOL and s then
						ply:StripWeapon(wep:GetClass())
						ply:Give( s )
					end
					if wep.Kind == WEAPON_NADE and g then
						ply:StripWeapon(wep:GetClass())
						ply:Give( g )
					end
				end
				
				net.Start("loadout_received")
				net.Send(ply)
			end
		end
	end)
	
	--// Opens the loadout menu 
	hook.Add( "PlayerSay", "loadout_chatcommand", function(ply, text, public)
		local text = string.lower(text)
		if text:lower() == loadout.chatCommand:lower() then
			net.Start("loadout_openmenu")
			net.Send(ply)
		end
	end)
	
	--// Tells the player what their loadout is
	hook.Add( "PlayerSay", "loadout_weaponprint", function(ply, text, public)
		local text = string.lower(text) 
		if text:lower() == "!loadoutprint" then
			local p = ply:GetPData("TTTPrimary", "none") 
			local s = ply:GetPData("TTTSecondary", "none")
			local g = ply:GetPData("TTTGrenade", "none")
			local tab = {p,s,g}
			
			net.Start("loadout_echo")
				net.WriteTable(tab)
			net.Send(ply)
			
			return false
		end
	end)
end

