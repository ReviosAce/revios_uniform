ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('revios_uniforms:useItem')
AddEventHandler('revios_uniforms:useItem', function(outfitName, outfitTable, isInUniform)
	if Config.DEBUG then
		print("revios_uniforms:useItem")
		print("outfitName: " .. outfitName)
	end

	print("outfitTable: \n" .. ESX.DumpTable(outfitTable))

	if isInUniform then
		if Config.DEBUG then
			print("Player is in a Uniform already")
		end
		ESX.TriggerServerCallback("revios_uniforms:getOldSkin", function(oldSkin)
			if oldSkin ~= nil then
				if Config.DEBUG then
					print("oldSkin: \n" .. ESX.DumpTable(oldSkin))
				end
				TriggerEvent("skinchanger:loadSkin", oldSkin)
				ESX.ShowNotification("Du hast dein Outfit ausgezogen!")
			else
				print("Error: cannot load oldSkin")
			end
		end)
		TriggerServerEvent("revios_uniforms:removeOutfit")
	else
		ESX.TriggerServerCallback("revios_uniforms:getActiveSkin", function(Outfit)
			if Config.Debug then
				print("AktiveOutfit: \n" .. ESX.DumpTable(Outfit))
				print("outfitTable: \n" .. ESX.DumpTable(outfitTable))
			end
			-- TODO: Save old Skin
			print("Save Skin")
			ESX.TriggerServerCallback('revios_uniforms:saveOutfitSkin', function(success)
				print("in Save Skin")

				if success then
					if Outfit['sex'] == 0 then
						TriggerEvent("skinchanger:loadSkin", outfitTable['male'])
						ESX.ShowNotification("Du hast dein Outfit angezogen!")
					elseif Outfit['sex'] == 1 then
						TriggerEvent("skinchanger:loadSkin", outfitTable['female'])
						ESX.ShowNotification("Du hast dein Outfit angezogen!")
					end
				else
					print("Error: Could not save Outfit")
				end
			end, outfitName)

		end)
	end
end)
