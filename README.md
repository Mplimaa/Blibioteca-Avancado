### Banco de Dados: Biblioteca (Nível Avançado)

Este projeto define um banco de dados de uma biblioteca com estrutura avançada, incluindo procedures, functions, relacionamentos complexos e integridade referencial.
O objetivo é permitir explorar o uso de procedures, funções, joins, subconsultas, controle de integridade e lógica condicional no SQL Server.

## Relacionamento das Tabelas


## Autores

Contém os autores dos livros. Cada autor pode escrever vários livros.



## Editoras

Representa as editoras responsáveis pela publicação dos livros. Uma editora pode publicar diversos livros.



## Categorias

Classifica os livros por categoria (ex: Romance, Ciência, Autoajuda).



## Livros

Tabela principal com os dados dos livros, incluindo chaves estrangeiras para Editoras e Categorias.



## LivroAutor

Tabela intermediária para resolver o relacionamento muitos-para-muitos entre livros e autores. Um livro pode ter vários autores e um autor pode escrever vários livros.



## Usuarios

Registra os dados dos usuários da biblioteca. São os que realizam os empréstimos.



## Funcionarios

Armazena os funcionários da biblioteca responsáveis pelos empréstimos.



## Emprestimos

Relação entre livros emprestados, usuários e funcionários. Contém data de empréstimo e data de devolução.



## Comandos SQL úteis (DDL, DML, Procedimentos e Funções)

-- Livros com suas editoras e categorias
SELECT L.Titulo, E.Nome AS Editora, C.NomeCategoria
FROM Livros L
JOIN Editoras E ON L.IdEditora = E.IdEditora
JOIN Categorias C ON L.IdCategoria = C.IdCategoria;


-- Autores de um determinado livro
SELECT A.Nome
FROM LivroAutor LA
JOIN Autores A ON LA.IdAutor = A.IdAutor
WHERE LA.IdLivro = 1;


-- Livros ainda não devolvidos
SELECT L.Titulo, U.Nome, E.DataEmprestimo
FROM Emprestimos E
JOIN Livros L ON E.IdLivro = L.IdLivro
JOIN Usuarios U ON E.IdUsuario = U.IdUsuario
WHERE E.DataDevolucao IS NULL;


-- Inserindo novo autor
INSERT INTO Autores (Nome, Nacionalidade)
VALUES ('Paulo Coelho', 'Brasileiro');


-- Inserindo novo livro
INSERT INTO Livros (Titulo, ISBN, AnoPublicacao, IdEditora, IdCategoria)
VALUES ('O Alquimista', '1234567890123', 1988, 1, 2);


-- Associando autor ao livro
INSERT INTO LivroAutor (IdLivro, IdAutor)
VALUES (1, 1);


-- Atualizando categoria de um livro
UPDATE Livros
SET IdCategoria = 3
WHERE IdLivro = 1;


-- Excluindo empréstimo (depois de checar dependências)
DELETE FROM Emprestimos
WHERE IdEmprestimo = 10;


--Procedure: Registrar Novo Empréstimo
CREATE PROCEDURE RegistrarEmprestimo
    @IdLivro INT,
    @IdUsuario INT,
    @IdFuncionario INT
AS
BEGIN
    INSERT INTO Emprestimos (IdLivro, IdUsuario, IdFuncionario, DataEmprestimo)
    VALUES (@IdLivro, @IdUsuario, @IdFuncionario, GETDATE());
END;


--Procedure: Finalizar Empréstimo
CREATE PROCEDURE FinalizarEmprestimo
    @IdEmprestimo INT
AS
BEGIN
    UPDATE Emprestimos
    SET DataDevolucao = GETDATE()
    WHERE IdEmprestimo = @IdEmprestimo;
END;


--Function: Verificar se Livro Está Disponível
CREATE FUNCTION LivroDisponivel(@IdLivro INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Disponivel BIT;

    IF EXISTS (
        SELECT 1 FROM Emprestimos
        WHERE IdLivro = @IdLivro AND DataDevolucao IS NULL
    )
        SET @Disponivel = 0;
    ELSE
        SET @Disponivel = 1;

    RETURN @Disponivel;
END;


--Function: Contar Empréstimos por Usuário
CREATE FUNCTION TotalEmprestimosUsuario(@IdUsuario INT)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;

    SELECT @Total = COUNT(*)
    FROM Emprestimos
    WHERE IdUsuario = @IdUsuario;

    RETURN @Total;
END;


