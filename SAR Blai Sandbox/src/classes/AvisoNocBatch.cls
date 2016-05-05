global class AvisoNocBatch implements Database.Batchable<sObject>, Database.Stateful {
    global final String Query;
    private id idRTDPR;
    private id idRTDPP;

   global AvisoNocBatch(){
        idRTDPR = [Select Id From RecordType Where Name = 'NOC 11 Descuento Personal Renegociado'].Id;
        idRTDPP = '012b0000000QBcvAAG';
        Query = 'Select Id, Name, RecordTypeId, CreatedById, OwnerId, Oportunidad__c, Oportunidad__r.Centro2__r.ATC_Zona__c, Oportunidad_renegociada__c, Oportunidad_renegociada__r.Centro2__r.ATC_Zona__c From NOC__c Where (RecordTypeId = \'012b0000000QBcvAAG\' or RecordTypeId = \'' + idRTDPR + '\') and Fecha_fin__c > NEXT_N_DAYS:14 and Fecha_fin__c = NEXT_N_DAYS:15';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(Query);
   }

    //envia mensajes a los propietarios de los recomendadores y residentes que hacen años dentro de una setmana
   global void execute(Database.BatchableContext BC, List<NOC__c> lNoc){
       //consultamos los usuarios y guardamos sus mails en un map
       Map<Id, User> users = new Map<Id, User>();
       for(User u: [Select Id, Name, Email From User]) {
           users.put(u.id, u);
       }
       
       List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
       //recorremos las noc que tenemos que informar al ATC Zona
       for(NOC__c nc : lNoc) {
           //rellenamos cada mail segun el tipo de noc y el atc zona del centro
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
           //guarda si existe o no el atcZona
           Boolean atcExis = false;
           if(nc.RecordTypeId == idRTDPP && nc.Oportunidad__r.Centro2__r.ATC_Zona__c != null) {
               atcExis = true;
              // mail.setToAddresses(new List<String>{users.get(nc.Oportunidad__r.Centro2__r.ATC_Zona__c).Email, 'sergi.aguilar@konozca.com'});
               mail.setToAddresses(new List<String>{users.get(nc.Oportunidad__r.Centro2__r.ATC_Zona__c).Email}); 
               mail.setSubject('Próximo vencimiento de una NOC 11 Descuento Personal Puntual'); 

           }
           else if(nc.Oportunidad_renegociada__r.Centro2__r.ATC_Zona__c != null){
               atcExis = true;
              // mail.setToAddresses(new List<String>{users.get(nc.Oportunidad_renegociada__r.Centro2__r.ATC_Zona__c).Email, 'sergi.aguilar@konozca.com'});
               mail.setToAddresses(new List<String>{users.get(nc.Oportunidad_renegociada__r.Centro2__r.ATC_Zona__c).Email});
               mail.setSubject('Próximo vencimiento de una NOC 11 Descuento Personal Renegociado'); 
           } 
           if(atcExis) {
               String body = 'Apreciado/a, \n\nLe informamos que se aproxima la fecha de vencimiento para la NOC  ( https://sarquavitae.my.salesforce.com/' + nc.Id + ' ) ' + nc.Name + ' de ' + users.get(nc.OwnerId).Name + '. \n\nReciba un cordial saludo.';
               mail.setPlainTextBody(body); 
               emails.add(mail);
           }
       }
       //enviamos los mails
       if(!Test.isRunningTest()) Messaging.sendEmail(emails);
   }

   global void finish(Database.BatchableContext BC){
   }
   
}