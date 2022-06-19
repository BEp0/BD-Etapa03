CREATE SCHEMA SPGS;
SET search_path = SPGS;
SET DATEstyle TO "ISO, DMY";

-- cricação das tabelas
CREATE TABLE filial (
	cod SERIAL, 
	cidade VARCHAR(255) NOT NULL, 
	dtInauguracao DATE NOT NULL, 
	qtVeiculos INT NOT NULL CHECK(qtVeiculos between 0 and 20),
	PRIMARY KEY (cod)
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
	cpf VARCHAR(30) NOT NULL UNIQUE,
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