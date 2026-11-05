;****************************************
;   Assembly Odyssey : tables communes a tous les mondes
; =======================================
; Genere par tools/kit-tuiles/outil/exporter_inc.py : ne pas editer, regenerer.
; masque_blob : masque des 8 voisines -> forme (blob 0 a 46). Bit a 1 = la voisine n'est pas du sol :
;   N = 1, NE = 2, E = 4, SE = 8, S = 16, SO = 32, O = 64, NO = 128
; Un coin ne compte que si ses deux cotes comptent : 256 masques, 47 formes.
;
; Tirage stable selon la case (x, y), sans multiplication :
;   h = hache_perm[(hache_perm[y and 15] + x) and 15]      (0 a 15)
; hache_motif[h and 7] : laquelle des 4 variantes (la principale 5 fois sur 8)
;****************************************

masque_blob        DB 0, 1, 0, 1, 2, 3, 2, 4, 0, 1, 0, 1, 2, 3, 2, 4
                   DB 5, 6, 5, 6, 7, 8, 7, 9, 5, 6, 5, 6, 10, 11, 10, 12
                   DB 0, 1, 0, 1, 2, 3, 2, 4, 0, 1, 0, 1, 2, 3, 2, 4
                   DB 5, 6, 5, 6, 7, 8, 7, 9, 5, 6, 5, 6, 10, 11, 10, 12
                   DB 13, 14, 13, 14, 15, 16, 15, 17, 13, 14, 13, 14, 15, 16, 15, 17
                   DB 18, 19, 18, 19, 20, 21, 20, 22, 18, 19, 18, 19, 23, 24, 23, 25
                   DB 13, 14, 13, 14, 15, 16, 15, 17, 13, 14, 13, 14, 15, 16, 15, 17
                   DB 26, 27, 26, 27, 28, 29, 28, 30, 26, 27, 26, 27, 31, 32, 31, 33
                   DB 0, 1, 0, 1, 2, 3, 2, 4, 0, 1, 0, 1, 2, 3, 2, 4
                   DB 5, 6, 5, 6, 7, 8, 7, 9, 5, 6, 5, 6, 10, 11, 10, 12
                   DB 0, 1, 0, 1, 2, 3, 2, 4, 0, 1, 0, 1, 2, 3, 2, 4
                   DB 5, 6, 5, 6, 7, 8, 7, 9, 5, 6, 5, 6, 10, 11, 10, 12
                   DB 13, 34, 13, 34, 15, 35, 15, 36, 13, 34, 13, 34, 15, 35, 15, 36
                   DB 18, 37, 18, 37, 20, 38, 20, 39, 18, 37, 18, 37, 23, 40, 23, 41
                   DB 13, 34, 13, 34, 15, 35, 15, 36, 13, 34, 13, 34, 15, 35, 15, 36
                   DB 26, 42, 26, 42, 28, 43, 28, 44, 26, 42, 26, 42, 31, 45, 31, 46

hache_perm         DB 6, 3, 8, 7, 4, 9, 14, 13, 11, 10, 15, 2, 12, 1, 5, 0
hache_motif        DB 0, 0, 1, 0, 0, 2, 0, 3
