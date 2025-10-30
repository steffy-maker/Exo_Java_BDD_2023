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

    // ===== Réinitialiser toutes les tâches =====
    if ("reset".equals(action)) {
        taches.clear();
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Projet_Annick - Gestionnaire de Tâches</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: linear-gradient(to right, #e0f7fa, #ffffff);
            margin: 0;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #0d47a1;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        form {
            background: #f9fafc;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        label {
            font-weight: bold;
        }

        input[type="text"], input[type="date"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        input[type="submit"], .btn {
            background-color: #0d47a1;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: 0.3s;
        }

        input[type="submit"]:hover, .btn:hover {
            background-color: #1565c0;
        }

        .btn-danger {
            background-color: #d32f2f;
        }

        .btn-danger:hover {
            background-color: #b71c1c;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
            margin-top: 15px;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #0d47a1;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #e3f2fd;
        }

        .terminee {
            text-decoration: line-through;
            color: #888;
        }

        .top-buttons {
            text-align: right;
            margin-bottom: 10px;
        }

        .empty {
            text-align: center;
            color: #666;
            padding: 10px;
        }
    </style>
</head>
<body>

    <h1>Projet_Annick - Mini Gestionnaire de Tâches</h1>

    <div class="container">
        <!-- ===== Formulaire pour ajouter une tâche ===== -->
        <form method="post">
            <input type="hidden" name="action" value="ajouter">
            <label>Titre :</label>
            <input type="text" name="titre" required>

            <label>Description :</label>
            <input type="text" name="description">

            <label>Date d’échéance :</label>
            <input type="date" name="date">

            <input type="submit" value="Ajouter la tâche">
        </form>

        <div class="top-buttons">
            <form method="post" style="display:inline;">
                <input type="hidden" name="action" value="reset">
                <button type="submit" class="btn btn-danger" onclick="return confirm('Supprimer toutes les tâches ?')">Vider toutes les tâches</button>
            </form>
        </div>

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
                <tr><td colspan="5" class="empty">Aucune tâche enregistrée</td></tr>
            <% } else {
                for (int i = 0; i < taches.size(); i++) {
                    Task t = taches.get(i);
            %>
            <tr>
                <td class="<%= t.isTerminee() ? "terminee" : "" %>"><%= t.getTitre() %></td>
                <td class="<%= t.isTerminee() ? "terminee" : "" %>"><%= t.getDescription() %></td>
                <td><%= t.getDate() %></td>
                <td><%= t.isTerminee() ? "Terminée ✅" : "En cours ⏳" %></td>
                <td>
                    <% if (!t.isTerminee()) { %>
                        <a class="btn" href="?action=terminer&index=<%=i%>">Terminer</a>
                    <% } %>
                    <a class="btn btn-danger" href="?action=supprimer&index=<%=i%>" onclick="return confirm('Supprimer cette tâche ?')">Supprimer</a>
                </td>
            </tr>
            <% } } %>
        </table>
    </div>

</body>
</html>
