ESX = exports["es_extended"]:getSharedObject()

-- Register all items from the config File
for k, v in pairs(Config.Outfits) do
	ESX.RegisterUsableItem(k, function(playerId)
		local isInUniform = false

		local xPlayer = ESX.GetPlayerFromId(playerId)
		-- Check is User in Uniform
		local identifier = xPlayer.identifier
		local result = MySQL.Sync.fetchAll("SELECT * FROM `uniforms` WHERE identifier = @identifier",
			{ ['@identifier'] = identifier })
		print(identifier)
		print(ESX.DumpTable(result))
		if next(result) ~= nil then
			isInUniform = true
		end

		-- Trigger Client Event
		xPlayer.triggerEvent('revios_uniforms:useItem', k, v, isInUniform)
	end)
end

-- SQL Functions
MySQL.ready(function()
	MySQL.Async.fetchAll("SELECT * FROM `uniforms`"
		, {}, function()
		print("Uniforms database is ready")
	end)
end)

ESX.RegisterServerCallback("revios_uniforms:getOldSkin", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll("SELECT * FROM `uniforms` WHERE `identifier` = @identifier", {
		['@identifier'] = identifier
	}, function(result)
		if result[1] ~= nil then
			cb(json.decode(result[1]['oldskin']))
		else
			cb(nil)
		end
	end)
end)

RegisterNetEvent("revios_uniforms:removeOutfit", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.execute("DELETE FROM `uniforms` WHERE `identifier` = @identifier", {
		['@identifier'] = identifier
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print("Error: Could not remove Outfit")
		end
	end)
end)

ESX.RegisterServerCallback("revios_uniforms:getActiveSkin"
	, function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local result = MySQL.Sync.fetchAll("SELECT skin FROM users WHERE identifier = @identifier",
		{ ['@identifier'] = identifier })
	if result[1].skin ~= nil then
		local skin = json.decode(result[1].skin)
		cb(skin)
	else
		cb(nil)
	end
end)



--[[
	revios_uniforms:getActiveSkinData

	Search is any outfit is active in the database

	if not then save the current skin
	if yes then load the oldOutfit and the current skin

]]

ESX.RegisterServerCallback('revios_uniforms:saveOutfitSkin', function(source, cb, uniformName)
	if Config.DEBUG then
		print("uniformName: " .. uniformName)
	end

	-- GET identifier
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	-- GET Skin
	local result = MySQL.Sync.fetchAll("SELECT skin FROM users WHERE identifier = @identifier",
		{ ['@identifier'] = identifier })
	if result[1].skin == nil then
		cb(false)
	end
	local oldSkin = result[1].skin
	MySQL.Sync.execute("INSERT INTO `uniforms`(`identifier`, `oldskin`, `uniform`) VALUES (@identifier,@oldSkin,@uniformName)"
		, { ['@identifier'] = identifier, ['oldSkin'] = oldSkin, ['uniformName'] = uniformName })
	cb(true)
end)
