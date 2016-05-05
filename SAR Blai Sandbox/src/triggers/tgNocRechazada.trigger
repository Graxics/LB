/** 
* File Name:   triggerNOCRechazada 
* Description: Envia correos electronicos informando que la noc ha sido rechazada a todos los participantes
* Copyright:   Konozca 
* @author:     Hector Mañosas
* Modification Log 
* =============================================================== 
*   Version          Date        Author           Modification 
*     00             30/09/2014
*     01             17/12/2014  Agimenez         Evitar redundancia de mails en la lista
*     02             23/12/2014  Agimenez         Envio de comentarios
*     03             07/12/2015  Agimenez         Cambio del trigger a after y se ha añadido where a dos select en subconsultas soql
* ============================================================================================================================== 
**/ 

trigger tgNocRechazada on NOC__c (after update) {
    System.debug('Entro al trigger de NOC RECHAZADA');
    if(triggerHelper.todofalse())
    {    //List<LogNOCRechazada__c> logsNOC= new List<LogNOCRechazada__c> ();
        datetime HoraActual = datetime.now();
         Boolean envios = false;
        NOC__c noc = new NOC__c();
         Map<Id, Id> mapProcessNOC  = new Map<Id, Id>();
         Set <String> emailsYaIntroducidos = new set <String>();
         String comment = '';
         Map<Id, NOC__c> mapNocs = new Map<Id, NOC__c>();
         List<QueueSobject> listaCola = new List<QueueSobject>();
         List<User> listaUsuarios = new List<User>();
         list<String> toAddresses = new list<String>();
         map<Id,User> mapUsers = new map<Id,User>();                 
         //Base URL
         String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();           
         for(NOC__c n : trigger.new)
         {
             NOC__c OldNOC = Trigger.oldMap.get(n.Id);
             if (OldNOC.Estado_Flujo__c != n.Estado_Flujo__c) {
             System.debug('Estado noc modificada: '+ n.Estado_Flujo__c);
                if(n.Estado_Flujo__c == 'Rechazado')
                {
                    mapNocs.put(n.Id, n);
                }
            } 
         }
                            
        //Obtenemos el Id de los Process Instance de cada NOC
         List<Id> processInstanceIds = new List<Id>();
         if(!mapNocs.isEmpty())
         {
             for (NOC__c invs : [SELECT Id, Name, CreatedById, Comentarios_de_aprobacion__c, (SELECT ID
                                FROM ProcessInstances                                                              
                                ORDER BY CreatedDate DESC
                                LIMIT 1)
                        FROM NOC__c
                        WHERE ID IN : mapNocs.KeySet()])
             {    
                  if(invs.ProcessInstances.size() > 0) {
                    processInstanceIds.add(invs.ProcessInstances[0].Id);
                    mapProcessNOC.put(invs.ProcessInstances[0].Id, invs.Id);                
                  }           
             }
         
         //Obtenemos el nombre de la Etiqueta QueueSObject
         listaCola = [SELECT Id, QueueId, Queue.Name FROM QueueSobject];
         // 01 Obtenemos los usuarios y los guardamos en un map
         listaUsuarios = [SELECT Id, Name, Email FROM User WHERE isActive = true];
         Map<id,User> mapUsuarios = new map <id,User> ();
            for(User u : listaUsuarios){
                mapUsuarios.put(u.Id, u);
            }
        Set <User> setUsers = new Set<User> (listaUsuarios);
         //Escogemos la plantilla de rechazo
         EmailTemplate template = [SELECT Id, Body, Subject FROM EmailTemplate WHERE DeveloperName = 'Rechazo' LIMIT 1];         
         //Montamos Record Type de las NOC
         map<Id, RecordType> mapTipoNOC = new map<Id, RecordType>([SELECT Id, Name, SobjectType FROM RecordType WHERE SobjectType = 'NOC__c']);
         //Id Org Wide email address
        
         OrgWideEmailAddress owa = [SELECT id, Address, DisplayName from OrgWideEmailAddress WHERE DisplayName = 'Notificaciones SARquavitae' LIMIT 1];
         //Obtenemos los Steps de cada Process Instance de la NOC modificada
         for (ProcessInstance pi : [SELECT ID, TargetObjectId,
                              (SELECT OriginalActorId, ActorId, Comments, StepStatus
                              FROM Steps
                              ORDER BY CreatedDate DESC)
                        FROM ProcessInstance
                        WHERE Id IN : processInstanceIds])
         {
                //Obtenemos el ID de la NOC para añadir los comentarios de los Steps
                id nocId = mapProcessNOC.get(pi.Id);
                noc = mapNocs.get(nocId);

                for(Integer i = 0; i < pi.Steps.size(); i++) {
                    if(pi.Steps[i].StepStatus=='Rejected') {
                        comment = pi.Steps[i].comments;
                        System.debug('comment: ' + comment);
                    }
                    for(QueueSobject q : listaCola) {
                        if(q.QueueId == pi.Steps[i].OriginalActorId) {
                            for(User u : mapUsuarios.values()) {
                                mapUsers.put(u.Id, u);
                                if(u.Id == pi.Steps[i].ActorId) {       
                                    // 01 Aqui comprovamos que no se haya introducido ya el mail anteriormente en la lista
                                    // si se ha hecho lo descartamos, pero si no, lo introucimos y lo añadimos a la lista 
                                    // de emails que ya han sido notificados
                                    if(! emailsYaintroducidos.contains(u.Email)) {
                                       /*LogNOCRechazada__c logNOC = new LogNOCRechazada__c();
                                        logNOC.correo_electronico__c = u.Email;
                                        logNOC.Comentario2__c = comment;
                                        logNOC.Fecha_hora_ejecucion__c = HoraActual;
                                        logNOC.ID_NOC__c = noc.Id;
                                        logNOC.Nom_NOC__c = noc.name;
                                        logsNOC.add(logNOC);*/
                                       System.debug('AÑADO al usuario' + u);
                                        toAddresses.add(u.Email);
                                        emailsYaintroducidos.add(u.Email);
                                        
                                    }
                                }
                            }
                        }
                    }               
                }
             //03 intentamos evitar que se envie mas de un mail                         
             
           }
             if(!envios){
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();               
                mail.setOrgWideEmailAddressId(owa.Id);
                mail.setBccAddresses(toAddresses);
                System.debug('ToAddresses ' + toAddresses);
                String subject = template.Subject;              
                String tipoNOC = mapTipoNOC.get(noc.RecordTypeId).Name;
                subject = subject.replace('{!NOC__c.RecordType}', tipoNoc);                     
                mail.setSubject(subject);
             // tipo = rechazo
                String body = template.Body;
                body = body.replace('{!NOC__c.Name}', noc.Name);
                String creador = mapUsers.get(noc.ownerid).Name;
                body = body.replace('{!NOC__c.Owner}', creador);
                body = body.replace('{!NOC__c.Comentarios_de_aprobacion__c}', comment);
                body = body.replace('{!Enlace}', sfdcBaseURL + '/' + noc.Id);
                mail.setPlainTextBody(body);                
                mail.setSaveAsActivity(false);                                          
                //enviamos el mail y ponemos envios a true para evitar enviar mas mensajes  
                          
                if (!Test.isRunningTest()) {
        	 	Messaging.sendEmail(new Messaging.Singleemailmessage[]{mail}); 
        		}            
                Boolean sinComentarios = true;     
                envios = true;
                
             }
        }
     //insert logsNOC;
    } 
}