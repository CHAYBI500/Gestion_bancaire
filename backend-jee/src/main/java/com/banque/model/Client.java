package com.banque.model;

import java.sql.Timestamp;

public class Client {

    private int idClient;
    private int identifiantOriginal;
    private String ville;
    private String codePostal;
    private double revenuMensuel;
	public int getIdClient() {
		return idClient;
	}
	public void setIdClient(int idClient) {
		this.idClient = idClient;
	}
	public int getIdentifiantOriginal() {
		return identifiantOriginal;
	}
	public void setIdentifiantOriginal(int identifiantOriginal) {
		this.identifiantOriginal = identifiantOriginal;
	}
	public String getVille() {
		return ville;
	}
	public void setVille(String ville) {
		this.ville = ville;
	}
	public String getCodePostal() {
		return codePostal;
	}
	public void setCodePostal(String codePostal) {
		this.codePostal = codePostal;
	}
	public double getRevenuMensuel() {
		return revenuMensuel;
	}
	public void setRevenuMensuel(double revenuMensuel) {
		this.revenuMensuel = revenuMensuel;
	}
	

}
