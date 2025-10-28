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
 
