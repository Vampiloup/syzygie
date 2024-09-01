-- Preparing solar systemstable
function lua_prepare()

	-- Initialize gui system page variables
	Gui_systeme = {etoile_clicked = 0, orbite_clicked = 0}
	
	-- zoom start
	zoom_state = 0
	-- zoom gap 
	zoom_gap = 1.1
	-- zoom minimum
	zoom_min = -20
	-- zoom maximum
	zoom_max = 20

	-- Double click delay
	dbl_click_delay = 0.3
	
	-- Variable used for tell if the game creation is finished.
	creation_finished = false

	
	-- Size of the game screen
	screen_X = sys.get_config_int("display.width")
	screen_Y = sys.get_config_int("display.height")


	-- Create systems map
	systeme = {}

	-- Number of star Systems
	map_size = {
		{nom = "minuscule", map_X = 1000, map_Y = 1000},
		{nom = "petite", map_X = 1500, map_Y = 1500},
		{nom = "medium", map_X = 2000, map_Y = 2000},
		{nom = "grande", map_X = 2500, map_Y = 2500},
		{nom = "geante", map_X = 3500, map_Y = 3500},
		{nom = "immense", map_X = 5000, map_Y = 5000}
	}

	map_density = {
		{nom = "épars", density = 0.5},
		{nom = "clairsemé", density = 0.75},
		{nom = "medium", density = 1},
		{nom = "dense", density = 1.5},
		{nom = "compact", density = 1.2}
	}

	-- default map characteristics
	map_size_tmp = 3
	map_density_tmp = 3

	map_X = map_size[map_size_tmp]["map_X"]
	map_Y = map_size[map_size_tmp]["map_Y"]
	
	-- Number of stars
	Nombre_Etoiles = ((map_X * map_Y) / 4000000) * 100 * map_density[map_density_tmp]["density"]
	
	-- Global variable : Is cursor on top of Gui or not ?
	-- Changed in on_input by Systeme.gui_script.
	-- Generaly, don't let curseur.script activate on_input actions, since there is a Gui element on top of it.
	Gui_entered = nil

	-- create table with colour of stars. First is the internal name (code), second is the name as displayed
	liste_etoiles = {"rouge","orange","jaune","blanc","cyan","bleu","violet"}
	liste_etoiles_nom = {"Red","Orange","Yellow","White","Cyan","Blue","Violet"}
	
		-- number of Orbits by system
	Systeme_Orbits = 5

	-- Size of Objects orbiting a Star
	-- liste_orbitals = {[0] = 4}
	liste_orbitals = {}
	table.insert(liste_orbitals, 1, {chance = 50, nom = "", taille = {}})
	-- Rock planets
	table.insert(liste_orbitals, 2, {chance = 20 ,nom = "Rock planet",taille={"minuscule", "petite", "medium", "grande", "enorme"}})
	-- Gaz planets
	table.insert(liste_orbitals, 3, {chance = 15 ,nom = "Gaz planet", taille={"methane", "medium", "large", "giga"}})
	-- Asteroids
	table.insert(liste_orbitals, 4, {chance = 10 ,nom = "Asteroids", taille={"asteroids group", "small asteroids field", "medium asteroids field", "large asteroids field"}})

	-- Total chance to have an Object at a Star's orbit
	total_orbit_chance = {}
	toc = 0
	for i = 1, #liste_orbitals do
		toc = toc + liste_orbitals[i]["chance"]
		table.insert (total_orbit_chance, i, toc)
	end
	total_orbit_chance[0] = toc

	-- Temp orbit according to star colour
	couleur_temp = {}
	table.insert(couleur_temp, 1, {chaud = 1})
	table.insert(couleur_temp, 2, {chaud = 2})
	table.insert(couleur_temp, 3, {chaud = 3})
	table.insert(couleur_temp, 4, {chaud = 4})
	table.insert(couleur_temp, 5, {chaud = 5})
	table.insert(couleur_temp, 6, {chaud = 6})
	table.insert(couleur_temp, 7, {chaud = 7})
	couleur_temp[0] = {nom={"hot","moderate","cold"}}

	-- Wetness (!) of orbit (planet)
	lua_SV_wetness_orbit = {nom = {"dry","aride","wet","aquatic"}, nb_zones_water = {{1,1,1},{2,1,1},{2,2,1},{2,2,2}}}

	-- Zones climatiques (land / sea / orbit)
	lua_zone_climatique = {
		{"default_espace","default_espace","default_espace","default_espace"},
		{"default_ground", "default_sea", "default_orbit"},
		{},
		{"default_asteroid", "default_asteroid", "default_asteroid", "default_asteroid"}
	}

	
	
end

-- Enter data in the Solar System table. id is the System number, message_is the name of the data, messsage its value
function lua_ecrire_systeme(id, message_id, message)

	if systeme[id] then
			systeme[id][message_id] = message
	else
		table.insert(systeme, id, {[message_id] = message})
	end
	
end

-- read and send back a value in the Solar System table. message_id is the name of the data wanted.
function lua_lire_systeme(id, message_id,message2)

	if systeme[id] then
		if message2 == nil then
			return systeme[id][message_id]
		else
			return systeme[id][message_id][message2]
		end
	else
		print ("systeme[".. id .."] not exists")
	end
	
end

-- convert Screen to world coordinates ( https://defold.com/examples/render/screen_to_world/ )
function screen_to_world(x, y, z)

	local projection = go.get("/camera#camera", "projection")
	local view = go.get("/camera#camera", "view")
	local w, h = window.get_size()
	-- The window.get_size() function will return the scaled window size,
	-- ie taking into account display scaling (Retina screens on macOS for
	-- instance). We need to adjust for display scaling in our calculation.
	w = w / (w / screen_X)
	h = h / (h / screen_Y)

	-- https://defold.com/manuals/camera/#converting-mouse-to-world-coordinates
	local inv = vmath.inv(projection * view)
	x = (2 * x / w) - 1
	y = (2 * y / h) - 1
	z = (2 * z) - 1
	local x1 = x * inv.m00 + y * inv.m01 + z * inv.m02 + inv.m03
	local y1 = x * inv.m10 + y * inv.m11 + z * inv.m12 + inv.m13
	local z1 = x * inv.m20 + y * inv.m21 + z * inv.m22 + inv.m23
	return x1, y1, z1
end


-- Distance between two objects
function dist_xy(x1,y1, x2,y2)
	local x = ((x2-x1)^2+(y2-y1)^2)^0.5
	return x
end