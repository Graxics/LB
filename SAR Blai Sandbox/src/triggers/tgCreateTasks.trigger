/** 
* File Name:   tgCreateTasks 
* Description: Crea tareas en función de los cambios de la oportunidad
* Copyright:   Konozca 
* @author:     Sergi Aguilar
* Modification Logs 
* =============================================================== 
*Date        Author           Modification 
* 09/10/2014 CAndinach        Ampliacion de creacion de tareas y evento automaticos
* 02/05/2016 Alexander Shubin Actualizar la fecha de vencimiento de las tareas:"Recordatorio: Visita pendiente de concertar" a 3 días. (Atención: código mal estructurado - tener precaución)
* =============================================================== 
**/ 
trigger tgCreateTasks on Oportunidad_platform__c (after insert, after update) {
    System.debug('ENTRA tgCreateTasks');
    if(triggerHelper.todofalse()) {
    if (TriggerHelperExecuteOnce.executar5() == true) {
        System.debug('ENTRA RENEGOCIADA000!!!');
        if(Label.Activacion_de_la_integracion != 'No' && triggerHelper.todofalse()) {
            System.debug('ENTRA RENEGOCIADA!!!');
                List<Id> contactosId = new List<Id>();	List<Id> personaContactoId = new List<Id>();	List<Id> empresaId = new List<Id>();
                for(Oportunidad_platform__c opc : trigger.new) {if(opc.Contacto_Recomendador__c != null) contactosId.add(opc.Contacto_Recomendador__c);		if(opc.Persona_de_Contacto__c != null) contactosId.add(opc.Persona_de_Contacto__c);		if(opc.Empresa_Recomendadora__c != null) empresaId.add(opc.Empresa_Recomendadora__c);  }
                List<Contact> contactos = [Select Id, Name, AccountId From Contact Where AccountId IN :contactosId];
                List<Account> cuentas = [Select Id, Name, Director_del_centro__c From Account Where RecordTypeId = '012b0000000QAeAAAW'];
                map<Id, User> users = new map<Id, User>([Select Id, Name, email from User]);
                map<Id, Account> empresas = new map<Id, Account> ([SELECT Id, Name, OwnerId FROM Account WHERE Id IN :empresaId]) ;
                List<EmailTemplate> plantilla = [SELECT Id, Name, HtmlValue, Subject, DeveloperName FROM EmailTemplate WHERE DeveloperName IN  ('Oportunidad_con_recomendador2', 'Ingreso_Oportunidad_con_recomendador2')];
                
                //creamos tareas en función de la modificación de la oportunidad
                List<Task> inTask = new List<Task>();	List<Event> inEvent = new List<Event>();	integer pos2 = 0;
                for(Oportunidad_platform__c opc : trigger.new) {   
                    if(trigger.isInsert){
                        if(opc.Canal__c == 'Llamada al centro' || opc.Canal__c == 'Llamada desde el centro'){
                            Task tr = new Task();
                            if(opc.Canal__c == 'Llamada al centro') tr.Subject = 'Llamada recibida';
                            else if(opc.Canal__c == 'Llamada al centro') tr.Subject = 'Llamada emitida'; 
                            tr.RecordTypeId = '012b0000000QBdPAAW';	
                            tr.ReminderDateTime = date.today();
                            tr.ActivityDate =  date.today();		
                            tr.IsReminderSet = true;
                            tr.WhatId = opc.Id;						
                            tr.IsFromTrigger__c = true;
                            Boolean enc = false;
                            for(integer i = 0; i < contactos.Size() && !enc; ++i) {
                            	if(contactos[i].AccountId == opc.Persona_de_Contacto__c) {
                                    tr.WhoId = contactos[i].Id;
                                    enc = true;} 
                            }
                            tr.Tipo__c = 'Identificación/Captación';	
                            tr.Subtipo__c='Solicitud información inicial';
                            tr.Status='Completada';						
                            inTask.add(tr); } 
                        
                        if(opc.Etapa__c == 'Visita Planificada / Espontánea') {
                            Event ev = new Event();		ev.RecordTypeId = '012b0000000QBdeAAG';		ev.Subject = 'Visita espontánea';		ev.ReminderDateTime = date.today();ev.StartDateTime =  date.today();		ev.EndDateTime =  date.today();		ev.IsReminderSet = true;				ev.WhatId = opc.Id;Boolean enc = false;
                            for(integer i = 0; i < contactos.Size() && !enc; ++i) {if(contactos[i].AccountId == opc.Persona_de_Contacto__c) {	ev.WhoId = contactos[i].Id;	enc = true;} }            ev.Tipo__c = 'Identificación/Captación';	ev.Subtipo__c='Enseñar Centro';		ev.Resultado__c='Acción Cerrada';			inEvent.add(ev);}
                        
                        if(opc.Empresa_Recomendadora__c != null && (opc.recordtypeid == '012b0000000QBG6'  || opc.recordtypeid == '012b0000000QC6IAAW')) {
                        	Task tr = new Task();	
                            tr.RecordTypeId = '012b0000000QBdKAAW';
                            Boolean enc = false;
                       
                        //Envio email propietario Empresa Recomendadora
                        String asunto, body;									
                        Account recomendadora = empresas.get(opc.Empresa_Recomendadora__c);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        User usuario = users.get(recomendadora.OwnerId);
                        mail.setTargetObjectId(usuario.Id);
                        mail.setSaveAsActivity(false);
                        mail.setWhatId(opc.Id); 
                        
                        for(EmailTemplate p : plantilla){
                            if(p.DeveloperName == 'Oportunidad_con_recomendador2') mail.setTemplateId(p.Id);
                        }
                                                                
                       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
                        
                            tr.Subject = 'Recordatorio: Agradecer nueva oportunidad';
                            tr.ReminderDateTime = date.today();
                            tr.ActivityDate =  date.today();
                            tr.IsReminderSet = true;
                            tr.WhatId = opc.Id;
                            Boolean enc2 = false;
                            for(integer i = 0; i < contactos.Size() && !enc; ++i) {
                                if(contactos[i].AccountId == opc.Contacto_Recomendador__c) {
                                    tr.WhoId = contactos[i].Id;	enc2 = true;
                                } 
                            }
                            tr.Tipo__c = 'Llamada';		
                            tr.Description = 'Se ha creado una opp con un recomendador informado. Recuerde llamarlo para agradecer su recomendación.';
                            inTask.add(tr);
                        }
                    }              
                    
                   
                    if(trigger.isUpdate && trigger.old[pos2].Etapa__c != 'Ingreso' && opc.Etapa__c == 'Ingreso' && opc.Empresa_Recomendadora__c != null && opc.recordtypeid != '012b0000000QBG1') {
                        Task tr = new Task();		tr.RecordTypeId = '012b0000000QBdKAAW';		tr.Subject = 'Recordatorio: Agradecer ingreso a recomendador';	Boolean enc = false;
                       
                                          
                    //Envio email al propietario de la empresa recomendadora
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();Account recomendadora = empresas.get(opc.Empresa_Recomendadora__c);mail.setSaveAsActivity(false);				User usuario = users.get(recomendadora.OwnerId);	mail.setTargetObjectId(usuario.Id);			mail.setWhatId(opc.Id); 
                    for(EmailTemplate p : plantilla){if(p.DeveloperName == 'Ingreso_Oportunidad_con_recomendador2') mail.setTemplateId(p.Id);}               
                    
                   if(!Test.isRunningTest()) {Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });}  tr.ReminderDateTime = date.today();		tr.ActivityDate =  date.today();	tr.IsReminderSet = true;				tr.WhatId = opc.Id;			enc = false;
                        for(integer i = 0; i < contactos.Size() && !enc; ++i) {if(contactos[i].AccountId == opc.Contacto_Recomendador__c) {tr.WhoId = contactos[i].Id;	enc = true;} }tr.Tipo__c = 'Llamada';		tr.Description = 'Ha ingresado un nuevo residente por un recomedador. Recuerde llamarlo y agradecerle su recomendación.';	inTask.add(tr);     }
                    
                    if(trigger.isInsert && opc.Etapa__c == 'Pendiente visita' || (trigger.isUpdate && opc.Etapa__c == 'Pendiente visita' && trigger.old[pos2].Etapa__c != 'Pendiente visita')) {
                        Task tr = new Task();										
                        tr.RecordTypeId = '012b0000000QBdPAAW';
                        tr.Subject = 'Recordatorio: Visita pendiente de concertar';
                        tr.ReminderDateTime = date.today().addDays(7);
                        tr.ActivityDate =  date.today().addDays(3);
                        tr.IsReminderSet = true;
                        tr.WhatId = opc.Id;
                        tr.IsFromTrigger__c = true;
                        tr.ownerid = opc.ownerid;
                        Boolean enc = false;
                        for(integer i = 0; i < contactos.Size() && !enc; ++i) {
                            if(contactos[i].AccountId == opc.Persona_de_Contacto__c) {
                                tr.WhoId = contactos[i].Id;	enc = true;
                            } 
                        }
                        tr.Tipo__c = 'Identificación/Captación';
                        tr.Subtipo__c = 'Confirmación Visita';
                        tr.Description = 'Recuerde que tiene que ponerse en contacto con el cliente y planificar una fecha de visita al centro.';
                        inTask.add(tr);
                    }
                    
                    if(trigger.isInsert && opc.Etapa__c == 'Presentado Plan Personal' || trigger.isUpdate && opc.Etapa__c == 'Presentado Plan Personal' && trigger.old[pos2].Etapa__c != 'Presentado Plan Personal') {
                        Task tr = new Task();	 tr.RecordTypeId = '012b0000000QBdPAAW';	tr.Subject = 'Recordatorio: Seguimiento Plan Personal';	tr.ReminderDateTime = date.today().addDays(3);	tr.ActivityDate =  date.today().addDays(3);tr.IsReminderSet = true;tr.WhatId = opc.Id;tr.IsFromTrigger__c = true;Boolean enc = false;
                        for(integer i = 0; i < contactos.Size() && !enc; ++i) {if(contactos[i].AccountId == opc.Persona_de_Contacto__c) {tr.WhoId = contactos[i].Id;	enc = true;}    }tr.Tipo__c = 'Identificación/Captación';tr.Subtipo__c = 'Confirmación Visita';tr.Description = 'Recuerde hacer seguimiento del Plan Personal Presentado.'; inTask.add(tr);
                    }
                    ++pos2;
                }
            
                insert inTask;              
            triggerHelper.recursiveHelper5(true);
                insert inEvent;
            triggerHelper.recursiveHelper5(false);
}}}}