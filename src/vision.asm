;****************************************
;   Assembly Odyssey : vision du joueur
; =======================================
;
;****************************************

public Decouvrir_Autour

extrn Est_Mur:near
extrn Est_Vue:near
extrn Marquer_Vue:near
extrn Lire_Case:near
extrn Ecrire_Case:near
extrn Joueur_Col:word
extrn Joueur_Lig:word

extrn Classe_Niveau:near

extrn Carte_Sol:near
extrn Carte_Mur:near

FIN_VOISINES     equ 8 * 4

donnees segment public
Voisines         DW  0, -1          ; N
                 DW  1, -1          ; NE
                 DW  1,  0          ; E
                 DW  1,  1          ; SE
                 DW  0,  1          ; S
                 DW -1,  1          ; SO
                 DW -1,  0          ; O
                 DW -1, -1          ; NO
Voisine          DW  0         
Voisine_Mur      DW  0          ; a part : Decor_Autour est appelee dans la boucle de Murs_Autour, et remettrait Voisine a 0

; Decouvrir_Autour : 1 si la case a 1 pas est du sol
Sol_N            DB  0
Sol_E            DB  0
Sol_S            DB  0
Sol_O            DB  0
donnees ends

code    segment public
assume  cs:code,ds:donnees


; ce que voit le joueur : les cases de sol a 2 pas au plus
;
;             N2
;         NO  N1  NE
;     O2  O1  J   E1  E2
;         SO  S1  SE
;             S2
;
; ex : le joueur est en case 11, 44
Decouvrir_Autour:
; la case du joueur
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	call Voir_Si_Sol

; a 1 pas : N1, E1, S1, O1 ( on retient si c'est du sol )
	mov  CX, Joueur_Col    ; CX = 11
	mov  DX, Joueur_Lig    ; DX = 44
	dec  DX                ; DX = 43 : N1 = case 11, 43
	call Voir_Si_Sol
	mov  Sol_N, AL         ; Sol_N = 1 si N1 est du sol
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	inc  CX
	call Voir_Si_Sol
	mov  Sol_E, AL
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	inc  DX
	call Voir_Si_Sol
	mov  Sol_S, AL
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	dec  CX
	call Voir_Si_Sol
	mov  Sol_O, AL

; a 2 pas en ligne droite : N2, E2, S2, O2, si la case entre les deux est du sol
	cmp  Sol_N, 1
	jne  Pas_N2
	mov  CX, Joueur_Col    ; CX = 11
	mov  DX, Joueur_Lig
	sub  DX, 2             ; DX = 42 : N2 = case 11, 42
	call Voir_Si_Sol
Pas_N2:
	cmp  Sol_E, 1
	jne  Pas_E2
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	add  CX, 2
	call Voir_Si_Sol
Pas_E2:
	cmp  Sol_S, 1
	jne  Pas_S2
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	add  DX, 2
	call Voir_Si_Sol
Pas_S2:
	cmp  Sol_O, 1
	jne  Pas_O2
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	sub  CX, 2
	call Voir_Si_Sol
Pas_O2:

; en diagonale : NE, SE, SO, NO, si une des deux cases qui y menent est du sol
	mov  AL, Sol_N
	or   AL, Sol_E         ; AL = 1 si N1 ou E1 est du sol
	cmp  AL, 1
	jne  Pas_NE
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	inc  CX                ; CX = 12
	dec  DX                ; DX = 43 : NE = case 12, 43
	call Voir_Si_Sol
Pas_NE:
	mov  AL, Sol_S
	or   AL, Sol_E
	cmp  AL, 1
	jne  Pas_SE
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	inc  CX
	inc  DX
	call Voir_Si_Sol
Pas_SE:
	mov  AL, Sol_S
	or   AL, Sol_O
	cmp  AL, 1
	jne  Pas_SO
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	dec  CX
	inc  DX
	call Voir_Si_Sol
Pas_SO:
	mov  AL, Sol_N
	or   AL, Sol_O
	cmp  AL, 1
	jne  Pas_NO
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	dec  CX
	dec  DX
	call Voir_Si_Sol
Pas_NO:

; sur une clairiere pas encore devoilee ( + ) : toute la clairiere
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	call Lire_Case
	cmp  AL, '+'
	jne  Fin_Decouvrir
	call Devoiler_Salle
Fin_Decouvrir:
	ret

; CX, DX = une case : si c'est du sol pas encore vu, Voir_Case
; AL = 1 si c'est du sol, 0 sinon
Voir_Si_Sol:
	call Est_Mur
	cmp  AL, 1
	je   Pas_Sol
	call Est_Vue
	cmp  AL, 1
	je   Sol_Deja_Vu
	call Voir_Case
Sol_Deja_Vu:
	mov  AL, 1
	ret
Pas_Sol:
	mov  AL, 0
	ret


Voir_Case:
	call Marquer_Vue
	call Carte_Sol           ; Voir_Si_Sol ne l'appelle que pour du sol
	call Murs_Autour
	ret

; M = mur qui touche du sol, V = mur qui n'en touche pas ( le decor ), S = sol
Murs_Autour:
	mov  Voisine_Mur, 0
Voisine_Murs:
	push CX
	push DX
	mov  BX, Voisine_Mur   ; BX = 4              
	add  CX, Voisines[BX]  ; CX = 11 + 1 = 12
	add  DX, Voisines[BX+2] ; DX = 43 - 1 = 42
	call Classe_Niveau
	cmp  AL, 'M'
	jne  Pas_Mur_Autour
	call Marquer_Vue
	call Carte_Mur
	call Decor_Autour
Pas_Mur_Autour:
	pop  DX
	pop  CX
	add  Voisine_Mur, 4    ; Voisine_Mur = 8 : la voisine E ( une paire = 4 octets )
	cmp  Voisine_Mur, FIN_VOISINES ; 8 voisines x 4 octets = 32 : fin de la boucle
	jne  Voisine_Murs
	ret

Decor_Autour:
	mov  Voisine, 0
Voisine_Decor:
	push CX
	push DX
	mov  BX, Voisine
	add  CX, Voisines[BX]
	add  DX, Voisines[BX+2]
	call Classe_Niveau
	cmp  AL, 'V'
	jne  Pas_Decor
	call Marquer_Vue
Pas_Decor:
	pop  DX
	pop  CX
	add  Voisine, 4
	cmp  Voisine, FIN_VOISINES
	jne  Voisine_Decor
	ret

; CX, DX = une case de clairiere ( + ) : elle est vue et devient du sol ( . )
Devoiler_Salle:
	call Lire_Case
	cmp  AL, '+'
	je   Case_Clairiere
	call Voir_Si_Sol       ; le bord : vu, mais on s'arrete la
	ret
Case_Clairiere:
	mov  AL, '.'
	call Ecrire_Case       ; devoilee : ce n'est plus un +
	call Voir_Si_Sol
	dec  DX
	call Devoiler_Salle    ; N
	inc  DX
	inc  CX
	call Devoiler_Salle    ; E
	dec  CX
	inc  DX
	call Devoiler_Salle    ; S
	dec  DX
	dec  CX
	call Devoiler_Salle    ; O
	inc  CX
	ret

code    ends
end
