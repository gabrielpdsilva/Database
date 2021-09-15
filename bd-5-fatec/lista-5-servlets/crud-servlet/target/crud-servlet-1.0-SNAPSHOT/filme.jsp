<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Filmes</title>
</head>
<body>
    <h1>CRUD de filmes</h1>
    <form action="filme" method="post">
        <table>
            <tr>
                <td colspan="3">
                    ID
                    <input type="number" id="idFilme" name="idFilme" size="40" value="${filme.idFilme }">
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    Ano lancamento
                    <input type="number" id="anoLancamento" name="anoLancamento" size="40" value="${filme.anoLancamento }">
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    Nome BR
                    <input type="text" id="nomeBr" name="nomeBr" size="40" value="${filme.nomeBr }">
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    Nome EN
                    <input type="text" id="nomeEn" name="nomeEn" size="40" value="${filme.nomeEn }">
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    Sinopse <br/>
                    <textarea style="resize:none" id="sinopse" name="sinopse" value="${filme.sinopse }"></textarea>
                </td>
            </tr>
            <br/>

            <div>
                <c:if test="${not empty listaDeFilmes }">
                    <table border = 1>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nome BR</th>
                                <th>Nome EN</th>
                                <th>Ano lancamento</th>
                                <th>Sinopse</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="filme" items="${listaDeFilmes }">
                                <tr>
                                    <td>${filme.idFilme}</td>
                                    <td>${filme.nomeBr}</td>
                                    <td>${filme.nomeEn}</td>
                                    <td>${filme.anoLancamento}</td>
                                    <td>${filme.sinopse}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>

            <br/>

            <tr>
                <td><input type="submit" value="Buscar" id="btnBuscar" name="button"></td>
                <td><input type="submit" value="Cadastrar" id="btnCadastrar" name="button"></td>
                <td><input type="submit" value="Atualizar" id="btnAtualizar" name="button"></td>
                <td><input type="submit" value="Excluir" id="btnExcluir" name="button"></td>
                <td><input type="submit" value="Listar" id="btnListar" name="button"></td>
            </tr>
        </table>
    </form>
    <div>
        <c:if test="${not empty saida }">
            <p><c:out value="${saida }" /></p>
        </c:if>

        <c:if test="${not empty erro }">
            <h2 style="color: #ff0000"><c:out value="${erro }" /></h2>
        </c:if>
    </div>
</body>
</html>
