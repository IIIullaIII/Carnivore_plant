minetest.register_abm({
	nodenames = {"mobu:UOlola_spawner"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		minetest.set_node(pos, {name = "mobu:UOlola2",param2=math.random(0,3)})
		minetest.env:get_node_timer(pos):start(3)
	end,
})
minetest.register_node("mobu:UOlola_spawner", {
	description = "UOlola spwner",
	drawtype="airlike",
	groups = {not_in_creative_inventory=1},
})

minetest.register_node("mobu:UOlola", {
	description = "UOlola",
	groups = {choppy = 1},
	tiles = {"uolola1.png"},
	drawtype="mesh",
	mesh="uolola.obj",
	paramtype="light",
	paramtype2="facedir",
	walkable=false,
    
	--sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.4, 0, 0.5}
	},
	on_construct = function(pos)
		minetest.env:get_node_timer(pos):start(3)
	end,
	on_timer = function (pos, elapsed)
		local a=0
		for i, ob in pairs(minetest.get_objects_inside_radius(pos, 1.5)) do
			minetest.sound_play("morso", {pos=pos,max_hear_distance = 10, gain = 0.5})
			ob:moveto({x=pos.x,y=pos.y-3,z=pos.z})
			a=1
		end
		if a==1 then
			local p2=minetest.get_node(pos).param2
			minetest.set_node(pos,{name="mobu:UOlola2",param2=p2})
			minetest.env:get_node_timer(pos):start(1)
		end
		for i, ob in pairs(minetest.get_objects_inside_radius({x=pos.x,y=pos.y-2.5,z=pos.z}, 2)) do
			if ob~=nil and (ob:is_player()==false or ob:is_player()==true) and ob:get_hp() then
				ob:set_hp(ob:get_hp()-4)
				ob:punch(ob, {full_punch_interval=1.0,damage_groups={fleshy=9000}}, "default:bronze_pick", nil)
				a=1
			end
		end
		return true
	end,
})

minetest.register_node("mobu:UOlola2", {
	description = "UOlola",
	groups = {choppy = 2,not_in_creative_inventory=1},
	tiles = {"uolola.png"},
	drawtype="mesh",
	drop="mobu:UOlola",
	mesh="uolola2.obj",
	paramtype="light",
	paramtype2="facedir",
	--sounds = mobu:morso,
			
    --sounds = default.node_sound_leaves_defaults(),
	on_timer = function (pos, elapsed)
		local p2=minetest.get_node(pos).param2
		minetest.set_node(pos,{name="mobu:UOlola",param2=p2})
		minetest.env:get_node_timer(pos):start(3)
		for i, ob in pairs(minetest.get_objects_inside_radius({x=pos.x,y=pos.y-2.5,z=pos.z}, 2)) do
			ob:set_hp(ob:get_hp()-4)
			ob:punch(ob, {full_punch_interval=1.0,damage_groups={fleshy=9000}}, "default:bronze_pick", nil)
		end
	end,
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
	},
})
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0.0003,
		scale = 0.0003,
		spread = {x = 250, y = 250, z = 250},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	y_min = 1,
	y_max = 50,
	decoration = "mobu:UOlola_spawner",
})
