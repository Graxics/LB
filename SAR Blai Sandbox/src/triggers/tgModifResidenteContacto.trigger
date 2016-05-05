/** 
* File Name:   tgModifResidenteContacto 
* Description: Modifica el residente o contacto corresponiente de navision y controla las empresas de los contactos recomendadores
* Copyright:   Konozca 
* @author:     Sergi Aguilar
* Modification Log 
* =============================================================== 
* Date     Author           Modification 
* 
* =============================================================== 
**/ 
trigger tgModifResidenteContacto on Account (after update, after insert) {
    if(trigger.isUpdate && Label.Activacion_de_la_integracion != 'No') {
        //activa el flujo de aprobacion si el tipo de recomenador era A y ya no o viceversa
        integer pos = 0;
        for(Account rec : trigger.new) {
            if((rec.RecordTypeId == '012b0000000QAd7AAG' || rec.RecordTypeId == '012b0000000QCbtAAG') && ((rec.Clasificacion_tipo_recomendador__c == 'A' && trigger.old[pos].Clasificacion_tipo_recomendador__c != 'A') ||
                (rec.Clasificacion_tipo_recomendador__c != 'A' && trigger.old[pos].Clasificacion_tipo_recomendador__c == 'A'))) {
                try {
                    // create the new approval request to submit
                    Approval.Processsubmitrequest req = new Approval.Processsubmitrequest();
                    req.setComments('Submitting request for approval.');
                    req.setObjectId(rec.Id);
                    // submit the approval request for processing
                    Approval.Processresult result = Approval.process(req);
                    // display if the request was successful
                    System.debug('Submitted for approval successfully: ' + result.isSuccess());
                } catch (Exception e) {
                    System.debug(e);
                }
            }
            ++pos;
        }
        pos = 0;
        
        //llamada a los WS por modificación de residente o contacto
        
        if(triggerhelper.todofalse() && Label.Activacion_de_la_integracion != 'No') {
            List<Account> laUpd = new List<Account>();
            List<Relacion_entre_contactos__c> lrec = [Select Id, IdGCR__c, Residente__c, Contacto__c From Relacion_entre_contactos__c Where Contacto__c In :trigger.newMap.keyset()];
            List<Oportunidad_platform__c> ling = [Select Id, Etapa__c, Fecha_de_Alta__c, Residente__c, Pagador__c From Oportunidad_platform__c Where Pagador__c In :trigger.newMap.keyset()];
            for(Account a: trigger.new) {
                if(a.RecordTypeId == '012b0000000QAe0AAG' && Trigger.isUpdate) {
                    Account OldCuenta = Trigger.oldMap.get(a.Id);
                    System.debug('CRIDA A T24!');
                    if (a.Id_T24__c != null && (OldCuenta.Id_T24__c == a.Id_T24__c) && a.Ultima_Mod__c != 'fromT24') {
                        CalloutT24WebService.modificacion_cuenta(a.id);
                    }
                    if(a.Ultima_Mod__c != 'fromT24' && a.Ultima_Mod__c != 'fromGCR' && a.Ultima_Mod__c != 'fromNAV' && !(!trigger.old[pos].Actualizar_direccion__c && a.Actualizar_direccion__c) && OldCuenta.Id_T24__c == a.Id_T24__c) { 
                        
                        //llamadas al WS
                        if(a.IdNAV_RES__c != null) calloutNavisionWS.CreateResident(a.Id); 
                        
                        Boolean enc = false;
                        for(integer i = 0; i < ling.Size() && !enc; ++i) {
                            if(ling[i].Pagador__c == a.Id && ling[i].Etapa__c == 'Ingreso' && ling[i].Fecha_de_Alta__c == null) enc = true;
                        }
                        if(enc) {
                            Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
                            Integer delayInMilliseconds = 1000; // One-second delay
                            while (System.now().getTime() - startingTime < delayInMilliseconds) {
                                
                                        // Do nothing until desired delay has passed
                            }
                            calloutNavisionWS.modifyCustomer(a.Id);
                        }
                        if(a.Residente__c && a.IdGCR__c != null) {
                            if(a.IdGCR__c != null) GCRCalloutClass.modifyResident(a.Id);
                        }
                        for(Relacion_entre_contactos__c rc: lrec) {
                            if(rc.Contacto__c == a.Id) {
                                if(rc.IdGCR__c != null) GCRCalloutClass.modifyContact(rc.Residente__c, a.Id);
                            }
                        }
                        Account aux = new Account(id = a.Id, Ultima_Mod__c = 'SF');
                        laUpd.add(aux);
                    }
                    else if(a.Ultima_Mod__c == 'fromGCR') {
                        Account aux = new Account(id = a.Id, Ultima_Mod__c = 'GCR');
                        laUpd.add(aux);
                    }
                    else if(a.Ultima_Mod__c == 'fromNAV') {
                        Account aux = new Account(id = a.Id, Ultima_Mod__c = 'NAV');
                        laUpd.add(aux);
                    }
                    else if(a.Ultima_Mod__c == 'fromT24') {
                        Account aux = new Account(id = a.Id, Ultima_Mod__c = 'T24');
                        laUpd.add(aux);
                    }
                    else if(a.Ultima_Mod__c != 'SF') {
                        Account aux = new Account(id = a.Id, Ultima_Mod__c = 'SF');
                        laUpd.add(aux);
                    }
                }
                ++pos;  
            }
            triggerhelper.recursiveHelper1(true);
            update laUpd;
            triggerhelper.recursiveHelper1(false);
        }
    }
    else if(trigger.isInsert && label.Activacion_tg_Residente_Contacto != 'No') {
        List<Account> insUpd = new List<Account>();
        for(Account a: trigger.new) {
            if(a.RecordTypeId == '012b0000000QAe0AAG') {
                if(a.Ultima_Mod__c == 'fromGCR') {
                    Account aux = new Account(id = a.Id, Ultima_Mod__c = 'GCR');
                    insUpd.add(aux);
                }
                else if(a.Ultima_Mod__c == 'fromNAV') {
                    Account aux = new Account(id = a.Id, Ultima_Mod__c = 'NAV');
                    insUpd.add(aux);
                }
                else if(a.Ultima_Mod__c != 'SF') {
                    Account aux = new Account(id = a.Id, Ultima_Mod__c = 'SF');
                    insUpd.add(aux);
                }
            }
        }
        triggerhelper.recursiveHelper1(true);
        update insUpd;
        triggerhelper.recursiveHelper1(false);
    }
    
    
    //controlamos las relaciones entre recomendadores y empresas
    List<Relacion_entre_contactos__c> lrecIn = new List<Relacion_entre_contactos__c>();
    List<Relacion_entre_contactos__c> lrecUpd = new List<Relacion_entre_contactos__c>();
    Integer pos2 = 0;
    
    List<Id> idRecom = new List<Id>();
    for(Account ids : trigger.new) {
                idRecom.add(ids.Id);
    }
    List<Relacion_entre_contactos__c> relacionesRecom = [Select Id, Contacto_Recomendador__c, Empresa_recomendadora__c, Empleo_actual__c FROM Relacion_entre_contactos__c WHERE Contacto_Recomendador__c In :idRecom];
    
    //anadimos la relacion con la empresa recomendadora si se ha cambiado
    for(Account recCon: trigger.new) {
        //si es un contacto recomendador, es update y ha cambiado la empresa anadimos la relación con este centro.
        if(recCon.RecordTypeId == '012b0000000QCbtAAG' && trigger.isUpdate && recCon.Empresa_recomendadora__c != trigger.oldmap.get(recCon.id).Empresa_recomendadora__c ) {
            Boolean enc = false;
            for(integer j = 0; j < relacionesRecom.Size(); ++j) {
                if(relacionesRecom[j].Contacto_Recomendador__c == recCon.Id) {
                    if(recCon.Empresa_recomendadora__c != null && relacionesRecom[j].Empresa_recomendadora__c == recCon.Empresa_recomendadora__c) {
                        enc = true;
                        if(relacionesRecom[j].Empleo_actual__c == false) {
                            Relacion_entre_contactos__c recUpd = new Relacion_entre_contactos__c();
                            recUpd.Id = relacionesRecom[j].Id;
                            recUpd.Empleo_actual__c = true;
                            lrecUpd.add(recUpd);
                        }
                    }   
                    else if (relacionesRecom[j].Empleo_actual__c == true) {
                        Relacion_entre_contactos__c recUpd = new Relacion_entre_contactos__c();
                        recUpd.Id = relacionesRecom[j].Id;
                        recUpd.Empleo_actual__c = false;
                        lrecUpd.add(recUpd);
                    }
                }
            }
            if(!enc && recCon.Empresa_recomendadora__c != null) {
                Relacion_entre_contactos__c rec = new Relacion_entre_contactos__c();
                rec.RecordTypeId = '012b0000000QCc3AAG';
                rec.Contacto_Recomendador__c = recCon.Id;
                rec.Empresa_recomendadora__c = recCon.Empresa_recomendadora__c;
                rec.Empleo_actual__c = true;
                lrecIn.add(rec);
            }
        }
        else if(trigger.isInsert && recCon.RecordTypeId == '012b0000000QCbtAAG' && recCon.Empresa_recomendadora__c != null) {
            Relacion_entre_contactos__c rec2 = new Relacion_entre_contactos__c();
            rec2.RecordTypeId = '012b0000000QCc3AAG';
            rec2.Contacto_Recomendador__c = recCon.Id;
            rec2.Empresa_recomendadora__c = recCon.Empresa_recomendadora__c;
            rec2.Empleo_actual__c = true;
            lrecIn.add(rec2);
        }
        ++pos2;
    }
    system.debug('Update lrecUpd ' + lrecUpd.size());
    system.debug('Insert lrecIn  ' + lrecIn.size());
    update lrecUpd;
    insert lrecIn;
}