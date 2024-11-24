	db DEX_SMEARGLE ; pokedex id

	db  55,  20,  35,  75,  45
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 255 ; catch rate
	db 20 ; base exp

	INCBIN "gfx/pokemon/front/smeargle.pic", 0, 1 ; sprite dimensions
	dw SmearglePicFront, SmearglePicBack

	db SKETCH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db 0 ; padding
