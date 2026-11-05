;****************************************
;   Assembly Odyssey : vision du joueur
; =======================================
;
;****************************************

public Decouvrir_Autour

extrn Est_Mur:near
extrn Est_Vue:near
extrn Marquer_Vue:near
extrn Dans_Niveau:near
extrn Joueur_Col:word
extrn Joueur_Lig:word

extrn Classe_Niveau:near

extrn Carte_Case:near

LAMPE            equ 4
FIN_VOISINES     equ 8 * 2

donnees segment public
include VISION.INC

Voisin_Dx        DW  0,  1,  1,  1,  0, -1, -1, -1
Voisin_Dy        DW -1, -1,  0,  1,  1,  1,  0, -1
Voisine          DW  0
Voisine_Mur      DW  0
Reste_Disque     DW  0
Case_Disque      DW  0
Cible_Dx         DW  0
Cible_Dy         DW  0

Abs_Dx           DW  0
Abs_Dy           DW  0
Pas_X            DW  0
Pas_Y            DW  0
Erreur           DW  0
Ligne_X          DW  0
Ligne_Y          DW  0
donnees ends

code    segment public
assume  cs:code,ds:donnees

Decouvrir_Autour:
	mov  BX, offset disque
	mov  AX, [BX]
	mov  Reste_Disque, AX
	add  BX, 2
	mov  Case_Disque, BX
Case_Suivante:
	mov  BX, Case_Disque
	mov  AX, [BX]
	mov  Cible_Dx, AX
	mov  AX, [BX+2]
	mov  Cible_Dy, AX
	add  Case_Disque, 4
	mov  CX, Joueur_Col
	add  CX, Cible_Dx
	mov  DX, Joueur_Lig
	add  DX, Cible_Dy
	call Dans_Niveau
	cmp  AL, 1
	jne  Pas_Vue
	call Est_Vue
	cmp  AL, 1
	je   Pas_Vue
	push CX
	push DX
	call Ligne_Libre
	pop  DX
	pop  CX
	cmp  AL, 1
	jne  Pas_Vue
	call Voir_Case
Pas_Vue:
	dec  Reste_Disque
	jnz  Case_Suivante
	ret

Voir_Case:
	call Marquer_Vue
	push CX
	push DX
	call Carte_Case
	pop  DX
	pop  CX
	call Classe_Niveau
	cmp  AL, 'M'
	je   Mur_Vu
	cmp  AL, 'S'
	jne  Fin_Voir_Case
	call Murs_Autour
	ret
Mur_Vu:
	call Decor_Autour
Fin_Voir_Case:
	ret

Murs_Autour:
	mov  Voisine_Mur, 0
Voisine_Murs:
	push CX
	push DX
	mov  BX, Voisine_Mur
	add  CX, Voisin_Dx[BX]
	add  DX, Voisin_Dy[BX]
	call Classe_Niveau
	cmp  AL, 'M'
	jne  Pas_Mur_Autour
	call Est_Vue
	cmp  AL, 1
	je   Pas_Mur_Autour
	call Marquer_Vue
	push CX
	push DX
	call Carte_Case
	pop  DX
	pop  CX
	call Decor_Autour
Pas_Mur_Autour:
	pop  DX
	pop  CX
	add  Voisine_Mur, 2
	cmp  Voisine_Mur, FIN_VOISINES
	jne  Voisine_Murs
	ret

Decor_Autour:
	mov  Voisine, 0
Voisine_Decor:
	push CX
	push DX
	mov  BX, Voisine
	add  CX, Voisin_Dx[BX]
	add  DX, Voisin_Dy[BX]
	call Classe_Niveau
	cmp  AL, 'V'
	jne  Pas_Decor
	call Marquer_Vue
Pas_Decor:
	pop  DX
	pop  CX
	add  Voisine, 2
	cmp  Voisine, FIN_VOISINES
	jne  Voisine_Decor
	ret

Ligne_Libre:
	mov  AX, Cible_Dx
	mov  Pas_X, 1
	cmp  AX, 0
	jg   Dx_Positif
	neg  AX
	mov  Pas_X, -1
Dx_Positif:
	mov  Abs_Dx, AX
	mov  AX, Cible_Dy
	mov  Pas_Y, 1
	cmp  AX, 0
	jg   Dy_Positif
	neg  AX
	mov  Pas_Y, -1
Dy_Positif:
	mov  Abs_Dy, AX
	mov  AX, Abs_Dx
	sub  AX, Abs_Dy
	mov  Erreur, AX
	mov  Ligne_X, 0
	mov  Ligne_Y, 0
Pas_Ligne:
	mov  AX, Ligne_X
	cmp  AX, Cible_Dx
	jne  Avancer
	mov  AX, Ligne_Y
	cmp  AX, Cible_Dy
	jne  Avancer
	mov  AL, 1
	ret
Avancer:
	mov  BX, Erreur
	add  BX, BX
	mov  AX, BX
	add  AX, Abs_Dy
	cmp  AX, 0
	jle  Pas_En_X
	mov  AX, Abs_Dy
	sub  Erreur, AX
	mov  AX, Pas_X
	add  Ligne_X, AX
Pas_En_X:
	cmp  BX, Abs_Dx
	jge  Pas_En_Y
	mov  AX, Abs_Dx
	add  Erreur, AX
	mov  AX, Pas_Y
	add  Ligne_Y, AX
Pas_En_Y:
	mov  AX, Ligne_X
	cmp  AX, Cible_Dx
	jne  Tester_Case
	mov  AX, Ligne_Y
	cmp  AX, Cible_Dy
	je   Pas_Ligne
Tester_Case:
	mov  CX, Joueur_Col
	add  CX, Ligne_X
	mov  DX, Joueur_Lig
	add  DX, Ligne_Y
	call Est_Mur
	cmp  AL, 1
	je   Ligne_Coupee
	jmp  Pas_Ligne
Ligne_Coupee:
	mov  AL, 0
	ret

code    ends
end
