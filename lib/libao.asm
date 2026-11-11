;****************************************
;   Assembly Odyssey : LIBAO
; =======================================
;
;****************************************
include LIBGFX.INC
include TAILLES.INC

public Charger_Palette
public Palette_Noire
public Attendre_Trame
public Ouvrir_Fichier
public Lire_Octet
public Placer_Lecture
public Fermer_Fichier
public Afficher_Image
public Dessiner_Tuile
public Dessiner_Sprite
public Dessiner_Noir

public Pal_Table
public Pal_Premiere
public Pal_Nombre
public Pos_Ecran

TAILLE_TAMPON    equ 512        ; on lit les fichiers par blocs de 512 octets

donnees segment public

Pal_Table        DW  0
Pal_Premiere     DW  0
Pal_Nombre       DW  0
Pal_Lecture      DW  0
Pal_Reste        DW  0

Fichier_Num      DW  0
Fichier_Tampon   DB  TAILLE_TAMPON dup(0)
Tampon_Pos       DW  0
Tampon_Taille    DW  0

Pixels_Restants  DB  0

Pos_Ecran        DW  0

Sprite_Largeur   DW  0

donnees ends

code    segment public
assume  cs:code,ds:donnees

Charger_Palette:
	mov  AX, Pal_Table
	mov  Pal_Lecture, AX
	mov  AX, Pal_Nombre
	mov  Pal_Reste, AX
	mov  BX, Pal_Premiere
Boucle_Palette:
	push BX
	mov  BX, Pal_Lecture
	mov  DH, [BX]
	mov  CH, [BX+1]
	mov  CL, [BX+2]
	pop  BX
	mov  AX, 1010h          ; ecrire la couleur BX du DAC : DH, CH, CL = rouge, vert, bleu
	int  10h
	add  Pal_Lecture, 3
	inc  BX
	dec  Pal_Reste
	jnz  Boucle_Palette
	ret

Palette_Noire:
	xor  BX, BX
Boucle_Noire:
	mov  AX, 1010h          ; la meme : la couleur BX en noir
	xor  DH, DH
	xor  CX, CX
	int  10h
	inc  BX
	cmp  BX, 256
	jne  Boucle_Noire
	ret

Attendre_Trame:
	mov  DX, 3DAh            ; registre d'etat VGA : le bit 3 ( 8 ) = retour vertical
Attendre_Fin:
	in   AL, DX
	and  AL, 8
	jnz  Attendre_Fin
Attendre_Debut:
	in   AL, DX
	and  AL, 8
	jz   Attendre_Debut
	ret

Ouvrir_Fichier:
	mov  AX, 3D00h           ; DOS : ouvrir en lecture le fichier nomme en DX
	int  21h
	jc   Pas_Ouvert
	mov  Fichier_Num, AX
	mov  Tampon_Pos, 0
	mov  Tampon_Taille, 0
	mov  AL, 1
	ret
Pas_Ouvert:
	mov  AL, 0
	ret

Lire_Octet:
	push BX
	mov  BX, Tampon_Pos
	cmp  BX, Tampon_Taille
	jb   Lire_Tampon
	push CX
	push DX
	mov  AH, 3Fh             ; DOS : lire CX octets dans le tampon
	mov  BX, Fichier_Num
	mov  CX, TAILLE_TAMPON
	mov  DX, offset Fichier_Tampon
	int  21h
	pop  DX
	pop  CX
	mov  Tampon_Taille, AX
	mov  BX, 0
	cmp  AX, 0
	jne  Lire_Tampon
	pop  BX
	mov  AH, 1
	ret
Lire_Tampon:
	mov  AL, Fichier_Tampon[BX]
	mov  AH, 0
	inc  BX
	mov  Tampon_Pos, BX
	pop  BX
	ret

Placer_Lecture:
	mov  AX, 4200h           ; DOS : se placer en CX:DX depuis le debut du fichier
	mov  BX, Fichier_Num
	int  21h
	mov  Tampon_Pos, 0
	mov  Tampon_Taille, 0
	ret

Fermer_Fichier:
	mov  AH, 3Eh             ; DOS : fermer
	mov  BX, Fichier_Num
	int  21h
	ret

Afficher_Image:
	call Ouvrir_Fichier
	cmp  AL, 1
	jne  Fin_Affichage
	mov  CX, 128             ; l'en-tete PCX fait 128 octets
Sauter_Entete:
	call Lire_Octet
	loop Sauter_Entete
	mov  cCX, 0
	mov  cDX, 0
Lire_Paquet:
	call Lire_Octet
	cmp  AH, 1
	je   Fermer_Image
	mov  Pixels_Restants, 1
	cmp  AL, 0C0h            ; les 2 bits du haut a 1 : un paquet repete
	jb   Garder_Couleur
	and  AL, 3Fh             ; les 6 bits du bas : combien de pixels
	mov  Pixels_Restants, AL
	call Lire_Octet
	cmp  AH, 1
	je   Fermer_Image
Garder_Couleur:
	mov  col, AL
Dessiner_Pixel:
	call PaintPxl
	inc  cCX
	cmp  cCX, 640            ; l'image fait 640 x 480 ( VESA 101h )
	jne  Pixel_Suivant
	mov  cCX, 0
	inc  cDX
	cmp  cDX, 480
	je   Fermer_Image
Pixel_Suivant:
	dec  Pixels_Restants
	jnz  Dessiner_Pixel
	jmp  Lire_Paquet
Fermer_Image:
	call Fermer_Fichier
Fin_Affichage:
	ret

Dessiner_Tuile:
	push ES
	mov  AX, 0A000h
	mov  ES, AX
	mov  DI, Pos_Ecran
	mov  SI, BX
	add  SI, 4
	cld
	mov  DX, TAILLE_CASE
Ligne_Tuile:
	mov  CX, TAILLE_CASE / 2
	rep  movsw
	add  DI, LARGEUR_ECRAN - TAILLE_CASE ; ligne suivante, meme colonne ( DI a deja avance de 16 )
	dec  DX
	jnz  Ligne_Tuile
	pop  ES
	ret

Dessiner_Noir:
	push ES
	mov  AX, 0A000h
	mov  ES, AX
	mov  DI, Pos_Ecran
	cld
	mov  AX, 0               ; noir sur les 2 pixels de chaque mot
	mov  DX, TAILLE_CASE
Ligne_Noire:
	mov  CX, TAILLE_CASE / 2
	rep  stosw
	add  DI, LARGEUR_ECRAN - TAILLE_CASE
	dec  DX
	jnz  Ligne_Noire
	pop  ES
	ret

Dessiner_Sprite:
	push ES
	mov  AX, 0A000h
	mov  ES, AX
	mov  DI, Pos_Ecran
	mov  AX, [BX]
	mov  Sprite_Largeur, AX
	mov  SI, [BX+2]
	add  BX, 4
Ligne_Sprite:
	mov  CX, Sprite_Largeur
Pixel_Sprite:
	mov  AL, [BX]
	cmp  AL, 0               ; 0 = transparent : on garde la tuile dessous
	je   Sprite_Suivant
	mov  ES:[DI], AL
Sprite_Suivant:
	inc  BX
	inc  DI
	dec  SI
	loop Pixel_Sprite
	add  DI, LARGEUR_ECRAN
	sub  DI, Sprite_Largeur
	cmp  SI, 0
	jne  Ligne_Sprite
	pop  ES
	ret

code    ends
end
