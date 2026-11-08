;****************************************
;   Assembly Odyssey : tailles maximales
; =======================================
; Les variables de taille pour le jeu
;****************************************


; Taille maximal d'un côté d'un niveau en nombre de case, ne pas dépasser 140 ( au-dela, le segment de donnees depasse 64 Ko ) ; la carte affiche 58 colonnes au plus
NIVEAU_MAX       equ 70
GRILLE_MAX       equ NIVEAU_MAX * NIVEAU_MAX


; L'ecran fait 320 x 200 px.
;
;   x : 0              191   194         317
;   y   +----------------+   +-------------+
;   0   | vue            |   | carte       |
;       | 12 x 12 cases  |   |             |
;       | de 16 x 16 px  |   |             |
;       | joueur en (5,6)|   |             |
;   191 +----------------+   +-------------+
;   192-199  bandeau "Niveau 01" (une ligne de texte BIOS)

TAILLE_CASE      equ 16

; carré de jeux 
COLONNES_ECRAN   equ 12
LIGNES_ECRAN     equ 12

; pOsition de l'avatar au "centre" de l'ecran
AVATAR_COL       equ 5
AVATAR_LIG       equ 6

LARGEUR_ECRAN    equ 320

; position de la map a droite de l'ecran
CARTE_X          equ COLONNES_ECRAN * TAILLE_CASE + 8
CARTE_Y          equ 8

; position du bandeau en bas de l'ecran
LIGNE_BANDEAU    equ LIGNES_ECRAN * TAILLE_CASE / 8
COULEUR_TEXTE    equ 255 ; le dernier index du DAC, libre ( monde 0 a 79, joueur 80 a 94 ) 
