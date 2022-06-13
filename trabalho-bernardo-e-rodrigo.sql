CREATE SCHEMA SPGS;
SET search_path = SPGS;
SET DATEstyle TO "ISO, DMY";

-- cricação das tabelas
CREATE TABLE filial (
	codFilial SERIAL, 
	cidade VARCHAR(255) NOT NULL, 
	dtInauguracao DATE NOT NULL, 
	qtVeiculos INT NOT NULL CHECK(qtVeiculos between 0 and 20),
	PRIMARY KEY (codFilial)
);

CREATE TABLE colaborador(
	cod SERIAL,
	codFilial  INT NOT NULL,
	cpf VARCHAR(30) NOT NULL UNIQUE,
	nome VARCHAR(255) NOT NULL,
	endereco VARCHAR(255) NOT NULL,
	salario DOUBLE PRECISION NOT NULL,
	funcao VARCHAR(255) CHECK(funcao IN('Mecanico', 'Consultor')) NOT NULL,
	dtAdmissao DATE DEFAULT CURRENT_DATE,
	PRIMARY KEY (cod),
	FOREIGN KEY (codFilial) REFERENCES Filial(codFilial)
);

CREATE TABLE servico(
	cod SERIAL,
	descricao VARCHAR(255) NOT NULL,
	valorMaoObra DOUBLE PRECISION NOT NULL,
	PRIMARY KEY (cod)
);

CREATE TABLE colaborador_servico(
	codColaborador INT NOT NULL,
	codServico INT NOT NULL,
	dtInicio DATE NOT NULL,
	dtFim DATE,
	ativo BOOLEAN DEFAULT false,
	PRIMARY KEY (codColaborador, codServico, dtInicio),
	FOREIGN KEY (codColaborador) REFERENCES colaborador(cod),
	FOREIGN KEY(codServico) REFERENCES servico(cod)
);
	
CREATE TABLE cliente(
	cod SERIAL,
	cpf VARCHAR(30) NOT NULL unique,
	nome VARCHAR(255) NOT NULL,
	dtNascimento DATE NOT NULL,
	pagamentoFinalizado BOOLEAN DEFAULT false,
	PRIMARY KEY(cod)
);

CREATE TABLE carro(
	cod SERIAL,
	codCliente INT NOT NULL,
	modelo VARCHAR(255) NOT NULL,
	tipoCombustivel VARCHAR(255) CHECK(tipoCombustivel IN ('Gasolina','Diesel','Gás','Elétrico')),
	PRIMARY KEY (cod),
	FOREIGN KEY (codCliente) REFERENCES cliente(cod)
);

CREATE TABLE pagamento(
	cod SERIAL,
	codNF INT NOT NULL,
	codCliente INT NOT NULL,
	valor DOUBLE PRECISION NOT NULL,
	dtPagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(cod, codNF),
	FOREIGN KEY (codCliente) REFERENCES cliente(cod)
);


CREATE TABLE servico_carro(
	codCarro INT NOT NULL,
	codservico INT NOT NULL,
	dtInicio DATE NOT NULL,
	dtFim DATE, 
	status VARCHAR(255) CHECK(status IN('Pendente','Andamento','Finalizado')) DEFAULT 'Pendente',
	PRIMARY KEY(codCarro, codservico, dtInicio),
	FOREIGN KEY (codCarro) REFERENCES carro(cod),
	FOREIGN KEY (codservico) REFERENCES servico(cod)
);

-- INSERTs nas tabelas, parte A da etapa 03:

-- tabela filial
INSERT INTO filial (cidade, dtInauguracao, qtVeiculos) VALUES ('Porto Alegre', '05/01/2010', 10);
INSERT INTO filial (cidade, dtInauguracao, qtVeiculos) VALUES ('Canoas', '06/05/2019', 5);
INSERT INTO filial (cidade, dtInauguracao, qtVeiculos) VALUES ('São Leopoldo', '20/06/2020', 3);
INSERT INTO filial (cidade, dtInauguracao, qtVeiculos) VALUES ('Sapiranga', '05/06/2021', 7);
INSERT INTO filial (cidade, dtInauguracao, qtVeiculos) VALUES ('Gravataí', '25/02/2018', 13);

-- colaboradores
INSERT INTO colaborador (codFilial, cpf, nome, endereco, salario, funcao, dtAdmissao) 
    VALUES (1, '20217852033', 'Bernardo', 'Centro', 1200, 'Mecanico', '10/06/2022');
INSERT INTO colaborador (codFilial, cpf, nome, endereco, salario, funcao, dtAdmissao) 
    VALUES (2, '90641865023', 'Nicolas', 'Mathias Velho', 2000, 'Consultor', '20/06/2022');
INSERT INTO colaborador (codFilial, cpf, nome, endereco, salario, funcao, dtAdmissao) 
    VALUES (3, '56916504080', 'João', 'Campina', 1300, 'Mecanico', '20/06/2022');
INSERT INTO colaborador (codFilial, cpf, nome, endereco, salario, funcao) 
    VALUES (4, '42295174082', 'Bruno', 'Ouro Branco', 1200, 'Mecanico');
INSERT INTO colaborador (codFilial, cpf, nome, endereco, salario, funcao) 
    VALUES (5, '20217854653', 'Julio', 'Ideal', 1200, 'Mecanico');
INSERT INTO colaborador (codFilial, cpf, nome, endereco, salario, funcao, dtAdmissao) 
    VALUES (3, '51034529013', 'Rodrigo', 'Boa Vista', 2000, 'Consultor', '22/04/2022');
INSERT INTO colaborador (codFilial, cpf, nome, endereco, salario, funcao, dtAdmissao) 
    VALUES (2, '17019095020', 'Pedro', 'Centro', 1300, 'Mecanico', '22/04/2022');
	
-- servico
INSERT INTO servico(descricao, valorMaoObra) VALUES ('Troca de óleo', 200);
INSERT INTO servico(descricao, valorMaoObra) VALUES ('Manutenção de embreagem', 450);
INSERT INTO servico(descricao, valorMaoObra) VALUES ('Revisão do freio', 150);
INSERT INTO servico(descricao, valorMaoObra) VALUES ('Alinhamento', 600);
INSERT INTO servico(descricao, valorMaoObra) VALUES ('Balanceamento', 700);
INSERT INTO servico(descricao, valorMaoObra) VALUES ('Reparo na lataria', 600);
INSERT INTO servico(descricao, valorMaoObra) VALUES ('Troca de óleo, checagem do nível de água', 300);

-- colaborador_servico
INSERT INTO colaborador_servico(codColaborador, codServico, dtInicio) 
	VALUES (2, 1, '25/07/2021');
INSERT INTO colaborador_servico(codColaborador, codServico, dtInicio, ativo) 
	VALUES (1, 2, '20/07/2021', true);
INSERT INTO colaborador_servico(codColaborador, codServico, dtInicio) 
	VALUES (3, 5, '10/08/2022');
INSERT INTO colaborador_servico(codColaborador, codServico, dtInicio, ativo) 
	VALUES (4, 3, '17/09/2022', true);
INSERT INTO colaborador_servico(codColaborador, codServico, dtInicio) 
	VALUES (2, 2, '24/11/2021');
INSERT INTO colaborador_servico(codColaborador, codServico, dtInicio) 
	VALUES (1, 1, '30/10/2021');
INSERT INTO colaborador_servico(codColaborador, codServico, dtInicio) 
	VALUES (3, 4, '28/02/2022');
INSERT INTO colaborador_servico(codColaborador, codServico, dtInicio, dtFim) 
	VALUES (3, 7, '28/02/2022', '10/03/2022');
INSERT INTO colaborador_servico(codColaborador, codServico, dtInicio, ativo) 
	VALUES (3, 6, '28/02/2022', true);

-- cliente
INSERT INTO cliente(cpf, nome, dtNascimento, pagamentoFinalizado)
	VALUES('07621014075', 'Patrick', '03/05/1999', true);
INSERT INTO cliente(cpf, nome, dtNascimento)
	VALUES('96854952034', 'Ivan', '20/05/2002');
INSERT INTO cliente(cpf, nome, dtNascimento, pagamentoFinalizado)
	VALUES('69896025037', 'Matheus K.', '15/05/2000', true);
INSERT INTO cliente(cpf, nome, dtNascimento)
	VALUES('37307443058', 'Luigi', '24/05/2003');
INSERT INTO cliente(cpf, nome, dtNascimento, pagamentoFinalizado)
	VALUES('42850882070', 'Diego', '10/06/2002', true);
	
-- carro
INSERT INTO carro(codCliente, modelo, tipoCombustivel) VALUES (1,'Gol','Gasolina');
INSERT INTO carro(codCliente, modelo, tipoCombustivel) VALUES (2,'Prius','Elétrico');
INSERT INTO carro(codCliente, modelo, tipoCombustivel) VALUES (3,'Palio','Gasolina');
INSERT INTO carro(codCliente, modelo, tipoCombustivel) VALUES (4,'Voyage','Gás');
INSERT INTO carro(codCliente, modelo, tipoCombustivel) VALUES (5,'Toro','Diesel');

-- pagamento
INSERT INTO pagamento (codNF, codCliente, valor) VALUES (124141, 1, 600);
INSERT INTO pagamento (codNF, codCliente, valor) VALUES (124142, 1, 400);
INSERT INTO pagamento (codNF, codCliente, valor) VALUES (124143, 3, 800);
INSERT INTO pagamento (codNF, codCliente, valor) VALUES (124144, 5, 600);
INSERT INTO pagamento (codNF, codCliente, valor) VALUES (124145, 5, 1000);

-- servico_carro
INSERT INTO servico_carro(codCarro, codservico, dtInicio, dtFim, status)
	VALUES(1, 2, '20/07/2021', '25/07/2021', 'Finalizado');
INSERT INTO servico_carro(codCarro, codservico, dtInicio, dtFim, status)
	VALUES(1, 4, '26/07/2021', '30/07/2021', 'Finalizado');
INSERT INTO servico_carro(codCarro, codservico, dtInicio, dtFim, status)
	VALUES(3, 3, '15/09/2022', '05/10/2022', 'Finalizado');
INSERT INTO servico_carro(codCarro, codservico, dtInicio, dtFim, status)
	VALUES(5, 6, '14/02/2022', '16/02/2022', 'Finalizado');
INSERT INTO servico_carro(codCarro, codservico, dtInicio, dtFim, status)
	VALUES(5, 7, '17/02/2022', '21/03/2022', 'Finalizado');
INSERT INTO servico_carro(codCarro, codservico, dtInicio)
	VALUES(2, 1, '27/05/2021');
INSERT INTO servico_carro(codCarro, codservico, dtInicio)
	VALUES(4, 2, '28/05/2021');
	
-- Consultas

-- B: Exibir o nome de todos os colaboradores, assim como suas funções
SELECT nome, funcao
FROM colaborador;

-- C: Exibir o nome dos clientes que realizaram um pagamento, assim como o valor total pago.
SElECT c.nome, SUM(p.valor)
FROM cliente c, pagamento p
WHERE c.cod = p.codCliente
GROUP BY c.nome;

-- D: Exibir o nome dos colaboradores que estão ativos e suas funções
SELECT c.nome, c.funcao
FROM colaborador c INNER JOIN colaborador_servico cs
	ON cs.codColaborador = c.cod
WHERE cS.ativo IS true;

-- E: Exibir o nome dos colaboradores que estão ativos, suas funções, a descrição dos serviçoes que estão sendo feitos, assim como o valor da mão de obra
SELECT c.nome, c.funcao, s.descricao, s.valorMaoObra
FROM colaborador c, colaborador_servico cs, servico s
WHERE ((cs.codColaborador = c.cod) and (cs.codServico = s.cod)) and (cs.ativo IS true);

-- F: Exibir o nome dos colaboradores que estão ativos, suas funções, a descrição dos serviçoes que estão sendo feitos, assim como o valor da mão de obra
SELECT c.nome, c.funcao, s.descricao, s.valorMaoObra
FROM colaborador c INNER JOIN colaborador_servico cs 
	ON c.cod = cs.codColaborador
	INNER JOIN servico s 
	ON s.cod = cs.codServico
WHERE cs.ativo IS true;

-- G: Mostrar a descricao do servico e seu status, o modelo do carro e seu tipo de combustível e o nome do cliente e seu cpf dos serviços pendentes
SELECT s.descricao, sc.status, ca.modelo, ca.tipoCombustivel, cl.nome, cl.cpf
FROM carro ca, cliente cl, servico_carro sc, servico s
WHERE (ca.cod = sc.codCarro) AND (s.cod = sc.codServico) AND (ca.codCliente = cl.cod) AND (sc.status ILIKE 'pendente');

-- H: Exibir o código e nome dos colaboradores que não terminaram um serviço
SELECT DISTINCT c.cod, c.nome
FROM colaborador_servico cs, colaborador c
WHERE (c.cod = cs.codColaborador) AND (cs.dtfim IS NULL);

-- I: Exibir o código e nome dos colaboradores que não terminaram um serviço e comecem com 'B'
SELECT DISTINCT c.cod, c.nome
FROM colaborador_servico cs, colaborador c
WHERE (c.cod = cs.codColaborador) AND (cs.dtfim IS NULL) AND (c.nome like 'B%');

-- J: Exibir o código e nome dos colaboradores que não terminaram um serviço e que tenha 5 letras
SELECT DISTINCT c.cod, c.nome
FROM colaborador_servico cs, colaborador c
WHERE (c.cod = cs.codColaborador) AND (cs.dtfim IS NULL) AND (c.nome like '_____');
