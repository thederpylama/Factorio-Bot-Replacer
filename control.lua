script.on_event(defines.events.on_tick, function(event)
	local modTick = game.tick % 600
	local theItemRequest
	local theSizeRequest                      

	if modTick == 0 then
		local modchests = {}
		local items = {}
		local counter
		for i, force in pairs(game.forces) do 
			for ii, surface in pairs(force.logistic_networks) do 
				for ii, network in pairs(surface) do  
					counter = ii
					for iii, modchest in pairs(network.requesters) do
						local inc = 0
						if modchest.name == "logistic-chest-botRequester" then
							local inventory = modchest.get_inventory(defines.inventory.chest)
							

							table.insert(modchests, modchest)

						end
					end

					doUpgrade(network, modchests)
					
					modchests = {}
				end
			end
		end
	end
	
end
)

function doUpgrade(network, modchests)
	local roboportWithInventory = {}
	local chestWithRequest = {}
	local destination
	local numRoboPorts
	local roboport

	for i, cell in pairs(network.cells) do 
		local owner = cell.owner
		local inventory = owner.get_inventory(defines.inventory.roboport_robot)

		if owner.type == "roboport" and inventory.is_empty() == false then
			table.insert(roboportWithInventory, owner)
		end
	end
	
	for i, modchest in pairs (modchests) do
		local itemRequest
		local sizeRequest = 0
		local diff = 0
		local count
		local source = modchest.get_inventory(defines.inventory.chest)
		local totalAvailable = 0
		local totalInsert = 0

		if modchest.get_request_slot(1) ~= nil then
								
			for iiii, out in pairs(modchest.get_request_slot(1)) do

				if iiii == "name" then
					
					itemRequest = out

				end
				if iiii == "count" then

					sizeRequest = out


				end
	
			end

		end

		--remove products

		if modchest.get_inventory(defines.inventory.chest).is_empty() ==  false then

			for itemSource, sizeSource in pairs(source.get_contents()) do
				if itemSource ~= itemRequest then
					source.remove({name=itemSource, count=sizeSource})

					for index=1, sizeSource do 
						modchest.surface.create_entity{name = game.item_prototypes[itemSource].place_result.name, position = modchest.position, force=modchest.force}
					end
				end
			end
		end

		--request for chest with items

		if modchest.get_request_slot ~= nil and modchest.get_inventory(defines.inventory.chest).is_empty() == false then
			for itemSource, sizeSource in pairs(source.get_contents()) do
				if itemSource == itemRequest then
					diff = sizeRequest - sizeSource
				end
				for ii, roboport in pairs (roboportWithInventory) do
					local destination = roboport.get_inventory(defines.inventory.roboport_robot)
					for itemDestination, sizeDestination in pairs(destination.get_contents()) do
						local x
						if itemDestination == itemRequest then
							totalAvailable = totalAvailable + sizeDestination

							if totalAvailable < diff then
								totalInsert = totalInsert + sizeDestination
								destination.remove({name=itemDestination, count=sizeDestination})
								network.insert({name=itemDestination, count=sizeDestination})
							end
		
							if totalAvailable >= diff then
								x = sizeDestination - (totalAvailable - diff)
								totalInsert = totalInsert + x

								if x > 0 then
								destination.remove({name=itemDestination, count=x})
								network.insert({name=itemDestination, count=x})
								end
							end
						end
					end
				end
			end
		end
		
		--request for empty chest

		if modchest.get_request_slot ~= nil and modchest.get_inventory(defines.inventory.chest).is_empty() ==  true then
			for ii, roboport in pairs (roboportWithInventory) do
				local destination = roboport.get_inventory(defines.inventory.roboport_robot)
				for itemDestination, sizeDestination in pairs(destination.get_contents()) do
					local x
					if itemDestination == itemRequest then
						totalAvailable = totalAvailable + sizeDestination

						if totalAvailable < sizeRequest then
							destination.remove({name=itemDestination, count=sizeDestination})
							network.insert({name=itemDestination, count=sizeDestination})
						end
		
						if totalAvailable >= sizeRequest then
							x = sizeDestination - (totalAvailable - sizeRequest)
							if x > 0 then
								destination.remove({name=itemDestination, count=x})
								network.insert({name=itemDestination, count=x})
							end
						end
					end
				end
			end
		end
	end
end

function matchType (source, destination)
	if source ~= destination and game.item_prototypes[source].place_result ~= nil and game.item_prototypes[source].place_result.type == game.item_prototypes[destination].place_result.type then
		return true
	end
end

function debugPrint(thing)
	for _, player in pairs(game.players) do
		player.print(serpent.block(thing))
	end
end