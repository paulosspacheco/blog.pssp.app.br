export default class DialogoModal {
    constructor(dialogoId, formularioId) {
        this.dialogo = document.getElementById(dialogoId);
        this.formulario = document.getElementById(formularioId);
        this.resolverDialogo = null;
        this.rejeitarDialogo = null;

        this.setupEventListeners();
    }

    setupEventListeners() {
        document.getElementById('abrirDialogoBtn').addEventListener('click', () => this.abrirDialogoEExibirDados());
        document.getElementById('cancelarBtn').addEventListener('click', () => this.procedimentoCancelarDialogo());
        document.getElementById('confirmarBtn').addEventListener('click', () => this.procedimentoConfirmarDialogo());
    }

    abrirDialogo() {
        this.dialogo.showModal();
    }

    handleDialog(resolve, reject) {
        this.resolverDialogo = resolve;
        this.rejeitarDialogo = reject;
        this.abrirDialogo();
    }

    chamarDialogo() {
        return new Promise((resolve, reject) => this.handleDialog(resolve, reject));
    }<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Modal Dialog with Data Return</title>
    </head>
    <body>
        <h1>Example of Modal Dialog with Data Return</h1>
        <button id="openDialogBtn">Open Dialog</button>
    
        <!-- Dialog box structure -->
        <dialog id="myDialog">
            <form id="dialogForm" method="dialog">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>
                <br><br>
                <label for="age">Age:</label>
                <input type="number" id="age" name="age" required>
                <br><br>
                <menu>
                    <button type="button" id="cancelBtn">Cancel</button>
                    <button type="button" id="confirmBtn">Confirm</button>
                </menu>
            </form>
        </dialog>
    
        <script type="module">
            import ModalDialog from './js/ModalDialog.js';
    
            // Initialize the class
            const dialog = new ModalDialog('myDialog', 'dialogForm');
        </script>
    </body>
    </html>
    

    async executarDialogo() {
        const dados = await this.chamarDialogo();
        return dados;
    }

    coletarDadosDialogo() {
        const nome = document.getElementById('nome').value;
        const idade = document.getElementById('idade').value;
        return { nome, idade };
    }

    fecharDialogo() {
        this.dialogo.close();
    }

    procedimentoConfirmarDialogo() {
        if (this.formulario.checkValidity()) {
            const dados = this.coletarDadosDialogo();
            this.fecharDialogo();
            this.resolverDialogo(dados);
        } else {
            this.formulario.reportValidity();
        }
    }

    procedimentoCancelarDialogo() {
        this.fecharDialogo();
        this.rejeitarDialogo('Diálogo cancelado pelo usuário');
    }

    async abrirDialogoEExibirDados() {
        try {
            const dados = await this.executarDialogo();
            alert(`Dados capturados:\nNome: ${dados.nome}\nIdade: ${dados.idade}`);
        } catch (erro) {
            alert('Erro: ' + erro);
        }
    }
}
