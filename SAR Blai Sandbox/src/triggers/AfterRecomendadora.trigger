/** 
* File Name:   AfterRecomendadora
* Description:Trigger que cada vez que se modifique una entidad recomendadora enviará campos a sus contactos recomendadores.
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version    Date        Author           Modification 
* 01        10/07/2015  Xavier Garcia
* =============================================================== 
**/ 
trigger AfterRecomendadora on Account (after insert,after update) {
    if(triggerHelper.todofalse() && Label.TriggerRecomenadors != 'No') {
        Map<id,Account> Recomendadoras = new Map<id,Account>();
        for (Account a:Trigger.new) {
            if (a.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Entidad Recomendadora').getRecordTypeId()) {
                if (Trigger.isInsert) {
                    Recomendadoras.put(a.id,a);
                }
                if (Trigger.isUpdate) {
                    Account OldAcc = Trigger.oldMap.get(a.Id);
                    if (oldAcc.Clasificacion_tipo_recomendador__c != a.Clasificacion_tipo_recomendador__c) {
                        Recomendadoras.put(a.id,a);
                    }
                }
            }
        }
        id RecordTypeContacto = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contacto Recomendador').getRecordTypeId();
        List<Account> UpdateContacts = new List<Account>();
        for (Account contacto:[Select id,Clasificacion_tipo_recomendador__c,Empresa_recomendadora__c from Account where Empresa_recomendadora__c IN:Recomendadoras.keySet() and recordtypeid =:RecordTypeContacto ]) {
            if (Recomendadoras.get(contacto.Empresa_recomendadora__c) != null) {
                Account contactUpdate = new Account(id =contacto.id);
                contactUpdate.Clasificacion_tipo_recomendador__c = Recomendadoras.get(contacto.Empresa_recomendadora__c).Clasificacion_tipo_recomendador__c;
                UpdateContacts.add(contactUpdate);
            }
            
        }
        Try {
            update UpdateContacts;
        }
        catch (DMLException e){for (Account account : Trigger.new) {account.addError('Está intentando modificar la Clasificación Tipo Recomendador a una entidad que tiene contactos que les falta algun campo mínimo obligatorio. Verifique primero los contactos relacionados antes de modificar la entidad.');
             }
        }
//update UpdateContacts;
        
    }
    
}