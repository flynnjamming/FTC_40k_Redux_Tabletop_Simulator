--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]
--
-- The vast majority of the scripting used in this map template was done by ThePants999
--
-- Having all these GUIDs centrally managed helps to ensure that any changes to
-- them only need to be made in one place, and hard-to-find stuff isn't inadvertently
-- broken.
--
-- If you're looking at this and thinking "surely this should be a table" - why,
-- yes it should. Unfortunately, I saw the documentation for Object.getVar said
-- "Cannot return a table", and missed that Object.getTable existed, and now I'm
-- too lazy to change it all again.
centerCircle_GUID = "51ee2f"
templateObjective_GUID = "573333"
startMenu_GUID = "738804"
redDiceMat_GUID = "c57d70"
blueDiceMat_GUID = "a84ed2"
redDiceRoller_GUID = "beae28"
blueDiceRoller_GUID = "4e0e0b"
redSecondaryManager_GUID = "cff35b"
blueSecondaryManager_GUID = "471de1"
redSecondaryInputBox_GUID = "9e4193"
blueSecondaryInputBox_GUID = "394524"
redSecondaryDropdown_GUID = "3ef881"
blueSecondaryDropdown_GUID = "aca663"
redVPCounter_GUID = "8b0541"
blueVPCounter_GUID = "a77a54"
redCPCounter_GUID = "e446f7"
orangeCPCounter_GUID = "cb0096"
blueCPCounter_GUID = "deb9f2"
tealCPCounter_GUID = "94093c"
redTurnCounter_GUID = "055302"
blueTurnCounter_GUID = "7e4111"
gameTurnCounter_GUID = "ee92cf"
redHiddenZone_GUID="28419e"
blueHiddenZone_GUID="e1e91a"
scoresheet_GUID = "06d627"
blankObjCard_GUID = "d618cb"
activation_GUID = "229946"
wounds_GUID = "ad63ba"

table_GUID = "81b3e4"
felt_GUID = "81b3e4"
mat_GUID = "4ee1f2"
matURLDisplay_GUID = "c5e288"
flexControl_GUID = "bd69bd"
tableLeg1_GUID = "afc863"
tableLeg2_GUID = "c8edca"
tableLeg3_GUID = "393bf7"
tableLeg4_GUID = "12c65e"
tableSideBottom_GUID = "f938a2"
tableSideTop_GUID = "35b95f"
tableSideLeft_GUID = "9f95fd"
tableSideRight_GUID = "5af8f2"
extractTerrain_GUID = "70b9f6"

turnOrder = {}
nonPlaying = {"White", "Brown","Yellow","Green","Purple","Pink" }
allowMenu = true
allowAutoSeat = true
redPlayerID = ""
bluePlayerID = ""
startMenu = nil

function nextPhase(playerObj, button, elementId)
    local altClick= false
    local playerColor=playerObj.color

    if button ~= "-1" then
        altClick =  true
    end
    startMenu.call("nextPhaseFromGlobal", {alt=altClick, color=playerColor})
end


function onSave()
    saved_data = JSON.encode({
                                svredPlayerID=redPlayerID,
                                svbluePlayerID=bluePlayerID
                            })
    --saved_data = ""
    return saved_data
end

function onLoad(saved_data)

    Turns.enable=false
    --- load vars from saved
    if saved_data ~= "" then
         local loaded_data = JSON.decode(saved_data)
         redPlayerID = loaded_data.svredPlayerID
         bluePlayerID = loaded_data.svbluePlayerIDs
    else
        redPlayerID=""
        bluePlayerID=""
    end
    ---- end loading
    startMenu=getObjectFromGUID(startMenu_GUID)
    if allowMenu then
        if allowAutoSeat and redPlayerID ~= "" and bluePlayerID ~= "" then --  if the game is not started dont autoseat
                autoSeatAll()
        else

            Global.UI.setAttribute("main", "active", "true")
            local presentPersons= Player.getPlayers()
            for i, person in ipairs(presentPersons) do
                person.team="Diamonds"
            end
            presentPersons= Player.getSpectators()
            for i, person in ipairs(presentPersons) do
                person.team="Diamonds"
            end
            showHideRedBlueBtn()
        end
    else
        Global.UI.setAttribute("main", "active", "false")
    end
end


function autoSeatPerson(_person)
    if _person.steam_id == redPlayerID then
        if Player.Red.seated then
            Player.Red.changeColor("Grey")
        end
        _person.changeColor("Red")
        _person.team="None"
        return
    end
    if _person.steam_id == bluePlayerID then
        if Player.Blue.seated then
            Player.Blue.changeColor("Grey")
        end
        _person.changeColor("Blue")
        _person.team="None"
        return
    end
    --_person.changeColor("Grey")
    _person.team="None"
end

function autoSeatGroup(persons)
    for i, person in ipairs(persons) do
        autoSeatPerson(person)
    end
end


function autoSeatAll()
    if redPlayerID=="" or bluePlayerID=="" then --  if the game is not started dont autoseat
        return
    end
    local presents = Player.getPlayers()
    autoSeatGroup(presents)
    presents = Player.getSpectators()
    autoSeatGroup(presents)
end

function recordPlayers()
    redPlayerID= Player.Red.steam_id
    bluePlayerID= Player.Blue.steam_id
end

function onPlayerChangeColor(player_color)
    promotePlayers()
    --demotePlayers()  -- RIC
    showHideRedBlueBtn()
end

function onPlayerConnect(player_id)
    if allowMenu then
        if allowAutoSeat and redPlayerID ~= "" and bluePlayerID ~= "" then --  if the game is not started dont autoseat
                autoSeatPerson(player_id)
        else
        player_id.team="Diamonds"
        end
    end
end

function promotePlayers()
    local colors={"Red", "Blue", "Orange", "Yellow", "Purple", "Teal"}
    for i, color in ipairs(colors) do
        if Player[color].seated and  Player[color].host == false then
             Player[color].promote(true)
        end
    end
end

function demotePlayers()
    for i, color in ipairs(nonPlaying) do
        if Player[color].seated  and Player[color].host == false then
            Player[color].promote(false)
        end
    end
    local spectators=Player.getSpectators()
    for i, person in ipairs(spectators) do
        if person.host == false then
            person.promote(false)
        end
    end
end

function showHideRedBlueBtn()
    if allowMenu then
        if Player.Red.seated == true then
            Global.UI.setAttribute("redBtn", "active", "false")
        else
            Global.UI.setAttribute("redBtn", "active", "true")
        end
        if Player.Blue.seated == true then
            Global.UI.setAttribute("blueBtn", "active", "false")
        else
            Global.UI.setAttribute("blueBtn", "active", "true")
        end
    end
end

function setViewForPlayer(player, color)
    if color=="Grey" then return end
    local pos= {0,0,0}
    if color == "Red" then
        pos = getObjectFromGUID(redDiceMat_GUID).getPosition()
    end
    if color == "Blue" then
        pos = getObjectFromGUID(blueDiceMat_GUID).getPosition()
    end
    player.lookAt({
        position = pos,
        pitch    = 25,
        yaw      = 180,
        distance = 20,
        })
end

function placeToColor(player, color)
    player.changeColor(color)
    player.team="None"
    broadcastToColor("READ INSTRUCTIONS FIRST!\n(Click Notebook at the top)", color, "Purple")
    --setViewForPlayer(player, color) --bugged
end

function placeToRed(player, value, id)
    placeToColor(player, "Red")
    --player.changeColor("Red")
    --player.team="None"
end

function placeToBlue(player, value, id)
    placeToColor(player, "Blue")
    --player.changeColor("Blue")
    --player.team="None"
end

function placeToGray(player, value, id)
    placeToColor(player, "Grey")
    --player.changeColor("Grey")
    --player.team="None"
end
function closeMenu(player, value, id)
    player.team="None"
    broadcastToColor("READ INSTRUCTIONS FIRST!\n(Click Notebook at the top)", player.color, "Purple")
end

backPosition={{0,0,0},{0,0,0},{0,0,0},{0,0,0}}