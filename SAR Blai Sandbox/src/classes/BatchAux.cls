global class BatchAux implements Database.Batchable<SObject>, Database.AllowsCallouts{
    
    global String glstrQuery;
    global Map<Id, List<Oportunidad_platform__c>> mapResOps; //oportunidades asociadas al residente
    global List<String> idsResidentes;
    global List <residentes_to_update__c> resVerificar;
	
    
    global BatchAux(){
        
        mapResOps = new Map<Id, List<Oportunidad_platform__c>>();
        idsResidentes = new List<String>();
        resVerificar = new List <residentes_to_update__c>();
        for(Res_Aux__c r : [SELECT id__c FROM Res_Aux__c]){
            idsResidentes.add(r.id__c);
        }
        for(Oportunidad_platform__c op : [ SELECT Id, Residente__c, Motivo_de_Alta_Comercial__c, Etapa__c 
                                           FROM Oportunidad_platform__c 
                                           WHERE Residente__c IN :idsResidentes ORDER BY CreatedDate ASC]){
            addOp(op);
        }
        
        System.debug('mapResOps:');
        System.debug(mapResOps);
        glstrQuery = 'SELECT Id FROM Account WHERE Id IN :idsResidentes';
    }
    

    
	//Funció start del batch
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        return Database.getQuerylocator(glstrQuery);
    }  
    
    global void execute(Database.BatchableContext bcMain, List<Account> lstResidentes) {
        
        for(Account ac : lstResidentes){
            List<Oportunidad_platform__c> opsAsoc = mapResOps.get(ac.Id);
            if(opsAsoc!=null){
                Oportunidad_platform__c lastOp = opsAsoc.get(opsAsoc.size()-1);
                if( lastOp.Motivo_de_Alta_Comercial__c==null || lastOp.Motivo_de_Alta_Comercial__c=='') {
                    resVerificar.add(new residentes_to_update__c(Id__c = ac.Id, Name = ac.Id));
                }
            }
        }
        insert resVerificar;
    }    
    
    global void finish(Database.BatchableContext bcMain){}    
    
    private String generateRandomId(){
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        return hexDigest;       
    }    
    
    private void addOp(Oportunidad_platform__c o){
        List<Oportunidad_platform__c> lop;
        if(mapResOps.get(o.Residente__c)==null){
            lop = new List<Oportunidad_platform__c>();
        }else{
            lop = mapResOps.get(o.Residente__c);
        }
        
        lop.add(new Oportunidad_platform__c(Id = o.Id, 
                                            Etapa__c = o.Etapa__c,
                                            Residente__c = o.Residente__c, 
                                            Motivo_de_Alta_Comercial__c = o.Motivo_de_Alta_Comercial__c));
        mapResOps.put(o.Residente__c, lop);        
    }    
}