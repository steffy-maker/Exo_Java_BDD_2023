<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // ===== Classe simple pour représenter une tâche =====
    class Task {
        private String titre;
        private String description;
        private String date;
        private boolean terminee;

        public Task(String titre, String description, String date) {
            this.titre = titre;
            this.description = description;
            this.date = date;
            this.terminee = false;
        }

        public String getTitre() { return titre; }
        public String getDescription() { return description; }
        public String getDate() { return date; }
        public boolean isTerminee() { return terminee; }
        public void setTerminee(boolean t) { terminee = t; }
    }

    // ===== Liste des tâches stockée dans la session =====
    ArrayList<Task> taches = (ArrayList<Task>) session.getAttribute("taches");
    if (taches == null) {
        taches = new ArrayList<>();
        session.setAttribute("taches", taches);
    }

    // ===== Récupération de l'action =====
    String action = request.getParameter("action");

    // ===== Ajouter une tâche =====
    if ("ajouter".equals(action)) {
        String titre = request.getParameter("titre");
        String desc = request.getParameter("description");
        String date = request.getParameter("date");
        if (titre != null && !titre.isEmpty()) {
            taches.add(new Task(titre, desc, date));
        }
    }

    // ===== Supprimer une tâche =====
    if ("supprimer".equals(action)) {
        int index = Integer.parseInt(request.getParameter("index"));
        if (index >= 0 && index < taches.size()) {
            taches.remove(index);
        }
    }

    // ===== Marquer une tâche comme terminée =====
    if ("terminer".equals(action)) {
        int index = Integer.parseInt(request.getParameter("index"));
        if (index >= 0 && index < taches.size()) {
            taches.get(index).setTerminee(true);
        }
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Projet_Annick - Mini Gestionnaire de Tâches</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f7f9fc;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        input, textarea, button {
            width: 100%;
            padding: 6px;
            margin: 4px 0;
            box-sizing: border-box;
        }
        input[type="submit"] {
            background-color: #007BFF;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        a {
            text-decoration: none;
            color: #007BFF;
            margin-right: 8px;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <h1>Projet_Annick - Mini Gestionnaire de Tâches</h1>

    <!-- ===== Formulaire pour ajouter une tâche ===== -->
    <form method="post">
        <input type="hidden" name="action" value="ajouter">
        <p><b>Titre :</b><br><input type="text" name="titre" required></p>
        <p><b>Description :</b><br><input type="text" name="description"></p>
        <p><b>Date d’échéance :</b><br><input type="date" name="date"></p>
        <p><input type="submit" value="Ajouter la tâche"></p>
    </form>

    <!-- ===== Liste des tâches ===== -->
    <h2>Liste des tâches</h2>
    <table>
        <tr>
            <th>Titre</th>
            <th>Description</th>
            <th>Date</th>
            <th>État</th>
            <th>Actions</th>
        </tr>

        <% if (taches.isEmpty()) { %>
            <tr>
                <td colspan="5" style="text-align:center;">Aucune tâche enregistrée</td>
            </tr>
        <% } else {
            for (int i = 0; i < taches.size(); i++) {
                Task t = taches.get(i);
        %>
        <tr>
            <td><%= t.getTitre() %></td>
            <td><%= t.getDescription() %></td>
            <td><%= t.getDate() %></td>
            <td><%= t.isTerminee() ? "Terminée ✅" : "En cours ⏳" %></td>
            <td>
                <% if (!t.isTerminee()) { %>
                    <a href="?action=terminer&index=<%=i%>">Terminer</a>
                <% } %>
                <a href="?action=supprimer&index=<%=i%>">Supprimer</a>
            </td>
        </tr>
        <% } } %>
    </table>

</body>
</html>

