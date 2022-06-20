[url=https://steamcommunity.com/sharedfiles/filedetails/?id=301839781]Original[/url] by [url=https://steamcommunity.com/profiles/76561198066930384]Exho[/url]

Modified loadout_config.lua to also show Weapons from the follwoing addons:

[list]
[*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=307400737] TTT Rifle Pack[/url]

[*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=307400139] TTT Assault Pack[/url]

[*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=316433211] TTT Assault Pack 2[/url]

[*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=307345118] TTT Shotgun Pack[/url]

[*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=307401169] TTT Pistol Pack[/url]
[/list]

For correct use all previously mentioned Addons are required. These can be downloaded [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2823275528]HERE[/url] as a collection. CS:S is required for the hands.

[h1]USAGE[/h1]
Open  loadout menu:

[table]
    [tr]
        [td]Chat[/td]
        [td][i]!Loadout[/i][/td]
    [/tr]
    [tr]
        [td]Button[/td]
        [td][i]F6[/i][/td]
    [/tr]
    [tr]
        [td]Console[/td]
        [td][i]wl_open[/i][/td]
    [/tr]
[/table]

Print current loadout:

[table]
    [tr]
        [td]Chat[/td]
        [td][i]!LoadoutPrint [/i][/td]
    [/tr]
[/table]


[url=https://github.com/RIPD/TTT_Loadout_Menu] My fork on github[/url]


[hr][/hr]

[b]Original description[/b]


Finding weapons takes too much effort!

*** Info:
My take on the popular Coderhire addon because recreating Coderhire stuff is fun and its always nice to have a free alternative! Basically it works by typing a chat command to open the menu, selecting which guns you want, and hitting "Submit" and bam! Now you have a loadout that you recieve at the start of each round. Loadouts can be configured to work only for certain usergroups so you could make it donator only. You can also disable your loadouts by hiting the Disable button in the panel.

*** Config:
* Chat - !Loadout - Opens the loadout menu if you are in the correct group!
* Chat - !LoadoutPrint - Prints in chat what your current loadout consists of.
* Console - wl_open - Does the same thing as !LoadOut.
* All configuration has to be handled within the Lua file. This includes the blacklist, panel colors, and messages. You can extract it with GMAD extractor.

Github: https://github.com/Exho1/TTT_Loadout_Menu

If you have any errors or problems, I am willing to help as long as you are respectful and specific with your issue.