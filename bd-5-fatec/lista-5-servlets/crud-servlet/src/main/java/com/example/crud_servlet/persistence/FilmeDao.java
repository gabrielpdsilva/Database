package com.example.crud_servlet.persistence;

import com.example.crud_servlet.model.Filme;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FilmeDao implements IFilmeDao {

    private Connection c;

    public FilmeDao() throws ClassNotFoundException, SQLException {
        GenericDao gDao = new GenericDao();
        c = gDao.getConnection();
    }

    @Override
    public String inserirFilme(Filme filme) throws SQLException {
        String saida = inserirEditarExcluir(filme, "I");
        return saida;
    }

    @Override
    public String editarFilme(Filme filme) throws SQLException {
        String saida = inserirEditarExcluir(filme, "U");
        return saida;
    }

    @Override
    public String excluirFilme(Filme filme) throws SQLException {
        String saida = inserirEditarExcluir(filme, "D");
        return saida;
    }

    @Override
    public Filme buscarFilme(Filme filme) throws SQLException {
        String sql = "SELECT idFilme, nomeBR, nomeEN, anoLancamento, sinopse FROM filme WHERE idFilme = ?";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setInt(1, filme.getIdFilme());
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            filme.setIdFilme(rs.getInt("idFilme"));
            filme.setNomeBr(rs.getString("nomeBR"));
            filme.setNomeEn(rs.getString("nomeEN"));
            filme.setAnoLancamento(rs.getInt("anoLancamento"));
            filme.setSinopse(rs.getString("sinopse"));
        } else {
            filme = new Filme();
        }
        rs.close();
        ps.close();
        return filme;
    }

    @Override
    public List<Filme> buscarTodosOsFilmes() throws SQLException {
        List<Filme> listaDeFilmes = new ArrayList<Filme>();
        StringBuffer sql = new StringBuffer();
        sql.append("SELECT idFilme, nomeBR, nomeEN, anoLancamento, sinopse ");
        sql.append("FROM filme");
        PreparedStatement ps = c.prepareStatement(sql.toString());
        ResultSet rs = ps.executeQuery();
        while(rs.next()) {
            Filme filme = new Filme();
            filme.setIdFilme(rs.getInt("idFilme"));
            filme.setNomeBr(rs.getString("nomeBR"));
            filme.setNomeEn(rs.getString("nomeEN"));
            filme.setAnoLancamento(rs.getInt("anoLancamento"));
            filme.setSinopse(rs.getString("sinopse"));
            listaDeFilmes.add(filme);
        }
        rs.close();
        ps.close();
        return listaDeFilmes;
    }

    private String inserirEditarExcluir(Filme filme, String cod) throws SQLException {
        String sql = "{CALL sp_realizar_alteracao (?,?,?,?,?,?,?)}";
        CallableStatement cs = c.prepareCall(sql);
        cs.setString(1, cod);
        cs.setInt(2, filme.getIdFilme());
        cs.setString(3, filme.getNomeBr());
        cs.setString(4, filme.getNomeEn());
        cs.setInt(5, filme.getAnoLancamento());
        cs.setString(6, filme.getSinopse());
        cs.registerOutParameter(7, Types.VARCHAR);
        cs.execute();
        String saida = cs.getString(7);
        cs.close();
        return saida;
    }
}
