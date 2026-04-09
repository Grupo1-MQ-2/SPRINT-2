CREATE DATABASE bancoCanalyticss;
USE bancoCanalyticss;

CREATE TABLE usuarios (
id_usuarios INT PRIMARY KEY AUTO_INCREMENT,
razao_social VARCHAR(100),
nome_fantasia VARCHAR(100),
apelido VARCHAR(45),
nome_representante VARCHAR(100),
email_representante VARCHAR(255) UNIQUE,
senha_representante VARCHAR(200)
);



CREATE TABLE dispositivos (
id_dispositivo INT PRIMARY KEY AUTO_INCREMENT,
nome_dispositivo VARCHAR (100),
latitude DECIMAL (9,6),
longitude DECIMAL (9,6),
dispositivos_status VARCHAR(20) NOT NULL DEFAULT 'ativo' CHECK (dispositivos_status IN ('ativo', 'em manutenção', 'inativo')),
data_instalacao DATETIME,
fk_usuarios INT,
CONSTRAINT fk_dispositivos_usuarios FOREIGN KEY
(fk_usuarios) REFERENCES usuarios (id_usuarios)
); 


CREATE TABLE leitura (
  id_leitura INT PRIMARY KEY AUTO_INCREMENT,
  valor_gas_ppm INT NOT NULL,
  data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
  fk_dispositivos INT,
  status_risco TINYINT AS (
    CASE
      WHEN valor_gas_ppm > 2000 THEN 2
      WHEN valor_gas_ppm > 1000 THEN 1
      ELSE 0
    END ),
  CONSTRAINT fk_leitura_dispositivos FOREIGN KEY (fk_dispositivos) 
    REFERENCES dispositivos (id_dispositivo)
);

CREATE TABLE alerta (
id_alerta INT PRIMARY KEY AUTO_INCREMENT,
nivel_risco VARCHAR(45),
mensagem VARCHAR(255),
datahora_leitura DATETIME,
fk_leitura INT,
CONSTRAINT fk_alerta_leitura FOREIGN KEY
(fk_leitura) REFERENCES leitura (id_leitura) );

INSERT INTO usuarios (razao_social, nome_fantasia, apelido, nome_representante, email_representante, senha_representante)
VALUES
  ('Usina São João Açúcar e Álcool Ltda', 'Usina São João', 'usinasj', 'Roberto Canavieiro', 'roberto@usinasaojoao.com.br', 'senha123'),
  ('Canavial Norte Agroindústria S.A.', 'Canavial Norte', 'canavialnorte', 'Fernanda Moraes', 'fernanda@canavialnorte.com.br', 'senha456'),
  ('Grupo Cana Verde Ltda', 'Cana Verde', 'canaverde', 'Antônio Ribeiro', 'antonio@canaverde.com.br', 'senha789'),
  ('Agroindústria Santa Cana S.A.', 'Santa Cana', 'santacana', 'Juliana Campos', 'juliana@santacana.com.br', 'senha321'),
  ('Destilaria Cerrado Dourado Ltda', 'Cerrado Dourado', 'cerradodourado', 'Marcos Teixeira', 'marcos@cerradodourado.com.br', 'senha654');
  
  INSERT INTO dispositivos (nome_dispositivo, latitude, longitude, dispositivos_status, data_instalacao, fk_usuarios)
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
  
 

