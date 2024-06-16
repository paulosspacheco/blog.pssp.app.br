 -- Cria banco de dados acm (Assistente virtual para médicos)
 
CREATE DATABASE avm;

 -- operadores definition

CREATE TABLE IF NOT exists operadores (
    Id serial primary key,
    nome varchar(50) NOT NULL,
    login varchar(50) NOT NULL,
    password varchar(50) NOT NULL,
    telefone varchar(20),
    CONSTRAINT operadores_login_key UNIQUE (login)
    --CONSTRAINT operadores_pkey PRIMARY KEY (id)
);


-- medicos definition

CREATE TABLE IF NOT exists medicos (
    Id serial primary key,
    id_operadores integer NULL,
    nome varchar(50) NULL,
    telefone varchar(25) NULL,
    telefone_da_secretaria varchar(25) NULL,
    login varchar(50) NULL,
    senha varchar(20) NULL
    --CONSTRAINT medicos_pkey PRIMARY KEY (id)
);

-- medicos foreign keys

ALTER TABLE medicos ADD CONSTRAINT medicos_id_operadores_fkey FOREIGN KEY (id_operadores) REFERENCES operadores(id) ON DELETE RESTRICT;


-- convenios definition

CREATE TABLE IF NOT exists convenios (
    Id serial primary key,
    id_medico integer NULL,
    nome varchar(50) not NULL,
    login varchar(50) not NULL,
    senha varchar(50) not NULL
    --CONSTRAINT convenios_pkey PRIMARY KEY (id)
);


-- convenios foreign keys

ALTER TABLE convenios ADD CONSTRAINT convenios_id_medico_fkey FOREIGN KEY (id_medico) REFERENCES medicos(id) ON DELETE RESTRICT;


-- clientes definition

CREATE table IF NOT EXISTS clientes (
    Id serial primary key,
    data_inclusão date not NULL,
    id_convenio integer,                
    matricula_no_convenio varchar(50),        
    nome varchar(50) NOT NULL,
    telefone_whatsapp varchar(25),
    e_mail varchar(50),
    login varchar(50),
    senha varchar(20),                
    CONSTRAINT clientes_login_key UNIQUE (login)
    --CONSTRAINT clientes_pkey PRIMARY KEY (id)
);


-- clientes foreign keys

ALTER TABLE clientes IF NOT exists ADD CONSTRAINT clientes_id_convenio_fkey FOREIGN KEY (id_convenio) REFERENCES convenios(id) ON DELETE RESTRICT;


-- formas_de_pagamento definition

CREATE TABLE IF NOT exists formas_de_pagamento (
    Id serial primary key,
    nome varchar(30) NOT NULL
    --CONSTRAINT formas_de_pagamento_pkey PRIMARY KEY (id)
);


-- status_da_agenda_ou_consulta definition

CREATE TABLE IF NOT exists status_da_agenda_ou_consulta (
    Id serial primary key,
    nome varchar(20) not NULL
    --CONSTRAINT status_da_agenda_ou_consulta_pkey PRIMARY KEY (id)
);


-- expediente_do_medico_data definition

CREATE TABLE IF NOT exists expediente_do_medico_data (
    id_medico integer NOT NULL,
    data_expediente date NOT NULL,
    hora_inicial time NOT NULL,
    hora_final time NOT NULL,        
    CONSTRAINT expediente_do_medico_data_pkey PRIMARY KEY (id_medico,data_expediente, hora_inicial)
);


-- expediente_do_medico_data foreign keys

ALTER TABLE expediente_do_medico_data ADD CONSTRAINT expediente_do_medico_data_id_medico_fkey FOREIGN KEY (id_medico) REFERENCES medicos(id) ON DELETE RESTRICT;



-- agenda definition

CREATE TABLE IF NOT exists agenda (
    Id serial primary key,
    datatime_inclusao timestamp NOT NULL,
    id_medico integer NOT NULL,        
    id_cliente integer NOT NULL,  
    id_convenio integer,
    id_status_da_agenda_ou_consulta integer NOT NULL,
    id_formas_de_pagamento integer not NULL,        
    data_agenda date NOT NULL,
    Hora_agenda time NOT NULL,
    data_confirmacao date,
    hora_confirmacao time,        
    observacoes varchar(255)
    --CONSTRAINT agenda_pkey PRIMARY KEY (id)
);


-- agenda foreign keys

ALTER TABLE agenda ADD CONSTRAINT agenda_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE RESTRICT;
ALTER TABLE agenda ADD CONSTRAINT agenda_id_convenio_fkey FOREIGN KEY (id_convenio) REFERENCES convenios(id) ON DELETE RESTRICT;
ALTER TABLE agenda ADD CONSTRAINT agenda_id_formas_de_pagamento_fkey FOREIGN KEY (id_formas_de_pagamento) REFERENCES formas_de_pagamento(id) ON DELETE RESTRICT;
ALTER TABLE agenda ADD CONSTRAINT agenda_id_medico_fkey FOREIGN KEY (id_medico) REFERENCES medicos(id) ON DELETE RESTRICT;
ALTER TABLE agenda ADD CONSTRAINT agenda_id_status_da_agenda_ou_consulta_fkey FOREIGN KEY (id_status_da_agenda_ou_consulta) REFERENCES status_da_agenda_ou_consulta(id) ON DELETE RESTRICT;


-- consulta definition


CREATE TABLE IF NOT exists consulta (
    Id serial primary key,
    data date NOT NULL,
    hora time NOT NULL,
    id_agenda integer,
    id_cliente integer NOT NULL,
    id_medico integer NOT NULL,        
    id_convenio integer,
    id_forma_de_pagamento integer not NULL,
    id_status_da_agenda_ou_consulta integer NOT NULL,
    observacao varchar(255)
    --CONSTRAINT consulta_pkey PRIMARY KEY (id)
);


-- consulta foreign keys

ALTER TABLE consulta ADD CONSTRAINT consulta_id_agenda_fkey FOREIGN KEY (id_agenda) REFERENCES agenda(id) ON DELETE RESTRICT;
ALTER TABLE consulta ADD CONSTRAINT consulta_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES clientes(id) ON DELETE RESTRICT;
ALTER TABLE consulta ADD CONSTRAINT consulta_id_convenio_fkey FOREIGN KEY (id_convenio) REFERENCES convenios(id) ON DELETE RESTRICT;
ALTER TABLE consulta ADD CONSTRAINT consulta_id_forma_de_pagamento_fkey FOREIGN KEY (id_forma_de_pagamento) REFERENCES formas_de_pagamento(id) ON DELETE RESTRICT;
ALTER TABLE consulta ADD CONSTRAINT consulta_id_medico_fkey FOREIGN KEY (id_medico) REFERENCES medicos(id) ON DELETE RESTRICT;


-- servico_de_agendas definition

CREATE TABLE IF NOT exists servico_de_agendas (
    Id serial primary key,
    id_operador integer not NULL,
    nome varchar(100) not NULL,
    login varchar(50) not NULL,
    senha varchar(50) not NULL
    --CONSTRAINT servico_de_agendas_pkey PRIMARY KEY (id)
);


-- servico_de_agendas foreign keys

ALTER TABLE servico_de_agendas ADD CONSTRAINT servico_de_agendas_id_operador_fkey FOREIGN KEY (id_operador) REFERENCES operadores(id) ON DELETE RESTRICT;


-- hospitais definition

CREATE TABLE IF NOT exists hospitais (
    Id serial primary key,
    nome varchar(50) not NULL,
    telefone varchar(20) not NULL
    --CONSTRAINT hospitais_pkey PRIMARY KEY (id)
);



-- integracao definition

CREATE TABLE IF NOT exists integracao (
    Id serial primary key,
    endereco_do_site varchar(255) NOT NULL,
    login varchar(50) NOT NULL,
    senha varchar(20) NOT NULL,
    status bool NOT NULL
    --CONSTRAINT integracao_pkey PRIMARY KEY (id)
);


-- exemplo_tipos_dados definition

CREATE TABLE IF NOT exists exemplo_tipos_dados (
    Id serial primary key,
    id_produto integer,
    nome_produto varchar(255),
    preco_unitario numeric(10, 2),
    quantidade_estoque int2,
    data_fabricacao date ,
    hora_ultima_venda time,
    data_hora_registro timestamp,
    descricao text ,
    imagem_produto bytea ,
    categoria_produto varchar(50),
    endereco_ip cidr ,
    dados_usuario json ,
    uuid_produto uuid
    --CONSTRAINT exemplo_tipos_dados_pkey PRIMARY KEY (id_produto)
);


-- "__dm_xtable__" definition

CREATE TABLE IF NOT exists __dm_xtable__ (
    id serial NOT NULL,
    nome varchar(50),
    endereco varchar(50),
    cnpj varchar(18),
    cpf varchar(14),
    cep varchar(10),
    valor_smallint int2,
    valor_integer integer,
    valor_float8 float8,
    data_1 date,
    hora_1 time,
    hora_2 time,
    data_2 date
    --CONSTRAINT "__dm_xtable___pkey" PRIMARY KEY (id)
);    
