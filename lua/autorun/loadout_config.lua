AddCSLuaFile()
---- TTT Weapon Loadouts Configuration ----
-- Author: Exho
WL_dat = "8/18/14"
WL_ver = 1.2

------ CONFIGURATION ------
-- Blacklist
-- Usergroups that are unable to use the loadout menu, "user" or "admin" for example. Leave empty if not used
WL_Blacklist 	= {}
WL_Deny_MSG 	= "Your group cannot use the loadout menu! Sorry :(" -- Blacklist deny message (if used)

-- Loadout panel stuff
WL_Panel_Header 	= Color(34, 42, 60) -- Where it says "Primary", "Secondary", and "Grenade"
WL_Panel_Content 	= Color(44, 62, 80) -- Where the gun icons are located
WL_Panel_Body		= Color(0, 0, 10, 230) -- The actual panel background. Alpha is used in this one only
WL_Panel_Category	= Color(255, 255, 255) -- Category name color
WL_Panel_Title		= "Weapon Loadout Menu" -- Title of the panel

WL_ChatOpen			= "!loadout"  -- Opens the Loadout panel
WL_Panel_Key		= KEY_F6 -- Not used at the moment, soon....

-- Primary
WL_WEAPON_1 	= "weapon_ttt_m16" -- Gun class 
WL_WEAPON_2 	= "weapon_zm_shotgun" 
WL_WEAPON_3		= "weapon_zm_sledge"
WL_WEAPON_4		= "weapon_zm_mac10"
WL_WEAPON_5		= "weapon_zm_rifle"
-- Secondary
WL_WEAPON_6		= "weapon_zm_pistol"
WL_WEAPON_7		= "weapon_ttt_glock"
WL_WEAPON_8		= "weapon_zm_revolver"
-- Grenades
WL_WEAPON_9		= "weapon_zm_molotov"
WL_WEAPON_10	= "weapon_ttt_confgrenade"
WL_WEAPON_11	= "weapon_ttt_smokegrenade"

-- The icons that the grenades currently use as I dont have one. Easily replaceable if you make your own
WL_ICON_INCEN = "vgui/ttt/icon_nades.vtf"
WL_ICON_SMOKE = "vgui/ttt/icon_nades.vtf"
WL_ICON_DISCOM = "vgui/ttt/icon_nades.vtf"

WL_WEPNAMES = {} -- Weapon names, used for tool tips and telling people what their loadout consists of
-- The perks of using variables is that these names are tied to the classes
WL_WEPNAMES[WL_WEAPON_1] = "a M16" 
WL_WEPNAMES[WL_WEAPON_2] = "a Shotgun"
WL_WEPNAMES[WL_WEAPON_3] = "a HUGE"
WL_WEPNAMES[WL_WEAPON_4] = "a Mac10"
WL_WEPNAMES[WL_WEAPON_5] = "a Rifle"
WL_WEPNAMES[WL_WEAPON_6] = "a Pistol"
WL_WEPNAMES[WL_WEAPON_7] = "a Glock"
WL_WEPNAMES[WL_WEAPON_8] = "a Deagle"
WL_WEPNAMES[WL_WEAPON_9] = "a Incendinary Grenade"
WL_WEPNAMES[WL_WEAPON_10] = "a Discombobulator"
WL_WEPNAMES[WL_WEAPON_11] = "a Smoke Grenade"


