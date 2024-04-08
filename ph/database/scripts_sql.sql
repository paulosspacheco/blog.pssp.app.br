CREATE DATABASE assistente_virtual;

-- Criação da tabela operadores
CREATE TABLE operadores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    login VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    telefone VARCHAR(20)
);

-- Índice para tabela operadores
CREATE INDEX idx_operadores_nome ON operadores (nome);
CREATE INDEX idx_operadores_login ON operadores (login);

-- Criação da tabela hospitais
CREATE TABLE hospitais (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    telefone VARCHAR(20)
);

-- Índice para tabela hospitais
CREATE INDEX idx_hospitais_nome ON hospitais (nome);

-- Criação da tabela status_da_agenda_ou_consulta
CREATE TABLE status_da_agenda_ou_consulta (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(20)
);

-- Índice para tabela status_da_agenda_ou_consulta
CREATE INDEX idx_status_da_agenda_ou_consulta_nome ON status_da_agenda_ou_consulta (nome);

-- Criação da tabela medicos
CREATE TABLE medicos (
    id SERIAL PRIMARY KEY,
    id_operadores INTEGER,
    nome VARCHAR(50),
    telefone VARCHAR(25),
    telefone_da_secretaria VARCHAR(25),
    login VARCHAR(50),
    senha VARCHAR(20),
    FOREIGN KEY (id_operadores) REFERENCES operadores(id)
);

-- Índices para tabela medicos
CREATE INDEX idx_medicos_nome ON medicos (nome);
CREATE INDEX idx_medicos_telefone ON medicos (telefone);
CREATE INDEX idx_medicos_login ON medicos (login);

-- Criação da tabela servico_de_agendas
CREATE TABLE servico_de_agendas (
    id SERIAL PRIMARY KEY,
    id_operador INTEGER,
    nome VARCHAR(100),
    login VARCHAR(50),
    senha VARCHAR(50),
    FOREIGN KEY (id_operador) REFERENCES operadores(id)
);

-- Índices para tabela servico_de_agendas
CREATE INDEX idx_servico_de_agendas_nome ON servico_de_agendas (nome);
CREATE INDEX idx_servico_de_agendas_login ON servico_de_agendas (login);

-- Criação da tabela convenios
CREATE TABLE convenios (
    id SERIAL PRIMARY KEY,
    id_medico INTEGER,
    nome VARCHAR(50),
    login VARCHAR(50),
    senha VARCHAR(50),
    FOREIGN KEY (id_medico) REFERENCES medicos(id)
);

-- Índices para tabela convenios
CREATE INDEX idx_convenios_nome ON convenios (nome);
CREATE INDEX idx_convenios_login ON convenios (login);

-- Criação da tabela clientes
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    telefone_whatsApp VARCHAR(25),
    e_mail VARCHAR(50),
    login VARCHAR(50) NOT NULL,
    senha VARCHAR(20) NOT NULL,
    id_convenio INTEGER,
    dataTime_disponivel DATE,
    matricula_no_convenio VARCHAR(50),
    FOREIGN KEY (id_convenio) REFERENCES convenios(id)
);

-- Índices para tabela clientes
CREATE INDEX idx_clientes_nome ON clientes (nome);
CREATE INDEX idx_clientes_login ON clientes (login);

-- Criação da tabela integracao
CREATE TABLE integracao (
    id SERIAL PRIMARY KEY,
    endereco_do_site VARCHAR(255) NOT NULL,
    login VARCHAR(50) NOT NULL,
    senha VARCHAR(20) NOT NULL,
    status BOOLEAN NOT NULL
);

-- Índices para tabela integracao
CREATE INDEX idx_integracao_endereco_do_site ON integracao (endereco_do_site);
CREATE INDEX idx_integracao_login ON integracao (login);

-- Criação da tabela expediente_do_medico_data
CREATE TABLE expediente_do_medico_data (
    id_medico INTEGER NOT NULL,
    data DATE NOT NULL,
    hora_inicial TIMESTAMP NOT NULL,
    hora_final TIMESTAMP NOT NULL,
    FOREIGN KEY (id_medico) REFERENCES medicos(id)
);

-- Índices para tabela expediente_do_medico_data
CREATE INDEX idx_expediente_do_medico_data_data ON expediente_do_medico_data (data);
CREATE INDEX idx_expediente_do_medico_data_hora_inicial ON expediente_do_medico_data (hora_inicial);
CREATE INDEX idx_expediente_do_medico_data_hora_final ON expediente_do_medico_data (hora_final);

-- Criação da tabela agenda
CREATE TABLE agenda (
    id SERIAL PRIMARY KEY,
    id_Medico INTEGER NOT NULL,
    id_Cliente INTEGER NOT NULL,
    dataTime TIMESTAMP NOT NULL,
    dataTime_confirmacao TIMESTAMP NOT NULL,
    id_convenio INTEGER,
    id_status_da_agenda_ou_consulta INTEGER NOT NULL,
    id_formas_de_pagamento INTEGER,
    dataTime_criacao TIMESTAMP NOT NULL,
    observacoes VARCHAR(255),
    FOREIGN KEY (id_Medico) REFERENCES medicos(id),
    FOREIGN KEY (id_Cliente) REFERENCES clientes(id),
    FOREIGN KEY (id_convenio) REFERENCES convenios(id),
    FOREIGN KEY (id_status_da_agenda_ou_consulta) REFERENCES status_da_agenda_ou_consulta(id),
    FOREIGN KEY (id_formas_de_pagamento) REFERENCES formas_de_pagamento(id)
);

-- Índices para tabela agenda
CREATE INDEX idx_agenda_dataTime ON agenda (dataTime);
CREATE INDEX idx_agenda_dataTime_confirmacao ON agenda (dataTime_confirmacao);
CREATE INDEX idx_agenda_dataTime_criacao ON agenda (dataTime_criacao);
CREATE INDEX idx_agenda_observacoes ON agenda (observacoes);

-- Criação da tabela formas_de_pagamento
CREATE TABLE formas_de_pagamento (
    id SERIAL PRIMARY KEY,
    Nome VARCHAR(30) NOT NULL
);

-- Índice para tabela formas_de_pagamento
CREATE INDEX idx_formas_de_pagamento_nome ON formas_de_pagamento (Nome);

-- Criação da tabela consulta
CREATE TABLE consulta (
    id SERIAL PRIMARY KEY,
    id_agenda INTEGER,
    id_cliente INTEGER NOT NULL,
    id_medico INTEGER NOT NULL,
    dataTime TIMESTAMP NOT NULL,
    id_convenio INTEGER,
    id_forma_de_pagamento INTEGER,
    id_status_da_agenda_ou_consulta INTEGER NOT NULL,
    observacao VARCHAR(255),
    FOREIGN KEY (id_agenda) REFERENCES agenda(id),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    FOREIGN KEY (id_medico) REFERENCES medicos(id),
    FOREIGN KEY (id_convenio) REFERENCES convenios(id),
    FOREIGN KEY (id_forma_de_pagamento) REFERENCES formas_de_pagamento(id),
    FOREIGN KEY (id_status_da_agenda_ou_consulta) REFERENCES status_da_agenda_ou_consulta(id)
);

-- Índices para tabela consulta
CREATE INDEX idx_consulta_dataTime ON consulta (dataTime);
CREATE INDEX idx_consulta_observacao ON consulta (observacao);


-- A tabela __dm_xtable__ é usada para testes do modelo de Tb_Table.pas

-- Criação da tabela operadores
CREATE TABLE __dm_xtable__ (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    endereco VARCHAR(50),    
    cnpj VARCHAR(18),  
    cpf VARCHAR(14), 
    cep VARCHAR(10),        
    valor_SMALLINT SMALLINT,
    valor_Integer Integer,
    valor_FLOAT8 DOUBLE PRECISION,
    Data_1 TIMESTAMP, 
    hora_1 TIMESTAMP,    
    hora_2 TIMESTAMP
);
