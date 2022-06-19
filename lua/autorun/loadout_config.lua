----// TTT Loadout Menu //----
-- Author: Exho
-- Modified by: RIPD

AddCSLuaFile()

loadout = {}
loadout.version = "7/12/15"

-- Usergroups that are allowed to use the loadout menu, if you want all usergroups to be able to use it then leave the table empty/blank
loadout.whitelist = {}
loadout.denyMsg = "Your usergroup is unable to use the loadout menu!"

loadout.chatCommand = "!loadout"
loadout.keyBind = KEY_F6

-- Primary weapons. Format: Name = Class
loadout.primary = {
	["M16"] = "weapon_ttt_m16",
	["Shotgun"] = "weapon_zm_shotgun",
	["HUGE"] = "weapon_zm_sledge",
	["Mac10"] = "weapon_zm_mac10",
	["Scout"] = "weapon_zm_rifle",
	["MR-CA1"] = "weapon_ap_mrca1", --TTT Assault Pack 2 id=316433211
	["TEC-9"] = "weapon_ap_tec9",
	["Vector"] = "weapon_ap_vector",
	["Honey Badger"] = "weapon_ap_hbadger", --TTT Assault Pack id=307400139
	["PP19"] = "weapon_ap_pp19",
	["Double Barrel"] = "weapon_sp_dbarrel", --TTT Shotgun Pack id=307345118
	["Striker 12"] = "weapon_sp_striker",
	["Winchester"] = "weapon_sp_winchester",
}

-- Secondary weapons. Format: Name = Class
loadout.secondary = {
	["Five Seven"] = "weapon_zm_pistol",
	["Glock"] = "weapon_ttt_glock",
	["Deagle"] = "weapon_zm_revolver",
	["Raging Bull"] = "weapon_pp_rbull", --TTT Pistol Pack id=307401169
	["Remington"] = "weapon_pp_remington",
	["Pocket Rifle"] = "weapon_rp_pocket", --TTT Rifle Pack id=307400737
}

-- Extra weapons. Format: Name = Class
loadout.grenades = {
	["Incendinary"] = "weapon_zm_molotov",
	["Discombobulator"] = "weapon_ttt_confgrenade",
	["Smoke"] = "weapon_ttt_smokegrenade",
}

-- Weapon icons. Format: Class = Path to material
loadout.icons = {
	["weapon_ttt_m16"] = "vgui/ttt/icon_m16",
	["weapon_zm_shotgun"] = "vgui/ttt/icon_shotgun",
	["weapon_zm_sledge"] = "vgui/ttt/icon_m249",
	["weapon_zm_mac10"] = "vgui/ttt/icon_mac",
	["weapon_zm_rifle"] = "vgui/ttt/icon_scout",
	["weapon_zm_pistol"] = "vgui/ttt/icon_pistol",
	["weapon_ttt_glock"] = "vgui/ttt/icon_glock",
	["weapon_zm_revolver"] = "vgui/ttt/icon_deagle",
	["weapon_ap_mrca1"] = "vgui/ttt/lykrast/icon_ap_mrca1", --TTT Assault Pack 2 id=316433211
	["weapon_ap_tec9"] = "vgui/ttt/lykrast/icon_ap_tec9",
	["weapon_ap_vector"] = "vgui/ttt/lykrast/icon_ap_vector",
	["weapon_ap_hbadger"] = "vgui/ttt/lykrast/icon_ap_hbadger", --TTT Assault Pack id=307400139
	["weapon_ap_pp19"] = "vgui/ttt/lykrast/icon_ap_pp19.vtf",
	["weapon_pp_rbull"] = "vgui/ttt/lykrast/icon_pp_rbull", --TTT Pistol Pack id=307401169
	["weapon_pp_remington"] = "vgui/ttt/lykrast/icon_pp_remington",
	["weapon_rp_pocket"] = "vgui/ttt/lykrast/icon_rp_pocket.vmt", --TTT Rifle Pack id=307400737
	["weapon_sp_dbarrel"] = "vgui/ttt/lykrast/icon_sp_dbarrel", --TTT Shotgun Pack id=307345118
	["weapon_sp_striker"] = "vgui/ttt/lykrast/icon_sp_striker",
	["weapon_sp_winchester"] = "vgui/ttt/lykrast/icon_sp_winchester",

}

local plymeta = FindMetaTable( "Player" )

--// Shared meta function 
function plymeta:canUseLoadout() 
	if #loadout.whitelist == 0 then return true end -- No groups on the whitelist
	
	local curgroup = self:GetUserGroup()
	for k, group in pairs(loadout.whitelist) do
		if string.lower(curgroup) == string.lower(group) then
			return true
		end
	end
	return false
end

