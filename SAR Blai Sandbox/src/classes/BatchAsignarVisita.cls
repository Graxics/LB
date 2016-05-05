/** 
* File Name:   BatchAsignarVisita 
* Description: Busca los contactos de tipo A o B que no tengan visita planificada el 1er cuarto del año, 
			    y le asignamos una visita para el 30 de Abril
* @author:     Jose M
* Modification Log 
*/
global class BatchAsignarVisita implements Database.Batchable<SObject>, Database.AllowsCallouts {    
    global String glstrQuery;
    global Map <Id, Id> idsEvent;
    global List <String> exclude;
    global List <Event> eventsToInsert;
    global Id rtEvRecId;
    global Map<Id, String> idToName;
    global Map<Id, Id> idAccToIdCont;
    global BatchAsignarVisita(){
        
        List <RecordType> lrt = [ SELECT Id FROM RecordType WHERE Name = 'Contacto Recomendador' ];
        Id rtId = (lrt.size() > 0) ? lrt.get(0).Id : null;
        List <RecordType> ltrec = [ SELECT id FROM RecordType WHERE Name = 'Evento a Recomendador'];
        rtEvRecId = (ltrec.size() > 0) ? ltrec.get(0).Id : null;
		exclude = new List <String>();
        idToName = new Map<Id, String>();
        idAccToIdCont = new Map<Id, Id>();
        
        for(Account a : [ SELECT Id, Name FROM Account WHERE RecordTypeId = :rtId ]){
            idToName.put(a.Id, a.Name);
        }
       
        for(Contact c : [ SELECT Id, AccountId, Name FROM Contact 
                         WHERE AccountId!=null AND Account.RecordTypeId =: rtId ]){
            idToName.put(c.Id, c.Name);
            idAccToIdCont.put(c.AccountId, c.Id);
        }        
        
        Datetime fechaIniQ = Datetime.newInstance(Date.today().year(), 1, 1, 1, 0, 0);
        Datetime fechaFinQ = Datetime.newInstance(Date.today().year(), 5, 1, 2, 0, 0);
        eventsToInsert = new List <Event>();
        
        //buscar eventos de tipo visita que ocurran entre el 1 de enero y el 4 de abril
        for(Event e : [ SELECT Id, WhatId, WhoId FROM Event WHERE Subject ='Visita' 
    					AND ActivityDateTime > :fechaIniQ  AND ActivityDateTime < :fechaFinQ ]){
                            
            if(e.WhatId!=null && idToName.get(e.WhatId)!=null){
                exclude.add('Name != \'' + String.escapeSingleQuotes(idToName.get(e.WhatId)) + '\'');
            } 
            if(e.WhoId!=null && idToName.get(e.WhoId)!=null){
                exclude.add('Name != \'' + String.escapeSingleQuotes(idToName.get(e.WhoId)) + '\'');
            }
              
        }
 		//System.debug(String.join(exclude, ' AND '));
        
        //Seleccionar las cuentas de tipo contacto recomendador RES de Tipo A o B
        glstrQuery = 'SELECT Id, OwnerId, Owner.Name, Owner.IsActive, Empresa_recomendadora__c, ' +
            'Name, Clasificacion_tipo_recomendador__c, Empresa_recomendadora__r.Name ' +
            'FROM Account WHERE RecordTypeId = \'' + rtId + '\' AND ' +
            '(Clasificacion_tipo_recomendador__c = \'A\' OR Clasificacion_tipo_recomendador__c = \'B\')' +
             ((exclude.size() > 0) ? ' AND (' + String.join(exclude, ' AND ') + ')' : '');
        System.debug('glstrQuery = ' + glstrQuery);
    }
    
	//Funció start del batch
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        return Database.getQuerylocator(glstrQuery);
    }

	//Funció execute del batch
    global void execute(Database.BatchableContext bcMain, List<Account> lstBatchRecords) {
        System.debug('size final = ' + lstBatchRecords.size());
      	List <Id> listIdsAcc = new List <Id>();
		List <rec_AB_no_proc__c> recABnoprocToInsert = new List <rec_AB_no_proc__c>();
        //List <rec_AB_no_proc__c> lrecAB = [SELECT Name FROM rec_AB_no_proc__c ORDER BY Name DESC LIMIT 1];
        //Integer lastName = (lrecAB.size() > 0) ? Integer.valueOf(lrecAB.get(0).Name) : 0;
        
        for(Account ac : lstBatchRecords){
           
            if(ac.Owner.IsActive){
                Event newEvent = new Event(
                    Subject = 'Visita',
                    EventSubtype = 'Event',
                    ActivityDate = Date.newInstance(Date.today().year(), 4, 30),
                    ActivityDateTime = Datetime.newInstance(Date.today().year(), 4, 30, 10, 0, 0),
                    DurationInMinutes = 60,
                    RecordTypeId = rtEvRecId,
                    Resultado__c = 'Acción Abierta',
                    OwnerId = ac.OwnerId,
                    WhatId = ac.Empresa_recomendadora__c,
                    WhoId = idAccToIdCont.get(ac.Id)
                );
                eventsToInsert.add(newEvent);
                System.debug('Evento insertado para la cuenta ' + ac.Id);
            }else{
                //lastName++;
                recABnoprocToInsert.add(
                    new rec_AB_no_proc__c(
                        Name = generateRandomId(),
                        Clasif_tipo_rec_RES__c = ac.Clasificacion_tipo_recomendador__c,
                        Entidad_Recomendadora__c = ac.Empresa_recomendadora__r.Name,
                        Nombre_de_la_cuenta__c = ac.Name,
                        Propietario_de_la_cuenta__c = ac.Owner.Name
                    )
                );
                
            }    
            
        }
        //try{
            System.debug('size tasksToInsert = ' + eventsToInsert.size());
        	triggerHelper.recursiveHelper8(true); 
            insert eventsToInsert;
        	triggerHelper.recursiveHelper8(false); 
        	insert recABnoprocToInsert;
        //} catch(Exception e){
            //System.debug(e.getMessage());
        //}
        
    }
    
    private String generateRandomId(){
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        return hexDigest;       
    }
    
    // Finish the Batch Job
    global void finish(Database.BatchableContext bcMain) {
      
        String strResultEmail = Label.email_Errores_Batch;
        AsyncApexJob aaJob = [SELECT NumberOfErrors, TotalJobItems 
                              FROM AsyncApexJob WHERE Id = :bcMain.getJobId()];
        if(aaJob.NumberOfErrors > 0) {
            Messaging.SingleEmailMessage semResult = new Messaging.SingleEmailMessage();
            semResult.setToAddresses(new String[] {strResultEmail});
            semResult.setSubject('Error in Scheduled APEX');
            semResult.setPlainTextBody('BatchAsignarVisita: Processed ' + 
                                       aaJob.TotalJobItems + ' batches with ' + 
                                       aaJob.NumberOfErrors + ' failures.');
            if (!Test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semResult });
            }
        }
        
    }   
}