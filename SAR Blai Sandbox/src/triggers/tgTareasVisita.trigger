/** 
* File Name:   tgTareasVista 
* Description: Crea una tarea para el dia que le corresponde segun el centro, la zona y el creador del evento. 
* Copyright:   Konozca 
* @author:     Sergi Aguilar
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 12/05/2015 Xavier Garcia  Modificar el Trigger para adaptarlo a las oportunidades TA
* =============================================================== 
**/ 
trigger tgTareasVisita on Event (after insert,after update) {
	
	if(triggerHelper.todofalse())
	{
        if (TriggerHelperExecuteOnce.executar9() == true) {
		RecordType ev = [Select Id, Name From RecordType Where Name = 'Evento a Recomendador' LIMIT 1];
	    RecordType cr = [Select Id, Name From RecordType Where Name = 'Contacto Recomendador' LIMIT 1];
	    RecordType tr = [Select Id, Name From RecordType Where Name = 'Tarea Recomendador' LIMIT 1];
	    //cogemos el documento con las tablas
	    List <Document> ld = [Select Id, Name, Body FROM Document WHERE Name = 'Tabla Eventos Visitas' LIMIT 1];
	    Document d = (ld.size() > 0) ? ld.get(0) : null;
	    List<Account> lRec = [Select Id, Name, Clasificacion_tipo_recomendador__c,Clasificacion_tipo_Recomendador_TA__c From Account where RecordTypeId = :cr.Id];
	    
	    List<id> listaRec = new List<id>();
	    for(Account a : lRec){
	        listaRec.add(a.id);
	    }
	    List<id> listaWhatId = new List<id>();
	    for(Event evento : trigger.new) {
	        listaWhatId.add(evento.WhatId);
	    }
	    
	    List<Oportunidad_platform__c> lop = [Select Id, Etapa__c, Centro2__c From Oportunidad_platform__c Where Id In :listaWhatId];
	    List<Oportunidad_platform__c> opUpd = new List<Oportunidad_platform__c>();
	    List<Contact> lCon = [Select Id, Name, AccountId From Contact Where AccountId In :listaRec];
	
	    List<User> users = [Select Id, Name, ProfileId,Profile.name, Email, Zona_Comercial__c, UserRoleId From User];
	    List<Id> centId = new List<Id>();
	    for(Oportunidad_platform__c opor : lop) {
	        centId.add(opor.Centro2__c);
	    }
	    List<Account> centros = [Select Id, Recepcionista__c From Account Where Id in :centId];
	    List<UserRole> urLis = [Select Id, Name From UserRole];
	    
	    //cogemos el texto
	    String tablas = (d!=null) ? d.Body.toString() : '';
	    
	    List<Task> toIns = new List<Task>();
	    
	    for(Event e : trigger.new) {
            System.debug('Activity date: '+e.activityDate);
            System.debug('ASUNTO: '+e.subject);
	        String zona = null; 
	        String tipoR = null;
            String tipoRecTA = null;
	        String license = null;
	        Integer times = null;
            Integer timesTA = null;
            String perfilName = null;
	        //controlamos que el evento sea del tipo que elegimos
	        
	        //e.RecordTypeId == ev.Id        
	        if(e.Subject == 'Visita' && e.Resultado__c == 'Acción Cerrada')
	        {
	            //buscamos el usuario propietario con su licencia
	            boolean usEnc = false;
	                     
	            for(Integer j = 0; j < users.size() && !usEnc; ++j) {
	            
	                if(users[j].Id == e.OwnerId) {
	                    usEnc = true;
	                    Id pro = users[j].UserRoleId;
	                    boolean enc2 = false;
                        perfilName = users[j].Profile.name;
	                    for(integer k = 0; k < urLis.Size() && !enc2; ++k) {
	                        if(urLis[k].Id == pro) {
	                            enc2 = true;
	                            license = urLis[k].Name;
	                        }
	                    }
	                }
	            }
	            
	            boolean enc4 = false;
	            for(integer i = 0; i < lCon.Size() && !enc4; ++i) {
	            	System.debug(lCon[i].Id);
	            	System.debug(e.WhoId);
	                if(lCon[i].Id == e.WhoId) {
	                    boolean accEnc = false;
	                    System.debug(lRec.Size());
	                    for(integer j = 0; j < lRec.Size() && !accEnc; ++j) {
	                        if(lRec[j].Id == lCon[i].AccountId) {
	                            accEnc = true;
	                            tipoR = lRec[j].Clasificacion_tipo_recomendador__c;
                                tipoRecTA = lRec[j].Clasificacion_tipo_Recomendador_TA__c;
	                        }
	                    }
	                    
	                    enc4 = true;    
	                }
	            }
	            //buscamos la zona ya que esta en el usuario relacionado
	            boolean enc5 = false;
	            for(integer l = 0; l < users.Size() && !enc5; ++l) {
	                if(users[l].Id == e.OwnerId) {
	                    zona = users[l].Zona_Comercial__c;
	                    enc5 = true;
	                }
	            }
	            system.debug('zona : ' + zona + ' tipoR: ' + tipoR+  e.WhoId + enc4);
	            String aBuscar = 'No encontrar';
	            //obtenemos el nombre de veces por año del usuario
	            if(license != null && (license.contains('ATC Centro') || license.contains('Director Centro'))) aBuscar = 'El perfil tiene funcion';
	            else aBuscar = 'No es Director Centro ni ATC Centro';
	            System.debug('nom perfil: '+perfilName);
                System.debug('tipo recomendador: '+perfilName);
                if (perfilName.contains('TA') && tipoRecTA != null) {
                    if (tipoRecTA == 'A') {
                        timesTA = 4;
                    }
                    else if (tipoRecTA == 'B') {
                        timesTA = 2;
                    }
                    else if (tipoRecTA == 'C') {
                        timesTA = 1;
                    }
                    else if (tipoRecTA == 'D') {
                        timesTA = 1;
                    }
                }
				if(timesTA != null) {
	                    Task t = new Task();
	                    t.RecordTypeId = tr.Id;
	                    t.Subject = 'Llamada';
	                    t.WhoId = e.WhoId;
	                    t.WhatId = e.WhatId;
	                    t.Status = 'Pendiente';
	                    t.Priority = 'Normal';
	                    t.IsReminderSet = true;
	                    t.OwnerId = e.OwnerId;
	                    t.Description = 'Recordatorio de llamada para concertar la próxima visita.';
	                    t.ReminderDateTime = e.StartDateTime.addDays((365/timesTA)-5);
	                    DateTime dtAuxTA = e.StartDateTime.addDays(365/timesTA);
	                    t.ActivityDate = date.newinstance(dtAuxTA.year(), dtAuxTA.month(), dtAuxTA.day());
	                    toIns.add(t);
	                    
	                }                
                
	            //leemos el documento
	            List<String> lines = tablas.split('\n');
	            integer pos = 0;
	            while(pos < lines.Size() && !lines[pos].contains(aBuscar)) ++pos;
	            pos+=2;
	            while (pos < lines.Size() && zona != null && !lines[pos].contains(zona)) ++pos;
	            if(pos < lines.Size() && zona != null && lines[pos].contains(zona)) {   
	                if(tipoR == 'A') times = integer.valueof(lines[pos].split(',')[1]);
	                if(tipoR == 'B') times = integer.valueof(lines[pos].split(',')[2]);
	                if(tipoR == 'C') times = integer.valueof(lines[pos].split(',')[3]);
	                //creamos la tarea con usando el valor obtenido para la fecha   
	                if(times != null && times != 0) {
	                    Task t = new Task();
	                    t.RecordTypeId = tr.Id;
	                    t.Subject = 'Llamada';
	                    t.WhoId = e.WhoId;
	                    t.WhatId = e.WhatId;
	                    t.Status = 'Pendiente';
	                    t.Priority = 'Normal';
	                    t.IsReminderSet = true;
	                    t.OwnerId = e.OwnerId;
	                    t.Description = 'Recordatorio de llamada para concertar la próxima visita.';
	                    t.ReminderDateTime = e.StartDateTime.addDays((365/times)-5);
	                    DateTime dtAux = e.StartDateTime.addDays(365/times);
	                    t.ActivityDate = date.newinstance(dtAux.year(), dtAux.month(), dtAux.day());
	                    toIns.add(t);
	                    
	                }
	            } 
	            else {
	                //no se ha podido crear la tarea    
	            }
	        }
	        //e.RecordTypeId == '012b0000000QBdeAAG' && 
	         else if(e.Subject == 'Visita concertada' && e.ActivityDate > Date.today().addDays(1)) {
	            Task t2 = new Task();
	            t2.RecordTypeId = '012b0000000QBdPAAW';
	            t2.Subject = 'Recordatorio visita concertada';
	            t2.WhoId = e.WhoId;
	            t2.WhatId = e.WhatId;
	            t2.Status = 'Pendiente';
	            t2.Priority = 'Normal';
	            t2.IsReminderSet = true;
	            t2.Tipo__c = 'Identificación/Captación';
	            t2.Subtipo__c = 'Confirmación Visita';
	            t2.Description = 'Recuerde llamar a la persona de contacto de la oportunidad para avisarle que tiene una visita programada para mañana.';
	            t2.ReminderDateTime = e.StartDateTime.addDays(-1);
	            DateTime dtAux2 = e.StartDateTime.addDays(-1);
	            t2.ActivityDate = date.newinstance(dtAux2.year(), dtAux2.month(), dtAux2.day());
	            Boolean opEnc = false;
	            for(integer j = 0; j < lop.Size() && !opEnc; ++j) {
	                if(e.WhatId == lop[j].Id) {
	                    opEnc = true;
	                    Boolean cenEnc = false;
	                    Id recep = null;
	                    for(integer l = 0; l < centros.Size() && !cenEnc; ++l) {
	                        if(centros[l].Id == lop[j].Centro2__c) {
	                            cenEnc = true;
	                            recep = centros[l].Recepcionista__c;
	                        }
	                    }
	                    if(recep != null) {
	                        t2.OwnerId = recep;
	                        Boolean recEnc = false;
	                        for(integer k = 0; k < users.Size() && !recEnc; ++k) {
	                            if(users[k].Id == recep) {
	                                recEnc = true;
	                                try {
	                                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
	                                    mail.setToAddresses(new List<String>{users[k].Email}); 
	                                    mail.setSubject('Recordatorio Visita concertada'); 
	                                    String body = 'Recuerde que hay una visita concertada con el contacto https://sarquavitae.my.salesforce.com/' + e.WhoId; 
	                                    mail.setPlainTextBody(body); 
	                                    system.debug('recepcionista : ' + users[k].Email + body);
	                                    if(!Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail});
	                                }
	                                catch(Exception exc) {
	                                    system.debug(exc);
	                                }
	                            }
	                        }
	                    }
	                    if(lop[j].Etapa__c == 'Pendiente visita') {
	                        Oportunidad_platform__c op = new Oportunidad_platform__c();
	                        op.Id = e.WhatId;
	                        op.Visita_realizada_en__c = e.Lugar_de_la_visita__c;
	                        op.Etapa__c = 'Visita Planificada / Espontánea';
	                        opUpd.add(op);
	                    }
	                }
	            }
	            toIns.add(t2);
	        }
	    }
            TriggerHelper.recursiveHelper1(true);
	    insert toIns;
	    update opUpd;
            TriggerHelper.recursiveHelper1(false);
	}	
	}	
    
}