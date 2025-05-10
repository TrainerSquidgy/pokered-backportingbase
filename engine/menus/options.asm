; To add custom starters to the Starter Selection Option, add their pointer to the bottom of StarterOptionStringsPointerTable (for example: dw StarterChikoritaText), add their string at the bottom of the list of strings (for example: StarterChikoritaText: db "CHIKORITA @", 0) - make sure to pad out the name with spaces to make it 10 characters long. Finally, replace "MEW" in .pressedRight and .pressedLeft with the name of the last Pokémon in the index order (for example, if you backported the entire Chikorita line, replace MEW with MEGANIUM).

DisplayOptionMenu_:
	call InitOptionsMenu
.optionMenuLoop
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	and START | B_BUTTON
	jr nz, .exitOptionMenu
	call OptionsControl
	jr c, .dpadDelay
	call GetOptionPointer
	jr c, .exitOptionMenu
.dpadDelay
	call OptionsMenu_UpdateCursorPosition
	call DelayFrame
	call DelayFrame
	call DelayFrame
	jr .optionMenuLoop
.exitOptionMenu
	ret

GetOptionPointer:
	ld a, [wOptionsCursorLocation]
	ld e, a
	ld d, $0
	ld hl, OptionMenuJumpTable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl ; jump to the function for the current highlighted option

OptionMenuJumpTable:
	dw OptionsMenu_TextSpeed
	dw OptionsMenu_BattleAnimations
	dw OptionsMenu_BattleStyle
	dw OptionsMenu_SpeakerSettings
	dw OptionsMenu_StarterChoice1 
	dw OptionsMenu_StarterChoice2 
	dw OptionsMenu_StarterChoice3 
	dw OptionsMenu_Dummy
	dw OptionsMenu_Cancel

OptionsMenu_TextSpeed:
	call GetTextSpeed
	ldh a, [hJoy5]
	bit BIT_D_RIGHT, a
	jr nz, .pressedRight
	bit BIT_D_LEFT, a
	jr nz, .pressedLeft
	jr .nonePressed
.pressedRight
	ld a, c
	cp $2
	jr c, .increase
	ld c, $ff
.increase
	inc c
	ld a, e
	jr .save
.pressedLeft
	ld a, c
	and a
	jr nz, .decrease
	ld c, $3
.decrease
	dec c
	ld a, d
.save
	ld b, a
	ld a, [wOptions]
	and $f0
	or b
	ld [wOptions], a
.nonePressed
	ld b, $0
	ld hl, TextSpeedStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 14, 2
	call PlaceString
	and a
	ret

TextSpeedStringsPointerTable:
	dw FastText
	dw MidText
	dw SlowText

FastText:
	db "FAST@"
MidText:
	db "MID @"
SlowText:
	db "SLOW@"

GetTextSpeed:
	ld a, [wOptions]
	and $f
	cp $5
	jr z, .slowTextOption
	cp $1
	jr z, .fastTextOption
; mid text option
	ld c, $1
	lb de, 1, 5
	ret
.slowTextOption
	ld c, $2
	lb de, 3, 1
	ret
.fastTextOption
	ld c, $0
	lb de, 5, 3
	ret

OptionsMenu_BattleAnimations:
	ldh a, [hJoy5]
	and D_RIGHT | D_LEFT
	jr nz, .asm_41d33
	ld a, [wOptions]
	and $80 ; mask other bits
	jr .asm_41d3b
.asm_41d33
	ld a, [wOptions]
	xor $80
	ld [wOptions], a
.asm_41d3b
	ld bc, $0
	sla a
	rl c
	ld hl, AnimationOptionStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 14, 4
	call PlaceString
	and a
	ret

AnimationOptionStringsPointerTable:
	dw AnimationOnText
	dw AnimationOffText

AnimationOnText:
	db "ON @"
AnimationOffText:
	db "OFF@"

OptionsMenu_BattleStyle:
	ldh a, [hJoy5]
	and D_LEFT | D_RIGHT
	jr nz, .asm_41d6b
	ld a, [wOptions]
	and $40 ; mask other bits
	jr .asm_41d73
.asm_41d6b
	ld a, [wOptions]
	xor $40
	ld [wOptions], a
.asm_41d73
	ld bc, $0
	sla a
	sla a
	rl c
	ld hl, BattleStyleOptionStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 14, 6
	call PlaceString
	and a
	ret

BattleStyleOptionStringsPointerTable:
	dw BattleStyleShiftText
	dw BattleStyleSetText

BattleStyleShiftText:
	db "SHIFT@"
BattleStyleSetText:
	db "SET  @"

OptionsMenu_SpeakerSettings:
	ld a, [wOptions]
	and $30
	swap a
	ld c, a
	ldh a, [hJoy5]
	bit BIT_D_RIGHT, a
	jr nz, .pressedRight
	bit BIT_D_LEFT, a
	jr nz, .pressedLeft
	jr .asm_41dca
.pressedRight
	ld a, c
	inc a
	and $3
	jr .asm_41dba
.pressedLeft
	ld a, c
	dec a
	and $3
.asm_41dba
	ld c, a
	swap a
	ld b, a
	xor a
	ldh [rNR51], a
	ld a, [wOptions]
	and $cf
	or b
	ld [wOptions], a
.asm_41dca
	ld b, $0
	ld hl, SpeakerOptionStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 8, 8
	call PlaceString
	and a
	ret

SpeakerOptionStringsPointerTable:
	dw MonoSoundText
	dw Earphone1SoundText
	dw Earphone2SoundText
	dw Earphone3SoundText

MonoSoundText:
	db "MONO     @"
Earphone1SoundText:
	db "EARPHONE1@"
Earphone2SoundText:
	db "EARPHONE2@"
Earphone3SoundText:
	db "EARPHONE3@"



OptionsMenu_Dummy:
	and a
	ret

OptionsMenu_Cancel:
	ldh a, [hJoy5]
	and A_BUTTON
	jr nz, .pressedCancel
	and a
	ret
.pressedCancel
	scf
	ret

OptionsControl:
	ld hl, wOptionsCursorLocation
	ldh a, [hJoy5]
	cp D_DOWN
	jr z, .pressedDown
	cp D_UP
	jr z, .pressedUp
	and a
	ret
.pressedDown
	ld a, [hl]
	cp $7
	jr nz, .doNotWrapAround
	ld [hl], $0
	scf
	ret
.doNotWrapAround
	cp $6
	jr c, .regularIncrement
	ld [hl], $6
.regularIncrement
	inc [hl]
	scf
	ret
.pressedUp
	ld a, [hl]
	cp $7
	jr nz, .doNotMoveCursorToPrintOption
	ld [hl], $6
	scf
	ret
.doNotMoveCursorToPrintOption
	and a
	jr nz, .regularDecrement
	ld [hl], $8
.regularDecrement
	dec [hl]
	scf
	ret

OptionsMenu_UpdateCursorPosition:
	hlcoord 1, 1
	ld de, SCREEN_WIDTH
	ld c, 16
.loop
	ld [hl], " "
	add hl, de
	dec c
	jr nz, .loop
	hlcoord 1, 2
	ld bc, SCREEN_WIDTH * 2
	ld a, [wOptionsCursorLocation]
	call AddNTimes
	ld [hl], "▶"
	ret

InitOptionsMenu:
	hlcoord 0, 0
	lb bc, SCREEN_HEIGHT - 2, SCREEN_WIDTH - 2
	call TextBoxBorder
	hlcoord 2, 2
	ld de, AllOptionsText
	call PlaceString
	hlcoord 2, 16
	ld de, OptionMenuCancelText
	call PlaceString
	xor a
	ld [wOptionsCursorLocation], a
	ld c, 7 ; the number of options to loop through
.loop
	push bc
	call GetOptionPointer ; updates the next option
	pop bc
	ld hl, wOptionsCursorLocation
	inc [hl] ; moves the cursor for the highlighted option
	dec c
	jr nz, .loop
	xor a
	ld [wOptionsCursorLocation], a
	inc a
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	ret

AllOptionsText:
	db "TEXT SPEED :"
	next "ANIMATION  :"
	next "BATTLESTYLE:"
	next "SOUND:"
	next "STARTER 1:"
	next "STARTER 2:"
	next "STARTER 3:@"


OptionMenuCancelText:
	db "CANCEL@"


StarterOptionStringsPointerTable:
	dw StarterBulbasaurText
	dw StarterIvysaurText
	dw StarterVenusaurText
	dw StarterCharmanderText
	dw StarterCharmeleonText
	dw StarterCharizardText
	dw StarterSquirtleText
	dw StarterWartortleText
	dw StarterBlastoiseText
	dw StarterCaterpieText
	dw StarterMetapodText
	dw StarterButterfreeText
	dw StarterWeedleText
	dw StarterKakunaText
	dw StarterBeedrillText
	dw StarterPidgeyText
	dw StarterPidgeottoText
	dw StarterPidgeotText
	dw StarterRattataText
	dw StarterRaticateText
	dw StarterSpearowText
	dw StarterFearowText
	dw StarterEkansText
	dw StarterArbokText
	dw StarterPikachuText
	dw StarterRaichuText
	dw StarterSandshrewText
	dw StarterSandslashText
	dw StarterNidoranFText
	dw StarterNidorinaText
	dw StarterNidoqueenText
	dw StarterNidoranMText
	dw StarterNidorinoText
	dw StarterNidokingText
	dw StarterClefairyText
	dw StarterClefableText
	dw StarterVulpixText
	dw StarterNinetalesText
	dw StarterJigglypuffText
	dw StarterWigglytuffText
	dw StarterZubatText
	dw StarterGolbatText
	dw StarterOddishText
	dw StarterGloomText
	dw StarterVileplumeText
	dw StarterParasText
	dw StarterParasectText
	dw StarterVenonatText
	dw StarterVenomothText
	dw StarterDiglettText
	dw StarterDugtrioText
	dw StarterMeowthText
	dw StarterPersianText
	dw StarterPsyduckText
	dw StarterGolduckText
	dw StarterMankeyText
	dw StarterPrimeapeText
	dw StarterGrowlitheText
	dw StarterArcanineText
	dw StarterPoliwagText
	dw StarterPoliwhirlText
	dw StarterPoliwrathText
	dw StarterAbraText
	dw StarterKadabraText
	dw StarterAlakazamText
	dw StarterMachopText
	dw StarterMachokeText
	dw StarterMachampText
	dw StarterBellsproutText
	dw StarterWeepinbellText
	dw StarterVictreebelText
	dw StarterTentacoolText
	dw StarterTentacruelText
	dw StarterGeodudeText
	dw StarterGravelerText
	dw StarterGolemText
	dw StarterPonytaText
	dw StarterRapidashText
	dw StarterSlowpokeText
	dw StarterSlowbroText
	dw StarterMagnemiteText
	dw StarterMagnetonText
	dw StarterFarfetchdText
	dw StarterDoduoText
	dw StarterDodrioText
	dw StarterSeelText
	dw StarterDewgongText
	dw StarterGrimerText
	dw StarterMukText
	dw StarterShellderText
	dw StarterCloysterText
	dw StarterGastlyText
	dw StarterHaunterText
	dw StarterGengarText
	dw StarterOnixText
	dw StarterDrowzeeText
	dw StarterHypnoText
	dw StarterKrabbyText
	dw StarterKinglerText
	dw StarterVoltorbText
	dw StarterElectrodeText
	dw StarterExeggcuteText
	dw StarterExeggutorText
	dw StarterCuboneText
	dw StarterMarowakText
	dw StarterHitmonleeText
	dw StarterHitmonchanText
	dw StarterLickitungText
	dw StarterKoffingText
	dw StarterWeezingText
	dw StarterRhyhornText
	dw StarterRhydonText
	dw StarterChanseyText
	dw StarterTangelaText
	dw StarterKangaskhanText
	dw StarterHorseaText
	dw StarterSeadraText
	dw StarterGoldeenText
	dw StarterSeakingText
	dw StarterStaryuText
	dw StarterStarmieText
	dw StarterMrMimeText
	dw StarterScytherText
	dw StarterJynxText
	dw StarterElectabuzzText
	dw StarterMagmarText
	dw StarterPinsirText
	dw StarterTaurosText
	dw StarterMagikarpText
	dw StarterGyaradosText
	dw StarterLaprasText
	dw StarterDittoText
	dw StarterEeveeText
	dw StarterVaporeonText
	dw StarterJolteonText
	dw StarterFlareonText
	dw StarterPorygonText
	dw StarterOmanyteText
	dw StarterOmastarText
	dw StarterKabutoText
	dw StarterKabutopsText
	dw StarterAerodactylText
	dw StarterSnorlaxText
	dw StarterArticunoText
	dw StarterZapdosText
	dw StarterMoltresText
	dw StarterDratiniText
	dw StarterDragonairText
	dw StarterDragoniteText
	dw StarterMewtwoText
	dw StarterMewText

StarterBulbasaurText: db "BULBASAUR @", 0
StarterIvysaurText: db "IVYSAUR   @", 0
StarterVenusaurText: db "VENUSAUR  @", 0
StarterCharmanderText: db "CHARMANDER@", 0
StarterCharmeleonText: db "CHARMELEON@", 0
StarterCharizardText: db "CHARIZARD @", 0
StarterSquirtleText: db "SQUIRTLE  @", 0
StarterWartortleText: db "WARTORTLE @", 0
StarterBlastoiseText: db "BLASTOISE @", 0
StarterCaterpieText: db "CATERPIE  @", 0
StarterMetapodText: db "METAPOD   @", 0
StarterButterfreeText: db "BUTTERFREE@", 0
StarterWeedleText: db "WEEDLE    @", 0
StarterKakunaText: db "KAKUNA    @", 0
StarterBeedrillText: db "BEEDRILL  @", 0
StarterPidgeyText: db "PIDGEY    @", 0
StarterPidgeottoText: db "PIDGEOTTO @", 0
StarterPidgeotText: db "PIDGEOT   @", 0
StarterRattataText: db "RATTATA   @", 0
StarterRaticateText: db "RATICATE  @", 0
StarterSpearowText: db "SPEAROW   @", 0
StarterFearowText: db "FEAROW    @", 0
StarterEkansText: db "EKANS     @", 0
StarterArbokText: db "ARBOK     @", 0
StarterPikachuText: db "PIKACHU   @", 0
StarterRaichuText: db "RAICHU    @", 0
StarterSandshrewText: db "SANDSHREW @", 0
StarterSandslashText: db "SANDSLASH @", 0
StarterNidoranFText: db "NIDORAN♀  @", 0
StarterNidorinaText: db "NIDORINA  @", 0
StarterNidoqueenText: db "NIDOQUEEN @", 0
StarterNidoranMText: db "NIDORAN♂  @", 0
StarterNidorinoText: db "NIDORINO  @", 0
StarterNidokingText: db "NIDOKING  @", 0
StarterClefairyText: db "CLEFAIRY  @", 0
StarterClefableText: db "CLEFABLE  @", 0
StarterVulpixText: db "VULPIX    @", 0
StarterNinetalesText: db "NINETALES @", 0
StarterJigglypuffText: db "JIGGLYPUFF@", 0
StarterWigglytuffText: db "WIGGLYTUFF@", 0
StarterZubatText: db "ZUBAT     @", 0
StarterGolbatText: db "GOLBAT    @", 0
StarterOddishText: db "ODDISH    @", 0
StarterGloomText: db "GLOOM     @", 0
StarterVileplumeText: db "VILEPLUME @", 0
StarterParasText: db "PARAS     @", 0
StarterParasectText: db "PARASECT  @", 0
StarterVenonatText: db "VENONAT   @", 0
StarterVenomothText: db "VENOMOTH  @", 0
StarterDiglettText: db "DIGLETT   @", 0
StarterDugtrioText: db "DUGTRIO   @", 0
StarterMeowthText: db "MEOWTH    @", 0
StarterPersianText: db "PERSIAN   @", 0
StarterPsyduckText: db "PSYDUCK   @", 0
StarterGolduckText: db "GOLDUCK   @", 0
StarterMankeyText: db "MANKEY    @", 0
StarterPrimeapeText: db "PRIMEAPE  @", 0
StarterGrowlitheText: db "GROWLITHE @", 0
StarterArcanineText: db "ARCANINE  @", 0
StarterPoliwagText: db "POLIWAG   @", 0
StarterPoliwhirlText: db "POLIWHIRL @", 0
StarterPoliwrathText: db "POLIWRATH @", 0
StarterAbraText: db "ABRA      @", 0
StarterKadabraText: db "KADABRA   @", 0
StarterAlakazamText: db "ALAKAZAM  @", 0
StarterMachopText: db "MACHOP    @", 0
StarterMachokeText: db "MACHOKE   @", 0
StarterMachampText: db "MACHAMP   @", 0
StarterBellsproutText: db "BELLSPROUT@", 0
StarterWeepinbellText: db "WEEPINBELL@", 0
StarterVictreebelText: db "VICTREEBEL@", 0
StarterTentacoolText: db "TENTACOOL @", 0
StarterTentacruelText: db "TENTACRUEL@", 0
StarterGeodudeText: db "GEODUDE   @", 0
StarterGravelerText: db "GRAVELER  @", 0
StarterGolemText: db "GOLEM     @", 0
StarterPonytaText: db "PONYTA    @", 0
StarterRapidashText: db "RAPIDASH  @", 0
StarterSlowpokeText: db "SLOWPOKE  @", 0
StarterSlowbroText: db "SLOWBRO   @", 0
StarterMagnemiteText: db "MAGNEMITE @", 0
StarterMagnetonText: db "MAGNETON  @", 0
StarterFarfetchdText: db "FARFETCH'D@", 0
StarterDoduoText: db "DODUO     @", 0
StarterDodrioText: db "DODRIO    @", 0
StarterSeelText: db "SEEL      @", 0
StarterDewgongText: db "DEWGONG   @", 0
StarterGrimerText: db "GRIMER    @", 0
StarterMukText: db "MUK       @", 0
StarterShellderText: db "SHELLDER  @", 0
StarterCloysterText: db "CLOYSTER  @", 0
StarterGastlyText: db "GASTLY    @", 0
StarterHaunterText: db "HAUNTER   @", 0
StarterGengarText: db "GENGAR    @", 0
StarterOnixText: db "ONIX      @", 0
StarterDrowzeeText: db "DROWZEE   @", 0
StarterHypnoText: db "HYPNO     @", 0
StarterKrabbyText: db "KRABBY    @", 0
StarterKinglerText: db "KINGLER   @", 0
StarterVoltorbText: db "VOLTORB   @", 0
StarterElectrodeText: db "ELECTRODE @", 0
StarterExeggcuteText: db "EXEGGCUTE @", 0
StarterExeggutorText: db "EXEGGUTOR @", 0
StarterCuboneText: db "CUBONE    @", 0
StarterMarowakText: db "MAROWAK   @", 0
StarterHitmonleeText: db "HITMONLEE @", 0
StarterHitmonchanText: db "HITMONCHAN@", 0
StarterLickitungText: db "LICKITUNG @", 0
StarterKoffingText: db "KOFFING   @", 0
StarterWeezingText: db "WEEZING   @", 0
StarterRhyhornText: db "RHYHORN   @", 0
StarterRhydonText: db "RHYDON    @", 0
StarterChanseyText: db "CHANSEY   @", 0
StarterTangelaText: db "TANGELA   @", 0
StarterKangaskhanText: db "KANGASKHAN@", 0
StarterHorseaText: db "HORSEA    @", 0
StarterSeadraText: db "SEADRA    @", 0
StarterGoldeenText: db "GOLDEEN   @", 0
StarterSeakingText: db "SEAKING   @", 0
StarterStaryuText: db "STARYU    @", 0
StarterStarmieText: db "STARMIE   @", 0
StarterMrMimeText: db "MR. MIME   @", 0
StarterScytherText: db "SCYTHER   @", 0
StarterJynxText: db "JYNX      @", 0
StarterElectabuzzText: db "ELECTABUZZ@", 0
StarterMagmarText: db "MAGMAR    @", 0
StarterPinsirText: db "PINSIR    @", 0
StarterTaurosText: db "TAUROS    @", 0
StarterMagikarpText: db "MAGIKARP  @", 0
StarterGyaradosText: db "GYARADOS  @", 0
StarterLaprasText: db "LAPRAS    @", 0
StarterDittoText: db "DITTO     @", 0
StarterEeveeText: db "EEVEE     @", 0
StarterVaporeonText: db "VAPOREON  @", 0
StarterJolteonText: db "JOLTEON   @", 0
StarterFlareonText: db "FLAREON   @", 0
StarterPorygonText: db "PORYGON   @", 0
StarterOmanyteText: db "OMANYTE   @", 0
StarterOmastarText: db "OMASTAR   @", 0
StarterKabutoText: db "KABUTO    @", 0
StarterKabutopsText: db "KABUTOPS  @", 0
StarterAerodactylText: db "AERODACTYL@", 0
StarterSnorlaxText: db "SNORLAX   @", 0
StarterArticunoText: db "ARTICUNO  @", 0
StarterZapdosText: db "ZAPDOS    @", 0
StarterMoltresText: db "MOLTRES   @", 0
StarterDratiniText: db "DRATINI   @", 0
StarterDragonairText: db "DRAGONAIR @", 0
StarterDragoniteText: db "DRAGONITE @", 0
StarterMewtwoText: db "MEWTWO    @", 0
StarterMewText: db "MEW       @", 0

OptionsMenu_StarterChoice1:
	ld a, [wStarterPokemon1]
	dec a                    ; convert to 0-based
	ld c, a
	ldh a, [hJoy5]
	bit BIT_D_RIGHT, a
	jr nz, .pressedRight
	bit BIT_D_LEFT, a
	jr nz, .pressedLeft
	jr .display

.pressedRight
	ld a, c
	inc a
	cp 151
	jr c, .store
	ld a, 0
	jr .store

.pressedLeft
	ld a, c
	cp 0
	jr nz, .dec
	ld c, 151 - 1
	jr .store_from_c
.dec
	dec c
.store_from_c
	ld a, c
	inc a
	ld [wStarterPokemon1], a
	jr .display

.store
	inc a                          ; convert to 1-based
	ld [wStarterPokemon1], a
	dec a                          ; back to 0-based for display
	ld c, a

.display
	ld b, 0
	ld hl, StarterOptionStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 3, 11 ; column 14, row 6th option (y = 2 + index * 2)
	call PlaceString
	and a
	ret
	
OptionsMenu_StarterChoice2:
	ld a, [wStarterPokemon2]
	dec a                    ; convert to 0-based
	ld c, a
	ldh a, [hJoy5]
	bit BIT_D_RIGHT, a
	jr nz, .pressedRight
	bit BIT_D_LEFT, a
	jr nz, .pressedLeft
	jr .display

.pressedRight
	ld a, c
	inc a
	cp 151
	jr c, .store
	ld a, 0
	jr .store

.pressedLeft
	ld a, c
	cp 0
	jr nz, .dec
	ld c, 151 - 1
	jr .store_from_c
.dec
	dec c
.store_from_c
	ld a, c
	inc a
	ld [wStarterPokemon2], a
	jr .display

.store
	inc a                          ; convert to 1-based
	ld [wStarterPokemon2], a
	dec a                          ; back to 0-based for display
	ld c, a

.display
	ld b, 0
	ld hl, StarterOptionStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 3, 13 ; column 14, row 6th option (y = 2 + index * 2)
	call PlaceString
	and a
	ret
	
OptionsMenu_StarterChoice3:
	ld a, [wStarterPokemon3]
	dec a                    ; convert to 0-based
	ld c, a
	ldh a, [hJoy5]
	bit BIT_D_RIGHT, a
	jr nz, .pressedRight
	bit BIT_D_LEFT, a
	jr nz, .pressedLeft
	jr .display

.pressedRight
	ld a, c
	inc a
	cp 151
	jr c, .store
	ld a, 0
	jr .store

.pressedLeft
	ld a, c
	cp 0
	jr nz, .dec
	ld c, 151 - 1
	jr .store_from_c
.dec
	dec c
.store_from_c
	ld a, c
	inc a
	ld [wStarterPokemon3], a
	jr .display

.store
	inc a                          ; convert to 1-based
	ld [wStarterPokemon3], a
	dec a                          ; back to 0-based for display
	ld c, a

.display
	ld b, 0
	ld hl, StarterOptionStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 3, 15 ; column 14, row 6th option (y = 2 + index * 2)
	call PlaceString
	and a
	ret