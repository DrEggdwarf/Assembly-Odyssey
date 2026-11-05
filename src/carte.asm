;****************************************
;   Assembly Odyssey : la carte
; =======================================
;
;****************************************
include LIBGFX.INC
include TAILLES.INC

public Dessiner_Carte
public Carte_Case
public Carte_Joueur

extrn Est_Mur:near
extrn Joueur_Col:word
extrn Joueur_Lig:word

COULEUR_MUR      equ 77
COULEUR_SOL      equ 78 ;( 77 = bleu, 78 = gris, 79 = rouge)
COULEUR_JOUEUR   equ 79
CADRE_X          equ CARTE_X - 6
CADRE_Y          equ CARTE_Y - 6
CADRE_LARGEUR    equ 123
CADRE_HAUTEUR    equ 187

donnees segment public
Ancien_Col       DW  0
Ancien_Lig       DW  0
donnees ends

code    segment public
assume  cs:code,ds:donnees


; Rx, Ry = coin haut gauche du rectangle
; Rw = largeur
; Rh = hauteur
; col = couleur

; l'ecran ( 320 x 200 pixels ) :
;
;   x : 0          191     194    200              317
;       +------------+       +-----------------------+     
;       |    vue     |       |    #########          |      
;       |  12 x 12   |       |    #...#...#          |
;       |  cases de  |       |    #.#.#.#.#          |
;       |  16 x 16 px|       |    #.#..J#.#          |
;       |            |       |    #########          |
;       +------------+       +-----------------------+     
;       +----------------------------------------------+
;       | Niveau 01      bandeau : y = 192 a 199       |
;       +----------------------------------------------+


Dessiner_Carte:
	mov  Rx, CADRE_X
	mov  Ry, CADRE_Y
	mov  Rw, CADRE_LARGEUR
	mov  Rh, CADRE_HAUTEUR
	mov  col, COULEUR_TEXTE
	call Rectangle


	mov  AX, Joueur_Col
	mov  Ancien_Col, AX
	mov  AX, Joueur_Lig
	mov  Ancien_Lig, AX
	ret

Carte_Case:
	call Est_Mur         ; niveau.asm
	cmp  AL, 1
	je   Case_Mur
	mov  col, COULEUR_SOL ; 
	call Poser_Carte
	ret
Case_Mur:
	mov  col, COULEUR_MUR ; col = 77 > bleu
	call Poser_Carte
	ret

; appelee par maze.asm a chaque pas
Carte_Joueur:
	mov  CX, Ancien_Col
	mov  DX, Ancien_Lig
	call Carte_Case      ; l'ancienne case redevient grise ou bleu
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	mov  Ancien_Col, CX  ; pour le prochain pas
	mov  Ancien_Lig, DX
	mov  col, COULEUR_JOUEUR
	call Poser_Carte
	ret

Poser_Carte: ; EX on est sur la case 11,43 donc cx = 11 et dx = 43

	mov  AX, CX          ; AX = 11
	add  AX, AX          ; AX = 22
	add  AX, CARTE_X     ; AX = 22 + 200 = 222
	mov  Rx, AX          ; Rx = 222

	mov  AX, DX          ; AX = 43
	add  AX, AX          ; AX = 86
	add  AX, CARTE_Y     ; AX = 86 + 8 = 94
	mov  Ry, AX          ; Ry = 94

	mov  Rw, 1           
	mov  Rh, 1          
	; rx = 222, ry = 94 rw = 1, rh = 1
	call fillRect
	ret

code    ends
end
