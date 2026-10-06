echo "Sincroniza todos os arquivo para /media/paulosspacheco/hd3tb/ssd-882tb"

# Sintaxe: copyTo.sh "Arquivo destino da cópia" "Arquivos que contém os arquivos a serem ignorados" 
./copyto.sh --log "./copyto_$(date +%Y%m%d_%H%M%S).log" "/media/paulosspacheco/hd3tb/ssd-882tb" "./copyto_hd500gb_ignore.txt"
