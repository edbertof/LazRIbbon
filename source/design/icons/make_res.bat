dir /b *.png > files.txt
lazres ..\LazRibbon_Core.res @files.txt
del files.txt
