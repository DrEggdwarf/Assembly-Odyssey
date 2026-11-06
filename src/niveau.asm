;****************************************
;   Assembly Odyssey : niveau en cours
; =======================================
;
;****************************************

public Charger_Niveau
public Numero_Case
public Lire_Case
public Ecrire_Case
public Est_Mur
public Marquer_Vue
public Dans_Niveau
public Est_Vue

public Lab_Largeur
public Lab_Hauteur
public Joueur_Col
public Joueur_Lig

extrn Generer_Niveau:near        ; genmaze.asm

include TAILLES.INC

VUE              equ 80h ; 1000 0000 en binaire
donnees segment public
include LEVEL.INC

Grille           DB  GRILLE_MAX dup(0) ; le niveau, 1 octet a 0 par case

;taille du labyrinthe
Lab_Largeur      DW  0             
Lab_Hauteur      DW  0

;position de départ du joueur
Joueur_Col       DW  0              
Joueur_Lig       DW  0
Lab_Type         DB  0              ; 0 = statique 1 = aleatoire
Lecture          DW  0
donnees ends

code    segment public
assume  cs:code,ds:donnees

Charger_Niveau:
	call Lire_Entete
	cmp  Lab_Type, 0
	je   Niveau_Statique

Niveau_Dynamique: ; ici la porte d'entree pour niveau dynamique a faire
	mov  AL, 0
	call Generer_Niveau
	ret

Niveau_Statique:
	call Copier_Trace
	mov  AL, 1
	ret

; entree : AX = numero du niveau
; sortie : Lab_Largeur, Lab_Hauteur, Lab_Type, Lecture
Lire_Entete:
; ex : niveau 1, lvl1 a l'adresse 1000 ( adresse fictive )
; 1. trouver le niveau dans level.inc
	dec  AX              ; BX = ?      AX = 0 : niveau 1 = 1re adresse de la table
	add  AX, AX          ; BX = ?      AX = 0 x 2 = 0
	mov  BX, AX          ; BX = 0
	mov  BX, niveaux[BX] ; BX = 1000 : adresse de lvl1

; 2. lire l'en-tete
	mov  AH, 0           ; BX = 1000   AX = | 00 | ?? |
	mov  AL, [BX]        ; BX = 1000   AX = | 00 | 57 | = largeur ( lu en 1000 )
	mov  Lab_Largeur, AX ; BX = 1000
	mov  AL, [BX+1]      ; BX = 1000   AX = | 00 | 50 | = hauteur ( lu en 1001 )
	mov  Lab_Hauteur, AX ; BX = 1000
	mov  AL, [BX+2]      ; BX = 1000   AL = 0 = statique ( lu en 1002 )
	mov  Lab_Type, AL    ; BX = 1000

; 3. le trace commence juste apres l'en-tete
	add  BX, 3           ; BX = 1003 : +3 pour passer l'en-tete
	mov  Lecture, BX     ; BX = 1003   Lecture = 1003 : Copier_Trace lira a partir d'ici
	ret

; recopie le trace dans Grille, le joueur sur 'D'
Copier_Trace:
	mov  DX, 0           ; initialise la ligne ( DX = 0 )
Ligne_Trace:
	mov  CX, 0           ; initialise la colonne ( CX = 0 )

Case_Trace:
	mov  BX, Lecture
	mov  AL, [BX]        ; AL = caractere lu ( '#' au 1er tour )
	call Numero_Case
	mov  Grille[BX], AL
	cmp  AL, 'D'
	jne  Case_Suivante
	mov  Joueur_Col, CX
	mov  Joueur_Lig, DX
Case_Suivante:
	inc  Lecture
	inc  CX
	cmp  CX, Lab_Largeur
	jne  Case_Trace
	inc  DX
	cmp  DX, Lab_Hauteur
	jne  Ligne_Trace
	ret


; BX = place de la case ( CX, DX ) dans Grille
Numero_Case:
; on garde AX et DX de cote
	push AX
	push DX

; CX = colonne 11  DX = ligne 44
	mov  AX, DX
	mul  Lab_Largeur     ; AX x Lab_Largeur = 44 x 57 = 2508
	add  AX, CX          ; + colonne = 2508 + 11 = 2519
	mov  BX, AX          ; BX = 2519 = place dans Grille
	pop  DX 
	pop  AX
	ret

Dans_Niveau:
	cmp  CX, 0
	jl   Dehors
	cmp  CX, Lab_Largeur
	jge  Dehors
	cmp  DX, 0
	jl   Dehors
	cmp  DX, Lab_Hauteur
	jge  Dehors
	mov  AL, 1
	ret
Dehors:
	mov  AL, 0
	ret

Lire_Case:
	call Dans_Niveau
	cmp  AL, 1
	jne  Hors_Niveau
	call Numero_Case
	mov  AL, Grille[BX]  ; AL = 1100 0100      ( ex : 'D' deja vue )
	and  AL, 7Fh         ; AL sans le bit 7 ( masque 0111 1111 ) donc AL = 'D'
	ret
Hors_Niveau:
	mov  AL, ' '
	ret

; CX, DX = une case, AL = le caractere a y ecrire ( le bit 7 VUE est garde )
Ecrire_Case:
	push AX
	call Dans_Niveau
	cmp  AL, 1
	pop  AX              ; pop ne touche pas aux drapeaux du cmp
	jne  Fin_Ecrire
	call Numero_Case
	and  Grille[BX], VUE ; on garde le bit 7 seul
	or   Grille[BX], AL  ; puis le caractere
Fin_Ecrire:
	ret

Marquer_Vue:
	call Dans_Niveau
	cmp  AL, 1
	jne  Fin_Marquer
	call Numero_Case
	or   Grille[BX], VUE ; marque le bit 7 avec 1 en gardant les 7 premiers bits intacts
Fin_Marquer:
	ret

Est_Vue:
	call Dans_Niveau
	cmp  AL, 1
	jne  Jamais_Vue
	call Numero_Case
	mov  AL, Grille[BX]  ; AL = 1100 0100      ( ex : 'D' deja vue )
	and  AL, VUE         ; AL = 1000 0000      ( jamais vue : 0000 0000 )
	cmp  AL, 0
	je   Jamais_Vue
	mov  AL, 1
	ret
Jamais_Vue:
	mov  AL, 0
	ret

Est_Mur:
	call Lire_Case
	cmp  AL, '#'
	je   Mur_Trouve
	cmp  AL, ' '
	je   Mur_Trouve
	mov  AL, 0
	ret
Mur_Trouve:
	mov  AL, 1
	ret

code    ends
end
