-- Criação do Banco de Dados (Executar no ambiente de administração do PostgreSQL)
CREATE DATABASE sistema_saude;

-- Conectar ao Banco de Dados Criado (Executar no ambiente de administração do PostgreSQL)
\c sistema_saude;

-- Criação das Tabelas
CREATE TABLE Operadores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE Hospitais (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE Natureza_da_interacao (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE Medicos (
    id SERIAL PRIMARY KEY,
    id_operadores INT,
    nome VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    telefone_da_secretaria VARCHAR(20),
    login VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_operadores) REFERENCES Operadores(id)
);

CREATE TABLE Servico_de_agendas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    login VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL
);

CREATE TABLE Convenios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    login VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL
);

CREATE TABLE Clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    telefone_whatsapp VARCHAR(20),
    email VARCHAR(255) NOT NULL,
    login VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    id_convenio INT,
    datetime_disponivel TIMESTAMP,
    matricula_no_convenio VARCHAR(255),
    integracao TEXT,
    FOREIGN KEY (id_convenio) REFERENCES Convenios(id)
);

CREATE TABLE Integracao (
    id SERIAL PRIMARY KEY,
    endereco_do_site TEXT NOT NULL,
    login VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    status BOOLEAN NOT NULL
);

CREATE TABLE Expediente_do_medico_data (
    id_medico INT NOT NULL,
    datetime TIMESTAMP NOT NULL,
    PRIMARY KEY (id_medico, datetime),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id)
);

CREATE TABLE Expediente_do_medico_horas (
    id_medico INT NOT NULL,
    datetime_inicial TIMESTAMP NOT NULL,
    datetime_final TIMESTAMP NOT NULL,
    PRIMARY KEY (id_medico, datetime_inicial, datetime_final),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id)
);

CREATE TABLE Agenda (
    id SERIAL PRIMARY KEY,
    id_medico INT NOT NULL,
    id_cliente INT NOT NULL,
    datetime TIMESTAMP NOT NULL,
    datetime_confirmacao TIMESTAMP,
    id_convenio INT,
    id_natureza_da_interacao INT,
    id_formas_de_pagamento INT,
    observacoes TEXT,
    FOREIGN KEY (id_medico) REFERENCES Medicos(id),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id),
    FOREIGN KEY (id_convenio) REFERENCES Convenios(id),
    FOREIGN KEY (id_natureza_da_interacao) REFERENCES Natureza_da_interacao(id),
    FOREIGN KEY (id_formas_de_pagamento) REFERENCES Formas_de_Pagamento(id)
);

CREATE TABLE Formas_de_Pagamento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE Consulta (
    id SERIAL PRIMARY KEY,
    id_agenda INT,
    id_cliente INT,
    id_medico INT,
    datetime TIMESTAMP NOT NULL,
    id_convenio INT,
    id_forma_de_pagamento INT,
    FOREIGN KEY (id_agenda) REFERENCES Agenda(id),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id),
    FOREIGN KEY (id_convenio) REFERENCES Convenios(id),
    FOREIGN KEY (id_forma_de_pagamento) REFERENCES Formas_de_Pagamento(id)
);
