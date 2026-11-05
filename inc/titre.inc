; Ecran titre : palette DAC (6 bits) et couleurs animees (durees en trames).

TITRE_PAL_N equ 94
titre_palette DB 0, 0, 0      ; 0 noir
              DB 2, 2, 6      ; 1 ciel 1
              DB 3, 4, 9      ; 2 ciel 2
              DB 4, 5, 13     ; 3 ciel 3
              DB 6, 7, 16     ; 4 ciel 4
              DB 8, 8, 18     ; 5 ciel 5
              DB 11, 10, 20   ; 6 ciel 6
              DB 5, 6, 14     ; 7 colline lointaine
              DB 3, 3, 8      ; 8 colline proche
              DB 39, 39, 51   ; 9 étoiles A (animé)
              DB 57, 57, 63   ; 10 étoiles B (animé)
              DB 63, 60, 45   ; 11 or 1
              DB 61, 52, 23   ; 12 or 2
              DB 55, 42, 15   ; 13 or 3
              DB 45, 30, 10   ; 14 or 4
              DB 30, 18, 5    ; 15 or 5
              DB 10, 5, 1     ; 16 contour du titre
              DB 1, 1, 2      ; 17 ombre du titre
              DB 60, 60, 63   ; 18 texte
              DB 60, 60, 63   ; 19 PRESS ANY KEY (animé)
              DB 1, 1, 2      ; 20 ombre de PRESS (animé)
              DB 16, 31, 20   ; 21 herbe
              DB 10, 21, 15   ; 22 herbe sombre
              DB 4, 8, 6      ; 23 sapin sombre
              DB 7, 13, 9     ; 24 sapin
              DB 6, 6, 9      ; 25 sol
              DB 3, 3, 6      ; 26 sol sombre
              DB 5, 9, 7      ; 27 sol éclairé
              DB 7, 6, 18     ; 28 cristal 1
              DB 14, 12, 33   ; 29 cristal 2
              DB 16, 23, 45   ; 30 cristal 3
              DB 20, 38, 53   ; 31 cristal 4
              DB 33, 51, 59   ; 32 cristal 5
              DB 48, 60, 63   ; 33 cristal 6
              DB 60, 63, 63   ; 34 cristal 7
              DB 33, 51, 59   ; 35 cœur de la tour (animé)
              DB 2, 2, 8      ; 36 contour du cristal
              DB 63, 58, 42   ; 37 fenêtre
              DB 11, 23, 20   ; 38 reflet 0 (animé)
              DB 11, 23, 20   ; 39 reflet 1 (animé)
              DB 11, 23, 20   ; 40 reflet 2 (animé)
              DB 11, 23, 20   ; 41 reflet 3 (animé)
              DB 11, 23, 20   ; 42 reflet 4 (animé)
              DB 56, 63, 59   ; 43 reflet 5 (animé)
              DB 39, 60, 49   ; 44 reflet 6 (animé)
              DB 21, 45, 37   ; 45 reflet 7 (animé)
              DB 7, 9, 20     ; 46 halo extérieur (animé)
              DB 10, 14, 28   ; 47 halo milieu (animé)
              DB 15, 20, 37   ; 48 halo intérieur (animé)
              DB 30, 20, 9    ; 49 bois
              DB 18, 11, 4    ; 50 bois sombre
              DB 63, 57, 32   ; 51 flamme 1 (animé)
              DB 63, 42, 13   ; 52 flamme 2 (animé)
              DB 55, 22, 7    ; 53 flamme 3 (animé)
              DB 22, 14, 7    ; 54 cheveux
              DB 60, 48, 38   ; 55 peau
              DB 52, 17, 10   ; 56 tunique
              DB 14, 9, 4     ; 57 bottes
              DB 5, 7, 8      ; 58 yeux
              DB 34, 33, 37   ; 59 pierre claire
              DB 21, 20, 23   ; 60 pierre sombre
              DB 2, 2, 4      ; 61 porte
              DB 5, 3, 4      ; 62 écorce 1
              DB 11, 8, 8     ; 63 écorce 2
              DB 19, 14, 12   ; 64 écorce 3
              DB 29, 22, 18   ; 65 écorce 4
              DB 40, 33, 28   ; 66 écorce 5
              DB 2, 5, 6      ; 67 feuille 1
              DB 3, 9, 10     ; 68 feuille 2
              DB 5, 14, 13    ; 69 feuille 3
              DB 8, 20, 16    ; 70 feuille 4
              DB 12, 27, 19   ; 71 feuille 5
              DB 22, 38, 25   ; 72 feuille 6
              DB 22, 38, 25   ; 73 feuillage 0 (animé)
              DB 32, 47, 33   ; 74 feuillage 1 (animé)
              DB 17, 32, 22   ; 75 feuillage 2 (animé)
              DB 49, 59, 30   ; 76 luciole A (animé)
              DB 49, 59, 30   ; 77 luciole B (animé)
              DB 10, 14, 10   ; 78 lueur 1
              DB 20, 30, 18   ; 79 lueur 2
              DB 39, 51, 34   ; 80 lueur 3
              DB 6, 8, 16     ; 81 brume
              DB 22, 11, 11   ; 82 toit
              DB 14, 13, 18   ; 83 mur
              DB 26, 24, 28   ; 84 mur clair
              DB 30, 16, 14   ; 85 toit clair
              DB 11, 6, 8     ; 86 toit sombre
              DB 14, 12, 11   ; 87 chemin
              DB 21, 17, 14   ; 88 chemin clair
              DB 21, 21, 27   ; 89 fumée 0 (animé)
              DB 15, 15, 22   ; 90 fumée 1 (animé)
              DB 11, 11, 17   ; 91 fumée 2 (animé)
              DB 15, 15, 22   ; 92 fumée 3 (animé)
              DB 63, 58, 42   ; 93 fenêtre vacillante (animé)

; Rotations : à chaque pas, l’entrée k prend la couleur de base de l’entrée (k + pas) mod N.
REFLET_1 equ 38    ; sève qui monte : entrées 38 à 45
REFLET_N equ 8
REFLET_TRAMES equ 6    ; 100 ms
FLAMME_1 equ 51    ; flammes : entrées 51 à 53
FLAMME_N equ 3
FLAMME_TRAMES equ 7    ; 110 ms
FEUILLAGE_1 equ 73    ; feuilles qui frémissent : entrées 73 à 75
FEUILLAGE_N equ 3
FEUILLAGE_TRAMES equ 14    ; 240 ms
FUMEE_1 equ 89    ; fumée des cheminées : entrées 89 à 92
FUMEE_N equ 4
FUMEE_TRAMES equ 13    ; 220 ms

; Séquences : l’entrée prend tour à tour chaque couleur de sa table, en commençant au rang PHASE.
ETOILE_A equ 9
ETOILE_A_TRAMES equ 24    ; 400 ms
ETOILE_A_PHASE equ 0
ETOILE_A_N equ 4
etoile_a_seq DB 24, 24, 42    ; rang 0
             DB 40, 40, 52    ; rang 1
             DB 58, 57, 63    ; rang 2
             DB 40, 40, 52    ; rang 3
ETOILE_B equ 10
ETOILE_B_TRAMES equ 24    ; 400 ms
ETOILE_B_PHASE equ 2
ETOILE_B_N equ 4
etoile_b_seq equ etoile_a_seq    ; même table que A
COEUR equ 35
COEUR_TRAMES equ 20    ; 330 ms
COEUR_PHASE equ 0
COEUR_N equ 6
coeur_seq DB 20, 30, 18       ; rang 0
          DB 39, 51, 34       ; rang 1
          DB 49, 59, 43       ; rang 2
          DB 59, 63, 55       ; rang 3
          DB 49, 59, 43       ; rang 4
          DB 39, 51, 34       ; rang 5
LANTERNE equ 93
LANTERNE_TRAMES equ 9    ; 150 ms
LANTERNE_PHASE equ 0
LANTERNE_N equ 6
lanterne_seq DB 63, 58, 42    ; rang 0
             DB 63, 58, 42    ; rang 1
             DB 56, 48, 30    ; rang 2
             DB 63, 58, 42    ; rang 3
             DB 63, 60, 49    ; rang 4
             DB 59, 52, 36    ; rang 5
LUCIOLE_A equ 76
LUCIOLE_A_TRAMES equ 16    ; 260 ms
LUCIOLE_A_PHASE equ 0
LUCIOLE_A_N equ 6
luciole_a_seq DB 10, 14, 6    ; rang 0
              DB 31, 40, 16   ; rang 1
              DB 53, 63, 34   ; rang 2
              DB 31, 40, 16   ; rang 3
              DB 10, 14, 6    ; rang 4
              DB 10, 14, 6    ; rang 5
LUCIOLE_B equ 77
LUCIOLE_B_TRAMES equ 16    ; 260 ms
LUCIOLE_B_PHASE equ 3
LUCIOLE_B_N equ 6
luciole_b_seq DB 10, 14, 6    ; rang 0
              DB 31, 40, 16   ; rang 1
              DB 53, 63, 34   ; rang 2
              DB 31, 40, 16   ; rang 3
              DB 10, 14, 6    ; rang 4
              DB 10, 14, 6    ; rang 5

; PRESS ANY KEY : texte et ombre clignotent ensemble en prenant la couleur du fond.
PRESS equ 19
PRESS_OMBRE equ 20
PRESS_ETEINT_COULEUR equ 26
PRESS_ALLUME equ 42    ; 700 ms
PRESS_ETEINT equ 24    ; 400 ms
