<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
<head>
<title>les conditions</title>
</head>
<body bgcolor=white>
<h1>Exercices sur les conditions</h1>
<form action="#" method="post">
    <p>Saisir la valeur 1 : <input type="text" id="inputValeur" name="valeur1">
    <p>Saisir la valeur 2 : <input type="text" id="inputValeur" name="valeur2">
    <p><input type="submit" value="Afficher">
</form>
<%-- Récupération des valeurs --%>
    <% String valeur1 = request.getParameter("valeur1"); %>
    <% String valeur2 = request.getParameter("valeur2"); %>

    <%-- Vérification de la condition entre les deux valeurs --%>
    <% if (valeur1 != null && valeur2 != null) { %>
        <%-- Conversion des valeurs en entiers pour la comparaison --%>
        <% int intValeur1 = Integer.parseInt(valeur1); %>
        <% int intValeur2 = Integer.parseInt(valeur2); %>
        
        <%-- Condition if pour comparer les valeurs --%>
        <% if (intValeur1 > intValeur2) { %>
            <p>Valeur 1 est supérieure à Valeur 2.</p>
        <% } else if (intValeur1 < intValeur2) { %>
            <p>Valeur 1 est inférieure à Valeur 2.</p>
        <% } else { %>
            <p>Valeur 1 est égale à Valeur 2.</p>
        <% } %>
   
    
<h2>Exercice 1 : Comparaison 1</h2>
<p>Ecrire un programme qui demande à l'utilisateur de saisir 3 valeurs (des chiffres),</br>
A, B et C et dites nous si la valeur de C est comprise entre A et B.</br>
Exemple :</br>
A = 10</br>
B = 20</br>
C = 15</br>
Oui C est compris entre A et B</p>

<form action="#" method="post">
    <p>Saisir la valeur A : <input type="text" name="valeur1"></p>
    <p>Saisir la valeur B : <input type="text" name="valeur2"></p>
    <p>Saisir la valeur C : <input type="text" name="valeur3"></p>
    <p><input type="submit" value="Afficher"></p>
</form>

<%-- Récupération des valeurs A, B et C --%>
    <% String valeurA = request.getParameter("valeur1"); %>
    <% String valeurB = request.getParameter("valeur2"); %>
    <% String valeurC = request.getParameter("valeur3"); %> <%-- Nouvelle valeur C --%>

    <%-- Vérification des conditions --%>
    <% 
        // On vérifie que les trois valeurs ont été saisies pour l'Exercice 1
        if (valeurA != null && valeurB != null && valeurC != null && 
            !valeurA.isEmpty() && !valeurB.isEmpty() && !valeurC.isEmpty()) { 
    %>
         
            
              <% -- Conversion des valeurs en entiers pour la comparaison %>
                  <% int intA = Integer.parseInt(valeurA); %>
                  <% int intB = Integer.parseInt(valeurB); %>
                  <% int intC = Integer.parseInt(valeurC); %>

                  <% -- Comparaison A vs B -- %>
               
                <% if (intA > intB) { %>
                    <p>Valeur A est supérieure à Valeur B.</p>
                <% } else if (intA < intB) { %>
                    <p>Valeur A est inférieure à Valeur B.</p>
                <% } else { %>
                    <p>Valeur A est égale à Valeur B.</p>
                <% } %>
                
                <hr>


<h2>Exercice 2 : Pair ou Impair ?</h2>
<p>Écrivez un programme pour vérifier si un nombre est pair ou impair en utilisant une structure if</p>

<% } %>
<p><a href="index.html">Retour au sommaire</a></p>
</body>
</html>
