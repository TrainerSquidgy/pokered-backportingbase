	db DEX_ZOROARK ; pokedex id

	db 60, 105,  60, 105, 120 ; change to 60 if you want lower
	;   hp  atk  def  spd  spc

	db DARK, DARK; type
	db 45 ; catch rate
	db 179 ; base exp

	INCBIN "gfx/pokemon/front/zoroark.pic", 0, 1 ; sprite dimensions
	dw ZoroarkPicFront, ZoroarkPicBack

	db SCRATCH, LEER, PURSUIT, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH, SWORDS_DANCE, MEGA_KICK, TOXIC, \
		BODY_SLAM, TAKE_DOWN, DOUBLE_EDGE, HYPER_BEAM, \
		RAGE, DIG, MIMIC, DOUBLE_TEAM, \
		BIDE, SWIFT, REST, SUBSTITUTE, \
		CUT
	; end

	db 0 ; padding
