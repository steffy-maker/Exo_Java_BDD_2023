<%@page contentType="text/html" pageEncoding="UTF_8"%>

// Déclaration de la classe 'Task' //
public class Task implements Serializable {

     private String titre;
     private String description;
     private String dateEchéance;
     private boolean terminee;
     private long id;
