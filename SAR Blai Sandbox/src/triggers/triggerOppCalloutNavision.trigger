/** 
* File Name:   triggerOppCalloutNavision 
* Description: Controla las oportunidades que se crean o modifican para crear el cliente o residente a Navision o GCR
* Copyright:   Konozca 
* @author:     Sergi Aguilar
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 
* =============================================================== 
**/ 
//por cada oportunidad insertada o modificada se comprueba la etapa de la oportunidad. Si esa es preingreso se crea o modifica 
//el residente a navision en funcion de si existe el identificador navision de residente o no. Si es ingreso se crea o modifica
//el cliente a navision en funcion de si existe el identificador navision de cliente o no.
trigger triggerOppCalloutNavision on Oportunidad_platform__c (after insert, after update) {
    if(Label.Activacion_de_la_integracion != 'No' && triggerHelper.todofalse()) {
        if (TriggerHelperExecuteOnce.executar10() == true || Test.isRunningTest()) {
            Integer pos = 0; 
            //recorremos todas las oportunidades nuevas
            Recordtype adorea = [select id from recordtype where name = 'Oportunidad Adorea'];
            for(Oportunidad_platform__c opc: Trigger.new) {
                //Comprobamos que la oportunidad no tiene las integraciones desactivadas
                if(!opc.integracion_desactivada__c && opc.recordtypeid != adorea.id) { 
                     //comprobamos el tipo de etapa si es ingreso o preingreso
                     
                if(opc.Etapa__c == 'Preingreso' && (Trigger.isInsert || (Trigger.isUpdate && opc.Etapa__c <> Trigger.old[pos].Etapa__c))) {
                    CalloutNavisionWS.createPreIngreso( opc.Residente__c, opc.Pagador__c, opc.Id, opc.LastModifiedBy.Name, false);
                    //GCRCalloutClass.createTodo( opc.Residente__c, opc.Pagador__c, opc.Id);
                }
                else if (opc.Etapa__c == 'Ingreso' && opc.Fecha_cierre__c == null && (Trigger.isInsert || (Trigger.isUpdate && opc.Etapa__c <> Trigger.old[pos].Etapa__c))) {
                    CalloutNavisionWS.createIngreso(opc.Pagador__c, opc.Id);
                    //GCRCalloutClass.modifyOpp(opc.Id); 
                }
                //Llamada a la funcion de crear beneficiario en T24 en caso que la op pase a Cerrada ganada y sea oportunidad TA
                if (Trigger.isUpdate) {
                    Oportunidad_platform__c OldOportunidad = Trigger.oldMap.get(opc.Id);
                    if (OldOportunidad.Etapa__c != opc.Etapa__c && opc.Etapa__c == 'Cerrada ganada' && (/*opc.RecordTypeId == '012b0000000QIjW' || */opc.recordtypeid  == '012b0000000QIDZ'/*|| opc.recordtypeid  == '012b0000000QIDe'*/)) {
                        CalloutT24WebService.crear_beneficiario(opc.id);
                    }  
                }
                
                }
               
                //AIXO ES DE PROVA
                /*
                if (opc.RecordTypeId == '012b0000000QIDj' || opc.recordtypeid  == '012b0000000QIDZ'|| opc.recordtypeid  == '012b0000000QIDe') {
                    CalloutT24WebService.llamada_prueba(opc.id);
                }*/
                
                
                pos = pos + 1;
            }
       }
    }
}