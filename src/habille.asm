;****************************************
;   Assembly Odyssey : habillage du niveau
; =======================================
;
;****************************************
include LIBAO.INC

public Charger_Monde
public Preparer_Affichage
public Classe_Niveau
public Tuile_Case

extrn Numero_Case:near
extrn Est_Mur:near
extrn Dans_Niveau:near
extrn Lab_Largeur:word
extrn Lab_Hauteur:word

include TAILLES.INC

NB_BLOBS         equ 47 ; blob = la forme d'une case selon ses 8 voisines : 47 formes
ROLE_SOL         equ 0  ; role = ce que la case montre : sol, dessus, face haute, face basse
                        ; chaque role a ses 47 tuiles dans monde1_cat, a partir de :
                        ;   sol = 0
ROLE_DESSUS      equ ROLE_SOL + NB_BLOBS        ; dessus de mur = 47
ROLE_FACE_HAUTE  equ ROLE_DESSUS + NB_BLOBS     ; face haute = 94
ROLE_FACE_BASSE  equ ROLE_FACE_HAUTE + NB_BLOBS ; face basse ( troncs ) = 141
FIN_VOISINES     equ 8 * 2 ; 8 voisines x 2 octets ( tables DW ) : fin de la boucle

donnees segment public
include MONDE1.INC
include BLOB.INC
Classes          DB  GRILLE_MAX dup(0)


; les 8 voisines dans l'ordre N NE E SE S SO O NO ( pour Classe_Case )
Voisin_Col       DW  0,  1,  1,  1,  0, -1, -1, -1  ; deplacement en colonne
Voisin_Lig       DW -1, -1,  0,  1,  1,  1,  0, -1  ; deplacement en ligne
Voisine          DW  0                             ; la voisine en cours x 2

Role             DB  0
Masque           DB  0
Categorie        DW  0
donnees ends

code    segment public
assume  cs:code,ds:donnees

Charger_Monde:
	mov  Pal_Table, offset monde1_palette
	mov  Pal_Premiere, 0
	mov  Pal_Nombre, MONDE1_PAL_N
	call Charger_Palette
	ret

Preparer_Affichage:
	mov  DX, 0
Classes_Ligne:
	mov  CX, 0
Classes_Colonne:
	call Classe_Case
	call Numero_Case
	mov  Classes[BX], AL
	inc  CX
	cmp  CX, Lab_Largeur
	jne  Classes_Colonne
	inc  DX
	cmp  DX, Lab_Hauteur
	jne  Classes_Ligne
	ret

Classe_Case:
	call Est_Mur
	cmp  AL, 1
	je   Classe_Mur
	mov  AL, 'S'
	ret
Classe_Mur:
	mov  Voisine, 0
Voisine_Classe:
	push CX
	push DX
	mov  BX, Voisine
	add  CX, Voisin_Col[BX]
	add  DX, Voisin_Lig[BX]
	call Est_Mur
	pop  DX
	pop  CX
	cmp  AL, 0
	je   Mur_Visible
	add  Voisine, 2
	cmp  Voisine, FIN_VOISINES
	jne  Voisine_Classe
	mov  AL, 'V'
	ret
Mur_Visible:
	mov  AL, 'M'
	ret

Classe_Niveau:
	call Dans_Niveau
	cmp  AL, 1
	jne  Hors_Classe
	call Numero_Case
	mov  AL, Classes[BX]
	ret
Hors_Classe:
	mov  AL, 'V'
	ret

; BX = adresse de la tuile de la case ( CX, DX )
Tuile_Case:
	call Classe_Niveau
	cmp  AL, 'V'
	jne  Pas_Vide
	mov  AL, MONDE1_VIDE
	jmp  Adresse_Tuile
Pas_Vide:
	call Chercher_Role
	call Calculer_Masque
	call Choisir_Tuile
Adresse_Tuile:
	mov  AH, 0
	add  AX, AX
	mov  BX, AX
	mov  BX, monde1_tuiles[BX]
	ret

; AL = classe de la case ( 'S' ou 'M' ) -> Role
Chercher_Role:
	mov  Role, ROLE_SOL
	cmp  AL, 'S'
	je   Fin_Role
	mov  Role, ROLE_FACE_BASSE
	inc  DX
	call Classe_Niveau
	dec  DX
	cmp  AL, 'S'
	je   Fin_Role
	mov  Role, ROLE_DESSUS
	cmp  AL, 'M'
	jne  Fin_Role
	add  DX, 2
	call Classe_Niveau
	sub  DX, 2
	cmp  AL, 'S'
	jne  Fin_Role
	mov  Role, ROLE_FACE_HAUTE
Fin_Role:
	ret

; les 8 voisines -> Masque ( un bit par voisine qui n'est pas du sol )
;
;   NO   N   NE        128    1    2
;   O  case  E    =>   64  case   4
;   SO   S   SE         32   16    8
Calculer_Masque:
	mov  Masque, 0

; voisine N ( au-dessus ) : 1
	dec  DX                  ; on va sur la voisine
	call Classe_Niveau       ; AL = classe de la voisine
	inc  DX                  ; on revient sur la case
	cmp  AL, 'S'
	je   Sol_N               ; du sol : rien a noter
	add  Masque, 1           ; pas du sol : son bit s'allume
Sol_N:

; voisine NE ( en haut a droite ) : 2
	dec  DX
	inc  CX
	call Classe_Niveau
	inc  DX
	dec  CX
	cmp  AL, 'S'
	je   Sol_NE
	add  Masque, 2
Sol_NE:

; voisine E ( a droite ) : 4
	inc  CX
	call Classe_Niveau
	dec  CX
	cmp  AL, 'S'
	je   Sol_E
	add  Masque, 4
Sol_E:

; voisine SE ( en bas a droite ) : 8
	inc  DX
	inc  CX
	call Classe_Niveau
	dec  DX
	dec  CX
	cmp  AL, 'S'
	je   Sol_SE
	add  Masque, 8
Sol_SE:

; voisine S ( en dessous ) : 16
	inc  DX
	call Classe_Niveau
	dec  DX
	cmp  AL, 'S'
	je   Sol_S
	add  Masque, 16
Sol_S:

; voisine SO ( en bas a gauche ) : 32
	inc  DX
	dec  CX
	call Classe_Niveau
	dec  DX
	inc  CX
	cmp  AL, 'S'
	je   Sol_SO
	add  Masque, 32
Sol_SO:

; voisine O ( a gauche ) : 64
	dec  CX
	call Classe_Niveau
	inc  CX
	cmp  AL, 'S'
	je   Sol_O
	add  Masque, 64
Sol_O:

; voisine NO ( en haut a gauche ) : 128
	dec  DX
	dec  CX
	call Classe_Niveau
	inc  DX
	inc  CX
	cmp  AL, 'S'
	je   Sol_NO
	add  Masque, 128
Sol_NO:
	ret

; Role + Masque -> AL = numero de la tuile
Choisir_Tuile:
	cmp  Role, ROLE_FACE_BASSE
	jne  Tuile_Variante
	mov  AL, Masque
	and  AL, 44h
	cmp  AL, 44h
	jne  Tuile_Variante
	mov  BX, CX
	and  BX, 7
	mov  AL, monde1_cycle[BX]
	ret
Tuile_Variante:
	mov  BL, Masque
	mov  BH, 0
	mov  AL, masque_blob[BX]
	add  AL, Role
	mov  AH, 0
	add  AX, AX
	add  AX, AX
	mov  Categorie, AX
	call Hache
	and  AL, 7
	mov  BL, AL
	mov  BH, 0
	mov  AL, hache_motif[BX]
	mov  AH, 0
	add  AX, Categorie
	mov  BX, AX
	mov  AL, monde1_cat[BX]
	ret

Hache:
	mov  BX, DX
	and  BX, 15
	mov  AL, hache_perm[BX]
	add  AL, CL
	and  AL, 15
	mov  BL, AL
	mov  AL, hache_perm[BX]
	ret

code    ends
end
