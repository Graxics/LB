/** 
* File Name:   tgCreacioTareaCATINFO 
* Description: Controla que el DNI no exista ya
* Copyright:   Konozca 
* @author:     Sergi Aguilar
* Modification Log 
* =============================================================== 
*    Date        Author       Modification 
* 13/05/2015 Xavier Garcia    Modificar el Trigger para adaptarlo a las oportunidades TA
* 02/06/2015 Eugenio Barrero  Cambiar el caso: "Taska Tp: "Cat Información" Asunto:"Interes centro"
*                             para anular el correo que se envia ahora, por una oportunidad abierta
*                    Marca: //Nº2 
*01/09/2015  Cristina&Eugenio Asignar "Creada por el sistema" a la etapa en el caso "Interes centro"
*                Marca //Nº3
*09/09/2015  Cristina&Eugenio Quitamos la modificación //Nº3, el estado de la oportunidad debe ser el asignado por defecto
*16/09/2015  Eugenio           Incidencia: En algunas ocasiones las oportunidades generdas tras una taska "Interés centro"
*                             En test funciona sin excepciones. añado debug's
*11/03/2016            Modificación del trigger para que creee una oportunidad tambíen cuando se modifique una tarea existente. (Líneas afectadas: 117-170)
*13/04/2016  Alexander Shubin  Agregar el campo Prioridad a las oportunidades que provienen de tareas CAT INFO
*14/04/2016 Alexander Shubin  Modificar la persona que envía los emails: Se ha creado una nueva oportunidad en salesforce
* =============================================================== 
**/ 
trigger tgCreacioTareaCATINFO on Task (after insert, after update) {
    system.debug('TRIGGER@tgCreacioTareaCATINFO');
    if(triggerHelper.todofalse()) {
        if (TriggerHelperExecuteOnce.executar6() == true) {
        List<User> users = [Select Id, Name, Email, UserRole.Name, Zona_Comercial__c From User];
        //lista de tareas a insertar
        List<Task> lt = new List<Task>();
        List<Oportunidad_platform__c> InsertOps = new List<Oportunidad_platform__c>();
        List<Id> cent = new List<Id>();
        List<id> TareasInfo = new List<id>();
      List<id> TareasInfoATC = new List<id>();
        List<id> TareasInfoATCZona = new List<id>();
      List<Task> InsertTareasATC = new List<Task>();
        List<Task> InsertTareasRec = new List<Task>();
        Profile profileCat = [Select id from profile where name = 'CAT' LIMIT 1];
        Map<id,Task> TasquesCorreuCentro = new Map<id,Task>();
        Map<id,Task> TasquesCorreuZonaComercial = new Map<id,Task>();
        Map<id,id> TasquesWhatid = new Map<id,id>();
        Map<id,Oportunidad_platform__c> opsInsert = new Map<id,Oportunidad_platform__c>();
        Map<id,Account> TasquesWhatName = new Map<id,Account>();
        Map<id,id> TasquesServicio = new Map<id,id>();
        Map<id,id> TasquesNOC = new Map<id,id>();
        Map<id,String> TasquesServicioName = new Map<id,String>();
        Map<id,String> TasquesNOCName = new Map<id,String>();
        Map<id,Account> TasquesInfoCentro = new Map<id,Account>();
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        Map<id,Oportunidad_platform__c> TasquesOpp = new Map<id,Oportunidad_platform__c>();
        Map<id,Oportunidad_platform__c> TasquesOppInfo = new Map<id,Oportunidad_platform__c>();
        List<id> OpsTasks = new List<id>();
        List<String> MailsZona = new List<String>();
        String DescProc;
        for(Task t : trigger.new) {
            cent.add(t.WhatId);
            //Si la Tarea tiene Tipo Registro = Cat info, tendremos que hacer una serie de acciones
            if (t.recordtypeid == '012b0000000QBdA') {
                //Si la tarea tiene como asunto Oportunidad TA y pasa a estado Completada tendremos que crear una nueva oportunidad TA
                //en etapa Abierta con los datos de la Tarea
                if (Trigger.isInsert) {
                    if (t.Subject == 'Oportunidad TA') {
                        //TareasInfo.add(t.id);
                        Oportunidad_platform__c op = new Oportunidad_platform__c();
                        op.Prioridad__c = t.Priority;
                        op.Medios_de_comunicacion__c = t.Medios_de_comunicacion__c;
                        op.servicio__c = t.Servicio_TA__c;
                        op.Detalle_medios_de_comunicacion__c = t.Detalle_medios_de_comunicacion__c;
                        op.etapa__c = 'Creada por el sistema';
                        op.Campana__c = t.Campana__c;
                        op.Central__c = t.Centro_residencial__c;
                        op.Procedencia__c = t.Procedencia__c;
                        op.Pagina_web__c = t.Pagina_web__c;
                        op.canal__c = t.canal__c;
                        op.IsFromTask__c = true;
                        op.Persona_de_Contacto__c = t.WhatId;  //desactivar en test
                        if (t.Entidad_Recomendadora__c != null) {op.Descripcion_procedencia__c = t.Entidad_Recomendadora__c;}
                        if (t.Centro_de_procedencia__c != null) {op.Descripcion_procedencia__c = t.Centro_de_procedencia__c;}
                        if (t.Empleado_recomendador__c != null) {op.Descripcion_procedencia__c = t.Empleado_recomendador__c;}
                        if (t.Cliente_Recomendador__c   != null) {op.Descripcion_procedencia__c = t.Cliente_Recomendador__c;}
                        if (t.Contacto_Recomendador__c != null) {
                            if (op.Descripcion_procedencia__c == null) {op.Descripcion_procedencia__c = t.Contacto_Recomendador__c;}
                            else {op.Descripcion_procedencia__c += ' - '+t.Contacto_Recomendador__c;}   
                        }
                        if (t.Subclasificacion__c == 'Fijo') {op.RecordTypeId = Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TAD').getRecordTypeId();}
                        else if (t.Subclasificacion__c == 'Móvil') {op.RecordTypeId = Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TAM').getRecordTypeId();}
                        else {
                            op.RecordTypeId = Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TA Dúo').getRecordTypeId();
                        }
                        system.debug('op.OwnerId:' + op.OwnerId);
                        InsertOps.add(op);
                    }
                    //Si la Tarea tiene como asunto Interés residencias de una Zona Comercial nos guardamos el id de la tarea en una lista de id
                    //Ya que necesitamos obtener el ATC zona relacionada con la tarea
                    if (t.Subject == 'Interés residencias de una Zona Comercial' && t.Status == 'Completada') {TareasInfoATCZona.add(t.id);}
                }
                else if (Trigger.isUpdate) {
                    Task OldTask = Trigger.oldMap.get(t.Id);
                    //Si la tarea tiene como asunto Oportunidad TA y pasa a estado Completada tendremos que crear una nueva oportunidad TA
                  //en etapa Abierta con los datos de la Tarea
                    if (t.Subject == 'Oportunidad TA' && t.Status == 'Completada' && OldTask.Status != 'Completada') {
                        //TareasInfo.add(t.id); 
                        Oportunidad_platform__c op = new Oportunidad_platform__c();
                        op.Prioridad__c = t.Priority;
                        op.servicio__c = t.Servicio_TA__c;
                        op.Medios_de_comunicacion__c = t.Medios_de_comunicacion__c;
                        op.etapa__c = 'Creada por el sistema';
                        op.Campana__c = t.Campana__c;
                        op.Detalle_medios_de_comunicacion__c = t.Detalle_medios_de_comunicacion__c;
                        op.Central__c = t.Centro_residencial__c;
                        op.Procedencia__c = t.Procedencia__c;
                        op.Pagina_web__c = t.Pagina_web__c;
                        op.canal__c = t.canal__c;
                        op.IsFromTask__c = true;
                        op.Persona_de_Contacto__c = t.WhatId;
                        if (t.Entidad_Recomendadora__c != null) {op.Descripcion_procedencia__c = t.Entidad_Recomendadora__c;}
                        if (t.Empleado_recomendador__c != null) {op.Descripcion_procedencia__c = t.Empleado_recomendador__c;}
                        if (t.Centro_de_procedencia__c != null) {op.Descripcion_procedencia__c = t.Centro_de_procedencia__c;}
                        if (t.Cliente_Recomendador__c   != null) {op.Descripcion_procedencia__c = t.Cliente_Recomendador__c;}
                        if (t.Contacto_Recomendador__c != null) {
                            if (op.Descripcion_procedencia__c == null) {op.Descripcion_procedencia__c = t.Contacto_Recomendador__c;}
                            else {op.Descripcion_procedencia__c += ' - '+t.Contacto_Recomendador__c;}    
                        }
                        
                        if (t.Subclasificacion__c == 'Fijo') {op.RecordTypeId = Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TAD').getRecordTypeId();
                        }
                        else if (t.Subclasificacion__c == 'Móvil') {op.RecordTypeId = Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TAM').getRecordTypeId();
                        }
                        else {op.RecordTypeId =Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TA Dúo').getRecordTypeId();
                        }
                        system.debug('op.OwnerId:' + op.OwnerId);
                        
                        InsertOps.add(op);
                    }
                    //Si la Tarea tiene como asunto Interes Centro nos guardamos el id de la tarea en una lista de id
                    //Ya que necesitamos obtener el ATC del centro relacionado con la tarea
                    /*if ((OldTask.Status != t.Status ||OldTask.Subject != t.Subject) && t.Status == 'Completada' && t.Subject == 'Interés centro') {
                        TareasInfoATC.add(t.id);   
                    }*/
                    //Si la Tarea tiene como asunto Interés residencias de una Zona Comercial nos guardamos el id de la tarea en una lista de id
                    //Ya que necesitamos obtener el ATC zona relacionada con la tarea
                    if ((OldTask.Status != t.Status ||OldTask.Subject != t.Subject) && t.Status == 'Completada' && t.Subject == 'Interés residencias de una Zona Comercial') {TareasInfoATCZona.add(t.id);   
                    }
                }
            }
        }
       
        Map<id,Task> TaskAtcs = new Map<id,Task>();
        Map<id,Task> TaskZones = new Map<id,Task>();
     
        //Para cada Tarea con Asunto Interés residencias de una Zona Comercial nos guardamos en un Map la asociacion idTarea-Tarea
        // ya que a partir del id podemos obtener todos los campos de la tarea (incluido el ATC Zona relacionada con la tarea)
        for (Task t:[Select id,tipo__c,resultado__c,whatid,zona_comercial__c,subject,Servicio_TA__c,Servicio_TA__r.Servicio__c,Campana__c,Centro_residencial__c,Centro_residencial__r.ATC_Zona__c,Procedencia__c,Pagina_web__c,canal__c from Task where id IN:TareasInfoATCZona]) {
              TaskZones.put(t.id,t);    
      }
        for (Task t:Trigger.new) {
            if (TaskZones.get(t.id) != null) {
                Task tNew = new Task();
                tNew = t.clone(false);
                tNew.OwnerId = TaskZones.get(t.id).Centro_residencial__r.ATC_Zona__c;
                tNew.Status = 'Pendiente';
                system.debug('tNew.OwnerId:' + tNew.OwnerId);
                InsertTareasATC.add(tNew);
            }
        }
        system.debug('Modificación: Nº2');
        List<Account> centros= [Select Id, Name, Director_del_centro__c,Director_del_centro__r.email, ATC_Zona__c,ATC_Zona__r.email, ATC_Centro__c,ATC_Centro2__c,ATC_Centro2__r.email,ATC_Centro3__c,ATC_Centro3__r.email,ATC_Centro4__c,ATC_Centro4__r.email,ATC_Centro5__c,ATC_Centro5__r.email,ATC_Centro__r.email, Zona_Comercial_del__c From Account Where RecordTypeId = '012b0000000QAeAAAW'] ;
        System.debug('Centro:' + centros.Size());

        Oportunidad_platform__c newOpp;
        Boolean enc = false;
        for(Task t : trigger.new) {
            
            Boolean taskChanged = true;
            if (Trigger.isUpdate) {
                Task oldT = Trigger.oldMap.get(t.Id);
                taskChanged =  (t.Subject != oldT.Subject ||  t.Status != oldT.Status);
            }
                
                
            system.debug('t.RecordTypeId:' + t.RecordTypeId);
            system.debug('t.Subject:' + t.Subject);
            system.debug('t.Status:' +  t.Status);
            if(t.RecordTypeId == '012b0000000QBdAAAW' && t.Subject == 'Interés centro' &&  t.Status == 'Completada' && taskChanged) {
                
                //Nº2 Nuevo Código
                system.debug('Crear Op desde Taska "Cat-Información y Asunto "Interes centro"');
                newOpp = new Oportunidad_platform__c();
                if(t.Tipo_de_servicio__c=='Público')  newOpp.RecordTypeId= Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad pública').getRecordTypeId(); 
                if(t.Tipo_de_servicio__c=='Privado')  newOpp.RecordTypeId= Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad privada').getRecordTypeId();   
        //newOpp.etapa__c = 'Creada por el sistema'; //Nº3
        newOpp.Prioridad__c = t.Priority;
                newOpp.ambito__c='Residencial';
                newOpp.Canal__c = t.Canal__c;
                newOpp.Detalle_medios_de_comunicacion__c = t.Detalle_medios_de_comunicacion__c;
                newOpp.Medios_de_comunicacion__c = t.Medios_de_comunicacion__c;
                newOpp.Procedencia__c = t.Procedencia__c;
                newOpp.Descripcion_procedencia__c='';
                newOpp.Pagina_web__c = t.Pagina_web__c;
                newOpp.Campana__c = t.Campana__c;
                newOpp.Servicio__c = t.Servicio_TA__c;
                if (t.Entidad_Recomendadora__c != null) {
                    newOpp.Descripcion_procedencia__c = t.Entidad_Recomendadora__c;
                }
                if (t.Empleado_recomendador__c != null) {
                    newOpp.Descripcion_procedencia__c = t.Empleado_recomendador__c;
                }
                if (t.Centro_de_procedencia__c != null) {
                    newOpp.Descripcion_procedencia__c = t.Centro_de_procedencia__c;
                }
                if (t.Cliente_Recomendador__c   != null) {
                    newOpp.Descripcion_procedencia__c = t.Cliente_Recomendador__c;
                }
                if (t.Contacto_Recomendador__c != null) {
                    if (newOpp.Descripcion_procedencia__c == null) {
                        newOpp.Descripcion_procedencia__c = t.Contacto_Recomendador__c;
                    }
                    else {
                        newOpp.Descripcion_procedencia__c += ' - '+t.Contacto_Recomendador__c;
                    }
                    
                }
                //newOpp.Tipo_Servicio__c=  t.Tipo_de_servicio__c ;
                newOpp.IsFromTask__c=true;
                newOpp.Persona_de_Contacto__c = t.WhatId; // desactivar en test
                
        newOpp.Centro2__c=t.Centro_residencial__c;
                DescProc = newOpp.Descripcion_procedencia__c;
               
                for(integer i = 0; i < centros.Size() && !enc; ++i) {
                    if(centros[i].Id == t.Centro_residencial__c) {
                        enc = true;
                        newOpp.OwnerId = centros[i].Director_del_centro__c;
                        System.debug('ALEX CENTRO SI');
                        if (UserInfo.getProfileId() == profileCat.id) {
                            System.debug('ALEX PERFIL SI');
                            newOpp.OwnerId = centros[i].ATC_Centro__c;
                            TasquesCorreuCentro.put(t.id,t);
                            TasquesWhatid.put(t.id,t.WhatId);
                            TasquesInfoCentro.put(centros[i].id, centros[i]);
                            //TasquesWhoid.put(t.id,t.WhoId);
                            if (t.Servicio_TA__c != null) {
                                TasquesServicio.put(t.id,t.Servicio_TA__c);
                            }
                            if (t.Campana__c != null) {
                                TasquesNOC.put(t.id,t.Campana__c);
                            }
                        }
                    }
                }
                if (newOpp.RecordTypeId == '012b0000000QBG1') {   //Oportunidad pública
                    insert newOpp;
                    TasquesOpp.put(t.id,newOpp);
                    OpsTasks.add(newOpp.id);
                    Task tRecordatorio = new Task();
                    tRecordatorio.Description = 'Se le ha asignado una nueva oportunidad en salesforce';
                    tRecordatorio.Status = 'Pendiente';
                    tRecordatorio.ActivityDate = Date.today().addDays(2);
                    tRecordatorio.Subject = 'Se le ha asignado una nueva oportunidad en salesforce';
                    tRecordatorio.OwnerId = newOpp.OwnerId;
                    tRecordatorio.Priority = 'Normal';
                    tRecordatorio.WhatId = newOpp.id;
                    tRecordatorio.WhoId = t.WhoId;
                    tRecordatorio.recordtypeid = '012b0000000QBdPAAW';
                    tRecordatorio.IsFromTrigger__c = true;
                    InsertTareasRec.add(tRecordatorio);
                    
                }
                else {
                  opsInsert.put(t.id,newOpp);
                }
            }
            else if(t.RecordTypeId == '012b0000000QBdAAAW' && t.Subject == 'Interés residencias de una Zona Comercial') {
                List<String> mails = new List<String>();
                Task tknew = t.clone();
                tknew.Id = null;
                tknew.ActivityDate= date.today();
                tknew.status= 'Pendiente';
                tknew.Description = 'Una persona ha llamado al CAT preguntando por nuestro servicio. Póngase en contacto con ella.';
                
                //buscamos el centro al que la tarea está asociada
                for(integer i = 0; i < users.Size(); ++i) {
                    if(users[i].UserRole.Name != null && users[i].UserRole.Name.contains('ATC Zona') && t.Zona_Comercial__c == users[i].Zona_Comercial__c) {
                        mails.add(users[i].Email);
                        tknew.OwnerId = users[i].Id;
                        if (UserInfo.getProfileId() == profileCat.id) {
                            MailsZona.add(users[i].Email);
                            TasquesCorreuZonaComercial.put(t.id,t);
                            TasquesWhatid.put(t.id,t.WhatId);
                            //TasquesWhoid.put(t.id,t.WhoId);
                            if (t.Servicio_TA__c != null) {
                                TasquesServicio.put(t.id,t.Servicio_TA__c);
                            }
                            if (t.Campana__c != null) {
                                TasquesNOC.put(t.id,t.Campana__c);
                            }
                        }
                    }
                }
                if(mails.Size() == 0){
                    t.addError('No existe ningún ATC_Zona con la zona comercial indicada.');
                }
                lt.add(tknew);          
             
            }
        }
        for (Account PC:[select id,name,personEmail,phone,PersonMobilePhone from Account where id IN:TasquesWhatid.values()]) {
            TasquesWhatName.put(PC.id, PC);
        }
        for (Servicio__c sv:[select id,name from Servicio__c where id IN:TasquesServicio.values()]) {
            TasquesServicioName.put(sv.id, sv.name);
        }
        for (NOC__c campana:[select id,name from NOC__c where id IN:TasquesNoc.values()]) {
            TasquesNOCName.put(campana.id, campana.name);
        }
        system.debug('opsInsert.size()=' + opsInsert.size());  
        insert opsInsert.values();
        for (Oportunidad_platform__c op: opsInsert.values())  system.debug('op.id:' + op.id);        
        List<String> AdressesTo= new List<String>();
        List<String> AdressesCC = new List<String>();
        
        for (id TaskId:opsInsert.keySet()) {
            TasquesOpp.put(TaskId,opsInsert.get(TaskId));
            OpsTasks.add(newOpp.id);
        }
        for (Oportunidad_platform__c op:[select id,name from Oportunidad_platform__c where id IN:OpsTasks]) {
            TasquesOppInfo.put(op.id, op);
        }
        String BaseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        
        // Agregando el correo verificado de la empresa
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'cat@sarquavitae.es'];
            
        for (Task t:TasquesCorreuCentro.values()) {
            id idOp = TasquesOpp.get(t.Id).id;
            String opName = TasquesOppInfo.get(idOp).name;
            String body = '<p>Se ha creado la oportunidad <a href = '+BaseUrl+TasquesOpp.get(t.Id).id+'>'+opName+'</a> a partir de una tarea CAT-Información con la siguiente información: <p>';
            //String body = '<p>Se ha creado la oportunidad '+BaseUrl+TasquesOpp.get(t.Id).id+' a partir de una tarea CAT-Información con la siguiente información: <p>';
            String subject = 'Se ha creado una nueva oportunidad en salesforce';
            if (TasquesInfoCentro.get(t.Centro_residencial__c) != null) {
                body += '<p>Asunto: '+t.Subject+'<p>';
                body += '<p>Centro residencial: '+TasquesInfoCentro.get(t.Centro_residencial__c).name+'<p>';
                body += '<p>Persona de contacto: '+TasquesWhatName.get(t.WhatId).name+'<p>';
                if (TasquesWhatName.get(t.WhatId).personEmail != null) {
                     body += '<p>Correo electrónico contacto: '+TasquesWhatName.get(t.WhatId).personEmail+'<p>';
                }
                if (TasquesWhatName.get(t.WhatId).phone != null) {
                     body += '<p>Teléfono contacto: '+TasquesWhatName.get(t.WhatId).phone+'<p>';
                }
                if (TasquesWhatName.get(t.WhatId).PersonMobilePhone != null) {
                     body += '<p>Teléfono móbil contacto: '+TasquesWhatName.get(t.WhatId).PersonMobilePhone+'<p>';
                }
                if (t.Zona_Comercial__c != null) {
                     body += '<p>Zona comercial: '+t.Zona_Comercial__c+'<p>';
                }
                if (t.Canal__c != null) {
                    body += '<p>Canal: '+t.Canal__c+'<p>';
                }
                body += '<p>Recurso: '+t.Recurso__c+'<p>';
                if (t.Servicio_TA__c != null) {
                    body += '<p>Servicio: '+TasquesServicioName.get(t.Servicio_TA__c)+'<p>';
                }
                if (t.Campana__c != null) {
                    body += '<p>Campaña: '+TasquesNOCName.get(t.Campana__c)+'<p>';
                }
                if (t.Tipo_de_servicio__c != null) {
                    body += '<p>Tipo de servicio: '+t.Tipo_de_servicio__c+'<p>';
                }
                if (t.Procedencia__c != null) {
                    body += '<p>Procedencia: '+t.Procedencia__c+'<p>';
                }
                if (DescProc != null && DescProc != '') {
                    body += '<p>Descripción procedencia: '+DescProc+'<p>';
                }
                if (t.Medios_de_comunicacion__c != null) {
                    body += '<p>Medios de comunicación: '+t.Medios_de_comunicacion__c+'<p>';
                }
                if (t.Detalle_medios_de_comunicacion__c != null) {
                     body += '<p>Detalle Medios de comunicación: '+t.Detalle_medios_de_comunicacion__c+'<p>';
                }
                AdressesCC.add(TasquesInfoCentro.get(t.Centro_residencial__c).Director_del_centro__r.email);
                AdressesTo.add(TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Centro__r.email);
                if (TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Centro2__c != null) {
                    AdressesCC.add(TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Centro2__r.email);
                }
                if (TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Centro3__c != null) {
                    AdressesCC.add(TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Centro3__r.email);
                }
                if (TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Centro4__c != null) {
                    AdressesCC.add(TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Centro4__r.email);
                }
                if (TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Centro5__c != null) {
                    AdressesCC.add(TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Centro5__r.email);
                }
                if (TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Zona__c != null) {
                    AdressesCC.add(TasquesInfoCentro.get(t.Centro_residencial__c).ATC_Zona__r.email);
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(AdressesTo);
                mail.setCcAddresses(AdressesCC);
                
                mail.setSubject(subject);
                mail.setHtmlBody(body);
                if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
                
                System.debug ('ALEX ' + mail.getOrgWideEmailAddressId());
                // Specify the address used when the recipients reply to the email.  
        mail.setReplyTo('cat@sarquavitae.es');
        // Specify the name used as the display name. 
        //mail.setSenderDisplayName('SAR QUAVITAE');
                allmails.add(mail);
                AdressesCC.clear();
                AdressesTo.clear();
                
            } 
            
        }
        for (Task t:TasquesCorreuZonaComercial.values()) {
            String body = '<p>Se ha creado una nueva tarea CAT-información con la siguiente información: <p>';
            String subject = 'Se ha creado una nueva tarea CAT-información con asunto Interés residencias de una Zona Comercial en salesforce';
                body += '<p>Asunto: '+t.Subject+'<p>';
                body += '<p>Persona de contacto: '+TasquesWhatName.get(t.WhatId).name+'<p>';
                if (TasquesWhatName.get(t.WhatId).personEmail != null) {
                         body += '<p>Correo electrónico contacto: '+TasquesWhatName.get(t.WhatId).personEmail+'<p>';
                }
                if (TasquesWhatName.get(t.WhatId).phone != null) {
                     body += '<p>Teléfono contacto: '+TasquesWhatName.get(t.WhatId).phone+'<p>';
                }
                if (TasquesWhatName.get(t.WhatId).PersonMobilePhone != null) {
                     body += '<p>Teléfono móbil contacto: '+TasquesWhatName.get(t.WhatId).PersonMobilePhone+'<p>';
                }
                body += '<p>Zona comercial: '+t.Zona_Comercial__c+'<p>';
              if (t.Canal__c != null) {
                    body += '<p>Canal: '+t.Canal__c+'<p>';
                }
                body += '<p>Recurso: '+t.Recurso__c+'<p>';
                if (t.Servicio_TA__c != null) {
                    body += '<p>Servicio: '+TasquesServicioName.get(t.Servicio_TA__c)+'<p>';
                }
                if (t.Campana__c != null) {
                    body += '<p>Campaña: '+TasquesNOCName.get(t.Campana__c)+'<p>';
                }
                if (t.Tipo_de_servicio__c != null) {
                    body += '<p>Tipo de servicio: '+t.Tipo_de_servicio__c+'<p>';
                }
                if (t.Procedencia__c != null) {
                    body += '<p>Procedencia: '+t.Procedencia__c+'<p>';
                }
                if (t.Medios_de_comunicacion__c != null) {
                    body += '<p>Medios de comunicación: '+t.Medios_de_comunicacion__c+'<p>';
                }
                if (t.Detalle_medios_de_comunicacion__c != null) {
                     body += '<p>Detalle Medios de comunicación: '+t.Detalle_medios_de_comunicacion__c+'<p>';
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setBccAddresses(MailsZona);
                mail.setSubject(subject);
                mail.setHtmlBody(body);
                allmails.add(mail);
              
                
            
        }
        if (allMails.size() > 0 && !Test.isRunningTest()) {
          Messaging.sendEmail(allMails);
        }

        system.debug('allMails size = ' + allMails.size());
        
       // insert lt;
        system.debug('InsertOps:' + InsertOps.size());
        insert InsertOps;
        system.debug(' InsertTareasATC:' +  InsertTareasATC.size());
      //insert InsertTareasATC;
      insert InsertTareasRec;
        triggerHelper.setTodoFalse();
        //system.debug(emails);
        //if(!Test.isRunningTest() && emails.size() > 0) Messaging.sendEmail(emails);
    }
}
}