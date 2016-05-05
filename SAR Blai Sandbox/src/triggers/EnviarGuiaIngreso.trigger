/** 
* File Name:   AfterUpdateOportunidad
* Description:Trigger que se ejecutará siempre que se modifique una oportunidad. En este trigger se generaran las tareas de 
ingreso por primera vez del residente, de la guia de ingreso y la primera tarea del informe a familia. Ademas, tambien se envia el email de
bienvenida.
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version    Date        Author           Modification 
* 01        25/11/2015  Carlos Díaz
* =============================================================== 
**/ 

trigger EnviarGuiaIngreso on Oportunidad_platform__c (after update) {
    //Tenemos que controlar que el trigger solo se ejecute una vez
    //ya que hay un workflow que hace saltar el trigger una segunda vez
    if(triggerHelper.todofalse()) { 
    	if (TriggerHelperExecuteOnce.executar11() == true) {
         System.debug('hello hello');
         Date avui = Date.today();
         Date avuiAux = avui;
         List<Task> tasksGuia = new List<Task>();
         List<id> idops = new List<id>();
         List<id> idResidents = new List<id>();
         List<Oportunidad_platform__c> OpsReingreso = new List<Oportunidad_platform__c>();
         Date vencimientoIngreso = avui.addDays(7);
         Date vencimientoInforme = avui.addMonths(1);
         for (Oportunidad_platform__c oportunidad:Trigger.new) {
             System.debug('GUIA INGRESO: '+oportunidad.residente__r.firstname+' oppid: '+oportunidad.id);
                //Comprovamos las condiciones y si se cumplen guardamos el id de la oportunidad a la lista de Ids
                if (oportunidad.Etapa__c=='Preingreso') {
                    //Obtenemos la oportunidad de antes de hacer el update
                    Oportunidad_platform__c OldOportunitat = Trigger.oldMap.get(oportunidad.Id);
                    //Si la etapa de la opp era diferente a Ingreso, guardamos el id de la oportunidad a la lista de ids.
                    if (OldOportunitat.Etapa__c != oportunidad.Etapa__c) {
                        //NEW!!!
                        Id idResident = oportunidad.Residente__c;
                        idResidents.add(idResident);
                        idops.add(oportunidad.Id);
                        System.debug('ENTRA PREINGRESO');
                    }
                }
         }
         Map<ID, Contact> ResiContact = new Map<ID, Contact>();
         for (Contact c: [SELECT AccountId, id FROM Contact where AccountId IN: idResidents]) {
             ResiContact.put(c.AccountId, c);
         }
         
         Recordtype RtypeTareaCliente = [Select Id, Name From RecordType Where Name = 'Tarea Cliente' LIMIT 1];
            /*CREACION DE TAREAS DE PREINGRESO*/
            //Seleccionamos el id del ATC del centro de todas las oportunidades que cumplen las condiciones
            //y hacemos las creaciones de las tareas de los ingresos.
            for (Oportunidad_platform__c oportunidad_nuevo: [SELECT id,residente__c,residente__r.name,Centro2__r.ATC_Centro__c,Centro2__r.ATC_Centro2__c,Centro2__r.ATC_Centro3__c,Centro2__r.Comunicacion_con_familias__c  from Oportunidad_platform__c where id IN: idops]) {
                    //Obtenemos los ids de los ATCs
                    Id IdAtc= oportunidad_nuevo.Centro2__r.ATC_Centro__c;
                    Id IdAtc2= oportunidad_nuevo.Centro2__r.ATC_Centro2__c;
                    Id IdAtc3= oportunidad_nuevo.Centro2__r.ATC_Centro3__c;
                    Boolean ComunicacionFamilias = oportunidad_nuevo.Centro2__r.Comunicacion_con_familias__c;
                    //CREAR TAREA ENTREGA GUÍA PARA EL INGRESO
                    if (IdAtc != null && ComunicacionFamilias == true) {
                        Task tguia = new Task();
                        tguia.Description = 'Recuerda entregar el manual de Guía de Ingreso a la familia del nuevo residente '+oportunidad_nuevo.residente__r.name;
                        tguia.Status = 'Pendiente';
                        tguia.ActivityDate = avui;
                        tguia.Subject = 'ENTREGA GUÍA PARA EL INGRESO';
                        tguia.OwnerId = IdAtc;
                        tguia.Priority = 'Normal';
                        tguia.WhatId = oportunidad_nuevo.Id;
                        tguia.WhoId = ResiContact.get(oportunidad_nuevo.residente__c).id;
                        tguia.RecordTypeId = RtypeTareaCliente.id;
                        tguia.IsFromTrigger__c = true;
                        //Añadimos la tarea a la lista para luego añadirla a la BD
                        tasksGuia.add(tguia);
                    }
            }
      
            
            /*ENVIAR EMAIL CON GUIA PARA EL INGRESO*/
            if (idResidents.size()> 0) {
                OrgWideEmailAddress owa = [SELECT id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName = 'Residencia SARquavitae' LIMIT 1];
                System.debug('ENTRA envio guia!!');
                Map<ID, Oportunidad_platform__c> InfoCentres = new Map<id,Oportunidad_platform__c>();
                Map<id,id> ResidentsiCentres = new Map<id,id>();
                for (Oportunidad_platform__c InfoOpp:[SELECT residente__c, centro2__c,centro2__r.blog__c,centro2__r.ATC_centro__c,Centro2__r.Comunicacion_con_familias__c  FROM Oportunidad_platform__c where id IN:idOps]) {
                        ResidentsiCentres.put(InfoOpp.residente__c, InfoOpp.centro2__c);
                        InfoCentres.put(InfoOpp.centro2__c,InfoOpp);
                }
             
                //Cargamos las plantillas de bienvenida (catalan y castellano)
                EmailTemplate templateCat = new EmailTemplate();
                EmailTemplate templateCast = new EmailTemplate(); 
                EmailTemplate templateEus = new EmailTemplate();
                EmailTemplate templateGal = new EmailTemplate();
                EmailTemplate templateGuia = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Guia_de_ingreso' LIMIT 1];
               
                
                // NUEVOOOO
                templateCat = templateGuia;
                templateCast = templateGuia;
                templateEus = templateGuia;
                templateGal = templateGuia;
                //NUEVO FIN
             

                //Declaramos la lista de direcciones.
                List<String> adresses = new List<String>();
                //Declaramos la clase auxiliar sendMail.
                SendEmailHelper sendMail = new SendEmailHelper();
                //Declaramos una lista de mails, donde iremos añadiendo todos los emails a enviar
                //y lo enviaremos despues de haber recorrido todos los familiares
                //ya que así no nos pasaremos del límite de 10 llamadas a la funcion sendMail
                List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
                Set<id> ContactosIds = new Set<id>();
                for (Relacion_entre_contactos__c familiar : [SELECT contacto__c,contacto__r.PersonEmail FROM Relacion_entre_contactos__c WHERE Residente__c IN: idResidents order by residente__c asc]) {
                    if (familiar.contacto__r.PersonEmail != null) {
                        ContactosIds.add(familiar.contacto__c);
                    }
                }
                Map<ID, Contact> ContactoYCuentas = new Map<ID, Contact>();
                for (Contact c: [SELECT AccountId, id FROM Contact where AccountId IN: ContactosIds]) {
                     ContactoYCuentas.put(c.AccountId, c);
                }
                ContactosIds = null;
                Integer count = 1;
                //Obtenemos toda la info de los familiares (Nombre, correo, idioma...) asociados a los residentes de la lista
                //y para cada uno vamos creando la tarea asociada y guardando el mail en la lista de mails.
                for (Relacion_entre_contactos__c familiar : [SELECT id,contacto__c,residente__c, contacto__r.lastname,residente__r.lastname,residente__r.name,contacto__r.name,contacto__r.PersonEmail,contacto__r.Idioma_de_Contacto__pc FROM Relacion_entre_contactos__c WHERE Residente__c IN: idResidents order by residente__c asc]) {
                    //Si el familiar tiene correo, haremos todo el proceso.
                    if (familiar.contacto__r.PersonEmail != null) {
                        Id CentreActual = ResidentsiCentres.get(familiar.residente__c);
                        Boolean CentroEnviable = InfoCentres.get(CentreActual).centro2__r.Comunicacion_con_familias__c;
                        if (CentroEnviable == true) {
                            adresses.add(familiar.contacto__r.PersonEmail);
                            System.debug('ADREÇA AFEGIDA '+count+' Bienvenida: '+familiar.contacto__r.PersonEmail);
                            ++count;
                            //Dependiendo del idioma del contacto, la plantilla sera una o otra.
                            EmailTemplate template = new EmailTemplate();
                            template = templateGuia; //PREPARADO POR SI ALGUN DÍA HAY GUIAS EN OTRO IDIOMA:
                            if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Catalán') {
                                template = templateCat;
                            }
                            else if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Euskera') {
                                template = templateEus;
                            }
                            if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Gallego') {
                                template = templateGal;
                            }
                            else {
                                template = templateCast;
                            }
                            //Obtenemos todos los datos de la plantilla
                            String subject = template.Subject;
                            String body = template.HtmlValue;
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                           /* String[] addresses = new String[]{familiar.contacto__r.PersonEmail};
                            mail.setToAddresses(addresses);*/
                            mail.setTargetObjectId(ContactoYCuentas.get(familiar.contacto__c).id);
                            mail.SaveAsActivity = false;
                            mail.setSubject(subject);
                            mail.setHtmlBody(body);
                            mail.setOrgWideEmailAddressId(owa.Id);
                            allmails.add(mail);
                            adresses.clear();
                       }  
                    }
                }
                //Una vez recorridos todos los familiares, insertamos las Tareas y enviamos los mails
                //insert TaskMails;
             if(!Test.isRunningTest() && Label.Activacion_comunicacion_familias != 'No') {
                    Messaging.sendEmail(allMails);
              } 
            }
        
            //INSERTS TASKS
            triggerHelper.recursiveHelper1(true);
            insert tasksGuia;    
            triggerHelper.recursiveHelper1(false);
 		} 
    } 
        
}