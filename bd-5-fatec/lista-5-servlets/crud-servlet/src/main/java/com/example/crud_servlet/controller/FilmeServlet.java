package com.example.crud_servlet.controller;

import com.example.crud_servlet.model.Filme;
import com.example.crud_servlet.persistence.FilmeDao;
import com.example.crud_servlet.persistence.IFilmeDao;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "filme", value = "/filme")
public class FilmeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IFilmeDao fDao;

    public FilmeServlet() {
        try {
            fDao = new FilmeDao();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cmd = request.getParameter("button");
        String saida = "";
        String erro = "";
        List<Filme> listaDeFilmes = new ArrayList<Filme>();
        Filme filme = validaCampos(request, cmd);
        try {
            if (cmd.contains("Cadastrar")) {
                if (filme != null) {
                    saida = fDao.inserirFilme(filme);
                    filme = new Filme();
                }
            }
            if (cmd.contains("Atualizar")) {
                if (filme != null) {
                    saida = fDao.editarFilme(filme);
                    filme = new Filme();
                }
            }
            if (cmd.contains("Excluir")) {
                if (filme != null) {
                    saida = fDao.excluirFilme(filme);
                    filme = new Filme();
                }
            }
            if (cmd.contains("Buscar")) {
                if (filme != null) {
                    filme = fDao.buscarFilme(filme);
                }
            }
            if (cmd.contains("Listar")) {
                listaDeFilmes = fDao.buscarTodosOsFilmes();
            }
        } catch (SQLException e) {
            erro = e.getMessage();
            e.printStackTrace();
        } finally {
            request.setAttribute("saida", saida);
            request.setAttribute("erro", erro);
            request.setAttribute("filme", filme);
            request.setAttribute("listaDeFilmes", listaDeFilmes);
            RequestDispatcher rd = request.getRequestDispatcher("filme.jsp");
            rd.forward(request, response);
        }
    }

    private Filme validaCampos(HttpServletRequest request, String cmd) {
        Filme filme = new Filme();
        if (cmd.contains("Cadastrar") || cmd.contains("Atualizar")) {
            if (!request.getParameter("idFilme").trim().isEmpty() &&
                    !request.getParameter("nomeBr").trim().isEmpty() &&
                    !request.getParameter("nomeEn").trim().isEmpty() &&
                    !request.getParameter("anoLancamento").trim().isEmpty() &&
                    !request.getParameter("sinopse").trim().isEmpty()) {
                filme.setIdFilme(Integer.parseInt(request.getParameter("idFilme").trim()));
                filme.setNomeBr(request.getParameter("nomeBr").trim());
                filme.setNomeEn(request.getParameter("nomeEn").trim());
                filme.setAnoLancamento(Integer.parseInt(request.getParameter("anoLancamento").trim()));
                filme.setSinopse(request.getParameter("sinopse").trim());
            }
        }
        if (cmd.contains("Excluir") || cmd.contains("Buscar")) {
            if (!request.getParameter("idFilme").trim().isEmpty()) {
                filme.setIdFilme(Integer.parseInt(request.getParameter("idFilme").trim()));
            }
        }
        return filme;
    }

}