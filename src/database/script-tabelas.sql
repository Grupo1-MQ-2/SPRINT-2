CREATE DATABASE bd_canalytics;
  
USE bd_canalytics;

CREATE TABLE cargo (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(45) NOT NULL
);

CREATE TABLE localizacao_empresa (
    id  INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    logradouro VARCHAR(90)NOT NULL,
    numero INT NOT NULL,
    complemento VARCHAR(80),
    CEP CHAR(8) NOT NULL,
    cidade VARCHAR(90) NOT NULL,
    estado CHAR(2)NOT NULL
    
);

CREATE TABLE assinatura (
    id   INT PRIMARY KEY  NOT NULL AUTO_INCREMENT,
    plano  CHAR(10) NOT NULL,
    descricao VARCHAR(100),
    dt_assinatura  DATE NOT NULL,
    dt_vencimento  DATE NOT NULL,
    valor DECIMAL(7,2) NOT NULL
 
);


CREATE TABLE empresa (
    id  INT PRIMARY KEY  NOT NULL AUTO_INCREMENT,
    razao_social  VARCHAR(100) NOT NULL,
    nome_fantasia  VARCHAR(100),
    apelido VARCHAR(45),
    CNPJ CHAR(18) NOT NULL UNIQUE,
    fk_assinatura  INT  NOT NULL,
    fk_localizacaoEmpresa INT NOT NULL,
    CONSTRAINT fk_empresa_assinatura
        FOREIGN KEY (fk_assinatura)
        REFERENCES assinatura (id),
    CONSTRAINT fk_empresa_localizacao
        FOREIGN KEY (fk_localizacaoEmpresa)
        REFERENCES localizacao_Empresa (id)
);


CREATE TABLE funcionario (
    id  INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome  VARCHAR(90) NOT NULL,
    dt_nascimento DATE,
    fk_empresa  INT  NOT NULL,
    fk_cargo   INT  NOT NULL,
   CONSTRAINT fk_funcionario_empresa
        FOREIGN KEY (fk_empresa)
        REFERENCES empresa (id),
    CONSTRAINT fk_funcionario_cargo
        FOREIGN KEY (fk_cargo)
        REFERENCES cargo (id)
);

CREATE TABLE canavial (
    id  INT PRIMARY KEY  NOT NULL AUTO_INCREMENT,
    coordenada  VARCHAR(60),
    fk_empresa  INT NOT NULL,
    CONSTRAINT fk_canavial_empresa
        FOREIGN KEY (fk_empresa)
        REFERENCES empresa (id)
);

CREATE TABLE sensor (
    id   INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    status_sensor  CHAR(11)  NOT NULL,
    data_instalacao  DATE,
    fk_canavial  INT  NOT NULL,
    unidadeMedida    VARCHAR(45),
    CONSTRAINT fk_sensor_canavial
        FOREIGN KEY (fk_canavial)
        REFERENCES canavial (id)
);

CREATE TABLE localsensor (
    id   INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    coordenada  VARCHAR(255),
    fk_sensor   INT  NOT NULL,
    CONSTRAINT fk_localsensor_sensor
        FOREIGN KEY (fk_sensor)
        REFERENCES sensor (id)
);

CREATE TABLE leitura (
    id   INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    fk_sensor   INT  NOT NULL,
    valor_gas   INT,
    data_hora   DATETIME NOT NULL,
    CONSTRAINT fk_leitura_sensor
        FOREIGN KEY (fk_sensor)
        REFERENCES sensor (id)
);

CREATE TABLE metrica (
    id    INT  PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nivel VARCHAR(45) NOT NULL
   
);

CREATE TABLE alerta (
    id   INT PRIMARY KEY  NOT NULL AUTO_INCREMENT,
    descricao       VARCHAR(200),
    nivelDeAlerta   CHAR(7),
    categoria       CHAR(10),
    alerta_fk_leitura INT   NOT NULL,
    alerta_fk_sensor  INT    NOT NULL,
    fk_metrica        INT    NOT NULL,
    CONSTRAINT fk_alerta_leitura
        FOREIGN KEY (alerta_fk_leitura)
        REFERENCES leitura (id),
    CONSTRAINT fk_alerta_sensor
        FOREIGN KEY (alerta_fk_sensor)
        REFERENCES sensor (id),
    CONSTRAINT fk_alerta_metrica
        FOREIGN KEY (fk_metrica)
        REFERENCES metrica (id)
);
