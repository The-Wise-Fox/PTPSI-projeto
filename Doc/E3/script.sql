DROP DATABASE IF EXISTS PTPSI;
CREATE DATABASE PTPSI;
USE PTPSI;

-- ============================================ Create Tabelas ============================================

CREATE TABLE utilizador (
    id_util  INT AUTO_INCREMENT PRIMARY KEY,
    nome     VARCHAR(255) NOT NULL,
    email    VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    perfil   ENUM('admin','gestor','cliente') NOT NULL DEFAULT 'cliente',
    ativo    TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    id_util    INT NOT NULL,
    nome       VARCHAR(150) NOT NULL,
    detalhe    TEXT,
    valor      DECIMAL(8,2) NOT NULL DEFAULT 0.00,

    CONSTRAINT fk_servico_util
        FOREIGN KEY (id_util) REFERENCES utilizador(id_util)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE tipolocal (
    id_tipolocal INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(100) NOT NULL
);

CREATE TABLE tipocontrato (
    id_tipocontrato INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL
);

CREATE TABLE local (
    id_local        INT AUTO_INCREMENT PRIMARY KEY,
    id_util         INT NOT NULL,
    id_tipolocal    INT NOT NULL,
    id_tipocontrato INT NOT NULL,
    morada          VARCHAR(255) NOT NULL,
    codigopostal    VARCHAR(20),
    telemovel       VARCHAR(20),
    email           VARCHAR(150),
    estado          INT DEFAULT 0,

    CONSTRAINT fk_local_util
        FOREIGN KEY (id_util) REFERENCES utilizador(id_util)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_local_tipolocal
        FOREIGN KEY (id_tipolocal) REFERENCES tipolocal(id_tipolocal),
    CONSTRAINT fk_local_tipocontrato
        FOREIGN KEY (id_tipocontrato) REFERENCES tipocontrato(id_tipocontrato),

    -- unicidade por utilizador (não global)
    UNIQUE KEY uk_local_util_email (id_util, email)
);

CREATE TABLE agenda (
    id_agenda    INT AUTO_INCREMENT PRIMARY KEY,
    id_util  	 INT  NOT NULL,
    id_local     INT  NOT NULL,
    data         DATE NOT NULL,

    CONSTRAINT fk_agenda_local
        FOREIGN KEY (id_local)   REFERENCES local(id_local)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_agenda_util
        FOREIGN KEY (id_util) REFERENCES utilizador(id_util)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE agenda_servico (
    id_agenda_servico INT AUTO_INCREMENT PRIMARY KEY,
    id_agenda    INT  NOT NULL,
    id_servico   INT  NOT NULL,
    hora_inicio  TIME NOT NULL,
    hora_fim     TIME NOT NULL,

    CONSTRAINT fk_ds_agenda  FOREIGN KEY (id_agenda)  REFERENCES agenda(id_agenda)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ds_servico FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
        ON UPDATE CASCADE ON DELETE RESTRICT
);




-- ============================================ Insert Dados ============================================

-- ============================================
-- UTILIZADORES     (as passwords sao de teste quando for o backend ficam criptadas)
-- ============================================

INSERT INTO utilizador (nome, email, password, perfil, ativo) VALUES
('Ana Silva',        'ana.silva@ptpsi.pt',        'pass_ana123',  'cliente', 1),
('Bruno Costa',      'bruno.costa@ptpsi.pt',      'pass_bruno12', 'cliente', 1),
('Carla Mendes',     'carla.mendes@ptpsi.pt',     'pass_carla12', 'gestor',  1),
('Diogo Ferreira',   'diogo.ferreira@ptpsi.pt',   'pass_diogo12', 'cliente', 1),
('Eva Rodrigues',    'eva.rodrigues@ptpsi.pt',    'pass_eva1234', 'admin',   1);

-- ============================================
-- SERVIÇOS
-- ============================================

INSERT INTO servico (id_util, nome, detalhe, valor) VALUES
(1, 'Limpeza Geral',         'Limpeza completa do espaço',                       75.00),
(1, 'Limpeza Profunda',      'Limpeza detalhada com desinfeção',                150.00),
(3, 'Manutenção Elétrica',   'Verificação e reparação de instalações elétricas', 120.50),
(3, 'Manutenção AVAC',       'Revisão de ar condicionado e ventilação',          200.00),
(2, 'Jardinagem',            'Corte de relva e manutenção de jardim',             60.00),
(4, 'Pintura',               'Pintura de interiores',                            300.00),
(5, 'Reparação Canalização', 'Deteção e reparação de fugas',                     110.00);


-- ============================================
-- TIPOS DE LOCAL
-- ============================================

INSERT INTO tipolocal (nome) VALUES
('Apartamento'),
('Moradia'),
('Escritório'),
('Loja'),
('Armazém');

-- ============================================
-- TIPOS DE CONTRATO
-- ============================================

INSERT INTO tipocontrato (nome) VALUES
('Mensal'),
('Trimestral'),
('Semestral'),
('Anual'),
('Pontual');

-- ============================================
-- LOCAIS
-- ============================================

INSERT INTO local (id_util, id_tipolocal, id_tipocontrato, morada, codigopostal, telemovel, email, estado) VALUES
(1, 1, 1, 'Rua das Flores 12, 2º Esq', '4000-123', '912345678', 'apt.flores@ptpsi.pt',          1),
(1, 1, 1, 'Rua do Almada 220, 1º',     '4050-032', '917890123', 'apt.almada@ptpsi.pt',          1),
(2, 2, 4, 'Av. da Boavista 456',       '4100-111', '913456789', 'moradia.boavista@ptpsi.pt',    1),
(3, 3, 2, 'Praça do Comércio 1, 3º',   '1100-148', '914567890', 'escritorio.comercio@ptpsi.pt', 1),
(4, 4, 5, 'Rua de Santa Catarina 88',  '4000-447', '915678901', 'loja.sc@ptpsi.pt',             0),
(5, 5, 3, 'Zona Industrial Lote 7',    '4475-123', '916789012', 'armazem.zi@ptpsi.pt',          1);

-- ============================================
-- AGENDAS
-- ============================================

INSERT INTO agenda (id_util, id_local, data) VALUES
(1, 1, '2026-11-10'),
(1, 2, '2026-11-11'),
(2, 3, '2026-11-12'),
(3, 4, '2026-11-13'),
(4, 5, '2026-11-14'),
(5, 6, '2026-11-15');

-- ============================================
-- AGENDA_SERVICO
-- ============================================

INSERT INTO agenda_servico (id_agenda, id_servico, hora_inicio, hora_fim) VALUES
(1, 1, '09:00:00', '11:00:00'),
(1, 2, '11:30:00', '12:30:00'),
(2, 1, '14:00:00', '17:00:00'),
(3, 5, '08:30:00', '10:30:00'),
(4, 3, '15:00:00', '18:00:00'),
(4, 4, '09:00:00', '11:00:00'),
(5, 6, '10:00:00', '12:00:00'),
(6, 7, '09:00:00', '11:00:00');


-- ============================================ Views ============================================

-- ============================================
-- 1. Utilizadores + nº de agendas
-- ============================================
CREATE VIEW v_utilizadores_resumo AS
SELECT
    u.id_util,
    u.nome,
    u.email,
    u.perfil,
    u.ativo,
    COUNT(a.id_agenda) AS total_agendas
FROM utilizador u
LEFT JOIN agenda a ON a.id_util = u.id_util
GROUP BY u.id_util, u.nome, u.email, u.perfil, u.ativo;

-- ============================================
-- 2. Locais com tipo e contrato legíveis
--    (expõe id_util para filtragem pelo backend)
-- ============================================
CREATE VIEW v_locais_detalhado AS
SELECT
    l.id_local,
    l.id_util,
    l.morada,
    l.codigopostal,
    tl.nome AS tipo_local,
    tc.nome AS tipo_contrato,
    l.telemovel,
    l.email,
    CASE l.estado
        WHEN 1 THEN 'Ativo'
        ELSE 'Inativo'
    END AS estado
FROM local l
JOIN tipolocal tl    ON tl.id_tipolocal    = l.id_tipolocal
JOIN tipocontrato tc ON tc.id_tipocontrato = l.id_tipocontrato;

-- ============================================
-- 3. Catálogo de serviços
--    (expõe id_util porque agora é privado)
-- ============================================
CREATE VIEW v_servicos AS
SELECT
    s.id_servico,
    s.id_util,
    s.nome,
    s.detalhe,
    s.valor,
    CONCAT(s.valor, ' €') AS valor_formatado
FROM servico s;

-- ============================================
-- 4. Agenda completa (cabeçalho)
--    (já tinha id_util? não → acrescentado)
-- ============================================
CREATE VIEW v_agenda_completa AS
SELECT
    a.id_agenda,
    a.id_util,
    a.data,
    u.nome  AS utilizador,
    u.email AS email_utilizador,
    l.id_local,
    l.morada,
    l.codigopostal,
    tl.nome AS tipo_local,
    tc.nome AS tipo_contrato
FROM agenda a
JOIN utilizador u    ON u.id_util          = a.id_util
JOIN local l         ON l.id_local         = a.id_local
JOIN tipolocal tl    ON tl.id_tipolocal    = l.id_tipolocal
JOIN tipocontrato tc ON tc.id_tipocontrato = l.id_tipocontrato;

-- ============================================
-- 5. Detalhe dos serviços por agenda
-- ============================================
CREATE VIEW v_agenda_servicos_detalhe AS
SELECT
    ags.id_agenda_servico,
    ags.id_agenda,
    a.id_util,
    a.data,
    u.nome   AS utilizador,
    l.morada AS local,
    s.id_servico,
    s.nome   AS servico,
    s.valor,
    ags.hora_inicio,
    ags.hora_fim,
    TIMEDIFF(ags.hora_fim, ags.hora_inicio) AS duracao
FROM agenda_servico ags
JOIN agenda a      ON a.id_agenda  = ags.id_agenda
JOIN utilizador u  ON u.id_util    = a.id_util
JOIN local l       ON l.id_local   = a.id_local
JOIN servico s     ON s.id_servico = ags.id_servico;

-- ============================================
-- 6. Total a pagar por agenda
-- ============================================
CREATE VIEW v_agenda_total AS
SELECT
    a.id_agenda,
    a.id_util,
    a.data,
    u.nome   AS utilizador,
    l.morada AS local,
    COUNT(ags.id_agenda_servico) AS num_servicos,
    COALESCE(SUM(s.valor), 0.00) AS total_valor
FROM agenda a
JOIN utilizador u            ON u.id_util     = a.id_util
JOIN local l                 ON l.id_local    = a.id_local
LEFT JOIN agenda_servico ags ON ags.id_agenda = a.id_agenda
LEFT JOIN servico s          ON s.id_servico  = ags.id_servico
GROUP BY a.id_agenda, a.id_util, a.data, u.nome, l.morada;

-- ============================================
-- 7. Serviços mais requisitados
--    (id_util exposto para filtrar por dono)
-- ============================================
CREATE VIEW v_servicos_mais_usados AS
SELECT
    s.id_servico,
    s.id_util,
    s.nome,
    s.valor,
    COUNT(ags.id_agenda_servico) AS vezes_usado
FROM servico s
LEFT JOIN agenda_servico ags ON ags.id_servico = s.id_servico
GROUP BY s.id_servico, s.id_util, s.nome, s.valor;

-- ============================================
-- 8. Ocupação por local
--    (id_util exposto para filtrar por dono)
-- ============================================
CREATE VIEW v_ocupacao_local AS
SELECT
    l.id_local,
    l.id_util,
    l.morada,
    COUNT(DISTINCT a.id_agenda)   AS num_agendas,
    COUNT(ags.id_agenda_servico)  AS num_servicos,
    COALESCE(SUM(TIME_TO_SEC(TIMEDIFF(ags.hora_fim, ags.hora_inicio)) / 3600), 0) AS horas_totais
FROM local l
LEFT JOIN agenda a           ON a.id_local    = l.id_local
LEFT JOIN agenda_servico ags ON ags.id_agenda = a.id_agenda
GROUP BY l.id_local, l.id_util, l.morada;

-- ============================================ Selects ============================================

SELECT * FROM v_utilizadores_resumo;
SELECT * FROM v_locais_detalhado;
SELECT * FROM v_servicos;
SELECT * FROM v_agenda_completa;
SELECT * FROM v_agenda_servicos_detalhe;
SELECT * FROM v_agenda_total;
SELECT * FROM v_servicos_mais_usados;
SELECT * FROM v_ocupacao_local;
