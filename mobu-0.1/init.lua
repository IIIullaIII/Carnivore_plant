local path = minetest.get_modpath("mobu")
dofile(path.."/UOlola.lua")

-- Mob Api

dofile(path.."/api.lua")

minetest.register_alias("mobu:mobu_green_egg", "mobu:mobu_green_egg")

mobu:register_mob("mobu:carnivore_plant", 
    {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	reach = 3,
	damage = 2,
	hp_min = 10,
	hp_max = 35,
	armor = 80,
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5},
	visual = "mesh",
	mesh = "ucarniplant.b3d",
	textures = {
		{"mobu_new_carnivore_plant.png"},
	},
	blood_texture = "mobu_green_blood.png",
        child_texture = {
		{"mobu_new_carnivore_plant.png"},
	},
	makes_footstep_sound = false,
	sounds = {
		random = "Banana_Slap",
		war_cry = "pew",
	},
	walk_velocity = 1,
	run_velocity = 0,
	jump = true,
	view_range = 6,
	floats = 0,
	drops =  {
		{name = "mobu:UOlola",
		chance = 15, min = 1, max = 1},
	}, 
       
	water_damage = 0,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		speed_run = 5,
		stand_start = 1,
		stand_end = 5,
		walk_start = 3,
		walk_end = 5,
		run_start = 1,
		run_end = 5,
		punch_start = 20,
		punch_end = 28,
	},
  --      follow = {"mobs:bee", "farming:seed_cotton"},
	--view_range = 5,

on_rightclick = function(self, clicker)
	mobu:feed_tame(self, clicker, 8, true, true)
	mobu:capture_mob(self, clicker, 30, 50, 80, true, nil)
end,

        	new_on_pounch = function(self, pos)
		minetest.set_node(pos, {name = "mobu;UOlola"})
	end,
})

mobu:register_spawn("mobu:carnivore_plant", {"default:dirt_with_grass", "ethereal:prairie_dirt"}, 20, 10, 15000, 2, 31000)

mobu:register_egg("mobu:carnivore_plant", "carnivore_plant","mobu_new_carnivore_plant.png",1)

mobu:register_arrow("mobu:ogg_entity", {
	visual = "sprite",
	visual_size = {x=.5, y=.5},
	textures = {"mobu_green_ogg.png"},
	velocity = 6,

	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 1},
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 1},
		}, nil)
	end,

	hit_node = function(self, pos, node)

		local num = math.random(1, 10)
		if num == 1 then
			pos.y = pos.y + 1
			local nod = minetest.get_node_or_nil(pos)
			if not nod
			or not minetest.registered_nodes[nod.name]
			or minetest.registered_nodes[nod.name].walkable == true then
				return
			end
			local mob = minetest.add_entity(pos, "mobu:carnivore_plant")
			local ent2 = mob:get_luaentity()
			mob:set_properties({
				textures = ent2.child_texture[1],
				visual_size = {
					x = ent2.base_size.x / 2,
					y = ent2.base_size.y / 2
				},
				collisionbox = {
					ent2.base_colbox[1] / 2,
					ent2.base_colbox[2] / 2,
					ent2.base_colbox[3] / 2,
					ent2.base_colbox[4] / 2,
					ent2.base_colbox[5] / 2,
					ent2.base_colbox[6] / 2
				},
			})
			ent2.child = true
			ent2.tamed = true
			ent2.owner = self.playername
		end
	end
})

local egg_GRAVITY = 9
local egg_VELOCITY = 19

-- shoot snowball
local mobu_shoot_egg = function (item, player, pointed_thing)
	local playerpos = player:getpos()
	minetest.sound_play("default_place_node_hard", {
		pos = playerpos,
		gain = 1.0,
		max_hear_distance = 5,
	})
	local obj = minetest.add_entity({
		x = playerpos.x,
		y = playerpos.y +1.5,
		z = playerpos.z
	}, "mobu:ogg_entity")
	local ent = obj:get_luaentity()
	local dir = player:get_look_dir()
	ent.velocity = egg_VELOCITY   -- needed for api internal timing
	ent.switch = 1 -- needed so that egg doesn't despawn straight away
	obj:setvelocity({
		x = dir.x * egg_VELOCITY,
		y = dir.y * egg_VELOCITY,
		z = dir.z * egg_VELOCITY
	})
	obj:setacceleration({
		x = dir.x * -3,
		y = -egg_GRAVITY,
		z = dir.z * -3
	})
	-- pass player name to egg for chick ownership
	local ent2 = obj:get_luaentity()
	ent2.playername = player:get_player_name()
	item:take_item()
	return item
end

minetest.register_node("mobu:mobu_green_egg", {
	description = "carnivore_plant_Egg",
	tiles = {"mobu_green_egg.png"},
	inventory_image  = "mobu_green_egg.png",
	visual_scale = 0.7,
	drawtype = "plantlike",
	wield_image = "mobu_green_egg.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	sunlight_propagates = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	groups = {snappy = 2, dig_immediate = 3},
	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.set_node(pos, {name = "mobu:mobu_green_egg", param2 = 1})
		end
	end,
	on_use = mobu_shoot_egg
})

local egg_GRAVITY = 9
local egg_VELOCITY = 19

-- shoot snowball
local mobu_shoot_egg = function (item, player, pointed_thing)
	local playerpos = player:getpos()
	minetest.sound_play("default_place_node_hard", {
		pos = playerpos,
		gain = 1.0,
		max_hear_distance = 5,
	})
	local obj = minetest.add_entity({
		x = playerpos.x,
		y = playerpos.y +1.5,
		z = playerpos.z
	}, "mobu:ogg_entity")
	local ent = obj:get_luaentity()
	local dir = player:get_look_dir()
	ent.velocity = egg_VELOCITY -- needed for api internal timing
	ent.switch = 1 -- needed so that egg doesn't despawn straight away
	obj:setvelocity({
		x = dir.x * egg_VELOCITY,
		y = dir.y * egg_VELOCITY,
		z = dir.z * egg_VELOCITY
	})
	obj:setacceleration({
		x = dir.x * -3,
		y = -egg_GRAVITY,
		z = dir.z * -3
	})
	-- pass player name to egg for chick ownership
	local ent2 = obj:get_luaentity()
	ent2.playername = player:get_player_name()
	item:take_item()
	return item
end
-- blood
minetest.register_craftitem("mobu:green_blood", {
	description = "green_blood",
	inventory_image = "mobu_green_blood.png",
})
