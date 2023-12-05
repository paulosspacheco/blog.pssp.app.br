#/bin/bash
# Origem: https://www.vivaolinux.com.br/script/Transformar-eBook-em-Audiobook/
#
# by Rafael Fini
#         v: 1.0
#

if [ -z $1 ]
then
  echo "Modo de uso ./TTSBook [livro.txt]"
  exit 0
else

# Escolhe a lingua que será falada: en, pt, fr...
lang=pt

# Duração dos arquivos em minutos
length=05

filename=`echo $1 | sed -e 's/^.*\///' | sed 's/\..*$//'`
cp $1 temp

# Transforma codificação do arquivo para utf-8
cat temp | iconv -f iso8859-15 -t UTF-8 -o temp2
mv temp2 temp

# Transforma arquivo para terminação de linha UNIX
tr -d '\r' < temp > temp2
mv temp2 temp

# Formata palavras com continuação na outra linha (Evita a palavra travessão no TTS)
sed 's/\ \([^ \t\n\r\f\v]*-$\)/\n\1/' temp | sed '/-$/ N ; s/-\n//' > temp2
mv temp2 temp

# Apaga as linhas em branco
sed '/^$/d' temp > temp2
mv temp2 temp

#---------------------------------------------------------------------------------------------------------

  nlinhas=`sed -n '$=' temp`
  touch $filename.mp3

  for it in `seq -w 1 $nlinhas`;
  do
      echo -ne "Convertendo: $it de $nlinhas linhas."\\r
      linha=`sed "$it !d" temp`
      wget -q -U Mozilla -O $it.mp3 "http://translate.google.com/translate_tts?ie=UTF-8&tl=$lang&q=$linha"
      cat $filename.mp3 $it.mp3 > tempfalado
      mv tempfalado $filename.mp3
      rm $it.mp3
  done

  rm temp
  mp3splt $filename.mp3 -Q -n -x -o @f-@m -t $length.00
  echo "Feito.                                            "
fi
exit 0
