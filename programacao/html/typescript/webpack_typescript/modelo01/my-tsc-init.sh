#!/bin/sh

echo PROGRAMA: Cria projeto typescript Básico
echo AUTOR: Paulo Pacheco
echo DATA DA CRIAÇÃO: 01/06/2021
echo DATA DA ULTIMA ATUALIZAÇÃO: 01/06/2021
echo .

# rename(){} : Funcão para renomeia arquivo e apaga o arquivo anterior se existir
rename(){
  #Parametros
  # Chamada: rename param1 param2
  fileName    = "$1";
  fileNameOld = "$2";     

# begin
    if [ -f $fileNameOld ]; then
        # Se $fileNameOld já existe então apaga
#        echo O arquivo $fileNameOld foi criado anteriormente!. 
#        echo Tecle ENTER para apaga-lo.
#        read input
        rm $fileNameOld
    fi


    if [ -f $filename ]; then # Se $filename existe renomeia para $fileNameOld
#        echo O arquivo $fileName foi criado anteriormente!. 
#        echo Tecle ENTER para renomear para $fileNameOld.
#        read input
        mv  $fileName $fileNameOld   
    fi
# end    
}

# $1 é passado na execução de my-tsc-init.sh
pasta=$1

# Se o paramentro 01 não existe então fazer nome do projeto igual ./myproject
if [ -z $pasta ]; # -z indica que a string $pasta existe e é vazia.
then     
  # echo  -z $pasta retorno true
  # read input
   pasta="./myproject"
else  
   # echo  -z $pasta retorno false  
   # read input
   pasta="./$pasta"
fi;   


if [ -d $pasta ]; then # Se $pasta já existe então aborta execução.
  echo O projeto $pasta foi criado anteriormente!. Tecle ENTER para sair.
  read input
  exit 2
else # A $pasta não existe então pergunta avisa que vair criar projeto.
  echo Presione ENTER para criar o projeto: $pasta 
  read input
fi

# Cria a pasta do projeto passada no parametro 01
mkdir $pasta

# Cria as pasta para os códigos fontes do projeto
mkdir ./"$pasta"/src      # Pasta raiz do código fonte 
mkdir ./"$pasta"/src/html # Pasta html de entrada de webpack
mkdir ./"$pasta"/src/css  # Pasta css de entrada de webpack
mkdir ./"$pasta"/src/js   # Pasta de saide js de tsc 
mkdir ./"$pasta"/src/ts   # Pasta de entrada ts de tsc
mkdir ./"$pasta"/dist     # Pasta destino do webpack para ser publicada na web.

# Criar arquivo inicial index.html
cat >"./"$pasta"/src/html/index.html"<<EOT

<!DOCTYPE html>
    <html dir="ltr" lang="pt-br">

        <head>
            <meta http-equiv="content-type" content="text/html; charset=utf-8" />

            <meta name="viewport" content="width=device-width, initial-scale=1.0" />

            <title>Modelo de projeto typescript</title>

            <meta name="createDate" content="28/05/2021" />
            <meta name="createDateUpdate" content="25/05/2021" />
            <meta name="description" content="Todos projeto typescript deve seguir essa sequência ao iniciar..." />
            <meta name="keywords" content="typescript,webpack" />

            <link type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
                rel="stylesheet" />

        </head>

        <body>
            <p>Alo mundo</p>
        </body>

    </html>            	

EOT

# Criar arquivo inicial defaulttheme.css
cat >"./"$pasta"/src/css/defaulttheme.css"<<EOT
   html {
      scroll-behavior: smooth;
      /* scroll lento*/
   }

   body {
      margin: 0;
      font-family: Arial
   }

EOT

# Criar arquivo inicial index.ts
cat >"./"$pasta"/src/ts/index.ts"<<EOT
   console.log('Alo mundo'); 
EOT


# Criar workspace para o projeto do vscode
cat >"./"$pasta"/workspace.code-workspace"<<EOT
{
	"folders": [
		{
			"path": "."
		}
	]
}
EOT


# Executa o prograa tsc-init
cd $pasta
tsc-init

echo ...
echo Alterar o arquivo webpack.config.js
echo 1 - Adicione a linha abaixo:
echo     mode : \'development\',   //O modo padrão é production  
echo 2 - Trocar as linhas :
echo     entry: \'./index.ts\', //Arquivo principal de entrada
echo por 
echo     entry: \'./src/ts/index.ts\', //Arquivo principal de entrada
# Atualiza o arquivo de entrada de webpack.config.js
subStrOrigem="entry: '.\/index.ts'"
subStrDestino="entry: '.\/src\/ts\/index.ts'"
fileNameOld="./webpack.config.js.ant"
fileName="./webpack.config.js"
rename "$fileName" "$fileNameOld"
sed "s/$subStrOrigem/$subStrDestino/g" $fileNameOld > $fileName 
echo ...
          
echo ...
echo Alterar o arquivo pakage.json
echo 1 - Trocar as linhas :
echo    '"dev": "webpack-dev-server --inline --hot",'
echo        por 
echo     '"dev": "webpack serve --mode development --env development --hot --port 3000",'
# Atualiza script dev do package.json
subStrOrigem="webpack-dev-server --inline --hot"
subStrDestino="webpack serve --mode development --env development --hot --port 3000"
fileNameOld="./package.json.ant"
fileName="./package.json"
rename "$fileName" "$fileNameOld"
sed "s/$subStrOrigem/$subStrDestino/g" $fileNameOld > $fileName 

echo ...
echo 2 - Trocar as linhas :
echo    '"build": "webpack -p"'
echo        por 
echo     '"build": "webpack --mode='production'"'
echo ...
# Atualiza script dev do package.json
subStrOrigem="webpack -p"
subStrDestino="webpack --mode='production'"
fileNameOld="./package.json.ant"
fileName="./package.json"
rename "$fileName" "$fileNameOld"
sed "s/$subStrOrigem/$subStrDestino/g" $fileNameOld > $fileName 

fim do script