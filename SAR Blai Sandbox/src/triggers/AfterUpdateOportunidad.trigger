/** 
* File Name:   AfterUpdateOportunidad
* Description:Trigger que se ejecutará siempre que se modifique una oportunidad. En este trigger se generaran las tareas de 
ingreso por primera vez del residente, de la guia de ingreso y la primera tarea del informe a familia. Ademas, tambien se envia el email de
bienvenida.
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version    Date        Author           	Modification 
* 01        09/02/2015  Xavier Garcia
* 02 		04/03/2016  Alexander Shubin	Correo electrónico: Bienvenida (Líneas 220-240)  reasignación de campos: Recordtype, Type, Subtype
* 03 		04/03/2016  Alexander Shubin	Arreglar el BUG Null exception (Líneas 219-222) 
* 04 		25/04/2016  Alexander Shubin	Arreglar el BUG Null exception (Líneas 219-222) Agregar plantilla correspondiente al idioma.
* =============================================================== 
**/ 

trigger AfterUpdateOportunidad on Oportunidad_platform__c (after update) {
    //Tenemos que controlar que el trigger solo se ejecute una vez
    //ya que hay un workflow que hace saltar el trigger una segunda vez
     if (TriggerHelperExecuteOnce.executar1() == true) {
         Date avui = Date.today();
         Date avuiAux = avui;
         List<Task> tasksHV = new List<Task>();
         List<Task> tasksGuia = new List<Task>();
         List<Task> tasksInforme = new List<Task>();
         List<id> idops = new List<id>();
         List<id> idResidents = new List<id>();
         List<id> idopsInforme = new List<id>();
         List<id> idResidentsInforme = new List<id>();
         List<id> idResidentsEmail = new List<id>();
         List<id> idOpsEmail = new List<id>();
         List<id> ResidentesReingreso = new List<id>();
         List<Oportunidad_platform__c> OpsReingreso = new List<Oportunidad_platform__c>();
         Date vencimientoIngreso = avui.addDays(7);
         Date vencimientoInforme = avui.addMonths(1);
         for (Oportunidad_platform__c oportunidad:Trigger.new) {
                //Comprovamos las condiciones y si se cumplen guardamos el id de la oportunidad a la lista de Ids
                if (oportunidad.Etapa__c=='Ingreso') {
                    //Obtenemos la oportunidad de antes de hacer el update
                    Oportunidad_platform__c OldOportunitat = Trigger.oldMap.get(oportunidad.Id);
                    //Si la etapa de la opp era diferente a Ingreso, guardamos el id de la oportunidad a la lista de ids.
                    if (OldOportunitat.Etapa__c != oportunidad.Etapa__c) {
                        //NEW!!!
                        //Si es el primer ingreso del residente, tendremos que generar todas las tareas al ATC
                        //y enviar el correo de bienvenida
                        Id idResident = oportunidad.Residente__c;
                        if (oportunidad.recordtypeid == '012b0000000QC6IAAW') idResident = oportunidad.Cliente_residente__c;
                        idResidents.add(idResident);
                        idops.add(oportunidad.Id);
                           /* idResidentsEmail.add(idResident);
                            idOpsEmail.add(oportunidad.Id);*/
                        idResidentsInforme.add(idResident);
                        idopsInforme.add(oportunidad.Id);
                        ResidentesReingreso.add(idResident);
                        OpsReingreso.add(oportunidad);
                        System.debug('ENTRA000000');
                    }
                }
         }
         Map<ID, Contact> ResiContact = new Map<ID, Contact>();
         Map<ID, Contact> ResiContactInforme = new Map<ID, Contact>();
         for (Contact c: [SELECT AccountId, id FROM Contact where AccountId IN: idResidents]) {ResiContact.put(c.AccountId, c);}
         for (Contact c: [SELECT AccountId, id FROM Contact where AccountId IN: idResidentsInforme]) {ResiContactInforme.put(c.AccountId, c);}
         
         Recordtype RtypeTareaCliente = [Select Id, Name From RecordType Where Name = 'Tarea Cliente' LIMIT 1];
            /*CREACION DE TAREAS DE INGRESO*/
            //Seleccionamos el id del ATC del centro de todas las oportunidades que cumplen las condiciones
            //y hacemos las creaciones de las tareas de los ingresos.
            for (Oportunidad_platform__c oportunidad_nuevo: [SELECT id,residente__c,residente__r.name,Centro2__r.ATC_Centro__c,Centro2__r.ATC_Centro2__c,Centro2__r.ATC_Centro3__c,Centro2__r.Comunicacion_con_familias__c  from Oportunidad_platform__c where id IN: idops and residente__r.Historia_de_vida_adjunta__c = false]) {
                    //Obtenemos los ids de los ATCs
                    Id IdAtc= oportunidad_nuevo.Centro2__r.ATC_Centro__c;
                    Id IdAtc2= oportunidad_nuevo.Centro2__r.ATC_Centro2__c;
                    Id IdAtc3= oportunidad_nuevo.Centro2__r.ATC_Centro3__c;
                    Boolean ComunicacionFamilias = oportunidad_nuevo.Centro2__r.Comunicacion_con_familias__c;
                    /*CREAR TAREA CUESTIONARIO HISTORIA DE VIDA*/
                    if (IdAtc != null &&  ComunicacionFamilias == true) {
                        Task thistoria = new Task();
                        thistoria.Description = 'Recuerda rellenar el Cuestionario de Historia de vida del nuevo residente '+oportunidad_nuevo.residente__r.name+' y añadirlo a su ficha. Puede encontrar el documento en el siguiente link: https://sarquavitae.my.salesforce.com/015b0000001oKO1';
                        thistoria.Status = 'Pendiente';
                        thistoria.ActivityDate = vencimientoIngreso;
                        thistoria.Subject = 'cuestionario historia de vida';
                        thistoria.OwnerId = IdAtc;
                        thistoria.Priority = 'Normal';
                        thistoria.WhatId = oportunidad_nuevo.Id;
                        thistoria.WhoId = (ResiContact.get(oportunidad_nuevo.residente__c)!=null) ?
                            ResiContact.get(oportunidad_nuevo.residente__c).id : null;
                        thistoria.RecordTypeId = RtypeTareaCliente.id;
                        thistoria.IsFromTrigger__c = true;
                        //Añadimos la tarea a la lista para luego añadirla a la BD
                        tasksInforme.add(thistoria);
                    }
                    
                    /*CREAR TAREA ENTREGA GUÍA PARA EL INGRESO*/
                /*    if (IdAtc != null && ComunicacionFamilias == true) {
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
                    } */
            }
         for (Oportunidad_platform__c oportunidad_nuevo: [SELECT id,residente__c,residente__r.name,Centro2__r.ATC_Centro__c,Centro2__r.ATC_Centro2__c,Centro2__r.ATC_Centro3__c,Centro2__r.Comunicacion_con_familias__c from Oportunidad_platform__c where id IN: idopsInforme]) {
              //Obtenemos los ids de los ATCs
             Id IdAtc= oportunidad_nuevo.Centro2__r.ATC_Centro__c;
             Id IdAtc2= oportunidad_nuevo.Centro2__r.ATC_Centro2__c;
             Id IdAtc3= oportunidad_nuevo.Centro2__r.ATC_Centro3__c;
             Boolean ComunicacionFamilias = oportunidad_nuevo.Centro2__r.Comunicacion_con_familias__c;
             /*CREAR TAREA INFORME A FAMILIA*/
             if (IdAtc != null && ComunicacionFamilias == true) {
                 Task tinforme = new Task();
                 tinforme.Description = 'URGENTE ¡¡¡Completa el informe de adaptación del residente '+oportunidad_nuevo.residente__r.name+'!!! Recuerda que el informe de adaptación es el informe a familias marcando el motivo “adaptación”. Este informe pretende aportar a la familia información sobre la adaptación del residente a la vida del centro. Una vez rellenado se deberá entregar a la familia.';
                 tinforme.Status = 'Pendiente';
                 tinforme.ActivityDate = vencimientoInforme;
                 tinforme.Subject = 'Informe a familia';
                 tinforme.OwnerId = IdAtc;
                 tinforme.Priority = 'Normal';
                 tinforme.WhatId = oportunidad_nuevo.Id;
                 tinforme.WhoId = (ResiContactInforme.get(oportunidad_nuevo.residente__c)!=null) ? 
                     ResiContactInforme.get(oportunidad_nuevo.residente__c).id : null;
                 tinforme.RecordTypeId = RtypeTareaCliente.id;
                 tinforme.IsFromTrigger__c = true;
                 //Añadimos la tarea a la lista para luego añadirla a la BD
                 tasksInforme.add(tinforme);
           }  
             
         }
            
            /*ENVIAR EMAIL DE BIENVENIDA*/
            //NEW!!!
            //Guardamos en un map la información de las fechas del ultimo ingreso de los residentes que hacen un reingreso.
            Map<id,Oportunidad_platform__c> InfoFechasResidentes = new Map<id,Oportunidad_platform__c>();
            for (Oportunidad_platform__c opInfoFechas:[SELECT Fecha_prevista_de_ingreso__c,residente__c from Oportunidad_platform__c where residente__c IN:ResidentesReingreso and
                 Fecha_prevista_de_ingreso__c != null and Fecha_de_Alta__c != null and id NOT IN:OpsReingreso order by residente__c asc,Fecha_prevista_de_ingreso__c asc] ) {
                     InfoFechasResidentes.put(opInfoFechas.residente__c,opInfoFechas);
                     System.debug('FECHA ULTIMO INGRESO SECUENCIA: '+opInfoFechas.Fecha_prevista_de_ingreso__c);
            }
            //Recorremos todas las ops en reingreso y solo nos guardamos en la lista de residentes que reciben email
            //a aquellos que la fecha prevista de ingreso de la ultima op tenga una antiguedad de 4 meses o mas.
            for (Oportunidad_platform__c opReingreso:OpsReingreso) {
                id Residente = opReingreso.Residente__c;
               if (opReingreso.recordtypeid == '012b0000000QC6IAAW') Residente = opReingreso.Cliente_residente__c;
                //System.debug('ID RESIDENTE INGRESO: '+Residente);
                //System.debug('ID OPP INGRESO: '+opReingreso.id);
                if (InfoFechasResidentes.get(Residente) != null) {
                    Date fechaPrevistaUltimoIngreso =InfoFechasResidentes.get(Residente).Fecha_prevista_de_ingreso__c;
                    Integer diferencia = fechaPrevistaUltimoIngreso.monthsBetween(avui);
                    System.debug('FECHA PREVISTA ULTIMO INGRESO: '+fechaPrevistaUltimoIngreso);
                    System.debug('DIFERENCIA: '+diferencia);
                    if (diferencia >= 4) {
                        idResidentsEmail.add(Residente);
                        idOpsEmail.add(opReingreso.Id);
                    }
                }
                //Si el residente no está en el map es que no tiene otras oportunidades,
                //por lo tanto, es su primer ingreso y se le tiene que enviar el mail.
                else {
                    idResidentsEmail.add(Residente);
                    idOpsEmail.add(opReingreso.Id);
                }
            }
            if (idResidentsEmail.size()> 0) {
                OrgWideEmailAddress owa = [SELECT id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName = 'Residencia SARquavitae' LIMIT 1];
                System.debug('ENTRA BIENVENIDA!!');
                Map<ID, Oportunidad_platform__c> InfoCentres = new Map<id,Oportunidad_platform__c>();
                Map<id,id> ResidentsiCentres = new Map<id,id>();
                List<id>ATCs = new List<id>();
                Map<id,String> ATCDades = new Map<id,String>();
                for (Oportunidad_platform__c InfoOpp:[SELECT Cliente_Residente__c, residente__c, centro2__c,centro2__r.blog__c,centro2__r.ATC_centro__c,Centro2__r.Comunicacion_con_familias__c  FROM Oportunidad_platform__c where id IN:idOpsEmail]) {
                        if (InfoOpp.residente__c != null){ResidentsiCentres.put(InfoOpp.residente__c, InfoOpp.centro2__c);}
                    	else {ResidentsiCentres.put(InfoOpp.Cliente_Residente__c, InfoOpp.centro2__c);}
                        InfoCentres.put(InfoOpp.centro2__c,InfoOpp);
                        ATCs.add(InfoOpp.centro2__r.ATC_centro__c);
                }
                for (User InfoATC:[SELECT id,email FROM User where id IN:ATCs]) {ATCDades.put(InfoATC.id, InfoATC.email);}   
                //Cargamos las plantillas de bienvenida (catalan y castellano)
                EmailTemplate templateCat = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Bienvenida_Cat' LIMIT 1];
                EmailTemplate templateCast = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Bienvenida_Cast' LIMIT 1];
                EmailTemplate templateEus = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Bienvenida_Eus' LIMIT 1];
                EmailTemplate templateGal = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Bienvenida_Gall' LIMIT 1];
                
               //Declaramos la lista de Tareas, donde guardaremos todas las tareas de los mails enviados.
                List<Task> TaskMails = new List<Task> ();
                //Declaramos la lista de direcciones.
                List<String> adresses = new List<String>();
                //Declaramos la clase auxiliar sendMail.
                SendEmailHelper sendMail = new SendEmailHelper();
                //Declaramos una lista de mails, donde iremos añadiendo todos los emails a enviar
                //y lo enviaremos despues de haber recorrido todos los familiares
                //ya que así no nos pasaremos del límite de 10 llamadas a la funcion sendMail
                List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
                Set<id> ContactosIds = new Set<id>();
                System.debug(idResidents);
                for (Relacion_entre_contactos__c familiar : [SELECT contacto__c,contacto__r.PersonEmail  FROM Relacion_entre_contactos__c WHERE Residente__c IN: idResidents order by residente__c asc]) {
                    if (familiar.contacto__r.PersonEmail != null) {ContactosIds.add(familiar.contacto__c);}
                }
                Map<ID, Contact> ContactoYCuentas = new Map<ID, Contact>();
                for (Contact c: [SELECT AccountId, id FROM Contact where AccountId IN: ContactosIds]) {ContactoYCuentas.put(c.AccountId, c);}
                ContactosIds = null;
                //Obtenemos toda la info de los familiares (Nombre, correo, idioma...) asociados a los residentes de la lista
                //y para cada uno vamos creando la tarea asociada y guardando el mail en la lista de mails.
                for (Relacion_entre_contactos__c familiar : [SELECT id,contacto__r.PersonContactId, contacto__c,residente__c,contacto__r.lastname,residente__r.lastname,residente__r.name,contacto__r.name,contacto__r.PersonEmail,contacto__r.Idioma_de_Contacto__pc FROM Relacion_entre_contactos__c WHERE Residente__c IN: idResidentsEmail order by residente__c asc]) {
                    if (familiar.contacto__r.PersonEmail != null) {
                        // Busca aquesta relació familiar entre IDs de ResidentsiCentres
                        Id CentreActual = ResidentsiCentres.get(familiar.residente__c);
                        Boolean CentroEnviable = false;
     
                        if (InfoCentres.get(CentreActual).centro2__r.Comunicacion_con_familias__c != null){CentroEnviable = InfoCentres.get(CentreActual).centro2__r.Comunicacion_con_familias__c;}
                        if (CentroEnviable == true) {
                            //Dependiendo del idioma del contacto, la plantilla sera una o otra.
                            EmailTemplate template = new EmailTemplate();
                            if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Catalán') {template = templateCat;}
                            else if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Euskera') {template = templateEus;}
                            else if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Gallego') {template = templateGal;}
                            else {template = templateCast;}
                            //Obtenemos todos los datos de la plantilla, y hacemos las sustituciones necesarias
                            String subject = template.Subject;
                            String body = template.HtmlValue;
                            
                            Id IdATC = InfoCentres.get(CentreActual).centro2__r.ATC_centro__c;
                            String AtcEmail = ATCDades.get(IdATC);
                            String blog = InfoCentres.get(CentreActual).centro2__r.Blog__c;

                            if (blog == null) {blog = '';}
                            if (AtcEmail != null) {adresses.add(AtcEmail);}
                            if (CentreActual == '001b000000UFBwQ' || CentreActual == '001b000000UFBwy') {
                                 adresses.add('bmonegal@sarquavitae.es');
                                 adresses.add('vgago@sarquavitae.es');
                                 adresses.add('jvelasco@sarquavitae.es');
                                if (CentreActual == '001b000000UFBwQ') {adresses.add('ahuguet@sarquavitae.es');}
                            }
                            if (CentreActual == '001b000000UFBwF' || CentreActual == '001b000000UFBvo') {adresses.add('jvelasco@sarquavitae.es');}
                            if (CentreActual == '001b000000UFBwW' || CentreActual == '001b000000UFBwl') {adresses.add('vgago@sarquavitae.es');}
                            if (CentreActual == '001b000000UFBw7') adresses.add('bmonegal@sarquavitae.es');
                            
                            body = body.replace('DIRECCION_BLOG',blog );
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            if (CentreActual == '001b000000UFBw7') mail.setBccAddresses(new String[]{'bmonegal@sarquavitae.es'});
                            //mail.setTargetObjectId(ContactoYCuentas.get(familiar.contacto__c).id);
                            mail.setSubject(subject);
                            mail.setHtmlBody(body);
                            mail.setOrgWideEmailAddressId(owa.Id);
                            String[] toAddresses = new String[]{ string.valueOf(familiar.contacto__r.PersonEmail)};
                            mail.setToAddresses(toAddresses);
                            allmails.add(mail);
                            adresses.clear();
                            adresses.add(familiar.contacto__r.PersonEmail);
                            Task tMail = new Task();
                            tMail.Description = body.stripHtmlTags();
                            tMail.Tipo__c = 'Fidelización';
                            tMail.Subtipo__c = 'Seguimiento de Cliente';
                            Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tarea Cliente').getRecordTypeId();
                            tmail.RecordTypeId = devRecordTypeId;
                            tMail.Status = 'Completada';
                            tMail.ActivityDate = avui;
                            tMail.Subject = 'Correo electrónico: Bienvenida Sarquavitae';
                            //El propietario de la tarea serà el admin
                            tMail.OwnerId = '005b0000000kj7H';
                            tMail.Priority = 'Normal';
                            //El whatid está associado al familiar del residente
                            //tMail.WhatId = familiar.contacto__c;                           
                            tMail.WhoId = familiar.contacto__r.PersonContactId;
                            //Añadimos la tarea a la lista, para despues insertarla en la BD
                            tMail.Type = 'Fidelización';
                            TaskMails.add(tMail);
                       }  
                    }
                }
                //Una vez recorridos todos los familiares, insertamos las Tareas y enviamos los mails
                insert TaskMails;
                if(!Test.isRunningTest() && Label.Activacion_comunicacion_familias != 'No') {
                    Messaging.sendEmail(allMails);
                } 
            }
        
            //INSERTS TASKS
            triggerHelper.recursiveHelper1(true);
            insert tasksHV;   
            insert tasksInforme;
            triggerHelper.recursiveHelper1(false);
    } 
}