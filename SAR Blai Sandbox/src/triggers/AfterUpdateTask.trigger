/** 
* File Name:   AfterUpdateTask 
* Description:Trigger que se ejecutará siempre que se modifique una tarea. En este trigger se enviará el correo de la agenda de ocio, el correo
del cumpleaños y el correo de los menús. Además, también pondrá el campo historia_de_vida del residente a true si la tarea tiene asunto
CUESTIONARIO HISTORIA DE VIDA y se generará la tarea recurrente del informe a la familia.
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		05/02/2015  Xavier Garcia
* =============================================================== 
**/ 

trigger AfterUpdateTask on Task (after update) {
    //Listas de centros
    //List<Id> IdCentresOcio = new List<Id> ();
    List<Id> IdCentresCumple = new List<Id> ();
    //List<Id> IdCentresMenus = new List<Id> ();
    List<Account> ResidentesHV = new List<Account> ();
    List<Task> TasksInformeAmirar = new List<Task>();
    List<id> OpsAmirar = new List<id>();
    List<id> idOpsHV = new List<id>();
    //Nos guardamos el mes actual
    Date avui = Date.today();
    Integer mesActual = avui.month();
    Integer diaActual = avui.day();
    Integer mesCumple = avui.month();
    if (diaActual > 23) {
        if (mesCumple < 12) {
            mesCumple++;
        }
        else {
            mesCumple = 1;
        }
    }
    //Recorremos todas las tareas modificadas y miramos de que tipo es.
   	//Si cumple las condiciones, entonces añadimos el whatid (Centro) a la lista de ids correspondiente.
    for (Task tasca:Trigger.new) {
        
        //Si la tarea modificada pasa a Completada y es de tipo CUESTIONARIO HISTORIA DE VIDA
        if (tasca.Status == 'Completada' && tasca.Subject =='cuestionario historia de vida') {
                Task OldTarea = Trigger.oldMap.get(tasca.Id);
            //Si el estado de la tarea era diferente de completada
                if (OldTarea.Status != tasca.Status) {
                    System.debug('ENTRA 222');
                    idOpsHV.add(tasca.WhatId);
                }
            /*
                    //Modificamos la cuenta del residente, poniendo el campo historia_de_vida_Adjunta a true
                    Oportunidad_platform__c op_modificar = new Oportunidad_platform__c(id = tasca.WhatId);
                    ID resId = idResidentsHV.get(tasca.WhatId).Residente__c;
                    Account ResMod = new Account(id = resId,Historia_de_vida_adjunta__c = true);
                    //Historia_de_vida_adjunta__c=true;
                    ResidentesHV.add(ResMod);
                    System.debug(resId);
                    System.debug(ResMod.Historia_de_vida_adjunta__c);*/
            }   
        /*
        //Si la tarea modificada pasa a Completada y es de tipo Actualizar blog Agenda de ocio y tiempo libre y es la de este mes
        if (tasca.Status == 'Completada' && tasca.Subject =='Actualizar blog Agenda de ocio y tiempo libre' && tasca.ActivityDate.month() == mesActual) {
            Task OldTarea = Trigger.oldMap.get(tasca.Id);
            //Si el estado de la tarea era diferente a completada nos guardamos el id del centro asociado a aquella tarea.
            if (OldTarea.Status != tasca.Status) {
                Id centro_id =tasca.WhatId;
                IdCentresOcio.add(centro_id);
            }   
        }*/
        
         //Si la tarea modificada pasa a Completada y es de tipo Actualizar blog Actividad cumpleaños y es la de este mes
        if (tasca.Status == 'Completada' && tasca.Subject =='Actualizar blog Actividad cumpleaños' && (tasca.ActivityDate.month() == mesActual+1 ||tasca.ActivityDate.month() == mesActual )) {
            mesCumple = tasca.ActivityDate.month();
            System.debug('ENTRA CUMPLE');
            Task OldTarea = Trigger.oldMap.get(tasca.Id);
            //Si el estado de la tarea era diferente a completada nos guardamos el id del centro asociado a aquella tarea.
            if (OldTarea.Status != tasca.Status) {
                System.debug('ENTRA CUMPLE2');
                Id centro_id =tasca.WhatId;
                IdCentresCumple.add(centro_id);
            }   
        }
        /*
        //Si la tarea modificada pasa a Completada y es de tipo Actualizar menús y es la de este mes
        if (tasca.Status == 'Completada' && tasca.Subject =='Actualizar menús' && tasca.ActivityDate.month() == mesActual) {
            Task OldTarea = Trigger.oldMap.get(tasca.Id);
            //Si el estado de la tarea era diferente a completada nos guardamos el id del centro asociado a aquella tarea.
            if (OldTarea.Status != tasca.Status) {
                Id centro_id =tasca.WhatId;
                IdCentresMenus.add(centro_id);
            }   
        }*/
        
        //Si la tarea modificada pasa a Completada y es de tipo Informe a familia
        if (tasca.Status == 'Completada' && tasca.Subject =='Informe a familia') {
           TasksInformeAmirar.add(tasca);
           OpsAmirar.add(tasca.WhatId);
           /* Oportunidad_platform__c oMap = new Oportunidad_platform__c();
            Boolean baja = true;
            if (BajaTareaRecurrente.get(tasca.WhatId) != null) {
               oMap= BajaTareaRecurrente.get(tasca.WhatId);
               baja = oMap.Residente__r.baja__c;
            }
            if (baja == false) {
                Date vencimiento = avui.addMonths(4);
                Task OldTarea = Trigger.oldMap.get(tasca.Id);
                //Si el estat de la tarea era diferent a completada
                if (OldTarea.Status != tasca.Status) {
                    //Creem una nova tasca amb les mateixes dades, però amb una data de vencimiento de 4 mesos.
                    Task tinforme = new Task();
                    tinforme.Description = 'Se tiene que entregar el informe a la familia';
                    tinforme.Status = 'Pendiente';
                    tinforme.ActivityDate = vencimiento;
                    tinforme.Subject = tasca.Subject;
                    tinforme.OwnerId = tasca.OwnerId;
                    tinforme.Priority = tasca.Priority;
                    tinforme.WhatId = tasca.WhatId;
                    //Afegim la tarea a la llista de tareas per posteriorment, insertar-les a la BD
                    TasksInforme.add(tinforme);
                }
            } */  
        }   
    }
    
    
    /*ACTUALIZAR HISTORIA DE VIDA*/
    //Si las tareas modificadas son de cuestionario de historia de vida
    if (idOpsHV.size() > 0) {
        for (Oportunidad_platform__c oportunidad:[SELECT id,residente__c,residente__r.Historia_de_vida_adjunta__c from Oportunidad_platform__c where id IN:idOpsHV]) {
            if (oportunidad.Residente__r.Historia_de_vida_adjunta__c == false) {
                Id resid = oportunidad.Residente__c;
                Account ResMod = new Account(id = resId,Historia_de_vida_adjunta__c = true);
                ResidentesHV.add(ResMod);
                System.debug(resId);
                System.debug(ResMod.Historia_de_vida_adjunta__c);
            }
        }
        update ResidentesHV;
    }
    
    
    /*ENVIAR EMAIL AGENDA DE OCIO*/
    /*
    //Si las tareas modificadas son de Agenda de ocio
    if (IdCentresOcio.size()> 0) {
        //Ordenamos los centros ascendentemente (el id).
        IdCentresOcio.sort();
        System.debug('Numero de centros Ocio: '+IdCentresOcio.size());
        //Obtenemos el nombre de los centros de la lista de IdCentresOcio, para despues al enviar emails, personalizar el mensaje.
        Map<ID, Account> InfoCentres = new Map<ID, Account>([SELECT Id, Name,Blog__c FROM Account where id IN:IdCentresOcio]);
        Integer numCentres = InfoCentres.size();
        System.debug('Num centres ocio: '+numCentres);
        //Creamos un map para tener, para cada Residente, la información de la oportunidad(Centro, fecha de creacion...)
        Map<id,Oportunidad_platform__c> ResidentsiCentres = new Map<id,Oportunidad_platform__c>();
        //Declaramos una lista y un set para guardar los Residentes, ya que
        //luego solo seleccionaremos aquellos familiares de los residentes de la lista.
        List<id> idResidents = new List<id>();
        Set<id>idResidentsSet = new Set<id>();
        //Obtenemos todos los residentes de todos los centros que tenemos en la lista de centros
        //y, para cada residente, guardamos en el Map el id del residente como clave y
        //informacion de la opp (centro y fecha de ingreso)
        for (Oportunidad_platform__c residente :[SELECT residente__c,centro2__c,Fecha_real_de_ingreso__c from Oportunidad_platform__c where centro2__c IN: IdCentresOcio and residente__r.baja__c = false and etapa__c = 'Ingreso' order by centro2__c asc]) {
            //En el map quedará asociado el residente con la oportunidad con fecha de ingreso mas reciente
            //ya que puede haber mas de una oportunidad para un mismo residente.
            if (ResidentsiCentres.get(residente.Residente__c) != null) {
				Oportunidad_platform__c existent = ResidentsiCentres.get(residente.Residente__c);
                if (residente.Fecha_real_de_ingreso__c > existent.Fecha_real_de_ingreso__c ) {
                    ResidentsiCentres.put(residente.Residente__c, residente);
                }
            }
            else {
                ResidentsiCentres.put(residente.Residente__c, residente);
            }
            //Guardamos los residentes en un Set, ya que como puede haber un residente con varias oportunidades,
            //solo guardaremos el Id una vez.
            idResidentsSet.add(residente.Residente__c);
        }
        //Pasamos el Set a la lista, que es la que usaremos en la consulta SOQL
        idResidents.addAll(idResidentsSet);
        System.debug('NUMERO DE RESIDENTES OCIO: '+idResidents.size());
        idResidents.sort();
        //Si la lista contiene residente, entonces miraremos los familiares y enviaremos los emails.
        if (idResidents.size()> 0) {
            //Cargamos la plantilla de agenda de ocio.
            EmailTemplate template = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'AgendaOcio' LIMIT 1];
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
            //Obtenemos toda la info de los familiares (Nombre, correo, idioma...) asociados a los residentes de la lista
            //y para cada uno vamos creando la tarea asociada y guardando el mail en la lista de mails.
            for (Relacion_entre_contactos__c familiar : [SELECT id,contacto__c,residente__c,contacto__r.lastname,residente__r.lastname,residente__r.name,contacto__r.name,contacto__r.PersonEmail,contacto__r.Idioma_de_Contacto__pc FROM Relacion_entre_contactos__c WHERE Residente__c IN: idResidents order by residente__c asc]) {
                   //Si el familiar tiene correo, haremos todo el proceso.
                if (familiar.contacto__r.PersonEmail != null) {
                    adresses.add(familiar.contacto__r.PersonEmail);
                    System.debug('ADREÇA AFEGIDA OCIO: '+familiar.contacto__r.PersonEmail);
                    Task tMail = new Task();
                    tMail.Description = 'Correo electrónico: Agenda de ocio';
                    tMail.Status = 'Completada';
                    tMail.ActivityDate = avui;
                    tMail.Subject = 'Correo electrónico: Agenda de ocio';
                    //El propietario de la tasca será el admin
                    tMail.OwnerId = '005b0000000kj7H';
                    tMail.Priority = 'Normal';
                    //El whatid está associat al familiar del residente
                    tMail.WhatId = familiar.contacto__c;
                    //Añadimos la tarea a la lista, para despues insertarla en la BD
                    TaskMails.add(tMail);
                    //Obtenemos todos los datos de la plantilla, y hacemos las sustituciones necesarias
                    //(Apellido del familiar, mes actual, Centro, url blog...)
                    String mesString = sendMail.convertir_mes(mesActual);
                    String subject = template.Subject;
                    subject = subject.replace('NOMBRE_MES', mesString);
                    String body = template.HtmlValue;
                    Id CentreActual = ResidentsiCentres.get(familiar.residente__c).centro2__c;
                    String blog = InfoCentres.get(CentreActual).blog__c;
                    if (blog == null) {
                        blog = '';
                    }
                    body = body.replace('APELLIDO_FAMILIA', familiar.contacto__r.lastname);
                    body = body.replace('NOMBRE_CENTRO', InfoCentres.get(CentreActual).name);
                    body = body.replace('NOMBRE_MES', mesString);
                    body = body.replace('DIRECCION_BLOG',blog );
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setBccAddresses(adresses);
                    mail.setSubject(subject);
                    mail.setHtmlBody(body);
                    allmails.add(mail);
                    adresses.clear();
                }
            }
            //Una vez recorridos todos los familiares, insertamos las Tareas y enviamos los mails
            insert TaskMails;
            Messaging.sendEmail(allMails); 
    	}     
    }
    */
    /*ENVIAR EMAIL CUMPLEAÑOS*/
    //Si las tareas modificadas son de Cumpleaños
    if (IdCentresCumple.size()> 0) {
        //Ordenamos los centros ascendentemente (el id).
        IdCentresCumple.sort();
        List<ResidentesYCentros> ResyCentros = new List<ResidentesYCentros>();
        System.debug('MES cumple: '+ mesCumple);
        System.debug('Numero de centros Cumple: '+IdCentresCumple.size());
        //Obtenemos el nombre de los centros de la lista de IdCentresOcio, para despues al enviar emails, personalizar el mensaje.
        Map<ID, Account> InfoCentres = new Map<ID, Account>([SELECT Id, Name,Blog__c,ATC_Centro__r.email FROM Account where id IN:IdCentresCumple]);
        Integer numCentres = InfoCentres.size();
        System.debug('Num centres cumple: '+numCentres);
        //Creamos un map para tener, para cada Residente, la información de la oportunidad(Centro, fecha de creacion...)
        Map<id,Oportunidad_platform__c> ResidentsiCentres = new Map<id,Oportunidad_platform__c>();
        //Declaramos una lista y un set para guardar los Residentes, ya que
        //luego solo seleccionaremos aquellos familiares de los residentes de la lista.
        List<id> idResidents = new List<id>();
        Set<id>idResidentsSet = new Set<id>();
        //Obtenemos todos los residentes de todos los centros que tenemos en la lista de centros
        //y, para cada residente, guardamos en el Map el id del residente como clave y
        //informacion de la opp (centro y fecha de ingreso)
        for (Oportunidad_platform__c residente :[SELECT residente__c,centro2__c,Fecha_real_de_ingreso__c,residente__r.PersonBirthdate from Oportunidad_platform__c where centro2__c IN: IdCentresCumple and residente__r.baja__c = false and etapa__c = 'Ingreso' and (Fecha_de_Alta__c = null and Motivio_de_Alta_GCR__c = null) and residente__r.PersonBirthdate != null order by centro2__c asc]) {
            //En el map quedará asociado el residente con la oportunidad con fecha de ingreso mas reciente
            //ya que puede haber mas de una oportunidad para un mismo residente.
            /*if (ResidentsiCentres.get(residente.Residente__c) != null) {
				Oportunidad_platform__c existent = ResidentsiCentres.get(residente.Residente__c);
                if (residente.Fecha_real_de_ingreso__c > existent.Fecha_real_de_ingreso__c ) {
                    ResidentsiCentres.put(residente.Residente__c, residente);
                }
            }
            else {
                Date nacimiento = residente.residente__r.PersonBirthdate;
            	//Solo guardamos los residentes que cumplen años en el mes actual.
                if (nacimiento.month() == mesCumple) {
                    ResidentsiCentres.put(residente.Residente__c, residente);
                    idResidentsSet.add(residente.Residente__c);
                }
        	}*/
            //MODIFICACION PARA QUE SE ENVIE EL CORREO A LOS RESIDENTES TANTAS VECES COMO EN CENTROS ESTÁ A LA VEZ.
            //YA QUE EL RESIDENTE PUEDE ESTAR EN MÁS DE UN CENTRO. MIRAR FECHA DE ALTA y CUMPLE
            	Date nacimiento = residente.residente__r.PersonBirthdate;
            	if (nacimiento.month() == mesCumple) {
                    ResidentesYCentros RyC = new ResidentesYCentros();
                    RyC.Centro = residente.Centro2__c;
                    RyC.Residente = residente.Residente__c;
                    ResyCentros.add(RyC);
                    idResidentsSet.add(residente.Residente__c);
                }
        }
        //Pasamos el Set a la lista, que es la que usaremos en la consulta SOQL
        idResidents.addAll(idResidentsSet);
        System.debug('NUMERO DE RESIDENTES CUMPLE: '+idResidents.size());
        idResidents.sort();
        //Si la lista contiene residente, entonces miraremos los familiares y enviaremos los emails.
        if (idResidents.size()> 0) {
            //Cargamos las plantillas de cumpleaños (catalan y castellano)
            EmailTemplate templateCat = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Aniversari_Cat' LIMIT 1];
            EmailTemplate templateCast = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Aniversari_Cast' LIMIT 1];
            EmailTemplate templateEus = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Aniversari_Eusk' LIMIT 1];
            EmailTemplate templateGal = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Aniversari_Gall' LIMIT 1];
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
            //Obtenemos toda la info de los familiares (Nombre, correo, idioma...) asociados a los residentes de la lista
            //y para cada uno vamos creando la tarea asociada y guardando el mail en la lista de mails.
            for (Relacion_entre_contactos__c familiar : [SELECT id,contacto__c,residente__c,contacto__r.lastname,residente__r.lastname,residente__r.name,contacto__r.name,contacto__r.PersonEmail,contacto__r.Idioma_de_Contacto__pc FROM Relacion_entre_contactos__c WHERE Residente__c IN: idResidents order by residente__c asc]) {
                   //Si el familiar tiene correo, haremos todo el proceso.
                if (familiar.contacto__r.PersonEmail != null) {
                    for (ResidentesYCentros residenteYcentro:ResyCentros) {
                            if (familiar.Residente__c == residenteYcentro.Residente) {
                                adresses.add(familiar.contacto__r.PersonEmail);
                                System.debug('ADREÇA AFEGIDA CUMPLE: '+familiar.contacto__r.PersonEmail);
                                Task tMail = new Task();
                                tMail.Description = 'Correo electrónico: Cumpleaños';
                                tMail.Status = 'Completada';
                                tMail.ActivityDate = avui;
                                tMail.Subject = 'Correo electrónico: Cumpleaños';
                                //El propietario de la tarea serà el admin
                                tMail.OwnerId = '005b0000000kj7H';
                                tMail.Priority = 'Normal';
                                //El whatid está associado al familiar del residente
                                tMail.WhatId = familiar.contacto__c;
                                //Añadimos la tarea a la lista, para despues insertarla en la BD
                                TaskMails.add(tMail);
                                System.debug('FAMILIAR ID TASCAAAA: '+familiar.contacto__c);
                                //Dependiendo del idioma del contacto, la plantilla sera una o otra.
                                String mesString = sendMail.convertir_mes(mesActual);
                                EmailTemplate template = new EmailTemplate();
                                if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Catalán') {
                                    template = templateCat;
                                    mesString = sendMail.convertir_mes_cat(mesActual);
                                }
                                else if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Euskera') {
                                    template = templateEus;
                                    mesString = sendMail.convertir_mes_eus(mesActual);
                                }
                                if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Gallego') {
                                    template = templateGal;
                                    mesString = sendMail.convertir_mes_gal(mesActual);
                                }
                                else {
                                    template = templateCast;
                                }
                                //Obtenemos todos los datos de la plantilla, y hacemos las sustituciones necesarias
                                //(Apellido del familiar, mes actual, Centro, url blog...)
                                String subject = template.Subject;
                                subject = subject.replace('NOMBRE_MES', mesString);
                                String body = template.HtmlValue;
                                //Id CentreActual = ResidentsiCentres.get(familiar.residente__c).centro2__c;
                                Id CentreActual = residenteYcentro.Centro;
                                String blog = InfoCentres.get(CentreActual).blog__c;
                                if (blog == null) {
                                    blog = '';
                                }
                                String AtcEmail = InfoCentres.get(CentreActual).ATC_Centro__r.email;
                                if (AtcEmail == null) {
                                    AtcEmail = '';
                                }
                                if (CentreActual == '001b000000UFBwQ' || CentreActual == '001b000000UFBwy') {
                                 adresses.add('bmonegal@sarquavitae.es');
                                 adresses.add('vgago@sarquavitae.es');
                                 adresses.add('jvelasco@sarquavitae.es');
                                    if (CentreActual == '001b000000UFBwQ') {
                                        adresses.add('ahuguet@sarquavitae.es');
                                    }
                            	}
                                if (CentreActual == '001b000000UFBwF' || CentreActual == '001b000000UFBvo') {
                                        adresses.add('jvelasco@sarquavitae.es');
                                }
                                if (CentreActual == '001b000000UFBwW' || CentreActual == '001b000000UFBwl') {
                                    adresses.add('vgago@sarquavitae.es');
                                }
                                if (CentreActual == '001b000000UFBw7') adresses.add('bmonegal@sarquavitae.es');
                                adresses.add(AtcEmail);
                                String emailAddress = UserInfo.getUserEmail();
                               // body = body.replace('APELLIDO_FAMILIA', familiar.contacto__r.lastname);
                                body = body.replace('NOMBRE_CENTRO', InfoCentres.get(CentreActual).name);
                                body = body.replace('NOMBRE_MES', mesString);
                                body = body.replace('DIRECCION_BLOG',blog );
                                body = body.replace('MAILTO_CORREO', 'mailto:'+emailAddress);
                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                mail.setBccAddresses(adresses);
                                mail.setSubject(subject);
                                mail.setHtmlBody(body);
                                allmails.add(mail);
                                adresses.clear();
                            }
                    }
                    
                }
            }
            //Una vez recorridos todos los familiares, insertamos las Tareas y enviamos los mails
            insert TaskMails;
            Messaging.sendEmail(allMails); 
    	}     
    }
    
    /*ENVIAR EMAIL MENUS*/
    /*
    //Si las tareas modificadas son de actualización de menús.
    if (IdCentresMenus.size()> 0) {
        //Ordenamos los centros ascendentemente (el id).
        IdCentresMenus.sort();
        System.debug('Numero de centros Menus: '+IdCentresMenus.size());
        //Obtenemos el nombre de los centros de la lista de IdCentresOcio, para despues al enviar emails, personalizar el mensaje.
        Map<ID, Account> InfoCentres = new Map<ID, Account>([SELECT Id, Name,Blog__c FROM Account where id IN:IdCentresMenus]);
        Integer numCentres = InfoCentres.size();
        System.debug('Num centres ocio: '+numCentres);
        //Creamos un map para tener, para cada Residente, la información de la oportunidad(Centro, fecha de creacion...)
        Map<id,Oportunidad_platform__c> ResidentsiCentres = new Map<id,Oportunidad_platform__c>();
        //Declaramos una lista y un set para guardar los Residentes, ya que
        //luego solo seleccionaremos aquellos familiares de los residentes de la lista.
        List<id> idResidents = new List<id>();
        Set<id>idResidentsSet = new Set<id>();
        //Obtenemos todos los residentes de todos los centros que tenemos en la lista de centros
        //y, para cada residente, guardamos en el Map el id del residente como clave y
        //informacion de la opp (centro y fecha de ingreso)
        for (Oportunidad_platform__c residente :[SELECT residente__c,centro2__c,Fecha_real_de_ingreso__c from Oportunidad_platform__c where centro2__c IN: IdCentresMenus and residente__r.baja__c = false and etapa__c = 'Ingreso' order by centro2__c asc]) {
            //En el map quedará asociado el residente con la oportunidad con fecha de ingreso mas reciente
            //ya que puede haber mas de una oportunidad para un mismo residente.
            if (ResidentsiCentres.get(residente.Residente__c) != null) {
				Oportunidad_platform__c existent = ResidentsiCentres.get(residente.Residente__c);
                if (residente.Fecha_real_de_ingreso__c > existent.Fecha_real_de_ingreso__c ) {
                    ResidentsiCentres.put(residente.Residente__c, residente);
                }
            }
            else {
                ResidentsiCentres.put(residente.Residente__c, residente);
            }
            //Guardamos los residentes en un Set, ya que como puede haber un residente con varias oportunidades,
            //solo guardaremos el Id una vez.
            idResidentsSet.add(residente.Residente__c);
        }
        //Pasamos el Set a la lista, que es la que usaremos en la consulta SOQL
        idResidents.addAll(idResidentsSet);
        System.debug('NUMERO DE RESIDENTES MENUS: '+idResidents.size());
        idResidents.sort();
        //Si la lista contiene residente, entonces miraremos los familiares y enviaremos los emails.
        if (idResidents.size()> 0) {
            //Cargamos la plantilla de agenda de ocio.
            EmailTemplate template = new EmailTemplate();
            if (mesActual >= 6 && mesActual <= 11) {
            	template = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'menu_verano' LIMIT 1];
            }
            else {
                template = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'menu_invierno' LIMIT 1];
            }
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
            //Obtenemos toda la info de los familiares (Nombre, correo, idioma...) asociados a los residentes de la lista
            //y para cada uno vamos creando la tarea asociada y guardando el mail en la lista de mails.
            for (Relacion_entre_contactos__c familiar : [SELECT id,contacto__c,residente__c,contacto__r.lastname,residente__r.lastname,residente__r.name,contacto__r.name,contacto__r.PersonEmail,contacto__r.Idioma_de_Contacto__pc FROM Relacion_entre_contactos__c WHERE Residente__c IN: idResidents order by residente__c asc]) {
                   //Si el familiar tiene correo, haremos todo el proceso.
                if (familiar.contacto__r.PersonEmail != null) {
                    adresses.add(familiar.contacto__r.PersonEmail);
                    System.debug('ADREÇA AFEGIDA MENUS: '+familiar.contacto__r.PersonEmail);
                    Task tMail = new Task();
                    tMail.Description = 'Correo electrónico: Actualización de los menús';
                    tMail.Status = 'Completada';
                    tMail.ActivityDate = avui;
                    tMail.Subject = 'Correo electrónico: Actualización de los menús';
                    //El propietario de la tasca será el admin
                    tMail.OwnerId = '005b0000000kj7H';
                    tMail.Priority = 'Normal';
                    //El whatid está associat al familiar del residente
                    tMail.WhatId = familiar.contacto__c;
                    //Añadimos la tarea a la lista, para despues insertarla en la BD
                    TaskMails.add(tMail);
                    //Obtenemos todos los datos de la plantilla, y hacemos las sustituciones necesarias
                    //(Apellido del familiar, mes actual, Centro, url blog...)
                    //String mesString = sendMail.convertir_mes(mesActual);
                    String subject = template.Subject;
                    //subject = subject.replace('NOMBRE_MES', mesString);
                    String body = template.HtmlValue;
                    /*Id CentreActual = ResidentsiCentres.get(familiar.residente__c).centro2__c;
                    String blog = InfoCentres.get(CentreActual).blog__c;*/
                    /*if (blog == null) {
                        blog = '';
                    }*/
                   /* body = body.replace('APELLIDO_FAMILIA', familiar.contacto__r.lastname);
                   // body = body.replace('NOMBRE_CENTRO', InfoCentres.get(CentreActual).name);
                    //body = body.replace('NOMBRE_MES', mesString);
                   // body = body.replace('DIRECCION_CENTRO',blog );
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setBccAddresses(adresses);
                    mail.setSubject(subject);
                    mail.setHtmlBody(body);
                    allmails.add(mail);
                    adresses.clear();
                }
            }
            //Una vez recorridos todos los familiares, insertamos las Tareas y enviamos los mails
            insert TaskMails;
            Messaging.sendEmail(allMails); 
    	}     
    }*/
    Recordtype RtypeTareaCliente = [Select Id, Name From RecordType Where Name = 'Tarea Cliente' LIMIT 1];
    /*GENERAR TAREA INFORME A FAMILIA*/
    //Si las tareas modificadas son de INFORME A FAMILIA
    if ( TasksInformeAmirar.size() > 0) {
        List<Task> TasksInforme = new List<Task>();
        Map<id,Oportunidad_platform__c> infoOp = new Map<id,Oportunidad_platform__c>();
        for (Oportunidad_platform__c op:[SELECT id,Fecha_de_Alta__c,residente__r.name from Oportunidad_platform__c where id IN:OpsAmirar and Fecha_de_Alta__c = null]) {
            infoOp.put(op.id, op);
        }
        for (Task t:TasksInformeAmirar) {
            if (infoOp.get(t.WhatId) != null) {
                Task tinforme = new Task();
                tinforme.Description = 'URGENTE ¡¡¡Completa el informe a familia del residente '+infoOp.get(t.WhatId).residente__r.name+'!!!Este informe pretende aportar a la familia información sobre la evolución del residente. Una vez rellenado se deberá entregar a la familia.';
                tinforme.Status = 'Pendiente';
                tinforme.ActivityDate = avui.addMonths(4);
                tinforme.Subject = t.Subject;
                tinforme.OwnerId = t.OwnerId;
                tinforme.Priority = t.Priority;
                tinforme.WhatId = t.WhatId;
                tinforme.whoid = t.WhoId;
                tinforme.RecordTypeId = RtypeTareaCliente.id;
                tinforme.IsFromTrigger__c = true;
                //Afegim la tarea a la llista de tareas per posteriorment, insertar-les a la BD
                TasksInforme.add(tinforme);
            }
        }
        insert TasksInforme;
    }

}