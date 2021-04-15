ESX 						   = nil
local CopsConnected       	   = 0
local PlayersHarvestingLukiCoke    = {}
local PlayersTransformingLukiCoke  = {}
local PlayersSellingLukiCoke       = {}
local PlayersHarvestingLukiMeth    = {}
local PlayersTransformingLukiMeth  = {}
local PlayersSellingLukiMeth       = {}
local PlayersHarvestingLukiWeed    = {}
local PlayersTransformingLukiWeed  = {}
local PlayersSellingLukiWeed       = {}
local PlayersHarvestingLukiOpium   = {}
local PlayersTransformingLukiOpium = {}
local PlayersSellingLukiOpium      = {}
local PlayersHarvestingLukiAmfa    = {}
local PlayersTransformingLukiAmfa  = {}
local PlayersSellingLukiAmfa       = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountCops()

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(120 * 1000, CountCops)
end

CountCops()

--coke
local function HarvestLukiCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		 TriggerClientEvent('pNotify:SendNotification', source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke)})
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingLukiCoke[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)
			if xPlayer ~= nil then
				local coke = xPlayer.getInventoryItem('coke')

				if coke.limit ~= -1 and coke.count >= coke.limit then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('inv_full_coke')})
				else
					xPlayer.addInventoryItem('coke', 1)
					HarvestLukiCoke(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestLukiCoke')
AddEventHandler('esx_drugs:startHarvestLukiCoke', function()

	local _source = source

	PlayersHarvestingLukiCoke[_source] = true

	TriggerClientEvent('pNotify:SendNotification', source, {text = _U('pickup_in_prog')})

	HarvestLukiCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestLukiCoke')
AddEventHandler('esx_drugs:stopHarvestLukiCoke', function()

	local _source = source

	PlayersHarvestingLukiCoke[_source] = false

end)

local function TransformLukiCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke)})
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingLukiCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local cokeQuantity = xPlayer.getInventoryItem('coke').count
				local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

				if poochQuantity > 20 then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('too_many_pouches')})
				elseif cokeQuantity < 5 then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('not_enough_coke')})
				else
					xPlayer.removeInventoryItem('coke', 5)
					xPlayer.addInventoryItem('coke_pooch', 1)
				
					TransformLukiCoke(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformLukiCoke')
AddEventHandler('esx_drugs:startTransformLukiCoke', function()

	local _source = source

	PlayersTransformingLukiCoke[_source] = true
 
	TriggerClientEvent('pNotify:SendNotification', source, {text = _U('packing_in_prog')})

	TransformLukiCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformLukiCoke')
AddEventHandler('esx_drugs:stopTransformLukiCoke', function()

	local _source = source

	PlayersTransformingLukiCoke[_source] = false

end)

local function SellLukiCoke(source)

	if CopsConnected < Config.RequiredCopsCoke then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsCoke))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingLukiCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
				else
					xPlayer.removeInventoryItem('coke_pooch', 1)
					if CopsConnected == 0 then
						xPlayer.addAccountMoney('black_money', 3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					elseif CopsConnected == 1 then
						xPlayer.addAccountMoney('black_money', 3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					elseif CopsConnected == 2 then
						xPlayer.addAccountMoney('black_money',3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					elseif CopsConnected == 3 then
						xPlayer.addAccountMoney('black_money', 3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					elseif CopsConnected == 4 then
						xPlayer.addAccountMoney('black_money', 3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					elseif CopsConnected >= 5 then
						xPlayer.addAccountMoney('black_money', 3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_coke'))
					end
					
					SellLukiCoke(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startSellLukiCoke')
AddEventHandler('esx_drugs:startSellLukiCoke', function()

	local _source = source

	PlayersSellingLukiCoke[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellLukiCoke(_source)

end)

RegisterServerEvent('esx_drugs:stopSellLukiCoke')
AddEventHandler('esx_drugs:stopSellLukiCoke', function()

	local _source = source

	PlayersSellingLukiCoke[_source] = false

end)

--meth
local function HarvestLukiMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth)})
		return
	end
	
	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingLukiMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local meth = xPlayer.getInventoryItem('meth')

				if meth.limit ~= -1 and meth.count >= meth.limit then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('inv_full_meth')})
				else
					xPlayer.addInventoryItem('meth', 1)
					HarvestLukiMeth(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestLukiMeth')
AddEventHandler('esx_drugs:startHarvestLukiMeth', function()

	local _source = source

	PlayersHarvestingLukiMeth[_source] = true

	TriggerClientEvent('pNotify:SendNotification', source, {text = _U('pickup_in_prog')})

	HarvestLukiMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestLukiMeth')
AddEventHandler('esx_drugs:stopHarvestLukiMeth', function()

	local _source = source

	PlayersHarvestingLukiMeth[_source] = false

end)

local function TransformLukiMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth)})
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingLukiMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local methQuantity = xPlayer.getInventoryItem('meth').count
				local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

				if poochQuantity > 20 then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('too_many_pouches')})
				elseif methQuantity < 5 then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('not_enough_meth')})
				else
					xPlayer.removeInventoryItem('meth', 5)
					xPlayer.addInventoryItem('meth_pooch', 1)
					
					TransformLukiMeth(source)
				end
			end
		end	
	end)
end

RegisterServerEvent('esx_drugs:startTransformLukiMeth')
AddEventHandler('esx_drugs:startTransformLukiMeth', function()

	local _source = source

	PlayersTransformingLukiMeth[_source] = true

	TriggerClientEvent('pNotify:SendNotification', source, {text = _U('packing_in_prog')})

	TransformLukiMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformLukiMeth')
AddEventHandler('esx_drugs:stopTransformLukiMeth', function()

	local _source = source

	PlayersTransformingLukiMeth[_source] = false

end)

local function SellLukiMeth(source)

	if CopsConnected < Config.RequiredCopsMeth then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsMeth))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingLukiMeth[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local poochQuantity = xPlayer.getInventoryItem('meth_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx:showNotification', _source, _U('no_pouches_sale'))
				else
					xPlayer.removeInventoryItem('meth_pooch', 1)
					if CopsConnected == 0 then
						xPlayer.addAccountMoney('black_money', 2500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected == 1 then
						xPlayer.addAccountMoney('black_money', 2500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected == 2 then
						xPlayer.addAccountMoney('black_money', 2500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected == 3 then
						xPlayer.addAccountMoney('black_money', 2500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected == 4 then
						xPlayer.addAccountMoney('black_money', 2500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected == 5 then
						xPlayer.addAccountMoney('black_money', 2500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					elseif CopsConnected >= 6 then
						xPlayer.addAccountMoney('black_money', 2500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_meth'))
					end
					
					SellLukiMeth(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startSellLukiMeth')
AddEventHandler('esx_drugs:startSellLukiMeth', function()

	local _source = source

	PlayersSellingLukiMeth[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellLukiMeth(_source)

end)

RegisterServerEvent('esx_drugs:stopSellLukiMeth')
AddEventHandler('esx_drugs:stopSellLukiMeth', function()

	local _source = source

	PlayersSellingLukiMeth[_source] = false

end)

--weed
local function HarvestLukiWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('act_imp_police',CopsConnected, Config.RequiredCopsWeed)})
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingLukiWeed[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local weed = xPlayer.getInventoryItem('weed')

				if weed.limit ~= -1 and weed.count >= weed.limit then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('inv_full_weed')})
				else
					xPlayer.addInventoryItem('weed', 1)
					HarvestLukiWeed(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestLukiWeed')
AddEventHandler('esx_drugs:startHarvestLukiWeed', function()

	local _source = source

	PlayersHarvestingLukiWeed[_source] = true

	TriggerClientEvent('pNotify:SendNotification', source, {text = _U('pickup_in_prog')})   

	HarvestLukiWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestLukiWeed')
AddEventHandler('esx_drugs:stopHarvestLukiWeed', function()

	local _source = source

	PlayersHarvestingLukiWeed[_source] = false

end)

local function TransformLukiWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed)})
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingLukiWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local weedQuantity = xPlayer.getInventoryItem('weed').count
				local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

				if poochQuantity > 20 then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('too_many_pouches')})   
				elseif weedQuantity < 5 then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('not_enough_weed')})   
				else
					xPlayer.removeInventoryItem('weed', 5)
					xPlayer.addInventoryItem('weed_pooch', 1)
					
					TransformLukiWeed(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformLukiWeed')
AddEventHandler('esx_drugs:startTransformLukiWeed', function()

	local _source = source

	PlayersTransformingLukiWeed[_source] = true

	TriggerClientEvent('pNotify:SendNotification', source, {text = _U('packing_in_prog')}) 

	TransformLukiWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformLukiWeed')
AddEventHandler('esx_drugs:stopTransformLukiWeed', function()

	local _source = source

	PlayersTransformingLukiWeed[_source] = false

end)

local function SellLukiWeed(source)

	if CopsConnected < Config.RequiredCopsWeed then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsWeed))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingLukiWeed[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local poochQuantity = xPlayer.getInventoryItem('weed_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
				else
					xPlayer.removeInventoryItem('weed_pooch', 1)
					if CopsConnected == 0 then
						xPlayer.addAccountMoney('black_money', 500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
					elseif CopsConnected == 1 then
						xPlayer.addAccountMoney('black_money', 500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
					elseif CopsConnected == 2 then
						xPlayer.addAccountMoney('black_money', 500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
					elseif CopsConnected == 3 then
						xPlayer.addAccountMoney('black_money', 500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
					elseif CopsConnected >= 4 then
						xPlayer.addAccountMoney('black_money', 500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_weed'))
					end
					
					SellLukiWeed(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startSellLukiWeed')
AddEventHandler('esx_drugs:startSellLukiWeed', function()

	local _source = source

	PlayersSellingLukiWeed[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellLukiWeed(_source)

end)

RegisterServerEvent('esx_drugs:stopSellLukiWeed')
AddEventHandler('esx_drugs:stopSellLukiWeed', function()

	local _source = source

	PlayersSellingLukiWeed[_source] = false

end)

--amfa
local function HarvestLukiAmfa(source)

	if CopsConnected < Config.RequiredCopsAmfa then
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsAmfa)}) 
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingLukiAmfa[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)
			if xPlayer ~= nil then
				local amfa = xPlayer.getInventoryItem('amfa') 

				if amfa.limit ~= -1 and amfa.count >= amfa.limit then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('inv_full_amfa')}) 
				else
					xPlayer.addInventoryItem('amfa', 1)
					HarvestLukiAmfa(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestLukiAmfa')
AddEventHandler('esx_drugs:startHarvestLukiAmfa', function()

	local _source = source

	PlayersHarvestingLukiAmfa[_source] = true

	TriggerClientEvent('pNotify:SendNotification', source, {text = _U('pickup_in_prog')}) 

	HarvestLukiAmfa(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestLukiAmfa')
AddEventHandler('esx_drugs:stopHarvestLukiAmfa', function()

	local _source = source

	PlayersHarvestingLukiAmfa[_source] = false

end)

local function TransformLukiAmfa(source)

	if CopsConnected < Config.RequiredCopsAmfa then
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsAmfa)}) 
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingLukiAmfa[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local amfaQuantity = xPlayer.getInventoryItem('amfa').count
				local poochQuantity = xPlayer.getInventoryItem('amfa_pooch').count

				if poochQuantity > 20 then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('too_many_pouches')}) 
				elseif amfaQuantity < 5 then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('not_enough_amfa')}) 
				else
					xPlayer.removeInventoryItem('amfa', 5)
					xPlayer.addInventoryItem('amfa_pooch', 1)
				
					TransformLukiAmfa(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformLukiAmfa')
AddEventHandler('esx_drugs:startTransformLukiAmfa', function()

	local _source = source

	PlayersTransformingLukiAmfa[_source] = true

	TriggerClientEvent('pNotify:SendNotification', source, {text = _U('packing_in_prog')}) 

	TransformLukiAmfa(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformLukiAmfa')
AddEventHandler('esx_drugs:stopTransformLukiAmfa', function()

	local _source = source

	PlayersTransformingLukiAmfa[_source] = false

end)

local function SellLukiAmfa(source)

	if CopsConnected < Config.RequiredCopsAmfa then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsAmfa))   
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingLukiAmfa[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local poochQuantity = xPlayer.getInventoryItem('amfa_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
				else
					xPlayer.removeInventoryItem('amfa_pooch', 1)
					if CopsConnected == 0 then
						xPlayer.addAccountMoney('black_money', 3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_amfa'))
					elseif CopsConnected == 1 then
						xPlayer.addAccountMoney('black_money', 3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_amfa'))
					elseif CopsConnected == 2 then
						xPlayer.addAccountMoney('black_money',3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_amfa'))
					elseif CopsConnected == 3 then
						xPlayer.addAccountMoney('black_money', 3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_amfa'))
					elseif CopsConnected == 4 then
						xPlayer.addAccountMoney('black_money', 3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_amfa'))
					elseif CopsConnected >= 5 then
						xPlayer.addAccountMoney('black_money', 3500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_amfa'))
					end
					
					SellLukiAmfa(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startSellLukiAmfa')
AddEventHandler('esx_drugs:startSellLukiAmfa', function()

	local _source = source

	PlayersSellingLukiAmfa[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellLukiAmfa(_source)

end)

RegisterServerEvent('esx_drugs:stopSellLukiAmfa')
AddEventHandler('esx_drugs:stopSellLukiAmfa', function()

	local _source = source

	PlayersSellingLukiAmfa[_source] = false

end)

--opium

local function HarvestLukiOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium)}) 
		return
	end

	SetTimeout(Config.TimeToFarm, function()

		if PlayersHarvestingLukiOpium[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local opium = xPlayer.getInventoryItem('opium')

				if opium.limit ~= -1 and opium.count >= opium.limit then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('inv_full_opium')}) 
				else
					xPlayer.addInventoryItem('opium', 1)
					HarvestLukiOpium(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startHarvestLukiOpium')
AddEventHandler('esx_drugs:startHarvestLukiOpium', function()

	local _source = source

	PlayersHarvestingLukiOpium[_source] = true

	TriggerClientEvent('pNotify:SendNotification', source, {text = _U('pickup_in_prog')}) 

	HarvestLukiOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopHarvestLukiOpium')
AddEventHandler('esx_drugs:stopHarvestLukiOpium', function()

	local _source = source

	PlayersHarvestingLukiOpium[_source] = false

end)

local function TransformLukiOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium)}) 
		return
	end

	SetTimeout(Config.TimeToProcess, function()

		if PlayersTransformingLukiOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local opiumQuantity = xPlayer.getInventoryItem('opium').count
				local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

				if poochQuantity > 20 then
					TriggerClientEvent('pNotify:SendNotification', source, {text = _U('too_many_pouches')}) 
				elseif opiumQuantity < 5 then
					 TriggerClientEvent('pNotify:SendNotification', source, {text = _U('not_enough_opium')}) 
				else
					xPlayer.removeInventoryItem('opium', 5)
					xPlayer.addInventoryItem('opium_pooch', 1)
				
					TransformLukiOpium(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startTransformLukiOpium')
AddEventHandler('esx_drugs:startTransformLukiOpium', function()

	local _source = source

	PlayersTransformingLukiOpium[_source] = true

	TriggerClientEvent('pNotify:SendNotification', source, {text = _U('packing_in_prog')}) 

	TransformLukiOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopTransformLukiOpium')
AddEventHandler('esx_drugs:stopTransformLukiOpium', function()

	local _source = source

	PlayersTransformingLukiOpium[_source] = false

end)

local function SellLukiOpium(source)

	if CopsConnected < Config.RequiredCopsOpium then
		TriggerClientEvent('esx:showNotification', source, _U('act_imp_police', CopsConnected, Config.RequiredCopsOpium))
		return
	end

	SetTimeout(Config.TimeToSell, function()

		if PlayersSellingLukiOpium[source] == true then

			local _source = source
  			local xPlayer = ESX.GetPlayerFromId(_source)
			if xPlayer ~= nil then
				local poochQuantity = xPlayer.getInventoryItem('opium_pooch').count

				if poochQuantity == 0 then
					TriggerClientEvent('esx:showNotification', source, _U('no_pouches_sale'))
				else
					xPlayer.removeInventoryItem('opium_pooch', 1)
					if CopsConnected == 0 then
						xPlayer.addAccountMoney('black_money', 1500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					elseif CopsConnected == 1 then
						xPlayer.addAccountMoney('black_money', 1500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					elseif CopsConnected == 2 then
						xPlayer.addAccountMoney('black_money', 1500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					elseif CopsConnected == 3 then
						xPlayer.addAccountMoney('black_money', 1500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					elseif CopsConnected == 4 then
						xPlayer.addAccountMoney('black_money', 1500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					elseif CopsConnected >= 5 then
						xPlayer.addAccountMoney('black_money', 1500)
						TriggerClientEvent('esx:showNotification', source, _U('sold_one_opium'))
					end
					
					SellLukiOpium(source)
				end
			end
		end
	end)
end

RegisterServerEvent('esx_drugs:startSellLukiOpium')
AddEventHandler('esx_drugs:startSellLukiOpium', function()

	local _source = source

	PlayersSellingLukiOpium[_source] = true

	TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))

	SellLukiOpium(_source)

end)

RegisterServerEvent('esx_drugs:stopSellLukiOpium')
AddEventHandler('esx_drugs:stopSellLukiOpium', function()

	local _source = source

	PlayersSellingLukiOpium[_source] = false

end)



RegisterServerEvent('esx_drugs:GetUserInventory')
AddEventHandler('esx_drugs:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		TriggerClientEvent('esx_drugs:ReturnInventory', 
			_source, 
			xPlayer.getInventoryItem('coke').count,
			xPlayer.getInventoryItem('coke_pooch').count,
			xPlayer.getInventoryItem('meth').count,
			xPlayer.getInventoryItem('meth_pooch').count,
			xPlayer.getInventoryItem('weed').count,
			xPlayer.getInventoryItem('weed_pooch').count,
			xPlayer.getInventoryItem('opium').count,
			xPlayer.getInventoryItem('opium_pooch').count,
			xPlayer.getInventoryItem('amfa').count,
			xPlayer.getInventoryItem('amfa_pooch').count,
			xPlayer.job.name,
			currentZone
		)
	end
end)

ESX.RegisterUsableItem('weed', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		xPlayer.removeInventoryItem('weed', 1)

		TriggerClientEvent('esx_drugs:onPot', _source)
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('used_one_weed')}) 
	end
end)

ESX.RegisterUsableItem('coke1', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		xPlayer.removeInventoryItem('coke1', 1)

		TriggerClientEvent('esx_drugs:onKoka', _source)
		TriggerClientEvent('esx_status:add', source, 'thirst', 500000)
		TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
		TriggerClientEvent('pNotify:SendNotification', source, {text = _U('used_one_koka')}) 
	end
end)

