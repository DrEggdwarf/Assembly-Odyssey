;****************************************
;   Assembly Odyssey : algorithme de generation du labyrinthe
; =======================================
; Algo de generation du labyrinthe
;****************************************
include TAILLES.INC

public Generer_Niveau

extrn Ecrire_Case:near           ; niveau.asm
extrn Lire_Case:near             ; niveau.asm
extrn Numero_Case:near           ; niveau.asm
extrn Grille:byte                ; niveau.asm
extrn Lab_Largeur:word           ; niveau.asm
extrn Lab_Hauteur:word           ; niveau.asm
extrn Joueur_Col:word            ; niveau.asm
extrn Joueur_Lig:word            ; niveau.asm

CHAMBRES_MAX     equ 32          ; au pire 23 chambres en attente ( 11 + 10 + 2 )
CHAMBRE_MIN      equ 3           ; en dessous ( 1 de large ) : un couloir
CLAIRIERE_MAX    equ 5           ; clairiere : 3 a 5 de cote ...
CLAIRIERE_CHANCE equ 10          ; ... 10 fois sur 100
CLAIRIERES_PLACES equ 32         ; jamais plus de 11 par niveau ( simule )
BRAID_CHANCE     equ 40          ; une impasse est ouverte 40 fois sur 100 ( comme core.js )

donnees segment public
Seed           DW  0
Fin_Col          DW  0
Fin_Lig          DW  0
; la chambre a couper ( Etape_3 )
Chambre_Col      DW  0
Chambre_Lig      DW  0
Chambre_Largeur  DW  0
Chambre_Hauteur  DW  0
; col, lig, largeur, hauteur ( 8 octets par chambre )
Chambres         DW  CHAMBRES_MAX * 4 dup(0)
Nb_Chambres      DW  0
; centre de chaque clairiere : col, lig ( 4 octets )
Clairieres       DW  CLAIRIERES_PLACES * 2 dup(0)
Nb_Clairieres    DW  0
Sortie_Col       DW  0           ; Etape_6 : la case du E
Sortie_Lig       DW  0
; Etape_4 : les 4 directions ( dx, dy ), et ce qu'on compte
Directions       DW  0, -1           ; N
                 DW  1,  0           ; E
                 DW  0,  1           ; S
                 DW -1,  0           ; O
Direction        DW  0
Ouvertures       DW  0
; Etape_5 : copie du petit labyrinthe
Petit_Largeur    DW  0
Petit            DB  ( NIVEAU_MAX / 2 ) * ( NIVEAU_MAX / 2 ) dup(0)
donnees ends

code    segment public
assume  cs:code,ds:donnees

Generer_Niveau:
	call Etape_0
	call Etape_1
	call Etape_2
	call Etape_3
	call Etape_4
	call Etape_5
	call Etape_6
	call Etape_7
	ret

Etape_0: ;Tirer une seed random
	mov  AH, 2Ch
	int  21h                 ; CH = heures, CL = minutes, DH = secondes, DL = centiemes
	or   DX, 1               ; jamais 0 ( xorshift bloque sur 0 )
	;mov  DX, 1234            ; graine fixe pour les tests, a commenter aprés
	mov  Seed, DX
	ret

Etape_1: ;Generer une grille de "#" ( petit labyrinthe )
	shr  Lab_Largeur, 1      ; 55 / 2 = 27
	shr  Lab_Hauteur, 1      ; 51 / 2 = 25
	mov  AX, Lab_Largeur
	mul  Lab_Hauteur         ; AX = 27 x 25 = 675
	mov  BX, 0
Etape_1_Fill:
	mov  Grille[BX], '#'
	inc  BX
	cmp  BX, AX
	jne  Etape_1_Fill
	ret

Etape_2: ;Generer l'interieur avec  "."
	mov  AX, Lab_Largeur
	dec  AX
	mov  Fin_Col, AX         
	mov  AX, Lab_Hauteur
	dec  AX
	mov  Fin_Lig, AX        
	mov  CX, 1               
	mov  DX, 1               
Etape_2_Fill:
	mov  AL, '.'
	call Ecrire_Case
	inc  CX
	cmp  CX, Fin_Col         ; arrive au bord droit ?
	jl   Etape_2_Fill        ; non donc case suivante

	mov  CX, 1
	inc  DX
	cmp  DX, Fin_Lig         ; arrive au bord bas ?
	jl   Etape_2_Fill        ; non donc ligne suivante
	ret


; CX = COLONNE
; DX = LIGNE

; Seed = 1234 
; Lab_Largeur = 27 | Lab_Hauteur = 25 ( le petit labyrinthe )
; Chambre_Largeur = 25 | Chambre_Hauteur = 23

Etape_3: ; Division recursive
; 1re chambre : la salle entiere
	mov  Chambres[0], 1      ; col = 1
	mov  Chambres[2], 1      ; lig = 1
	mov  AX, Lab_Largeur
	sub  AX, 2
	mov  Chambres[4], AX     ; largeur = 27 - 2 = 25
	mov  AX, Lab_Hauteur
	sub  AX, 2
	mov  Chambres[6], AX     ; hauteur = 25 - 2 = 23
	mov  Nb_Chambres, 1
	mov  Nb_Clairieres, 0

; on prend la derniere chambre
Etape_3_Boucle:
	cmp  Nb_Chambres, 0
	jne  Etape_3_Prendre
	ret                      ; liste vide : fini
Etape_3_Prendre:
	dec  Nb_Chambres
	mov  BX, Nb_Chambres
	add  BX, BX
	add  BX, BX
	add  BX, BX              ; BX = Nb_Chambres x 8 = 0
	mov  AX, Chambres[BX]
	mov  Chambre_Col, AX     ; 1
	mov  AX, Chambres[BX+2]
	mov  Chambre_Lig, AX     ; 1
	mov  AX, Chambres[BX+4]
	mov  Chambre_Largeur, AX ; 25
	mov  AX, Chambres[BX+6]
	mov  Chambre_Hauteur, AX ; 23

; trop petite ?
	cmp  Chambre_Largeur, CHAMBRE_MIN
	jl   Etape_3_Boucle
	cmp  Chambre_Hauteur, CHAMBRE_MIN
	jl   Etape_3_Boucle

; clairiere ?
	cmp  Chambre_Largeur, CLAIRIERE_MAX
	jg   Etape_3_Sens
	cmp  Chambre_Hauteur, CLAIRIERE_MAX
	jg   Etape_3_Sens
	mov  BX, 100
	call Xorshift16          ; AX = entre 0 et 99
	cmp  AX, CLAIRIERE_CHANCE
	jge  Etape_3_Sens
	jmp  Etape_3_Clairiere

Etape_3_Sens:
	mov  AX, Chambre_Largeur
	cmp  AX, Chambre_Hauteur ; 25 < 23 ?
	jge  Etape_3_Vertical    ; plus large : verticale
	jmp  Etape_3_Horizontal  ; plus haute : horizontale

Etape_3_Vertical:
; colonne du mur
	mov  BX, Chambre_Largeur
	dec  BX
	shr  BX, 1               ; n = ( 25 - 1 ) / 2 = 12
	call Xorshift16          ; AX = k = 5
	add  AX, AX              ; AX = 2 x 5 = 10
	inc  AX                  ; AX = 11
	add  AX, Chambre_Col     ; AX = 11 + 1 = 12
	mov  CX, AX              ; CX = 12

; mur
	mov  AX, Chambre_Lig
	add  AX, Chambre_Hauteur
	mov  Fin_Lig, AX         ; Fin_Lig = 1 + 23 = 24
	mov  DX, Chambre_Lig     ; DX = 1
Etape_3_Decoupe_Vertical:
	mov  AL, '#'
	call Ecrire_Case
	inc  DX
	cmp  DX, Fin_Lig         ; arrive au bas de la chambre ?
	jl   Etape_3_Decoupe_Vertical ; non donc ligne suivante
; ouverture
	mov  BX, Chambre_Hauteur
	inc  BX
	shr  BX, 1               ; n = ( 23 + 1 ) / 2 = 12
	call Xorshift16          ; AX = k = 6
	add  AX, AX              ; AX = 2 x 6 = 12
	add  AX, Chambre_Lig     ; AX = 12 + 1 = 13
	mov  DX, AX              ; DX = 13
	mov  AL, '.'
	call Ecrire_Case         ; ( 12, 13 )

; gauche puis droite
	mov  BX, Nb_Chambres
	add  BX, BX
	add  BX, BX
	add  BX, BX              ; BX = Nb_Chambres x 8 = 0
	mov  AX, Chambre_Col
	mov  Chambres[BX], AX    ; gauche : col = 1
	mov  AX, Chambre_Lig
	mov  Chambres[BX+2], AX  ; lig = 1
	mov  AX, CX
	sub  AX, Chambre_Col
	mov  Chambres[BX+4], AX  ; largeur = 12 - 1 = 11
	mov  AX, Chambre_Hauteur
	mov  Chambres[BX+6], AX  ; hauteur = 23
	mov  AX, CX
	inc  AX
	mov  Chambres[BX+8], AX  ; droite : col = 12 + 1 = 13
	mov  AX, Chambre_Lig
	mov  Chambres[BX+10], AX ; lig = 1
	mov  AX, Chambre_Col
	add  AX, Chambre_Largeur
	sub  AX, CX
	dec  AX
	mov  Chambres[BX+12], AX ; largeur = 1 + 25 - 12 - 1 = 13
	mov  AX, Chambre_Hauteur
	mov  Chambres[BX+14], AX ; hauteur = 23
	add  Nb_Chambres, 2
	jmp  Etape_3_Boucle

Etape_3_Horizontal:
; ligne du mur
	mov  BX, Chambre_Hauteur
	dec  BX
	shr  BX, 1               ; n = ( hauteur - 1 ) / 2
	call Xorshift16          ; AX = k
	add  AX, AX              ; AX = 2 x k
	inc  AX
	add  AX, Chambre_Lig     ; AX = Chambre_Lig + 1 + 2 x k
	mov  DX, AX              ; DX = ligne du mur

; mur
	mov  AX, Chambre_Col
	add  AX, Chambre_Largeur
	mov  Fin_Col, AX
	mov  CX, Chambre_Col
Etape_3_Decoupe_Horizontal:
	mov  AL, '#'
	call Ecrire_Case
	inc  CX
	cmp  CX, Fin_Col         ; arrive au bord droit ?
	jl   Etape_3_Decoupe_Horizontal ; non donc case suivante
; ouverture
	mov  BX, Chambre_Largeur
	inc  BX
	shr  BX, 1               ; n = ( largeur + 1 ) / 2
	call Xorshift16          ; AX = k
	add  AX, AX              ; AX = 2 x k
	add  AX, Chambre_Col     ; AX = Chambre_Col + 2 x k
	mov  CX, AX
	mov  AL, '.'
	call Ecrire_Case

; haut puis bas
	mov  BX, Nb_Chambres
	add  BX, BX
	add  BX, BX
	add  BX, BX              ; BX = Nb_Chambres x 8
	mov  AX, Chambre_Col
	mov  Chambres[BX], AX    ; haut : col
	mov  AX, Chambre_Lig
	mov  Chambres[BX+2], AX  ; lig
	mov  AX, Chambre_Largeur
	mov  Chambres[BX+4], AX  ; largeur
	mov  AX, DX
	sub  AX, Chambre_Lig
	mov  Chambres[BX+6], AX  ; hauteur = DX - Chambre_Lig
	mov  AX, Chambre_Col
	mov  Chambres[BX+8], AX  ; bas : col
	mov  AX, DX
	inc  AX
	mov  Chambres[BX+10], AX ; lig = DX + 1
	mov  AX, Chambre_Largeur
	mov  Chambres[BX+12], AX ; largeur
	mov  AX, Chambre_Lig
	add  AX, Chambre_Hauteur
	sub  AX, DX
	dec  AX
	mov  Chambres[BX+14], AX ; hauteur = Chambre_Lig + hauteur - DX - 1
	add  Nb_Chambres, 2
	jmp  Etape_3_Boucle

Etape_3_Clairiere: ; en +, et son centre dans la liste
	mov  AX, Chambre_Col
	add  AX, Chambre_Largeur
	mov  Fin_Col, AX
	mov  AX, Chambre_Lig
	add  AX, Chambre_Hauteur
	mov  Fin_Lig, AX
	mov  CX, Chambre_Col
	mov  DX, Chambre_Lig
Etape_3_Clairiere_Fill:
	mov  AL, '+'
	call Ecrire_Case
	inc  CX
	cmp  CX, Fin_Col         ; arrive au bord droit ?
	jl   Etape_3_Clairiere_Fill ; non donc case suivante
	mov  CX, Chambre_Col
	inc  DX
	cmp  DX, Fin_Lig         ; arrive au bord bas ?
	jl   Etape_3_Clairiere_Fill ; non donc ligne suivante
	cmp  Nb_Clairieres, CLAIRIERES_PLACES
	jl   Etape_3_Noter
	jmp  Etape_3_Boucle      ; liste pleine
Etape_3_Noter:
	mov  BX, Nb_Clairieres
	add  BX, BX
	add  BX, BX              ; BX = Nb_Clairieres x 4
	mov  AX, Chambre_Col
	add  AX, AX
	add  AX, Chambre_Largeur
	mov  Clairieres[BX], AX  ; 2 x col + largeur ( grand niveau )
	mov  AX, Chambre_Lig
	add  AX, AX
	add  AX, Chambre_Hauteur
	mov  Clairieres[BX+2], AX ; 2 x lig + hauteur
	inc  Nb_Clairieres
	jmp  Etape_3_Boucle

Etape_4: ; Tresser ( braiding ) : ouvrir le fond de certaines impasses vers un couloir voisin
	mov  AX, Lab_Largeur
	dec  AX
	mov  Fin_Col, AX         ; 27 - 1 = 26 : le bord droit
	mov  AX, Lab_Hauteur
	dec  AX
	mov  Fin_Lig, AX         ; 25 - 1 = 24 : le bord bas
	mov  CX, 1
	mov  DX, 1
Etape_4_Case:                ; les cases : colonne et ligne impaires
	call Lire_Case
	cmp  AL, '.'
	je   Etape_4_Sol
	jmp  Etape_4_Suivante    ; un + : une clairiere, pas une impasse
Etape_4_Sol:
; combien d'ouvertures autour ?
	mov  Ouvertures, 0
	mov  Direction, 0
Etape_4_Compter:
	push CX
	push DX
	mov  BX, Direction
	add  CX, Directions[BX]
	add  DX, Directions[BX+2]
	call Lire_Case
	pop  DX
	pop  CX
	cmp  AL, '#'
	je   Etape_4_Mur
	inc  Ouvertures
Etape_4_Mur:
	add  Direction, 4        ; une paire dx, dy = 4 octets
	cmp  Direction, 16
	jne  Etape_4_Compter
	cmp  Ouvertures, 1
	jne  Etape_4_Suivante    ; pas une impasse
; une impasse : ouverte BRAID_CHANCE fois sur 100
	mov  BX, 100
	call Xorshift16
	cmp  AX, BRAID_CHANCE
	jge  Etape_4_Suivante
	mov  BX, 4
	call Xorshift16          ; AX = la direction tiree ( 0 a 3 )
	add  AX, AX
	add  AX, AX
	mov  Direction, AX
Etape_4_Essayer:
	push CX
	push DX
	mov  BX, Direction
	add  CX, Directions[BX]
	add  DX, Directions[BX+2]  ; CX, DX = le mur de ce cote
	call Lire_Case
	cmp  AL, '#'
	jne  Etape_4_Tourner     ; deja ouvert
	cmp  CX, 0
	je   Etape_4_Tourner     ; le bord du niveau : on ne le perce pas
	cmp  CX, Fin_Col
	je   Etape_4_Tourner
	cmp  DX, 0
	je   Etape_4_Tourner
	cmp  DX, Fin_Lig
	je   Etape_4_Tourner
	mov  AL, '.'
	call Ecrire_Case         ; le mur s'ouvre
	pop  DX
	pop  CX
	jmp  Etape_4_Suivante
Etape_4_Tourner:
	pop  DX
	pop  CX
	add  Direction, 4
	and  Direction, 15       ; apres O ( 12 ) on revient a N ( 0 )
	jmp  Etape_4_Essayer     ; une impasse a toujours un mur interieur ferme
Etape_4_Suivante:
	add  CX, 2
	cmp  CX, Fin_Col         ; arrive au bord droit ?
	jl   Etape_4_Encore
	mov  CX, 1
	add  DX, 2
	cmp  DX, Fin_Lig         ; arrive au bord bas ?
	jl   Etape_4_Encore
	ret
Etape_4_Encore:
	jmp  Etape_4_Case        ; trop loin pour un jl ( 127 octets au plus )

Etape_5: ; Agrandir : murs de 3, couloirs de 1
; 1. copie du petit
	mov  AX, Lab_Largeur
	mov  Petit_Largeur, AX   ; 27
	mul  Lab_Hauteur
	mov  CX, AX              ; CX = 27 x 25 = 675 cases
	mov  BX, 0
Etape_5_Copie:
	mov  AL, Grille[BX]
	mov  Petit[BX], AL
	inc  BX
	cmp  BX, CX
	jne  Etape_5_Copie
; 2. la grande taille
	mov  AX, Lab_Largeur
	add  AX, AX
	inc  AX
	mov  Lab_Largeur, AX     ; 2 x 27 + 1 = 55
	mov  AX, Lab_Hauteur
	add  AX, AX
	inc  AX
	mov  Lab_Hauteur, AX     ; 2 x 25 + 1 = 51
; 3. chaque grande case recopie sa case du petit
;    petite colonne = ( x + 1 ) / 4 + x / 4 : x = 0 1 2 3 4 5 6 7 -> 0 0 0 1 2 2 2 3
	mov  CX, 0
	mov  DX, 0
Etape_5_Fill:
	mov  AX, DX
	inc  AX
	shr  AX, 1
	shr  AX, 1               ; ( y + 1 ) / 4
	mov  BX, DX
	shr  BX, 1
	shr  BX, 1               ; y / 4
	add  AX, BX              ; AX = la petite ligne
	push DX
	mul  Petit_Largeur       ; x 27 ( MUL ecrase DX )
	pop  DX
	mov  BX, CX
	inc  BX
	shr  BX, 1
	shr  BX, 1
	add  AX, BX              ; + ( x + 1 ) / 4
	mov  BX, CX
	shr  BX, 1
	shr  BX, 1
	add  AX, BX              ; + x / 4 : AX = la case du petit
	mov  BX, AX
	mov  AL, Petit[BX]       ; son caractere
	call Numero_Case         ; BX = la grande case ( CX, DX )
	mov  Grille[BX], AL      ; efface aussi le bit VUE
	inc  CX
	cmp  CX, Lab_Largeur     ; arrive au bord droit ?
	jl   Etape_5_Fill        ; non donc case suivante
	mov  CX, 0
	inc  DX
	cmp  DX, Lab_Hauteur     ; arrive au bord bas ?
	jl   Etape_5_Fill        ; non donc ligne suivante
	ret

Etape_6: ; Le E au centre d'une clairiere au hasard ( aucune : en bas a droite )
	cmp  Nb_Clairieres, 0
	jne  Etape_6_Tirer
	mov  AX, Lab_Largeur
	sub  AX, 4
	mov  Sortie_Col, AX      ; 55 - 4 = 51 : le dernier couloir
	mov  AX, Lab_Hauteur
	sub  AX, 4
	mov  Sortie_Lig, AX      ; 51 - 4 = 47
	jmp  Etape_6_Ecrire
Etape_6_Tirer:
	mov  BX, Nb_Clairieres   ; n = 3
	call Xorshift16          ; AX = k = 1
	add  AX, AX
	add  AX, AX
	mov  BX, AX              ; BX = k x 4 = 4
	mov  AX, Clairieres[BX]
	mov  Sortie_Col, AX      ; 33
	mov  AX, Clairieres[BX+2]
	mov  Sortie_Lig, AX      ; 45
Etape_6_Ecrire:
	mov  CX, Sortie_Col
	mov  DX, Sortie_Lig
	mov  AL, 'E'
	call Ecrire_Case
	ret

Etape_7: ; Le D au symetrique du E, sur un couloir, et le joueur dessus
	mov  CX, Lab_Largeur
	dec  CX
	sub  CX, Sortie_Col      ; CX = 55 - 1 - 33 = 21
	and  CX, 0FFFCh          ; CX = 20 ( multiple de 4 )
	add  CX, 3               ; CX = 23 : un couloir ( 3 + 4 x k )
	mov  Joueur_Col, CX
	mov  DX, Lab_Hauteur
	dec  DX
	sub  DX, Sortie_Lig      ; DX = 51 - 1 - 45 = 5
	and  DX, 0FFFCh          ; DX = 4
	add  DX, 3               ; DX = 7
	mov  Joueur_Lig, DX
	mov  AL, 'D'
	call Ecrire_Case
	ret


; Algo de Marsaglia : BX = n en entree, AX = de 0 a n - 1 en sortie
; ( decalages 7, 9, 8 : 65535 valeurs avant que la suite reboucle )
Xorshift16:
; Sauvegarde des registres 
	push CX
	push BX                  ; BX = n

; le generateur xorshift16
	mov  AX, Seed            ; AX = 0000 0100 1101 0010 = 1234
; tour 1 : 7 a gauche
	mov  BX, AX
	mov  CL, 7
	shl  BX, CL              ; BX = 0110 1001 0000 0000
	xor  AX, BX              ; AX = 0110 1101 1101 0010 = 28114
; tour 2 : 9 a droite
	mov  BX, AX
	mov  CL, 9
	shr  BX, CL              ; BX = 0000 0000 0011 0110
	xor  AX, BX              ; AX = 0110 1101 1110 0100 = 28132
; tour 3 : 8 a gauche
	mov  BX, AX
	mov  CL, 8
	shl  BX, CL              ; BX = 1110 0100 0000 0000
	xor  AX, BX              ; AX = 1000 1001 1110 0100 = 35300
	mov  Seed, AX            ; Seed = 35300 ( nouvelle seed)
; on passe AH a 0 pour garder AX sur une valeur de 0 a 255 
	mov  AL, AH              ; AX = | 89h | 89h |
	mov  AH, 0               ; AX = | 00h | 89h | = 137 ( positif : le modulo teste avec jge )
; le modulo : on enleve n tant qu'on peut
	pop  BX                 
Xorshift16_Modulo:
	sub  AX, BX              
	jge  Xorshift16_Modulo 
	add  AX, BX              
	pop  CX
	ret    

code    ends
end
