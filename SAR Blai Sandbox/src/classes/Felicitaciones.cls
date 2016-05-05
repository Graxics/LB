global class Felicitaciones implements Database.Batchable<sObject>, Database.Stateful {

   global final String Query;

   global Felicitaciones(){
        Query = 'Select Id, Name, OwnerId, PersonBirthdate, RecordTypeId, Residente__c, Aniversario_apertura__c From Account Where (((RecordTypeId = \'012b0000000QAe0AAG\' and Residente__c = true) or RecordTypeId = \'012b0000000QCbtAAG\') and PersonBirthdate > NEXT_N_DAYS:6 and PersonBirthdate = NEXT_N_DAYS:7)  or (RecordTypeId = \'012b0000000QAd7AAG\' and Aniversario_apertura__c > NEXT_N_DAYS:6 and Aniversario_apertura__c = NEXT_N_DAYS:7)';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(Query);
   }

    //envia mensajes a los propietarios de los recomendadores y residentes que hacen años dentro de una setmana
   global void execute(Database.BatchableContext BC, List<Account> lacc){
      List<Id> idResidentes = new List<Id>();
        for(Account a : lacc){
            if(a.RecordTypeId == '012b0000000QAe0AAG' && a.Residente__c == true) idResidentes.add(a.Id);
        }
        List<Oportunidad_platform__c> ops = [Select Id, OwnerId, Etapa__c, Residente__c FROM Oportunidad_platform__c WHERE Residente__c In :idResidentes];
      
      List<User> lus = [Select Id, Email From User];
      List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
      for(Account a : lacc){
        boolean b = false;
            Id owner = null;
            if(a.RecordTypeId == '012b0000000QAe0AAG' && a.Residente__c == true) {
                Boolean enc = false;
                for(integer i = 0; i < ops.Size() && !enc; ++i) {
                    if(ops[i].Residente__c == a.Id && ops[i].Etapa__c == 'Ingreso') {
                        enc = true;
                        owner = ops[i].OwnerId;
                    } 
                }
            }
            else owner = a.OwnerId; 
            if(owner != null) {
                  for(integer i = 0; i < lus.Size() && !b; ++i) {
                    if(lus[i].Id == owner) {
                        b = true;
                        try {
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                            mail.setToAddresses(new List<String>{lus[i].Email, 'sergi.aguilar@konozca.com'}); 
                            mail.setSubject('Recordatorio de aniversario'); 
                            String body = '';
                            if(a.RecordTypeId == '012b0000000QAd7AAG') body = 'Apreciado/a,\n\n'+ 'La fecha de aperture de la entidad recomendadora '+ a.Name +' (https://sarquavitae.my.salesforce.com/'+a.Id+') fue el ' +  a.Aniversario_apertura__c.day() + '-' + a.Aniversario_apertura__c.month() + '-' + a.Aniversario_apertura__c.year()  + ' por lo que se acerca su aniversario. \n' +'Recuerda contactar para felicitarle.\n\n' +'Un cordial saludo,'; 
                            else body = 'Apreciado/a,\n\n'+ 'La fecha de nacimiento de '+ a.Name +' (https://sarquavitae.my.salesforce.com/'+a.Id+') fue el ' +  a.PersonBirthdate.day() + '-' + a.PersonBirthdate.month() + '-' + a.PersonBirthdate.year()  + ' por lo que se acerca su aniversario. \n' +'Recuerda contactar para felicitarle.\n\n' +'Un cordial saludo,'; 
                            mail.setPlainTextBody(body); 
                            emails.add(mail);
                        }
                        catch(Exception e) {
                            system.debug(e);
                        }
                    }
                }
            }
      }
     // if(!Test.isRunningTest()) Messaging.sendEmail(emails);
    }

   global void finish(Database.BatchableContext BC){
   }
   
}