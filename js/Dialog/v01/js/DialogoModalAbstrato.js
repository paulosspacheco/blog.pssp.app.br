// DialogoModalAbstrato.js
export default class DialogoModalAbstrato {
    constructor(dialogoId, formularioId) {
        if (this.constructor === DialogoModalAbstrato) {
            throw new Error("Não é possível instanciar uma classe abstrata.");
        }

        this.dialogo = document.getElementById(dialogoId);
        this.formulario = document.getElementById(formularioId);
        this.resolverDialogo = null;
        this.rejeitarDialogo = null;

        this.setupEventListeners();
    }

    setupEventListeners() {
        throw new Error("Método 'setupEventListeners' deve ser implementado.");
    }

    abrirDialogo() {
        throw new Error("Método 'abrirDialogo' deve ser implementado.");
    }

    handleDialog(resolve, reject) {
        this.resolverDialogo = resolve;
        this.rejeitarDialogo = reject;
        this.abrirDialogo();
    }

    chamarDialogo() {
        return new Promise((resolve, reject) => this.handleDialog(resolve, reject));
    }

    async executarDialogo() {
        const dados = await this.chamarDialogo();
        return dados;
    }

    coletarDadosDialogo() {
        throw new Error("Método 'coletarDadosDialogo' deve ser implementado.");
    }

    fecharDialogo() {
        throw new Error("Método 'fecharDialogo' deve ser implementado.");
    }

    procedimentoConfirmarDialogo() {
        throw new Error("Método 'procedimentoConfirmarDialogo' deve ser implementado.");
    }

    procedimentoCancelarDialogo() {
        throw new Error("Método 'procedimentoCancelarDialogo' deve ser implementado.");
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
