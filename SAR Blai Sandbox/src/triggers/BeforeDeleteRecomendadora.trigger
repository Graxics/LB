/** 
* File Name:   BeforeDeleteRecomendadora 
* Description: Trigger before delete cuenta que controla que no se pueda eliminar una institucion facturable si no eres admin.
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version    Date        Author           Modification 
* 01        02/04/2015  Xavier Garcia
* =============================================================== 
**/ 
trigger BeforeDeleteRecomendadora on Account (before delete,before insert) {
    if(triggerHelper.todofalse()) {
        if (Trigger.isDelete) {
            List<id> InstitucionesFacturables = new List<id>();
            Id userid = UserInfo.getUserId();
            String p = '<br>';
            for (Account a : Trigger.old) {
                if (a.RecordTypeid == '012b0000000QAd7' && a.Institucion_facturable__c == true && userid != '005b0000000kj7H' && userid != '005b0000000kiZe') {
                    a.addError('<font color = red><strong>No se pueden eliminar entidades con las que tenemos acuerdos de facturación.</strong></font>',false);
                }
            } 
        }
        //Cada vez que se inserta un contacto recomenador tenemos que coger la clasificacion de la empresa recomenadora relacionada
        if (Trigger.isInsert) {
            List<id> Recomendadoras = new List<id>();
            Map<id,Account> InfoRecomendadoras = new Map<id,Account>();
            for (Account a:Trigger.new) {
                if (a.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contacto Recomendador').getRecordTypeId()) {
                    Recomendadoras.add(a.Empresa_recomendadora__c);
                    System.debug('Aquino 1');
                }
            }
            for (Account rec:[Select id, Clasificacion_tipo_recomendador__c from Account where id IN:Recomendadoras]) {
                InfoRecomendadoras.put(rec.id,rec);
                System.debug('Aquino 2');
            }
            for (Account a:Trigger.new) {
                if (a.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contacto Recomendador').getRecordTypeId()) {
                    System.debug('Aquino 3');
                    if (InfoRecomendadoras.get(a.Empresa_recomendadora__c) != null) {
                        a.Clasificacion_tipo_recomendador__c = InfoRecomendadoras.get(a.Empresa_recomendadora__c).Clasificacion_tipo_recomendador__c;
                        System.debug('Aquino 4');
                    }
                }
            }
        }
        
    }   
}