<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.banque.model.Client" %>

<%
String role = (String) session.getAttribute("role");
if(role == null || !role.equals("AGENT")){
    response.sendRedirect("../error/accessDenied.jsp");
    return;
}

List<Client> clients = (List<Client>) request.getAttribute("clients");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Liste des clients</title>
</head>
<body>

<h2>Clients enregistrés</h2>

<table border="1">
    <tr>
        <th>ID Client</th>
        <th>Identifiant original</th>
        <th>Ville</th>
        <th>Code postal</th>
        <th>Revenu mensuel</th>
    </tr>

    <%
    if (clients != null) {
        for(Client c : clients){
    %>
    <tr>
        <td><%= c.getIdClient() %></td>
        <td><%= c.getIdentifiantOriginal() %></td>
        <td><%= c.getVille() %></td>
        <td><%= c.getCodePostal() %></td>
        <td><%= c.getRevenuMensuel() %></td>
    </tr>
    <%
        }
    }
    %>

</table>

<br>
<a href="dashboard.jsp">Retour au tableau de bord</a>

</body>
</html>
