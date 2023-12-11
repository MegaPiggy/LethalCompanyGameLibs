@echo off 

@REM Add all the assemblies you want to publicize in this list
set toPublicize=Assembly-CSharp.dll Assembly-CSharp-firstpass.dll

set exePath=%1
echo exePath: %exePath% 

@REM Remove quotes
set exePath=%exePath:"=%

set managedPath=%exePath:.exe=_Data\Managed%
echo managedPath: %managedPath%

set outPath=%~dp0\package\lib

@REM Strip all assembiles, but keep them private.
%~dp0\tools\NStrip.exe "%managedPath%" -o %outPath%

@REM Strip and publicize assemblies from toPublicize.
(for %%a in (%toPublicize%) do (
  echo a: %%a

  %~dp0\tools\NStrip.exe "%managedPath%\%%a" -o "%outPath%\%%a" -cg -p --cg-exclude-events
))

@REM Delete System.x, netstandard, and mscorlib dlls since they cause duplicate references (.netframework dev pack)
del "%outPath%\System.*"
del "%outPath%\mscorlib.dll"
del "%outPath%\netstandard.dll"

pause