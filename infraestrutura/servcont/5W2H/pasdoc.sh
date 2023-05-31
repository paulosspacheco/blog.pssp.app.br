# Gera documento .html da pasta ./units/*.pas para a pasta ./Docs/pasdoc

# Move-se para a pasta raiz do projeto.
cd "/home/paulosspacheco/servcont/PasDoc"
rm "/home/paulosspacheco/servcont/PasDoc/*.*"

#pasdoc --marker=: --markdown --output=./Docs/pasdoc `find ./units/ -iname '*.pas'`
#pasdoc @pasdoc.cfg `find ./ -iname '*.pas'`
#pasdoc --language=br.utf8 --auto-link --verbosity=1 --marker=: --staronly --markdown --output=./Docs/pasdoc  `find ./ -iname '*.pas'`

#pasdoc --use-tipue-search --verbosity=6 --auto-link --language=br.utf8 --marker=: --write-uses-list --staronly --markdown --output=./Docs/pasdoc `find ./ -iname '*.pas'`
pasdoc --use-tipue-search --verbosity=6 --auto-link --language=br.utf8 --marker=: --write-uses-list --staronly --markdown --output=./Docs/pasdoc --format=htmlhelp `find ./ -iname '*.pas'`




