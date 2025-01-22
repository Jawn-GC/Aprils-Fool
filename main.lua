meta = {
    name = "April's Fool",
	description = "It's just a prank, bro.",
    version = '1.6.1',
    author = 'JawnGC',
}

local sound = require('play_sound')
local blockchain_and_firebug = require("blockchain_and_firebug")

activate_sparktraps_hack(true)

--Drops/Spawns
replace_drop(DROP.ROCKDOG_FIREBALL, ENT_TYPE.ITEM_AXOLOTL_BUBBLESHOT)
replace_drop(DROP.AXOLOTL_BUBBLE, ENT_TYPE.ITEM_FIREBALL)
replace_drop(DROP.SORCERESS_DAGGERSHOT, ENT_TYPE.ITEM_PLASMACANNON_SHOT)
replace_drop(DROP.USHABTI_QILIN, ENT_TYPE.ITEM_JETPACK)
replace_drop(DROP.LOCKEDCHEST_UDJATEYE, ENT_TYPE.MONS_LEPRECHAUN)
replace_drop(DROP.VAN_HORSING_DIAMOND, ENT_TYPE.ITEM_PICKUP_UDJATEYE)
replace_drop(DROP.VAN_HORSING_COMPASS, ENT_TYPE.ITEM_PICKUP_TABLETOFDESTINY)
replace_drop(DROP.GIANTSPIDER_WEBSHOT, ENT_TYPE.MONS_SPIDER)
replace_drop(DROP.ANUBIS2_JETPACK, ENT_TYPE.ITEM_POWERPACK)
replace_drop(DROP.ALTAR_PRESENT_EGGPLANT, ENT_TYPE.FX_POWEREDEXPLOSION)
replace_drop(DROP.ALTAR_ROCK_WOODENARROW, ENT_TYPE.ITEM_DIAMOND)
replace_drop(DROP.YAMA_GIANTFOOD, ENT_TYPE.ITEM_PICKUP_COOKEDTURKEY)
change_waddler_drop({ENT_TYPE.ITEM_PICKUP_SPECIALCOMPASS, ENT_TYPE.ITEM_CHEST, ENT_TYPE.ITEM_KEY})
change_sunchallenge_spawns({ENT_TYPE.MONS_WITCHDOCTOR, ENT_TYPE.MONS_VAMPIRE, ENT_TYPE.MONS_YETI, ENT_TYPE.MONS_NECROMANCER})

--"Immortal" skeletons
set_drop_chance(DROPCHANCE.SKELETON_SKELETONKEY, 1)
replace_drop(DROP.SKELETON_SKELETONKEY, ENT_TYPE.MONS_SKELETON)
replace_drop(DROP.SKELETON_SKULL, ENT_TYPE.FX_SHADOW)

--Daggershotgun
set_pre_entity_spawn(function(type, x, y, l, overlay)
	return spawn_entity_nonreplaceable(ENT_TYPE.ITEM_SORCERESS_DAGGER_SHOT, x, y, l, 0, 0)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_BULLET)

--Firebugs spray curse clouds
set_pre_entity_spawn(function(type, x, y, l, overlay)
   	local num = math.random(10)
	if num <= 2 then
		return spawn_entity_nonreplaceable(ENT_TYPE.ITEM_CURSING_CLOUD, x, y, l, 0, 0)
	else 
		return spawn_entity_nonreplaceable(ENT_TYPE.FX_SHADOW, x, y, l, 0, 0)
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_FLAMETHROWER_FIREBALL)

--"Invisible" Quillback
set_post_entity_spawn(function (entity)
	entity.color.a = 0.1
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_CAVEMAN_BOSS)

--Sonic Lizards
--Drop "rings" when hit
local lizards = {}
local lizard_callbacks = {}
set_post_entity_spawn(function (entity)
	lizards[#lizards + 1] = entity.uid
	entity.color:set_rgba(0, 50, 200, 255)
	entity.type.max_speed = 0.4
	lizard_callbacks[#lizard_callbacks + 1] = entity:set_pre_damage(function()
		if entity.health > 0 and entity.state ~= 12 and entity.state ~= 17 then
			local x, y ,l = get_position(entity.uid)
			local angle, vx, vy
			for i = 1,3 do
				angle = 2 * math.pi * math.random()
				vx = math.cos(angle)
				vy = math.sin(angle)
				spawn(ENT_TYPE.ITEM_GOLDCOIN, x, y, l, vx, vy)
			end
		end
	end)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HORNEDLIZARD)

--Giant spiders release smaller spiders on death
local giant_spider_callbacks = {}
set_post_entity_spawn(function (entity)
	giant_spider_callbacks[#giant_spider_callbacks + 1] = entity:set_pre_kill(function()
		local x, y ,l = get_position(entity.uid)
		local angle, vx, vy
		for i = 1,3 do
			angle = 2 * math.pi * math.random()
			vx = 0.2 * math.cos(angle)
			vy = 0.2 * math.sin(angle)
			spawn(ENT_TYPE.MONS_SPIDER, x, y, l, vx, vy)
		end
	end)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_GIANTSPIDER)

--Necromancers spawn cursed Sorceresses that will die after shooting
local cursed_sorceress = {}
set_pre_entity_spawn(function(type, x, y, l, overlay)
    local uid = spawn_entity_nonreplaceable(ENT_TYPE.MONS_SORCERESS, x, y, l, 0, 0)
	get_entity(uid):set_cursed(true)
	cursed_sorceress[#cursed_sorceress + 1] = uid
	return uid
end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.MONS_REDSKELETON)

--Worse Gambling Shop Prizes
set_callback(function ()	
	change_diceshop_prizes({ENT_TYPE.ITEM_PICKUP_PARACHUTE, ENT_TYPE.ITEM_MACHETE, ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES, ENT_TYPE.ITEM_PICKUP_SPRINGSHOES, ENT_TYPE.ITEM_PURCHASABLE_POWERPACK, ENT_TYPE.ITEM_PURCHASABLE_JETPACK, ENT_TYPE.ITEM_PURCHASABLE_TELEPORTER_BACKPACK, ENT_TYPE.ITEM_DIAMOND, ENT_TYPE.ITEM_METAL_SHIELD, ENT_TYPE.ITEM_WOODEN_SHIELD, ENT_TYPE.ITEM_KEY, ENT_TYPE.ITEM_PRESENT, ENT_TYPE.ITEM_BROKEN_MATTOCK, ENT_TYPE.ITEM_LANDMINE, ENT_TYPE.ITEM_PICKUP_ROYALJELLY, ENT_TYPE.ITEM_DIE, ENT_TYPE.ITEM_SHOTGUN, ENT_TYPE.ITEM_PURCHASABLE_HOVERPACK, ENT_TYPE.ITEM_TELEPORTER})
end, ON.POST_LEVEL_GENERATION)

--Robots
local robots = {}
local robot_exploded = {}
set_post_entity_spawn(function(entity)
    robots[#robots + 1] = entity.uid
	robot_exploded[#robot_exploded + 1] = false
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_ROBOT)

--Change Gravity of falling platforms
--Shaking is more intense for higher gravity magnitudes
local falling_platforms = {}
set_post_entity_spawn(function(entity)
	local num = math.random()
    entity:set_gravity(0.15 * (5 - 10 * num))
	entity.shaking_factor = math.abs(0.5 - num) * 0.2
	falling_platforms[#falling_platforms + 1] = entity.uid
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM)

--Spark Traps
local sparks = {}
set_post_entity_spawn(function(entity)
	sparks[#sparks + 1] = entity.uid
	entity.distance = 3.0
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SPARK)

--Replace snakes with cardboard snakes
set_pre_entity_spawn(function(type, x, y, l, overlay)
	local direction = math.random(2)
	local snake = spawn_entity_nonreplaceable(ENT_TYPE.ITEM_TUTORIAL_MONSTER_SIGN, x, y, l, 0, 0)
	get_entity(snake):set_texture(TEXTURE.DATA_TEXTURES_DECO_BASECAMP_1)
	get_entity(snake).animation_frame = 195
	
	if direction == 1 then
		get_entity(snake).flags = set_flag(get_entity(snake).flags, 17)
	else
		get_entity(snake).flags = clr_flag(get_entity(snake).flags, 17)
	end
	
	get_entity(snake).flags = set_flag(get_entity(snake).flags, 15)
	
    return snake
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)

--Get 20% of Bats
local bats = {}
set_post_entity_spawn(function(entity)
	local num = math.random(5)
	if num == 1 then
		bats[#bats + 1] = entity.uid
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_BAT)

--Penguin critters are larger
set_post_entity_spawn(function(entity)
	if state.theme == THEME.ICE_CAVES or (state.theme == THEME.COSMIC_OCEAN and get_co_subtheme() == COSUBTHEME.ICE_CAVES) then
		entity.height = entity.height * 2
		entity.width = entity.width * 2
		entity.hitboxx = entity.hitboxx * 2
		entity.hitboxy = entity.hitboxy * 2.5
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_CRITTERPENGUIN)

--Timed Forcefields
local timed_forcefields = {}
set_post_entity_spawn(function(entity)
	timed_forcefields[#timed_forcefields + 1] = entity.uid
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_TIMED_FORCEFIELD)

--50% of Jiangshi will wait for the player to make a move
local jiangshi = {}
set_post_entity_spawn(function(entity)
	local num = math.random(2)
	if num == 1 then
		jiangshi[#jiangshi + 1] = entity.uid
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_JIANGSHI)
set_post_entity_spawn(function(entity)
	local num = math.random(2)
	if num == 1 then
		jiangshi[#jiangshi + 1] = entity.uid
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_FEMALE_JIANGSHI)

--Flying Fish
local flying_fish = {}
local fish_state = {}
set_post_entity_spawn(function(entity)
	flying_fish[#flying_fish + 1] = entity.uid
	fish_state[#fish_state + 1] = 0
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_FISH)

--Octopy have Spring Shoes
set_post_entity_spawn(function(entity)
	entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPRING_SHOES)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_OCTOPUS)

--Mosquitoes have more blood
set_post_entity_spawn(function(entity)
	entity.type.blood_content = 15
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MOSQUITO)

--Remove skulls from bone blocks for Moon Challenge
set_post_entity_spawn(function(entity, spawn_flags)
	if state.theme == THEME.JUNGLE or state.theme == THEME.VOLCANA then
		entity:destroy()
	end
end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)

--Kingu
local kingu = {}
set_post_entity_spawn(function(entity)
	kingu[#kingu + 1] = entity.uid 
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_KINGU)
set_post_entity_spawn(function(entity)
	entity:destroy()
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FX_KINGU_PLATFORM)
	
--Rewards from the Star Challenge are replaced with 3 gifts
set_pre_entity_spawn(function(type, x, y, l, overlay)
	if state.theme == THEME.TEMPLE and state.level == 2 then
		spawn_entity_nonreplaceable(ENT_TYPE.ITEM_PRESENT, x + 1, y, l, 0, 0)
		spawn_entity_nonreplaceable(ENT_TYPE.ITEM_PRESENT, x - 1, y, l, 0, 0)
		return spawn_entity_nonreplaceable(ENT_TYPE.ITEM_PRESENT, x, y, l, 0, 0)
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_PICKUP_ELIXIR)
set_pre_entity_spawn(function(type, x, y, l, overlay)
	if state.theme == THEME.TIDE_POOL and state.level == 2 then
		spawn_entity_nonreplaceable(ENT_TYPE.ITEM_PRESENT, x + 1, y, l, 0, 0)
		spawn_entity_nonreplaceable(ENT_TYPE.ITEM_PRESENT, x - 1, y, l, 0, 0)
		return spawn_entity_nonreplaceable(ENT_TYPE.ITEM_PRESENT, x, y, l, 0, 0)
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_CLONEGUN)

--Lamassu
local lamassu = {}
local lamassu_attack_counter = {}
set_post_entity_spawn(function(entity)
	lamassu[#lamassu + 1] = entity.uid
	entity.attack_timer = -60
	lamassu_attack_counter[#lamassu_attack_counter + 1] = 0
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_LAMASSU)

--Monkeys (50% Normal, 25% Fire, 25% Ice)
local fire_monkeys = {}
local ice_monkeys = {}
local ice_monkey_can_freeze = {}
set_post_entity_spawn(function(entity)
	local num = math.random(4)
	if num == 1 then
		fire_monkeys[#fire_monkeys + 1] = entity.uid
	elseif num == 2 then
		ice_monkeys[#ice_monkeys + 1] = entity.uid
		ice_monkey_can_freeze[#ice_monkey_can_freeze + 1] = true
		generate_world_particles(PARTICLEEMITTER.WETEFFECT_DROPS, entity.uid)
		entity.color.r = 0.23
		entity.color.g = 0.58
		entity.color.b = 0.58
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MONKEY)

--Frogs are cursed
set_post_entity_spawn(function(entity)
	entity:set_cursed(true)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_FROG)
set_post_entity_spawn(function(entity)
	entity:set_cursed(true)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_FIREFROG)

--Small Yeti King & Queen
set_post_entity_spawn(function(entity)
	entity.height = entity.height * 0.65
	entity.width = entity.width * 0.65
	entity.hitboxx = entity.hitboxx * 0.5
	entity.hitboxy = entity.hitboxy * 0.5
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_YETIQUEEN)
set_post_entity_spawn(function(entity)
	entity.height = entity.height * 0.65
	entity.width = entity.width * 0.65
	entity.hitboxx = entity.hitboxx * 0.5
	entity.hitboxy = entity.hitboxy * 0.5
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_YETIKING)

--Random UFO shots
set_post_entity_spawn(function(entity)
	local num = math.random(6)
	local shot 
	if num == 1 then
		shot = spawn_entity_nonreplaceable(ENT_TYPE.ITEM_SORCERESS_DAGGER_SHOT, entity.x, entity.y, entity.layer, 0, -0.15)
	elseif num == 2 then
		shot = spawn_entity_nonreplaceable(ENT_TYPE.ITEM_FREEZERAYSHOT, entity.x, entity.y, entity.layer, 0, -0.25)
	elseif num == 3 then
		shot = spawn_entity_nonreplaceable(ENT_TYPE.ITEM_CLONEGUNSHOT, entity.x, entity.y, entity.layer, 0, 0) --Clones the UFO
	elseif num == 4 then
		shot = spawn_entity_nonreplaceable(ENT_TYPE.ITEM_PLASMACANNON_SHOT, entity.x, entity.y, entity.layer, 0, -0.05)
	elseif num == 5 then
		shot = spawn_entity_nonreplaceable(ENT_TYPE.ITEM_LAMASSU_LASER_SHOT, entity.x, entity.y, entity.layer, 0, -0.2)
	else
		shot = spawn_entity_nonreplaceable(ENT_TYPE.ITEM_HUNDUN_FIREBALL, entity.x, entity.y, entity.layer, 0, -0.2)
	end
	get_entity(shot).angle = 3 * math.pi / 2
	entity:destroy()
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_UFO_LASER_SHOT)

--Egg Sac Piñatas
set_post_entity_spawn(function(entity)
	local num = math.random(18)
	if num == 1 then
		spawn_entity_nonreplaceable(ENT_TYPE.ITEM_RUBY_SMALL, entity.x, entity.y, entity.layer, 0, 0)
		entity:destroy()
	elseif num == 2 then
		spawn_entity_nonreplaceable(ENT_TYPE.ITEM_EMERALD_SMALL, entity.x, entity.y, entity.layer, 0, 0)
		entity:destroy()
	elseif num == 3 then
		spawn_entity_nonreplaceable(ENT_TYPE.ITEM_SAPPHIRE_SMALL, entity.x, entity.y, entity.layer, 0, 0)
		entity:destroy()
	elseif num == 4 then
		spawn_entity_nonreplaceable(ENT_TYPE.ITEM_GOLDCOIN, entity.x, entity.y, entity.layer, 0, 0)
		entity:destroy()
	elseif num == 5 then
		spawn_entity_nonreplaceable(ENT_TYPE.MONS_MOLE, entity.x, entity.y, entity.layer, 0, 0)
		entity:destroy()
	elseif num == 6 then
		spawn_entity_nonreplaceable(ENT_TYPE.MONS_PROTOSHOPKEEPER, entity.x, entity.y, entity.layer, 0, 0)
		entity:destroy()
	elseif num == 7 then
		spawn_entity_nonreplaceable(ENT_TYPE.ITEM_BOMB, entity.x, entity.y, entity.layer, 0, 0)
		entity:destroy()
	elseif num == 8 then
		spawn_entity_nonreplaceable(ENT_TYPE.MONS_SCORPION, entity.x, entity.y, entity.layer, 0, 0)
		entity:destroy()
	elseif num == 9 then
		spawn_entity_nonreplaceable(ENT_TYPE.MONS_OLMITE_NAKED, entity.x, entity.y, entity.layer, 0, 0)
		entity:destroy()
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_GRUB)

--Split Ghost Immediately
set_post_entity_spawn(function(entity)
	entity.split_timer = 1
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_GHOST)

local frames = 0
set_callback(function ()	
	frames = frames + 1
end, ON.FRAME)

--Scepter Shot Information
local scepter_shots = {}
local scepter_shot_starting_frame = {}
local shot_direction = {}
set_post_entity_spawn(function(entity)
	scepter_shots[#scepter_shots + 1] = entity.uid
	scepter_shot_starting_frame[#scepter_shot_starting_frame + 1] = frames
	if #players > 0 then
		shot_direction[#shot_direction + 1] = test_flag(players[1].flags, 17)
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SCEPTER_PLAYERSHOT)

-- Conveyor Belts point in the wrong directions
set_post_entity_spawn(function(entity)
	entity.flags = set_flag(entity.flags, 17)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_CONVEYORBELT_LEFT)
set_post_entity_spawn(function(entity)
	entity.flags = set_flag(entity.flags, 17)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_CONVEYORBELT_RIGHT)

--Fast Bubbles
set_post_entity_spawn(function(entity)
	entity.type.max_speed = 0.75
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ACTIVEFLOOR_BUBBLE_PLATFORM)

--Replace Tusk idol in Tidepool with the Tablet of Destiny
set_post_entity_spawn(function(entity)
	if state.theme == THEME.TIDE_POOL then
		local x,y,l = get_position(entity.uid)
		entity:destroy()
		spawn(ENT_TYPE.ITEM_PICKUP_TABLETOFDESTINY, x, y, l, 0, 0)
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_MADAMETUSK_IDOL)

--Replace idol in Palace of Pleasure with Tusk's Idol
set_post_entity_spawn(function(entity)
	local walrus = get_entities_by(ENT_TYPE.MONS_MADAMETUSK, MASK.ANY, LAYER.BOTH)
	if state.theme == THEME.NEO_BABYLON and #walrus > 0 then
		local x,y,l = get_position(entity.uid)
		entity:destroy()
		spawn(ENT_TYPE.ITEM_MADAMETUSK_IDOL, x, y, l, 0, 0)
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_IDOL)

--Shields
set_post_entity_spawn(function(entity)
	entity.flags = set_flag(entity.flags, ENT_FLAG.USABLE_ITEM)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_METAL_SHIELD)
set_post_entity_spawn(function(entity)
	entity.flags = set_flag(entity.flags, ENT_FLAG.USABLE_ITEM)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_WOODEN_SHIELD)

--Remove hitbox of Kingu's platform
set_post_entity_spawn(function(entity)
	entity.hitboxx = 0
	entity.hitboxy = 0
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ACTIVEFLOOR_KINGU_PLATFORM)

--Modifications related to the player
local volcana_idol = {}
local volcana_idol_frames = 0
local poison_distance = 0
local pre_x, pre_y, pre_l = 0, 0, 0 --Variables that will hold the position of the player from the previous frame
local cold_feet_timer = 0
local cold_feet = false
local ice_blocks = {}
local player_invisible = false
local hoverpack_timer = 0
local red_teleporter
local red_active = false
local red_thrown = false
local green_teleporter
local shield_bash_cooldown = 0
local shield_bash_direction = 0
set_callback(function ()
	--Slippery Climbing Gloves
	--Hold the Door button to not slide
	if #players > 0 and players[1].state == CHAR_STATE.HANGING and entity_has_item_type(players[1].uid, ENT_TYPE.ITEM_POWERUP_CLIMBING_GLOVES) then
		local input = read_input(players[1].uid)
		if test_flag(input, 6) == false then
			players[1].y = players[1].y - 0.025
		end
	end

	--Spawn bombs at the players feet when they have the True Crown
	if #players > 0 and (players[1].state == CHAR_STATE.STANDING or players[1].state == CHAR_STATE.DUCKING) and players[1].state ~= CHAR_STATE.ENTERING and players[1].state ~= CHAR_STATE.EXITING and entity_has_item_type(players[1].uid, ENT_TYPE.ITEM_POWERUP_TRUECROWN) then
		if frames % 120 == 0 then
			local px, py, pl = get_position(players[1].uid)
			local bomb = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_BOMB, px, py, pl, 0, 0)
		end
	end

	--Parachute must be deployed manually by pressing the door button while falling
	if #players > 0 and (players[1].state == CHAR_STATE.FALLING or players[1].state == CHAR_STATE.STUNNED) and entity_has_item_type(players[1].uid, ENT_TYPE.ITEM_POWERUP_PARACHUTE) then
		local parachute = entity_get_items_by(players[1].uid, ENT_TYPE.ITEM_POWERUP_PARACHUTE, MASK.ANY)
		if #parachute > 0 and get_entity(parachute[1]).falltime_deploy ~= -1 then
			get_entity(parachute[1]).falltime_deploy = -1
		end
		local input = read_input(players[1].uid)
		if test_flag(input, 6) == true and #parachute > 0 then
			get_entity(parachute[1]):deploy()
		end
	end

	--Defective Spring Shoes
	--Jump height is based on the seconds counter of the level time (0 -> lowest, 9 -> highest)
	if #players > 0 and entity_has_item_type(players[1].uid, ENT_TYPE.ITEM_POWERUP_SPRING_SHOES) then
		local num = math.floor((frames % 600) / 60)
		players[1].jump_height_multiplier = 1.1 + 0.1 * num
	end
	
	--Poison does damage to the player only when they've moved enough (like in Pokemon games)
	--Remove poison when player is at 1 health
	if #players > 0 and players[1].health == 1 and players[1].poison_tick_timer ~= -1 then
		players[1].poison_tick_timer = -1
	end
	if #players > 0 and players[1]:is_poisoned() == false then
		pre_x, pre_y, pre_l = get_position(players[1].uid)
	end
	if #players > 0 and players[1]:is_poisoned() and players[1].poison_tick_timer == 300 then
		players[1].poison_tick_timer = players[1].poison_tick_timer + 1 --Stall timer
	end
	if #players > 0 and players[1]:is_poisoned() and poison_distance < 30.0 then
		local px, py, pl = get_position(players[1].uid)
		local delta = math.sqrt((px - pre_x)^2.0 + (py - pre_y)^2.0)
		--Discard large changes in position due to teleporting or looping in CO
		if delta < 1.0 then
			poison_distance = poison_distance + delta
		end
		pre_x, pre_y, pre_l = px, py, pl
	elseif #players > 0 and players[1]:is_poisoned() and poison_distance >= 30.0 then
		players[1].poison_tick_timer = 0
		poison_distance = 0
		pre_x, pre_y, pre_l = get_position(players[1].uid)
	end
	
	--Unequip Jetpack from player if it runs out of fuel
	local jetpacks = get_entities_by(ENT_TYPE.ITEM_JETPACK, MASK.ANY, LAYER.BOTH)
	for i = 1,#jetpacks do
		if #players > 0 and get_entity(jetpacks[i]) ~= nil then
			if get_entity(jetpacks[i]).fuel == 0 and jetpacks[i] == players[1]:worn_backitem() then
				players[1]:unequip_backitem()
			end
		end
	end
	
	--Hoverpacks will overheat and explode if active for too long
	local hoverpacks = get_entities_by(ENT_TYPE.ITEM_HOVERPACK, MASK.ANY, LAYER.BOTH)
	for i = 1,#hoverpacks do
		if #players > 0 and get_entity(hoverpacks[i]) ~= nil and hoverpacks[i] == players[1]:worn_backitem() then
			if get_entity(hoverpacks[i]).is_on == true then
				if hoverpack_timer < 300 then
					hoverpack_timer = hoverpack_timer + 1
				end
				if hoverpack_timer >= 150 and frames % 12 == 0 then
					get_entity(hoverpacks[i]):light_on_fire(5)
					generate_world_particles(PARTICLEEMITTER.BLUESPARKS, hoverpacks[i])
				end
				if hoverpack_timer == 300 then
					players[1]:light_on_fire(5)
				end
			end
			if get_entity(hoverpacks[i]).is_on == false and hoverpack_timer > 0 then
				hoverpack_timer = hoverpack_timer - 1
			end
		end
	end
	if #players > 0 and players[1]:worn_backitem() == -1 then
		hoverpack_timer = 0
	end

	--Make the player invisible while wearing a telepack
	local telepacks = get_entities_by(ENT_TYPE.ITEM_TELEPORTER_BACKPACK, MASK.ANY, LAYER.BOTH)
	for i = 1,#telepacks do
		if #players > 0 and get_entity(telepacks[i]) ~= nil then
			if telepacks[i] == players[1]:worn_backitem() and player_invisible == false then
				get_entity(telepacks[i]).color.a = 0
				players[1].color.a = 0
				player_invisible = true
			elseif telepacks[i] ~= players[1]:worn_backitem() then
				get_entity(telepacks[i]).color.a = 1
			end
		end
	end
	if #players > 0 and players[1]:worn_backitem() == -1 and player_invisible == true then
		players[1].color.a = 1
		player_invisible = false
	end
	if #players > 0 and (players[1].state == CHAR_STATE.EXITING or players[1].state == CHAR_STATE.ENTERING) then
		player_invisible = false
	end

	--Teleporters can be thrown and the player can teleport to their location
	local teleporters = get_entities_by(ENT_TYPE.ITEM_TELEPORTER, MASK.ANY, LAYER.BOTH)
	for i = 1,#teleporters do
		if #players > 0 and get_entity(teleporters[i]) ~= nil and players[1].holding_uid == teleporters[i] then
			red_teleporter = teleporters[i]
			get_entity(red_teleporter).flags = clr_flag(get_entity(red_teleporter).flags, ENT_FLAG.USABLE_ITEM)
			red_active = true
		end
	end
	if #players > 0 and red_active == true and players[1].holding_uid ~= red_teleporter and red_thrown == false then
		red_thrown = true
		green_teleporter = spawn_entity(ENT_TYPE.ITEM_ROCK, 0, 0, players[1].layer, 0, 0)
		pick_up(players[1].uid, green_teleporter)
		get_entity(green_teleporter).animation_frame = 54
	end
	if #players > 0 and (players[1].state == CHAR_STATE.ENTERING or players[1].state == CHAR_STATE.EXITING) and red_thrown == true then
		get_entity(green_teleporter):destroy()
	end
	if #players > 0 and red_thrown == true and players[1].holding_uid ~= green_teleporter then
		red_active = false
		red_thrown = false
		if get_entity(green_teleporter) ~= nil then
			get_entity(green_teleporter):destroy()
		end
		if get_entity(red_teleporter) ~= nil and players[1].state ~= CHAR_STATE.ENTERING and players[1].state ~= CHAR_STATE.EXITING then
			local px, py, pl = get_position(players[1].uid)
			local tx, ty, tl = get_position(red_teleporter)
			local dx = tx - px
			local dy = ty - py
			if dx < 0 then
				dx = math.ceil(dx)
			else
				dx = math.floor(dx)
			end
			if dy < 0 then
				dy = math.ceil(dy)
			else
				dy = math.floor(dy)
			end
			players[1].invincibility_frames_timer = 10
			players[1]:perform_teleport(dx, dy)
		end
	end
	if red_active == true and frames % 12 == 0 then
		if get_entity(red_teleporter) ~= nil then
			generate_world_particles(PARTICLEEMITTER.TELEPORTEFFECT_REDSPARKLES, red_teleporter)
		end
	end
	if red_thrown == true and frames % 12 == 0 then
		if get_entity(green_teleporter) ~= nil then
			generate_world_particles(PARTICLEEMITTER.TELEPORTEFFECT_GREENSPARKLES, green_teleporter)
		end
	end
	if get_entity(red_teleporter) == nil and get_entity(green_teleporter) ~= nil then
		red_active = false
		red_thrown = false
		get_entity(green_teleporter):destroy()
	end
	
	--Teleport the player when they interact with a crocman
	local crocs = get_entities_by(ENT_TYPE.MONS_CROCMAN, MASK.ANY, LAYER.BOTH)
	for i = 1,#crocs do
		if #players > 0 and get_entity(crocs[i]) ~= nil then
			get_entity(crocs[i]).teleport_cooldown = 10
			if get_entity(crocs[i]).last_owner_uid == players[1].uid and get_entity(crocs[i]).health ~= 0 and players[1].holding_uid ~= crocs[i] then
				local input = read_input(players[1].uid)
				if test_flag(input, INPUT_FLAG.UP) == false and test_flag(input, INPUT_FLAG.DOWN) == true then
					players[1]:perform_teleport(0, -math.random(4,8))
				elseif test_flag(input, INPUT_FLAG.UP) == true and test_flag(input, INPUT_FLAG.DOWN) == false then
					players[1]:perform_teleport(0, math.random(4,8))
				elseif test_flag(players[1].flags, 17) then
					players[1]:perform_teleport(-math.random(4,8), 0)
				else
					players[1]:perform_teleport(math.random(4,8), 0)
				end
				get_entity(crocs[i]).last_owner_uid = -1
			end
		end
	end
	
	--Volcana Idol explodes when held by the player for 3 seconds
    if state.theme == THEME.VOLCANA then
		volcana_idol = get_entities_by(ENT_TYPE.ITEM_IDOL, MASK.ANY, LAYER.BOTH)
		for i = 1,#volcana_idol do
			if #players > 0 and get_entity(volcana_idol[i]) ~= nil then
				if players[1].holding_uid == volcana_idol[i] then
					get_entity(volcana_idol[i]):light_on_fire(5)
					volcana_idol_frames = volcana_idol_frames + 1
				else
					volcana_idol_frames = 0
				end
				
				if volcana_idol_frames == 180 then
					local ix, iy, il = get_position(volcana_idol[i])
					spawn_entity(ENT_TYPE.FX_EXPLOSION, ix, iy, il, 0, 0)
					volcana_idol_frames = 0
				end
			end
		end
    end
	volcana_idol = {}
	
	--Player becomes a random character every 2 seconds while they are cursed
	if #players > 0 and players[1]:is_cursed() and frames % 120 == 0 then
		players[1]:set_texture(285 + math.random(0,19))
	end
	
	--Jiangshi wait timer is reduced only when the player is in motion
	for i = 1,#jiangshi do
		if #players > 0 and get_entity(jiangshi[i]) ~= nil then
			local pvx, pvy = get_velocity(players[1].uid)
			if pvx == 0 and pvy == 0 then
				get_entity(jiangshi[i]).wait_timer = get_entity(jiangshi[i]).wait_timer + 1
			end
		end
	end

	--Turkeys stay untamed when player is on them
	local turkeys = get_entities_by(ENT_TYPE.MOUNT_TURKEY, MASK.ANY, LAYER.BOTH)
	if #players > 0 then
		for i = 1,#turkeys do
			if get_entity(turkeys[i]) ~= nil then
				if get_entity(turkeys[i]).rider_uid == players[1].uid then
					get_entity(turkeys[i]):tame(false)
					get_entity(turkeys[i]).taming_timer = 90
				end
			end
		end
	end
	
	--Fire Monkeys set the player on fire, Ice Monkeys freeze the player
	for i = 1,#fire_monkeys do
		if get_entity(fire_monkeys[i]) ~= nil then
			get_entity(fire_monkeys[i]):light_on_fire(5)
			if get_entity(fire_monkeys[i]):topmost_mount() ~= nil then
				get_entity(fire_monkeys[i]):topmost_mount():light_on_fire(5)
			end
		end
	end
	for i = 1,#ice_monkeys do
		if get_entity(ice_monkeys[i]) ~= nil and get_entity(ice_monkeys[i]).move_state == 6 and ice_monkey_can_freeze[i] == true then
			if #players > 0 and get_entity(ice_monkeys[i]):topmost_mount().uid == players[1].uid then
				ice_monkey_can_freeze[i] = false
				players[1]:freeze(45)
				sound.play_sound(VANILLA_SOUND.ITEMS_FREEZE_RAY_HIT)
			end
		elseif get_entity(ice_monkeys[i]) ~= nil and get_entity(ice_monkeys[i]).move_state ~= 6 and ice_monkey_can_freeze[i] == false then
			ice_monkey_can_freeze[i] = true
		end
	end

	--The player will freeze if they stand on ice blocks for too long (including thin ice)
	if #players > 0 and players[1].state ~= CHAR_STATE.ENTERING and players[1].state ~= CHAR_STATE.EXITING then
		for i = 1,#ice_blocks do
			if get_entity(ice_blocks[i]) ~= nil and players[1].standing_on_uid == ice_blocks[i] and players[1].frozen_timer == 0 then
				cold_feet = true
				if (cold_feet_timer % 12 == 0 and cold_feet_timer <= 60) or (cold_feet_timer % 3 == 0 and cold_feet_timer > 60) then
					generate_world_particles(PARTICLEEMITTER.YETIQUEEN_LANDING_SNOWDUST, ice_blocks[i])
				end
				break
			end
		end
		if cold_feet == true and cold_feet_timer < 120 then
			cold_feet_timer = cold_feet_timer + 1
		elseif cold_feet == false and cold_feet_timer > 0 then
			cold_feet_timer = cold_feet_timer - 1
		end
		if cold_feet_timer == 120 then
			sound.play_sound(VANILLA_SOUND.ITEMS_FREEZE_RAY_HIT)
			players[1]:freeze(90)
			cold_feet_timer = 0
		end
		cold_feet = false
	elseif #players > 0 then
		cold_feet = false
	end

	--Spark Trap speed depends on player speed
	for i = 1,#sparks do
		if #players > 0 and get_entity(sparks[i]) ~= nil then
			local vx, vy = get_velocity(players[1].uid)
			local sparkball_speed = math.sqrt(vx^2.0 + vy^2.0) / 5
			if sparkball_speed < 0.1 then
				get_entity(sparks[i]).speed = sparkball_speed
			end
		end
	end
	
	--Ghost Pots break on pick up
	local ghost_pot = get_entities_by(ENT_TYPE.ITEM_CURSEDPOT, MASK.ANY, LAYER.BOTH)
	for i = 1,#ghost_pot do
		if #players > 0 and get_entity(ghost_pot[i]) ~= nil then
			if players[1].holding_uid == ghost_pot[i] then
				get_entity(ghost_pot[i]):kill(false, nil)
			end
		end
	end
	
	--Scepter shots orbit the player
	for i = 1,#scepter_shots do
		if #players > 0 and get_entity(scepter_shots[i]) ~= nil and get_entity(scepter_shots[i]).idle_timer == 19 then
			local px, py, pl = get_position(players[1].uid)
			get_entity(scepter_shots[i]).idle_timer = get_entity(scepter_shots[i]).idle_timer + 1
			if shot_direction[i] == false then
				get_entity(scepter_shots[i]).x = px + 2 * math.cos(0.05 * (frames - scepter_shot_starting_frame[i]))
				get_entity(scepter_shots[i]).y = py + 2 * math.sin(0.05 * (frames - scepter_shot_starting_frame[i]))
			elseif shot_direction[i] == true then
				get_entity(scepter_shots[i]).x = px + 2 * -math.cos(0.05 * (frames - scepter_shot_starting_frame[i]))
				get_entity(scepter_shots[i]).y = py + 2 * -math.sin(0.05 * (frames - scepter_shot_starting_frame[i]))
			end
		end
	end
	
	--Metal Shield bash effects
	local metal_shields = get_entities_by(ENT_TYPE.ITEM_METAL_SHIELD, MASK.ANY, LAYER.BOTH)
	for i = 1, #metal_shields do
		if #players > 0 and get_entity(metal_shields[i]) ~= nil and shield_bash_cooldown == 0 and players[1].holding_uid == metal_shields[i] then
			if frames % 15 == 0 then
				generate_world_particles(PARTICLEEMITTER.TREASURE_SPARKLE_HIGH, metal_shields[i])
			end
		end
		if #players > 0 and get_entity(metal_shields[i]) ~= nil and shield_bash_cooldown == 180 and players[1].holding_uid == metal_shields[i] then
			generate_world_particles(PARTICLEEMITTER.EXPLOSION_SHOCKWAVE, metal_shields[i])
			sound.play_sound(VANILLA_SOUND.SHARED_TOSS)		
		end
	end
	if shield_bash_cooldown > 0 then
		shield_bash_cooldown = shield_bash_cooldown - 1
	end
end, ON.FRAME)
set_callback(function()
    if not players[1] then return end
	local metal_shields = get_entities_by(ENT_TYPE.ITEM_METAL_SHIELD, MASK.ANY, LAYER.BOTH)
	local input = read_input(players[1].uid)
	--Metal Shield bash
	for i = 1,#metal_shields do
		if get_entity(metal_shields[i]) ~= nil and players[1].holding_uid == metal_shields[i] and players[1].state ~= CHAR_STATE.DUCKING and players[1].state ~= CHAR_STATE.HANGING and test_flag(input, INPUT_FLAG.WHIP) then
			players[1].input.buttons_gameplay = clr_mask(players[1].input.buttons_gameplay, INPUTS.WHIP)
			if shield_bash_cooldown == 0 and (players[1].state == CHAR_STATE.STANDING or players[1].state == CHAR_STATE.JUMPING or players[1].state == CHAR_STATE.FALLING or players[1].state == CHAR_STATE.FLAILING) then
				if test_flag(players[1].flags, ENT_FLAG.FACING_LEFT) == true then
					shield_bash_direction = -1
					shield_bash_cooldown = 180
				else
					shield_bash_direction = 1
					shield_bash_cooldown = 180
				end
			end
		end
		if shield_bash_cooldown > 170 then
			players[1].input.buttons_gameplay = clr_mask(players[1].input.buttons_gameplay, INPUTS.LEFT)
			players[1].input.buttons_gameplay = clr_mask(players[1].input.buttons_gameplay, INPUTS.RIGHT)
			players[1].velocityx = shield_bash_direction * 0.5
			players[1].velocityy = 0
			players[1].airtime = 0
		end
		if shield_bash_cooldown == 170 then
			players[1].velocityx = 0
			players[1].airtime = 0
		end
	end
end, ON.PRE_UPDATE)

--Miscellaneous
local timed_kegs = {}
local timed_kegs_triggered = false
local cat_mummy = {}
local cat_mummy_state = {}
local block_swap = false
local boulder_spawned = false
local weapons = {ENT_TYPE.ITEM_WEBGUN, ENT_TYPE.ITEM_MACHETE, ENT_TYPE.ITEM_METAL_SHIELD, ENT_TYPE.ITEM_SHOTGUN, ENT_TYPE.ITEM_TELEPORTER, ENT_TYPE.ITEM_CROSSBOW, ENT_TYPE.ITEM_BOOMERANG, ENT_TYPE.ITEM_WOODEN_SHIELD}
local kirby_blocks = {}
set_callback(function ()
	--Lava when robots explode
	for i = 1,#robots do
		if get_entity(robots[i]) ~= nil then
			if get_entity(robots[i]).health == 0 and robot_exploded[i] == false then
				spawn_liquid(ENT_TYPE.LIQUID_LAVA, get_entity(robots[i]).x, get_entity(robots[i]).y)
				robot_exploded[i] = true
			end
		end
	end
	
	--Spiders jump faster
	local spiders = get_entities_by(ENT_TYPE.MONS_SPIDER, MASK.ANY, LAYER.BOTH)
	for i = 1,#spiders do
		if get_entity(spiders[i]) ~= nil and get_entity(spiders[i]).jump_timer > 20 then
			get_entity(spiders[i]).jump_timer = 20
		end
	end

	--Eggplant Ministers & Eggplups
	local ministers = get_entities_by(ENT_TYPE.MONS_EGGPLANT_MINISTER, MASK.ANY, LAYER.BOTH)
	local jumpdog = get_entities_by(ENT_TYPE.MONS_JUMPDOG, MASK.ANY, LAYER.BOTH)
	for i = 1,#ministers do
		if get_entity(ministers[i]) ~= nil and frames % 240 == 0 then
			get_entity(ministers[i]).squish_timer = 0
		elseif get_entity(ministers[i]) ~= nil and frames % 120 == 0 then
			get_entity(ministers[i]).squish_timer = 10
		end
	end
	for i = 1,#jumpdog do
		if get_entity(jumpdog[i]) ~= nil and frames % 240 == 0 then
			get_entity(jumpdog[i]).squish_timer = 0
		elseif get_entity(jumpdog[i]) ~= nil and frames % 120 == 0 then
			get_entity(jumpdog[i]).squish_timer = 60
		end
	end

	--Bats are replaced with vampires when activated
	for i = 1,#bats do
		if get_entity(bats[i]) ~= nil and get_entity(bats[i]).move_state == 6 then
			spawn_entity(ENT_TYPE.MONS_VAMPIRE, get_entity(bats[i]).x, get_entity(bats[i]).y, get_entity(bats[i]).layer, 0, 0)
			get_entity(bats[i]):destroy()
		end
	end
	
	--Random forcefield timing
	if state.theme == THEME.NEO_BABYLON or (state.theme == THEME.COSMIC_OCEAN and get_co_subtheme() == COSUBTHEME.NEO_BABYLON) then
		for i = 1,#timed_forcefields do
			local num = math.random(190, 289)
			if get_entity(timed_forcefields[i]) ~= nil and get_entity(timed_forcefields[i]).timer == num then
				get_entity(timed_forcefields[i]).timer = 0
				get_entity(timed_forcefields[i]).timer = math.random(90)
			end
		end
	end
	
	--Flying Fish explode when they collide with something (while flying)
	for i = 1,#flying_fish do
		if get_entity(flying_fish[i]) ~= nil and get_entity(flying_fish[i]).move_state == 0 and fish_state[i] == 6 then
			local fx, fy, fl  = get_position(flying_fish[i])
			spawn_entity(ENT_TYPE.FX_EXPLOSION, fx, fy, fl, 0, 0)
			fish_state[i] = get_entity(flying_fish[i]).move_state
		elseif get_entity(flying_fish[i]) ~= nil then
			fish_state[i] = get_entity(flying_fish[i]).move_state
		end
	end
	
	--Kingu boss fight
	for i = 1,#kingu do
		if get_entity(kingu[i]) ~= nil then
			--Makes Kingu climb faster
			if get_entity(kingu[i]).climb_pause_timer > 90 then
				get_entity(kingu[i]).climb_pause_timer = 90
			end
		end
	end
	
	--Lamassu shoots a burst of 3 shots
	for i = 1,#lamassu do
		if get_entity(lamassu[i]) ~= nil and get_entity(lamassu[i]).attack_timer == 0 and lamassu_attack_counter[i] ~= 3 then
			get_entity(lamassu[i]).attack_timer = 10
			lamassu_attack_counter[i] = lamassu_attack_counter[i] + 1
		elseif get_entity(lamassu[i]) ~= nil and lamassu_attack_counter[i] == 3 then
			get_entity(lamassu[i]).attack_timer = -1
			lamassu_attack_counter[i] = 0
		end
	end
	
	--Timed Powder Kegs in Tidepool 4-3 explode from innermost to outermost
	if state.theme == THEME.TIDE_POOL and state.world == 4 and state.level == 3 then
		if frames == 1 then
			timed_kegs = get_entities_by(ENT_TYPE.ACTIVEFLOOR_TIMEDPOWDERKEG, MASK.ANY, LAYER.BOTH)
		end
		for i = 1,#timed_kegs do
			if get_entity(timed_kegs[i]) ~= nil and get_entity(timed_kegs[i]).timer ~= -1 and timed_kegs_triggered == false then
				for j = 1,#timed_kegs/2 do
					if get_entity(timed_kegs[j]) ~= nil then
						get_entity(timed_kegs[j]).timer = 211 - 30 * j
					end
					if get_entity(timed_kegs[#timed_kegs + 1 - j]) ~= nil then
						get_entity(timed_kegs[#timed_kegs + 1 - j]).timer = 211 - 30 * j
					end
				end
				timed_kegs_triggered = true
			end
		end
	end
	
	--Cat mummies spawn two more cat mummies when triggered (Chargin' Chuck style); the spawned cats do not have this effect
	for i = 1,#cat_mummy do
		if get_entity(cat_mummy[i]) ~= nil and get_entity(cat_mummy[i]).move_state == 6 and cat_mummy_state[i] == 0 then
			local cx, cy, cl = get_position(cat_mummy[i])
			local cat1 = spawn_entity(ENT_TYPE.MONS_CATMUMMY, cx, cy, cl, 0.2, 0.2)
			local cat2 = spawn_entity(ENT_TYPE.MONS_CATMUMMY, cx, cy, cl, -0.2, 0.2)
			get_entity(cat1).move_state = 6
			get_entity(cat2).move_state = 6
			cat_mummy_state[i] = get_entity(cat_mummy[i]).move_state
		elseif get_entity(cat_mummy[i]) ~= nil then
			cat_mummy_state[i] = get_entity(cat_mummy[i]).move_state
		end
	end
	
	--In Dwelling, Push Blocks become Powder Kegs and vice versa
	--1 in 3 chance for swap to happen every 5 seconds
	if state.theme == THEME.DWELLING or (state.theme == THEME.COSMIC_OCEAN and get_co_subtheme() == COSUBTHEME.DWELLING) then
		if frames % 300 == 0 and frames > 1 and block_swap == false then
			local num = math.random(3)
			if num == 1 then
				local blocks = get_entities_by(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, MASK.ANY, LAYER.FRONT)
				for i = 1,#blocks do
					local x, y, l = get_position(blocks[i])
					local vx, vy = get_velocity(blocks[i])
					get_entity(blocks[i]):destroy()
					local block_uid = spawn_entity(ENT_TYPE.ACTIVEFLOOR_POWDERKEG, x, y, l, vx, vy)
					generate_world_particles(PARTICLEEMITTER.MERCHANT_APPEAR_POOF, block_uid)
					block_swap = true
				end
				if #blocks > 0 then 
					sound.play_sound(VANILLA_SOUND.SHARED_SMOKE_TELEPORT)
				end
			end
		elseif frames % 300 == 0 and frames > 1 and block_swap == true then
			local num = math.random(3)
			if num == 1 then
				local blocks = get_entities_by(ENT_TYPE.ACTIVEFLOOR_POWDERKEG, MASK.ANY, LAYER.FRONT)
				for i = 1,#blocks do
					local x, y, l = get_position(blocks[i])
					local vx, vy = get_velocity(blocks[i])
					get_entity(blocks[i]):destroy()
					local block_uid = spawn_entity(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, l, vx, vy)
					generate_world_particles(PARTICLEEMITTER.MERCHANT_APPEAR_POOF, block_uid)
					block_swap = false
				end
				if #blocks > 0 then 
					sound.play_sound(VANILLA_SOUND.SHARED_SMOKE_TELEPORT)
				end
			end
		end
	end
	
	--Kill Cursed Sorceresses from Necromancers after they shoot
	--Remove corpse
	for i = 1,#cursed_sorceress do
		if get_entity(cursed_sorceress[i]) ~= nil then
			get_entity(cursed_sorceress[i]):light_on_fire(2)
			if get_entity(cursed_sorceress[i]).inbetween_attack_timer == 120 or get_entity(cursed_sorceress[i]).health == 0 then
				get_entity(cursed_sorceress[i]):kill(true, nil)
			end
		end
	end
	
	--Regen Blocks (front layer only) break every ten seconds
	if frames % 600 == 0 and frames > 1 then
		local regen_blocks = get_entities_by(ENT_TYPE.ACTIVEFLOOR_REGENERATINGBLOCK, MASK.ANY, LAYER.FRONT)
		for i = 1,#regen_blocks do
			if get_entity(regen_blocks[i]) ~= nil then
				get_entity(regen_blocks[i]):kill(false, nil)
			end
		end
	end
	
	--Lion Traps randomly trigger
	if #players > 0 and frames % 100 == 0 then
		local lion_traps = get_entities_by(ENT_TYPE.FLOOR_LION_TRAP, MASK.ANY, LAYER.FRONT)
		for i = 1,#lion_traps do
			local num = math.random(3)
			if num == 1 then
				get_entity(lion_traps[i]):trigger(players[1].uid,true)
			elseif num == 2 then
				get_entity(lion_traps[i]):trigger(players[1].uid,false)
			end
		end
	end
	
	--Spawn 3 Boulders when the idol in Ice Caves is disturbed
	if state.theme == THEME.ICE_CAVES then
		local boulder = get_entities_by(ENT_TYPE.LOGICAL_BOULDERSPAWNER, MASK.ANY, LAYER.FRONT)
		if #boulder > 0 and get_entity(boulder[1]) ~= nil and get_entity(boulder[1]).timer == 149 and boulder_spawned == false then
			local x, y, l = get_position(boulder[1])
			boulder[2] = spawn_entity(ENT_TYPE.LOGICAL_BOULDERSPAWNER, x, y, l, 0, 0)
			get_entity(boulder[2]).timer = 135
			boulder[3] = spawn_entity(ENT_TYPE.LOGICAL_BOULDERSPAWNER, x, y, l, 0, 0)
			get_entity(boulder[3]).timer = 120
			boulder_spawned = true
		end
	end
	
	--Landmine Bouncing Betties
	local landmines = get_entities_by(ENT_TYPE.ITEM_LANDMINE, MASK.ANY, LAYER.BOTH)
	for i = 1,#landmines do
		local m = get_entity(landmines[i])
		if m ~= nil and m.animation_frame ~= 178 and m.animation_frame ~= 179 and m.timer == 40 then
			m.velocityy = 0.25
		end
	end
	
	--Kirby Olmites
	local olmites = get_entities_by(ENT_TYPE.MONS_OLMITE_HELMET, MASK.ANY, LAYER.BOTH)
	local olmites2 = get_entities_by(ENT_TYPE.MONS_OLMITE_BODYARMORED, MASK.ANY, LAYER.BOTH)
	local olmites3 = get_entities_by(ENT_TYPE.MONS_OLMITE_NAKED, MASK.ANY, LAYER.BOTH)
	for i = 1,#olmites2 do
		olmites[#olmites + 1] = olmites2[i]
	end
	for i = 1,#olmites3 do
		olmites[#olmites + 1] = olmites3[i]
	end
	for i = 1,#olmites do
		local o = get_entity(olmites[i])
		if o ~= nil and o.attack_cooldown_timer == 16 and o.in_stack == false and o.standing_on_uid == -1 then
			local ox, oy, ol = get_position(olmites[i])
			generate_world_particles(PARTICLEEMITTER.ALTAR_MONSTER_APPEAR_POOF, olmites[i])
			o:destroy()
			local block = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, ox, oy, ol, 0, 0)
			get_entity(block).color = Color:red()
			kirby_blocks[#kirby_blocks + 1] = {block, frames, o.health}
		end
	end
	for i = 1,#kirby_blocks do
		if get_entity(kirby_blocks[i][1]) ~= nil and frames - kirby_blocks[i][2] == 120 then
			local bx, by, bl = get_position(kirby_blocks[i][1])
			get_entity(kirby_blocks[i][1]):kill(true, nil)
			local o = spawn(ENT_TYPE.MONS_OLMITE_NAKED, bx, by, bl, 0, 0)
			get_entity(o).health = kirby_blocks[i][3]
		end
	end
end, ON.FRAME)

set_callback(function ()
	--Get ice blocks and thin ice
	ice_blocks = get_entities_by(ENT_TYPE.FLOOR_ICE, MASK.ANY, LAYER.BOTH)
	local thin_ice = get_entities_by(ENT_TYPE.ACTIVEFLOOR_THINICE, MASK.ANY, LAYER.BOTH)
	for i = 1,#thin_ice do
		ice_blocks[#ice_blocks + 1] = thin_ice[i]
	end

	--Replace a gold bar in CO with a random pet
	if state.theme == THEME.COSMIC_OCEAN then
		local gold_bar = get_entities_by(ENT_TYPE.ITEM_GOLDBAR, MASK.ANY, LAYER.BOTH)
		if #gold_bar > 0 then
			local num = math.random(#gold_bar)
			local gx, gy, gl = get_position(gold_bar[num])
			spawn_entity_snapped_to_floor(ENT_TYPE.MONS_PET_DOG + math.random(0,2), gx, gy, gl, 0, 0)
			get_entity(gold_bar[num]):destroy()
		end
	end

	--Give Tikimen random weapons
	local tikiman = get_entities_by(ENT_TYPE.MONS_TIKIMAN, MASK.ANY, LAYER.BOTH)
	for i = 1,#tikiman do
		if get_entity(tikiman[i]) ~= nil then
			local held_item = get_entity(tikiman[i]).holding_uid
			local tx, ty, tl = get_position(tikiman[i])
			local num = math.random(#weapons)
			drop(tikiman[i], held_item)
			get_entity(held_item):destroy()
			pick_up(tikiman[i], spawn_entity_snapped_to_floor(weapons[num], tx, ty, tl, 0, 0))
		end
	end

	--Get only the cat mummies that exist at the start of the level
	cat_mummy = get_entities_by(ENT_TYPE.MONS_CATMUMMY, MASK.ANY, LAYER.BOTH)
	for i = 1,#cat_mummy do
		cat_mummy_state[i] = 0
	end
	
	--Give a random caveman the Udjat Eye (Jungle 2-1 only)
	if state.theme == THEME.JUNGLE and state.level == 1 then
		local cavemen = get_entities_by(ENT_TYPE.MONS_CAVEMAN, MASK.ANY, LAYER.FRONT)
		if #cavemen > 0 then
			local num = math.random(#cavemen)
			pick_up(cavemen[num], spawn(ENT_TYPE.ITEM_PICKUP_UDJATEYE, 0, 0, LAYER.FRONT, 0, 0))
		end
	end
	
	--Replace Tablet of Destiny with Clone Gun / Elixir
	if state.theme == THEME.ABZU then
		replace_drop(DROP.KINGU_TABLETOFDESTINY, ENT_TYPE.ITEM_CLONEGUN)
	elseif state.theme == THEME.DUAT then
		replace_drop(DROP.OSIRIS_TABLETOFDESTINY, ENT_TYPE.ITEM_PICKUP_ELIXIR)
	end
	
	--Set animation frames of all ushabtis to the correct one
	--Freeze all but one ushabti
	--The original correct ushabti will sparkle if the player has the Tablet (gold and jade naturally sparkle, however)
	if state.theme == THEME.NEO_BABYLON and state.level == 2 then
		local ushabtis = get_entities_by(ENT_TYPE.ITEM_USHABTI, MASK.ANY, LAYER.BACK)
		for i = 1,#ushabtis do
			if get_entity(ushabtis[i]).animation_frame ~= state:get_correct_ushabti() then
				get_entity(ushabtis[i]).animation_frame = state:get_correct_ushabti()
				get_entity(ushabtis[i]).flags = set_flag(get_entity(ushabtis[i]).flags, 28)
				get_entity(ushabtis[i]).flags = clr_flag(get_entity(ushabtis[i]).flags, 18)
			elseif get_entity(ushabtis[i]).animation_frame == state:get_correct_ushabti() and entity_has_item_type(players[1].uid, ENT_TYPE.ITEM_POWERUP_TABLETOFDESTINY) then
				generate_world_particles(PARTICLEEMITTER.AU_GOLD_SPARKLES, ushabtis[i])
			end
		end
	end
end, ON.POST_LEVEL_GENERATION)

set_callback(function ()	
	for i = 1,#lizard_callbacks do
		clear_callback(lizard_callbacks[i])
	end
	for i = 1,#giant_spider_callbacks do
		clear_callback(giant_spider_callbacks[i])
	end
	falling_platforms = {}
	sparks = {}
	robots = {}
	robot_exploded = {}
	bats = {}
	volcana_idol = {}
	timed_forcefields = {}
	jiangshi = {}
	flying_fish = {}
	fish_state = {}
	kingu = {}
	lamassu = {}
	lamassu_attack_counter = {}
	timed_kegs = {}
	timed_kegs_triggered = false
	cat_mummy = {}
	cat_mummy_state = {}
	fire_monkeys = {}
	ice_monkeys = {}
	ice_monkey_can_freeze = {}
	ice_blocks = {}
	block_swap = false
	cursed_sorceress = {}
	lizards = {}
	lizard_callbacks = {}
	giant_spider_callbacks = {}
	scepter_shots = {}
	scepter_shot_starting_frame = {}
	shot_direction = {}
	kirby_blocks = {}
	shield_bash_cooldown = 0
	shield_bash_direction = 0
	red_teleporter = 0
	green_teleporter = 0
	frames = 0
	volcana_idol_frames = 0
	poison_distance = 0
	hoverpack_timer = 0
	cold_feet_timer = 0
	cold_feet = false
	boulder_spawned = false
	player_invisible = false
	red_active = false
	red_thrown = false
end, ON.PRE_LEVEL_GENERATION)