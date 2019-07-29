local planet={} warptorio.Planets=planet

local resourceTypes={"coal","crude-oil","copper-ore","iron-ore","stone","uranium-ore"}
warptorio.OreTypes=resourceTypes
--["iron-ore"]={size=0},["copper-ore"]={size=0},["coal"]={size=0},["crude-oil"]={size=0},["uranium-ore"}={size=0},["stone"]={size=0}


local czRes={size=0.25,frequency=0.23,richness=0.22}
local czCoal={size=0.275,frequency=0.3,richness=0.23}
local czIron={size=0.25,frequency=0.25,richness=0.23}
local czCopper={size=0.23,frequency=0.23,richness=0.21}
local czUranium={size=0.25,frequency=0.25,richness=0.21}

-- --------
-- Regular Planets

planet.normal={ rng=24, name="A Normal Planet", desc="This world reminds you of home."} -- default

planet.average={ zone=1, rng=17, name="An Average Planet", desc="The usual critters and riches surrounds you, but you feel like something is missing.", -- remove 1-2 resources
	gen={autoplace_controls={}},
	fgen=function(t,b)
		local z,x=table.deepcopy(resourceTypes),{} for i=1,math.random(1,2),1 do local u=math.random(1,#z) x[i]=z[u] table.remove(z,u) end
		for k,v in pairs(x)do t.autoplace_controls[v]={size=0} end
		if(b)then local s=x[1] if(x[2])then s=s .. " and " .. x[2] .. " do" else s=s.. " does" end s=s.." not spawn on this planet"
			game.print(s) end
	end,
	spawn=function(f,b)


	end,
}

planet.dwarf={ zone=12, rng=8, name="A Dwarf Planet", desc="You are like a giant to the creatures of this planet. .. And to its natural resources.", -- half resources
	gen={
		autoplace_controls={["uranium-ore"]=czUranium,["enemy-base"]={frequency=0.5,size=0.5,},
			["iron-ore"]=czIron,["copper-ore"]=czCopper,["coal"]=czCoal,["crude-oil"]=czRes,["stone"]=czRes,
		}
	},
}


-- --------
-- Other Planets

planet.jungle={ zone=15, rng=3, name="A Jungle Planet", desc="These trees might be enough to conceal your location from the natives. .. At least for a while.",
	gen={autoplace_controls={["trees"]={frequency=2.5,size=2.5}}},
	spawn=function(f) f.daytime=math.random(0,1) end
}

planet.barren={ zone=3, rng=4, name="A Barren Planet", desc="This world looks deserted and we appear to be safe. .. For now.",
	warp_multiply=0.25,
	gen={
	starting_area = "none",
	cliff_settings = { cliff_elevation_0 = 1024 },
	default_enable_all_autoplace_controls = false,
	autoplace_settings = {
		decorative = { treat_missing_as_default = false },
		entity = { treat_missing_as_default = false },
		tile = { treat_missing_as_default = false, settings = {}, },
		},
	},
	fgen=function(t,b) local x=t.autoplace_settings.tile.settings local y={frequency="very-low",size=2}
		for i=1,3,1 do x["sand-"..i]=y end
		for i=1,7,1 do x["dirt-"..i]=y end
		x["dry-dirt"]=y  x["sand-decal"]=y x["sand-dune-decal"]=y
		if(b)then end
	end,
	spawn=function(f)
		f.daytime=0
		f.freeze_daytime=1
		f.peaceful_mode=1
		for k,v in pairs(f.find_entities_filtered{type="resource"})do v.destroy() end
	end,
}

planet.water={ zone=7, rng=4, name="An Ocean Planet", desc="There is water all around and seems to go on forever. The nearby fish that greet you fills you with determination.",
	warp_multiply=0.25,
	gen={ starting_area="none",water=999999,default_enable_all_autoplace_controls=false,autoplace_settings={
		tile={treat_missing_as_default=false,settings={["water"]={frequency=5,size=5},["deepwater"]={frequency=5,size=5}}},
		entity={treat_missing_as_default=false,settings={["fish"]={frequency=5,size=5,richness=10}}},decorative = { treat_missing_as_default = false },
	}},
	spawn=function(f) end,
}

planet.rich={ zone=60, rng=2, name="A Rich Planet", desc="A Rich Planet Description",
	warp_multiply=1.5,
	gen={
		autoplace_controls={["iron-ore"]={frequency=4,size=2},["enemy-base"]={frequency=1.25,size=1.25},
			["copper-ore"]={frequency=4,size=2},["coal"]={frequency=4,size=2},["crude-oil"]={frequency=4,size=2},["uranium-ore"]={frequency=4,size=2},["stone"]={frequency=4,size=2},
		},
	},
	spawn=function(f) end,
}

-- --------
-- Resource Specific Planets

planet.copper={ zone=8, rng=5, name="A Copper Planet", desc="The warp reactor surges with power and you feel static in the air. You are filled with determination.",
	warp_multiply=0.5,
	gen={
		autoplace_controls={["copper-ore"]={frequency=4,size=2,richness=1},
			["iron-ore"]=czIron,["coal"]=czCoal,["crude-oil"]=czRes,["uranium-ore"]=czRes,["stone"]=czRes,
		},
	},
	--spawn=function(f) for k,v in pairs(f.find_entities_filtered{type="resource"})do if(v.name~="copper-ore")then v.destroy() end end end
}


planet.iron={ zone=5, rng=5, name="An Iron Planet", desc="You land with a loud metal clang. The sparkle in the ground fills you with determination.",
	gen={
		autoplace_controls={["iron-ore"]={frequency=4,size=2,richness=1},
			["copper-ore"]=czCopper,["coal"]=czCoal,["crude-oil"]=czRes,["uranium-ore"]=czRes,["stone"]=czRes,
		},
	},
	--spawn=function(f) for k,v in pairs(f.find_entities_filtered{type="resource"})do if(v.name~="iron-ore")then v.destroy() end end end,
}

planet.coal={ zone=7, rng=5, name="A Coal Planet", desc="A great jungle once thrived here, many millions of years ago.",
	gen={
		autoplace_controls={["coal"]={frequency=7,size=2},
			["iron-ore"]=czIron,["copper-ore"]=czCopper,["crude-oil"]=czRes,["uranium-ore"]=czRes,["stone"]=czRes
		},
	},
	--spawn=function(f) for k,v in pairs(f.find_entities_filtered{type="resource"})do if(v.name~="coal")then v.destroy() end end end,
}

planet.uranium={ zone=30, rng=5, name="A Uranium Planet", desc="The warmth of this worlds green glow fills you with determination, but you probably shouldn't stay too long",
	gen={
		autoplace_controls={["uranium-ore"]={frequency=8,size=2},["enemy-base"]={frequency=1.5,size=1.5},
			["iron-ore"]=czIron,["copper-ore"]=czCopper,["coal"]=czCoal,["crude-oil"]=czRes,["stone"]=czRes,
		},
	},
	--spawn=function(f) for k,v in pairs(f.find_entities_filtered{type="resource"})do if(v.name~="uranium-ore")then v.destroy() end end end,
}

planet.oil={ zone=10, rng=5, name="An Oil Planet", desc="An Oil Planet Description",
	gen={
		autoplace_controls={["crude-oil"]={frequency=7,size=2},
			["iron-ore"]=czIron,["copper-ore"]=czCopper,["coal"]=cRes,["stone"]=czRes,["uranium-ore"]=czRes
		},
	},
	--spawn=function(f) for k,v in pairs(f.find_entities_filtered{type="resource"})do if(v.name~="crude-oil")then v.destroy() end end end,
}


planet.stone={ zone=15, rng=5, name="A Stone Planet", desc="This planet is like your jouney through warpspacetime. Stuck somewhere between a rock and a hard place.",
	gen={
		autoplace_controls={["stone"]={frequency=8,size=2},
			["iron-ore"]=czIron,["copper-ore"]=czCopper,["coal"]=czCoal,["crude-oil"]=czRes,["uranium-ore"]=czRes,["crude-oil"]=czRes,
		},
	},
	--spawn=function(f) for k,v in pairs(f.find_entities_filtered{type="resource"})do if(v.name~="stone")then v.destroy() end end end,
}


-- --------
-- Biter Planets

planet.polluted={ zone=40,rng=5,name="A Polluted Planet", desc="A heavy aroma of grease and machinery suddenly wafts over the platform and you wonder if you have been here before.",
	warp_multiply=1.5,
	gen={
		autoplace_controls={["enemy-base"]={frequency=1.75,size=1.75},},
	},
	spawn=function(f)
		--f.daytime=0.5
		--f.freeze_daytime=0
		for x=-5,5,1 do for y=-5,5,1 do f.pollute({x*32,y*32},200) end end
	end,
}

planet.midnight={ zone=20,rng=5,name="A Planet Called Midnight", desc="Your hands disappear before your eyes as you are shrouded in darkness. This place seems dangerous.",
	warp_multiply=1.5,
	gen={
		autoplace_controls={["enemy-base"]={frequency=2,size=2}},
	},
	spawn=function(f)
		f.daytime=0.5
		f.freeze_daytime=0
	end,
}


planet.biter={ zone=60,rng=5,name="A Biter Planet", desc="Within moments of warping in, your base is immediately under siege. We must survive until the next warp!",
	warp_multiply=1.5,
	gen={
		starting_area=0.3,
		autoplace_controls={["enemy-base"]={frequency=8,size=8}},
	},
}




for k,v in pairs(planet)do v.key=k end






