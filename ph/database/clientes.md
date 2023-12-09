<div class="header" id="myHeader">
  <div class="navbar" w3-include-html="/menu.inc"> </div>
</div>
<div class="title"><script> document.write(document.title);</script></div>  
<main>
<!-- markdownlint-disable-next-line -->
<span id="topo"><span>

# Cadastro de clientes em python

1. Instalação de pacotes:

    ```bash

        mkdir NodeSequelize
        cd NodeSequelize

    ```

2. Programa para incluir, alterar, consultar e excluir cliente:

    ```python
    
    import psycopg2
    from psycopg2 import sql

    # Função para conectar ao banco de dados
    def conectar():
        return psycopg2.connect(
            dbname="seu_banco_de_dados",
            user="seu_usuario",
            password="sua_senha",
            host="localhost"
        )

    # Função para criar a tabela Edicos
    def criar_tabela_medicos(conexao):
        with conexao.cursor() as cursor:
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS Edicos (
                    Id SERIAL PRIMARY KEY,
                    Nome VARCHAR(255) NOT NULL,
                    Telefone VARCHAR(15),
                    Telefone_da_secretaria VARCHAR(15),
                    Login VARCHAR(50) UNIQUE NOT NULL,
                    Senha VARCHAR(50) NOT NULL
                );
            """)
        conexao.commit()

    # Função para inserir um novo médico
    def inserir_medico(conexao, nome, telefone, telefone_secretaria, login, senha):
        with conexao.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Edicos (Nome, Telefone, Telefone_da_secretaria, Login, Senha)
                VALUES (%s, %s, %s, %s, %s) RETURNING Id;
            """, (nome, telefone, telefone_secretaria, login, senha))
            medico_id = cursor.fetchone()[0]
        conexao.commit()
        return medico_id

    # Função para buscar todos os médicos
    def buscar_medicos(conexao):
        with conexao.cursor() as cursor:
            cursor.execute("SELECT * FROM Edicos;")
            medicos = cursor.fetchall()
        return medicos

    # Função para buscar um médico por ID
    def buscar_medico_por_id(conexao, medico_id):
        with conexao.cursor() as cursor:
            cursor.execute("SELECT * FROM Edicos WHERE Id = %s;", (medico_id,))
            medico = cursor.fetchone()
        return medico

    # Função para atualizar os dados de um médico
    def atualizar_medico(conexao, medico_id, nome, telefone, telefone_secretaria, login, senha):
        with conexao.cursor() as cursor:
            cursor.execute("""
                UPDATE Edicos
                SET Nome = %s, Telefone = %s, Telefone_da_secretaria = %s, Login = %s, Senha = %s
                WHERE Id = %s;
            """, (nome, telefone, telefone_secretaria, login, senha, medico_id))
        conexao.commit()

    # Função para excluir um médico por ID
    def excluir_medico(conexao, medico_id):
        with conexao.cursor() as cursor:
            cursor.execute("DELETE FROM Edicos WHERE Id = %s;", (medico_id,))
        conexao.commit()

    # Exemplo de uso
    conexao = conectar()
    criar_tabela_medicos(conexao)

    # Inserir um novo médico
    medico_id = inserir_medico(conexao, "Dr. Smith", "123456789", "987654321", "dr_smith", "senha123")

    # Buscar todos os médicos
    todos_medicos = buscar_medicos(conexao)
    print("Todos os médicos:", todos_medicos)

    # Buscar um médico por ID
    medico_encontrado = buscar_medico_por_id(conexao, medico_id)
    print("Médico encontrado:", medico_encontrado)

    # Atualizar os dados do médico
    atualizar_medico(conexao, medico_id, "Dr. Smith Atualizado", "111111111", "222222222", "dr_smith", "nova_senha")

    # Buscar novamente o médico por ID
    medico_atualizado = buscar_medico_por_id(conexao, medico_id)
    print("Médico atualizado:", medico_atualizado)

    # Excluir o médico
    excluir_medico(conexao, medico_id)

    # Buscar todos os médicos após exclusão
    todos_medicos_apos_exclusao = buscar_medicos(conexao)
    print("Todos os médicos após exclusão:", todos_medicos_apos_exclusao)

    # Fechar a conexão
    conexao.close()
    
    
    ```

<!-- markdownlint-disable-next-line -->
</main>

[🔝🔝](#topo "Retorna ao topo")
