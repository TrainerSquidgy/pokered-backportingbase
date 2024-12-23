	db DEX_GIRAFARIG ; pokedex id

	db  70,  80,  65,  85,  90
	;   hp  atk  def  spd  spc

	db NORMAL, PSYCHIC_TYPE ; type
	db 60 ; catch rate
	db 149 ; base exp

	INCBIN "gfx/pokemon/front/girafarig.pic", 0, 1 ; sprite dimensions
	dw GirafarigPicFront, GirafarigPicBack

	db TACKLE, GROWL, CONFUSION, STOMP ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC, BODY_SLAM, TAKE_DOWN, DOUBLE_EDGE, \
	RAGE, THUNDERBOLT, THUNDER, EARTHQUAKE, \
	MIMIC, DOUBLE_TEAM, REFLECT, BIDE, \
	SWIFT, DREAM_EATER, REST, THUNDER_WAVE, \
	SUBSTITUTE, STRENGTH, FLASH
	; end

	db 0 ; padding
