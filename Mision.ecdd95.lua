function onSave()
	local data_to_save = {my_count = my_count, label = label, tooltip = tooltip}
	saved_data = JSON.encode(data_to_save)
	return saved_data
end

function onLoad(saved_data)
	if saved_data ~= "" then
		local loaded_data = JSON.decode(saved_data)
		my_count = loaded_data.my_count
		label = loaded_data.label
		tooltip = loaded_data.tooltip
	else
		my_count = 11
		label = "Mission"
		tooltip = ""
	end
	
  all_objects = getAllObjects()
  for _, object in ipairs(all_objects) do
    if object.getName() == 'J1_Primaria' then
      J1_Primaria_GUID = object.getGUID()
	  elseif object.getName() == 'J2_Primaria' then
      J2_Primaria_GUID = object.getGUID()
    end
  end
  
  J1_Primaria = getObjectFromGUID(J1_Primaria_GUID)
  J2_Primaria = getObjectFromGUID(J2_Primaria_GUID)
  
  self.createButton({
    click_function = 'clicked',
    function_owner = self,
    label          = tostring(label),
    position       = {0,0.5,0},
    width          = 5000,
    height         = 500,
    font_size      = 350,
	tooltip        = tostring(tooltip),
  })

end

function clicked()
    if my_count == 11 then
        self.editButton({
        label = "11 - Recover the Relics",
		tooltip = "[i][b]Take and Hold: 1, 2, +[/i][/b]\n\n[b]Recover Relics:[/b]\nIn this mission, a player only receives the Battle-forged CP bonus at the start of their Command phase if they control either one or more objective markers in their opponent´s territory, or if they control one or more objective markers in no man´s land. In addition, if at the start of their Command phase a player controls the objective marker in their opponent´s deployment zone, that player recieves 1 additional Command point (this is in addition to the Battle-forged CP bonus)."})
        my_count = 12
		label = "11 - Recover the Relics"
		tooltip = "[i][b]Take and Hold: 1, 2, +[/i][/b]\n\n[b]Recover Relics:[/b]\nIn this mission, a player only receives the Battle-forged CP bonus at the start of their Command phase if they control either one or more objective markers in their opponent´s territory, or if they control one or more objective markers in no man´s land. In addition, if at the start of their Command phase a player controls the objective marker in their opponent´s deployment zone, that player recieves 1 additional Command point (this is in addition to the Battle-forged CP bonus)."
        J1_Primaria.call('mision11')
		J2_Primaria.call('mision11')

    elseif my_count == 12 then       
        self.editButton({
        label = "12 - Tear Down Their Icons",
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\nIn this mission, units from both players army can attempt the following actions:\n\n[b]Prime Explosives (Action):[/b]\nOne unit from your army can start to perform this action at the end of your Movement phase if it is wholly within your opponent´s territory and it is more than 9" away from any Primed Explosives objective markers (see below). If the unit performing this action has the Objective Secured ability or a similar rule, this action is completed at the end of your turn; otherwise, it is completed at the end of your next Command phase. If this action is successfully completed, set up 1 Primed Explosives objective marker on the battlefield that is wholly within you opponent´s territory and wholly within 3" of the unit that completed this action - this represents a cache of Primed Explosives, but does not count as an objective marker for any rules purposes other than for the Defuse Explosives action and the Detonation primary objective.\n\n[b]Defuse Explosives (Action):[/b]\nOne unit from your army can start to perfom this action at the end of your Movement phase if it is within range of a Primed Explosives objective marker within your own territory and no enemy units (excluding AIRCRAFT) are within range of the same Primed Explosives objective marker. This action is completed at the end of your turn provided the unit attempting it is still within range of the same Primed Explosives objective marker. If this action is successfully completed, roll one D6 and add 3 to the result if the unit that performed this action has the Objective Secure ability or a similar rule: on a 4+, remove that Primed Explosives objective marker from the battlefield.'})
        my_count = 13
		label = "12 - Tear Down Their Icons"
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\nIn this mission, units from both players army can attempt the following actions:\n\n[b]Prime Explosives (Action):[/b]\nOne unit from your army can start to perform this action at the end of your Movement phase if it is wholly within your opponent´s territory and it is more than 9" away from any Primed Explosives objective markers (see below). If the unit performing this action has the Objective Secured ability or a similar rule, this action is completed at the end of your turn; otherwise, it is completed at the end of your next Command phase. If this action is successfully completed, set up 1 Primed Explosives objective marker on the battlefield that is wholly within you opponent´s territory and wholly within 3" of the unit that completed this action - this represents a cache of Primed Explosives, but does not count as an objective marker for any rules purposes other than for the Defuse Explosives action and the Detonation primary objective.\n\n[b]Defuse Explosives (Action):[/b]\nOne unit from your army can start to perfom this action at the end of your Movement phase if it is within range of a Primed Explosives objective marker within your own territory and no enemy units (excluding AIRCRAFT) are within range of the same Primed Explosives objective marker. This action is completed at the end of your turn provided the unit attempting it is still within range of the same Primed Explosives objective marker. If this action is successfully completed, roll one D6 and add 3 to the result if the unit that performed this action has the Objective Secure ability or a similar rule: on a 4+, remove that Primed Explosives objective marker from the battlefield.'
        J1_Primaria.call('mision12')
		J2_Primaria.call('mision12')
        
    elseif my_count == 13 then       
        self.editButton({
        label = "13 - Data Scry-Salvage",
		tooltip = '[i][b]Domination: 2, 3, +[/i][/b]\n\nIn this mission, units from both players army can attempt the following actions:\n\n[b]Data Intercept (Action):[/b]\nOne unit from your army can start to perfom this action at the end of your Movement phase if it is within range of the objective marker within its own deployment zone and no enemy units (excluding AIRCRAFT) are within range of that objective marker. This action is completed at the end of your turn, provided the unit attempting it is still within range of that objective marker.\n\n[b]Data Terminals:[/b]\nIn this mission, if a player controls an objective marker that is in no man´s land at the end of their Command phase and one or more of their units that are in range of it has the Objective Secured ability or a similar rule, it remains under that player´s control unless their opponent controls it at the end of any subsequent phase, even if there are no models within range of it.'})
        my_count = 21
		label = "13 - Data Scry-Salvage"
		tooltip = '[i][b]Domination: 2, 3, +[/i][/b]\n\nIn this mission, units from both players army can attempt the following actions:\n\n[b]Data Intercept (Action):[/b]\nOne unit from your army can start to perfom this action at the end of your Movement phase if it is within range of the objective marker within its own deployment zone and no enemy units (excluding AIRCRAFT) are within range of that objective marker. This action is completed at the end of your turn, provided the unit attempting it is still within range of that objective marker.\n\n[b]Data Terminals:[/b]\nIn this mission, if a player controls an objective marker that is in no man´s land at the end of their Command phase and one or more of their units that are in range of it has the Objective Secured ability or a similar rule, it remains under that player´s control unless their opponent controls it at the end of any subsequent phase, even if there are no models within range of it.'
        J1_Primaria.call('mision13')
		J2_Primaria.call('mision13')

    elseif my_count == 21 then       
        self.editButton({
        label = "21 - Abandoned Sanctuaries",
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\n[b]No Man´s Land:[/b]\nIf a unit has a pre-battle rule that allows it to be set up anywhere on the battlefield, that unit cannot be set up in no man’s land. If a unit has a rule that allows it to make a move before the first turn begins, it cannot end that move in no man’s land. If any rule is used to redeploy a unit, that rule cannot be used to set that unit up in no man’s land. Reinforcement units that are set up on the battlefield during the first battle round cannot be set up in no man’s land.'})
        my_count = 22
		label = "21 - Abandoned Sanctuaries"
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\n[b]No Man´s Land:[/b]\nIf a unit has a pre-battle rule that allows it to be set up anywhere on the battlefield, that unit cannot be set up in no man’s land. If a unit has a rule that allows it to make a move before the first turn begins, it cannot end that move in no man’s land. If any rule is used to redeploy a unit, that rule cannot be used to set that unit up in no man’s land. Reinforcement units that are set up on the battlefield during the first battle round cannot be set up in no man’s land.'
        J1_Primaria.call('mision21')
		J2_Primaria.call('mision21')

    elseif my_count == 22 then       
        self.editButton({
        label = "22 - Conversion",
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\n[b]Leading From the Front:[/b]\nIn this mission, at the start of each player’s Command phase, if a player’s WARLORD is not on the battlefield or it is not embarked within a TRANSPORT model that is on the battlefield, roll one D6: on a 1-3 that player does not receive the Battle-forged CP bonus this phase.'})
        my_count = 23
		label = "22 - Conversion"
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\n[b]Leading From the Front:[/b]\nIn this mission, at the start of each player’s Command phase, if a player’s WARLORD is not on the battlefield or it is not embarked within a TRANSPORT model that is on the battlefield, roll one D6: on a 1-3 that player does not receive the Battle-forged CP bonus this phase.'
        J1_Primaria.call('mision22')
		J2_Primaria.call('mision22')

    elseif my_count == 23 then       
        self.editButton({
        label = "23 - The Scouring",
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\nIn this mission, units from both players army can attempt the following action:\n\n[b]Auspex Scan (Action):[/b]\nOne unit from your army can start to perform this action at the end of your Movement phase if it is within range of an objective marker that has not been scanned by a unit from your army (see below). A unit cannot start this action while there are any enemy units (excluding AIRCRAFT units) within range of the same objective marker. This action is completed at the end of your turn, provided the unit performing it is still within range of the same objective marker. If completed, that objective marker is said to have been scanned by your army.'})
        my_count = 31
		label = "23 - The Scouring"
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\nIn this mission, units from both players army can attempt the following action:\n\n[b]Auspex Scan (Action):[/b]\nOne unit from your army can start to perform this action at the end of your Movement phase if it is within range of an objective marker that has not been scanned by a unit from your army (see below). A unit cannot start this action while there are any enemy units (excluding AIRCRAFT units) within range of the same objective marker. This action is completed at the end of your turn, provided the unit performing it is still within range of the same objective marker. If completed, that objective marker is said to have been scanned by your army.'
        J1_Primaria.call('mision23')
		J2_Primaria.call('mision23')

    elseif my_count == 31 then       
        self.editButton({
        label = "31 - Tide of Conviction",
		tooltip = '[i][b]Domination: 2, 3, +[/i][/b]\n\n[b]Supply Lines:[/b]\nIn this mission, at the start of each player’s Command phase, if a player does not control the objective marker in their deployment zone, roll one D6: on a 1-3 that player does not receive the Battle-forged CP bonus this phase.'})
        my_count = 32
		label = "31 - Tide of Conviction"
		tooltip = '[i][b]Domination: 2, 3, +[/i][/b]\n\n[b]Supply Lines:[/b]\nIn this mission, at the start of each player’s Command phase, if a player does not control the objective marker in their deployment zone, roll one D6: on a 1-3 that player does not receive the Battle-forged CP bonus this phase.'
        J1_Primaria.call('mision31')
		J2_Primaria.call('mision31')

    elseif my_count == 32 then       
        self.editButton({
        label = "32 - Death and Zeal",
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\n[b]Objective Purged:[/b]\nIn this mission, if a player controls an objective marker at the end of their Command phase and one or more of their units that are within range of it has the Objective secured ability, it remains under that players control unless their opponent controls it at the end of any subsequent phase, even if there are no models within range of it.'})
        my_count = 33
		label = "32 - Death and Zeal"
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\n[b]Objective Purged:[/b]\nIn this mission, if a player controls an objective marker at the end of their Command phase and one or more of their units that are within range of it has the Objective secured ability, it remains under that players control unless their opponent controls it at the end of any subsequent phase, even if there are no models within range of it.'
        J1_Primaria.call('mision32')
		J2_Primaria.call('mision32')

    elseif my_count == 33 then       
        self.editButton({
        label = "33 - Secure Missing Artefacts",
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\n[b]Precious Objectives:[/b]\nAfter players have chosen their deployment zones, but before they declare reserves and transports, the players reposition the objective markers labelled A and B as described below:\n\n- First, the Attacker repositions either one objective marker labelled A or one objective marker labelled B.\n\n- Secondly, the Defender repositions one objective marker labelled A and one objective marker labelled B (an objective marker cannot be repositioned more than once).\n\n- Finally, the Attacker repositions the last objective marker labelled A or B that has yet to be repositioned.\n\nIn all cases, when an objective marker is repositioned, you set it up wholly within 6" horizontally of its original position, and not on or whitin any Obstacles or Defensible Terrain features.\n\nAfter all objective markers have been repositioned, each player secretly notes down one of the objective markers that is within their opponent´s territory to be a Priority objective marker (this cannot be the objective marker in the center of the battlefield). After both players have deployed their armies, they reveal their choices to their opponent.'})
        my_count = 11
		label = "33 - Secure Missing Artefacts"
		tooltip = '[i][b]Take and Hold: 1, 2, +[/i][/b]\n\n[b]Precious Objectives:[/b]\nAfter players have chosen their deployment zones, but before they declare reserves and transports, the players reposition the objective markers labelled A and B as described below:\n\n- First, the Attacker repositions either one objective marker labelled A or one objective marker labelled B.\n\n- Secondly, the Defender repositions one objective marker labelled A and one objective marker labelled B (an objective marker cannot be repositioned more than once).\n\n- Finally, the Attacker repositions the last objective marker labelled A or B that has yet to be repositioned.\n\nIn all cases, when an objective marker is repositioned, you set it up wholly within 6" horizontally of its original position, and not on or whitin any Obstacles or Defensible Terrain features.\n\nAfter all objective markers have been repositioned, each player secretly notes down one of the objective markers that is within their opponent´s territory to be a Priority objective marker (this cannot be the objective marker in the center of the battlefield). After both players have deployed their armies, they reveal their choices to their opponent.'
        J1_Primaria.call('mision33')
		J2_Primaria.call('mision33')
    end

end