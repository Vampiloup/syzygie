-- Function generation of Names for Stars

function StarNameGeneration(id)

	Premiere = {
		"a", "ab", "ad", "ae", "aes", "au", "be","car", "clau", "cen", "con", "dan", "de","dic", "do", "e", "est", "ex", "den", "di", "dis", "duo" ,"ex", "fe", "fi", "foe", "gra", "in", "ma", "me", "men", "mi", "mit", "mo", "mon", "ni",
		 "no", "o", "ob", "pa", "pe", "plu", "pu", "qua", "quam", "re", "rem", "res", "ro", "sa", "san", "sax", "si", "sub", "tan","ter", "tol", "tri", "ui", "ver","vi", "vo"
	}

	Medium = {
		"a", "bi", "ci", "di", "cer", "clu", "de", "e", "el", "er", "fa", "fe", "iu", "la", "le", "li", "ma", "mi", "mit", "mo", "mu", "na", "ne", "ni", "ob", "phan", "qui", "ri", "tin", "vi", "zen"
	}

	Derniere = {
		"a", "bus", "ca", "ce", "cus", "cris", "ctae", "cto", "cus", "cut", "des", "do", "dos", "dus", "e", "er", "est", "hil", "git", "go", "gno", 
		"io", "ior", "ius", "la", "lo", "lus", "ma", "mnes", "mu", "mus", "na", "ne", "no", "num", "nus", "o", "que", "quis", "ra", "re", "rem", "ro", "ros", "sa",
		 "sis","sit", "sor", "sti", "sto", "stris", "strum", "sul", "sum", "tae", "tem", "to", "ter", "tes", "tius", "to", "tor", "tur",
		"tus", "um" ,"us", "va"
	}
	
	
	--voyelles = { "a","e","i","o","u","y","an","en","in","oi","on","ou","au","eau","ay" }
	
	-- consonnes = { "b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","z","br","cr","dr","fr", "gr","mr","nr","pr","sr","tr","vr","bl","cl","fl","gl","pl","sl","tl","ch","ph" }

	-- choose first syllabe

	StarNameGeneration2()

	
	repeat

		local nom_disponible = true
		number2 = StarNameGeneration2()
		-- check if the newly created name is already taken by another star
		if id > 1 then
			for j = 1, id-1 do
				nomJ = lua_lire_systeme(j, "nom")
				if nomJ == number2 then
					nom_disponible = false
				end
			end
		end
	until (nom_disponible == true)


	
	return number2
	
end


function StarNameGeneration2()
	number2 = Premiere[math.random(1,#Premiere)]

	-- choose number of middle syllages (can be 0 to 2)
	number = math.random(0,2)
	-- Choose "number" middle syllabes
	for i = 1, number do
		number2 = number2 .. Medium[math.random(1,#Medium)]
	end

	-- Choose last syllabe
	number2 = number2 .. Derniere[math.random(1,#Derniere)]
	return number2
end


