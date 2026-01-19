package com.banque.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.JSONObject;

public class FlaskReportService {

    private static final String FLASK_URL = "http://127.0.0.1:5000/report";

    public static JSONObject getReport() {
        JSONObject result = new JSONObject();
        try {
            URL url = new URL(FLASK_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
            StringBuilder sb = new StringBuilder();
            String output;
            while ((output = br.readLine()) != null) {
                sb.append(output);
            }
            conn.disconnect();

            result = new JSONObject(sb.toString());

            // Ajouter les chemins des images pour JSP
            result.put("graphRepartition", "static/graphs/repartition_risques.png");
            result.put("graphEndettement", "static/graphs/distribution_endettement.png");
            result.put("graphEvolution", "static/graphs/evolution_risques.png");
            result.put("graphCorrelation", "static/graphs/correlation_matrix.png");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
