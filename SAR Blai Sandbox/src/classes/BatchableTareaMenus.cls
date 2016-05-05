/** 
* File Name:   BatchableTareaMenus 
* Description: Batchable que es crida el 1 de desembre i de juny i que crea les
Tareas d'actualitzacio del menú
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		22/01/2015  Xavier Garcia
* =============================================================== 
**/ 
global class BatchableTareaMenus implements Database.Batchable<SObject>, Database.AllowsCallouts {
	global String glstrQuery;
    //Llista on es guardarà el resultat de la query
    global List <Account> Centres;
    //Declarem la llista de tareas de menu que s'insertaran a la BD
    global List <Task> Tasks = new List<Task>();
    //La data de vencimiento de les tareas serà de 7? dies
    global Date avui = Date.today();
    global Integer diaActual = avui.day();
    global Integer mesActual = avui.month();
    global Date vencimiento = avui.addDays(7);
    global id rt= '012b0000000QAeA';
    global string division= 'Residencial';
    //Obtenim els ATC de tots els comptes
    global BatchableTareaMenus() {
        glstrQuery = 'SELECT id ,name,RecordTypeId, ATC_Centro__c,ATC_Centro__r.email,ATC_Centro__r.name,ATC_Centro2__c,ATC_Centro3__c,Comunicacion_con_familias__c FROM Account where RecordTypeId = :rt and Division__c =: division';
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
                //Creem les tareas de Menu
                Task tmenu = new Task();
                //if (mesActual == 10 && diaActual == 7) {
                    tmenu.Description = 'El día 1 del próximo mes se enviará una notificación automática informando a los familiares del nuevo menú. Recuerda actualizar el blog con el menú del próximo mes';
                    tmenu.Status = 'Pendiente';
                    tmenu.ActivityDate = vencimiento;
                    tmenu.Subject = 'Menú próximo mes';
                    tmenu.OwnerId = Atc1;
                    tmenu.Priority = 'Normal';
                    tmenu.WhatId = Idcentre;
                    existeix = true;
                    Tasks.add(tmenu);
                    infoCentres.put(Idcentre, centre);
                /*}
                else if (mesActual == 5 && diaActual == 23 ) {
                    tmenu.Description = 'El próximo día 1 de junio se enviará una notificación automática informando a los familiares del cambio de menú primavera-verano.';
                    tmenu.Status = 'Pendiente';
                    tmenu.ActivityDate = vencimiento;
                    tmenu.Subject = 'Menú primavera-verano';
                    tmenu.OwnerId = Atc1;
                    tmenu.Priority = 'Normal';
                    tmenu.WhatId = Idcentre;
                    existeix = true;
                    Tasks.add(tmenu);
                    infoCentres.put(Idcentre, centre);
                }*/
                //Afegim la tarea a la llista de tareas per posteriorment, insertar-les a la BD
                
                //Si s'han creat les tareas les podrem insertar a la BD.
                
                
            }
        }
          //Tenemos que insertar las tareas en la BD y, ademas, enviar un correo electrónico al ATC de cada centro
        //informandole que se le ha asignado la tarea. En los triggers eso no hace falta porque se hace automaticamente
        //pero en los batch no lo hace.
        if (existeix) {
        	insert Tasks;
            List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
            List<String> adresses = new List<String>();
            EmailTemplate template = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Nueva_tarea_menus' LIMIT 1];
            for (Task task:Tasks ) {
                if (infoCentres.get(task.WhatId) != null) {
                    if (infoCentres.get(task.WhatId).ATC_Centro__r.email != null && infoCentres.get(task.WhatId).Comunicacion_con_familias__c == true) {
                        String emailAdress = infoCentres.get(task.WhatId).ATC_Centro__r.email;
                        String urlBase = URL.getSalesforceBaseUrl().toExternalForm();
                        adresses.add(emailAdress);
                        String subject = template.Subject;
                        String body = template.HtmlValue;
                        String ActivityDte = String.valueOf(task.ActivityDate);
                        String[] separa = ActivityDte.split('-');
                        String ActDateMostra = separa[2]+'/'+separa[1]+'/'+separa[0];
                        subject =subject.replace('ASUNTO_TAREA', task.Subject);
                        body =body.replace('ATC_CENTRO', infoCentres.get(task.WhatId).ATC_Centro__r.name);
                        body =body.replace('NOMBRE_CENTRO', infoCentres.get(task.WhatId).name);
                        body =body.replace('FECHA_VENCIMIENTO_TAREA', ActDateMostra);
                        body =body.replace('NOMBRE_ASUNTO_TAREA', task.Subject);
                        body =body.replace('PRIORIDAD_TAREA', task.Priority);
                        body =body.replace('COMENTARIOS_TAREA', task.Description);
                        body =body.replace('LINK_TAREA_BATCH', urlBase+'/'+task.Id);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setBccAddresses(adresses);
                        mail.setSubject(subject);
                        mail.setHtmlBody(body);
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