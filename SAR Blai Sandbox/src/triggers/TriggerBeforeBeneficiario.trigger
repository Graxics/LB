/** 
* File Name:   TriggerBeforeBeneficiario 
* Description: Trigger que lanza errores si no se cumplen ciertas condiciones al insertar/modificar Relaciones entre contactos
Con tipo de Registro Relacion de beneficiarios
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Date           Author          Modification 
* 06/05/2015    Xavier Garcia     
* =============================================================== 
**/
trigger TriggerBeforeBeneficiario on Relacion_entre_contactos__c (before insert,before update) {
    if(triggerHelper.todofalse() && userInfo.getUserName() != 'wssarq@sarquavitae.es') {
    List<id> Beneficiarios = new List<id>();
    List<id> RelsBenef = new List<id>();
    Map<id,Boolean> ErroresActivo = new Map<id,Boolean>();
    Map<id,Boolean> ErroresUsPrincipal = new Map<id,Boolean>();
    for (Relacion_entre_contactos__c rel:Trigger.new) {
        if (rel.recordtypeid == '012b0000000QIjXAAW') {
            Beneficiarios.add(rel.Beneficiario__c);
            if (Trigger.isUpdate) {
                RelsBenef.add(rel.Id);
            }
        }
    }
    if (Trigger.isInsert) {
        for (Relacion_entre_contactos__c rel:[Select Beneficiario__c,Usuario_principal__c,Activo__c from Relacion_entre_contactos__c where Beneficiario__c IN:Beneficiarios and recordtypeid = '012110000000hjI' and activo__c = true]) {
            if (rel.Usuario_principal__c == true) {
                ErroresUsPrincipal.put(rel.Beneficiario__c, true);
            }
            if (rel.Activo__c == true) {
                ErroresActivo.put(rel.Beneficiario__c, true);
            }      
        }
    }
    if (Trigger.isUpdate) {
        for (Relacion_entre_contactos__c rel:[Select Beneficiario__c,Usuario_principal__c,Activo__c from Relacion_entre_contactos__c where Beneficiario__c IN:Beneficiarios and recordtypeid = '012110000000hjI' and id NOT IN:RelsBenef and activo__c = true]) {
            if (rel.Usuario_principal__c == true) {
                ErroresUsPrincipal.put(rel.Beneficiario__c, true);
            }
            if (rel.Activo__c == true) {
                ErroresActivo.put(rel.Beneficiario__c, true);
            }      
        }
    }
    
    for (Relacion_entre_contactos__c rel:Trigger.new) {
        if (rel.recordtypeid == '012b0000000QIjXAAW') {
            if (rel.Usuario_principal__c == true) {
                if (ErroresUsPrincipal.get(rel.Beneficiario__c) != null) {
                    rel.addError('Este usuario ya está marcado como usuario principal en otra relación de beneficiarios');
                }
            }
            if (rel.Activo__c == true && !rel.pagador__c) {
                if (ErroresActivo.get(rel.Beneficiario__c) != null) {
                    rel.addError('Este usuario ya está activo en otra relación de beneficiarios');
                }
            }
        }
    }
        }
}