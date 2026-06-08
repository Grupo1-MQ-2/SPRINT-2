CREATE DATABASE banco_canalytics;
USE banco_canalytics;

CREATE TABLE assinatura (
id INT PRIMARY KEY AUTO_INCREMENT,
plano VARCHAR(15) NOT NULL,
CONSTRAINT chkPlano CHECK (plano IN('SEMESTRAL', 'TRIMESTRAL', 'ANUAL')),
dt_assinatura DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
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

-- INSERÇÃO DAS TABELAS SENSOR E LOCALSENSOR QUE SERÃO AS ÚNICAS
-- obs: não estão feitas
INSERT INTO sensor (id, fk_canavial, estado, data_instalacao) VALUES
(1, 1, 'ATIVO', '2024-01-10'),
(2, 2, 'INATIVO', '2024-01-10'),
(3, 3, 'MANUTENÇÃO', '2024-02-05');

INSERT INTO localSensor (id, fk_sensor, coordenada) VALUES
(1,  1,  '-23.550520, -46.633308'),
(2,  2,  '-23.551000, -46.634000'),
(3,  3,  '-23.552000, -46.635000'),
(4,  4,  '-23.553000, -46.636000'),
(5,  5,  '-22.910000, -47.060000'),
(6,  6,  '-22.911000, -47.061000'),
(7,  7,  '-22.912000, -47.062000'),
(8,  8,  '-22.913000, -47.063000'),
(9,  9,  '-21.177900, -47.810600'),
(10, 10, '-21.178000, -47.811000'),
(11, 11, '-21.179000, -47.812000'),
(12, 12, '-21.180000, -47.813000'),
(13, 13, '-20.540000, -47.400000'),
(14, 14, '-20.541000, -47.401000'),
(15, 15, '-20.542000, -47.402000'),
(16, 16, '-20.543000, -47.403000');


-- view: resulta no estado de todos os sensores, seus canaviais e loc em coordenadas
CREATE VIEW vw_alertas_ativos AS
SELECT
a.id AS id_alerta, a.data_hora
AS data_hora_alerta,
le.valor_gas AS valor_gas, m.categoria
AS criticidade, s.id AS id_sensor,
s.estado AS estado_sensor,
c.nome AS canavial
FROM alerta a JOIN leitura le
    ON a.fk_leitura = le.id
JOIN metrica m
    ON m.fk_leitura = le.id
JOIN sensor s
    ON le.fk_sensor = s.id
JOIN canavial c
    ON s.fk_canavial = c.id;

-- view: resulta nos sensores que precisam de monitoramento
CREATE VIEW vw_sensores_manutencao AS
SELECT
s.id AS id_sensor,
s.estado AS estado_sensor,
s.data_instalacao, c.nome AS canavial,
ls.coordenada AS localizacao_sensor
FROM sensor s JOIN canavial c
    ON s.fk_canavial = c.id
JOIN localSensor ls
    ON ls.fk_sensor = s.id
WHERE s.estado IN ('INATIVO', 'MANUTENÇÃO');

select * from vw_sensores_manutencao;
select * from vw_alertas_ativos;

-- 1. Tabela : assinatura
INSERT INTO assinatura (plano, dt_assinatura, valor) VALUES 
('ANUAL', '2025-05-10 08:00:00', 24000.00),
('SEMESTRAL', '2025-11-01 09:30:00', 13500.00),
('TRIMESTRAL', '2026-02-15 14:15:00', 7200.00);


-- 2. Tabela: empresa
INSERT INTO empresa (fk_assinatura, razao_social, nome_fantasia, CNPJ, senha, codigo_ativacao) VALUES
(1, 'Agropecuária Vale do Mogi Ltda', 'AgroVale Cana', '45123456000189', 'AgroVale2026!', 'ACT-VALE-9921');


-- 3. Tabela: localizacaoEmpresa
INSERT INTO localizacaoEmpresa (fk_empresa, logradouro, numero, complemento, CEP, cidade, estado) VALUES
(1, 'Rodovia Deputado Rogério de Souza', 450, 'Km 12 - Galpão A', '14000000', 'Ribeirão Preto', 'SP');


-- 4. Tabela: representant
INSERT INTO representante (id, fk_empresa, nome, email, dt_nascimento, senha) VALUES
(1, 1, 'Carlos Eduardo Mendes', 'carlos.mendes@agrovalecana.com.br', '1982-04-14', 'CaduAgro82');


-- 5. Tabela: canavial
INSERT INTO canavial (nome, fk_empresa, coordenada) VALUES
('Talhão Sul - Cana Planta (Variedade CTC4)', 1, '-21.177900, -47.810600');


-- 6. Tabela: sensor
INSERT INTO sensor (fk_canavial, estado, data_instalacao, unidade_medida) VALUES
(1, 'ATIVO', '2025-06-01', 'ppm');


-- 7. Tabela: localSensor
INSERT INTO localSensor (fk_sensor, coordenada) VALUES
(1, '-22.725080, -47.648110');


-- 8. Tabela: leitura
INSERT INTO leitura (fk_sensor, valor_gas, data_hora) VALUES
(1, 380, '2026-06-08 10:00:00'), 
(1, 650, '2026-06-08 10:05:00'), 
(1, 920, '2026-06-08 10:10:00'), 
(1, 385, '2026-06-08 11:00:00');
