/** 
* File Name:   EnviarCorreuTask 
* Description:Trigger que se ejectua cuada vez que se inserta una tarea Cat info y que envía un correo en función de los campos de Direciones de envío
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		18/06/2015  Xavier Garcia
* =============================================================== 
**/ 
trigger EnviarCorreuTask on Task (after insert) {
   if(triggerHelper.todofalse()) {
    if (TriggerHelperExecuteOnce.executar8() == true) {   
    List<id> Whatids = new List<id>();
    for (Task t:Trigger.new) {
        if (t.SAD_Barcelona__c|| t.SAD_resto_de_Espana__c || t.SARDOMUS__c || t.ADOREA_Benalmadena__c || t.ADOREA_Girona__c || t.ADOREA_Sevilla__c) {
            Whatids.add(t.WhatId);
        }
    }
    Map<id,Account> InfoCuentas = new Map<id,Account>();
    if (whatids.size() > 0) {
        System.debug('whatids: '+whatids);
        List<String> Adreces = new List<String>();
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        //OrgWideEmailAddress owa = [SELECT id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName = 'Residencia SARquavitae' LIMIT 1];
        EmailTemplate template = [SELECT Id, Body, Subject FROM EmailTemplate WHERE DeveloperName = 'Email_desde_el_CAT' LIMIT 1];
        for (Account a:[Select id,name,phone,personMobilePhone,personEmail,ciudad__c,Franja_horaria_de_contacto__c from Account where id IN:Whatids]) {
        	InfoCuentas.put(a.id,a);
            System.debug('NAME: '+a.name);
            System.debug('phone: '+a.phone);
            System.debug('ID: '+a.id);
    	}
    
        for (Task t:Trigger.new) {
            if (t.SAD_Barcelona__c || t.SAD_resto_de_Espana__c || t.SARDOMUS__c|| t.ADOREA_Benalmadena__c || t.ADOREA_Girona__c || t.ADOREA_Sevilla__c) {
                String subject = template.Subject;
                String body = template.Body;
                String mailCopia = Userinfo.getUserEmail();
                if (InfoCuentas.get(t.WhatId) != null) {
                    body = body.replace('{!Task.What}',InfoCuentas.get(t.WhatId).name);
                    if (InfoCuentas.get(t.WhatId).phone != null) {
                       body = body.replace('{!Account.Phone}',InfoCuentas.get(t.WhatId).phone);
                    }
                    else {
                        body = body.replace('{!Account.Phone}','');
                    }
                    if (InfoCuentas.get(t.WhatId).PersonMobilePhone != null) {
                        body = body.replace('{!Account.PersonMobilePhone}',InfoCuentas.get(t.WhatId).PersonMobilePhone);
                    }
                    else {
                        body = body.replace('{!Account.PersonMobilePhone}','');
                    }
                    if (InfoCuentas.get(t.WhatId).PersonEmail != null) {
                        body = body.replace('{!Account.PersonEmail}',InfoCuentas.get(t.WhatId).PersonEmail);
                    }
                    else {
                        body = body.replace('{!Account.PersonEmail}','');
                    }
                    if (InfoCuentas.get(t.WhatId).Ciudad__c != null) {
                        body = body.replace('{!Account.Ciudad__c}',InfoCuentas.get(t.WhatId).Ciudad__c);
                    }
                    else {
                        body = body.replace('{!Account.Ciudad__c}','');
                    }
                    if (t.Description != null) {
                        body = body.replace('{!Task.Description}',t.Description);
                    }
                    else {
                        body = body.replace('{!Task.Description}','');
                    }
                    if (t.Procedencia__c != null) {
                        body = body.replace('{!Task.Procedencia__c}',t.Procedencia__c);
                    }
                    else {
                        body = body.replace('{!Task.Procedencia__c}','');
                    }
                    String DescripcionProc = '';
                    if (t.Entidad_Recomendadora__c != null) {
                            DescripcionProc = t.Entidad_Recomendadora__c;
                    }
                    if (t.Centro_de_procedencia__c != null) {
                        DescripcionProc = t.Centro_de_procedencia__c;
                    }
                    if (t.Empleado_recomendador__c != null) {
                        DescripcionProc = t.Empleado_recomendador__c;
                    }
                    if (t.Cliente_Recomendador__c	 != null) {
                        DescripcionProc = t.Cliente_Recomendador__c;
                    }
                    if (t.Contacto_Recomendador__c != null) {
                        if (DescripcionProc == '') {
                            DescripcionProc = t.Contacto_Recomendador__c;
                        }
                        else {
                            DescripcionProc += ' - '+t.Contacto_Recomendador__c;
                        }
                        
                    }
                    body = body.replace('{!Task.Descripcion_procedencia__c}',DescripcionProc);
                    if (InfoCuentas.get(t.WhatId).Franja_horaria_de_contacto__c != null) {
                        body = body.replace('{!Account.Franja_horaria_de_contacto__c}',InfoCuentas.get(t.WhatId).Franja_horaria_de_contacto__c);
                    }
                    else {
                        body = body.replace('{!Account.Franja_horaria_de_contacto__c}','');
                    }
                    
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                if (t.SAD_Barcelona__c) {
                    Adreces.add('anemperfeina@pangea.org');
                    //Adreces.add('cristina.andinach@konozca.com');
                    //System.debug('ENVIO A SAD_Barcelona__c');
                    Adreces.add(mailCopia);
                }
                if (t.SAD_resto_de_Espana__c) {
                    Adreces.add('direccion.sadalcorcon@sarquavitae.es');
                    System.debug('ENVIO A SAD_resto_de_Espana__c');
                    //Adreces.add('cristina.andinach@konozca.com');
                    Adreces.add(mailCopia);
                }
                if (t.SARDOMUS__c) {
                    Adreces.add('cgenerica.sardomus@sarquavitae.es');
                   // Adreces.add('cristina.andinach@konozca.com');
                    //System.debug('ENVIO A SARDOMUS__c');
                    Adreces.add(mailCopia);
                }
                if (t.ADOREA_Benalmadena__c) {
                    Adreces.add('direccion.adoreabenalmadena@sarquavitae.es');
                    Adreces.add('atcliente.suroriental@sarquavitae.es');
                    System.debug('ENVIO A ADOREA_Benalmadena__c');
                    //Adreces.add('cristina.andinach@konozca.com');
                    Adreces.add(mailCopia);
                }
                if (t.ADOREA_Girona__c) {
                    Adreces.add('direccion.adoreagirona@sarquavitae.es');
                    System.debug('ENVIO A ADOREA_Girona__c');
                    //Adreces.add('cristina.andinach@konozca.com');
                    Adreces.add(mailCopia);
                }
                if (t.ADOREA_Sevilla__c) {
                    Adreces.add('direccion.adoreasevilla@sarquavitae.es');
                    Adreces.add('atcliente.suroccidental@sarquavitae.es');
                    Adreces.add('atcliente.adoreasevilla@sarquavitae.es');
                    Adreces.add('atcliente.santajusta@sarquavitae.es');
                    System.debug('ENVIO A ADOREA_Sevilla__c');
                    //Adreces.add('cristina.andinach@konozca.com');
                    Adreces.add(mailCopia);
                }
                mail.setCcAddresses(Adreces);
                mail.setSubject(subject);
                mail.setPlainTextBody(body);
                //mail.setOrgWideEmailAddressId(owa.Id);
                allmails.add(mail);
                Adreces.clear();
            }
        }
        if(!Test.isRunningTest()) {
            Messaging.sendEmail(allMails);
        }   	
    }
        }
  }  
}