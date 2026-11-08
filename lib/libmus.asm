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

ECHANT_TRAME     equ 630  ; 44100 echantillons par seconde / 70 trames par seconde
DEBUT_MUSIQUE    equ 80h  ; les donnees VGM commencent en 34h + 4Ch ( le decalage lu en 34h )

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
	xor  CX, CX
	mov  DX, DEBUT_MUSIQUE
	call Placer_Lecture       ; on saute l'en-tete VGM
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
	cmp  AL, 5Fh             ; 5Fh rr vv : registre rr = vv, banque 1 ( OPL3 )
	je   Banque_1
	cmp  AL, 5Eh             ; 5Eh rr vv : banque 0 ( OPL3 )
	je   Banque_0
	cmp  AL, 5Ah             ; 5Ah rr vv : OPL2 ( une seule banque )
	je   Banque_0
	cmp  AL, 61h             ; 61h nnnn : attendre n echantillons
	je   Lire_Attente
	cmp  AL, 62h             ; 62h : attendre 1/60 s
	je   Attente_Fixe
	cmp  AL, 66h             ; 66h : la fin, on reprend au debut
	je   Reprendre_Debut
	jmp  Stopper_Lecture
Banque_0:
	mov  DX, 388h            ; port d'adresse de la banque 0
	jmp  Envoyer_Registre
Banque_1:
	mov  DX, 38Ah            ; port d'adresse de la banque 1
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
	mov  AX, 735             ; 1/60 s = 44100 / 60 echantillons
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
