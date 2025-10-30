<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // ----- Classe simple pour représenter une tâche -----
    class Task {
        String titre;
        String description;
        String date;
        boolean terminee;

        Task(String titre, String description, String date) {
            this.titre = titre;
            this.description = description;
            this.date = date;
            this.terminee = false; // Par défaut, la tâche n'est pas terminée
        }
    }

    // ----- On récupère la liste des tâches depuis la session -----
    ArrayList<Task> taches = (ArrayList<Task>) session.getAttribute("taches");
    if (taches == null) {
        taches = new ArrayList<Task>();
        session.setAttribute("taches", taches);
    }

    // ----- On regarde si une action a été envoyée (ajouter, terminer, supprimer) -----
    String action = request.getParameter("action");

    // ----- Ajouter une nouvelle tâche -----
    if ("ajouter".equals(action)) {
        String titre = request.getParameter("titre");
        String description = request.getParameter("description");
        String date = request.getParameter("date");

        if (titre != null && !titre.isEmpty()) {
            Task nouvelleTache = new Task(titre, description, date);
            taches.add(nouvelleTache);
        }
    }

    // ----- Marquer une tâche comme terminée -----
    if ("terminer".equals(action)) {
        int index = Integer.parseInt(request.getParameter("index"));
        if (index >= 0 && index < taches.size()) {
            taches.get(index).terminee = true;
        }
    }

    // ----- Supprimer une tâche -----
    if ("supprimer".equals(action)) {
        int index = Integer.parseInt(request.getParameter("index"));
        if (index >= 0 && index < taches.size()) {
            taches.remove(index);
        }
    }

    // ----- Vider la liste (supprimer toutes les tâches) -----
    if ("vider".equals(action)) {
        taches.clear();
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Projet_Annick - Mini Gestionnaire de Tâches</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #eef3f7;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #004080;
        }

        form {
            background-color: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 0 5px #aaa;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
        }

        input, textarea {
            width: 100%;
            margin: 5px 0 10px 0;
            padding: 6px;
        }

        input[type="submit"], button {
            background-color: #004080;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
        }

        input[type="submit"]:hover, button:hover {
            background-color: #0066cc;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 8px;
        }

        th {
            background-color: #004080;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .terminee {
            text-decoration: line-through;
            color: gray;
        }

        .center {
            text-align: center;
        }
    </style>
</head>
<body>

    <h1>Projet_Annick - Mini Gestionnaire de Tâches</h1>

    <!-- ===== Formulaire pour ajouter une tâche ===== -->
    <form method="post">
        <input type="hidden" name="action" value="ajouter">

        <label>Titre :</label>
        <input type="text" name="titre" required>

        <label>Description :</label>
        <textarea name="description" rows="3"></textarea>

        <label>Date d’échéance :</label>
        <input type="date" name="date">

        <input type="submit" value="Ajouter la tâche">
    </form>

    <!-- ===== Liste des tâches ===== -->
    <h2>Liste des tâches</h2>

    <form method="post" style="text-align:right; margin-bottom:10px;">
        <input type="hidden" name="action" value="vider">
        <button type="submit" onclick="return confirm('Supprimer toutes les tâches ?')">Vider la liste</button>
    </form>

    <table>
        <tr>
            <th>Titre</th>
            <th>Description</th>
            <th>Date</th>
            <th>État</th>
            <th>Actions</th>
        </tr>

        <% if (taches.isEmpty()) { %>
            <tr><td colspan="5" class="center">Aucune tâche enregistrée</td></tr>
        <% } else {
            for (int i = 0; i < taches.size(); i++) {
                Task t = taches.get(i);
        %>
        <tr>
            <td class="<%= t.terminee ? "terminee" : "" %>"><%= t.titre %></td>
            <td class="<%= t.terminee ? "terminee" : "" %>"><%= t.description %></td>
            <td><%= t.date %></td>
            <td><%= t.terminee ? "Terminée ✅" : "En cours ⏳" %></td>
            <td>
                <% if (!t.terminee) { %>
                    <a href="?action=terminer&index=<%=i%>">Terminer</a>
                <% } %>
                <a href="?action=supprimer&index=<%=i%>" onclick="return confirm('Supprimer cette tâche ?')">Supprimer</a>
            </td>
        </tr>
        <% } } %>
    </table>

</body>
</html>


