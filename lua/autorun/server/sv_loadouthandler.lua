util.AddNetworkString("LoadoutSubmit")
util.AddNetworkString("LoadoutPrint")
util.AddNetworkString("LoadoutReceived")
util.AddNetworkString("OpenLoadoutMenu")
util.AddNetworkString("LoadoutDisable")

local function CanUseLoadout(ply)
	if (#WL.Blacklist == 0) then return true end
	
	local group = ply:GetUserGroup()

	if (table.HasValue(WL.Blacklist, group)) then return false end
	
	return true
end

hook.Add("Initialize", "AddIcons", function()
	for k,v in pairs(WL.Weapons) do
		if (!v.Icon) then continue end
		
		resource.AddFile(v.Icon)
	end
end)

loadouts = loadouts or {}

net.Receive("LoadoutSubmit", function(l, ply) 
	if (!CanUseLoadout(ply)) then return; end

	local p = net.ReadString()
	local s = net.ReadString()
	local g = net.ReadString()
	local e = true

	loadouts[ply:SteamID()] = {
		primary = p;
		secondary = s;
		grenade = g;
		enabled = e;
	}

	ply:SetNWString("TTTPrimary", p)
	ply:SetNWString("TTTSecondary", s)
	ply:SetNWString("TTTGrenade", g)

	ply:SetPData("TTTLoadoutEnabled", e)
	ply:SetPData("TTTLoadoutPrimary", p)
	ply:SetPData("TTTLoadoutSecondary", s)
	ply:SetPData("TTTLoadoutGrenade", g)
end)

net.Receive("LoadoutDisable", function(l, ply)
	local loadout = loadouts[ply:SteamID()]
	if (!loadout) then return; end
	
	loadouts[ply:SteamID()].enabled = false
end)

hook.Add("TTTBeginRound", "GiveLoadouts", function()
	if (!loadouts) then return; end
	
	for k,v in pairs(player.GetAll()) do
		local loadout = loadouts[v:SteamID()]
		if (!loadout or !tobool(loadout.enabled)) then continue; end
		
		if (v:IsSpec() or !v:Alive() or !CanUseLoadout(v)) then continue; end

		v:Give(loadout.primary)
		v:Give(loadout.secondary)
		v:Give(loadout.grenade)

		net.Start("LoadoutReceived")
		net.Send(v)
	end
end)

hook.Add("PlayerInitialSpawn", "CacheLoadout", function(ply)
	local p = ply:GetPData("TTTLoadoutPrimary", "")
	local s = ply:GetPData("TTTLoadoutSecondary", "")
	local g = ply:GetPData("TTTLoadoutGrenade", "")
	local e = ply:GetPData("TTTLoadoutEnabled", false)

	ply:SetNWString("TTTPrimary", p)
	ply:SetNWString("TTTSecondary", s)
	ply:SetNWString("TTTGrenade", g)

	loadouts[ply:SteamID()] = {
		primary = p;
		secondary = s;
		grenade = g;
		enabled = e;
	}

	print("Loadout loaded: "..ply:Nick())
end)

hook.Add("PlayerSay", "Print-OpenWL", function(ply, text) 
	local txt = string.lower(text)

	if (txt == WL.ChatCommand) then 

		net.Start("OpenLoadoutMenu")
		net.Send(ply)

		return "" 
	end
	if (txt == WL.PrintLoadout) then

		local tab = loadouts[ply:SteamID()]
		if (!tab) then return "" end


		net.Start("LoadoutPrint")
			net.WriteString(tab.primary)
			net.WriteString(tab.secondary)
			net.WriteString(tab.grenade)
		net.Send(ply)

		return "" 
	end
	if (txt == WL.PrintVersion) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "WL VERSION: "..WL.Version.."( "..WL.VersionDate.." )")
		
		return ""
	end
end)

