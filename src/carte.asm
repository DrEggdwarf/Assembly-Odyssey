;****************************************
;   Assembly Odyssey : la carte
; =======================================
;
;****************************************
include LIBGFX.INC
include TAILLES.INC

public Dessiner_Carte
public Carte_Sol
public Carte_Mur
public Carte_Joueur

extrn Joueur_Col:word
extrn Joueur_Lig:word

COULEUR_MUR      equ 77
COULEUR_SOL      equ 78 ;( 77 = bleu, 78 = gris, 79 = rouge)
COULEUR_JOUEUR   equ 79
CADRE_X          equ CARTE_X - 6 ; 200 - 6 = 194 : 6 px de marge autour de la carte
CADRE_Y          equ CARTE_Y - 6
CADRE_LARGEUR    equ 123        ; 194 + 123 = 317 : 58 colonnes de carte au plus
CADRE_HAUTEUR    equ 187        ; 2 + 187 = 189

donnees segment public
Ancien_Col       DW  0
Ancien_Lig       DW  0
donnees ends

code    segment public
assume  cs:code,ds:donnees


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
	mov  col, 0              ; tout en noir : la carte repart a zero
	call fillRect
	mov  col, COULEUR_TEXTE
	call Rectangle


	mov  AX, Joueur_Col
	mov  Ancien_Col, AX
	mov  AX, Joueur_Lig
	mov  Ancien_Lig, AX
	ret

; CX, DX = une case vue : l'appelant sait deja si c'est du sol ou un mur
Carte_Sol:
	mov  col, COULEUR_SOL
	call Poser_Carte
	ret
Carte_Mur:
	mov  col, COULEUR_MUR ; col = 77 > bleu
	call Poser_Carte
	ret

; appelee par maze.asm a chaque pas
Carte_Joueur:
	mov  CX, Ancien_Col
	mov  DX, Ancien_Lig
	call Carte_Sol       ; l'ancienne case redevient grise ( le joueur n'est jamais sur un mur )
	mov  CX, Joueur_Col
	mov  DX, Joueur_Lig
	mov  Ancien_Col, CX  ; pour le prochain pas
	mov  Ancien_Lig, DX
	mov  col, COULEUR_JOUEUR
	call Poser_Carte
	ret

Poser_Carte: ; EX on est sur la case 11,43 donc cx = 11 et dx = 43
	push CX                  ; fillRect ecrase CX et DX
	push DX
	mov  AX, CX          ; AX = 11
	add  AX, AX          ; AX = 22
	add  AX, CARTE_X     ; AX = 22 + 200 = 222
	mov  Rx, AX          ; Rx = 222

	mov  AX, DX          ; AX = 43
	add  AX, AX          ; AX = 86
	add  AX, CARTE_Y     ; AX = 86 + 8 = 94
	mov  Ry, AX          ; Ry = 94

	mov  Rw, 1           ; 2 pixels : fillRect va jusqu'a Rx + Rw inclus
	mov  Rh, 1          
	; rx = 222, ry = 94 rw = 1, rh = 1
	call fillRect
	pop  DX
	pop  CX
	ret

code    ends
end
