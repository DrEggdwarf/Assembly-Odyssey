;****************************************
;   Assembly Odyssey : ecran titre
; =======================================
;
;****************************************
include LIBGFX.INC
include LIBAO.INC
include LIBMUS.INC

public Ecran_Titre
public Animer_Titre
public Lancer_Fondu
public Assombrir_Palette
public Num_Trame

PAS_FONDU        equ 63 ; composante max du DAC ( 6 bits ) : le noir en 63 pas

donnees segment public
include TITRE.INC
Nom_Image        DB  'ASSETS\TITRE.PCX', 0
Nom_Musique      DB  'ASSETS\SOUNDS\INTRO.VGM', 0
Num_Trame        DW  0

Anim_Debut       DW  0
Anim_Nombre      DW  0
Anim_Delai       DW  0
Anim_Table       DW  0
Anim_Depart      DW  0

Rot_Decalage     DW  0
Rot_Couleur      DW  0

Fondu_Palette    DB  TITRE_PAL_N*3 dup(0)
Fondu_Restant    DB  0
donnees ends

code    segment public
assume  cs:code,ds:donnees

Ecran_Titre:
	call Palette_Noire
	mov  DX, offset Nom_Image
	call Afficher_Image
	mov  Pal_Table, offset titre_palette
	mov  Pal_Premiere, 0
	mov  Pal_Nombre, TITRE_PAL_N
	call Charger_Palette
	mov  DX, offset Nom_Musique
	call Ouvrir_Musique
Boucle_Titre:
	call Attendre_Trame
	cmp  Fondu_Restant, 0
	jne  Boucle_Fondu
	call Animer_Titre
	inc  Num_Trame
	call Jouer_Musique
	call PeekKey
	cmp  userinput, 0
	je   Boucle_Titre
	call Lancer_Fondu
	jmp  Boucle_Titre
Boucle_Fondu:
	call Assombrir_Palette
	call Jouer_Musique
	cmp  Fondu_Restant, 0
	jne  Boucle_Titre
	call Arreter_Musique
	ret

Animer_Titre:
	mov  Anim_Debut, REFLET_1
	mov  Anim_Nombre, REFLET_N
	mov  Anim_Delai, REFLET_TRAMES
	call Tourner_Couleurs
	mov  Anim_Debut, FLAMME_1
	mov  Anim_Nombre, FLAMME_N
	mov  Anim_Delai, FLAMME_TRAMES
	call Tourner_Couleurs
	mov  Anim_Debut, FEUILLAGE_1
	mov  Anim_Nombre, FEUILLAGE_N
	mov  Anim_Delai, FEUILLAGE_TRAMES
	call Tourner_Couleurs
	mov  Anim_Debut, FUMEE_1
	mov  Anim_Nombre, FUMEE_N
	mov  Anim_Delai, FUMEE_TRAMES
	call Tourner_Couleurs

	mov  Anim_Debut, ETOILE_A
	mov  Anim_Table, offset etoile_a_seq
	mov  Anim_Nombre, ETOILE_A_N
	mov  Anim_Delai, ETOILE_A_TRAMES
	mov  Anim_Depart, ETOILE_A_PHASE
	call Couleur_Suivante
	mov  Anim_Debut, ETOILE_B
	mov  Anim_Table, offset etoile_b_seq
	mov  Anim_Nombre, ETOILE_B_N
	mov  Anim_Delai, ETOILE_B_TRAMES
	mov  Anim_Depart, ETOILE_B_PHASE
	call Couleur_Suivante
	mov  Anim_Debut, COEUR
	mov  Anim_Table, offset coeur_seq
	mov  Anim_Nombre, COEUR_N
	mov  Anim_Delai, COEUR_TRAMES
	mov  Anim_Depart, COEUR_PHASE
	call Couleur_Suivante
	mov  Anim_Debut, LANTERNE
	mov  Anim_Table, offset lanterne_seq
	mov  Anim_Nombre, LANTERNE_N
	mov  Anim_Delai, LANTERNE_TRAMES
	mov  Anim_Depart, LANTERNE_PHASE
	call Couleur_Suivante
	mov  Anim_Debut, LUCIOLE_A
	mov  Anim_Table, offset luciole_a_seq
	mov  Anim_Nombre, LUCIOLE_A_N
	mov  Anim_Delai, LUCIOLE_A_TRAMES
	mov  Anim_Depart, LUCIOLE_A_PHASE
	call Couleur_Suivante
	mov  Anim_Debut, LUCIOLE_B
	mov  Anim_Table, offset luciole_b_seq
	mov  Anim_Nombre, LUCIOLE_B_N
	mov  Anim_Delai, LUCIOLE_B_TRAMES
	mov  Anim_Depart, LUCIOLE_B_PHASE
	call Couleur_Suivante

	mov  AX, Num_Trame
	xor  DX, DX
	mov  BX, PRESS_ALLUME+PRESS_ETEINT
	div  BX
	cmp  DX, 0
	je   Rallumer_Press
	cmp  DX, PRESS_ALLUME
	jne  Fin_Anim
	mov  Pal_Table, offset titre_palette + PRESS_ETEINT_COULEUR*3
	mov  Pal_Premiere, PRESS
	mov  Pal_Nombre, 1
	call Charger_Palette
	mov  Pal_Premiere, PRESS_OMBRE
	call Charger_Palette
	ret
Rallumer_Press:
	mov  Pal_Table, offset titre_palette + PRESS*3
	mov  Pal_Premiere, PRESS
	mov  Pal_Nombre, 2       ; PRESS et PRESS_OMBRE, qui suit
	call Charger_Palette
Fin_Anim:
	ret

Tourner_Couleurs:
	mov  AX, Num_Trame
	xor  DX, DX
	div  Anim_Delai
	cmp  DX, 0
	jne  Fin_Rotation
	xor  DX, DX
	div  Anim_Nombre
	mov  Rot_Decalage, DX
	mov  Rot_Couleur, 0
Boucle_Rotation:
	mov  AX, Rot_Couleur
	add  AX, Rot_Decalage
	cmp  AX, Anim_Nombre
	jb   Couleur_Base
	sub  AX, Anim_Nombre
Couleur_Base:
	add  AX, Anim_Debut
	mov  BX, 3
	mul  BX
	add  AX, offset titre_palette
	mov  Pal_Table, AX
	mov  AX, Anim_Debut
	add  AX, Rot_Couleur
	mov  Pal_Premiere, AX
	mov  Pal_Nombre, 1
	call Charger_Palette
	inc  Rot_Couleur
	mov  AX, Rot_Couleur
	cmp  AX, Anim_Nombre
	jne  Boucle_Rotation
Fin_Rotation:
	ret

Couleur_Suivante:
	mov  AX, Num_Trame
	xor  DX, DX
	div  Anim_Delai
	cmp  DX, 0
	jne  Fin_Sequence
	add  AX, Anim_Depart
	xor  DX, DX
	div  Anim_Nombre
	mov  AX, DX
	mov  BX, 3
	mul  BX
	add  AX, Anim_Table
	mov  Pal_Table, AX
	mov  AX, Anim_Debut
	mov  Pal_Premiere, AX
	mov  Pal_Nombre, 1
	call Charger_Palette
Fin_Sequence:
	ret

Lancer_Fondu:
	mov  SI, offset titre_palette
	mov  DI, offset Fondu_Palette
	mov  CX, TITRE_PAL_N*3
Copier_Palette:
	mov  AL, [SI]
	mov  [DI], AL
	inc  SI
	inc  DI
	loop Copier_Palette
	mov  Fondu_Restant, PAS_FONDU
	ret

Assombrir_Palette:
	mov  SI, offset Fondu_Palette
	mov  CX, TITRE_PAL_N*3
Boucle_Assombrir:
	cmp  byte ptr [SI], 0
	je   Composante_Suivante
	dec  byte ptr [SI]
Composante_Suivante:
	inc  SI
	loop Boucle_Assombrir
	mov  Pal_Table, offset Fondu_Palette
	mov  Pal_Premiere, 0
	mov  Pal_Nombre, TITRE_PAL_N
	call Charger_Palette
	dec  Fondu_Restant
	ret

code    ends
end
