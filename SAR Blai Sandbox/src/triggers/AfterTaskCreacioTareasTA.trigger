/** 
* File Name:   AfterTaskCreacioTareasTA 
* Description: Crea tareas en funcion de la tarea TA 
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 08/05/2015
* =============================================================== 
**/ 
trigger AfterTaskCreacioTareasTA on Task (after update) {
    if(triggerHelper.todofalse()) {
    Date avui = Date.today();
    Recordtype RtypeTareaCliente = [Select Id, Name From RecordType Where Name = 'Tarea Cliente' LIMIT 1];
    //System.debug( RtypeTareaCliente.Id);
    List<id> OpsPrimerContacto = new List<id>();
    Map<id,Task> TareasPC = new Map<id,Task>();
    Map<id,Task> TareasContactado = new Map<id,Task>();
    Map<id,Task> TareasNegociacion = new Map<id,Task>();
    Map<id,Task> TareasInteresado = new Map<id,Task>();
    Map<id,Task> TareasInteresadoRep = new Map<id,Task>();
    Map<id,Task> OpsPerdidas = new Map<id,Task>();
    Map<id,Task> OpsGanadas = new Map<id,Task>();
    List<Task> TareasInsert = new List<Task>();
    List<Oportunidad_platform__c> OpsUpdate = new List<Oportunidad_platform__c>();
    //Recorremos todas las tareas Clientes insertadas y miramos el asunto y el resultado.
    //Dependiendo de las condiciones nos guardamos en Maps la asociacion op (whatid) - TASK
    for (Task t:trigger.new) {
        if (t.recordtypeid == RtypeTareaCliente.Id) {
            Task OldTask = Trigger.oldMap.get(t.Id);
            if ((t.subject == 'Tarea recordatorio primer contacto' || t.subject == 'Tarea recordatorio seguimiento negociación') && (OldTask.resultado__c != t.resultado__c || OldTask.Status != t.Status) && t.resultado__c == 'No contactado' && t.Status == 'Completada') {
                //TareasPC.put(t.WhatId, t);
                Task TRepeticionNoContactado = new Task();		TRepeticionNoContactado.Description = t.Description;
                TRepeticionNoContactado.Status = 'Pendiente';	TRepeticionNoContactado.ActivityDate = avui.addDays(1);
                TRepeticionNoContactado.Subject = t.Subject;	TRepeticionNoContactado.OwnerId = t.ownerid;
                TRepeticionNoContactado.Priority = 'Normal';	TRepeticionNoContactado.WhatId = t.WhatId;
                TRepeticionNoContactado.Whoid = t.Whoid;		TRepeticionNoContactado.RecordTypeId = RtypeTareaCliente.id;
                TRepeticionNoContactado.IsFromTrigger__c = true;TareasInsert.add(TRepeticionNoContactado);
            }
            if ((t.subject == 'Tarea recordatorio primer contacto' || t.subject == 'Tarea recordatorio seguimiento negociación') && (OldTask.resultado__c != t.resultado__c || OldTask.Status != t.Status) && t.resultado__c == 'Contactado' && t.Status == 'Completada') {
                //TareasContactado.put(t.WhatId, t);
                Task TRepeticionContactado = new Task();		TRepeticionContactado.Description = t.Description;
                TRepeticionContactado.Status = 'Pendiente';		TRepeticionContactado.ActivityDate = avui.addDays(1);
                TRepeticionContactado.Subject = t.Subject;		TRepeticionContactado.OwnerId = t.ownerid;
                TRepeticionContactado.Priority = 'Normal';		TRepeticionContactado.WhatId = t.WhatId;
                TRepeticionContactado.Whoid = t.Whoid;			TRepeticionContactado.RecordTypeId = RtypeTareaCliente.id;
                TRepeticionContactado.IsFromTrigger__c = true;	TareasInsert.add(TRepeticionContactado);
                
            }
            if (t.subject == 'Tarea recordatorio primer contacto' && (OldTask.resultado__c != t.resultado__c || OldTask.Status != t.Status) && t.resultado__c == 'Interesado' && t.Status == 'Completada') {
                TareasInteresado.put(t.WhatId, t);
            }
            if (t.subject == 'Tarea recordatorio seguimiento negociación' && (OldTask.resultado__c != t.resultado__c || OldTask.Status != t.Status) && t.resultado__c == 'Interesado' && t.Status == 'Completada') {
                //TareasInteresadoRep.put(t.WhatId, t);
                Task TRepeticionInteresado = new Task();		TRepeticionInteresado.Description = t.Description;
                TRepeticionInteresado.Status = 'Pendiente';		TRepeticionInteresado.ActivityDate = avui.addDays(5);
                TRepeticionInteresado.Subject = t.Subject;		TRepeticionInteresado.OwnerId = t.ownerid;
                TRepeticionInteresado.Priority = 'Normal';		TRepeticionInteresado.WhatId = t.WhatId;
                TRepeticionInteresado.Whoid = t.Whoid;			TRepeticionInteresado.RecordTypeId = RtypeTareaCliente.id;
                TRepeticionInteresado.IsFromTrigger__c = true;	TareasInsert.add(TRepeticionInteresado);
            }
            if ((t.subject == 'Tarea recordatorio seguimiento negociación' || t.subject == 'Tarea recordatorio primer contacto') && (OldTask.resultado__c != t.resultado__c || OldTask.Motivo_no_interesado__c !=t.Motivo_no_interesado__c || OldTask.Status != t.Status)  && t.resultado__c == 'No Interesado' && t.Motivo_no_interesado__c != null && t.Status == 'Completada') {
                OpsPerdidas.put(t.WhatId, t);
            }
            if ((t.subject == 'Tarea recordatorio seguimiento negociación' || t.subject == 'Tarea recordatorio primer contacto') && (OldTask.resultado__c != t.resultado__c || OldTask.Status != t.Status) && t.resultado__c == 'Enviar contrato' && t.Status == 'Completada') {
                OpsGanadas.put(t.WhatId, t);
            }
        }
    }
        /*
    //Si la etapa de la opp es abierta, el resultado es No contactado y la tarea es Tarea recordatorio primer contacto
    //generamos otra tarea igual con fecha de vencimiento 1 dia
    for (Oportunidad_platform__c op:[Select id,etapa__c,ownerid from Oportunidad_platform__c where id IN:TareasPC.keySet() and etapa__c = 'abierta']) {
        Task TPrimerContacto = new Task();
        TPrimerContacto.Description = 'Tarea recordatorio primer contacto';
        TPrimerContacto.Status = 'Pendiente';
        TPrimerContacto.ActivityDate = avui.addDays(1);
        TPrimerContacto.Subject = 'Tarea recordatorio primer contacto';
        TPrimerContacto.OwnerId = op.ownerid;
        TPrimerContacto.Priority = 'Normal';
        TPrimerContacto.WhatId = op.Id;
        TPrimerContacto.Whoid = TareasPC.get(op.id).Whoid;
        //TPrimerContacto.WhoId = ResiContact.get(oportunidad_nuevo.residente__c).id;
        TPrimerContacto.RecordTypeId = RtypeTareaCliente.id;
        TPrimerContacto.IsFromTrigger__c = true;
        TareasInsert.add(TPrimerContacto);
    }*/
        /*
    //Si la etapa de la opp es Negociación, el resultado es Interesado y la tarea es Tarea recordatorio seguimiento negociación
    //generamos otra tarea igual con fecha de vencimiento 7 dias
    for (Oportunidad_platform__c op:[Select id,etapa__c,ownerid from Oportunidad_platform__c where id IN:TareasNegociacion.keySet() and etapa__c = 'Negociación']) {
        Task TNegociacion = new Task();
        TNegociacion.Description = 'Tarea recordatorio seguimiento negociación';
        TNegociacion.Status = 'Pendiente';
        TNegociacion.ActivityDate = avui.addDays(7);
        TNegociacion.Subject = 'Tarea recordatorio seguimiento negociación';
        TNegociacion.OwnerId = op.ownerid;
        TNegociacion.Priority = 'Normal';
        TNegociacion.WhatId = op.Id;
        TNegociacion.Whoid = TareasNegociacion.get(op.id).whoid;
        //TPrimerContacto.WhoId = ResiContact.get(oportunidad_nuevo.residente__c).id;
        TNegociacion.RecordTypeId = RtypeTareaCliente.id;
        TNegociacion.IsFromTrigger__c = true;
        TareasInsert.add(TNegociacion);
    }*/
        
    //Si la etapa de la opp es abierta, el resultado es contactado y la tarea es Tarea recordatorio primer contacto
    //cambiamos la etapa de la opp a Negociacion
    for (Oportunidad_platform__c op:[Select id,etapa__c,ownerid from Oportunidad_platform__c where id IN:TareasInteresado.keySet() and etapa__c = 'abierta']) {
        Oportunidad_platform__c opMod = new Oportunidad_platform__c(id = op.id);
        opMod.Etapa__c = 'Negociación';
        opMod.Fecha_primer_contacto__c = Date.today();
        OpsUpdate.add(opMod);
    }
    //Si el resultado es No Interesado y el motivo de no interes está informado y la tarea es Tarea recordatorio seguimiento negociación
    //cambiamos la etapa de la opp a Cerrada perdida
    for (Oportunidad_platform__c op:[Select id,etapa__c,ownerid from Oportunidad_platform__c where id IN:OpsPerdidas.keySet() and etapa__c != 'Cerrada ganada' and etapa__c != 'Cerrada perdida']) {
        Oportunidad_platform__c opMod = new Oportunidad_platform__c(id = op.id);
        opMod.Etapa__c = 'Cerrada perdida';
        opMod.Motivo_Cerrada_perdida__c = OpsPerdidas.get(op.id).Motivo_no_interesado__c;
        OpsUpdate.add(opMod);
    }
    //Si  el resultado es Enviar contrato y la tarea es Tarea recordatorio seguimiento negociación
    //cambiamos la etapa de la opp a Cerrada ganada
    for (Oportunidad_platform__c op:[Select id,etapa__c,ownerid,IBAN__c from Oportunidad_platform__c where id IN:OpsGanadas.keySet() and etapa__c != 'Cerrada ganada' and etapa__c != 'Cerrada perdida' ]) {
        Oportunidad_platform__c opMod = new Oportunidad_platform__c(id = op.id);
        opMod.Etapa__c = 'Cerrada ganada';
        opMod.Fecha_envio_contrato__c = Date.today();
        OpsUpdate.add(opMod);
    }
    //Insertamos las tareas
    insert TareasInsert;
    //Hacemos update de las oportunidades
    update OpsUpdate;
  } 
}