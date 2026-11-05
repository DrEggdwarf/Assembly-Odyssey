;****************************************
;   Assembly Odyssey : LIBMUS
; =======================================
;
;****************************************
include LIBAO.INC
include LIBOPL.INC

public Ouvrir_Musique
public Jouer_Musique
public Arreter_Musique

ECHANT_TRAME     equ 630
DEBUT_MUSIQUE    equ 80h

donnees segment public
Musique_Active   DB  0
Attente_Restante DW  0
Reste_Trame      DW  0
donnees ends

code    segment public
assume  cs:code,ds:donnees

Ouvrir_Musique:
	mov  Musique_Active, 0
	call Ouvrir_Fichier
	cmp  AL, 1
	jne  Fin_Ouverture
	mov  CX, DEBUT_MUSIQUE
Sauter_Entete:
	call Lire_Octet
	loop Sauter_Entete
	mov  Attente_Restante, 0
	mov  Musique_Active, 1
Fin_Ouverture:
	ret

Jouer_Musique:
	cmp  Musique_Active, 0
	je   Fin_Trame
	cmp  Attente_Restante, ECHANT_TRAME
	jb   Calcul_Reste
	sub  Attente_Restante, ECHANT_TRAME
	ret
Calcul_Reste:
	mov  AX, ECHANT_TRAME
	sub  AX, Attente_Restante
	mov  Reste_Trame, AX
Commande_Suivante:
	call Lire_Octet
	cmp  AH, 1
	je   Stopper_Lecture
	cmp  AL, 5Fh
	je   Banque_1
	cmp  AL, 5Eh
	je   Banque_0
	cmp  AL, 5Ah
	je   Banque_0
	cmp  AL, 61h
	je   Lire_Attente
	cmp  AL, 62h
	je   Attente_Fixe
	cmp  AL, 66h
	je   Reprendre_Debut
	jmp  Stopper_Lecture
Banque_0:
	mov  DX, 388h
	jmp  Envoyer_Registre
Banque_1:
	mov  DX, 38Ah
Envoyer_Registre:
	call Lire_Octet
	mov  CL, AL
	call Lire_Octet
	mov  AH, CL
	call Ecrire_Puce
	jmp  Commande_Suivante
Lire_Attente:
	call Lire_Octet
	mov  BL, AL
	call Lire_Octet
	mov  BH, AL
	mov  AX, BX
	jmp  Traiter_Attente
Attente_Fixe:
	mov  AX, 735
Traiter_Attente:
	cmp  AX, Reste_Trame
	jae  Reporter_Attente
	sub  Reste_Trame, AX
	jmp  Commande_Suivante
Reporter_Attente:
	sub  AX, Reste_Trame
	mov  Attente_Restante, AX
Fin_Trame:
	ret
Reprendre_Debut:
	xor  CX, CX
	mov  DX, DEBUT_MUSIQUE
	call Placer_Lecture
	jmp  Commande_Suivante
Stopper_Lecture:
	call Arreter_Musique
	ret

Arreter_Musique:
	cmp  Musique_Active, 0
	je   Deja_Arretee
	mov  Musique_Active, 0
	call Couper_Son
	call Fermer_Fichier
Deja_Arretee:
	ret

code    ends
end
