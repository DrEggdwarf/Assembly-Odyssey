;****************************************
;   Assembly Odyssey : bandeau du labyrinthe
; =======================================
;
;****************************************
include LIBAO.INC
include TAILLES.INC

public Dessiner_Bandeau

COLONNE_NIVEAU   equ 1

donnees segment public
Palette_Bandeau  DB  63, 54, 36
Texte_Niveau     DB  'Niveau 01', 0
Texte            DW  0
donnees ends

code    segment public
assume  cs:code,ds:donnees

Dessiner_Bandeau:
	mov  Pal_Table, offset Palette_Bandeau
	mov  Pal_Premiere, COULEUR_TEXTE
	mov  Pal_Nombre, 1
	call Charger_Palette
	mov  AH, 02h             ; place le curseur une seule fois
	mov  BH, 0
	mov  DH, LIGNE_BANDEAU
	mov  DL, COLONNE_NIVEAU
	int  10h
	mov  Texte, offset Texte_Niveau
Caractere_Suivant:
	mov  BX, Texte
	mov  AL, [BX]
	cmp  AL, 0
	je   Fin_Texte
	mov  AH, 0Eh             ; ecrit AL et avance le curseur
	mov  BX, COULEUR_TEXTE   ; BL = couleur, BH = page 0
	int  10h
	inc  Texte
	jmp  Caractere_Suivant
Fin_Texte:
	ret

code    ends
end
