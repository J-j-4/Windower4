function job_self_command(commandArgs,eventArgs)

	if commandArgs[1] == 'trade_ring' then
		trade_ring()
	elseif commandArgs[1] == 'trade_earring1' then
		trade_earring1()
	elseif commandArgs[1] == 'trade_earring2' then
		trade_earring2()
	elseif commandArgs[1] == 'regear' then
		regear()
	elseif commandArgs[1] == 'custom_treasure_cycle' then
		custom_treasure_cycle()
	elseif commandArgs[1]:lower() == 'siphon' then
        handle_siphoning()
        eventArgs.handled = true
    elseif commandArgs[1]:lower() == 'pact' then
        handle_pacts(commandArgs)
        eventArgs.handled = true
    elseif commandArgs[1] == 'reset_ward_flag' then
        wards.flag = false
        wards.spell = ''
        eventArgs.handled = true
    end
	
end

function initialize_job()
	
	daytime = world.time <= (18*60) and world.time >= (6*60)
	duskdawn = (world.time >= (17*60) and world.time <= (18*60)) and (world.time >= (6*60) and world.time <= (7*60))
	
	gear.TRing1 = { name="Toreador's Ring", augments={'"Triple Atk."+2','Dark resistance+12',}}
	gear.TRing2 = { name="Toreador's Ring", augments={'MND-3','"Triple Atk."+2',}}
	
	gear.main = player.equipment.main
	gear.sub = player.equipment.sub
	
	select_default_macro_book()
	set_custom_universal_keybinds()
	
	windower.register_event('zone change', 
	function(new, old)
		send_command('gs c update')
		send_command('treasury clearall')
	end)

	windower.register_event('time change', 
	function(new, old)
		if new == (17*60) or new == (18*60) or new == (6*60) or new == (7*60) then
			if new == (17*60) then
				duskdawn = true
			elseif new == (18*60) then
				daytime = false
			elseif new == (6*60) then
				daytime = true
			elseif new == (7*60) then
				duskdawn = false
			end
			if not midaction() then
				send_command('gs c update')
			else
				add_to_chat('Time change midaction.')
			end
		end
	end)
	
end

function set_custom_universal_keybinds()

	-- Defensive cycles
	send_command('bind f9 gs c cycle PhysicalDefenseMode')
	send_command('bind f10 gs c set DefenseMode Physical')
	send_command('bind f11 gs c set DefenseMode Magical')
	send_command('bind f12 gs c reset DefenseMode')
	
	-- Offensive cycles
	send_command('bind ^f9 gs c cycle OffenseMode')
	send_command('bind ^f10 gs c cycle WeaponskillMode')
	send_command('bind ^f11 gs c cycle RangedMode')
	send_command('bind ^f12 gs c cycle CastingMode')
	
	-- Misc. cycles
	-- F9 left out for customs
	send_command('bind !f10 gs c update')
	send_command('bind !f11 gs c regear')
	send_command('bind !f12 gs reload')
	
	-- Trade functions
	send_command('bind !x gs c trade_earring1')
	send_command('bind !c gs c trade_earring2')
	send_command('bind !v gs c trade_ring')

end

function trade_ring()
	
	local currentRing
	
	if player.inventory['Rajas Ring'] then
		currentRing = 'Rajas Ring'
	elseif player.inventory['Tamas Ring'] then
		currentRing = 'Tamas Ring'
	elseif player.inventory['Sattva Ring'] then
		currentRing = 'Sattva Ring'
	end
	
	if player.target.name == "Runga-Kopunga" then
		send_command('@input /item "'..currentRing..'" <t> ')
	else
		add_to_chat("Please target Runga-Kopunga!")
		return
	end
	
end

function trade_earring1()
	
	local currentEarring	
	
	if player.inventory['Abyssal Earring'] then
		currentEarring = 'Abyssal Earring'
	elseif player.inventory['Beastly Earring'] then
		currentEarring = 'Beastly Earring'
	elseif player.inventory['Bushinomimi'] then
		currentEarring = 'Bushinomimi'
	elseif player.inventory["Knight\'s Earring"] then
		currentEarring = 'Knight\'s Earring'
	elseif player.inventory['Suppanomimi'] then
		currentEarring = 'Suppanomimi'
	end
	
	if player.target.name == "Runga-Kopunga" then
		send_command('@input /item "'..currentEarring..'" <t> ')
	else
		add_to_chat("Please target Runga-Kopunga!")
		return
	end
	
end

function trade_earring2()
	
	local currentEarring	
	
	if player.inventory['Ethereal Earring'] then
		currentEarring = 'Ethereal Earring'
	elseif player.inventory['Hollow Earring'] then
		currentEarring = 'Hollow Earring'
	elseif player.inventory['Magnetic Earring'] then
		currentEarring = 'Magnetic Earring'
	elseif player.inventory['Static Earring'] then
		currentEarring = 'Static Earring'
	end
	
	if player.target.name == "Runga-Kopunga" then
		send_command('@input /item "'..currentEarring..'" <t> ')
	else
		add_to_chat("Please target Runga-Kopunga!")
		return
	end
	
end

function job_sub_job_change(new,old)

	select_default_macro_book()

end

function select_default_macro_book()
	
	local mainjobs = {'WAR','MNK','WHM','BLM','RDM','THF','PLD','DRK','BST','BRD','RNG','SAM','NIN','DRG','SMN','BLU','COR','PUP','DNC','SCH'}
	local commonsubs = {'NIN','DNC','WAR','SAM','THF','WHM','RDM','SCH','BLM','DRK'}
	
	local mainpage
	local subpage
	
	if player.main_job ~= 'SMN' then
		for mainjob = 1,20 do
			if player.main_job == mainjobs[mainjob] then
				mainpage = mainjob
				add_to_chat('Main job '..player.main_job..': Macro Book '..mainjob..'.')
			end
		end
		
		for subjob = 1,10 do
			if player.sub_job == commonsubs[subjob] then
				subpage = subjob
				add_to_chat('Sub job '..player.sub_job..': Macro Page '..subjob..'.')
			end
		end
		
		set_macro_page(subpage,mainpage)
	end
	
end

function regear()
	
	equip({main=gear.main,sub=gear.sub})
	send_command('gs c update')
	add_to_chat('Regeared: ' .. gear.main .. ' and ' .. gear.sub)
	
end

function sleep_swap(name,gain)

    local neckpiece

    if name == 'sleep' then
        if gain then
            if player.main_job == 'WAR' or player.main_job == 'PLD' or player.main_job == 'DRK' or player.main_job == 'SAM' or player.main_job == 'DRG' then
                neckpiece='Berserker\'s torque'
            else
                neckpiece='Opo-opo necklace'
            end
            equip({neck=neckpiece})
        else
            send_command('gs c update')
        end
    end

end

function ammo_recharge()

	if player.equipment.ammo == 'empty' then
		if player.inventory[gear.ammo] then
			add_to_chat("Replenishing "..gear.ammo.."s.")
			equip({ammo=gear.ammo})
		else
			add_to_chat("No more "..gear.ammo.."s.")
		end
	else
		gear.ammo = player.equipment.ammo
	end

end