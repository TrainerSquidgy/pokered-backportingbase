	db DEX_AZUMARILL ; pokedex id

	db 100,  50,  80,  50,  80
	;   hp  atk  def  spd  spc

	db WATER, WATER ; type
	db 190 ; catch rate
	db 58 ; base exp

	INCBIN "gfx/pokemon/front/azumarill.pic", 0, 1 ; sprite dimensions
	dw AzumarillPicFront, AzumarillPicBack

	db TACKLE, DEFENSE_CURL, TAIL_WHIP, WATER_GUN ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH, MEGA_KICK, TOXIC, BODY_SLAM, \
	TAKE_DOWN, DOUBLE_EDGE, WATER_GUN, ICE_BEAM, \
	BLIZZARD, HYPER_BEAM, SEISMIC_TOSS, RAGE, \
	DIG, MIMIC, DOUBLE_TEAM, BIDE, \
	SWIFT, REST, SUBSTITUTE, SURF, \
	STRENGTH

	; end

	db 0 ; padding
