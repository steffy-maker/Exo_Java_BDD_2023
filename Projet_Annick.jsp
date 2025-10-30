<%-- ====================================================================== --%>
<%-- PAGE JSP UNIQUE : Projet_Annick.jsp --%>
<%-- ====================================================================== --%>

<%-- Imports : On dit à JSP quels "outils" Java on veut utiliser --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%> <%-- Outil pour créer notre "liste" de tâches --%>
<%@page import="java.util.Iterator"%> <%-- Outil nécessaire pour SUPPRIMER un élément d'une liste --%>
<%@page import="java.io.Serializable"%> <%-- Une "bonne pratique" pour les objets qu'on met en session --%>


<%-- ====================================================================== --%>
<%-- SECTION 1 : DÉFINITION DE LA CLASSE TÂCHE (Le "Modèle") --%>
<%-- ====================================================================== --%>
<%!
    /**
     * Crée une classe Java représentant une tâche (Task) 
     * avec des attributs privés.
     * La balise <%! ... %> (avec un "!") permet de déclarer des classes.
     */
    public class Task implements Serializable {

        // --- Attributs Privés ---
        private String titre;
        private String description;
        private String dateEcheance;
        private boolean terminee;
        
        // On ajoute un ID unique pour savoir quelle tâche supprimer ou modifier
        private long id; 

        /**
         * C'est le "constructeur". Il est appelé quand on fait "new Task(...)".
         */
        public Task(String titre, String description, String dateEcheance) {
            this.titre = titre;
            this.description = description;
            this.dateEcheance = dateEcheance;
            this.terminee = false; // Par défaut, une tâche n'est pas terminée
            // On crée un ID simple basé sur l'heure (pour s'assurer qu'il est unique)
            this.id = System.currentTimeMillis();
        }

        // --- Les "Getters" (Accesseurs) ---
        // Méthodes publiques pour LIRE les attributs privés.
        public String getTitre() { return this.titre; }
        public String getDescription() { return this.description; }
        public String getDateEcheance() { return this.dateEcheance; }
        public boolean isTerminee() { return this.terminee; }
        public long getId() { return this.id; }

        // --- Le "Setter" (Mutateur) ---
        // Méthode publique pour MODIFIER un attribut privé
        public void setTerminee(boolean status) {
            this.terminee = status;
        }
    }
%>


<%-- ====================================================================== --%>
<%-- SECTION 2 : LOGIQUE DE LA PAGE (Le "Contrôleur") --%>
<%-- ====================================================================== --%>
<%
    /**
     * Ce bloc de code (<% ... %> SANS "!") s'exécute A CHAQUE FOIS
     * que la page est chargée ou rechargée.
     */

    // 1. GESTION DE LA SESSION
    // Les tâches sont enregistrées dans une liste (ArrayList) stockée en session.
    
    // On essaie de récupérer la liste de tâches de la mémoire de l'utilisateur.
    ArrayList<Task> maListeDeTaches = (ArrayList<Task>) session.getAttribute("listeTaches");

    // Si c'est la première visite (liste = null)
    if (maListeDeTaches == null) {
        // On crée une nouvelle liste vide
        maListeDeTaches = new ArrayList<Task>();
        // Et on la sauvegarde dans la session pour les prochaines visites
        session.setAttribute("listeTaches", maListeDeTaches);
    }

    // 2. GESTION DES ACTIONS (Que veut faire l'utilisateur ?)
    
    // On regarde si l'utilisateur a cliqué sur un bouton ou un lien
    String action = request.getParameter("action");
    String messageUtilisateur = ""; // Pour afficher un message de succès

    if (action != null) {

        // CAS 1: L'utilisateur a rempli le formulaire d'ajout
        if (action.equals("ajouter")) {
            String titreForm = request.getParameter("titre");
            String descForm = request.getParameter("description");
            String dateForm = request.getParameter("dateEcheance");
            
            Task nouvelleTache = new Task(titreForm, descForm, dateForm);
            maListeDeTaches.add(nouvelleTache);
            messageUtilisateur = "Tâche '" + titreForm + "' ajoutée !";
        }

        // CAS 2: L'utilisateur a cliqué sur le lien "Supprimer"
        else if (action.equals("supprimer")) {
            long idTacheASupprimer = Long.parseLong(request.getParameter("id"));
            
            // On utilise un "Iterator" : c'est la seule façon sûre
            // de supprimer un élément d'une liste PENDANT qu'on la parcourt.
            Iterator<Task> iter = maListeDeTaches.iterator();
            while (iter.hasNext()) {
                Task tache = iter.next();
                if (tache.getId() == idTacheASupprimer) {
                    iter.remove();
                    messageUtilisateur = "Tâche supprimée.";
                    break; 
                }
            }
        }

        // CAS 3: L'utilisateur a cliqué sur le lien "Terminer"
        else if (action.equals("terminer")) {
            long idTacheATerminer = Long.parseLong(request.getParameter("id"));
            
            for (Task tache : maListeDeTaches) { 
                if (tache.getId() == idTacheATerminer) {
                    tache.setTerminee(true); 
                    messageUtilisateur = "Tâche marquée comme terminée.";
                    break; 
                }
            }
        }
    }
%>


<%-- ====================================================================== --%>
<%-- SECTION 3 : L'"Affichage" (Code HTML que voit l'utilisateur) --%>
<%-- ====================================================================== --%>
<html>
<head>
    <title>Gestionnaire de Tâches (Projet Annick)</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; }
        h1, h2 { color: #444; }
        form { background: #f4f4f4; padding: 20px; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f0f0f0; }
        .message { color: green; font-weight: bold; }
        .task-done { text-decoration: line-through; color: #999; }
    </style>
</head>
<body>

    <h1>Mon Gestionnaire de Tâches</h1>

    <%-- On affiche le message de succès (s'il n'est pas vide) --%>
    <% if (!messageUtilisateur.isEmpty()) { %>
        <p class="message"><%= messageUtilisateur %></p>
    <% } %>

    <hr>

    <h2>Ajouter une nouvelle tâche</h2>
    
    <form action="Projet_Annick.jsp" method="POST">
        
        <input type="hidden" name="action" value="ajouter">
        
        <div>
            Titre: <br>
            <input type="text" name="titre" required>
        </div>
        <div>
            Description: <br>
            <textarea name="description"></textarea>
        </div>
        <div>
            Date d'échéance: <br>
            <input type="date" name="dateEcheance">
        </div>
        <div>
            <input type="submit" value="Ajouter la tâche">
        </div>
    </form>

    <hr>

    <h2>Liste de mes tâches</h2>

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
            
            <%-- On vérifie d'abord si la liste est vide --%>
            <% if (maListeDeTaches.isEmpty()) { %>
                <tr>
                    <td colspan="5">Aucune tâche pour le moment.</td>
                </tr>
            <% } else { %>
            
                <%-- Boucle "for" pour parcourir 'maListeDeTaches' --%>
                <% for (Task tache : maListeDeTaches) { %>
                
                    <tr <% if (tache.isTerminee()) { out.print("class='task-done'"); } %>>
                        
                        <%-- On utilise <%= ... %> pour AFFICHER les infos --%>
                        <td><%= tache.getTitre() %></td>
                        <td><%= tache.getDescription() %></td>
                        <td><%= tache.getDateEcheance() %></td>
                        <td>
                            <%= tache.isTerminee() ? "Terminée" : "En cours" %>
                        </td>
                        <td>
                            <%-- Le lien "Terminer" s'affiche seulement si la tâche est "En cours" --%>
                            <% if (!tache.isTerminee()) { %>
                                <a href="Projet_Annick.jsp?action=terminer&id=<%= tache.getId() %>">
                                    Terminer
                                </a>
                            <% } %>
                            
                            <a href="Projet_Annick.jsp?action=supprimer&id=<%= tache.getId() %>">
                                Supprimer
                            </a>
                        </td>
                    </tr>
                
                <% } // Fin de la boucle "for" %>
            <% } // Fin du "else" %>
            
        </tbody>
    </table>

</body>
</html>
