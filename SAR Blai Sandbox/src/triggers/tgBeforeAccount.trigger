/** 
* File Name:   tgBeforeAccount 
* Description: Controla que el DNI no exista ya
* Copyright:   Konozca 
* @author:     Sergi Aguilar
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 
* =============================================================== 
**/ 
trigger tgBeforeAccount on Account (before insert, before update) {
    if(Label.Activacion_de_validacion_de_dni != 'No' && Trigger.new.Size() == 1) {
        //cogemos las cuentas que se repiten con los dnis actuales
        String idn = Trigger.new[0].CIF_NIF__c;
        if(idn != null) {
            integer dnisRep = [SELECT Id, CIF_NIF__c FROM Account WHERE CIF_NIF__c <> Null and CIF_NIF__c = :idn].Size();
            if(dnisRep > 0) Trigger.new[0].addError('El CIF/NIF ya existe');
        }
    }
}