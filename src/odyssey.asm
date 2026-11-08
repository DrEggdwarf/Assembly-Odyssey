;****************************************
;   Assembly Odyssey
; =======================================
; programme principal
;****************************************
include LIBGFX.INC

extrn Ecran_Titre:near
extrn Ecran_Labyrinthe:near

pile    segment stack
        dw 2048 dup(?) ; 4096 octets reserves ( Devoiler_Salle s'appelle elle-meme )
pile    ends

donnees segment public ; vide, mais obligatoire pour mov AX, donnees
donnees ends

code    segment public
assume  cs:code,ds:donnees

prog:
	mov AX, donnees          ; AX = adresse du segment donnees
	mov DS, AX               ; DS = donnees ( mov DS, valeur est interdit : on passe par AX )

	call VideoVGA
	call Ecran_Titre
	call Ecran_Labyrinthe
	call VideoCMD

	mov AX, 4C00h            ; AX = | 4C | 00 | : AH = 4Ch quitter, AL = 0 code retour
	int 21h

code    ends
end prog
