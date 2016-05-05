/** 
* File Name:   tgNocAprobada 
* Description: Envia correos electronicos informando que la nocc ha sido aprobada
* Copyright:   Konozca 
* @author:     Sergi Aguilar & Hector Mañosas
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 06/08/2014    HManosas    Utilizamos los centros de la visibilidad
* =============================================================== 
**/ 

trigger tgNocAprobada on NOC__c (after update) {
    
    if(triggerHelper.todofalse())
    {
        integer pos = 0;        
        //Lista de los roles
        List<UserRole> lur = [Select Id, Name From UserRole];       
                
        List<String> listSplit = new List<String>();
        map<Id,List<String>> mapNocCentros = new map<Id,List<String>>();        
                
        //Seleccionamos la plantilla
        EmailTemplate template = [SELECT Id, Name, HtmlValue, Subject, Body FROM EmailTemplate WHERE DeveloperName = 'Aprobacion' LIMIT 1];
        
        //Montamos Record Type de las NOC
        map<Id, RecordType> mapTipoNOC = new map<Id, RecordType>([SELECT Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'NOC__c']);
                        
        //Id Org Wide email address
        OrgWideEmailAddress owa = [SELECT id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName = 'Notificaciones SARquavitae' LIMIT 1];
                        
        //Base URL
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        List<Servicio__c> ServiciosHogar = [SELECT Id, Name FROM Servicio__c WHERE name Like 'Hogar%'];
        List<Centros_NOC__c> liniesTA = new List<Centros_NOC__c>();
        List<User> users = [SELECT Id, Name, ProfileId,Profile.name, Email, Zona_Comercial__c, UserRoleId FROM User 
                            WHERE isActive = true AND (Profile.name = 'Director Comercial' OR Profile.name = 'Zona' 
                            OR Profile.name = 'Centro')];
        
        //recorremos todas las nuevas noc
        for(NOC__c nc : trigger.new) {          
                
            //si la noc ha sido aprobada y es de tipo 9 o 12 enviamos los mails a los centros
            if((nc.RecordTypeId == '012b0000000QBcgAAG' || nc.RecordTypeId == '012b0000000QBd0AAG') && ((nc.Estado_Flujo__c == 'Aprobado' && trigger.isInsert) || (trigger.isUpdate && nc.Estado_Flujo__c == 'Aprobado' && trigger.old[pos].Estado_Flujo__c != 'Aprobado')))
            {   
                if (nc.RecordTypeId == '012b0000000QBd0AAG' && nc.Domiciliaria__c) {
                    Boolean trobat = false;
                    for(Integer j = 0; j < users.size() && !trobat; ++j) {
                        if (users[j].id == nc.OwnerId) {
                            trobat = true;
                        }
                    }
                    if (trobat) {
                        for (Servicio__c ServicioTA:ServiciosHogar) {
                        Centros_NOC__c liniaTA = new Centros_NOC__c(Servicio_TA__c = ServicioTA.id,central__c = 'MADRID;SEVILLA;SEVILLA NACIONAL',NOC_TAD__c = nc.id,Descuento__c = 0.1,Descuento_Dispositivo__c = 0.1,recordtypeid = Schema.SObjectType.Centros_NOC__c.getRecordTypeInfosByName().get('Centros/Servicios NOC TA').getRecordTypeId());
                        liniesTA.add(liniaTA);
                        }
                    }
                    
                }
                 
                //Cogemos todos los centros de la visibilidad
                List<String> listSplit1;
                List<String> listSplit2;
                List<String> listSplit3;
                List<String> listSplit4;
                List<String> listSplit5;
                if(nc.Visibilidad_Centros_1__c != null) listSplit1 = nc.Visibilidad_Centros_1__c.split(';');
                if(nc.Visibilidad_Centros_2__c != null) listSplit2 = nc.Visibilidad_Centros_2__c.split(';');
                if(nc.Visibilidad_Centros_3__c != null) listSplit3 = nc.Visibilidad_Centros_3__c.split(';');
                if(nc.Visibilidad_Centros_4__c != null) listSplit4 = nc.Visibilidad_Centros_4__c.split(';');
                if(nc.Visibilidad_Centros_5__c != null) listSplit5 = nc.Visibilidad_Centros_5__c.split(';');      
                
                if(listSplit1 != null) listSplit.addall(listSplit1);
                if(listSplit2 != null) listSplit.addall(listSplit2);
                if(listSplit3 != null) listSplit.addall(listSplit3);
                if(listSplit4 != null) listSplit.addall(listSplit4);
                if(listSplit5 != null) listSplit.addall(listSplit5);           
            }
            
            if((nc.RecordTypeId == '012b0000000QDCD') && ((nc.Estado_Flujo__c == 'Aprobado' && trigger.isInsert) || (trigger.isUpdate && nc.Estado_Flujo__c == 'Aprobado' && trigger.old[pos].Estado_Flujo__c != 'Aprobado'))) {
                System.debug('ENVIAR LA NOC RENEGOCIADA!');
                CalloutNavisionWS.enviar_noc_renegociada(nc.Id);
            }
             
            
            mapNocCentros.put(nc.Id, listSplit);
            pos ++;     
        }
        
        //Cogemos los centros de los campos visibilidad
        List<Account> lCen = [Select Id, IdNAV__c, Director_del_centro__c, ATC_Zona__c, ATC_Centro__c, ATC_Centro2__c, ATC_Centro3__c, Zona_Territorial__c, Activo__c From Account Where IdNAV__c IN :listSplit];
        List<User> lUs = [Select Id, Name, Email, Zona_Territorial__c, UserRoleId From User WHERE isActive = true];
        map<Id, User> mapUsers = new map<Id, User>();
                
        for(NOC__c ncc : trigger.new) {     
            
            Set<String> toAddresses = new Set<String>();
            
            for(Account ac : lCen)
            {
                //Miramos si la lista de centros visibilidad coincide y cogemos los Perfiles
                if(mapNocCentros.containsKey(ncc.Id) && ac.Activo__c) {
                    Set<String> centros = new Set<String> (mapNocCentros.get(ncc.Id));
                    if(centros.contains(ac.IdNAV__c)) {
                        //recorremos los usuarios para buscar los que les tenemos que enviar un mensaje
                        for(User u : lUs) {
                            mapUsers.put(u.Id, u);
                            String role = '';
                            //buscamos el nombre de la funcion del usuario
                            for(UserRole ur : lur) {
                                if(u.UserRoleId == ur.Id) {
                                    role = ur.Name;
                                }
                            }
                            if((u.Id == ac.Director_del_centro__c || u.Id == ac.ATC_Centro__c|| u.id==ac.ATC_Centro2__c || u.Id == ac.ATC_Centro3__c || u.Id == ac.ATC_Zona__c || role.contains('Director Comercial') || role.contains('Directora de División')
                            || (role.contains('Director Territorial') && u.Zona_Territorial__c == ac.Zona_Territorial__c)) && (u.Email != 'bmonegal@sarquavitae.es')) {
                                toAddresses.add(u.Email);                                                                                               
                            }   
                        }                   
                    }               
                }                       
            }           
            List<String> addresses = new List<String>(toAddresses);
            Integer i = 0;                  
            integer cont = 0;           
            while(i < addresses.size()) {               
                Integer j = i;
                List<String> addressesAux  = new List<String>();    
                while((cont < 25) && j < addresses.size()) {
                    addressesAux.add(addresses.get(j));
                    j = j + 1;
                    cont = cont + 1;
                }                       
                Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();             
                mail.setOrgWideEmailAddressId(owa.Id);
                mail.setBccAddresses(addressesAux);
                String subject = template.Subject;              
                String tipoNOC = mapTipoNOC.get(ncc.RecordTypeId).Name;
                subject = subject.replace('{!NOC__c.RecordType}', tipoNoc);                     
                mail.setSubject(subject);           
                String body = template.Body;
                body = body.replace('{!NOC__c.Name}', ncc.Name);
                String creador = mapUsers.get(ncc.ownerid).Name;
                body = body.replace('{!NOC__c.Owner}', creador);
                if(ncc.Comentarios_de_aprobacion__c != null)  {
                    body = body.replace('{!NOC__c.Comentarios_de_aprobacion__c}', ncc.Comentarios_de_aprobacion__c);
                } 
                else {
                    body = body.replace('{!NOC__c.Comentarios_de_aprobacion__c}', 'No hay comentarios');
                }
                body = body.replace('{!NOC__c.Link}', sfdcBaseURL + '/' + ncc.Id);
                mail.setPlainTextBody(body);           
                mail.setSaveAsActivity(false);
                System.debug(mail.getBccAddresses());               
                if(!Test.isRunningTest()) {
                    if(!toAddresses.isEmpty()) Messaging.sendEmail(new Messaging.Singleemailmessage[]{mail});                   
                }
                
                i = j;
                cont = 0;       
            }                           
        }
        insert liniesTA;
    }
}