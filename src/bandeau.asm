;****************************************
;   Assembly Odyssey : bandeau du labyrinthe
; =======================================
;
;****************************************
include LIBAO.INC
include TAILLES.INC

public Dessiner_Bandeau
public Niveau_Suivant

COLONNE_NIVEAU   equ 1
POS_DIZAINE      equ 7          ; 'Niveau 01' : le 0 est en 7 ...
POS_UNITE        equ 8          ; ... et le 1 en 8

donnees segment public
Palette_Bandeau  DB  63, 54, 36 ; la couleur 255 : rouge, vert, bleu de 0 a 63 ( creme )
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

; le numero du niveau + 1 ( 09 -> 10 ) ; Demarrer_Niveau redessine le bandeau
Niveau_Suivant:
	inc  Texte_Niveau+POS_UNITE        ; '1' -> '2'
	cmp  Texte_Niveau+POS_UNITE, '9' + 1
	jne  Fin_Suivant
	mov  Texte_Niveau+POS_UNITE, '0'   ; apres '9' : '0' ...
	inc  Texte_Niveau+POS_DIZAINE      ; ... et la dizaine avance : 09 -> 10
Fin_Suivant:
	ret

code    ends
end
