#!/bin/bash

# Script: merge_scripts.sh
# Descrição: Concatena todos os arquivos *.sh na pasta corrente em um único arquivo chamado 'scripts.sh'.
#            Adiciona separadores entre os scripts para facilitar a leitura e análise.
#            Ignora o próprio 'merge_scripts.sh' e o 'scripts.sh' gerado para evitar loops.
# Uso: Salve este código como 'merge_scripts.sh', torne executável com 'chmod +x merge_scripts.sh'
#      e rode './merge_scripts.sh' na pasta com os scripts originais.
# Nota: Faça backup da pasta antes, se necessário. O arquivo 'scripts.sh' será sobrescrito.

set -e  # Para em caso de erro

# Arquivo de saída
OUTPUT_FILE="scripts.sh"

# Limpa o arquivo de saída se existir
> "$OUTPUT_FILE"

# Cabeçalho geral
echo "#!/bin/bash" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "# Arquivo Unificado: Todos os scripts *.sh da pasta corrente" >> "$OUTPUT_FILE"
echo "# Gerado em: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "# Original: Concatenação de $(ls *.sh | grep -v -E '^(merge_scripts.sh|scripts.sh)$' | wc -l) scripts" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Lista de arquivos a ignorar
IGNORE_FILES="merge_scripts.sh|scripts.sh"

# Concatena cada script com separador
for script in *.sh; do
    if [[ ! "$script" =~ $IGNORE_FILES ]]; then
        echo "" >> "$OUTPUT_FILE"
        echo "# =================== INÍCIO DO SCRIPT: $script ===================" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        cat "$script" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        echo "# =================== FIM DO SCRIPT: $script ===================" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    fi
done

# Torna o arquivo unificado executável
chmod +x "$OUTPUT_FILE"

echo "Concluído! Arquivo 'scripts.sh' criado com $(ls *.sh | grep -v -E '^(merge_scripts.sh|scripts.sh)$' | wc -l) scripts concatenados."
echo "Agora, você pode encaminhar o 'scripts.sh' para avaliação das dependências."
echo "Para testar: ./scripts.sh (mas revise primeiro, pois é uma concatenação direta)."