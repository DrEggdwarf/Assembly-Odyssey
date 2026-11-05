@echo off
rem Assembly Odyssey : build MASM 5 + LINK, a lancer depuis C:\ODYSSEY
rem "BUILD RUN" lance aussi le jeu. Sorties (.OBJ, .LST, .EXE) dans build\
rem Liste des modules a lier : ODYSSEY.LNK (une commande DOS fait 127 caracteres max)
if not exist build\nul md build
masm /Iinc /Ilib lib\libgfx,build\libgfx,build\libgfx;
if errorlevel 1 goto err
masm /Iinc /Ilib lib\libao,build\libao,build\libao;
if errorlevel 1 goto err
masm /Iinc /Ilib lib\libopl,build\libopl,build\libopl;
if errorlevel 1 goto err
masm /Iinc /Ilib lib\libmus,build\libmus,build\libmus;
if errorlevel 1 goto err
masm /Iinc /Ilib src\odyssey,build\odyssey,build\odyssey;
if errorlevel 1 goto err
masm /Iinc /Ilib src\mainscr,build\mainscr,build\mainscr;
if errorlevel 1 goto err
masm /Iinc /Ilib src\maze,build\maze,build\maze;
if errorlevel 1 goto err
masm /Iinc /Ilib src\niveau,build\niveau,build\niveau;
if errorlevel 1 goto err
masm /Iinc /Ilib src\habille,build\habille,build\habille;
if errorlevel 1 goto err
masm /Iinc /Ilib src\vision,build\vision,build\vision;
if errorlevel 1 goto err
masm /Iinc /Ilib src\bandeau,build\bandeau,build\bandeau;
if errorlevel 1 goto err
masm /Iinc /Ilib src\carte,build\carte,build\carte;
if errorlevel 1 goto err
masm /Iinc /Ilib src\genmaze,build\genmaze,build\genmaze;
if errorlevel 1 goto err
link @odyssey.lnk
if errorlevel 1 goto err
echo Build OK : build\ODYSSEY.EXE
if "%1"=="run" build\odyssey
if "%1"=="RUN" build\odyssey
goto end
:err
echo *** ERREUR de build ***
:end
