CREATE DATABASE banco_canalytics;
USE banco_canalytics;

CREATE TABLE funcionario (
id_funcionario INT,
fk_empresa INT,
CONSTRAINT fkEmpresaFuncionario PRIMARY KEY(id_funcionario, fk_empresa),
nome VARCHAR(100),
email VARCHAR(255) UNIQUE,
senha VARCHAR(200),
cargo VARCHAR(45)
);

CREATE TABLE empresa (
id_empresa INT PRIMARY KEY AUTO_INCREMENT,
razao_social VARCHAR(100),
nome_fantasia VARCHAR(100),
apelido VARCHAR(45),
CEP CHAR(8),
CNPJ CHAR(18) UNIQUE,
fk_assinatura INT
);
ALTER TABLE empresa ADD CONSTRAINT fk_assinaturaEmpresa FOREIGN KEY (fk_assinatura) REFERENCES assinatura(id_assinatura);

CREATE TABLE assinatura (
id_assinatura INT PRIMARY KEY,
plano VARCHAR(45),
descricao VARCHAR(100),
dt_assinatura DATE,
dt_vencimento DATE,
valor DECIMAL(7,2)
);

CREATE TABLE canavial (
id_canavial INT PRIMARY KEY,
descricao VARCHAR (100),
localizacao VARCHAR(60), 
fk_empresa INT
); 
ALTER TABLE canavial ADD CONSTRAINT fk_empresaCanavial FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa);

CREATE TABLE sensor (
id_sensor INT PRIMARY KEY,
sensor_status CHAR(11),
CONSTRAINT chkStatus CHECK (sensor_status IN('ATIVO', 'INATIVO', 'MANUTENÇÃO')),
data_instalacao DATE,
fk_canavial INT
); 
ALTER TABLE sensor ADD CONSTRAINT fk_sensorCanavial FOREIGN KEY (fk_canavial) REFERENCES canavial(id_canavial);

CREATE TABLE leitura (
  id_leitura INT,
  fk_sensor INT,
  CONSTRAINT fk_leitura_sensor PRIMARY KEY (id_leitura, fk_sensor),
  valor_gas_ppm INT NOT NULL,
  data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
); 


CREATE TABLE localSensor (
  id_localSensor INT,
  fk_sensor INT,
  CONSTRAINT fk_sensor PRIMARY KEY (id_localSensor, fk_sensor),
  coordenada VARCHAR(25)
); 

CREATE TABLE alerta (
  id_alerta INT,
  fk_sensor INT,
  CONSTRAINT fk_sensor PRIMARY KEY (id_alerta, fk_sensor), -- Um alerta DEPENDE de um sensor
  descricao VARCHAR(200),
  nivelDeAlerta CHAR(7),
  CONSTRAINT ckhNivelAlerta CHECK(nivelDeAlerta IN('NORMAL', 'ATENÇÃO', 'CRÍTICO')),
  dtAlerta DATE,
  categoria CHAR(10),
  CONSTRAINT chkCategoria CHECK(categoria IN('LEITURAS','MANUTENÇÃO')),
  fk_idLeitura INT, -- Para saber qual o ID de leitura ele vai exibir no alerta
  CONSTRAINT fk_idLeituraAlerta FOREIGN KEY (fk_idLeitura) REFERENCES leitura(id_leitura),
  fk_idLocalSensor INT, -- Para saber o ID do local do Sensor
  CONSTRAINT fk_idLocalSensorAlerta FOREIGN KEY (fk_idLocalSensor) REFERENCES localSensor(id_localSensor)
); 

-- ASSINATURA
INSERT INTO assinatura (id_assinatura, plano, descricao, dt_assinatura, dt_vencimento, valor) VALUES
(1, 'SEMESTRAL',   'Plano semestral de monitoramento',    '2024-01-01', '2024-06-01', 599.90),
(2, 'ANUAL',  'Plano anual completo com suporte 24h',   '2024-03-01', '2025-03-01', 299.90);

-- EMPRESA
INSERT INTO empresa (id_empresa, razao_social, nome_fantasia, apelido, CEP, CNPJ, fk_assinatura) VALUES
(1, 'AgroTech Ltda', 'AgroTech', 'agro', '13800000', '12.345.678/0001-99', 1),
(2, 'CanaVerde S/A', 'CanaVerde', 'cana', '14900000', '98.765.432/0001-11', 2);

-- FUNCIONARIO
INSERT INTO funcionario (id_funcionario, fk_empresa, nome, email, senha, cargo) VALUES
(1, 1, 'Carlos Silva',    'carlos@agrotech.com',    'senha123', 'Gerente'),
(2, 1, 'Ana Souza',       'ana@agrotech.com',        'senha123', 'Técnico'),
(1, 2, 'Roberto Lima',    'roberto@canaverde.com',   'senha123', 'Gerente'),
(2, 2, 'Fernanda Costa',  'fernanda@canaverde.com',  'senha123', 'Analista');

-- CANAVIAL
INSERT INTO canavial (id_canavial, descricao, localizacao, fk_empresa) VALUES
(1, 'Canavial Norte', 'Zona Rural - Bloco A', 1),
(2, 'Canavial Sul',   'Zona Rural - Bloco B', 1),
(3, 'Canavial Leste', 'Zona Rural - Bloco A', 2),
(4, 'Canavial Oeste', 'Zona Rural - Bloco B', 2);

-- SENSOR
INSERT INTO sensor (id_sensor, sensor_status, data_instalacao, fk_canavial) VALUES
(1,  'ATIVO',      '2024-01-10', 1),
(2,  'INATIVO',    '2024-01-10', 1),
(3,  'ATIVO',      '2024-02-05', 1),
(4,  'MANUTENÇÃO', '2024-02-05', 1),
(5,  'ATIVO',      '2024-03-01', 2),
(6,  'ATIVO',      '2024-03-01', 2),
(7,  'MANUTENÇÃO', '2024-04-10', 2),
(8,  'INATIVO',    '2024-04-10', 2),
(9,  'ATIVO',      '2024-02-20', 3),
(10, 'ATIVO',      '2024-02-20', 3),
(11, 'INATIVO',    '2024-03-15', 3),
(12, 'MANUTENÇÃO', '2024-03-15', 3),
(13, 'ATIVO',      '2024-05-01', 4),
(14, 'ATIVO',      '2024-05-01', 4),
(15, 'MANUTENÇÃO', '2024-06-01', 4),
(16, 'INATIVO',    '2024-06-01', 4);

-- LOCAL SENSOR
INSERT INTO localSensor (id_localSensor, fk_sensor, coordenada) VALUES
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

-- LEITURA
INSERT INTO leitura (id_leitura, fk_sensor, valor_gas_ppm, data_hora) VALUES
(1,  1,  1200, '2024-07-01 08:00:00'),
(2,  2,  14998, '2024-07-01 08:05:00'),
(3,  3,  7688, '2024-07-01 08:10:00'),
(4,  4,  0, '2024-07-01 08:15:00'),
(5,  5,  2000, '2024-07-01 09:00:00'),
(6,  6,  6744, '2024-07-01 09:05:00'),
(7,  7,  0, '2024-07-01 09:10:00'),
(8,  8,  0, '2024-07-01 09:15:00'),
(9,  9,  1500, '2024-07-01 10:00:00'),
(10, 10, 5642, '2024-07-01 10:05:00'),
(11, 11, 12966, '2024-07-01 10:10:00'),
(12, 12, 9950, '2024-07-01 10:15:00'),
(13, 13, 1000, '2024-07-01 11:00:00'),
(14, 14, 5300, '2024-07-01 11:05:00'),
(15, 15, 7400, '2024-07-01 11:10:00'),
(16, 16, 0, '2024-07-01 11:15:00');

-- ALERTA (ppm <= 4999 -> NORMAL | 5000 <=ppm <=9999 -> ATENÇÃO | ppm > 10000 -> CRÍTICO)
INSERT INTO alerta (id_alerta, fk_sensor, descricao, nivelDeAlerta, dtAlerta, categoria, fk_idLeitura, fk_idLocalSensor) VALUES
(1,  1,  'Leitura normal do sensor 1',           'NORMAL',  '2024-07-01', 'LEITURAS',   1,  1),
(2,  2,  'Nível crítico detectado no sensor 2',  'CRÍTICO', '2024-07-01', 'LEITURAS',   2,  2),
(3,  3,  'Nível de atenção no sensor 3',         'ATENÇÃO', '2024-07-01', 'LEITURAS',   3,  3),
(4,  4,  'Sensor em manutenção',                 'CRÍTICO', '2024-07-01', 'MANUTENÇÃO', 4,  4),
(5,  5,  'Leitura normal do sensor 5',           'NORMAL',  '2024-07-01', 'LEITURAS',   5,  5),
(6,  6,  'Nível de atenção no sensor 6',         'ATENÇÃO', '2024-07-01', 'LEITURAS',   6,  6),
(7,  7,  'Sensor aguardando manutenção',         'CRÍTICO', '2024-07-01', 'MANUTENÇÃO', 7,  7),
(8,  8,  'Sensor inativo — verificar',           'CRÍTICO', '2024-07-01', 'MANUTENÇÃO', 8,  8),
(9,  9,  'Leitura normal do sensor 9',           'NORMAL',  '2024-07-01', 'LEITURAS',   9,  9),
(10, 10, 'Nível de atenção no sensor 10',        'ATENÇÃO', '2024-07-01', 'LEITURAS',   10, 10),
(11, 11, 'Nível crítico detectado no sensor 11', 'CRÍTICO', '2024-07-01', 'LEITURAS',   11, 11),
(12, 12, 'Nível de atenção no sensor 12',      'CRÍTICO', '2024-07-01', 'LEITURAS', 12, 12),
(13, 13, 'Leitura normal do sensor 13',          'NORMAL',  '2024-07-01', 'LEITURAS',   13, 13),
(14, 14, 'Nível de atenção no sensor 14',        'ATENÇÃO', '2024-07-01', 'LEITURAS',   14, 14),
(15, 15, 'Nível de atenção no sensor 15',    'CRÍTICO', '2024-07-01', 'LEITURAS',   15, 15),
(16, 16, 'Sensor inativo',       'CRÍTICO', '2024-07-01', 'MANUTENÇÃO', 16, 16);

-- Selecionando informações e planos das empresas clientes
SELECT e.razao_social AS 'Razão Social', 
e.nome_fantasia AS 'Nome Fantasia', 
e.apelido AS 'Apelido', 
e.CEP AS 'CEP', 
e.CNPJ AS 'CNPJ',
a.plano FROM empresa AS e
JOIN assinatura AS a
	ON e.fk_assinatura = a.id_assinatura;
    
-- Empresas e funcionarios cadastrados no sistema
SELECT e.razao_social AS 'Empresa', 
f.nome AS 'Funcionario',
f.email AS 'Email',
f.senha AS 'Senha',
f.cargo AS 'Cargo' FROM empresa AS e
JOIN funcionario AS f 
	ON e.id_empresa = f.fk_empresa;
    
-- Empresas e canaviais da Empresa
SELECT e.razao_social AS 'Empresa', 
c.id_canavial AS 'ID Canavial',
c.descricao AS 'Descrição',
c.localizacao AS 'Localização' FROM empresa AS e
JOIN canavial AS c 
	ON c.fk_empresa = e.id_empresa;


-- Informações dos canavias e sensores da empresa AgroTech
SELECT e.razao_social AS 'Empresa', 
c.id_canavial AS 'ID Canavial',
c.descricao AS 'Descrição',
c.localizacao AS 'Localização',
s.id_sensor AS 'ID sensor',
s.sensor_status AS 'Status sensor',
s.data_instalacao AS 'Data Instalação' FROM empresa AS e 
JOIN canavial AS c 
	ON e.id_empresa = c.fk_empresa
JOIN sensor AS s 
	ON s.fk_canavial = c.id_canavial 
WHERE e.razao_social LIKE '%AgroTech%';

-- Selecionando os sensores, seus respectivos canaviais e seu status
SELECT s.id_sensor AS 'ID Sensor', s.sensor_status AS 'Status Sensor', 
s.fk_canavial AS 'Canavial',
ls.coordenada AS 'Coordenada' FROM sensor AS s
JOIN localSensor AS ls 
	ON s.id_sensor = ls.fk_sensor;
    
-- Selecionando sensor, seu canavial, sua leitura, seu nivel de alerta (do canavial 2)
SELECT s.id_sensor AS 'ID Sensor', 
s.sensor_status AS 'Status Sensor', 
s.fk_canavial AS 'Canavial',
le.valor_gas_ppm AS 'Valor',
le.data_hora AS 'Hora da Captura',
a.nivelDeAlerta AS 'Nivel Alerta' FROM sensor AS s
JOIN leitura AS le 
	ON s.id_sensor = le.fk_sensor
JOIN alerta AS a 
	ON s.id_sensor = a.fk_sensor WHERE s.fk_canavial = 2;

-- Selecionando sensores que estão em manutenção, e seus canaviais
SELECT s.id_sensor AS 'ID Sensor',
c.descricao AS 'Canavial',
c.localizacao AS 'Local',
s.sensor_status AS 'Status Sensor' FROM sensor AS s
JOIN canavial AS c
	ON s.fk_canavial = c.id_canavial
WHERE s.sensor_status = 'MANUTENÇÃO';

-- Verificando ações que devem ser tomadas a partir do nível de gás captado e da integridade física dos sensores. (Simulação de um alerta)
SELECT a.id_alerta AS 'ID alerta',
s.id_sensor AS 'ID sensor',
c.descricao AS 'Canavial',
c.localizacao AS 'Localização',
a.descricao AS 'Desc',
le.data_hora AS 'Data/Hora',
le.valor_gas_ppm AS 'Qtd Gás',
a.nivelDeAlerta AS 'Nivel Alerta',
CASE
    WHEN a.nivelDeAlerta = 'CRÍTICO' THEN 'ATENÇÃO MÁXIMA!!'
    WHEN a.nivelDeAlerta = 'ATENÇÃO' THEN 'VERIFICAR!'
    ELSE 'TUDO CERTO'
    END AS 'STATUS GÁS',
CASE 
	WHEN s.sensor_status = 'MANUTENÇÃO' THEN 'CONSERTO!'
    WHEN s.sensor_status = 'INATIVO' THEN 'ATIVAR!'
    ELSE 'FUNCIONANDO!'
END AS 'Status SENSOR'
FROM alerta AS a 
JOIN sensor AS s 
	ON a.fk_sensor = s.id_sensor
JOIN leitura AS le
	ON le.id_leitura = a.fk_idLeitura
RIGHT JOIN canavial AS c
	ON s.fk_canavial = c.id_canavial
WHERE le.data_hora BETWEEN '2024-07-01 08:00:00' AND '2024-07-01 10:05:00';
