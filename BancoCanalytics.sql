CREATE DATABASE banco_canalytics;
USE banco_canalytics;



CREATE TABLE cliente (
id_cliente INT PRIMARY KEY AUTO_INCREMENT,
razao_social VARCHAR(100),
nome_fantasia VARCHAR(100),
apelido VARCHAR(45),
nome_representante VARCHAR(100),
email_representante VARCHAR(255) UNIQUE,
senha_representante VARCHAR(200)
);


CREATE TABLE dispositivo (
id_dispositivo INT PRIMARY KEY AUTO_INCREMENT,
nome_dispositivo VARCHAR (100),
latitude DECIMAL (9,6),
longitude DECIMAL (9,6),
dispositivo_status VARCHAR(20) NOT NULL DEFAULT 'Ativo' CHECK (dispositivo_status IN ('Ativo', 'Em manutenção', 'Inativo')),
data_instalacao DATETIME,
fk_cliente INT,
CONSTRAINT fk_dispositivo_cliente FOREIGN KEY
(fk_cliente) REFERENCES cliente (id_cliente)
); 


CREATE TABLE leitura (
  id_leitura INT PRIMARY KEY AUTO_INCREMENT,
  valor_gas_ppm INT NOT NULL,
  data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
  fk_dispositivo INT,
  CONSTRAINT fk_leitura_dispositivo FOREIGN KEY (fk_dispositivo) 
    REFERENCES dispositivo (id_dispositivo)

); 


SELECT valor_gas_ppm,
CASE
WHEN valor_gas_ppm > 2000 THEN 'Crítico'
WHEN valor_gas_ppm > 1000 THEN 'Risco de incêndio'
ELSE 'Regular' 
END AS 'status de risco'
FROM leitura ;


INSERT INTO cliente (razao_social, nome_fantasia, apelido, nome_representante, email_representante, senha_representante)
VALUES
  ('Usina São João Açúcar e Álcool Ltda', 'Usina São João', 'usinasj', 'Roberto Canavieiro', 'roberto@usinasaojoao.com.br', 'senha123'),
  ('Canavial Norte Agroindústria S.A.', 'Canavial Norte', 'canavialnorte', 'Fernanda Moraes', 'fernanda@canavialnorte.com.br', 'senha456'),
  ('Grupo Cana Verde Ltda', 'Cana Verde', 'canaverde', 'Antônio Ribeiro', 'antonio@canaverde.com.br', 'senha789'),
  ('Agroindústria Santa Cana S.A.', 'Santa Cana', 'santacana', 'Juliana Campos', 'juliana@santacana.com.br', 'senha321'),
  ('Destilaria Cerrado Dourado Ltda', 'Cerrado Dourado', 'cerradodourado', 'Marcos Teixeira', 'marcos@cerradodourado.com.br', 'senha654');
  
  INSERT INTO dispositivo (nome_dispositivo, latitude, longitude, dispositivo_status, data_instalacao, fk_cliente)
VALUES
  ('Sensor Cana-01', -22.123456, -47.654321, 'ativo', '2024-01-15 08:00:00', 1),
  ('Sensor Cana-02', -22.234567, -47.765432, 'ativo', '2024-02-20 09:30:00', 1),
  ('Sensor Cana-03', -21.345678, -48.876543, 'em manutenção', '2024-03-10 10:00:00', 2),
  ('Sensor Cana-04', -21.456789, -48.987654, 'ativo', '2024-04-05 07:45:00', 2),
  ('Sensor Cana-05', -22.567890, -47.098765, 'inativo', '2024-05-12 11:00:00', 3),
  ('Sensor Cana-06', -22.678901, -47.109876, 'ativo', '2024-06-18 08:30:00', 3),
  ('Sensor Cana-07', -21.789012, -48.210987, 'ativo', '2024-07-22 09:00:00', 4),
  ('Sensor Cana-08', -21.890123, -48.321098, 'em manutenção', '2024-08-30 10:15:00', 4),
  ('Sensor Cana-09', -22.901234, -47.432109, 'ativo', '2024-09-14 07:00:00', 5),
  ('Sensor Cana-10', -22.012345, -47.543210, 'ativo', '2024-10-25 08:45:00', 5); 
