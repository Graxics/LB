/** 
* File Name:   BatchableEmailMenus 
* Description: Batchable que que se llama el 1 de cada mes y que envia los correos de los menús
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		18/02/2015  Xavier Garcia
* =============================================================== 
**/ 
global class BatchableEmailMenus implements Database.Batchable<SObject>, Database.AllowsCallouts {
	global String glstrQuery;
    //Llista on es guardarà el resultat de la query
    global List <Account> Centres;
    global List <Oportunidad_platform__c> Oportunidades;
    //Declarem la llista de tareas de ocio que s'insertaran a la BD
    global List <Task> TasksOcio = new List<Task>();
    //Declarem la llista de tareas de cumpleaños que s'insertaran a la BD
    global List <Task> TasksCumple = new List<Task>();
    //La data de vencimiento de les tareas serà de 7? dies
    global Date avui = Date.today();
    global Integer diaActual = avui.day();
    global Date vencimiento = avui.addDays(7);
    global Integer mesActual = avui.month();
    global id rt= '012b0000000QAeA';
    global string division= 'Residencial';
    global String etapa = 'Ingreso';
    //Obtenim els ATC de tots els comptes
    global BatchableEmailMenus() {
       //glstrQuery = 'SELECT id ,name,RecordTypeId, ATC_Centro__c,ATC_Centro__r.email,ATC_Centro__r.name,ATC_Centro2__c,ATC_Centro3__c FROM Account where RecordTypeId = :rt and Division__c =: division';
        glstrQuery = 'SELECT residente__c,centro2__c,Fecha_real_de_ingreso__c from Oportunidad_platform__c where centro2__r.Comunicacion_con_familias__c =true and residente__r.baja__c = false and etapa__c =:etapa and (Fecha_de_Alta__c = null and Motivio_de_Alta_GCR__c = null) and centro2__r.division__c =:division order by centro2__c asc';
    }
    //Funció start del batch
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        return Database.getQuerylocator(glstrQuery);
    }
    //Funció execute del batch
    global void execute(Database.BatchableContext bcMain, List<Oportunidad_platform__c> lstBatchRecords) {
        //Guardem a la llista d'accounts el resultat de la consulta
        Oportunidades = lstBatchRecords;
        Boolean existeix = false;
        OrgWideEmailAddress owa = [SELECT id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName = 'Residencia SARquavitae' LIMIT 1];
        Set<Id> IdCentresMenus = new Set<Id> ();
        List<ResidentesYCentros> ResyCentros = new List<ResidentesYCentros>();
        Map<id,Oportunidad_platform__c> ResidentsiCentres = new Map<id,Oportunidad_platform__c>();
         List<id> idResidents = new List<id>();
        Set<id>idResidentsSet = new Set<id>();
        //Recorrem totes les comptes i creem les tareas si el tipus de registre es de tipus "Centro" 
        //i el ATC del centre no es null
       for (Oportunidad_platform__c op:Oportunidades) {
            System.debug('OPORTUNIDAD: '+op);
            IdCentresMenus.add(op.centro2__c);
            ResidentesYCentros RyC = new ResidentesYCentros();
           RyC.Centro = op.Centro2__c;
           RyC.Residente = op.Residente__c;
           ResyCentros.add(RyC);
           //Guardamos los residentes en un Set, ya que como puede haber un residente con varias oportunidades,
           //solo guardaremos el Id una vez.
           idResidentsSet.add(op.Residente__c);
        }
        //Si las tareas modificadas son de actualización de menús.
    if (IdCentresMenus.size()> 0) {
        //Ordenamos los centros ascendentemente (el id).
        System.debug('Numero de centros Menus: '+IdCentresMenus.size());
        //Obtenemos el nombre de los centros de la lista de IdCentresOcio, para despues al enviar emails, personalizar el mensaje.
        Map<ID, Account> InfoCentres = new Map<ID, Account>([SELECT Id, Name,Blog__c,ATC_Centro__r.email,Comunicacion_con_familias__c FROM Account where id IN:IdCentresMenus]);
        Integer numCentres = InfoCentres.size();
        System.debug('Num centres ocio: '+numCentres);
        //Pasamos el Set a la lista, que es la que usaremos en la consulta SOQL
        idResidents.addAll(idResidentsSet);
        System.debug('NUMERO DE RESIDENTES MENUS: '+idResidents.size());
        idResidents.sort();
        idResidentsSet = null;
        //Si la lista contiene residente, entonces miraremos los familiares y enviaremos los emails.
        if (idResidents.size()> 0) {
            //Cargamos la plantilla de agenda de ocio.
            EmailTemplate templateCat = new EmailTemplate();
            EmailTemplate templateCast = new EmailTemplate();
            EmailTemplate templateEus = new EmailTemplate();
            EmailTemplate templateGal = new EmailTemplate();
            /*if (mesActual == 10 && diaActual == 15) {
            	templateCat = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Menu_verano_cat' LIMIT 1];
                templateCast = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'menu_verano_cast' LIMIT 1];
                templateEus = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Menu_verano_eus' LIMIT 1];
                templateGal = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'menu_verano_gal' LIMIT 1];
            }
            else if (mesActual == 6 && diaActual == 1) {*/
                templateCat = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'menu_invierno_cat' LIMIT 1];
                templateCast = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'menu_invierno_cast' LIMIT 1];
                templateEus = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'menu_invierno_eus' LIMIT 1];
                templateGal = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'menu_invierno_gal' LIMIT 1];
            /*}*/
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
            
            
            
            //Obtenemos toda la info de los familiares (Nombre, correo, idioma...) asociados a los residentes de la lista
            //y para cada uno vamos creando la tarea asociada y guardando el mail en la lista de mails.
            for (Relacion_entre_contactos__c familiar : [SELECT id,contacto__c,residente__c,contacto__r.lastname,residente__r.lastname,residente__r.name,contacto__r.name,contacto__r.PersonEmail,contacto__r.Idioma_de_Contacto__pc FROM Relacion_entre_contactos__c WHERE Residente__c IN: idResidents order by residente__c asc]) {
                   //Si el familiar tiene correo, haremos todo el proceso.
                if (familiar.contacto__r.PersonEmail != null) {
                     for (ResidentesYCentros residenteYcentro:ResyCentros) {
                            if (familiar.Residente__c == residenteYcentro.Residente) {
                                Id CentreActual = residenteYcentro.Centro;
                                Boolean CentroEnviable = InfoCentres.get(CentreActual).Comunicacion_con_familias__c;
                                if (CentroEnviable == true) {
                                    //adresses.add(familiar.contacto__r.PersonEmail);
                                    System.debug('ADREÇA AFEGIDA MENUS: '+familiar.contacto__r.PersonEmail);
                                   /* Task tMail = new Task();
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
                                    TaskMails.add(tMail);*/
                                    EmailTemplate template = new EmailTemplate();
                                    String mesString = sendMail.convertir_mes(mesActual);
                                    if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Catalán') {
                                        template = templateCat;
                                        mesString = sendMail.convertir_mes_cat(mesActual);
                                    }
                                    else if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Euskera') {
                                        template = templateEus;
                                        mesString = sendMail.convertir_mes_eus(mesActual);
                                    }
                                    else if (familiar.contacto__r.Idioma_de_Contacto__pc == 'Gallego') {
                                        template = templateGal;
                                        mesString = sendMail.convertir_mes_gal(mesActual);
                                    }
                                    else {
                                        template = templateCast;
                                    }
                                    //Obtenemos todos los datos de la plantilla, y hacemos las sustituciones necesarias
                                    //(Apellido del familiar, mes actual, Centro, url blog...)
                                    //String mesString = sendMail.convertir_mes(mesActual);
                                    String subject = template.Subject;
                                    subject = subject.replace('NOMBRE_MES', mesString);
                                    String body = template.HtmlValue;
                                    //Id CentreActual = ResidentsiCentres.get(familiar.residente__c).centro2__c;
                                    //Id CentreActual = residenteYcentro.Centro;
                                    /*Id CentreActual = ResidentsiCentres.get(familiar.residente__c).centro2__c;*/
                                    String blog = InfoCentres.get(CentreActual).blog__c;
                                    /*if (blog == null) {
                                        blog = '';
                                    }*/
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
                                    adresses.add(AtcEmail);
                                    //body = body.replace('APELLIDO_FAMILIA', familiar.contacto__r.lastname);
                                   // body = body.replace('NOMBRE_CENTRO', InfoCentres.get(CentreActual).name);
                                    //body = body.replace('NOMBRE_MES', mesString);
                                    body = body.replace('DIRECCION_BLOG',blog );
                                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                    if (adresses.size() > 0) {
                                        mail.setBccAddresses(adresses);
                                    }
                                    mail.setTargetObjectId(ContactoYCuentas.get(familiar.contacto__c).id);
                                    //mail.setBccAddresses(adresses);
                                    mail.setSubject(subject);
                                    mail.setHtmlBody(body);
                                    mail.setOrgWideEmailAddressId(owa.Id);
                                    allmails.add(mail);
                                    adresses.clear();
                               }  
                            }
                     }
                    
                }
            }
            //Una vez recorridos todos los familiares, insertamos las Tareas y enviamos los mails
            
            //if ((mesActual == 10 && diaActual == 15)|| (mesActual == 6 && diaActual == 1)) {
                //insert TaskMails;
                if(!Test.isRunningTest()) {
                    triggerHelper.recursiveHelper1(true);
        	Messaging.sendEmail(allMails);
                    triggerHelper.recursiveHelper1(false);
        }
            /*}*/
            
    	}     
    }
        
    }
    
    
    
    
    
    //Funcio finish del batch
    global void finish(Database.BatchableContext bcMain) {
    }
}