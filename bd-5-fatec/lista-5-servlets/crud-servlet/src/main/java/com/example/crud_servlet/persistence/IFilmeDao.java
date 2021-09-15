package com.example.crud_servlet.persistence;

import com.example.crud_servlet.model.Filme;

import java.sql.SQLException;
import java.util.List;

public interface IFilmeDao {

    public String inserirFilme(Filme filme) throws SQLException;
    public String editarFilme(Filme filme) throws SQLException;
    public String excluirFilme(Filme filme) throws SQLException;
    public Filme buscarFilme(Filme filme) throws SQLException;
    public List<Filme> buscarTodosOsFilmes() throws SQLException;

}
