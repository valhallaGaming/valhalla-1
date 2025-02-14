local ped = createPed(123, 224.0537109375, 112.4599609375, 1010.2117919922)
local ped2 = createPed(123, 1025.2021484375, -901.103515625, 41.983009338379)
setElementInterior(ped, 10)
setElementDimension(ped, 9001)
setPedRotation(ped2, 180)
addEventHandler("onClientPedDamage", ped, cancelEvent)
addEventHandler("onClientPedDamage", ped2, cancelEvent)
local vehElements = {}
car, wImpound, bClose, bRelease, gCars, lCost, IDcolumn = nil

function showImpoundUI(vehElementsret)
	if not wImpound then
		local width, height = 400, 200
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth - width
		local y = scrHeight/10
		
		wImpound = guiCreateWindow(x, y, width, height, "Impound: Release a vehicle", false)
		guiWindowSetSizable(wImpound, false)
		
		bClose = guiCreateButton(0.6, 0.85, 0.2, 0.1, "Close", true, wImpound)
		bRelease = guiCreateButton(0.825, 0.85, 0.2, 0.1, "Release", true, wImpound)
		addEventHandler("onClientGUIClick", bClose, hideImpoundUI, false)
		addEventHandler("onClientGUIClick", bRelease, releaseCar, false)
		

		gCars = guiCreateGridList(0.05, 0.1, 0.9, 0.65, true, wImpound)
		addEventHandler("onClientGUIClick", gCars, updateCar, false)
		local col = guiGridListAddColumn(gCars, "Impounded Vehicles", 0.7)
		IDcolumn = guiGridListAddColumn(gCars, "ID", 0.2)
		vehElements = vehElementsret
		for key, value in ipairs(vehElements) do
			local dbid = getElementData(value, "dbid")
			local row = guiGridListAddRow(gCars)
			guiGridListSetItemText(gCars, row, col, getVehicleName(value), false, false)
			guiGridListSetItemText(gCars, row, IDcolumn, tostring(dbid), false, false)
		end
		guiGridListSetSelectedItem(gCars, 0, 1)
		
		lCost = guiCreateLabel(0.3, 0.85, 0.2, 0.1, "Cost: 75$", true, wImpound)
		guiSetFont(lCost, "default-bold-small")
		
		updateCar()
			

		guiSetInputEnabled(true)
		
		outputChatBox("Welcome to The Impound lot.")
	end
end

function updateCar()
	local row, col = guiGridListGetSelectedItem(gCars)
	
	if (row~=-1) and (col~=-1) then
		guiSetText(lCost, "Cost: 75$")
		
		if not exports.global:hasMoney(getLocalPlayer(), 75) and exports.global:hasItem(getLocalPlayer(), 3, guiGridListGetItemText(gCars, row, IDcolumn)) then
			guiLabelSetColor(lCost, 255, 0, 0)
			guiSetEnabled(bRelease, false)
		else
			guiLabelSetColor(lCost, 0, 255, 0)
			guiSetEnabled(bRelease, true)
		end
	else
		guiSetEnabled(bRelease, false)
	end
end


function hideImpoundUI()
	destroyElement(bClose)
	bClose = nil
	
	destroyElement(bRelease)
	bRelease = nil

	
	destroyElement(wImpound)
	wImpound = nil
	
	--removeEventHandler("onClientRender", getRootElement(), rotateCar)
	
	setCameraTarget(getLocalPlayer())
	guiSetInputEnabled(false)
end

function releaseCar(button)
	if (button=="left") then
		local row = guiGridListGetSelectedItem(gCars)
		hideImpoundUI()
		triggerServerEvent("releaseCar", getLocalPlayer(), vehElements[row+1])
	end
end
addEvent("ShowImpound", true)
addEventHandler("ShowImpound", getRootElement(), showImpoundUI)
