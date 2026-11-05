;****************************************
;   Assembly Odyssey : LIBOPL
; =======================================
;
;****************************************

public Ecrire_Puce
public Couper_Son

code    segment public
assume  cs:code

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
	mov  AX, 0500h
	call Ecrire_Puce
	ret
Couper_Banque:
	mov  AX, 0B000h
Boucle_Notes:
	call Ecrire_Puce
	inc  AH
	cmp  AH, 0B9h
	jne  Boucle_Notes
	mov  AX, 403Fh
Boucle_Volumes:
	call Ecrire_Puce
	inc  AH
	cmp  AH, 56h
	jne  Boucle_Volumes
	ret

code    ends
end
