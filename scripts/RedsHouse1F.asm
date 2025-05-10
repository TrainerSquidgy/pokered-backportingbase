RedsHouse1F_Script:
	jp EnableAutoTextBoxDrawing

RedsHouse1F_TextPointers:
	def_text_pointers
	dw_const RedsHouse1FMomText, TEXT_REDSHOUSE1F_MOM
	dw_const RedsHouse1FTVText,  TEXT_REDSHOUSE1F_TV

RedsHouse1FMomText:
	text_asm
	ld a, [wStatusFlags4]
	bit BIT_GOT_STARTER, a
	jp nz, RedsHouse1FMomHealScript
	
	ld hl, RedsHouse1FMomProfOakQuestionsText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .noPerfectDVs
	ld a, 1
	ld [wStarterPerfectDVs], a
	ld hl, RedsHouse1FMomProfOakQuestionsTextYes
	call PrintText
	jr .DVsMerge
.noPerfectDVs
	ld hl, RedsHouse1FMomProfOakQuestionsTextNo
	call PrintText
	xor a
	ld [wStarterPerfectDVs], a
.DVsMerge
	
	ld hl, RedsHouse1FMomProfOakEvolutionsText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr z, .noEvolutionsDisabled
	ld hl, RedsHouse1FMomProfOakEvolutionsTextYes
	call PrintText
	ld a, 1
	ld [wEvolutionsDisabled], a
	jr .EvolutionsMerge
.noEvolutionsDisabled
	ld hl, RedsHouse1FMomProfOakEvolutionsTextNo
	call PrintText
	xor a
	ld [wEvolutionsDisabled], a
.EvolutionsMerge
	
	ld hl, RedsHouse1FMomProfOakHMFriendHelpText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .noHMFriends
	ld hl, RedsHouse1FMomProfOakHMFriendHelpTextYes
	call PrintText
	ld a, 1
	ld [wHMFriendHelp], a
	jr .HMFriendMerge
.noHMFriends
	ld hl, RedsHouse1FMomProfOakHMFriendHelpTextNo
	call PrintText
	xor a
	ld [wHMFriendHelp], a
.HMFriendMerge
	
	ld hl, RedsHouse1FMomProfOakDexHelpText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .noDexHelp
	ld hl, RedsHouse1FMomProfOakDexHelpTextYes
	call PrintText
	ld a, 1
	ld [wDexCatchingHelp], a
	jr .DexHelpMerge
.noDexHelp
	ld hl, RedsHouse1FMomProfOakDexHelpTextNo
	call PrintText
	xor a
	ld [wDexCatchingHelp], a
.DexHelpMerge
	ld hl, RedsHouse1FMomProfOakVermilionGymText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .noVermilionHelp
	ld hl, RedsHouse1FMomProfOakVermilionGymTextYes
	call PrintText
	ld a, 1
	ld [wVermilionGymHelp], a
	jr .VermilionHelpMerge
.noVermilionHelp
	ld hl, RedsHouse1FMomProfOakVermilionGymTextNo
	call PrintText
	xor a
	ld [wVermilionGymHelp], a
.VermilionHelpMerge
	ld hl, RedsHouse1FMomWakeUpText
	call PrintText
	ret

	
RedsHouse1FMomProfOakQuestionsText:
	text_far _RedsHouse1FMomProfOakQuestionsText
	text_end

RedsHouse1FMomProfOakQuestionsTextYes:
	text_far _RedsHouse1FMomProfOakQuestionsTextYes
	text_end

RedsHouse1FMomProfOakQuestionsTextNo:
	text_far _RedsHouse1FMomProfOakQuestionsTextNo
	text_end

RedsHouse1FMomProfOakEvolutionsText:
	text_far _RedsHouse1FMomProfOakEvolutionsText
	text_end

RedsHouse1FMomProfOakEvolutionsTextYes:
	text_far _RedsHouse1FMomProfOakEvolutionsTextYes
	text_end
RedsHouse1FMomProfOakEvolutionsTextNo:
	text_far _RedsHouse1FMomProfOakEvolutionsTextNo
	text_end

RedsHouse1FMomProfOakHMFriendHelpText:
	text_far _RedsHouse1FMomProfOakHMFriendHelpText
	text_end

RedsHouse1FMomProfOakHMFriendHelpTextYes:
	text_far _RedsHouse1FMomProfOakHMFriendHelpTextYes
	text_end

RedsHouse1FMomProfOakHMFriendHelpTextNo:
	text_far _RedsHouse1FMomProfOakHMFriendHelpTextNo
	text_end

RedsHouse1FMomProfOakDexHelpText:
	text_far _RedsHouse1FMomProfOakDexHelpText
	text_end

RedsHouse1FMomProfOakDexHelpTextYes:
	text_far _RedsHouse1FMomProfOakDexHelpTextYes
	text_end

RedsHouse1FMomProfOakDexHelpTextNo:
	text_far _RedsHouse1FMomProfOakDexHelpTextNo
	text_end

RedsHouse1FMomProfOakVermilionGymText:
	text_far _RedsHouse1FMomProfOakVermilionGymText
	text_end

RedsHouse1FMomProfOakVermilionGymTextYes:
	text_far _RedsHouse1FMomProfOakVermilionGymTextYes
	text_end

RedsHouse1FMomProfOakVermilionGymTextNo:
	text_far _RedsHouse1FMomProfOakVermilionGymTextNo
	text_end


RedsHouse1FMomHealScript:
	ld hl, RedsHouse1FMomYouShouldRestText
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite
	ld hl, RedsHouse1FMomLookingGreatText
	jp PrintText

RedsHouse1FMomYouShouldRestText:
	text_far _RedsHouse1FMomYouShouldRestText
	text_end
RedsHouse1FMomLookingGreatText:
	text_far _RedsHouse1FMomLookingGreatText
	text_end

RedsHouse1FTVText:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ld hl, .WrongSideText
	jr nz, .got_text
	ld hl, .StandByMeMovieText
.got_text
	call PrintText
	jp TextScriptEnd

.StandByMeMovieText:
	text_far _RedsHouse1FTVStandByMeMovieText
	text_end

.WrongSideText:
	text_far _RedsHouse1FTVWrongSideText
	text_end

RedsHouse1FMomWakeUpText:
	text_far _RedsHouse1FMomWakeUpText
	text_end
