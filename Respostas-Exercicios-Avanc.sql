--Resposta Exercícios

--Exercicio 1
SELECT 
    L.Titulo,
    A.Nome AS Autor,
    C.NomeCategoria
FROM Emprestimos E
	JOIN Livros L 
		ON E.IdLivro = L.IdLivro
	JOIN LivroAutor LA 
		ON LA.IdLivro = L.IdLivro
	JOIN Autores A 
		ON A.IdAutor = LA.IdAutor
	JOIN Categorias C 
		ON C.IdCategoria = L.IdCategoria
WHERE E.DataDevolucao IS NULL;


--exercicio 2
SELECT 
    F.Nome,
    COUNT(E.IdEmprestimo) AS TotalEmprestimos
FROM Emprestimos E
	JOIN Funcionarios F 
		ON E.IdFuncionario = F.IdFuncionario
GROUP BY F.Nome
ORDER BY TotalEmprestimos DESC;


--exercicio 3
SELECT 
    U.Nome,
    COUNT(E.IdEmprestimo) AS Qtde
FROM Emprestimos E
	JOIN Usuarios U 
		ON U.IdUsuario = E.IdUsuario
GROUP BY U.Nome
HAVING COUNT(E.IdEmprestimo) > 5;


--exercicio 4
SELECT L.Titulo
FROM Livros L
	LEFT JOIN Emprestimos E 
		ON E.IdLivro = L.IdLivro
WHERE E.IdEmprestimo IS NULL;


--exercicio 5
SELECT 
    L.Titulo,
    COUNT(E.IdEmprestimo) AS Qtde
FROM Livros L
	JOIN Emprestimos E 
		ON E.IdLivro = L.IdLivro
GROUP BY L.Titulo
ORDER BY Qtde DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;


--exercicio 6
SELECT 
    E.IdEmprestimo,
    L.Titulo,
    DATEDIFF(DAY, E.DataEmprestimo, E.DataDevolucao) AS Dias
FROM Emprestimos E
	JOIN Livros L 
		ON L.IdLivro = E.IdLivro
WHERE E.DataDevolucao IS NOT NULL
  AND DATEDIFF(DAY, E.DataEmprestimo, E.DataDevolucao) > 15;


  --exercicio 7
  SELECT dbo.LivroDisponivel(5) AS Disponivel;


  --exercicio 8
  EXEC RegistrarEmprestimo @IdLivro = 3, @IdUsuario = 2, @IdFuncionario = 1;


  --exercicio 9
  SELECT 
    E.Nome AS Editora,
    COUNT(L.IdLivro) AS QtdeLivros
FROM Editoras E
	LEFT JOIN Livros L 
		ON E.IdEditora = L.IdEditora
GROUP BY E.Nome;


--exercicio 10
SELECT 
    C.NomeCategoria,
    COUNT(E.IdEmprestimo) AS TotalEmprestimos
FROM Categorias C
	JOIN Livros L 
		ON C.IdCategoria = L.IdCategoria
	JOIN Emprestimos E
		ON E.IdLivro = L.IdLivro
GROUP BY C.NomeCategoria;


--exercicio 11
CREATE PROCEDURE BuscarLivrosPorCategoria
    @Categoria NVARCHAR(100)
AS
BEGIN
    SELECT L.Titulo
    FROM Livros L
		JOIN Categorias C 
			ON L.IdCategoria = C.IdCategoria
    WHERE C.NomeCategoria = @Categoria;
END;


--exercicio 12
CREATE PROCEDURE DevolverLivro
    @IdEmprestimo INT
AS
BEGIN
    UPDATE Emprestimos
    SET DataDevolucao = GETDATE()
    WHERE IdEmprestimo = @IdEmprestimo;
END;


--exercicio 13
CREATE PROCEDURE LivrosPorEditora
    @NomeEditora NVARCHAR(100)
AS
BEGIN
    SELECT L.Titulo
    FROM Livros L
		JOIN Editoras E 
			ON L.IdEditora = E.IdEditora
    WHERE E.Nome = @NomeEditora;
END;


--exercicio 14
CREATE PROCEDURE LivrosAtrasados
AS
BEGIN
    SELECT 
        E.IdEmprestimo,
        U.Nome AS Usuario,
        L.Titulo,
        E.DataEmprestimo
    FROM Emprestimos E
		JOIN Livros L 
			ON E.IdLivro = L.IdLivro
		JOIN Usuarios U 
			ON E.IdUsuario = U.IdUsuario
    WHERE E.DataDevolucao IS NULL 
      AND DATEDIFF(DAY, E.DataEmprestimo, GETDATE()) > 15;
END;


--exercicio 15
CREATE PROCEDURE ResumoEmprestimosUsuario
    @IdUsuario INT
AS
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM Emprestimos WHERE IdUsuario = @IdUsuario) AS TotalEmprestimos,
        (SELECT COUNT(*) FROM Emprestimos 
         WHERE IdUsuario = @IdUsuario AND DataDevolucao IS NULL) AS EmprestimosPendentes;
END;
