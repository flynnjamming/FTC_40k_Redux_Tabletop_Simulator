-- FTC-GUID: 738804
-- CONTENT:
-- size changer manager
-- deploy zones manager
-- objectives manager
-- game manager

keepForTerrainEditor = true

secondaryObj_GUID = {"cff35b","471de1"}

cpCounter_GUID={"e446f7","deb9f2","cb0096","94093c"}

function onLoad(saved_data)
    --self.setPosition({40,-4,0})
    self.setRotation({0,270,0})
    -- load from saved
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        gameMode = loaded_data.svgameMode
        inGame = loaded_data.svinGame
        currentTurn = loaded_data.svcurrentTurn
        currentPhase = loaded_data.svcurrentPhase
        mapSizeSelected = loaded_data.svmapSizeSelected
        sizeConfirmed=loaded_data.svsizeConfirmed
        deployTypeSelected = loaded_data.svdeployTypeSelected
        deploySelected = loaded_data.svdeploySelected
        areaPlaced = loaded_data.svareaPlaced
        deploymentIngamePlaced = loaded_data.svdeploymentIngamePlaced
        objectivesTypeSelected = loaded_data.svobjectivesTypeSelected
        objectivesSelected = loaded_data.svobjectivesSelected
    end

    --mapSizeSelected=2
--    objectivesTypeSelected = 4
--    objectivesSelected = #objectivesData[objectivesTypeSelected].objectivesList

--    deployTypeSelected = 8
--    deploySelected = #DeployZonesData[deployTypeSelected].zones

    --objectivesSelected=#objectivesData[sizeSelected]
    --print("objSel: "..objectivesSelected)
    mat = getObjectFromGUID(mat_GUID)
    if simulation then print("THIS IS "..currentTurn.." TURN") end
    -- DEPLOY MENU VARIABLES
    if sizeData[mapSizeSelected].type == "30k" then
        phases=phases30k
    else
        phases=phases40k
    end

    -- REST OF CODE
    redTurnCounter = getObjectFromGUID("055302")
    blueTurnCounter = getObjectFromGUID("7e4111")
    gameTurnCounter = getObjectFromGUID("ee92cf")
    redCpCounter = getObjectFromGUID(cpCounter_GUID[1])
    blueCpCounter = getObjectFromGUID(cpCounter_GUID[2])
	orangeCpCounter = getObjectFromGUID(cpCounter_GUID[3])
	cyanCpCounter = getObjectFromGUID(cpCounter_GUID[4])
    if inGame == false then
        --broadcastToAll("The mod will keep track of how many times a game is started or a map is exported.\nNo other data will be sent!", "Orange")
        Notes.setNotes(notePadTxt)
    else
        Notes.setNotes("")
    end
    if deploymentIngamePlaced == true then
        deployIngameBtn.label = deployIngameLblOpen
    else
        deployIngameBtn.label = deployIngameLblClosed
    end
    if areaPlaced == true then
        areaBtn.label = areaLblOpen
    else
        areaBtn.label = areaLblClosed
    end
    gameTurnCounter.call("checkGameEnd")
    writeMenus()
    if not inGame then
        makeAnnouncement()
    end
end

function onSave()
    saved_data = JSON.encode({
        svinGame = inGame,
        svgameMode = gameMode,
        svcurrentTurn = currentTurn,
        svcurrentPhase = currentPhase,
        svmapSizeSelected=mapSizeSelected,
        svsizeConfirmed=sizeConfirmed,
        svdeployTypeSelected = deployTypeSelected,
        svdeploySelected = deploySelected,
        svareaPlaced = areaPlaced,
        svdeploymentIngamePlaced = deploymentIngamePlaced,
        svobjectivesTypeSelected = objectivesTypeSelected,
        svobjectivesSelected = objectivesSelected,
    })
    --saved_data = ""
    return saved_data
end


function makeAnnouncement()
    local features={
    'Implemented objective marker changes, strategic reserve board edges, and For the Dark Gods button, scripted by ThePants999 (or other contributors to his github)',
    'Corrected world eater secondary typos',
    'Corrected token sizing and placement'
    }
    printToAll("NEW FEATURES:", "Yellow")
    for i, new in ipairs(features) do
        printToAll("- "..new, "Yellow")
    end
end

-- SIZE CHANGER MANAGER
positionValue={0,-9.52,0}
sizeData={
    {type="9th", id=1, name='4 0 k   C o m b a t     P a t r o l - 44" x 30"', scale={1.22,1,0.83}, defaultObjectives=0},
    {type="9th", id=2, name='4 0 k   I n c u r s i o n - 44" x 30"', scale={1.22,1,0.83}, defaultObjectives=0},
    {type="9th", id=3, name='4 0 k   S t r i k e   F o r c e - 44" x 60"', scale={0.83*2,1,1.22}, defaultObjectives=0},
    {type="9th", id=4, name='4 0 k   O n s l a u g h t - 44" x 90"', scale={0.83*3,1,1.22}, defaultObjectives=0},
    {type="30k", id=6, name="3 0 k   P r a e t o r - 6' x 4'", scale={2,1,1.333}, defaultObjectives=0},
    {type="30k", id=7, name="3 0 k   W a r m a s t e r - 8' x 4'", scale={2.66,1,1.333}, defaultObjectives=0},
}

menuSizeX = 0
menuSizeY = 5
menuSizeZ = 25
arrowOffset=9.5

mapSizeSelected=2
numberSizes=#sizeData
sizeConfirmed=false

sizeMenuBtn={
    index=1, label="S E L E C T     B A T T L E F I E L D     S I Z E", click_function="none", function_owner=self,
    position={menuSizeX, menuSizeY ,menuSizeZ-2.05}, rotation={0,0,0}, height=450, width=8000, scale = {1.3,1.3,1.3},
    font_size=300, color={0,0,0}, font_color={1,1,1}
}

sizeBtn={
    index= i, label="Zone", click_function="none", function_owner=self,
    position={-menuSizeX, menuSizeY ,menuSizeZ}, rotation={0,0,0}, height=450, width=6000,scale = {1.3,1.3,1.3},
    font_size=300, color={0.6,0.6,0.6}, font_color={0,0,0}
}
sizeUpBtn={
    index=1, label="->", click_function="sizeUp", function_owner=self,
    position={-menuSizeX+arrowOffset, menuSizeY ,menuSizeZ}, rotation={0,0,0}, height=450, width=800,scale = {1.3,1.3,1.3},
    font_size=300, color={0,0,0}, font_color={1,1,1}
}
sizeDownBtn={
    index=1, label="<-", click_function="sizeDown", function_owner=self,
    position={-menuSizeX-arrowOffset, menuSizeY ,menuSizeZ}, rotation={0,0,0}, height=450, width=800,scale = {1.3,1.3,1.3},
    font_size=300, color={0,0,0}, font_color={1,1,1}
}
confirmBtn={
    index= i, label="C O N F I R M\nFOR GAMING", click_function="confirmSizeGame", function_owner=self,
    position={-menuSizeX, menuSizeY ,menuSizeZ+3.5}, rotation={0,0,0}, height=1400, width=4400, scale = {1.3,1.3,1.3},
    font_size=500, color={0,0.7,0}, font_color={0,0,0}
}
confirmBtn2={
    index= i, label="C O N F I R M\nFOR MAP MAKING", click_function="confirmSizeTerrain", function_owner=self,
    position={-menuSizeX, menuSizeY ,menuSizeZ+7.5}, rotation={0,0,0}, height=1400, width=4400, scale = {1.3,1.3,1.3},
    font_size=500, color={0.7,0,0}, font_color={0,0,0}
}

function refreshMat()
    mat = getObjectFromGUID("4ee1f2")
end

function writeSizeMenu()
    self.clearButtons()
    if sizeConfirmed then
        return
    end
    self.createButton(sizeMenuBtn)
    sizeBtn.label=sizeData[mapSizeSelected].name
    self.createButton(sizeBtn)
    self.createButton(sizeUpBtn)
    self.createButton(sizeDownBtn)
    self.createButton(confirmBtn)
    self.createButton(confirmBtn2)
    mat.setScale(sizeData[mapSizeSelected].scale)
    mat.setPosition(positionValue)
end

function sizeUp()
    sizeUpDown(1)
end

function sizeDown()
    sizeUpDown(-1)
end

function sizeUpDown(increment)
    mapSizeSelected=mapSizeSelected+increment
    if mapSizeSelected > #sizeData then
        mapSizeSelected=1
    end
    if mapSizeSelected < 1 then
        mapSizeSelected=#sizeData
    end
    updateDeployObjectivesSelection()
    deployTypeUpDown(nil)
    writeMenus()
end

function confirmSizeGame()
    confirmSizeMat("game")
end

function confirmSizeTerrain()
    confirmSizeMat("terrain")
end

function confirmSizeMat(type)
    gameMode= type
    sizeConfirmed=true
    mat.setScale(sizeData[mapSizeSelected].scale)
    if sizeData[mapSizeSelected].type == "30k" then

        phases=phases30k
    else
        phases=phases40k
    end
    self.setRotation({0,270,0})
    writeMenus()
    if gameMode == "game" then
    end
    if gameMode == "terrain" then
        switchToTerrainEditor()
    end
end

function updateDeployObjectivesSelection()
    for i, deploy in ipairs(DeployZonesData) do
        if deploy.id == sizeData[mapSizeSelected].id then
            deployTypeSelected = i
        end
    end
    for i, objectives in ipairs(objectivesData) do
        if objectives.id == sizeData[mapSizeSelected].id then
            objectivesTypeSelected = i
        end
    end
    deploySelected = #DeployZonesData[deployTypeSelected].zones
    objectivesSelected = #objectivesData[objectivesTypeSelected].objectivesList
end

function switchToTerrainEditor()
    printToAll("Deleting unnecessary things.\nPLEASE WAIT..", "Yellow")
    local pos={}
    for i, obj in ipairs(getAllObjects()) do
        pos=obj.getPosition()
        if ((pos.y > -8 and pos.y < 0.36) or pos.y > 0.71) and not obj.getVar("keepForTerrainEditor") then
            obj.destroy()
        end
    end
    printToAll("DONE!", "Yellow")
end
-- END size changer

objectivesData = {
    {   id=1 , type = "Combat Patrol",
        objectivesList={
            {id = 1, name = "Eternal War #1 Incisive attack", objectives = {{type = "fixed", pos={16, objectivesOffset, 0}},{type = "fixed", pos={-16, objectivesOffset, 0}},{type = "fixed", pos={0, objectivesOffset, 9}},{type = "fixed", pos={0, objectivesOffset, -9}}}},
            {id = 2, name = "Eternal War #2 Outriders", objectives = {{type = "fixed", pos={14, objectivesOffset, 9}},{type = "fixed", pos={14, objectivesOffset, -9}},{type = "fixed", pos={-14, objectivesOffset, 9}},{type = "fixed", pos={-14, objectivesOffset, -9}}}},
            {id = 3, name = "Eternal War #3 Encircle", objectives = {{type = "fixed", pos={16, objectivesOffset, 3}},{type = "fixed", pos={6, objectivesOffset, -6}},{type = "fixed", pos={-16, objectivesOffset, -3}},{type = "fixed", pos={-6, objectivesOffset, 6}}}},

            {id = 4, name = "Crusade #1 Sweep and Clear", objectives = {{type = "fixed", pos={2, objectivesOffset, 2}},{type = "fixed", pos={2, objectivesOffset, -2}},{type = "fixed", pos={-2, objectivesOffset, 2}},{type = "fixed", pos={-2, objectivesOffset, -2}}}
},
            {id = 5, name = "Crusade #2 Supply drop", objectives = {{type = "fixed", pos={2, objectivesOffset, 2}},{type = "fixed", pos={2, objectivesOffset, -2}},{type = "fixed", pos={-2, objectivesOffset, 2}}}},

            {id = 0, name = "None", objectives = {} },
        }
    },
    {   id=2 , type = "Incursion",
        objectivesList={
            {id = 12, name = "#11 Cleanse The Land", objectives = {{type = "fixed", pos={12, objectivesOffset, 9}},{type = "fixed", pos={-12, objectivesOffset, -9}},{type = "fixed", pos={12, objectivesOffset, -9}},{type = "fixed", pos={-12, objectivesOffset, 9}},{type = "fixed", pos={0, objectivesOffset, 0}}}},
            {id = 13, name = "#12 Deliverance", objectives = {{type = "diagonal", pos={14, objectivesOffset}, orientation = "xz"}, {type = "diagonal", pos={14, objectivesOffset}, orientation = "-x-z"}, {type = "diagonal", pos={14, objectivesOffset}, orientation = "-xz"}, {type = "diagonal", pos={14, objectivesOffset}, orientation = "x-z"},{type = "fixed", pos={0, objectivesOffset, 0}}}},
            {id = 14, name = "#13 Desperate Raid", objectives = {{type = "fixed", pos={16, objectivesOffset, -6}},{type = "fixed", pos={16, objectivesOffset, 10}},{type = "fixed", pos={-16, objectivesOffset, -10}},{type = "fixed", pos={-16, objectivesOffset, 6}},{type = "fixed", pos={0, objectivesOffset, 8}},{type = "fixed", pos={0, objectivesOffset, -8}}}},
            {id = 15, name = "#21 Sacred Ground", objectives = {{type = "fixed", pos={16.83, objectivesOffset, -8}},{type = "fixed", pos={-16.83, objectivesOffset, 8}},{type = "fixed", pos={0, objectivesOffset, 8}},{type = "fixed", pos={0, objectivesOffset, -8}}}},
            {id = 16, name = "#22 Ascension", objectives = {{type = "fixed", pos={8, objectivesOffset, -8}},{type = "fixed", pos={-16, objectivesOffset, -8}},{type = "fixed", pos={16, objectivesOffset, 8}},{type = "fixed", pos={-8, objectivesOffset, 8}},{type = "fixed", pos={0, objectivesOffset, 0}}}},
            {id = 17, name = "#23 Surge of Faith", objectives = {{type = "fixed", pos={16, objectivesOffset, 6}},{type = "fixed", pos={3, objectivesOffset, -9}},{type = "fixed", pos={-3, objectivesOffset, 9}},{type = "fixed", pos={-16, objectivesOffset, -6}}}},
            {id = 18, name = "#31 Rise of the Machine Spirit", objectives = {{type = "diagonal", pos={14, objectivesOffset}, orientation = "xz"}, {type = "diagonal", pos={14, objectivesOffset}, orientation = "-x-z"}, {type = "diagonal", pos={14, objectivesOffset}, orientation = "-xz"}, {type = "diagonal", pos={14, objectivesOffset}, orientation = "x-z"},{type = "fixed", pos={0, objectivesOffset, 0}}}},
            {id = 19, name = "#32 Display of Spiritual Might", objectives = {{type = "fixed", pos={14, objectivesOffset, 0}},{type = "fixed", pos={-14, objectivesOffset, 0}},{type = "fixed", pos={0, objectivesOffset, 8}},{type = "fixed", pos={0, objectivesOffset, -8}}}},
            {id = 20, name = "#33 Reconnaissance Mission", objectives = {{type = "diagonal", pos={16, objectivesOffset}, orientation = "xz"}, {type = "diagonal", pos={16, objectivesOffset}, orientation = "-x-z"}, {type = "diagonal", pos={10, objectivesOffset}, orientation = "-xz"}, {type = "diagonal", pos={10, objectivesOffset}, orientation = "x-z"}}},



            {id = 7,  name = "Crusade #1 Supply Cache", objectives = {{type = "fixed", pos={2, objectivesOffset, 2}},{type = "fixed", pos={2, objectivesOffset, -2}},{type = "fixed", pos={-2, objectivesOffset, 2}},{type = "fixed", pos={-2, objectivesOffset, -2}}}},
            {id = 8,  name = "Crusade #2 The Relic", objectives = {{type = "fixed", pos={0, objectivesOffset, 0}}}},
            {id = 9,  name = "Crusade #3 Sabotage", objectives = {{type = "fixed", pos={2, objectivesOffset, 2}},{type = "fixed", pos={2, objectivesOffset, -2}},{type = "fixed", pos={-2, objectivesOffset, 2}},{type = "fixed", pos={-2, objectivesOffset, -2}}}},
            {id = 10, name = "Crusade #4 Reckon Patrol", objectives = {{type = "fixed", pos={2, objectivesOffset, 2}},{type = "fixed", pos={2, objectivesOffset, -2}},{type = "fixed", pos={-2, objectivesOffset, 2}},{type = "fixed", pos={-2, objectivesOffset, -2}}}},
            {id = 11, name = "Crusade #5 The Ritual", objectives = {{type = "fixed", pos={2, objectivesOffset, 2}},{type = "fixed", pos={2, objectivesOffset, -2}},{type = "fixed", pos={-2, objectivesOffset, 2}},{type = "fixed", pos={-2, objectivesOffset, -2}}}},

            {id = 0, name = "None", objectives = {} },
        }
    },
    {   id=3 , type = "Strike Force",
        objectivesList={
            {id = 12, name = "#11 Recover The Relics", objectives = {{type = "fixed", pos={20, objectivesOffset, 0}},{type = "fixed", pos={8, objectivesOffset, 12}},{type = "fixed", pos={8, objectivesOffset, -12}},{type = "fixed", pos={-20, objectivesOffset, 0}},{type = "fixed", pos={-8, objectivesOffset, 12}},{type = "fixed", pos={-8, objectivesOffset, -12}}}},
            {id = 13, name = "#12 Tear Down Their Icons", objectives = {{type = "fixed", pos={0, objectivesOffset, 0}},{type = "fixed", pos={15, objectivesOffset, 12}},{type = "fixed", pos={15, objectivesOffset, -12}},{type = "fixed", pos={-15, objectivesOffset, 12}},{type = "fixed", pos={-15, objectivesOffset, -12}}}},
            {id = 14, name = "#13 Data Scry-Salvage", objectives = {{type = "diagonal", orientation="xz", pos={18}},{type = "diagonal", orientation="x-z", pos={12}},{type = "diagonal", orientation="x-z", pos={24}},{type = "diagonal", orientation="-x-z", pos={18}},{type = "diagonal", orientation="-xz", pos={12}},{type = "diagonal", orientation="-xz", pos={24}}}},
            {id = 15, name = "#21 Abandoned Sanctuaries", objectives = {{type = "fixed", pos={0, objectivesOffset, 0}},{type = "fixed", pos={18, objectivesOffset, 0}},{type = "fixed", pos={0, objectivesOffset, 14}},{type = "fixed", pos={-18, objectivesOffset, 0}},{type = "fixed", pos={0, objectivesOffset, -14}}}},
            {id = 16, name = "#22 Conversion", objectives = {{type = "fixed", pos={0, objectivesOffset, 0}},{type = "fixed", pos={15, objectivesOffset, 12}},{type = "fixed", pos={15, objectivesOffset, -12}},{type = "fixed", pos={-15, objectivesOffset, 12}},{type = "fixed", pos={-15, objectivesOffset, -12}}}},
            {id = 17, name = "#23 The Scouring", objectives = {{type = "fixed", pos={0, objectivesOffset, 0}},{type = "fixed", pos={9, objectivesOffset, 12}},{type = "fixed", pos={9, objectivesOffset, -12}},{type = "fixed", pos={-9, objectivesOffset, 12}},{type = "fixed", pos={-9, objectivesOffset, -12}}}},
            {id = 18, name = "#31 Tide of Conviction", objectives = {{type = "fixed", pos={6, objectivesOffset, 6}},{type = "fixed", pos={-18, objectivesOffset, 6}},{type = "fixed", pos={0, objectivesOffset, 15}}, {type = "fixed", pos={18, objectivesOffset, -6}},{type = "fixed", pos={-6, objectivesOffset, -6}},{type = "fixed", pos={0, objectivesOffset, -15}}}},
            {id = 19, name = "#32 Death and Zeal", objectives = {{type = "fixed", pos={0, objectivesOffset, 0}},{type = "fixed", pos={15, objectivesOffset, 12}},{type = "fixed", pos={15, objectivesOffset, -12}},{type = "fixed", pos={-15, objectivesOffset, 12}},{type = "fixed", pos={-15, objectivesOffset, -12}}}},
            {id = 20, name = "#33 Secure Missing Artefacts", objectives = {{type = "fixed", pos={0, objectivesOffset, 0}},{type = "fixed", pos={15, objectivesOffset, 12}},{type = "fixed", pos={15, objectivesOffset, -12}},{type = "fixed", pos={-15, objectivesOffset, 12}},{type = "fixed", pos={-15, objectivesOffset, -12}}}},



        {id = 7,   name = "Crusade #1 Supplies from Above", objectives = {{type = "fixed", pos={2, objectivesOffset, 4}},{type = "fixed", pos={2, objectivesOffset, 0}},{type = "fixed", pos={2, objectivesOffset, -4}},{type = "fixed", pos={-2, objectivesOffset, 4}},{type = "fixed", pos={-2, objectivesOffset, 0}},{type = "fixed", pos={-2, objectivesOffset, -4}}}},
        {id = 8,   name = "Crusade #2 Narrow the Search", objectives = {{type = "fixed", pos={2, objectivesOffset, 2}},{type = "fixed", pos={2, objectivesOffset, -2}},{type = "fixed", pos={-2, objectivesOffset, 2}},{type = "fixed", pos={-2, objectivesOffset, -2}}}},
        {id = 9,   name = "Crusade #3 Cut off the Head", objectives = {{type = "fixed", pos={2, objectivesOffset, 0}},{type = "fixed", pos={-2, objectivesOffset, 0}}}},
        {id = 10,  name = "Crusade #4 Retrieval", objectives = {{type = "fixed", pos={2, objectivesOffset, 4}},{type = "fixed", pos={2, objectivesOffset, 0}},{type = "fixed", pos={2, objectivesOffset, -4}},{type = "fixed", pos={-2, objectivesOffset, 4}},{type = "fixed", pos={-2, objectivesOffset, 0}},{type = "fixed", pos={-2, objectivesOffset, -4}}}},
        {id = 11,  name = "Crusade #5 Raze and Ruin", objectives = {{type = "fixed", pos={2, objectivesOffset, 4}},{type = "fixed", pos={2, objectivesOffset, 0}},{type = "fixed", pos={2, objectivesOffset, -4}},{type = "fixed", pos={-2, objectivesOffset, 4}},{type = "fixed", pos={-2, objectivesOffset, 0}},{type = "fixed", pos={-2, objectivesOffset, -4}}}},

        {id = 0, name = "None", objectives = {} },
    }
    },
    {   id=4 , type = "Onslaught",
        objectivesList={
            {id = 1, name = "Eternal War #1 Lines of Battle", objectives = {{type = "diagonal", orientation="x-z", pos={12}},{type = "diagonal", orientation="x-z", pos={30}},{type = "diagonal", orientation="x-z", pos={48}},{type = "diagonal", orientation="-xz", pos={12}},{type = "diagonal", orientation="-xz", pos={30}},{type = "diagonal", orientation="-xz", pos={48}}}},
            {id = 2, name = "Eternal War #2 All-out War", objectives = {{type = "fixed", pos={24, objectivesOffset, 0}},{type = "fixed", pos={0, objectivesOffset, -6}},{type = "fixed", pos={-24, objectivesOffset, 0}},{type = "fixed", pos={0, objectivesOffset, 6}},{type = "fixed", pos={30, objectivesOffset, 20}},{type = "fixed", pos={30, objectivesOffset, -20}},{type = "fixed", pos={-30, objectivesOffset, 20}},{type = "fixed", pos={-30, objectivesOffset, -20}}}},
            {id = 3, name = "Eternal War #3 Pathway to Glory", objectives = {{type = "fixed", pos={12, objectivesOffset, 0}},{type = "fixed", pos={0, objectivesOffset, -12}},{type = "fixed", pos={-12, objectivesOffset, 0}},{type = "fixed", pos={0, objectivesOffset, 12}},{type = "fixed", pos={24, objectivesOffset, 16}},{type = "fixed", pos={24, objectivesOffset, -16}},{type = "fixed", pos={-24, objectivesOffset, 16}},{type = "fixed", pos={-24, objectivesOffset, -16}}}},

            {id = 4,  name = "Crusade #2 Grand Assault", objectives = {{type = "fixed", pos={2, objectivesOffset, 6}},{type = "fixed", pos={2, objectivesOffset, 2}},{type = "fixed", pos={2, objectivesOffset, -2}},{type = "fixed", pos={2, objectivesOffset, -6}},{type = "fixed", pos={-2, objectivesOffset, 6}},{type = "fixed", pos={-2, objectivesOffset, 2}},{type = "fixed", pos={-2, objectivesOffset, -2}},{type = "fixed", pos={-2, objectivesOffset, -6}}}},
            {id = 5,  name = "Crusade #3 Field of Glory", objectives = {{type = "fixed", pos={2, objectivesOffset, 6}},{type = "fixed", pos={2, objectivesOffset, 2}},{type = "fixed", pos={2, objectivesOffset, -2}},{type = "fixed", pos={2, objectivesOffset, -6}},{type = "fixed", pos={-2, objectivesOffset, 6}},{type = "fixed", pos={-2, objectivesOffset, 2}},{type = "fixed", pos={-2, objectivesOffset, -2}},{type = "fixed", pos={-2, objectivesOffset, -6}}}},

            {id = 0, name = "None", objectives = {} },
        }
    },
    {   id=-1 , type = "None",
        objectivesList={
            {id = 0, name = "None", objectives = {} },
        }
    },
}

-- DEPLOY ZONES MANAGER
DeployZonesData = {
{ id=1 , type = "Combat Patrol",
    zones={
        {name = "Eternal War #1 Incisive attack", objectivesID= 1, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12}}},
        {name = "Eternal War #2 Outriders", objectivesID= 2, draw = {--[[1]]{type = "quarter", color = "Red", position = "xz", fromCenter = 9},--[[2]]{type = "quarter", color = "Teal", position = "-x-z", fromCenter = 9},--[[3]]{type = "circle", color = "White", fromCenter = 9}}},
        {name = "Eternal War #3 Encircle", objectivesID= 3, draw = {--[[1]]{type = "corner", color="Red", position = "z", fromCenter = 9, wide=6},--[[2]]{type = "corner", color="Teal", position = "-z", fromCenter = 9,  wide=6}}},
        {name = "Crusade #1 Sweep and Clear", objectivesID= 4, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12},--[[3]]{type = "line", color = "Black", position = "x", fromCenter = 3},--[[4]]{type = "line", color = "Black", position = "-x", fromCenter = 3}}},
        {name = "Crusade #2 Supply drop", objectivesID= 5, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 10},--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 10},--[[3]]{type = "circle", color = "White", fromCenter = 6}}},
        {name = "Crusade #3 Assassinate", objectivesID= 0, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 0},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 10},--[[3]]{type = "circleInZone", color = "Red", position = "x", fromCenter = 6, deployFromCenter=0}}},
        {name = "None", draw = {type = "none"}},
    }
},
{ id=2 , type = "Incursion",
        zones={
            {name = "#11 Cleanse The Land",  objectivesID= 12, draw = {--[[1]]{type = "quarter", color = "Teal", position = "-x-z", fromCenter = 9},--[[2]]{type = "quarter", color = "Red", position = "xz", fromCenter = 9},--[[3]]{type = "circle", color = "White", fromCenter = 9}}},
            {name = "#12 Deliverance",  objectivesID= 13, draw = {--[[1]]{type = "quarter", color = "Teal", position = "-x-z", fromCenter = 9},--[[2]]{type = "quarter", color = "Red", position = "xz", fromCenter = 9},--[[3]]{type = "circle", color = "White", fromCenter = 9}}},
            {name = "#13 Desperate Raid", objectivesID= 14, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12}}},
            {name = "#21 Sacred Ground",  objectivesID= 15, draw = {--[[1]]{type = "triangle", color = "Red", position = "x"},--[[2]]{type = "triangle", color = "Teal", position = "-x"}}},
            {name = "#22 Ascension", objectivesID= 16, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12}}},
            {name = "#23 Surge of Faith", objectivesID= 17, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12}}},
            {name = "#31 Rise of the Machine Spirit",  objectivesID= 18, draw = {--[[1]]{type = "quarter", color = "Teal", position = "-x-z", fromCenter = 9},--[[2]]{type = "quarter", color = "Red", position = "xz", fromCenter = 9},--[[3]]{type = "circle", color = "White", fromCenter = 9}}},
            {name = "#32 Display of Spiritual Might", objectivesID= 19, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12}}},
            {name = "#33 Reconnaissance Mission",  objectivesID= 20, draw = {--[[1]]{type = "triangle", color = "Red", position = "x"},--[[2]]{type = "triangle", color = "Teal", position = "-x"}}},

        {name = "Crusade #1 Supply Cache", objectivesID= 7, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 10},--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 10}}},
        {name = "Crusade #2 The Relic", objectivesID= 8, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12},--[[3]]{type = "circle", color = "White", fromCenter = 6}}},
        {name = "Crusade #3 Sabotage", objectivesID= 9, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 0},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 9}}},
        {name = "Crusade #4 Reckon Patrol", objectivesID= 10, draw = {--[[1]]{type = "quarter", color = "Teal", position = "-x-z", fromCenter = 10},--[[2]]{type = "quarter", color = "Red", position = "xz", fromCenter = 10},--[[3]]{type = "circle", color = "White", fromCenter = 10}}},
        {name = "Crusade #5 The Ritual", objectivesID= 11, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 0},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12},--[[3]]{type = "circleInZone", color = "Red", position = "x", fromCenter = 3, deployFromCenter=0}}},
        {name = "Crusade #6 Behind Enemy Lines", objectivesID= 0, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 10},--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 10}}},

        {name = "None", draw = {type = "none"}},
    }
},
    { id=3 , type = "Strike Force",
        zones={
            {name = "#11 Recover The Relics", objectivesID= 12, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12 },--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12, fromEdge = 0},--[[3{type = "circle", color = "White", fromCenter = 12}]]}},
            {name = "#12 Tear Down Their Icons", objectivesID= 13, draw = {--[[1]]{type = "triangle", color = "Red", position = "x"},--[[2]]{type = "triangle", color = "Teal", position = "-x"}}},
            {name = "#13 Data Scry-Salvage", objectivesID= 14,draw = {--[[1]]{type = "diagonal", color = "Teal", position = "-z" , fromCenter = 12},--[[1]]{type = "diagonal", color = "Red", position = "z" , fromCenter = 12}}},
            {name = "#21 Abandoned Sanctuaries", objectivesID= 15, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 12 },--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 12, fromEdge = 0}}},
            {name = "#22 Conversion", objectivesID= 16, draw = {--[[1]]{type = "quarter", color = "Teal", position = "-x-z", fromCenter = 9},--[[2]]{type = "quarter", color = "Red", position = "xz", fromCenter = 9},--[[3]]{type = "circle", color = "White", fromCenter = 9}}},
            {name = "#23 The Scouring", objectivesID= 17, draw = {--[[1]]{type = "line", color="Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color="Teal", position = "-x", fromCenter = 12}}},
            {name = "#31 Tide of Conviction", objectivesID= 18, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 12 },--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 12, fromEdge = 0}}},
            {name = "#32 Death and Zeal", objectivesID= 19, draw = {--[[1]]{type = "quarter", color = "Teal", position = "-x-z", fromCenter = 9},--[[2]]{type = "quarter", color = "Red", position = "xz", fromCenter = 9},--[[3]]{type = "circle", color = "White", fromCenter = 9}}},
            {name = "#33 Secure Missing Artefacts", objectivesID= 20, draw = {--[[1]]{type = "triangle", color = "Red", position = "x"},--[[2]]{type = "triangle", color = "Teal", position = "-x"}}},

        {name = "Crusade #1 Supplies from Above", objectivesID= 7, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 12 },--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 12, fromEdge = 0}}},
        {name = "Crusade #2 Narrow the Search", objectivesID= 8, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12},--[[3]]{type = "circle", color = "White", fromCenter = 12},--[[4]]{type = "circle", color = "White", fromCenter = 18}}},
        {name = "Crusade #3 Cut off the Head",  objectivesID= 9, draw = {--[[1]]{type = "quarter", color = "Teal", position = "-x-z", fromCenter = 12},--[[2]]{type = "quarter", color = "Red", position = "xz", fromCenter = 12},--[[3]]{type = "circle", color = "White", fromCenter = 12}}},
        {name = "Crusade #4 Retrieval", objectivesID= 10, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 12 },--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 0, fromEdge = 0}}},
        {name = "Crusade #5 Raze and Ruin", objectivesID= 11, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 12 },--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 12, fromEdge = 0},--[[2]]{type = "line", color = "Black", position = "z", fromCenter = 3, fromEdge = 0},{type = "line", color = "Black", position = "-z", fromCenter = 3, fromEdge = 0}}},
        {name = "Crusade #6 Ambush", objectivesID= 0, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 5 },--[[2]]{type = "line", color = "Teal", position = "z", fromCenter = 5, fromEdge = 0},{type = "line", color = "Red", position = "z", fromCenter = 17, fromEdge = 0},{type = "line", color = "Red", position = "-z", fromCenter = 17, fromEdge = 0}}},

        {name = "None", draw = {type = "none"}},
    }
},
{id=4 ,  type = "Onslaught",
    zones={
        {name = "Eternal War #1 Lines of Battle",  objectivesID= 1, draw = {--[[1]]{type = "quarter", color = "Teal", position = "-x-z", fromCenter = 12},--[[2]]{type = "quarter", color = "Red", position = "xz", fromCenter = 12},--[[3]]{type = "circle", color = "White", fromCenter = 12}}},
        {name = "Eternal War #2 All-out War", objectivesID= 2, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 12 },--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 12, fromEdge = 0}}},
        {name = "Eternal War #3 Pathway to Glory", objectivesID= 3, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12 },--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12, fromEdge = 0},--[[3]]{type = "circle", color = "White", fromCenter = 12}}},


        {name = "Crusade #1 Firestorm", objectivesID= 0, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 12 },--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 12, fromEdge = 0}}},
        {name = "Crusade #2 Grand assault", objectivesID= 4, draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 0 },--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 12, fromEdge = 0}}},
        {name = "Crusade #3 Field of Glory", objectivesID= 5, draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12}}},
        {name = "None", draw = {type = "none"}},
    }
},

{ id=6 , type = "Praetor",
    zones={
        {name = "#1 6x4 Spearhead Assault", draw = {--[[1]]{type = "arrow", color="Red", position = "x", fromCenter = 12, fromEdge = 0, wide=0},--[[2]]{type = "arrow", color="Teal", position = "-x", fromCenter = 12, fromEdge = 0, wide=0}}},
        {name = "#2 6x4 Dawn of War", draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 12 },--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 12, fromEdge = 0}}},
        {name = "#3 6x4 Search and Destroy", draw = {--[[1]]{type = "quarter", color = "Teal", position = "x-z", fromCenter = 9},--[[2]]{type = "quarter", color = "Red", position = "-xz", fromCenter = 9},--[[3]]{type = "circle", color = "White", fromCenter = 9}}},
        {name = "#4 6x4 Hammer and Hanvil", draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12}}},
        {name = "#5 6x4 Front-Line Assault", draw = {--[[1]]{type = "line", color="Red", position = "x", fromCenter = 24},--[[2]]{type = "line", color="Red", position = "-x", fromCenter = 24}, --[[3]]{type = "circle", color="Teal", fromCenter = 18}}},
        {name = "#6 6x4 Vanguard Strike", draw = {--[[1]]{type = "diagonal", color = "Red", position = "z" , fromCenter = 12},--[[1]]{type = "diagonal", color = "Teal", position = "-z" , fromCenter = 12}}},
        {name = "None", draw = {type = "none"}},
        }
    },
{ id=7 , type = "Warmaster",  objectivesID = 5 ,
    zones={
        {name = "#1 8x4 Spearhead Assault", draw = {--[[1]]{type = "arrow", color="Red", position = "x", fromCenter = 12, fromEdge = 0, wide=0},--[[2]]{type = "arrow", color="Teal", position = "-x", fromCenter = 12, fromEdge = 0, wide=0}}},
        {name = "#2 8x4 Dawn of War", draw = {--[[1]]{type = "line", color = "Teal", position = "-z", fromCenter = 12},--[[2]]{type = "line", color = "Red", position = "z", fromCenter = 12}}},
        {name = "#3 8x4 Search and Destroy", draw = {--[[1]]{type = "quarter", color = "Teal", position = "x-z", fromCenter = 9},--[[2]]{type = "quarter", color = "Red", position = "-xz", fromCenter = 9},--[[3]]{type = "circle", color = "White", fromCenter = 9}}},
        {name = "#4 8x4 Hammer and Hanvil", draw = {--[[1]]{type = "line", color = "Red", position = "x", fromCenter = 12},--[[2]]{type = "line", color = "Teal", position = "-x", fromCenter = 12}}},
        {name = "#5 8x4 Front-Line Assault", draw = {--[[1]]{type = "line", color="Red", position = "x", fromCenter = 32},--[[2]]{type = "line", color="Red", position = "-x", fromCenter = 32}, --[[3]]{type = "circle", color="Teal", fromCenter = 24}}},
        {name = "#6 8x4 Vanguard Strike", draw = {--[[1]]{type = "diagonal", color = "Red", position = "z" , fromCenter = 12},--[[1]]{type = "diagonal", color = "Teal", position = "-z" , fromCenter = 12}}},
        {name = "None", draw = {type = "none"}},
        }
    },
}

deployLineHeight = 2.1
deployLineYPos = deployLineHeight-0.1
mat_GUID = "4ee1f2"
centerCircle_GUID="51ee2f"
sizeMulti = 36

function drawDeployZone(zone)
    local drawDataZone = zone.draw
    for i, drawData in ipairs(drawDataZone) do
        if drawData.type == "arrow" then
            drawArrow(drawData)
        end
        if drawData.type == "line" then
            drawLine(drawData)
        end
        if drawData.type == "quarter" then
            drawQuarter(drawData)
        end
        if drawData.type == "diagonal" then
            drawDiagonal(drawData)
        end
        if drawData.type == "rectangle" then
            drawRectangle(drawData)
        end
        if drawData.type == "corner" then
            drawCorner(drawData)
        end
        if drawData.type == "triangle" then
            drawTriangle(drawData)
        end
        if drawData.type == "circle" then
            drawCircle(drawData, "deployZone")
        end
        if drawData.type == "circleInZone" then
            drawCircleInZone(drawData, "deployZone")
        end
    end
    setDeployHeight()
end

function setDeployHeight()
    local pos = {0,0,0}
    local found_GUID = {}
    for i, obj in ipairs(getAllObjects()) do
        if obj.getGMNotes() == "deployZone" then
            table.insert(found_GUID, #found_GUID+1, obj.getGUID())
        end
    end
    local found= nil
    for j, guid in ipairs(found_GUID) do
        found=getObjectFromGUID(guid)
        pos = found.getPosition()
        found.setPosition({pos[1], defaultDeployHeight+ deployOffset, pos[3]})
    end
end


function drawRectangle(drawData)
    local mat = getObjectFromGUID(mat_GUID)
    local linePosL = {x = 0, y = deployLineYPos, z = 0}
    local lineRotL = {x = 0, y = 90, z = 0}
    local lineScaleL = {x = 5, y = deployLineHeight, z = 0.02}
    local linePosS1 = {x = 0, y = deployLineYPos, z = 0}
    local lineRotS1 = {x = 0, y = 0, z = 0}
    local lineScaleS1 = {x = 5, y = deployLineHeight, z = 0.02}
    local linePosS2 = {x = 0, y = deployLineYPos, z = 0}
    local mapBase = mat.getScale().z * sizeMulti --short edge
    local mapHeight = mat.getScale().x * sizeMulti --long edge
    if drawData.position == "z" or drawData.position == "-z" then
        mapBase = mat.getScale().x * sizeMulti
        mapHeight = mat.getScale().z * sizeMulti
    end
    if drawData.wide ~= 0 then
        mapBase = drawData.wide * 2
    end

    lineScaleL.x = drawData.wide * 2
    linePosL.x = drawData.fromCenter

    lineScaleS1.x = (mapHeight/2)-drawData.fromCenter
    linePosS1.x = drawData.fromCenter + ((mapHeight/2) - drawData.fromCenter)/2
    linePosS1.z = drawData.wide

    linePosS2.x = linePosS1.x
    linePosS2.z = -linePosS1.z

    if drawData.position == "x" then
        -- default values
    end
    if drawData.position == "-x" then
            linePosL.x = - linePosL.x
            linePosS2.x = -linePosS2.x
            linePosS1.x = -linePosS1.x
    end
    if drawData.position == "z" then
        linePosL.z = linePosL.x
        linePosL.x = 0
        lineRotL.y = 0

        local tmp = linePosS1.z
        linePosS1.z = linePosS1.x
        linePosS1.x = tmp
        lineRotS1.y = 90

        linePosS2.z = linePosS1.z
        linePosS2.x = -tmp

    end
    if drawData.position == "-z" then
        linePosL.z = -linePosL.x
        linePosL.x = 0
        lineRotL.y = 0

        local tmp = linePosS1.z
        linePosS1.z = -linePosS1.x
        linePosS1.x = -tmp
        lineRotS1.y = 90

        linePosS2.z = linePosS1.z
        linePosS2.x = tmp

    end
    spawnLine(linePosL, lineRotL, lineScaleL, drawData.color, "deployZone") -- orizz
    spawnLine(linePosS1, lineRotS1, lineScaleS1, drawData.color,  "deployZone") -- vert1
    spawnLine(linePosS2, lineRotS1, lineScaleS1, drawData.color, "deployZone") -- vert2
end

function drawCorner(drawData)
    local mat = getObjectFromGUID(mat_GUID)
    local linePosL = {x = 0, y = deployLineYPos, z = 0}
    local lineRotL = {x = 0, y = 0, z = 0}
    local lineScaleL = {x = 5, y = deployLineHeight, z = 0.02}
    local linePosS1 = {x = 0, y = deployLineYPos, z = 0}
    local lineRotS1 = {x = 0, y = 90, z = 0}
    local lineScaleS1 = {x = 5, y = deployLineHeight, z = 0.02}
    local mapBase = mat.getScale().z * sizeMulti --short edge
    local mapHeight = mat.getScale().x * sizeMulti --long edge
    if drawData.position == "x" or drawData.position == "-x" then
        mapBase = mat.getScale().x * sizeMulti
        mapHeight = mat.getScale().z * sizeMulti
    end
    --print("MAP BxH: "..mapBase.." x "..mapHeight)
    lineScaleL.x = (mapHeight/2) + drawData.wide
    linePosL.x = (mapHeight/4)-(drawData.wide/2)
    linePosL.z = drawData.fromCenter

    lineScaleS1.x = (mapBase/2)-drawData.fromCenter
    linePosS1.z = drawData.fromCenter + lineScaleS1.x/2
    linePosS1.x = -drawData.wide

    if drawData.position == "z" then
        -- default values
    end
    if drawData.position == "-z" then
            linePosL.x = - linePosL.x
            linePosL.z = - linePosL.z

            linePosS1.z = -linePosS1.z
            linePosS1.x = -linePosS1.x
    end
    if drawData.position == "x" then -- not valid, to do
        linePosL.z = linePosL.x
        linePosL.x = 0
        lineRotL.y = 0

        local tmp = linePosS1.z
        linePosS1.z = linePosS1.x
        linePosS1.x = tmp
        lineRotS1.y = 90
    end
    if drawData.position == "-x" then-- not valid, to do
        linePosL.z = -linePosL.x
        linePosL.x = 0
        lineRotL.y = 0

        local tmp = linePosS1.z
        linePosS1.z = -linePosS1.x
        linePosS1.x = -tmp
        lineRotS1.y = 90
    end
    spawnLine(linePosL, lineRotL, lineScaleL, drawData.color, "deployZone") -- long
    spawnLine(linePosS1, lineRotS1, lineScaleS1, drawData.color,  "deployZone") -- short
end

function drawDiagonal(drawData)
    local mat = getObjectFromGUID(mat_GUID)
    local linePos = {x = 0, y = deployLineYPos, z = 0}
    local lineRot = {x = 0, y = 0, z = 0}
    local lineScale = {x = 5, y = deployLineHeight, z = 0.02}
    local mapBase = mat.getScale().z * sizeMulti --short edge
    local mapHeight = mat.getScale().x * sizeMulti --long edge
    if drawData.position == "x" or drawData.position == "-x" then
        mapBase = mat.getScale().x * sizeMulti
        mapHeight = mat.getScale().z * sizeMulti
    end
    local mainDiagonal = 0
    local edgeLoss = 0
    local triBase = 0 -- triangle with hypotenuse as the needed deploy line

    local edgeAngle = 0 -- angle of the line from the given map edge
    local edgeAngleRad = 0
    local halfTriBase = 0 -- triangle with hypotenuse that is half the line lenght
    local halfTriHeight = 0 -- triangle with hypotenuse that is half the line lenght
    mainDiagonal = math.sqrt(math.pow(mapBase, 2) + math.pow(mapHeight, 2))
    edgeAngleRad = math.atan(mapBase / mapHeight)
    edgeAngle = math.deg(edgeAngleRad)
    edgeLoss = drawData.fromCenter / math.cos(edgeAngleRad)
    triBase = mapBase-edgeLoss
    local ratio = triBase / mapBase
    lineScale.x = mainDiagonal * ratio
    lineRot.y = edgeAngle
    halfTriBase = lineScale.x * math.sin(edgeAngleRad) / 2
    halfTriHeight = lineScale.x * math.cos(edgeAngleRad) / 2
    linePos.x = (mapHeight/2) - (lineScale.x/2) * math.cos(edgeAngleRad)
    linePos.z = (mapBase/2) - (lineScale.x/2) * math.sin(edgeAngleRad)
    if drawData.position == "z" then -- upper right
        -- default values
    end
    if drawData.position == "-z" then
        linePos.x = - linePos.x
        linePos.z = - linePos.z
    end
    spawnLine(linePos, lineRot, lineScale, drawData.color,  "deployZone")
end

function drawTriangle(drawData)
    local mat = getObjectFromGUID(mat_GUID)
    local linePos = {x = 0, y = deployLineYPos, z = 0}
    local lineRot = {x = 0, y = 0, z = 0}
    local lineScale = {x = 5, y = deployLineHeight, z = 0.02}
    local mapBase = mat.getScale().z * sizeMulti --short edge
    local mapHeight = mat.getScale().x * sizeMulti --long edge
    if drawData.position == "z" or drawData.position == "-z" then
        mapBase = mat.getScale().x * sizeMulti
        mapHeight = mat.getScale().z * sizeMulti
    end

    local triBase = 0 -- triangle with hypotenuse as the needed deploy line
    local triHeight = 0 -- triangle with hypotenuse as the needed deploy line

    local edgeAngle = 0 -- angle of the line from the given map edge
    local edgeAngleRad = 0

    triBase = mapBase
    triHeight = mapHeight/2
    edgeAngleRad = math.atan(triBase/triHeight )
    edgeAngle = math.deg(edgeAngleRad)
    lineScale.x = math.sqrt(triBase^2+triHeight^2)
    lineRot.y = edgeAngle

    if drawData.position == "x" then
        linePos.x=mapHeight/4
        linePos.z=0
    end
    if drawData.position == "-x" then
        linePos.x=-mapHeight/4
        linePos.z=0
    end
    if drawData.position == "z" then
            lineRot.y= lineRot.y-90
        linePos.x=0
        linePos.z=mapHeight/4
    end
    if drawData.position == "-z" then
            lineRot.y= lineRot.y+90
        linePos.x=0
        linePos.z=-mapHeight/4
    end
    spawnLine(linePos, lineRot, lineScale, drawData.color,  "deployZone")
end

function drawQuarter(drawData)
    local mat = getObjectFromGUID(mat_GUID)
    local linePos = {x = 0, y = deployLineYPos, z = 0}
    local lineRot = {x = 0, y = 90, z = 0}
    local lineScale = {x = 5, y = deployLineHeight, z = 0.02}
    local mapBase = mat.getScale().z * sizeMulti --short edge
    local mapHeight = mat.getScale().x * sizeMulti --long edge
    if drawData.position == "x" then
        mapBase = mat.getScale().x * sizeMulti
        mapHeight = mat.getScale().z * sizeMulti
    end
    lineScale.x = (mapBase/2)-drawData.fromCenter
    linePos.z =  (lineScale.x/2) + drawData.fromCenter
    if drawData.position == "xz" then
        -- default values
    end
    if drawData.position == "x-z" or drawData.position == "-x-z" then
        linePos.z = -linePos.z
    end
    spawnLine(linePos, lineRot, lineScale, drawData.color,  "deployZone") -- short line
    lineScale.x = (mapHeight/2)-drawData.fromCenter
    linePos.z = 0
    linePos.x =  (lineScale.x/2) + drawData.fromCenter
    lineRot.y = 0
    if drawData.position == "-xz" or drawData.position == "-x-z" then
        linePos.x = -linePos.x
    end
    spawnLine(linePos, lineRot, lineScale, drawData.color, "deployZone") -- long line
end

function drawCircle(drawData, type)
    local originalCircle=getObjectFromGUID(centerCircle_GUID)
    local circleObj = originalCircle.clone({ position = {0, -5, 0}})
    if circleObj then
        circleObj.setLock(true)
        circleObj.setScale({drawData.fromCenter, deployLineHeight, drawData.fromCenter})
        circleObj.setPosition({0, deployLineYPos, 0})
        circleObj.setColorTint(drawData.color)
        circleObj.setGMNotes(type)
        circleObj.setName("")
        local blockComp = circleObj.getComponent("BoxCollider")
        blockComp.set("enabled", false)
    end
end

function drawCircleInZone(drawData, type)
    local mat = getObjectFromGUID(mat_GUID)
    local mapBase = mat.getScale().z * sizeMulti --short edge
    local mapHeight = mat.getScale().x * sizeMulti --long edge
    if drawData.position == "z" or drawData.position == "-z" then
        mapBase = mat.getScale().x * sizeMulti
        mapHeight = mat.getScale().z * sizeMulti
    end
    local posX=0
    local posZ=0
    if drawData.position == "x" then
        posX=((mapHeight/2-drawData.deployFromCenter)/2)+drawData.deployFromCenter
    end
    if drawData.position == "-x" then
        posX=-((mapHeight/2-drawData.deployFromCenter)/2)+drawData.deployFromCenter
    end
    if drawData.position == "z" then
        posZ=((mapHeight/2-drawData.deployFromCenter)/2)+drawData.deployFromCenter
    end
    if drawData.position == "-z" then
        posZ=-((mapHeight/2-drawData.deployFromCenter)/2)+drawData.deployFromCenter
    end
     drawCircleNotCentered(drawData, type, posX,posZ)
end

function drawCircleNotCentered(drawData, type, centerX, centerZ)
    local originalCircle=getObjectFromGUID(centerCircle_GUID)
    local circleObj = originalCircle.clone({ position = {0, -5, 0}})
    if circleObj then
        circleObj.setLock(true)
        circleObj.setScale({drawData.fromCenter, deployLineHeight, drawData.fromCenter})
        circleObj.setPosition({centerX, deployLineYPos, centerZ})
        circleObj.setColorTint(drawData.color)
        circleObj.setGMNotes(type)
        circleObj.setName("")
        local blockComp = circleObj.getComponent("BoxCollider")
        blockComp.set("enabled", false)
    end
end

function drawLine(drawData)
    local mat = getObjectFromGUID(mat_GUID)
    local linePos = {x = 0, y = deployLineYPos, z = 0}
    local lineRot = {x = 0, y = 90, z = 0}
    local lineScale = {x = 5, y = deployLineHeight, z = 0.02}
    local mapBase = mat.getScale().z * sizeMulti --short edge
    local mapHeight = mat.getScale().x * sizeMulti --long edge
    if drawData.position == "z" or drawData.position == "-z" then
        mapBase = mat.getScale().x * sizeMulti
        mapHeight = mat.getScale().z * sizeMulti
    end
    if drawData.fromSide then
        if drawData.fromSide ~= 0 then
            drawData.fromCenter = (mapBase/2)-drawData.fromSide
        end
    end
    lineScale.x = mapBase
    linePos.x = drawData.fromCenter
    if drawData.position == "x" then
        -- defaut values
    end
    if drawData.position == "-x" then
        linePos.x = -linePos.x
    end
    if drawData.position == "z" then
        lineRot.y = 0
        linePos.z = linePos.x
        linePos.x = 0
    end
    if drawData.position == "-z" then
        lineRot.y = 0
        linePos.z = -linePos.x
        linePos.x = 0
    end
    spawnLine(linePos, lineRot, lineScale, drawData.color, "deployZone")
end

function drawArrow(drawData)
    local mat = getObjectFromGUID(mat_GUID)
    local linePos = {x = 0, y = deployLineYPos, z = 0}
    local lineRot = {x = 0, y = 0, z = 0}
    local lineScale = {x = 5, y = deployLineHeight, z = 0.02}
    local mapBase =  mat.getScale().z * sizeMulti --short edge
    local mapHeight = mat.getScale().x * sizeMulti --long edge
    if drawData.position == "z" or drawData.position == "-z" then
        mapBase = mat.getScale().x * sizeMulti
        mapHeight = mat.getScale().z * sizeMulti
    end
    if drawData.wide ~= 0 then
        mapBase = drawData.wide *2
    end
    local triBase = (mapBase / 2) -- triangle with hypotenuse as the needed deploy line
    local triHeight = (mapHeight / 2) - drawData.fromCenter - drawData.fromEdge -- triangle with hypotenuse as the needed deploy line
    local edgeAngle = 0 -- angle of the line from the given map edge
    local edgeAngleRad = 0
    local halfTriBase = 0 -- triangle with hypotenuse that is half the line lenght
    local halfTriHeight = 0 -- triangle with hypotenuse that is half the line lenght
    lineScale.x = math.sqrt(math.pow(triBase, 2) + math.pow(triHeight, 2))
    edgeAngleRad = math.atan(triBase / triHeight)
    edgeAngle = math.deg(edgeAngleRad)
    lineRot.y = edgeAngle
    halfTriBase = (lineScale.x / 2) * math.sin(edgeAngleRad)
    halfTriHeight = (lineScale.x  / 2 ) * math.cos(edgeAngleRad)
    linePos.x = triHeight - halfTriHeight + drawData.fromCenter
    linePos.z = -1 * (triBase - halfTriBase)
    if drawData.position == "x" then
        --default values
    end
    if drawData.position == "-x" then
        linePos.z = -linePos.z
        linePos.x = -linePos.x
    end
    if drawData.position == "z" then
        local tmp = linePos.z
        linePos.z = linePos.x
        linePos.x = -tmp
        lineRot.y = 90 + lineRot.y
    end
    if drawData.position == "-z" then
        local tmp = linePos.z
        linePos.z = -linePos.x
        linePos.x = tmp
        lineRot.y = 90 + lineRot.y
    end

    spawnLine(linePos, lineRot, lineScale, drawData.color, "deployZone")
    if drawData.position == "x" or drawData.position == "-x"  then
        linePos.z = -linePos.z
        lineRot.y = -lineRot.y
    end
    if drawData.position == "z" or drawData.position == "-z"  then
        linePos.x = -linePos.x
        lineRot.y = -lineRot.y
    end
    spawnLine(linePos, lineRot, lineScale, drawData.color, "deployZone")
end

function spawnLine(linePos, lineRot, lineScale, color, type)
    local lineObj = spawnObject({ --Chip_10
        type = "BlockSquare",
        position = linePos,
        rotation = lineRot,
        scale = lineScale,
    })
    if lineObj then
        lineObj.setLock(true)
        lineObj.setGMNotes(type)
        lineObj.setColorTint(color)
        local blockComp = lineObj.getComponent("BoxCollider")
        blockComp.set("enabled", false)
    end
end

function destroyDeployZones()
    for i, obj in ipairs(getAllObjects()) do
        if obj.getGMNotes() == "deployZone" then
            obj.destroy()
        end
    end
end

function disableCollidersDeployZones()
    for i, obj in ipairs(getAllObjects()) do
        if obj.getGMNotes() == "deployZone" or obj.getGMNotes() == "areaDeny" or obj.getGMNotes() == "quarter" then
            local blockComp = obj.getComponent("BoxCollider")
            blockComp.set("enabled", false)
        end
    end

end
-- END deploy zones MANAGER


simulation = false -- is used to test in single player
redFirstLbl = "R  e  d    p l a y e r    f i r s t\n(click to toggle)"
blueFirstLbl = "B l u e    p l a y e r    f i r s t\n(click to toggle)"
inGame = false
gameTurnCounter = nil
armyMover = ""
first = "Red"
currentTurn = "Red"
cpEveryTurn = true
phases40k = {"Command", "Movement", "Psychic", "Shooting", "Charge", "Fight", "Morale"}
phases30k = {"Move", "Shoot", "Assault"}
currentPhase = 1
startBtn = {
    index = 1, label = "S T A R T  G A M E", click_function = "startGame", function_owner = self,
    position = {0, 5, - 1}, rotation = {0, 0, 0}, height = 750, width = 5000,
    font_size = 500, color = {0, 0.6, 0}, font_color = {1, 1, 1}
}
firstPlayerBtn = {
    index = 1, label = redFirstLbl, click_function = "togglePlyr", function_owner = self,
    position = {0, 5, 1}, rotation = {0, 0, 0}, height = 750, width = 5000,
    font_size = 300, color = {1, 0, 0}, font_color = {1, 1, 1}
}
nextPhaseLbl = "P A S S\nT U R N"
nextPhaseBtn = {
    index = 1, label = nextPhaseLbl, tooltip = "Left click - Next phase\nRight click - Skip to next turn", click_function = "nextPhase", function_owner = self,
    position = {0, 5, 0}, rotation = {0, 0, 0}, height = 1500, width = 5000,
    font_size = 600, color = {1, 0, 0}, font_color = {1, 1, 1}
}

notePadTxt = ""

menuX = 15
menuZ = 1.05-1.05
arrowOffset = 7.5

-- DEPLOY ZONES VARIABLES


deploymentIngamePlaced = false
deployIngameLblOpen = "H i d e\nd e p l o y m e n t\nz o n e s"
deployIngameLblClosed = "S h o w\nd e p l o y m e n t\nz o n e s"
defaultDeployHeight=2
deployOffset = 0
deployTypeMenuBtn = {
    index = 1, label = "S e l e c t    d e p l o y m e n t    z o n e s", click_function = "none", function_owner = self,
    position = { - menuX, 5, menuZ - 1.2}, rotation = {0, 0, 0}, height = 450, width = 8000,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
deployTypeBtn = {
    index = i, label = "", click_function = "none", function_owner = self,
    position = { - menuX, 5, menuZ}, rotation = {0, 0, 0}, height = 450, width = 6000,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
deployTypeUpBtn = {
    index = 1, label = "->", click_function = "deployTypeUp", function_owner = self,
    position = { - menuX + arrowOffset, 5, menuZ}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
deployTypeDownBtn = {
    index = 1, label = "<-", click_function = "deployTypeDown", function_owner = self,
    position = { - menuX - arrowOffset, 5, menuZ}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}

secondRowOffset= 1.2
deployBtn = {
    index = i, label = "", click_function = "none", function_owner = self,
    position = { - menuX, 5, menuZ+secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 6000,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
deployUpBtn = {
    index = 1, label = "->", click_function = "deployUp", function_owner = self,
    position = { - menuX + arrowOffset, 5, menuZ+secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
deployDownBtn = {
    index = 1, label = "<-", click_function = "deployDown", function_owner = self,
    position = { - menuX - arrowOffset, 5, menuZ+secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
deployIngameBtn = {
    index = 1, label = deployIngameLblClosed, click_function = "showHideIngameDeployment", function_owner = self,
    position = { - menuX - 16, 5, menuZ}, rotation = {0, 0, 0}, height = 1500, width = 2600,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
deployOffsetMenuBtn = {
    index = 1, label = "Height", click_function = "none", function_owner = self,
    position = {-menuX - 1.4*arrowOffset, 5, menuZ}, rotation = {0, 0, 0}, height = 450, width = 1000,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
deployOffsetUpBtn = {
    index = 1, label = "+", click_function = "deployOffsetUp", function_owner = self,
    position = {-menuX - 1.4*arrowOffset, 5, menuZ - secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
deployOffsetDownBtn = {
    index = 1, label = "-", click_function = "deployOffsetDown", function_owner = self,
    position = {-menuX - 1.4*arrowOffset, 5, menuZ + secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}

-- OBJECTIVES MANAGER
defaultObjectivesHeight=1.0
templateObjectiveGuid="573333"
function spawnObjectives()
    destroyAllObjectives()
    local selectedObjectivesBySize= objectivesData[objectivesTypeSelected].objectivesList
    local spawned = nil
    local pos={}
    local template = getObjectFromGUID(templateObjectiveGuid)
    for i, objective in ipairs(selectedObjectivesBySize[objectivesSelected].objectives) do
        pos=objective.pos
        if objectivesOffset == nil then pos[2] = 1 else pos[2] = defaultObjectivesHeight+ objectivesOffset end
            if objective.type=="fixed" then
                -- no change to pos
            end
            if objective.type=="diagonal" then
                pos=calcDiagonalPos(objective.orientation, pos[1], pos[2])
            end
        spawned = template.clone({ position = pos })
        spawned.setGMNotes("objective")
        spawned.setPosition(pos)
        local rotZ = 180
        if objectivesData[objectivesTypeSelected].rotateUp then
            rotZ = 0
        end
        spawned.setRotation({0,270,rotZ})
        spawned.setLock(true)
    end
end

function calcDiagonalPos(orientation, relPosOnDiagonal, posY)
    local posX = 0
    local posZ = 0
    local mat = getObjectFromGUID(mat_GUID)
    local mapBase = mat.getScale().z * sizeMulti --short edge
    local mapHeight = mat.getScale().x * sizeMulti --long edge


    local edgeAngle = 0 -- angle of the line from the given map edge
    local edgeAngleRad = 0
    local halfTriBase = 0 -- triangle with hypotenuse that is half the line lenght
    local halfTriHeight = 0 -- triangle with hypotenuse that is half the line lenght

    edgeAngleRad = math.atan(mapBase / mapHeight)
    edgeAngle = math.deg(edgeAngleRad)

    posX=relPosOnDiagonal * math.cos(edgeAngleRad)
    posZ=relPosOnDiagonal * math.sin(edgeAngleRad)
    if orientation == "xz" then
        -- default values
    end
    if orientation == "x-z" then
        posZ=-posZ
    end
    if orientation == "-xz" then
        posX=-posX
    end
    if orientation == "-x-z" then
        posX=-posX
        posZ=-posZ
    end

    return {posX,posY,posZ}
end

function destroyAllObjectives()
    for i, obj in ipairs(getAllObjects()) do
        if obj.getGMNotes() == "objective" then
            obj.destroy()
        end
    end
end

function setObjectivesHeight()
    local pos = {0,0,0}
    local found_GUID = {}
    for i, obj in ipairs(getAllObjects()) do
        if obj.getGMNotes() == "objective" then
            table.insert(found_GUID, #found_GUID+1, obj.getGUID())
        end
    end
    local found= nil
    for j, guid in ipairs(found_GUID) do
        found=getObjectFromGUID(guid)
        pos = found.getPosition()
        found.setPosition({pos[1], defaultObjectivesHeight+ objectivesOffset, pos[3]})
    end
end
--END objectives manager

objectivesOffset = 0
objectivesTypeBtn = {
    index = i, label = "", click_function = "none", function_owner = self,
    position = {menuX, 5, menuZ}, rotation = {0, 0, 0}, height = 450, width = 6000,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
objectivesTypeUpBtn = {
    index = 1, label = "->", click_function = "objectivesTypeUp", function_owner = self,
    position = {menuX + arrowOffset, 5, menuZ}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
objectivesTypeDownBtn = {
    index = 1, label = "<-", click_function = "objectivesTypeDown", function_owner = self,
    position = {menuX - arrowOffset, 5, menuZ}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}

objectivesMenuBtn = {
    index = 1, label = "S e l e c t    o b j e c t i v e s", click_function = "none", function_owner = self,
    position = {menuX, 5, menuZ-secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 8000,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
objectivesBtn = {
    index = i, label = "", click_function = "none", function_owner = self,
    position = {menuX, 5,  menuZ + secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 6000,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
objectivesUpBtn = {
    index = 1, label = "->", click_function = "objectivesUp", function_owner = self,
    position = {menuX + arrowOffset, 5,  menuZ + secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
objectivesDownBtn = {
    index = 1, label = "<-", click_function = "objectivesDown", function_owner = self,
    position = {menuX - arrowOffset, 5,  menuZ + secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
objectivesOffsetMenuBtn = {
    index = 1, label = "Height", click_function = "none", function_owner = self,
    position = {menuX + 1.4*arrowOffset, 5, menuZ}, rotation = {0, 0, 0}, height = 450, width = 1000,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
objectivesOffsetBtn = {
    label = tostring(objectivesOffset), click_function = "none", function_owner = self,
    position = {menuX + 5, 5, menuZ + 1.2}, rotation = {0, 0, 0}, height = 450, width = 1200,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
objectivesOffsetUpBtn = {
    index = 1, label = "+", click_function = "objectivesOffsetUp", function_owner = self,
    position = {menuX + 1.4*arrowOffset, 5, menuZ - secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}
objectivesOffsetDownBtn = {
    index = 1, label = "-", click_function = "objectivesOffsetDown", function_owner = self,
    position = {menuX + 1.4*arrowOffset, 5, menuZ + secondRowOffset}, rotation = {0, 0, 0}, height = 450, width = 800,
    font_size = 300, color = {0, 0, 0}, font_color = {1, 1, 1}
}

-- AREA DENIAL
areaPlaced = false
areaLblOpen = "Hide\nArea Denial"
areaLblClosed = "Show\nArea Denial"
areaBtn = {
    label = areaLblClosed, click_function = "showHideAreaDeny", function_owner = self,
    position = {menuX + 22, 5, menuZ }, rotation = {0, 0, 0}, height = 1500, width = 2600,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
engagePlaced = false
engageLblOpen = "Hide\nEngage/RBD"
engageLblClosed = "Show\nEngage/RBD"
engageBtn = {
    label = engageLblClosed, click_function = "showHideEngageRBD", function_owner = self,
    position = {menuX + 28, 5, menuZ}, rotation = {0, 0, 0}, height = 1500, width = 2600,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
quartersPlaced = false
quartersLblOpen = "Hide\nTable Quarters"
quartersLblClosed = "Show\nTable Quarters"
quartersBtn = {
    label = quartersLblClosed, click_function = "showHideQuarters", function_owner = self,
    position = {menuX + 16, 5, menuZ }, rotation = {0, 0, 0}, height = 1500, width = 2600,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
ftDarkGodsPlaced = false
ftDarkGodsLblOpen = "Hide\nFor The Dark Gods"
ftDarkGodsLblClosed = "Show\nFor The Dark Gods"
ftDarkGodsBtn = {
    label = ftDarkGodsLblClosed, click_function = "showHideftDarkGods", function_owner = self,
    position = {-menuX - 28, 5, menuZ }, rotation = {0, 0, 0}, height = 1500, width = 2600,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
stratreservesPlaced = false
stratreservesLblOpen = "Hide\nStrat Reserves"
stratreservesLblClosed = "Show\nStrat Reserves"
stratreservesBtn = {
    label = stratreservesLblClosed, click_function = "showHideStratreserves", function_owner = self,
    position = {-menuX - 22, 5, menuZ}, rotation = {0, 0, 0}, height = 1500, width = 2600,
    font_size = 300, color = {1, 1, 1}, font_color = {0, 0, 0}
}
position = {menuX, 5, menuZ}
 
 
 
 
function writeMenus()
    self.clearButtons()
    if not sizeConfirmed then
        writeSizeMenu()
        writeDeployMenu()
        writeObjMenu()
    else
        if inGame == false then
            writeStartMenu()
            writeDeployMenu()
            writeObjMenu()
        else
            writeIngameMenu()
        end
    end
 
end
 
function writeStartMenu()
    if gameMode ~= "game" then return end
    self.createButton(startBtn)
    self.createButton(firstPlayerBtn)
end
 
function writeDeployMenu()
    local DeployListSelected=DeployZonesData[deployTypeSelected].zones
    deployBtn.label = DeployListSelected[deploySelected].name
    deployTypeBtn.label = DeployZonesData[deployTypeSelected].type
    self.createButton(deployTypeBtn)
    self.createButton(deployTypeUpBtn)
    self.createButton(deployTypeDownBtn)
    self.createButton(deployBtn)
    self.createButton(deployUpBtn)
    self.createButton(deployDownBtn)
    self.createButton(deployOffsetMenuBtn)
    self.createButton(deployOffsetUpBtn)
    self.createButton(deployOffsetDownBtn)
    self.createButton(deployTypeMenuBtn)
    self.createButton(areaBtn)
    self.createButton(quartersBtn)
    self.createButton(engageBtn)
    self.createButton(ftDarkGodsBtn)
    self.createButton(stratreservesBtn)
end

function writeObjMenu()
    if not objectivesData[objectivesTypeSelected].objectivesList then
        return
    end
    if #objectivesData[objectivesTypeSelected].objectivesList == 0 then
        return
    end

    local selectedObjectivesBySize = objectivesData[objectivesTypeSelected].objectivesList
    if not selectedObjectivesBySize[objectivesSelected] then
        objectivesSelected=#selectedObjectivesBySize
    end
    objectivesBtn.label = selectedObjectivesBySize[objectivesSelected].name
    objectivesTypeBtn.label = objectivesData[objectivesTypeSelected].type
    objectivesOffsetBtn.label = tostring(objectivesOffset)

    self.createButton(objectivesMenuBtn)

    self.createButton(objectivesTypeBtn)
    self.createButton(objectivesTypeUpBtn)
    self.createButton(objectivesTypeDownBtn)

    self.createButton(objectivesBtn)
    self.createButton(objectivesUpBtn)
    self.createButton(objectivesDownBtn)

    self.createButton(objectivesOffsetDownBtn)
    self.createButton(objectivesOffsetUpBtn)
    self.createButton(objectivesOffsetMenuBtn)
end

function writeIngameMenu()
    self.createButton(areaBtn)
    self.createButton(engageBtn)
    self.createButton(quartersBtn)
    self.createButton(ftDarkGodsBtn)
    self.createButton(stratreservesBtn)
    self.createButton(deployIngameBtn)
    local DeployListSelected=DeployZonesData[deployTypeSelected].zones

    nextPhaseBtn.color = currentTurn
    local visibleTo=nextPhaseBtn.color
    Global.UI.setAttribute("passTurn", "visibility", visibleTo)
    Global.UI.setAttribute("passTurnBtn", "color", nextPhaseBtn.color)
    nextPhaseBtn.label = phases[currentPhase].."\nNEXT PHASE"
    if currentPhase == #phases then
        nextPhaseBtn.label = phases[currentPhase].."\nPASS TURN"
    end
    Global.UI.setValue("passTurnTxt", nextPhaseBtn.label)
    self.createButton(nextPhaseBtn)
end

function startGame(obj, player, alt)
    if alt then
        simulation = true
    end
    local playerList = Player.getPlayers()
    local numberOfPlayers = 0
    for i, p in ipairs(playerList) do
        numberOfPlayers = numberOfPlayers + 1
    end

    if Player["Red"].seated == false or Player["Blue"].seated == false then
        broadcastToAll("Must have both players seated", {1, 0, 0})
        if simulation == false then
            return
        end
    end
    Global.call("recordPlayers")
    inGame = true
    secondaryObj_GUID = {"cff35b","471de1"}
    for i, guid in ipairs(secondaryObj_GUID) do
        if getObjectFromGUID(guid) then
            getObjectFromGUID(guid).call("writeMenu")
        end
    end

    startCustomTurns()
    destroyDeployZones()
    deploymentIngamePlaced = false
    areaPlaced = false
    local DeployListSelected=DeployZonesData[deployTypeSelected].zones
    broadcastToAll(phases[currentPhase].." phase", "Yellow")
    resetActivationTokens()
    Notes.setNotes("")
    writeMenus()
    simulation = false
end

function resetActivationTokens()
    for i, obj in ipairs(getAllObjects()) do
        if obj.getVar("BCBtype") == "ActivationToken" then
            obj.call("resetAlredyActed")
        end
    end
end

function nextPhaseFromGlobal(params)
    if not inGame then return end
    local alt_click = params.alt
    local player_color_click = params.color
    nextPhase(self, player_color_click, alt_click)
end

function nextPhase(obj, player_color_click, alt_click)
    resetActivationTokens()
    if alt_click then
        passTurn(obj, player_color_click, alt_click)
        return
    end
    currentPhase = currentPhase + 1
    if currentPhase > #phases then
        currentPhase = 1
        passTurn(obj, player_color_click, alt_click)
    end
    broadcastToAll(phases[currentPhase].." phase", "Yellow")
    writeMenus()
end

function passTurn(obj, player_color_click, alt_click)
    if player_color_click ~= currentTurn then

        if simulation then
            broadcastToAll("INTRUDER", "Pink")
        else
            return
        end

    end
    currentPhase = 1
    if currentTurn == "Red" then
        currentTurn = "Blue" -- it has to be the opposite
        blueTurnCounter.call("increaseSelf")
        blueCpCounter.Counter.increment()
		cyanCpCounter.Counter.increment()
        if cpEveryTurn then
          redCpCounter.Counter.increment()
		  orangeCpCounter.Counter.increment()
          Wait.time(function() broadcastToAll("Both CPs incremented!", "White") end, 0.3)
        else
          Wait.time(function() broadcastToAll("Blue CPs incremented!", "Blue") end, 0.3)
        end
    else
        currentTurn = "Red"
        redTurnCounter.call("increaseSelf")
        redCpCounter.Counter.increment()
		orangeCpCounter.Counter.increment()
        if cpEveryTurn then
          blueCpCounter.Counter.increment()
		  cyanCpCounter.Counter.increment()
          Wait.time(function() broadcastToAll("Both CPs incremented!", "White") end, 0.3)
        else
          Wait.time(function() broadcastToAll("Red CPs incremented!", "Red") end, 0.3)
        end
    end
    if simulation then
        broadcastToAll("It's "..currentTurn.." turn", currentTurn)
    else
        if Player[currentTurn].steam_name then
            broadcastToAll("It's "..Player[currentTurn].steam_name.." turn", currentTurn)
        else
            broadcastToAll("It's "..currentTurn.." turn", currentTurn)
        end
    end
    writeMenus()
end

function startCustomTurns()
    if first == "Red" then
        currentTurn = "Blue" -- it has to be the opposite
    else
        currentTurn = "Red"
    end
    passTurn(self, currentTurn, false)
end

function startBuiltinTurns()
    if first == "Red" then
        Turns.order = {"Red", "Blue"}
    else
        Turns.order = {"Blue", "Red"}
    end
    Turns.pass_turns = true
    Turns.enable = false
    Turns.enable = true
end

function togglePlyr()
    self.clearButtons()
    if first == "Red" then
        firstPlayerBtn.label = blueFirstLbl
        firstPlayerBtn.color = {0, 0, 1}
        first = "Blue"
    else
        firstPlayerBtn.label = redFirstLbl
        firstPlayerBtn.color = {1, 0, 0}
        first = "Red"
    end
    writeMenus()
end

function placeDeploy()
    destroyDeployZones()
    local data= DeployZonesData[deployTypeSelected].zones[deploySelected]
    drawDeployZone(data)
    if data.objectivesID then
        for i, setup in ipairs(objectivesData[objectivesTypeSelected].objectivesList) do
            if setup.id == data.objectivesID then
                objectivesSelected = i
                for j, type in ipairs(objectivesData) do
                    if type.id ==  DeployZonesData[deployTypeSelected].id then
                        objectivesTypeSelected = j
                    end
                end
                spawnObjectives()
            end
        end
    end
    writeMenus()
end

function deployTypeUp()
    deployTypeUpDown(true)
end

function deployTypeDown()
    deployTypeUpDown(false)
end

function deployTypeUpDown(upDown)
    deploymentPregamePlaced = true

    --if DeployZonesData[deployTypeSelected][deploySelected].objectivesID then
    --    destroyAllObjectives()
    --end
    local add=1
    if not upDown then
        add=-1
    end
    if upDown == nil then
        add = 0
    end
    deployTypeSelected = deployTypeSelected + add
    if deployTypeSelected > #DeployZonesData then
        deployTypeSelected = 1
    end
    if deployTypeSelected < 1 then
        deployTypeSelected = #DeployZonesData
    end

    for i, obj in ipairs(objectivesData) do
        if DeployZonesData[deployTypeSelected].objectivesID then
            if obj.id == DeployZonesData[deployTypeSelected].objectivesID then
                objectivesTypeSelected = i
                break
            end
        else
            if obj.id == DeployZonesData[deployTypeSelected].id then
                objectivesTypeSelected = i
                break
            end
        end

    end
    objectivesSelected = #objectivesData[objectivesTypeSelected].objectivesList
    deploySelected = #DeployZonesData[deployTypeSelected].zones

    writeMenus()
    placeDeploy()
    destroyAllObjectives()
end

function deployUp()
    deployUpDown(true)
end

function deployDown()
    deployUpDown(false)
end

function deployUpDown(upDown)
    deployOffset=0
    deploymentPregamePlaced = true
    if DeployZonesData[deployTypeSelected].zones[deploySelected].objectivesID then
        destroyAllObjectives()
    end
    local add=1
    if not upDown then
        add=-1
    end
    deploySelected = deploySelected + add
    if deploySelected > #DeployZonesData[deployTypeSelected].zones then
        deploySelected = 1
    end
    if deploySelected < 1 then
        deploySelected = #DeployZonesData[deployTypeSelected].zones
    end
    writeMenus()
    placeDeploy()
end

function deployOffsetUp()
    deployOffsetUpDown(true)
end

function deployOffsetDown()
    deployOffsetUpDown(false)
end

function deployOffsetUpDown(upDown) -- true up, false down
    local amt = 1
    if not upDown then amt = -1 end
    deployOffset = deployOffset + amt
    if deployOffset > 25 then
        deployOffset = 25
    end
    if deployOffset < 0 then
        deployOffset = 0
    end
    writeMenus()
    setDeployHeight()
end


function objectivesUp()
    objectivesUpDown(true)
end

function objectivesDown()
    objectivesUpDown(false)
end

function objectivesUpDown(upDown)
    objectivesOffset=0
    local add = 1
    if not upDown then
        add = -1
    end
    objectivesSelected = objectivesSelected + add
    if objectivesSelected > #objectivesData[objectivesTypeSelected].objectivesList then
        objectivesSelected = 1
    end
    if objectivesSelected < 1 then
        objectivesSelected = #objectivesData[objectivesTypeSelected].objectivesList
    end
    writeMenus()
    spawnObjectives()
end

function objectivesTypeUp()
    objectivesTypeUpDown(true)
end

function objectivesTypeDown()
    objectivesTypeUpDown(false)
end

function objectivesTypeUpDown(upDown)
    local add = 1
    if not upDown then
        add = -1
    end
    objectivesTypeSelected = objectivesTypeSelected + add
    if objectivesTypeSelected > #objectivesData then
        objectivesTypeSelected = 1
    end
    if objectivesTypeSelected < 1 then
        objectivesTypeSelected = #objectivesData
    end
    objectivesSelected = #objectivesData[objectivesTypeSelected].objectivesList
    writeMenus()
    spawnObjectives()
end

function objectivesOffsetUp()
    objectivesOffsetUpDown(true)
end

function objectivesOffsetDown()
    objectivesOffsetUpDown(false)
end

function objectivesOffsetUpDown(upDown) -- true up, false down
    local amt = 0.02
    if not upDown then amt = -0.02 end
    objectivesOffset = objectivesOffset + amt
    if objectivesOffset > 25 then
        objectivesOffset = 25
    end
    if objectivesOffset < 0 then
        objectivesOffset = 0
    end
    writeMenus()
    setObjectivesHeight()
end


function showHideIngameDeployment()
    if deploymentIngamePlaced == false then -- place
        deployIngameBtn.label = deployIngameLblOpen
        if deploySelected < #DeployZonesData[deployTypeSelected].zones then
            drawDeployZone(DeployZonesData[deployTypeSelected].zones[deploySelected])
        end
        deploymentIngamePlaced = true
    else -- recall
        deployIngameBtn.label = deployIngameLblClosed
        if deploySelected < #DeployZonesData[deployTypeSelected].zones then
            destroyDeployZones()
        end
        deploymentIngamePlaced = false
    end
    writeMenus()
end

function showHideAreaDeny()
    if areaPlaced == false then -- place
        areaBtn.label = areaLblOpen
        drawCircle({color="White", fromCenter=6}, "areaDeny")
        drawCircle({color="White", fromCenter=12}, "areaDeny")
        areaPlaced = true
    else -- recall
        areaBtn.label = areaLblClosed
        for i, obj in ipairs(getAllObjects()) do
            if obj.getGMNotes() == "areaDeny" then
                obj.destroy()
            end
        end
        areaPlaced = false
    end
    writeMenus()
end

function showHideEngageRBD()
    if not engagePlaced then
        engageBtn.label = engageLblOpen

        local mat = getObjectFromGUID(mat_GUID)
        local lineScale = {x = 0, y = deployLineHeight, z = 0.02}
        local mapBase = mat.getScale().z * sizeMulti -- short edge
        local mapHeight = mat.getScale().x * sizeMulti -- long edge

        -- 4-quarter Engage lines
        xLength = (mapHeight / 2) - 3
        zLength = (mapBase / 2) - 3
        lineScale.x = xLength
        --(linePos, lineRot, lineScale, color, orientation, type)
        spawnLine({(xLength / 2) + 3, deployLineHeight, -3}, {0, 0, 0}, lineScale, "White", "engageRBD")
        spawnLine({(xLength / 2) + 3, deployLineHeight, 3}, {0, 0, 0}, lineScale, "White", "engageRBD")
        spawnLine({((xLength / 2) * -1) - 3, deployLineHeight, -3}, {0, 0, 0}, lineScale, "White", "engageRBD")
        spawnLine({((xLength / 2) * -1) - 3, deployLineHeight, 3}, {0, 0, 0}, lineScale, "White", "engageRBD")
        lineScale.x = zLength
        spawnLine({-3, deployLineHeight, (zLength / 2) + 3}, {0, 90, 0}, lineScale, "White", "engageRBD")
        spawnLine({3, deployLineHeight, (zLength / 2) + 3}, {0, 90, 0}, lineScale, "White", "engageRBD")
        spawnLine({-3, deployLineHeight, (((zLength / 2) * -1) - 3)}, {0, 90, 0}, lineScale, "White", "engageRBD")
        spawnLine({3, deployLineHeight, (((zLength / 2) * -1) - 3)}, {0, 90, 0}, lineScale, "White", "engageRBD")

        -- 3-quarter Engage / Retrieve Battlefield Data lines
        xLength = (mapHeight / 2) - 6
        zLength = (mapBase / 2) - 6
        lineScale.x = xLength
        --(linePos, lineRot, lineScale, color, orientation, type)
        spawnLine({(xLength / 2) + 6, deployLineHeight, -6}, {0, 0, 0}, lineScale, "White", "engageRBD")
        spawnLine({(xLength / 2) + 6, deployLineHeight, 6}, {0, 0, 0}, lineScale, "White", "engageRBD")
        spawnLine({((xLength / 2) * -1) - 6, deployLineHeight, -6}, {0, 0, 0}, lineScale, "White", "engageRBD")
        spawnLine({((xLength / 2) * -1) - 6, deployLineHeight, 6}, {0, 0, 0}, lineScale, "White", "engageRBD")
        lineScale.x = zLength
        spawnLine({-6, deployLineHeight, (zLength / 2) + 6}, {0, 90, 0}, lineScale, "White", "engageRBD")
        spawnLine({6, deployLineHeight, (zLength / 2) + 6}, {0, 90, 0}, lineScale, "White", "engageRBD")
        spawnLine({-6, deployLineHeight, (((zLength / 2) * -1) - 6)}, {0, 90, 0}, lineScale, "White", "engageRBD")
        spawnLine({6, deployLineHeight, (((zLength / 2) * -1) - 6)}, {0, 90, 0}, lineScale, "White", "engageRBD")

        engagePlaced = true
    else
        engageBtn.label = engageLblClosed

        for i, obj in ipairs(getAllObjects()) do
            if obj.getGMNotes() == "engageRBD" then
                obj.destroy()
            end
        end
        engagePlaced = false
    end

    writeMenus()
end

function showHideQuarters()
    if quartersPlaced == false then -- place
        quartersBtn.label = quartersLblOpen
        local mat = getObjectFromGUID(mat_GUID)
        local lineScale = {x = 5, y = deployLineHeight, z = 0.02}
        local mapBase = mat.getScale().z * sizeMulti --short edge
        local mapHeight = mat.getScale().x * sizeMulti --long edge
        --(linePos, lineRot, lineScale, color, orientation, type)
        lineScale.x = mapHeight
        spawnLine({0, deployLineHeight, 0}, {0,0,0}, lineScale, "White", "quarter")
        lineScale.x = mapBase
        spawnLine({0, deployLineHeight ,0}, {0,90,0}, lineScale, "White", "quarter")
        quartersPlaced = true
    else -- recall
        quartersBtn.label = quartersLblClosed
        for i, obj in ipairs(getAllObjects()) do
            if obj.getGMNotes() == "quarter" then
                obj.destroy()
            end
        end
        quartersPlaced = false
    end
    writeMenus()
end

function showHideftDarkGods()
    if not ftDarkGodsPlaced then -- place
        ftDarkGodsBtn.label = ftDarkGodsLblOpen
        local mat = getObjectFromGUID(mat_GUID)
        local lineScale = {x = 5, y = deployLineHeight, z = 0.02}
        local mapBase = mat.getScale().z * sizeMulti   -- short edge
        local mapHeight = mat.getScale().x * sizeMulti -- long edge

        drawCircleNotCentered({color="White", fromCenter=6}, "ftDarkGods", mapHeight / 4, mapBase / 4)
        drawCircleNotCentered({color="White", fromCenter=6}, "ftDarkGods", -mapHeight / 4, mapBase / 4)
        drawCircleNotCentered({color="White", fromCenter=6}, "ftDarkGods", mapHeight / 4, -mapBase / 4)
        drawCircleNotCentered({color="White", fromCenter=6}, "ftDarkGods", -mapHeight / 4, -mapBase / 4)
        ftDarkGodsPlaced = true
    else -- recall
        ftDarkGodsBtn.label = ftDarkGodsLblClosed
        for i, obj in ipairs(getAllObjects()) do
            if obj.getGMNotes() == "ftDarkGods" then
                obj.destroy()
            end
        end
        ftDarkGodsPlaced = false
    end
    writeMenus()
end

function showHideStratreserves()
    if not stratreservesPlaced then
        stratreservesBtn.label = stratreservesLblOpen

        local DeployListSelected=DeployZonesData[deployTypeSelected].zones
        local playerSides = "None"

        -- check that a deployment zone has been specified to determine which sides to colour
        if DeployListSelected[deploySelected].name ~= "None" then
            local deployZoneLayout = DeployListSelected[deploySelected].draw[1]
            playerSides = "long"

            -- check if deployment has short sides as Player Sides
            if deployZoneLayout["type"] == "line" and deployZoneLayout["position"] == "x" then
                playerSides = "short"
            elseif deployZoneLayout["type"] == "triangle" then
                playerSides = "short"
            end
        end

        local mat = getObjectFromGUID(mat_GUID)
        local lineScale = {x = 0, y = deployLineHeight, z = 0.02}
        local mapBase = mat.getScale().z * sizeMulti -- short edge
        local mapHeight = mat.getScale().x * sizeMulti -- long edge

        -- Strategic reserves lines
        --(linePos, lineRot, lineScale, color, orientation, type)
        lineScale.x = mapHeight

        if playerSides == "long" then
            spawnLine({0, deployLineHeight, (mapBase / 2) - 6}, {0, 0, 0}, lineScale, "Red", "stratreserves")
            spawnLine({0, deployLineHeight, -((mapBase / 2) - 6)}, {0, 0, 0}, lineScale, "Teal", "stratreserves")
        else
            spawnLine({0, deployLineHeight, (mapBase / 2) - 6}, {0, 0, 0}, lineScale, "White", "stratreserves")
            spawnLine({0, deployLineHeight, -((mapBase / 2) - 6)}, {0, 0, 0}, lineScale, "White", "stratreserves")
        end
        lineScale.x = mapBase

        if playerSides == "short" then
            spawnLine({(mapHeight / 2) - 6, deployLineHeight, 0}, {0, 90, 0}, lineScale, "Red", "stratreserves")
            spawnLine({-((mapHeight / 2) - 6), deployLineHeight, 0}, {0, 90, 0}, lineScale, "Teal", "stratreserves")
        else
            spawnLine({(mapHeight / 2) - 6, deployLineHeight, 0}, {0, 90, 0}, lineScale, "White", "stratreserves")
            spawnLine({-((mapHeight / 2) - 6), deployLineHeight, 0}, {0, 90, 0}, lineScale, "White", "stratreserves")
        end

        stratreservesPlaced = true
    else
        stratreservesBtn.label = stratreservesLblClosed

        for i, obj in ipairs(getAllObjects()) do
            if obj.getGMNotes() == "stratreserves" then
                obj.destroy()
            end
        end
        stratreservesPlaced = false
    end

    writeMenus()
end

function recallAll()
    destroyAllObjectives()
    destroyDeployZones()
end

function none()
end