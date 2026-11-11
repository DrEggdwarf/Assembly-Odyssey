# Assembly Odyssey : cahier des charges (en construction)

Dernière mise à jour : 2026-11-11

## 1. Vision (provisoire)

À chaque pleine lune, un portail mène à un labyrinthe qui semble se réinitialiser à chaque ouverture : personne ne sait pourquoi.
Un dungeon crawler hommage à Etrian Odyssey, où **la carte est la progression** : le jeu trace,
le joueur annote, et à chaque expédition il doit d'abord se retrouver dessus. Des étages faits main
qui changent selon le temps passé (au rythme des pas), et une entrée
dans le donjon à un endroit inconnu qui oblige à lire l'environnement.

## 2. Décisions actées

| # | Décision | Pourquoi | Source |
|---|---|---|---|
| D1 | Pas de roguelite à carte jetable : la carte ne s'efface jamais | Cartographier est le cœur d'EO ; une carte jetable tue ce plaisir | Robin, EmpressLust, DetDango |
| D2 | Étages fixes, faits main, de 30 à 45 cases de côté ; une zone peut compter plusieurs segments (~40×40) qui se révèlent | Un étage pensé (raccourcis, FOE, énigmes) bat un enchevêtrement de couloirs | EmpressLust |
| D3 | Chaque expédition commence à un endroit aléatoire du donjon (une des portes débloquées, voir D17) : le joueur ne sait pas où il est. Sa carte reste visible, mais sans sa position. Chaque pas trace une **carte provisoire** (un fragment) à part. Le joueur peut glisser-déposer ce fragment là où il pense être sur sa carte ; le fragment se recale tout seul, au bon endroit, dès qu'il passe sur un **élément clé** (balise, escalier, coffre…). Aucun signal d'erreur entre-temps | Casse le « je connais le chemin par cœur », oblige à lire l'environnement et à comparer des formes ; rien de ce qui est exploré n'est perdu ; l'erreur se corrige d'elle-même, sans punition | Robin (Surviving the Game as a Barbarian) |
| D4 | Le level design pose des balises, des repères physiques et des panneaux, placés à des endroits stratégiques (ex. une lampe bleue dans une clairière de 6×6) | Se repérer doit être possible et juste, au premier passage comme aux suivants | Robin |
| D5 | Le temps avance au rythme des **pas**, pas en temps réel : on peut passer plusieurs jours sans se reposer, juste en marchant. Se reposer fait passer la nuit d'un coup ; les combats poussent à se reposer (soins) | Contrôlable (rien ne bouge si on ne joue pas) et lisible ; aucune perte d'accès « à 2 minutes près » | Robin (Outer Wilds, Baldur's Gate 3) — corrigée le 2026-11-11 |
| D6 | L'étage change d'un jour à l'autre (ex. une cascade engloutit une zone et ouvre un autre passage). Chaque changement a une cause visible. On peut atteindre l'état voulu en marchant ou en se reposant (qui fait passer la nuit) | Rejouer un même étage autrement ; garder les changements compréhensibles | Robin (Outer Wilds) |
| D7 | Mécanique de changement utilisée avec parcimonie | Trop d'états = level design hors de prix, et revenir en arrière devient pénible | Robin |
| D8 | Cartographie automatique (murs, sols) ; le plaisir est dans les **annotations** du joueur : coffres, raccourcis, ennemis, pièges, sauts, pont qui n'apparaît qu'à certains moments… | Le tracé à la main est fastidieux (surtout au tactile) ; ce qui a du sens, c'est ce que le joueur choisit de noter | Robin |
| D9 | Premier passage sur un étage : carte vide, on cartographie | Garde la découverte intacte | Robin |
| D10 | Se reposer coûte des ressources (nourriture, matériel, feu…). Les vivres ne se consomment **qu'au repos**, pas en marchant | Sans coût, le repos n'est plus une décision ; pas de jauge de faim à surveiller en permanence | Robin |
| D11 | Une annotation peut porter un état de l'étage (ex. « pont visible au jour 2 ») | Les étages changent (D6) : la carte doit pouvoir le dire | Robin |
| D12 | Un fragment glissé reste une **hypothèse** (en transparence) jusqu'au recalage, puis fusionne au bon endroit, même si le joueur l'avait mal placé | La carte n'est jamais salie par une erreur | Robin |
| D13 | Le recalage ne se déclenche que sur des éléments **déjà notés** sur la carte du joueur | Les annotations deviennent des repères : ça récompense D8 et garde la phase « perdu » | Robin |
| D14 | La localisation est réglable : un mode « classique » (position toujours connue, comme EO) et un mode « exploration » (D3) | Accessibilité : la mécanique peut frustrer, le joueur choisit | Robin |
| D15 | Une expédition (un cycle) est bornée par les vivres **et** par un nombre maximal de jours ; les valeurs se règlent à l'équilibrage | Sessions de durée définie (mobile), sans chronomètre : le plafond se voit venir | Robin |
| D16 | Trois façons de sortir : revenir à pied jusqu'à une sortie ; le fil d'Ariane, réservé aux urgences ; l'expulsion forcée à la fin du cycle, avec une pénalité | La tension « jusqu'où je pousse avant de rentrer » exige que l'expulsion soit pire qu'une sortie propre, et que le fil d'Ariane ne la remplace pas | Robin (Barbarian) |
| D17 | Chaque étage a plusieurs **portes** fixes (statue, autel, sanctuaire… à définir). Un cycle démarre sur une porte tirée au hasard parmi celles débloquées ; en découvrir de nouvelles ajoute des départs possibles. Finir un étage ouvre le cycle suivant sur une porte de l'étage d'après | L'aléatoire du départ reste borné et juste ; découvrir une porte est une récompense d'exploration | Robin |
| D18 | Expulsion ou équipe décimée : le butin transporté reste dans un **sac**, à l'endroit de l'échec, noté sur la carte et récupérable à un cycle suivant. Équipe décimée : les soins en ville coûtent de l'or. Fil d'Ariane : on garde tout, son prix est sa seule pénalité. Option difficile : tomber de nouveau avant d'avoir récupéré le sac le fait perdre | Rien n'est perdu sans recours, mais chaque issue a son prix ; aller chercher son sac devient un objectif qui utilise la carte | Robin |
| D19 | Les portes se ressemblent à l'arrivée : on sait qu'on est à l'une de ses portes, pas laquelle | Garde le puzzle de localisation (D3) avec un nombre de candidates borné ; la difficulté monte avec le nombre de portes débloquées | Robin |
| D20 | Les portes sont aussi les sorties | La tension devient « à quelle distance est ma porte la plus proche » | Robin |
| D21 | On peut démarrer un cycle sur un étage déjà fini (récolte, récupération d'un sac) ; remonter coûte des jours, donc des vivres | Aucune raison de l'interdire : le coût est déjà dans D15 | Robin |
| D22 | L'inventaire est limité. Les besoins de survie peuvent toujours se couvrir avec des objets (vivres, torches, balises…), mais ils prennent de la place ; une compétence de survie permet d'en emporter moins pour le même résultat | Aucune compétence n'est obligatoire, mais chacune fait gagner quelque chose de concret : de la place | Robin |
| D23 | Les rôles de terrain doivent rapporter du **butin** : ouvrir ce qui est fermé autrement (coffres crochetés), accéder à des zones inaccessibles, ramener plus de butin, ou de meilleure qualité | Ce que les joueurs aiment plus que la puissance, ce sont les récompenses ; un rôle qui ne fait qu'économiser sera toujours sacrifié | Robin |
| D24 | Chaque personnage a sa classe de combat **et** un rôle de terrain, au choix parmi tous les rôles, sans sacrifice. La tension est dans l'équipe : 5 rôles pour 5 personnages, choisis en ville selon l'étage | Pas de dilemme puissance/terrain où la puissance gagne toujours (X10) ; le choix des rôles devient une décision de préparation | Robin |
| D25 | La maîtrise d'un rôle progresse en l'exerçant ; les stats principales du personnage modulent sa vitesse de progression et son efficacité, sans jamais verrouiller un rôle (à la Baldur's Gate) | Cohérence classe/rôle sans composition imposée ; la voie hors combat a sa propre progression | Robin |
| D26 | Un rôle donne automatiquement ses compétences selon son niveau de maîtrise | Plus simple et plus lisible qu'un choix compétence par compétence | Robin |
| D27 | Les accès gérés par les rôles ont des paliers (ex. serrure de niveau 1 à 3) ; aucun passage obligatoire de la progression principale ne dépend d'un rôle | La progression du rôle se voit ; personne n'est bloqué faute du bon rôle | Robin |
| D28 | Former une recrue coûte de l'or et des ressources, investis à chaque passage en ville jusqu'à ce qu'elle soit prête à partir | Le coût se paie en ressources, pas en attente (X8) | Robin |
| D29 | Une recrue progresse soit en ville (une séance de formation payée par retour d'expédition), soit en expédition, en s'entraînant sur les étages inférieurs | Pas de deuxième équipe à jouer (X11), mais le choix reste ouvert |  Robin |
| D30 | La maîtrise est propre à chaque personnage et à chaque rôle ou classe : changer de rôle, c'est repartir débutant. Un personnage peut finir expert partout, mais c'est très long | Donne un sens à la réserve (des spécialistes) ; récompense l'investissement à long terme | Robin |
| D31 | Chaque personnage a une **réserve de compétences** (celles de sa classe, plus celles qu'on lui transmet) et n'en équipe que 3 ou 4. Un mentor transmet une compétence à une recrue, qui l'ajoute à sa réserve | Des builds variés pour les theorycrafters, sans 20 compétences dont on n'utilise que 3 | Robin (Bravely Default) |
| D32 | Pas de rencontres aléatoires : tous les ennemis sont visibles sur la carte, chacun avec un comportement (gardien, patrouille, chasseur, indifférent… à étendre) ; les FOE en sont la version puissante | Engager ou éviter devient un choix ; l'embuscade a un sens ; les énigmes d'évitement réclamées par EmpressLust | Robin |
| D33 | *(retirée : remplacée par D34 à D37, voir X12)* | | |
| D34 | Le combat se déroule **dans le labyrinthe**, là où il se déclenche : le terrain compte (couloir, clairière, hauteur) | La carte devient un outil tactique ; le même étage se combat autrement selon le jour (S1b) | Robin (FF Tactics, Baldur's Gate 3) |
| D35 | Chaque personnage a sa vitesse : le plus rapide agit en premier. Être pris par surprise fait jouer tous les ennemis avant l'équipe | Ordre lisible, à la Baldur's Gate 3 ; l'embuscade a un vrai enjeu | Robin |
| D36 | Pas de phase de placement : l'équipe démarre dans sa formation de marche (le chef, souvent le tank, devant ; archer et mage derrière). À son tour, un personnage se déplace librement tant qu'il a du mouvement, et choisit une action : attaque, technique, objet, garde | Simple et naturel, adapté au tactile ; la formation fait partie du build | Robin |
| D37 | Défense active : l'ennemi arme son coup (« ! »), **une seule touche** de blocage, au bon moment, pare le coup ; un ennemi peut frapper plusieurs fois. La fenêtre de timing dépend de la classe (un paladin a une fenêtre plus large) | Le geste qui récompense, comme dans Clair Obscur ; la classe change la difficulté du geste | Robin |
| D38 | Ce qu'on peut parer dépend de l'armure : légère, intermédiaire, lourde. Un mage pare peu de coups, un tank à bouclier en pare beaucoup | La défense active ne rend pas les classes interchangeables ; le placement garde son importance | Robin |
| D39 | L'action « garde » (toutes les classes) : pas de parade possible, mais dégâts réduits jusqu'au prochain tour. Le tank a un bonus de garde | Dilemme à chaque fin de tour : dépenser une action pour garantir sa survie, ou compter sur sa parade | Robin |
| D40 | Une embuscade par l'arrière retourne la formation (le mage se retrouve en première ligne). Certains ennemis sont fourbes et prennent à revers ; l'éclaireur les détecte | La formation et l'éclaireur deviennent des décisions qui comptent | Robin |
| D41 | À son tour, un personnage a une réserve de mouvement et une action, comme dans Baldur's Gate 3 | Simple à lire, adapté au tactile | Robin |
| D42 | Les alliés ne bloquent pas les tirs ; pas de tir allié | L'archer derrière le tank reste utile, même dans un couloir | Robin |
| D43 | Combats courts : 5 personnages contre 6 ennemis au plus | Limite la fatigue des parades ; tient sur un écran mobile | Robin |
| D44 | Déplacement sur 4 directions, en exploration comme en combat. Les formes de zone (croix, losange, ligne droite, diagonales…) sont des propriétés de compétences ou d'armes | Une seule grille, des couloirs qui restent des goulots, des distances sans ambiguïté ; la variété passe par les compétences (C1) | Robin |
| D45 | Le « ! » change d'aspect selon que la cible peut parer ce coup ou non (à valider en jeu) | Le joueur ne tape pas pour rien, et apprend quelle armure pare quoi | Robin |
| D46 | Tir allié : option du mode difficile | Ajoute une contrainte de placement pour qui la cherche | Robin |
| D47 | Les changements d'étage viennent de sources variées : altitude et eau (un niveau englouti rend un ravin praticable), événements locaux (un village tribal construit un barrage et assèche une zone), météo et nature (blizzard, ronces, poison), mécanismes (ascenseur qui fonctionne…), avancée de la quête principale | Varier les façons de rejouer un même étage | Robin |
| D48 | Certains changements sont cycliques (un état ouvre une zone et en ferme une autre) ; ceux liés à la quête principale sont définitifs | Le cycle crée des énigmes de planification ; la quête marque une progression qu'on ne perd pas | Robin |
| D49 | Trois familles de changements : **cycle** (le temps qui passe, au fil des pas et des nuits : marée, blizzard, ronces…), **interrupteur** (une action du joueur : levier, ascenseur, barrage), **quête** (définitif). Chaque strate a sa propre mécanique de cycle. Aucun quota fixe : le dosage se règle à l'usage, en concevant les étages | La variété vient des strates ; un seul système à comprendre à la fois | Robin |
| D50 | La carte garde ce que le joueur a vu, avec le jour où il l'a vu ; une zone dont l'état a pu changer depuis s'affiche hachurée (« à revérifier ») ; une zone vue dans tous les états de son cycle s'affiche automatiquement selon le jour | La carte ne ment pas et ne devine pas ; cartographier un cycle entier est récompensé (esprit Outer Wilds) | Robin |
| D51 | On ne se repose que dans les clairières | Logique dans l'univers ; une clairière devient un lieu à atteindre, parfois à libérer | Robin |
| D52 | Le jeu ne sera pas en assembleur (technique : voir D57) ; il garde le look 16 bits | L'assembleur DOS était le cadre du projet scolaire ; le style visuel, lui, plaît | Robin |
| D53 | PC d'abord (itch.io, puis Steam) ; mobile ensuite, une fois que le jeu marche. L'interface est pensée compatible tactile dès le départ (pas d'action qui dépend du survol, cibles larges) | Plus simple pour développer et faire tester ; le mobile est contraignant ; le portage reste possible sans tout refaire | Robin |
| D54 | Écran en paysage (vue du donjon et carte côte à côte), sur PC comme plus tard sur mobile | Même disposition partout ; continuité avec la version DOS | Robin |
| D55 | Double objectif : sortir le jeu **et** apprendre en le construisant | Guide le choix de la technique (S7) | Robin |
| D56 | On commence par une **tranche verticale** (section 7), ajustée au fil de l'eau | Savoir en quelques semaines si les trois paris tiennent, avant de construire le reste | Robin |
| D57 | Technique : **Godot 4**, en GDScript typé ; version de Godot figée dans le projet. Niveaux dans l'éditeur de tuiles de Godot (LDtk reste possible via un importeur). Règles du jeu écrites à part de l'affichage et testées avec gdUnit4, lancé sans fenêtre (`--headless`). Documentation à jour fournie à l'IA par Context7 | Un moteur qui s'adapte (interface, tuiles, scènes, export PC puis mobile), très documenté, donc bien soutenu par l'IA pour développer et tester ; C++ possible plus tard (GDExtension) | Robin — remplace LÖVE le 2026-11-11 |
| D58 | Ton : le **mystère**. Point de départ du scénario : à chaque pleine lune, un portail apparaît et mène à un labyrinthe ; les aventuriers du pays s'y rendent ; le labyrinthe semble se réinitialiser à chaque apparition, sans qu'on sache pourquoi ; le but est de creuser pour comprendre | Donne un sens à la boucle de jeu (cycles, départ inconnu, retour forcé) et un moteur narratif : comprendre le labyrinthe | Robin |
| D59 | La lumière fait l'ambiance : vignettage avec un halo qui tremble comme une flamme (les grottes sombres de Pokémon Rubis) ; les torches se consomment | L'ambiance sort d'une mécanique (D22) | Robin |
| D60 | Le camp est une **phase à part entière**, un moment de répit (FF XV, Clair Obscur, Baldur's Gate 3) : avant la nuit, poser des pièges (trappeur), cuisiner et choisir le plat (léger, moyen, copieux), décider qui veille (fatigué au réveil) ou organiser des tours de garde, installer des alarmes, allumer un feu… ; plus des dialogues et des événements où l'on apprend des choses | Le repos (D5, D10, D51) devient le cœur émotionnel du jeu et la vitrine des rôles de terrain (D23) | Robin |
| D61 | À chaque pleine lune se réinitialisent les monstres et les cycles (retour au jour 1) ; persistent le tracé du labyrinthe (la carte reste juste) et les changements définitifs de la quête, qui deviennent des anomalies à comprendre | Garde D1 intact ; le mystère se nourrit de ce qui résiste à la réinitialisation | Robin |
| D62 | Le camp est une scène où l'on se déplace librement dans la clairière : parler aux membres de l'équipe, aller aux sorties de la clairière pour poser les pièges, désigner qui est de garde en lui parlant ; tout reste aussi faisable par un menu. On finit la nuit en allant à sa tente ou à sa couchette, avec confirmation | Un sentiment de liberté et de répit au milieu du labyrinthe ; le menu sert de camp rapide | Robin |
| D63 | Une petite horloge en haut à droite indique le moment de la journée ; le temps avance avec le nombre de pas (D5) | Le plus simple ; on voit venir la nuit | Robin |
| D64 | La nuit tombe et passe avec les pas ; rien n'oblige à camper, mais la nuit les monstres sont plus nombreux et plus agressifs (plus de patrouilles, détection plus large), comme dans EO. Camper dans une clairière fait passer la nuit d'un coup | Choix : camper jusqu'au matin, ou prendre le risque d'avancer de nuit | Robin — corrigée le 2026-11-11 |
| D65 | Au camp, déplacement libre (hors grille) | Contraste avec le labyrinthe case par case : on sent le répit | Robin |
| D66 | Musique originale au son façon Super Nintendo (instruments échantillonnés), plutôt que FM | Colle au look 16 bits visé (Chrono Trigger, FF6) | Robin |
| D67 | Quatre stats principales : **Force** (le combat), **Endurance** (le tank), **Dextérité** (le voleur), **Intelligence** (le mage). Des sous-stats (critique, précision…) pourront venir plus tard | Suffisant pour couvrir les classes et les rôles ; simple à lire | Robin |
| D68 | Neuf rôles de terrain (section 8), après fusion du chasseur et du trappeur (Traqueur), et du bûcheron et du grimpeur (Pionnier) | Moins de rôles, plus riches ; un levier principal par rôle | Robin |
| D69 | Aucun rôle n'est indispensable à l'histoire : l'Érudit lit des stèles d'une civilisation ancienne, qui révèlent ou ajoutent des annotations sur la carte, mais le scénario avance sans lui | Même principe que D27 pour l'accès : un rôle est un avantage, jamais une obligation | Robin |
| D70 | Une fatigue s'accumule quand on ne dort pas, mais elle reste douce : elle ne se remarque qu'en cas d'abus (4 à 5 jours sans sommeil), avec par exemple une fenêtre de parade plus étroite | Donne une raison de dormir autre que les soins (D5 corrigée), sans devenir pénible | Robin |

## 3. Exclu (et pourquoi)

| # | Exclu | Pourquoi |
|---|---|---|
| X1 | Génération procédurale au cœur du jeu | Tue la cartographie, produit des couloirs sans intention (EmpressLust, DetDango). Le générateur actuel peut rester un outil de maquette pour les level designers |
| X2 | Runs roguelite de 30–40 min avec remise à zéro | Incompatible avec D1 |
| X3 | Cycle en temps réel (façon Outer Wilds) | Perdre l'accès à une zone parce qu'on a traîné est frustrant ; remplacé par D5 |
| X4 | Placer son curseur à la main comme **seul** moyen de se localiser | Une erreur salit la carte sans retour : anti-UX. Remplacé par le fragment à glisser et le recalage automatique (D3) |
| X6 | Carte noire tant qu'on est perdu | On ne peut plus raisonner : on erre jusqu'à tomber sur une balise |
| X7 | Signal d'erreur quand le fragment est mal placé | Inutile : le recalage sur un élément clé corrige tout seul (D3) |
| X8 | Pénalités payées en temps (ex. blessures qui immobilisent l'équipe pendant N cycles) | Un cycle sans rien faire ne coûte rien : le joueur reste en ville et enchaîne les repos pour attendre. C'est ennuyeux et ça contourne la pénalité |
| X9 | Échelle de pénalités punitive (équipe décimée = gros malus durable) | Trop dur, décourage de prendre des risques |
| X10 | Emplacement secondaire à partager entre une 2e classe de combat et un rôle de terrain | Les joueurs choisiraient presque toujours la puissance |
| X11 | Devoir monter plusieurs équipes en expédition | Long et pénible ; l'équipe principale de 5 est celle qu'on joue, qu'on monte et qu'on équipe |
| X12 | Écran de combat séparé, vu de côté (ancienne D33) | Le combat tactique dans le labyrinthe (D34) relie le combat à la carte et au terrain |
| X13 | Annoncer les coups par des cases dangereuses au sol (Into the Breach) | Robin préfère voir l'ennemi s'approcher et frapper ; la parade dépend de l'armure (D38) |
| X14 | LÖVE (Lua) comme moteur (ancienne D57) | Toute l'interface serait à écrire, dont la carte éditable (U1), le cœur du jeu ; Godot la fournit |
| X5 | Tracé de la carte entièrement à la main (comme EO) | Fastidieux, surtout au tactile ; remplacé par D8 |

## 4. Questions ouvertes

Ambiance (S8) :
- Q38. Style de la carte : propre comme dans EO, avec ou sans une touche de carnet de cartographe ? À trancher sur maquettes
- Q39. Sons d'ambiance qui annoncent les cycles (on entend la cascade avant l'inondation) ?

Technique (S7) :
- Q34. Résolution interne : 480×270, 640×360, ou autre ? À trancher par un essai à l'écran (plus haut = plus de dessin)
- Q35. Hauteur dans les niveaux : relief (une altitude par case), ponts (deux niveaux au même endroit, à limiter), étages empilés (niveaux séparés). Vérifier dans la tranche verticale que les ponts restent lisibles sur la carte. Modèle : Chrono Trigger et Golden Sun (le personnage a un niveau courant, changé par les marches, échelles et lianes ; ordre de dessin selon ce niveau ; la vue de trois quarts du jeu actuel s'y prête déjà)

Équilibrage (plus tard) :
- Q16. Mode intermédiaire de D14 : recalage sur n'importe quel élément clé, même non noté
- Q22. Qu'est-ce qui donne de la valeur au temps **entre** les cycles ? Proposition : rien, et on l'assume ; règle : aucune mécanique ne se paie en cycles vides (X8). Le vieillissement des aventuriers est écarté pour l'instant

## 4 bis. Règles de level design (tirées des décisions)

- R1. Les éléments intéressants sont loin des portes : explorer à partir d'une porte doit coûter (D20)
- R2. Chaque repère est unique, ou volontairement ambigu, jamais par accident (D4)
- R3. Ce qui entoure une porte décide de la difficulté de localisation : un élément distinctif à côté d'une porte la rend reconnaissable dès qu'on l'a noté (D13, D19)
- R4. Chaque changement d'étage a une cause visible avant qu'il se produise (D6)
- R5. Pas d'allers-retours absurdes : le palier d'une serrure ou d'un accès suit la profondeur (un palier 3 n'a rien à faire à l'étage 1), et ce qu'on revient chercher sur un étage déjà fini vaut le déplacement (D21, D27)
- R6. Les combats doivent pouvoir se jouer dans des clairières ou des zones intéressantes ; une patrouille dans un couloir unique doit toujours pouvoir se contourner. Les étages doivent être assez grands pour des groupes de 6 ennemis
- R7. Les clairières (lieux de repos, D51) doivent être espacées de façon à ne jamais laisser l'équipe sans repos possible trop longtemps ; un cycle qui rend une clairière inutilisable (inondée…) doit en laisser une autre accessible

## 4 ter. Règles de conception des compétences

- C1. Chaque compétence est utile à sa manière : pas de version « +1 » qui rend la précédente inutile, des variantes plutôt que des améliorations (D31)
- C2. Une compétence transmise hors de sa classe d'origine reste utilisable, mais ses effets suivent les stats du personnage qui l'utilise (D25) : une mage avec une charge de guerrier frappe moins fort qu'un guerrier

## 4 quater. Exigences d'interface

- U1. La carte sera très chargée (tracé, annotations, annotations datées, zones hachurées, cycles, portes, sac) : elle doit rester **lisible et éditable**, au tactile comme à la souris. Prévoir filtres par type d'annotation, choix du jour affiché, zoom

## 5. Sujets en attente

| # | Sujet | Source | Notes |
|---|---|---|---|
| S3 | Compétences hors combat : récolte, chasse, cuisine, éclaireur, trappeur, cartographe | Robin (Barbarian, Gloutons & Dragons), RotundBun | **Fermé** (D22 à D27, D67 à D69, section 8). Ne pas refaire le Farmer d'EO3 (classe utilitaire qui finit en réserve). Leur donner une ressource à gagner (temps, repos, accès, information). Lien avec D5 : moins de combats = moins de repos = horloge plus lente. Pistes de Robin autour du repos : la cuisine consomme moins de ressources ou permet de manger ce qu'on trouve (baies…) ; l'éclaireur empêche les attaques de bêtes la nuit ; le trappeur pose des pièges la nuit et récupère de la nourriture au matin. Cartographe : attention, révéler toute la carte d'emblée viderait D1 et D9 de leur sens ; plutôt des aides partielles (voir les balises, se localiser plus vite, deviner la forme de la salle) |
| S4 | Expédition, ville, ce qu'on perd quand ça tourne mal | Robin (Barbarian) | **Fermé** (D15 à D21) ; reste Q22. Le coût d'un repos dépend de S3 et S4. Idée de Robin : des cycles aux durées définies, adaptés au mobile (« je finis mon cycle et j'arrête ») ; un roguelite « doux », sans aléatoire, avec progression et amélioration entre les cycles |
| S5 | Mentor / breeding / progression | Robin, DetDango | **Fermé** (X11, D28 à D31). Risque « jeu de chiffres » ; alternative : base qu'on améliore, puissance via l'équipement (Elminage). Robin hésite sur le mentorat ; acquis : X11, D28. Pistes : réserve formée en ville sans expédition ; une compétence transmissible (variété de builds) |
| S6 | Combat au tour par tour | Robin, RotundBun | **Fermé** (D32, D34 à D46). Parade (Clair Obscur) à adapter au rétro et au tactile ; grille de positions (5×5 proposée par Robin) ; diversité tactique plutôt que cumul de chiffres ; synergies |
| S7 | Plateforme et technique | Robin, RotundBun | **Fermé** pour l'essentiel : Godot 4 (D57) ; PC d'abord (D53), paysage (D54). Mobile plus tard : sessions courtes, sauvegarde auto robuste. La fin d'une expédition est un point d'arrêt naturel ; au milieu d'une expédition, sauvegarde à chaque pas (appli fermée par erreur) |
| S8 | Ambiance | RotundBun | **Presque fermé** (D58 à D66) ; restent Q38 et Q39. Lo-fi, vignettage, fenêtres illustrées pour les événements |
| S1b | Étages qui changent | Robin (Outer Wilds) | **Fermé** (D47 à D51) |
| S9 | Références à étudier | commentaires, discussion | Etrian Mystery Dungeon, Elminage Original, Below, Into the Breach, EO2 à EO5, Untold, Nexus, Outer Wilds ; jeux d'extraction (Escape from Tarkov, Dark and Darker) pour la tension « je pousse ou je rentre » ; Darkest Dungeon pour les blessures et la retraite ; Chrono Trigger et Golden Sun pour les niveaux superposés ; Golden Sun pour les énigmes de terrain liées aux compétences (lianes, piliers), modèle pour les rôles (D23) |
| S10 | Juridique | imaginationac | Musique FF3 (Crystal Tower) à remplacer avant toute sortie publique (D66 : musique originale, il faudra un compositeur ou une compositrice). À vérifier : l'origine des tuiles « émeraude » (dessinées par un script `fabrique.py`, introuvable dans `tools/`), du sprite du joueur et de l'escalier (`objets.png`, `calques.png`). Historique : en octobre, les mondes essayés venaient de FF3 Pixel Remaster (altar_herbe, touffes de Dragon's Peak) et le socle de la sortie de Gulgan Gulch ; s'assurer qu'aucun élément montré dans la vidéo Reddit ou repris dans le futur jeu n'en dérive. Les règles d'habillage apprises sur les cartes de FF3 sont abstraites ; les planches FF3 du kit ne doivent jamais être distribuées |

## 6. Retours Reddit : suivi

| Commentaire | Idée | Statut |
|---|---|---|
| navr33 (19), Quagquagsire | « Ça ressemble à Mystery Dungeon » | Traité : D1, D2, X1 |
| EmpressLust | Aléatoire et roguelike = inconvénients ; level design réfléchi | Traité : D1, D2, X1 ; méta-progression → S4/S5 |
| DetDango | Donjons séparés au choix, base à construire, étages faits main mélangés, donjons tournants | Partiel : D2 ; base et donjons au choix → S4/S5 |
| RotundBun | Mobile, structure inverse d'Into the Breach, donjon conservé (Below), atmosphère, compétences hors combat | Partiel : D1 ; reste → S3, S7, S8 |
| imaginationac | Musique de FF3 | → S10 |

## 7. Tranche verticale (D56)

But : savoir si les trois paris tiennent — **se repérer sur sa carte**, **la parade au tap**, **la tension « je pousse ou je rentre »**.

| Domaine | Dans la tranche | Hors tranche |
|---|---|---|
| Donjon | 1 étage fait main (~40×40), strate forêt, 1 cycle (ronces), 1 interrupteur | Plusieurs étages, autres strates, quête |
| Carte | 3 portes, départ aléatoire, fragment et recalage, 5 types d'annotations, zones hachurées | Filtres avancés |
| Combat | 4 directions, vitesse, mouvement + une action, garde, parade au tap, 2 types d'armure | Tir allié, mode difficile |
| Équipe | 3 classes (tank à bouclier, archer, mage), 4 stats (D67), 3 rôles : éclaireur, cuisinier, crocheteur | Recrues, mentorat, transmission, autres rôles |
| Ennemis | 3 comportements (gardien, patrouille, chasseur) + 1 FOE | Ennemis fourbes, autres comportements |
| Économie | Vivres, repos en clairière, plafond de jours, sac, sortie par une porte ; coffres verrouillés (paliers 1 et 2) | Ville, or, palier 3 |
| Préparation | Un écran : acheter des vivres, choisir rôles et formation | Ville complète |

Mesures (5 à 10 testeurs, par exemple ceux du post Reddit) :
- Rôles : un rôle qui rapporte du butin (crocheteur) donne-t-il envie d'être emmené (D23) ?
- Se repérer : temps pour se recaler ; vécu comme un jeu ou comme une corvée ?
- Parer : les échecs viennent-ils de la lisibilité ou de l'adresse ? Le geste plaît-il encore au dixième combat ?
- Pousser ou rentrer : y a-t-il des expéditions où le joueur hésite vraiment ?

## 8. Rôles de terrain (D68)

Chaque rôle a un levier principal, rapporte un avantage concret (D23) et n'est jamais obligatoire (D27, D69). La stat indiquée accélère sa maîtrise et renforce ses effets (D25).

| Rôle | Levier | Ce qu'il apporte | Au camp | Stat |
|---|---|---|---|---|
| Cartographe | Se localiser | Se recale plus vite ; repère les murs suspects (passages secrets) | — | Intelligence |
| Éclaireur | Détecter | Voit les champs de vision, repère les ennemis fourbes, réussit ses embuscades | Pas d'attaque surprise la nuit | Dextérité |
| Cuisinier | Consommer moins | Les vivres nourrissent plus ; cuisine ce qu'on trouve ; plats qui donnent des bonus | Choix du plat (léger, moyen, copieux) | Intelligence |
| Traqueur | Contrôler et chasser | Pose des pièges sur la carte pour bloquer une patrouille ou un FOE (pas en combat) ; meilleur butin sur les bêtes (peaux, os, viande) | Pièges de nuit : gibier au matin, alarme | Dextérité |
| Cueilleur | Récolter | Ramasse herbes et baies en passant (passif) | Prépare remèdes et antidotes (actif) | Endurance |
| Crocheteur | Ouvrir | Serrures par paliers ; désamorce les pièges de coffre | — | Dextérité |
| Pionnier | Tailler et grimper | Coupe ronces et obstacles, abat un arbre pour faire un pont, escalade lianes et falaises, pose une corde : toujours des raccourcis, jamais le seul chemin | Bois pour le feu | Force |
| Porteur | Ramener plus | Plus de place dans l'inventaire, donc plus de butin à l'extraction | — | Endurance |
| Érudit | Comprendre | Lit les stèles d'une civilisation ancienne : révèle ou ajoute des annotations sur la carte (mystère, indices, avertissements) | Partage ce qu'il a appris (dialogues) | Intelligence |

Exemples de paliers de maîtrise (D26, D27) :
- Crocheteur : serrures simples, puis renforcées et pièges de coffre, puis runiques.
- Cartographe : portes en surbrillance, puis forme de la salle devinée, puis recalage sur des éléments non notés (réponse possible à Q16).

