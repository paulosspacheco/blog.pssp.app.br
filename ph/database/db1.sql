-- Criação do Banco de Dados
CREATE DATABASE nome_do_banco_de_dados;

-- Uso do Banco de Dados Criado
USE nome_do_banco_de_dados;

-- Criação das Tabelas
CREATE TABLE Operadores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    telefone VARCHAR(20)
);

CREATE TABLE Hospitais (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    telefone VARCHAR(20)
);

CREATE TABLE Natureza_da_interacao (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255)
);

CREATE TABLE Medicos (
    id SERIAL PRIMARY KEY,
    id_operadores INT,
    nome VARCHAR(255),
    telefone VARCHAR(20),
    telefone_da_secretaria VARCHAR(20),
    login VARCHAR(255),
    senha VARCHAR(255),
    FOREIGN KEY (id_operadores) REFERENCES Operadores(id)
);

CREATE TABLE Servico_de_agendas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    login VARCHAR(255),
    senha VARCHAR(255)
);

CREATE TABLE Convenios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    login VARCHAR(255),
    senha VARCHAR(255)
);

CREATE TABLE Clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    telefone_whatsapp VARCHAR(20),
    email VARCHAR(255),
    login VARCHAR(255),
    senha VARCHAR(255),
    id_convenio INT,
    datetime_disponivel TIMESTAMP,
    matricula_no_convenio VARCHAR(255),
    integracao TEXT,
    FOREIGN KEY (id_convenio) REFERENCES Convenios(id)
);

CREATE TABLE Integracao (
    id SERIAL PRIMARY KEY,
    endereco_do_site TEXT,
    login VARCHAR(255),
    senha VARCHAR(255),
    status BOOLEAN
);

CREATE TABLE Expediente_do_medico_data (
    id_medico INT,
    datetime TIMESTAMP,
    PRIMARY KEY (id_medico, datetime),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id)
);

CREATE TABLE Expediente_do_medico_horas (
    id_medico INT,
    datetime_inicial TIMESTAMP,
    datetime_final TIMESTAMP,
    PRIMARY KEY (id_medico, datetime_inicial),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id)
);

CREATE TABLE Agenda (
    id SERIAL PRIMARY KEY,
    id_medico INT,
    id_cliente INT,
    datetime TIMESTAMP,
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
    nome VARCHAR(255)
);

CREATE TABLE Consulta (
    id SERIAL PRIMARY KEY,
    id_agenda INT,
    id_cliente INT,
    id_medico INT,
    datetime TIMESTAMP,
    id_convenio INT,
    id_forma_de_pagamento INT,
    FOREIGN KEY (id_agenda) REFERENCES Agenda(id),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id),
    FOREIGN KEY (id_medico) REFERENCES Medicos(id),
    FOREIGN KEY (id_convenio) REFERENCES Convenios(id),
    FOREIGN KEY (id_forma_de_pagamento) REFERENCES Formas_de_Pagamento(id)
);
