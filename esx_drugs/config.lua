Config              = {}
Config.MarkerType   = 1
Config.DrawDistance = 25.0
Config.ZoneSize     = {x = 2.8, y = 2.8, z = 1.0}
Config.MarkerColor  = {r = 0, g = 255, b = 0}
Config.ShowBlips   = false  --markers visible on the map? (false to hide the markers on the map)

Config.RequiredCopsCoke  = 0
Config.RequiredCopsMeth  = 0
Config.RequiredCopsWeed  = 0
Config.RequiredCopsOpium = 0
Config.RequiredCopsAmfa = 0

Config.TimeToFarm    = 1200
Config.TimeToProcess = 1200
Config.TimeToSell    = 150

Config.Locale = 'en'

Config.Zones = {
	CokeField =		{x = -448.66,	y = 1597.08,	z = 358.09,	name = _U('coke_field'),		sprite = 503,	color = 40}, -----Zrobione
	CokeProcessing =	{x = 2708.05,     y = 1532.5,   z = 20.02,	name = _U('coke_processing'),	        sprite = 245,	color = 40}, ----Zrobione
	---CokeDealer =		{x = 451.21,	y = -3101.52,	z = 6.07,	name = _U('coke_dealer'),		sprite = 500,	color = 75},
   MethField =	        {x = 2329.89,	y = 2571.66,	z = 46.0,	name = _U('meth_field'),		sprite = 499,	color = 26}, ----Zrobione
   MethProcessing =	{x = 2434.23,	y = 4968.68,	z = 41.34,	name = _U('meth_processing'),	        sprite = 499,	color = 26}, --- Zrobione
 	---MethDealer =		{x = -3183.29,	y = 1246.20,	z = 6.44,	name = _U('meth_dealer'),		sprite = 500,	color = 75},
	WeedField =		{x = 2222.41,	y = 5577.0,	z = 53.83,	name = _U('weed_field'),		sprite = 496,	color = 52}, --- Zrobione
	WeedProcessing =	{x = -1128.83,	y = 2691.98,	z = 18.70,	name = _U('weed_processing'),	        sprite = 496,	color = 52},  -----Zrobione
	---WeedDealer =		{x = 5454.20,	y = 5454.20,	z = 49.0,	name = _U('weed_dealer'),		sprite = 500,	color = 75},
	OpiumField =		{x = 3303.14,	y = 5199.32,	z = 18.0,	name = _U('opium_field'),		sprite = 51,	color = 60}, -------Zrobione
	OpiumProcessing =	{x = 229.3,	y = -3284.25,	z = 40.10,     name = _U('opium_processing'),	        sprite = 51,	color = 60}, -------Zrobione
    AmfaField =         {x = 2658.79,    y = 2890.46,    z = 36.10,    name = _U('amfa_field'),        sprite = 51,    color = 60},
	AmfaProcessing =	{x = 1198.6,	y = -3119.87,	z = 5.10,     name = _U('amfa_processing'),	        sprite = 51,	color = 60}, -------Zrobione
}