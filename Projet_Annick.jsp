<%@page contentType="text/html" pageEncoding="UTF_8"%>
<%@page import="java.util.ArrayList, java.util.Iterator, java.io.Serializable"%>
<%!
// Déclaration de la classe 'Task' //
public class Task implements Serializable {

     private String titre;
     private String description;
     private String dateEchéance;
     private boolean terminee;
     private long id; 

// Constructeur 
public Task(String titre, String description, String dateEchéance) {
  this.titre = titre; 
  this.description = description; 
  this.dateEcheance = dateEcheance; 
  this.terminee = false; 
  this.id = system.currentTimeMillis(); 
}
 
public String getTitre(){ return titre;} 
public String getDescription(){ return Description;}
public String getDateEcheance(){ return dateEcheance;}
public String isTerminee(){ return terminee;}
public String getId(){ return id;}


public void setTerminee(boolean terminee) {
   this.terminee = terminee;
}

}

%> 

  if (listeTaches == null) {
        listeTaches = new ArrayList<Task>();
        session.setAttribute("listeTaches", listeTaches);
  }

  if (action != null) {
        
      switch (action) {
      case "ajouter" : 
            String titre = request.getParameter("titre");
                String desc = request.getParameter("description");
                String date = request.getParameter("dateEcheance");
                
                if (titre != null && !titre.isEmpty()) {
                    listeTaches.add(new Task(titre, desc, date));
                    // On ne sauvegarde pas la liste en session ici, 
                    // car 'listeTaches' est une référence à l'objet déjà en session.
                }
                
                // Implémentation du pattern PRG (Post-Redirect-Get)
                // Essentiel pour éviter la re-soumission du formulaire (F5)
                response.sendRedirect("gestionTaches.jsp");
                return; // Arrête l'exécution de la page après la redirection

            /**
             * ACTION : SUPPRIMER
             * [cite_start]Gère la fonctionnalité "Suppression d'une tâche"[cite: 20].
             */
            case "supprimer":
                long idSuppr = Long.parseLong(request.getParameter("id"));
                
                // Utilisation d'un Iterator : obligatoire pour supprimer
                // un élément d'une collection pendant un parcours.
                Iterator<Task> iterator = listeTaches.iterator();
                while (iterator.hasNext()) {
                    if (iterator.next().getId() == idSuppr) {
                        iterator.remove();
                        message = "Tâche supprimée.";
                        break;
                    }
                }
                break;

            /**
             * ACTION : TERMINER
             * [cite_start]Gère la fonctionnalité "Tâche terminée"[cite: 20].
             */
            case "terminer":
                long idTerm = Long.parseLong(request.getParameter("id"));
                for (Task tache : listeTaches) {
                    if (tache.getId() == idTerm) {
                        tache.setTerminee(true);
                        message = "Tâche marquée comme terminée.";
                        break;
                    }
                }
                break;
        }
    }
    
    // Les données (listeTaches) sont maintenant prêtes pour la Vue.
%>


<html>
<head>
    <title>Gestionnaire de Tâches</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        th, td { border: 1px solid #ddd; padding: 10px; }
        th { background-color: #f2f2f2; }
        form { background: #f9f9f9; padding: 15px; border-radius: 5px; }
        .message { color: green; }
        .task-done { text-decoration: line-through; color: #888; }
        .actions a { margin-right: 10px; }
    </style>
</head>
<body>

    <h1>Gestionnaire de Tâches</h1>

    <%-- Affichage du feedback (si défini par le contrôleur) --%>
    <% if (!message.isEmpty()) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <hr>
    
    <h2>Ajouter une tâche</h2>
    <form action="gestionTaches.jsp" method="POST">
        <input type="hidden" name="action" value="ajouter">
        
        <div>
            Titre: <input type="text" name="titre" required>
        </div>
        <div>
            Description: <textarea name="description"></textarea>
        </div>
        <div>
            Date d'échéance: <input type="date" name="dateEcheance">
        </div>
        <input type="submit" value="Ajouter">
    </form>

    <hr>

    <h2>Liste des tâches</h2>
    
    <table>
        <thead>
            <tr>
                <th>Titre</th>
                <th>Description</th>
                <th>Échéance</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            
            [cite_start]<%-- Exigence : L'affichage des tâches utilise une boucle dans une page JSP [cite: 16] --%>
            <% if (listeTaches.isEmpty()) { %>
                <tr>
                    <td colspan="5">Aucune tâche n'est actuellement enregistrée.</td>
                </tr>
            <% } else { %>
                <%-- Boucle 'for-each' sur la liste préparée par le contrôleur --%>
                <% for (Task tache : listeTaches) { %>
                    <tr class="<%= tache.isTerminee() ? "task-done" : "" %>">
                        
                        <%-- Utilisation des getters du Modèle --%>
                        <td><%= tache.getTitre() %></td>
                        <td><%= tache.getDescription() %></td>
                        <td><%= tache.getDateEcheance() %></td>
                        <td><%= tache.isTerminee() ? "Terminée" : "En cours" %></td>
                        
                        <td class="actions">
                            <% if (!tache.isTerminee()) { %>
                                <a href="gestionTaches.jsp?action=terminer&id=<%= tache.getId() %>">Terminer</a>
                            <% } %>
                            <a href="gestionTaches.jsp?action=supprimer&id=<%= tache.getId() %>" onclick="return confirm('Confirmer la suppression ?');">Supprimer</a>
                        </td>
                    </tr>
                <% } // Fin de la boucle %>
            <% } // Fin du else %>
