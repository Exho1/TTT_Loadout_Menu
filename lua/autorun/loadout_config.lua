WL = WL or {}
WL.Colors = WL.Colors or {}
WL.Weapons = WL.Weapons or {}

WL.Version = "1.2"
WL.VersionDate = "8/18/14"

WL.Blacklist = {}
WL.DenyMessage = "Sorry, but your group does not have access to this!"

WL.Colors.TextHeadings = Color(34, 42, 60)
WL.Colors.Content      = Color(44, 62, 80)
WL.Colors.Body         = Color(0, 0, 10, 230)
WL.Colors.Category     = Color(255, 255, 255)
WL.Colors.Title        = "Weapon Loadout Menu"
WL.Colors.ActiveOutline = Color(255, 255, 255)

WL.ChatCommand = "!loadout"
WL.PrintLoadout = "!pl"
WL.PrintVersion = "!wlv"

WL.Weapons["weapon_ttt_m16"] = {
	Name = "M16";
	Class = "primary";
	Icon = "vgui/ttt/icon_m16.vtf";
}
WL.Weapons["weapon_zm_shotgun"] = {
	Name = "Shotgun";
	Class = "primary";
	Icon = "vgui/ttt/icon_shotgun.vtf";
}
WL.Weapons["weapon_zm_sledge"] = {
	Name = "HUGE";
	Class = "primary";
	Icon = "vgui/ttt/icon_m249.vtf";
}
WL.Weapons["weapon_zm_mac10"] = {
	Name = "Mac10";
	Class = "primary";
	Icon = "vgui/ttt/icon_mac.vtf";
}
WL.Weapons["weapon_zm_rifle"] = {
	Name = "Rifle";
	Class = "primary";
	Icon = "vgui/ttt/icon_scout.vtf";
}

WL.Weapons["weapon_zm_pistol"] = {
	Name = "Pistol";
	Class = "secondary";
	Icon = "vgui/ttt/icon_pistol.vtf";
}
WL.Weapons["weapon_ttt_glock"] = {
	Name = "Glock";
	Class = "secondary";
	Icon = "vgui/ttt/icon_glock.vtf";
}
WL.Weapons["weapon_zm_revolver"] = {
	Name = "Revolver";
	Class = "secondary";
	Icon = "vgui/ttt/icon_deagle.vtf";
}

WL.Weapons["weapon_zm_molotov"] = {
	Name = "Incendinary Grenade";
	Class = "grenade";
	Icon = "vgui/ttt/icon_nades.vtf";
}
WL.Weapons["weapon_ttt_confgrenade"] = {
	Name = "Discombobulator";
	Class = "grenade";
	Icon = "vgui/ttt/icon_nades.vtf";
}
WL.Weapons["weapon_ttt_smokegrenade"] = {
	Name = "Smoke Grenade";
	Class = "grenade";
	Icon = "vgui/ttt/icon_nades.vtf";
}
