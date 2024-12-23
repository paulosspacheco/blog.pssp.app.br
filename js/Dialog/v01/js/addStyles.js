addStyles() {
        const style = document.createElement('style');
        style.textContent = `

            /* input_Box.css */

            /* @import url('./color_tons_de_cinza.css'); */
            /* @import url('./color_tons_dark.css'); */
            /* @import url('./color_tons_de_dark_claro.css'); */
            /* @import url('./color_tons_de_azul_ceu.css'); */
            /* @import url('./color_tons_de_verde_claro.css'); */
            /* @import url('./color_tons_amarelo.css'); */
            @import url('../css/color_tons_de_lilas_claro.css');

            html, body {
                height: 100%; /* Garante que o body ocupe toda a altura da janela */
                margin: 0; /* Remove margens do body */
            }            

            .inputBox-dialog-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: rgba(0, 0, 0, 0.5); /* Cor do fundo com transparência */
                z-index: 1000; /* Coloca o overlay acima de outros elementos */
                display: none; /* Inicialmente oculto */
            }

            .inputBox-dialog {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background-color: white;
                border-radius: 5px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                z-index: 1001;
                display: none;

                /* Define largura e altura máximas da caixa de diálogo */
                width: 90%;
                max-width: 800px;
                max-height: 90vh;

                /* Permite que o conteúdo se expanda verticalmente se necessário */
                overflow: hidden;
            }


            .inputBox-dialog-header {
                font-size: 1.2em; /* Tamanho da fonte do cabeçalho */
                margin-bottom: 15px; /* Espaçamento inferior */
            }      


            .inputBox-container {
                /* Usa 100% da largura e altura do pai sem ultrapassar */
                width: 100%;
                height: 100%;

                /* Flexível para rolagem interna quando o conteúdo é maior */
                display: flex;
                flex-direction: column;

                /* Reduz as margens e adição de borda para visualização */
                margin: 0;
                border: 1px solid #ccc;

                /* Rolagem apenas vertical */
                overflow-y: auto;
                overflow-x: hidden; /* Opcional: oculta rolagem horizontal */

                /* Estilo de posicionamento relativo para possíveis conteúdos internos */
                position: relative;
            }

            .inputBox-table-title {
                height: 30px; /* Altura fixa do título */
                background-color: #f1f1f1; /* Cor de fundo do título */
                display: flex;
                align-items: center; /* Centraliza verticalmente o texto */
                padding-left: 10px; /* Espaço à esquerda */
                font-weight: bold; /* Deixa o título em negrito */
                border-bottom: 1px solid #ccc; /* Linha inferior para separação */
            }

            .inputBox-table-container {
                flex: 1; /* Faz a tabela ocupar o espaço restante */
                overflow-y: auto; /* Permite rolagem vertical na tabela */
                overflow-x: auto; /* Permite rolagem horizontal se necessário */
                padding: 5px; /* Espaço interno para evitar que o conteúdo fique colado nas bordas */
            }

            .inputBox-table-container table {
                width: 100%; /* A tabela ocupa toda a largura disponível do contêiner */
            }

            .inputBox-footer-panel {                
                height: 30px; /* A altura do painel para os botões */
                background-color: #f1f1f1; /* Cor de fundo do painel */
                display: flex; /* Para alinhar os botões horizontalmente */
                justify-content: flex-end; /* Alinha os botões à direita */
                /* padding: 10px; /* Espaçamento interno */
                border-top: 1px solid #ccc; /* Linha superior para separação */
            }

                `;
        document.head.appendChild(style);
    }