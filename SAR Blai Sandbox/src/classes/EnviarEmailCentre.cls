/** 
* File Name:   EnviarEmailCentre
* Description:Clase que se llama desde un botón del Centro que envia los emails de cambio de personal a todos los familiares de los residentes del centro
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		27/02/2015  Xavier Garcia
* =============================================================== 
**/ 
global class EnviarEmailCentre
{	//Metodo al cual se llama desde el botón
    webservice static void EnviarEmail(id idCentre,String tipoMail) 
    { 
        OrgWideEmailAddress owa = [SELECT id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName = 'Notificaciones SARquavitae' LIMIT 1];
        Date avui = Date.today();
        System.debug('ID CENTRE: '+idCentre);
        System.debug('Tipus Email: '+tipoMail);
        List<id> Residents = new List<id>();
        //Obtenemos toda la información del centro
        Account centro = [SELECT Ciudad__c,Director_del_centro__r.name,Director_del_centro__r.Email, name,Phone from Account where id =:idCentre];
        //Insertamos en una lista de ids todos los residentes que tienen una oportunidad en el centro
        for (Oportunidad_platform__c op:[SELECT Residente__c from Oportunidad_platform__c where centro2__c =:idCentre and Residente__r.baja__c = false and Fecha_de_Alta__c = null and etapa__c ='Ingreso']) {
            Residents.add(op.Residente__c);
        }
        String Descripcion;
        //Declaramos una template y la inicializamos según el botón que se haya pulsado.
        EmailTemplate template = new EmailTemplate();
        if (tipoMail == 'Director') {
            template = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Cambio_Director2' LIMIT 1];
            Descripcion = 'Email de cambio de director';
        }
        else if (tipoMail == 'AtCliente') {
            template = [SELECT Id, Body, Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Cambio_at_cliente2' LIMIT 1];
            Descripcion = 'Email de cambio de At.Cliente';
        }
        //Declaramos la lista de Tareas, donde guardaremos todas las tareas de los mails enviados.
        List<Task> TaskMails = new List<Task> ();
        //Declaramos la lista de direcciones.
        List<String> adresses = new List<String>();
        //Declaramos la clase auxiliar sendMail.
        SendEmailHelper sendMail = new SendEmailHelper();
        //Convertimos el mes actual a Texto.
        String mesString = sendMail.convertir_mes(avui.month());
        //Declaramos una lista de mails, donde iremos añadiendo todos los emails a enviar
        //y lo enviaremos despues de haber recorrido todos los familiares
        //ya que así no nos pasaremos del límite de 10 llamadas a la funcion sendMail
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
       	System.debug('NUMERO RESIDENTES: '+Residents.size());
        //Recorremos todos los familiares del centro y, si tiene email, 
        //le enviamos el correo sustituiendo los datos en la plantilla por los del centro
        for (Relacion_entre_contactos__c familiar : [SELECT id,contacto__c,residente__c,contacto__r.lastname,residente__r.lastname,residente__r.name,contacto__r.name,contacto__r.PersonEmail,contacto__r.Idioma_de_Contacto__pc FROM Relacion_entre_contactos__c WHERE Residente__c IN: Residents order by residente__c asc]) {
                    //Si el familiar tiene correo, haremos todo el proceso.
             System.debug('NOMBRE RESIDENTE: '+familiar.residente__r.name);
             System.debug('NOMBRE FAMILIAR: '+familiar.contacto__r.name);  
            if (familiar.contacto__r.PersonEmail != null) {
                        adresses.add(familiar.contacto__r.PersonEmail);
                        System.debug('ADREÇA AFEGIDA Bienvenida: '+familiar.contacto__r.PersonEmail);
                        Task tMail = new Task();
                        tMail.Description = Descripcion;
                        tMail.Status = 'Completada';
                        tMail.ActivityDate = avui;
                        tMail.Subject = Descripcion;
                        //El propietario de la tarea serà el admin
                        tMail.OwnerId = '005b0000000kj7H';
                        tMail.Priority = 'Normal';
                        //El whatid está associado al familiar del residente
                        tMail.WhatId = familiar.contacto__c;
                        //Añadimos la tarea a la lista, para despues insertarla en la BD
                        TaskMails.add(tMail);
                        String subject = template.Subject;
                        String body = template.HtmlValue;
                		String ciudad = centro.Ciudad__c;
                		String telefono = centro.Phone;
                		String director = centro.Director_del_centro__r.name;
                		String emailDirector = centro.Director_del_centro__r.email;
                        //Si hay valores que pueden ser null, los debemos sustituir por '' ya que no se puede pasar a una template un valor nulo.
                		if (ciudad == null) {
                            ciudad='';
                        }
                        if (telefono == null) {
                            telefono='';
                        }
                        if (director == null) {
                            director = '';
                            emailDirector = '';
                        }
                		//Reemplazamos los datos de la plantilla con los del centro
                        body = body.replace('(Ciudad)', ciudad);
                        body = body.replace('(día)', String.valueOf(avui.day()));
                        body = body.replace('(mes)', mesString);
                        body = body.replace('(año)', String.valueOf(avui.year()));
                        body = body.replace('NOMBRE_DIRECTOR', director);
                        body = body.replace('NOMBRE_CENTRO', centro.name);
                		body = body.replace('(e-mail director)', emailDirector);
                		body = body.replace('(teléfono del centro)', telefono);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setBccAddresses(adresses);
                        mail.setSubject(subject);
                        mail.setHtmlBody(body);
                		mail.setOrgWideEmailAddressId(owa.Id);
                        allmails.add(mail);
                        adresses.clear();
                    }
        }
        insert TaskMails;
       if(!Test.isRunningTest()) {
        	Messaging.sendEmail(allMails);
        }
    }
}