CREATE DATABASE banco_canalytics;
USE banco_canalytics;

CREATE TABLE assinatura (
id INT PRIMARY KEY AUTO_INCREMENT,
plano VARCHAR(15) NOT NULL,
CONSTRAINT chkPlano CHECK (plano IN('SEMESTRAL', 'TRIMESTRAL', 'ANUAL')),
descricao VARCHAR(100) NOT NULL,
dt_assinatura DATE NOT NULL,
dt_vencimento DATE NOT NULL,
valor DECIMAL(7,2) NOT NULL
);

CREATE TABLE empresa (
id INT AUTO_INCREMENT,
fk_assinatura INT,
PRIMARY KEY (id, fk_assinatura),
razao_social VARCHAR(100) NOT NULL,
nome_fantasia VARCHAR(100) NOT NULL,
CNPJ CHAR(14) UNIQUE NOT NULL,
senha VARCHAR(20) NOT NULL,
codigo_ativacao VARCHAR(45) NOT NULL,
CONSTRAINT fk_assinatura_empresa FOREIGN KEY (fk_assinatura) REFERENCES assinatura(id)
);

CREATE TABLE localizacaoEmpresa (
id INT PRIMARY KEY AUTO_INCREMENT,
fk_empresa INT,
logradouro VARCHAR(90) NOT NULL,
numero INT NOT NULL,
complemento VARCHAR(80),
CEP CHAR(8) NOT NULL,
cidade VARCHAR(90) NOT NULL,
estado CHAR(2) NOT NULL,
CONSTRAINT fk_empresa_localizacao FOREIGN KEY (fk_empresa) REFERENCES empresa(id)
);

CREATE TABLE representante (
id INT,
fk_empresa INT,
PRIMARY KEY (id, fk_empresa),
nome VARCHAR(90) NOT NULL,
email VARCHAR(45) UNIQUE NOT NULL,
dt_nascimento DATE NOT NULL,
senha VARCHAR(20) NOT NULL,
CONSTRAINT fk_empresa_representante FOREIGN KEY (fk_empresa) REFERENCES empresa(id)
);

CREATE TABLE canavial (
id INT AUTO_INCREMENT,
nome VARCHAR(50) NOT NULL,
fk_empresa INT,
PRIMARY KEY (id, fk_empresa),
coordenada VARCHAR(60) NOT NULL,
CONSTRAINT fk_empresa_canavial FOREIGN KEY (fk_empresa) REFERENCES empresa(id)
); 

CREATE TABLE sensor (
id INT AUTO_INCREMENT,
fk_canavial INT,
PRIMARY KEY (id, fk_canavial),
estado VARCHAR(11) NOT NULL,
CONSTRAINT chkEstado CHECK (estado IN('ATIVO', 'INATIVO', 'MANUTENÇÃO')),
data_instalacao DATE NOT NULL,
unidade_medida VARCHAR(45) NOT NULL,
CONSTRAINT fk_canavial_sensor FOREIGN KEY (fk_canavial) REFERENCES canavial(id)
); 

CREATE TABLE localSensor (
id INT AUTO_INCREMENT,
fk_sensor INT,
PRIMARY KEY (id, fk_sensor),
coordenada VARCHAR(60) NOT NULL,
CONSTRAINT fk_sensor_local FOREIGN KEY (fk_sensor) REFERENCES sensor(id)
); 

CREATE TABLE leitura (
id INT AUTO_INCREMENT,
fk_sensor INT,
PRIMARY KEY (id, fk_sensor),
valor_gas INT NOT NULL,
data_hora DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
CONSTRAINT fk_sensor_leitura FOREIGN KEY (fk_sensor) REFERENCES sensor(id)
);

CREATE TABLE metrica (
id INT AUTO_INCREMENT,
fk_leitura INT,
PRIMARY KEY (id, fk_leitura),
categoria VARCHAR(10) NOT NULL,
CONSTRAINT chkCategoria CHECK(categoria IN('ESTÁVEL','ATENÇÃO', 'CRÍTICO')),
CONSTRAINT fk_leitura_metrica FOREIGN KEY (fk_leitura) REFERENCES leitura(id)
);

CREATE TABLE alerta (
id INT AUTO_INCREMENT,
fk_leitura INT,
PRIMARY KEY (id, fk_leitura),
data_hora DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
CONSTRAINT fk_leitura_alerta FOREIGN KEY (fk_leitura) REFERENCES leitura(id)
);
