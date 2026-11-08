;****************************************
;   Assembly Odyssey : LIBOPL
; =======================================
;
;****************************************

public Ecrire_Puce
public Couper_Son

code    segment public
assume  cs:code

; AH = registre, AL = valeur, DX = port d'adresse ( la valeur part en DX + 1 )
Ecrire_Puce:
	push AX
	mov  AL, AH
	out  DX, AL
	pop  AX
	inc  DX
	out  DX, AL
	dec  DX
	ret

Couper_Son:
	mov  DX, 388h
	call Couper_Banque
	mov  DX, 38Ah
	call Couper_Banque
	mov  AX, 0500h           ; DX vaut encore 38Ah : registre 105h = 0, mode OPL3 coupe
	call Ecrire_Puce
	ret
Couper_Banque:
	mov  AX, 0B000h          ; registres B0h a B8h = 0 : les 9 voix coupees
Boucle_Notes:
	call Ecrire_Puce
	inc  AH
	cmp  AH, 0B9h
	jne  Boucle_Notes
	mov  AX, 403Fh           ; registres 40h a 55h = 3Fh : volume au plus bas
Boucle_Volumes:
	call Ecrire_Puce
	inc  AH
	cmp  AH, 56h
	jne  Boucle_Volumes
	ret

code    ends
end
