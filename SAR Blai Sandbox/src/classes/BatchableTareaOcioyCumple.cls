/** 
* File Name:   BatchableTareaOcioyCumple 
* Description: Batchable que es crida el 1 de cada mes i que crea les
Tareas d'actualitzacio de la agenda de ocio i les de cumpleaños
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		22/01/2015  Xavier Garcia
* =============================================================== 
**/ 
global class BatchableTareaOcioyCumple implements Database.Batchable<SObject>, Database.AllowsCallouts {
	global String glstrQuery;
    //Llista on es guardarà el resultat de la query
    global List <Account> Centres;
    //Declarem la llista de tareas de ocio que s'insertaran a la BD
    global List <Task> TasksOcio = new List<Task>();
    //Declarem la llista de tareas de cumpleaños que s'insertaran a la BD
    global List <Task> TasksCumple = new List<Task>();
    //La data de vencimiento de les tareas serà de 7? dies
    global Date avui = Date.today();
    global Integer mesActual = avui.month();
    global Integer anyActual = avui.year();
    global Date vencimiento2 = date.newinstance(anyActual, mesActual+1, 1);
    global Date vencimiento = avui.addDays(7);
    global id rt= '012b0000000QAeA';
    //Obtenim els ATC de tots els comptes
    global BatchableTareaOcioyCumple() {
        glstrQuery = 'SELECT id ,name,RecordTypeId, ATC_Centro__c,ATC_Centro__r.email,ATC_Centro__r.name,ATC_Centro2__c,ATC_Centro3__c,Comunicacion_con_familias__c FROM Account where RecordTypeId = :rt';
    }
    //Funció start del batch
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        return Database.getQuerylocator(glstrQuery);
    }
    //Funció execute del batch
    global void execute(Database.BatchableContext bcMain, List<Account> lstBatchRecords) {
        //Guardem a la llista d'accounts el resultat de la consulta
        Centres = lstBatchRecords;
        Boolean existeix = false;
        if (mesActual == 12) {
        	vencimiento2 = date.newinstance(anyActual+1, 1, 1);
    	}
        Map<id,Account> infoCentres = new Map<id,Account>();
        //Recorrem totes les comptes i creem les tareas si el tipus de registre es de tipus "Centro" 
        //i el ATC del centre no es null
        for (Account centre:Centres) {
            if (centre.ATC_Centro__c !=null && centre.Comunicacion_con_familias__c == true) {
                //Guardem els ATCs en variables de tipus Id
                Id Atc1 = centre.ATC_Centro__c;
                Id Atc2 = centre.ATC_Centro2__c;
                Id Atc3 = centre.ATC_Centro3__c;
                Id Idcentre = centre.Id;
                //Creem les tareas de Ocio
                Task tOcio = new Task();
                tOcio.Description = 'URGENTE ¡¡¡Actualiza la agenda de ocio del próximo mes en vuestro blog antes del día 1!!! El día 1 todos los familiares de los residentes recibirán una notificación automática de acceso para consultar las nuevas actividades. Si la agenda no está actualizada ofrecerás una mala imagen de tu centro y de la compañía a los familiares.';
                tOcio.Status = 'Pendiente';
                tOcio.ActivityDate = vencimiento2;
                tOcio.Subject = 'Actualizar blog Agenda de ocio y tiempo libre';
                tOcio.OwnerId = Atc1;
                tOcio.Priority = 'Normal';
                //El whatid està associat al centre
                tOcio.WhatId = Idcentre;
                //Afegim la tarea a la llista de tareas per posteriorment, insertar-les a la BD
                TasksOcio.add(tOcio);
                
                 //Creem les tareas de Cumpleaños
                Task tCumple = new Task();
                tCumple.Description = 'AVISO:  Recuerda publicar en el blog día y hora de las actividades programadas para la celebración del cumpleaños mensual.Una vez rellenado, cierra la tarea para que automáticamente se envíe a todos los familiares de los residentes que cumplan años este mes el e-mail de acceso al blog para consultar las actividades de celebración. Si la agenda no está actualizada ofrecerás una mala imagen de tu centro y de la compañía a los familiares.';
                tCumple.Status = 'Pendiente';
                tCumple.ActivityDate = vencimiento2;
                tCumple.Subject = 'Actualizar blog Actividad cumpleaños';
                tCumple.OwnerId = Atc1;
                tCumple.Priority = 'Normal';
                //El whatid està associat al centre
                tCumple.WhatId = Idcentre;
                //Afegim la tarea a la llista de tareas per posteriorment, insertar-les a la BD
                TasksCumple.add(tCumple);
                //Si s'han creat les tareas les podrem insertar a la BD.
            	existeix = true;
                infoCentres.put(Idcentre, centre);
                
           	}
        }
        //Tenemos que insertar las tareas en la BD y, ademas, enviar un correo electrónico al ATC de cada centro
        //informandole que se le ha asignado la tarea. En los triggers eso no hace falta porque se hace automaticamente
        //pero en los batch no lo hace.
        if (existeix) {
            List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
            List<String> adresses = new List<String>();
            EmailTemplate template = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Nueva_tarea_batch' LIMIT 1];
            insert TasksOcio;
            for (Task tocio:TasksOcio ) {
                if (infoCentres.get(tocio.WhatId) != null) {
                    if (infoCentres.get(tocio.WhatId).ATC_Centro__r.email != null && infoCentres.get(tocio.WhatId).Comunicacion_con_familias__c == true) {
                        String emailAdress = infoCentres.get(tocio.WhatId).ATC_Centro__r.email;
                        String urlBase = URL.getSalesforceBaseUrl().toExternalForm();
                        adresses.add(emailAdress);
                        String subjectOcio = template.Subject;
                        String bodyOcio = template.HtmlValue;
                        String ActivityDte = String.valueOf(tOcio.ActivityDate);
                        String[] separa = ActivityDte.split('-');
                        String ActDateMostra = separa[2]+'/'+separa[1]+'/'+separa[0];
                        subjectOcio =subjectOcio.replace('ASUNTO_TAREA', tOcio.Subject);
                        bodyOcio =bodyOcio.replace('ATC_CENTRO', infoCentres.get(tocio.WhatId).ATC_Centro__r.name);
                        bodyOcio =bodyOcio.replace('NOMBRE_CENTRO', infoCentres.get(tocio.WhatId).name);
                        bodyOcio =bodyOcio.replace('FECHA_VENCIMIENTO_TAREA', ActDateMostra);
                        bodyOcio =bodyOcio.replace('NOMBRE_ASUNTO_TAREA', tOcio.Subject);
                        bodyOcio =bodyOcio.replace('PRIORIDAD_TAREA', tOcio.Priority);
                        bodyOcio =bodyOcio.replace('URGENTE_COMENTARIOS', 'URGENTE ¡¡¡Actualiza la agenda de ocio del próximo mes en vuestro blog antes del día 1!!!');
                        bodyOcio =bodyOcio.replace('COMENTARIOS_TAREA', 'El día 1 todos los familiares de los residentes recibirán una notificación automática de acceso para consultar las nuevas actividades. ');
                        bodyOcio =bodyOcio.replace('NEGRITA_COMENTARIOS', 'Si la agenda no está actualizada ofrecerás una mala imagen de tu centro y de la compañía a los familiares.');
                        bodyOcio =bodyOcio.replace('LINK_TAREA_BATCH', urlBase+'/'+tocio.Id);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setBccAddresses(adresses);
                        mail.setSubject(subjectOcio);
                        mail.setHtmlBody(bodyOcio);
                        allmails.add(mail);
                        adresses.clear();
                     }  
                }
            }
            insert TasksCumple;
            for (Task tcumple:TasksCumple ) {
                if (infoCentres.get(tcumple.WhatId) != null) {
                    if (infoCentres.get(tcumple.WhatId).ATC_Centro__r.email != null && infoCentres.get(tcumple.WhatId).Comunicacion_con_familias__c == true) {
                        String emailAdress = infoCentres.get(tcumple.WhatId).ATC_Centro__r.email;
                        String urlBase = URL.getSalesforceBaseUrl().toExternalForm();
                        System.debug('EMAIL ADRESS: '+emailAdress);
                        System.debug('url base: '+urlBase);
                        adresses.add(emailAdress);
                        String subjectCumple = template.Subject;
                        String bodyCumple = template.HtmlValue;
                        String ActivityDte = String.valueOf(tcumple.ActivityDate);
                        String[] separa = ActivityDte.split('-');
                        String ActDateMostra = separa[2]+'/'+separa[1]+'/'+separa[0];
                        subjectCumple =subjectCumple.replace('ASUNTO_TAREA', tcumple.Subject);
                        bodyCumple =bodyCumple.replace('ATC_CENTRO', infoCentres.get(tcumple.WhatId).ATC_Centro__r.name);
                        bodyCumple =bodyCumple.replace('NOMBRE_CENTRO', infoCentres.get(tcumple.WhatId).name);
                        bodyCumple =bodyCumple.replace('FECHA_VENCIMIENTO_TAREA', ActDateMostra);
                        bodyCumple =bodyCumple.replace('NOMBRE_ASUNTO_TAREA', tcumple.Subject);
                        bodyCumple =bodyCumple.replace('PRIORIDAD_TAREA', tcumple.Priority);
                        bodyCumple =bodyCumple.replace('URGENTE_COMENTARIOS', 'AVISO:  Recuerda publicar en el blog día y hora de las actividades programadas para la celebración del cumpleaños mensual.');
                        bodyCumple =bodyCumple.replace('COMENTARIOS_TAREA', ' Una vez rellenado, cierra la tarea para que automáticamente se envíe a todos los familiares de los residentes que cumplan años este mes el e-mail de acceso al blog para consultar las actividades de celebración. ');
                        bodyCumple =bodyCumple.replace('NEGRITA_COMENTARIOS', 'Si la agenda no está actualizada ofrecerás una mala imagen de tu centro y de la compañía a los familiares.');
                        bodyCumple =bodyCumple.replace('LINK_TAREA_BATCH', urlBase+'/'+tcumple.Id);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setBccAddresses(adresses);
                        mail.setSubject(subjectCumple);
                        mail.setHtmlBody(bodyCumple);
                        allmails.add(mail);
                        adresses.clear();
                     }  
                }
            }
            if(!Test.isRunningTest()) {
        	Messaging.sendEmail(allMails);
        }

        } 
    }
    //Funcio finish del batch
    global void finish(Database.BatchableContext bcMain) {
    }
}