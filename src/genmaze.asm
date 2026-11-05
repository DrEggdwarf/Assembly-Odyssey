;****************************************
;   Assembly Odyssey : algorithme de generation du labyrinthe
; =======================================
;
;****************************************
include TAILLES.INC

public Generer_Niveau

donnees segment public
donnees ends

code    segment public
assume  cs:code,ds:donnees

Generer_Niveau:
; test de la porte E 
	mov  AX, 1010h     
	mov  BX, COULEUR_TEXTE
	mov  DH, 63        
	mov  CH, 0       
	mov  CL, 0        
	int  10h
	ret

code    ends
end
