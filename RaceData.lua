if AZP == nil then AZP = {} end
if AZP.DragonRider == nil then AZP.DragonRider = {} end

AZP.DragonRider.RaceData =
{
    [2022] = -- The Waking Shores
    {
        Normal =
        {
            [1] = {ID = 2042, Silver = 56, Gold = 53, Name =  "Ruby Lifeshrine Loop"},
            [2] = {ID = 2048, Silver = 45, Gold = 42, Name =  "Wild Preserve Slalom"},
            [3] = {ID = 2052, Silver = 53, Gold = 50, Name =      "Emberflow Flight"},
            [4] = {ID = 2054, Silver = 43, Gold = 40, Name =       "Apex Canopy Run"},
            [5] = {ID = 2056, Silver = 49, Gold = 44, Name =       "Uktulut Coaster"},
            [6] = {ID = 2058, Silver = 56, Gold = 53, Name =   "Wingrest Roundabout"},
            [7] = {ID = 2046, Silver = 66, Gold = 63, Name =    "Flashfrost Flyover"},
            [8] = {ID = 2050, Silver = 43, Gold = 40, Name = "Wild Preserve Circuit"},
        },
        Advanced =
        {
            [1] = {ID = 2044, Silver = 62, Gold = 59, Name =  "Ruby Lifeshrine Loop"},
            [2] = {ID = 2049, Silver = 50, Gold = 47, Name =  "Wild Preserve Slalom"},
            [3] = {ID = 2053, Silver = 55, Gold = 52, Name =      "Emberflow Flight"},
            [4] = {ID = 2055, Silver = 55, Gold = 52, Name =       "Apex Canopy Run"},
            [5] = {ID = 2057, Silver = 48, Gold = 45, Name =       "Uktulut Coaster"},
            [6] = {ID = 2059, Silver = 60, Gold = 57, Name =   "Wingrest Roundabout"},
            [7] = {ID = 2047, Silver = 72, Gold = 69, Name =    "Flashfrost Flyover"},
            [8] = {ID = 2051, Silver = 46, Gold = 43, Name = "Wild Preserve Circuit"},
        },
    },
    -- [2023] = -- Ohn'Ahran Plains
    -- {

    -- },
    -- [2024] = -- Azure Span
    -- {

    -- },
    -- [2025] = -- Thaldraszus
    -- {

    -- },
}

AZP.DragonRider.RaceQuestIDs =
{
    [66679] = AZP.DragonRider.RaceData[2022].Normal[1],
    [66732] = AZP.DragonRider.RaceData[2022].Normal[4],
    [66777] = AZP.DragonRider.RaceData[2022].Normal[5],
    [66710] = AZP.DragonRider.RaceData[2022].Normal[7],

    [66692] = AZP.DragonRider.RaceData[2022].Advanced[1],
    [66733] = AZP.DragonRider.RaceData[2022].Advanced[4],
    [66778] = AZP.DragonRider.RaceData[2022].Advanced[5],
    [66712] = AZP.DragonRider.RaceData[2022].Advanced[7],
}

TempDataGathering = {
	[66732] = {
		["Name"] = "Apex Canopy River Run",
		["Silver"] = 43,
		["Gold"] = 40,
	},
	[66733] = {
		["Name"] = "Apex Canopy River Run - Advanced",
		["Silver"] = 55,
		["Gold"] = 52,
	},
	[66778] = {
		["Name"] = "Uktulut Coaster - Advanced",
		["Silver"] = 48,
		["Gold"] = 45,
	},
	[66777] = {
		["Name"] = "Uktulut Coaster",
		["Silver"] = 49,
		["Gold"] = 44,
	},
	[66946] = {
		["Silver"] = 51,
		["Name"] = "Azure Span Sprint",
		["Gold"] = 48,
	},
	[66722] = {
		["Silver"] = 45,
		["Name"] = "Wild Preserve Slalom - Advanced",
		["Gold"] = 42,
	},
	[66726] = {
		["Name"] = "Wild Preserve Circuit - Advanced",
		["Silver"] = 66,
		["Gold"] = 63,
	},
	[66727] = {
		["Name"] = "Emberflow Flight",
		["Silver"] = 50,
		["Gold"] = 45,
	},
	[66725] = {
		["Silver"] = 43,
		["Name"] = "Wild Preserve Circuit",
		["Gold"] = 38,
	},
	[66786] = {
		["Name"] = "Wingrest Roundabout",
		["Silver"] = 45,
		["Gold"] = 40,
	},
	[66787] = {
		["Name"] = "Wingrest Roundabout - Advanced",
		["Silver"] = 56,
		["Gold"] = 53,
	},
	[66728] = {
		["Name"] = "Emberflow Flight - Advanced",
		["Silver"] = 53,
		["Gold"] = 50,
	},
	[66877] = {
		["Silver"] = 66,
		["Name"] = "Fen Flythrough",
		["Gold"] = 63,
	},
	[70161] = {
		["Silver"] = 66,
		["Name"] = "Caverns Criss-Cross",
		["Gold"] = 63,
	},
	[66710] = {
		["Name"] = "Flashfrost Flyover",
		["Silver"] = 66,
		["Gold"] = 63,
	},
	[66721] = {
		["Silver"] = 58,
		["Name"] = "Wild Preserve Slalom",
		["Gold"] = 53,
	},
}