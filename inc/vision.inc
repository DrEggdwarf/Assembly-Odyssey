;****************************************
;   Assembly Odyssey : la lampe (vision.asm)
; =======================================
; Genere par tools/kit-tuiles/outil/exporter_inc.py : ne pas editer, regenerer.
; En cases, autour du joueur : dx > 0 a droite, dy > 0 en bas ; le disque dx^2 + dy^2 <= 4^2.
; Chaque case du disque est decouverte si le joueur la voit.
; La table : le nombre de cases, puis les cases (DW dx, dy), de la plus proche a la plus loin.
;****************************************
;
;                  *
;            *  *  *  *  *
;         *  *  *  *  *  *  *
;         *  *  *  *  *  *  *
;      *  *  *  *  @  *  *  *  *
;         *  *  *  *  *  *  *
;         *  *  *  *  *  *  *
;            *  *  *  *  *
;                  *
;
disque             DW 49                                         ; 49 cases
                   DW  0, 0,    0,-1,   -1, 0,    1, 0,    0, 1,   -1,-1
                   DW  1,-1,   -1, 1,    1, 1,    0,-2,   -2, 0,    2, 0
                   DW  0, 2,   -1,-2,    1,-2,   -2,-1,    2,-1,   -2, 1
                   DW  2, 1,   -1, 2,    1, 2,   -2,-2,    2,-2,   -2, 2
                   DW  2, 2,    0,-3,   -3, 0,    3, 0,    0, 3,   -1,-3
                   DW  1,-3,   -3,-1,    3,-1,   -3, 1,    3, 1,   -1, 3
                   DW  1, 3,   -2,-3,    2,-3,   -3,-2,    3,-2,   -3, 2
                   DW  3, 2,   -2, 3,    2, 3,    0,-4,   -4, 0,    4, 0
                   DW  0, 4
