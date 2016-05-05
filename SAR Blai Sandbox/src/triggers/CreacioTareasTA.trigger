/** 
* File Name:   CreacioTareasTA 
* Description: Crea tareas en funcion de la etapa de la oportunidad TA 
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 08/05/2015
* =============================================================== 
**/ 
trigger CreacioTareasTA on Oportunidad_platform__c (after insert,after update) {
    if(triggerHelper.todofalse()) {
    if (TriggerHelperExecuteOnce.executar7() == true) {
        List<id> OpsAbiertas = new List<id>();
        List<id> OpsNegociacion = new List<id>();
        List<id> OpsCerrada = new List<id>();
        List<id> OpsGanadas = new List<id>();
        List<Task> TareasInsert = new List<Task>();
        Map<id,id> PersonasContacto = new Map<id,id>();
        Map<id,Contact> ContactosWhoid = new Map<id,Contact>();
        Recordtype RtypeTareaCliente = [Select Id, Name From RecordType Where Name = 'Tarea Cliente' LIMIT 1];
        Date avui = Date.today();
        //Nos recorremos todas las ops insertadas o modificadas y si es una oportunidad TA (TAD,TAM o mixta), miramos la etapa de la opp.
        //Si la etapa == abierta nos guardamos en una lista los ids de las ops abiertas
        //Si la etapa == Negociación nos guardamos en una lista los ids de las ops Negociación
        //Si la etapa == Cerrada por el sistema nos guardamos en una lista los ids de las ops Cerrada por el sistema
        for (Oportunidad_platform__c op:Trigger.new) {
            System.debug('entres al trigger tareasTAD0');
            if (op.recordtypeid  == '012b0000000QIjW'||op.recordtypeid  == '012b0000000QIDZ'|| op.recordtypeid  == '012b0000000QIDe') {
                System.debug('entres al trigger tareasTAD1');
                if (Trigger.isInsert) {
                    if (op.Etapa__c == 'Abierta') {
                        System.debug('entres al trigger tareasTAD20');
                        OpsAbiertas.add(op.Id);
                        
                    }
                    if (op.Etapa__c == 'Negociación') {
                        OpsNegociacion.add(op.Id);
                    }
                    PersonasContacto.put(op.id,op.Persona_de_Contacto__c);
                }
                if (Trigger.isUpdate) {
                    Oportunidad_platform__c OldOportunitat = Trigger.oldMap.get(op.Id);
                    if (op.Etapa__c == 'Abierta' && OldOportunitat.Etapa__c != op.Etapa__c) {
                        System.debug('entres al trigger tareasTAD21');
                        OpsAbiertas.add(op.Id);
                    }
                    if (op.Etapa__c == 'Negociación' && OldOportunitat.Etapa__c != op.Etapa__c) {
                        OpsNegociacion.add(op.Id);
                    }if (op.Etapa__c == 'Cerrada por el sistema' && OldOportunitat.Etapa__c != op.Etapa__c) {
                        OpsCerrada.add(op.Id);
                    }
                    //Si pasa a cerrada ganada, tenemos que desmarcar el check de baja de todos los beneficiarios
                    if (op.Etapa__c == 'Cerrada ganada' && OldOportunitat.Etapa__c != op.Etapa__c) {
                        OpsGanadas.add(op.Id);
                    }
                    PersonasContacto.put(op.id,op.Persona_de_Contacto__c);
                }
            }
        }
        for (Contact c:[Select id,accountid from Contact where accountid IN:PersonasContacto.values()]) {
            ContactosWhoid.put(c.AccountId,c);
        }
        //Si la oportunidad de la etapa es abierta se tiene que generar una tarea de recordatorio de primer contacto
        for (Oportunidad_platform__c op:[Select id,ownerid,persona_de_contacto__c from Oportunidad_platform__c where id IN:OpsAbiertas]) {
            System.debug('CREAR TAREA PRIMER CONTACTO');
            Task TPrimerContacto = new Task();
            TPrimerContacto.Description = 'Tarea recordatorio primer contacto';
            TPrimerContacto.Status = 'Pendiente';
            TPrimerContacto.ActivityDate = avui.addDays(1);
            TPrimerContacto.Subject = 'Tarea recordatorio primer contacto';
            TPrimerContacto.OwnerId = op.ownerid;
            TPrimerContacto.Priority = 'Normal';
            TPrimerContacto.WhatId = op.Id;
            TPrimerContacto.Whoid = ContactosWhoid.get(op.Persona_de_Contacto__c).id;
            //TPrimerContacto.WhoId = ResiContact.get(oportunidad_nuevo.residente__c).id;
            TPrimerContacto.RecordTypeId = RtypeTareaCliente.id;
            TPrimerContacto.IsFromTrigger__c = true;
            TareasInsert.add(TPrimerContacto);
        }
        //Si la oportunidad de la etapa es negociacion se tiene que generar una Tarea recordatorio seguimiento negociación
        for (Oportunidad_platform__c op:[Select id,ownerid,persona_de_contacto__c from Oportunidad_platform__c where id IN:OpsNegociacion]) {
            System.debug('CREAR TAREA seguimiento negociación');
            Task TNegociacion = new Task();
            TNegociacion.Description = 'Tarea recordatorio seguimiento negociación';
            TNegociacion.Status = 'Pendiente';
            TNegociacion.ActivityDate = avui.addDays(5);
            TNegociacion.Subject = 'Tarea recordatorio seguimiento negociación';
            TNegociacion.OwnerId = op.ownerid;
            TNegociacion.Priority = 'Normal';
            TNegociacion.WhatId = op.Id;
            TNegociacion.Whoid = ContactosWhoid.get(op.Persona_de_Contacto__c).id;
            //TNegociacion.WhoId = ResiContact.get(oportunidad_nuevo.residente__c).id;
            TNegociacion.RecordTypeId = RtypeTareaCliente.id;
            TNegociacion.IsFromTrigger__c = true;
            TareasInsert.add(TNegociacion);
        }
        List<Account> CuentasSinBaja = new List<Account>();
        for (Relacion_entre_contactos__c beneficiario:[Select id, Beneficiario__c from Relacion_entre_contactos__c where Oportunidad__c IN:OpsGanadas]) {
            Account resi = new Account(id = beneficiario.Beneficiario__c,baja__c = false);
            CuentasSinBaja.add(resi);
        }
        List<String> Adreces = new List<String>();
        Map<id,Oportunidad_platform__c> PersContactos = new Map<id,Oportunidad_platform__c>();
        Map<id,Contact> Contactos = new Map<id,Contact>();
        OrgWideEmailAddress owa = [SELECT id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName = 'Residencia SARquavitae' LIMIT 1];
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        //Si la oportunidad de la etapa es cerrada por el sistema se le tiene que enviar un correo a la persona de contacto.
        //Para eso, nos guardamos en un map la relacion personaContacto-oportunidad si la persona de contacto tiene mail
        for (Oportunidad_platform__c op:[Select id,ownerid,Persona_de_Contacto__r.personEmail,Persona_de_Contacto__c from Oportunidad_platform__c where id IN:OpsCerrada]) {
            if (op.Persona_de_Contacto__r.personEmail != null) {
                PersContactos.put(op.Persona_de_Contacto__c,op);
            }
        }
        //Obtenemos los contactos asociados a las cuentas de las personas de referencia y nos guardamos en un map la asociacion
        //ID persona de referencia-Contacto
        for (Contact c: [SELECT AccountId, id FROM Contact where AccountId IN: PersContactos.keySet()]) {
            Contactos.put(c.AccountId, c);
        }
        //De todas las personas de referencia que tengan mail, les mandamos un correo usando su id de contacto.
        for (Oportunidad_platform__c op:PersContactos.values()) {
            String subject = 'Servicios de sarquavitae';
            String body = '<p>Servicios de sarquavitae</p>';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(Contactos.get(op.Persona_de_Contacto__c).id);
            //mail.setWhatId(familiar.contacto__c);
            mail.setSubject(subject);
            mail.setHtmlBody(body);
            mail.setOrgWideEmailAddressId(owa.Id);
            allmails.add(mail);
        }
        //insertamos las tareas
        insert TareasInsert;
        //Modificamos los beneficiarios poniendo el check baja a false
        update CuentasSinBaja;
        //Enviamos todos los correos a la vez en una unica llamada
        if (!Test.isRunningTest() && allMails.size() > 0) {
        	 	Messaging.sendEmail(allMails);
        		}
    }
        }
}