
-- Banco de Dados: Biblioteca (Avançado)

CREATE DATABASE Blibioteca_Avancado

CREATE TABLE Autores (
    IdAutor INT PRIMARY KEY IDENTITY,
    Nome VARCHAR(100),
    Nacionalidade VARCHAR(50)
);

CREATE TABLE Editoras (
    IdEditora INT PRIMARY KEY IDENTITY,
    Nome VARCHAR(100),
    Pais VARCHAR(50)
);

CREATE TABLE Categorias (
    IdCategoria INT PRIMARY KEY IDENTITY,
    NomeCategoria VARCHAR(50)
);

CREATE TABLE Livros (
    IdLivro INT PRIMARY KEY IDENTITY,
    Titulo VARCHAR(200),
    ISBN VARCHAR(13),
    AnoPublicacao INT,
    IdEditora INT,
    IdCategoria INT,
    FOREIGN KEY (IdEditora) REFERENCES Editoras(IdEditora),
    FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria)
);

CREATE TABLE LivroAutor (
    IdLivro INT,
    IdAutor INT,
    PRIMARY KEY (IdLivro, IdAutor),
    FOREIGN KEY (IdLivro) REFERENCES Livros(IdLivro),
    FOREIGN KEY (IdAutor) REFERENCES Autores(IdAutor)
);

CREATE TABLE Usuarios (
    IdUsuario INT PRIMARY KEY IDENTITY,
    Nome VARCHAR(100),
    Email VARCHAR(100),
    DataCadastro DATE DEFAULT GETDATE()
);

CREATE TABLE Funcionarios (
    IdFuncionario INT PRIMARY KEY IDENTITY,
    Nome VARCHAR(100),
    Cargo VARCHAR(50)
);

CREATE TABLE Emprestimos (
    IdEmprestimo INT PRIMARY KEY IDENTITY,
    IdLivro INT,
    IdUsuario INT,
    IdFuncionario INT,
    DataEmprestimo DATETIME DEFAULT GETDATE(),
    DataDevolucao DATETIME NULL,
    FOREIGN KEY (IdLivro) REFERENCES Livros(IdLivro),
    FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario),
    FOREIGN KEY (IdFuncionario) REFERENCES Funcionarios(IdFuncionario)
);

-- Procedures

GO
CREATE PROCEDURE RegistrarEmprestimo
    @IdLivro INT,
    @IdUsuario INT,
    @IdFuncionario INT
AS
BEGIN
    INSERT INTO Emprestimos (IdLivro, IdUsuario, IdFuncionario, DataEmprestimo)
    VALUES (@IdLivro, @IdUsuario, @IdFuncionario, GETDATE());
END;

GO
CREATE PROCEDURE FinalizarEmprestimo
    @IdEmprestimo INT
AS
BEGIN
    UPDATE Emprestimos
    SET DataDevolucao = GETDATE()
    WHERE IdEmprestimo = @IdEmprestimo;
END;

-- Funções

GO
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

GO
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
