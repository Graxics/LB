public with sharing class ControladorTareas {
    Account Central {get; set;}
    String Centralname {get; set;}
    public ControladorTareas(ApexPages.StandardController controller) {
        Central = [select name from Account limit 1];
        Centralname = Central.Name;
    }
}