	db DEX_SLUGMA ; pokedex id

	db  40,  40,  40,  20,  40
	;   hp  atk  def  spd  spc

	db FIRE, FIRE ; type
	db 190 ; catch rate
	db 78 ; base exp

	INCBIN "gfx/pokemon/front/slugma.pic", 0, 1 ; sprite dimensions
	dw SlugmaPicFront, SlugmaPicBack

	db SMOG, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,   BODY_SLAM, TAKE_DOWN,    DOUBLE_EDGE, \
	     RAGE, MIMIC, DOUBLE_TEAM, REFLECT, \
		 BIDE, FIRE_BLAST, REST, ROCK_SLIDE, \
	     SUBSTITUTE
	; end

	db 0 ; padding
