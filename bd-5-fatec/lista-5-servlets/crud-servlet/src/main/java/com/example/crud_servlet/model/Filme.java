package com.example.crud_servlet.model;

public class Filme {

    private int idFilme;
    private String nomeBr;
    private String nomeEn;
    private int anoLancamento;
    private String sinopse;

    public int getIdFilme() {
        return idFilme;
    }

    public void setIdFilme(int idFilme) {
        this.idFilme = idFilme;
    }

    public String getNomeBr() {
        return nomeBr;
    }

    public void setNomeBr(String nomeBr) {
        this.nomeBr = nomeBr;
    }

    public String getNomeEn() {
        return nomeEn;
    }

    public void setNomeEn(String nomeEn) {
        this.nomeEn = nomeEn;
    }

    public int getAnoLancamento() {
        return anoLancamento;
    }

    public void setAnoLancamento(int anoLancamento) {
        this.anoLancamento = anoLancamento;
    }

    public String getSinopse() {
        return sinopse;
    }

    public void setSinopse(String sinopse) {
        this.sinopse = sinopse;
    }

    @Override
    public String toString() {
        return "Filme [id=" + idFilme + ", nome em portugues: " + nomeBr + ", nome em ingles: " + nomeEn + ", ano lancamento: " + anoLancamento + ", sinopse: " + sinopse + "]";
    }
}
