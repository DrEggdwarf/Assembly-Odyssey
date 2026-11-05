;****************************************
;   Assembly Odyssey : labyrinthe
; =======================================
; la boucle du labyrinthe
;****************************************
include LIBGFX.INC
include LIBAO.INC 
include TAILLES.INC

public Ecran_Labyrinthe

extrn Charger_Niveau:near       ; niveau.asm
extrn Lire_Case:near            ; niveau.asm
extrn Est_Mur:near              ; niveau.asm
extrn Est_Vue:near              ; niveau.asm
extrn Joueur_Col:word           ; niveau.asm
extrn Joueur_Lig:word           ; niveau.asm

extrn Decouvrir_Autour:near     ; vision.asm

extrn Charger_Monde:near        ; habille.asm
extrn Preparer_Affichage:near   ; habille.asm
extrn Tuile_Case:near           ; habille.asm

extrn Dessiner_Bandeau:near     ; bandeau.asm

extrn Dessiner_Carte:near       ; carte.asm
extrn Carte_Joueur:near         ; carte.asm

NIVEAU_DEPART    equ 1
FLECHE_GAUCHE    equ 4Bh
FLECHE_DROITE    equ 4Dh
FLECHE_HAUT      equ 48h
FLECHE_BAS       equ 50h
ECHAP            equ 1Bh

donnees segment public
include OBJETS.INC              ; spr_joueur, spr_sortie, joueur_palette, COULEUR_VIDE

; variables de Dessiner_Labyrinthe
Cam_Col          DW  0          ; case du niveau en haut a gauche de l'ecran
Cam_Lig          DW  0
Ecran_Col        DW  0          ; case de l'ecran en cours ( 0 a 11 )
Ecran_Lig        DW  0
Case_Col         DW  0          ; case du niveau qu'on y dessine ( Cam + Ecran ) 
Case_Lig         DW  0
Debut_Rangee     DW  0          ; adresse ecran de la rangee en cours
donnees ends

code    segment public
assume  cs:code,ds:donnees

Ecran_Labyrinthe:
	mov  AH, 0          ; AX = | 00 | ?? | : fonction 0 = changer de mode video
	mov  AL, 13h        ; AX = | 00 | 13 | : mode 13h ( 320 x 200 )
	int  10h
	call Demarrer_Niveau
	cmp  AL, 1
	jne  Fin_Labyrinthe

Boucle_Touches:
	call WaitKey ; libgfx.asm
	cmp  userinput, ECHAP
	je   Fin_Labyrinthe

	cmp  userinput, 0 ; 0 = fleche
	jne  Boucle_Touches
	call WaitKey
	call Lire_Fleche
	call Est_Mur
	cmp  AL, 1
	je   Boucle_Touches
	mov  Joueur_Col, CX
	mov  Joueur_Lig, DX
	call Voir_Autour
	jmp  Boucle_Touches

Fin_Labyrinthe:
	ret

; charge le niveau et dessine tout ( AL = 1 : niveau charge )
Demarrer_Niveau:
	mov  AX, NIVEAU_DEPART
	call Charger_Niveau
	cmp  AL, 1
	jne  Fin_Demarrer
	call Charger_Monde  ; couleurs de monde1.inc
	mov  Pal_Table, offset joueur_palette
	mov  Pal_Premiere, JOUEUR_PAL_1
	mov  Pal_Nombre, JOUEUR_PAL_N
	call Charger_Palette
	call Dessiner_Bandeau
	call Dessiner_Carte
	call Preparer_Affichage
	call Voir_Autour
	mov  AL, 1
Fin_Demarrer:
	ret

; la fleche lue dans userinput donne la case visee
; CX = colonne ( inc = a droite , dec = a gauche )
; DX = ligne ( inc = en bas , dec = en haut )
Lire_Fleche:
	mov  CX, Joueur_Col ; CX = 20        ( ex : joueur 20, 30 )
	mov  DX, Joueur_Lig ; DX = 30
	cmp  userinput, FLECHE_GAUCHE
	jne  Pas_Gauche
	dec  CX             ; gauche : CX = 19
Pas_Gauche:
	cmp  userinput, FLECHE_DROITE
	jne  Pas_Droite
	inc  CX             ; droite : CX = 21
Pas_Droite:
	cmp  userinput, FLECHE_HAUT
	jne  Pas_Haut
	dec  DX             ; haut : DX = 29
Pas_Haut:
	cmp  userinput, FLECHE_BAS
	jne  Pas_Bas
	inc  DX             ; bas : DX = 31
Pas_Bas:
	ret

Voir_Autour:
	call Decouvrir_Autour
	call Carte_Joueur
	call Placer_Camera
	call Dessiner_Labyrinthe
	call Dessiner_Avatar      ; le joueur par-dessus
	ret

; l'ecran = une fenetre de 12 x 12 cases posee sur le niveau
;
;   niveau
;   +----------------------------+
;   |  Cam                       |
;   |   +------------+           |
;   |   |   ecran    |           |
;   |   |     J      |           |
;   |   +------------+           |
;   +----------------------------+
;
; Cam   = coin haut gauche de la fenetre ( Joueur - AVATAR )
; Ecran = case dans la fenetre ( 0 a 11 )
; Case  = case du niveau sous Ecran ( Cam + Ecran )

; Cam = Joueur - ( 5, 6 )
Placer_Camera:
	mov  AX, Joueur_Col ; AX = 20        ( ex : joueur 20, 30 )
	sub  AX, AVATAR_COL ; AX = 20 - 5 = 15
	mov  Cam_Col, AX    ; Cam_Col = 15
	mov  AX, Joueur_Lig ; AX = 30
	sub  AX, AVATAR_LIG ; AX = 30 - 6 = 24
	mov  Cam_Lig, AX    ; Cam_Lig = 24
	ret

; les 12 x 12 cases de l'ecran, a partir de Cam
; tour par tour ( ex : Cam = 15, 24 ) :
;   Ecran  0, 0  ->  Case 15, 24   Pos_Ecran = 0
;   Ecran  1, 0  ->  Case 16, 24   Pos_Ecran = 16
;   ...
;   Ecran 11, 0  ->  Case 26, 24   Pos_Ecran = 176
;   Ecran  0, 1  ->  Case 15, 25   Pos_Ecran = 5120 ( Debut_Rangee = 16 x 320 )
Dessiner_Labyrinthe:
	mov  Debut_Rangee, 0
	mov  Ecran_Lig, 0

; debut d'une rangee
Boucle_Lignes:
	mov  AX, Debut_Rangee
	mov  Pos_Ecran, AX
	mov  Ecran_Col, 0

; une case : Case = Cam + Ecran
Boucle_Colonnes:
	mov  AX, Cam_Col
	add  AX, Ecran_Col
	mov  Case_Col, AX
	mov  AX, Cam_Lig
	add  AX, Ecran_Lig
	mov  Case_Lig, AX
	call Dessiner_Case

; case suivante a droite, jusqu'a 12
	add  Pos_Ecran, TAILLE_CASE
	inc  Ecran_Col
	cmp  Ecran_Col, COLONNES_ECRAN
	jne  Boucle_Colonnes

; rangee suivante en dessous, jusqu'a 12
	add  Debut_Rangee, TAILLE_CASE * LARGEUR_ECRAN
	inc  Ecran_Lig
	cmp  Ecran_Lig, LIGNES_ECRAN
	jne  Boucle_Lignes
	ret

Dessiner_Case:
	mov  CX, Case_Col
	mov  DX, Case_Lig
	call Est_Vue
	cmp  AL, 1
	jne  Case_Noire
	call Tuile_Case
	call Dessiner_Tuile
	mov  CX, Case_Col
	mov  DX, Case_Lig
	call Lire_Case
	cmp  AL, 'E'
	jne  Fin_Case
	mov  BX, offset spr_sortie
	call Dessiner_Sprite
Fin_Case:
	ret
Case_Noire:
	mov  AL, COULEUR_VIDE
	call Dessiner_Noir
	ret


Dessiner_Avatar:
	mov  Pos_Ecran, AVATAR_LIG * TAILLE_CASE * LARGEUR_ECRAN + AVATAR_COL * TAILLE_CASE
	mov  BX, offset spr_joueur
	call Dessiner_Sprite
	ret

code    ends
end
