/** 
* File Name:   tgNuevaRelacionRecomendador 
* Description: Relaciona el contacto con la ultima empresa recomendadora asignados a las oportunidades
* Copyright:   Konozca 
* @author:     Sergi Aguilar
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 
* =============================================================== 
**/ 
trigger tgNuevaRelacionRecomendador on Relacion_entre_contactos__c (after insert, after update) {
    if(Label.Activacion_de_la_integracion != 'No' && triggerhelper.todofalse()) {
        List<id>OportunidadesUpdate = new List<id>();
        List<Id> resId = new List<Id> ();
        for(Relacion_entre_contactos__c rc: trigger.new) {
            resId.add(rc.Residente__c);
        }
        List<Account> residentes = [Select Id, IdGCR__c From Account Where Residente__c = true and RecordTypeId = '012b0000000QAe0AAG' and Id IN :resId];
        
        //cogemos los contactos recomendadores
        List<Account> conRec = [Select Id, Empresa_recomendadora__c From Account Where RecordTypeId = '012b0000000QCbtAAG'];
        //contactos a updatear
        List<Relacion_entre_contactos__c> toUpd = new List<Relacion_entre_contactos__c>();
        for(Relacion_entre_contactos__c rc: trigger.new) {
            if (Trigger.isInsert && rc.recordtypeid == '012b0000000QIjXAAW' && rc.Historico__c == false) {
        		CalloutT24WebService.insertar_beneficiario(rc.id);
    		}
            if (rc.recordtypeid == '012b0000000QIjXAAW') {
                OportunidadesUpdate.add(rc.Oportunidad__c);
            }
            
            
            //si es un contacto nuevo de un cliente ya en GCR se actualiza
            if (rc.RecordTypeId == '012b0000000QCbyAAG') {
                boolean enc = false;
                for(integer i = 0; i < residentes.Size() && !enc;++i) {
                    if(residentes[i].Id == rc.Residente__c) {
                        enc = true;
                        system.debug('rc.Ultima_Mod__c: ' + rc.Ultima_Mod__c);
                        if(rc.Ultima_Mod__c != 'fromGCR' && rc.Ultima_Mod__c != 'fromNAV' && rc.Control_duplicados_1__c == null) {
                            if(residentes[i].IdGCR__c != null) GCRCalloutClass.modifyContact(rc.Residente__c, rc.Contacto__c);
                            Relacion_entre_contactos__c aux = new Relacion_entre_contactos__c(id = rc.Id, Ultima_Mod__c = 'SF');
                            toUpd.add(aux);
                        }
                        else if(rc.Ultima_Mod__c == 'fromGCR') {
                            Relacion_entre_contactos__c aux = new Relacion_entre_contactos__c(id = rc.Id, Ultima_Mod__c = 'GCR');
                            toUpd.add(aux);
                        }
                        else if(rc.Ultima_Mod__c == 'fromNAV') {
                            Relacion_entre_contactos__c aux = new Relacion_entre_contactos__c(id = rc.Id, Ultima_Mod__c = 'NAV');
                            toUpd.add(aux);
                        }
                        else if(rc.Ultima_Mod__c != 'SF') {
                            Relacion_entre_contactos__c aux = new Relacion_entre_contactos__c(id = rc.Id, Ultima_Mod__c = 'SF');
                            toUpd.add(aux);
                        }
                    }
                }
            }
        }
        List<Oportunidad_platform__c> ops = [Select id,etapa__c from Oportunidad_platform__c where id IN:OportunidadesUpdate];
        triggerhelper.recursiveHelper1(true);
        update toUpd;
        triggerhelper.recursiveHelper1(false);
        update ops;
    }
}