	db DEX_RAYQUAZA ; pokedex id

	db 105, 150,  90,  95, 150
	;   hp  atk  def  spd  spc

	db DRAGON, FLYING ; type
	db 3 ; catch rate
	db 220 ; base exp

	INCBIN "gfx/pokemon/front/rayquaza.pic", 0, 1 ; sprite dimensions
	dw RayquazaPicFront, RayquazaPicBack

	db TWISTER, SCARY_FACE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC, BODY_SLAM, TAKE_DOWN, DOUBLE_EDGE, \
	ICE_BEAM, BLIZZARD, HYPER_BEAM, RAGE, \
	THUNDERBOLT, THUNDER, EARTHQUAKE, MIMIC, \
	DOUBLE_TEAM, BIDE, FIRE_BLAST, SWIFT, \
	REST, THUNDER_WAVE, ROCK_SLIDE, SUBSTITUTE, \
	FLY, SURF, STRENGTH
	; end

	db 0 ; padding
