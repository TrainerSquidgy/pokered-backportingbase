	db DEX_DELIBIRD ; pokedex id

	db  45,  55,  45,  75,  65
	;   hp  atk  def  spd  spc

	db ICE, FLYING ; type
	db 45 ; catch rate
	db 183 ; base exp

	INCBIN "gfx/pokemon/front/delibird.pic", 0, 1 ; sprite dimensions
	dw DelibirdPicFront, DelibirdPicBack

	db PRESENT, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH, MEGA_KICK, TOXIC, BODY_SLAM, \
		TAKE_DOWN, DOUBLE_EDGE, ICE_BEAM, BLIZZARD, \
		COUNTER, SEISMIC_TOSS, RAGE, MIMIC, \
		DOUBLE_TEAM, BIDE, SWIFT, SKY_ATTACK, \
		REST, SUBSTITUTE, FLY
	; end

	db 0 ; padding
