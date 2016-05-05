trigger tgAuxiliarMotivoAltaComercial on Oportunidad_platform__c (before insert, before update) {
    
    if(Label.tgAuxiliarMotivoAltaComercial_Activado == 'Si'){
        	System.debug('entra tgAuxiliarMotivoAltaComercial');
        	List <Account> accountsToUpdate = new List<Account>();
            for(Oportunidad_platform__c opc : trigger.new) {
        
                if(opc.Motivio_de_Alta_GCR__c != NULL)  {
                    //comprobamos si ha habido una baja del residente que proviene de GCR y actualizamos a GCR
                    MotivosAlta ma = new MotivosAlta(); 
                    String tipOp = '';
                    if(opc.RecordTypeId == '012b0000000QBG6AAO') {
                        tipOp = 'Oportunidad privada';
                    }
                    else if(opc.RecordTypeId == '012b0000000QBG1AAO') {
                        tipOp = 'Oportunidad pública';
                    }
                    
                    opc.Motivo_de_Alta_Comercial__c = ma.getSFMotivo(new List<String>{tipOp, 
                        (opc.Motivio_de_Alta_GCR__c==NULL) ? '' : opc.Motivio_de_Alta_GCR__c, 
                        (opc.Tipo_de_estancia__c==NULL) ? '' : opc.Tipo_de_estancia__c, 
                        (opc.Destino__c==NULL) ? '' : opc.Destino__c
                    });
                    
                    if(opc.Motivo_de_Alta_Comercial__c != null && opc.Residente__c != null) {
                        Account res = new Account(Id = opc.Residente__c);
                        res.Exitus__c = false;
                        res.Baja__c = true;
                        if(opc.Motivo_de_Alta_Comercial__c == 'Exitus') {
                            res.Exitus__c = true;
                        }  
                        //triggerHelper.recursiveHelper8(true); 
                        accountsToUpdate.add(res);
                        //triggerHelper.recursiveHelper8(false); 
                    }                    
                    
                }    
            }
        	update accountsToUpdate;
    }
}