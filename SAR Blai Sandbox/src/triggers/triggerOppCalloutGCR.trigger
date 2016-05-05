trigger triggerOppCalloutGCR on Oportunidad_platform__c (after update) {
    System.debug('Llego al trigger 1');
    
    if (TriggerHelperExecuteOnce.executar14() == true || Test.isRunningTest()) {
        Recordtype adorea = [select id from recordtype where name = 'Oportunidad Adorea'];
        System.debug('Llego al trigger 2');
        for (Oportunidad_platform__c opp :Trigger.new) {
            System.debug('Llego al trigger 3');
            if(!opp.Integracion_Desactivada__c && opp.recordtypeid != adorea.id) {
                System.debug('Llego al trigger 4');
                Oportunidad_platform__c oldopp = Trigger.OldMap.get(opp.id);
           		if(opp.Fecha_Respuesta_Navision__c != null && ( oldopp.Fecha_Respuesta_Navision__c != opp.Fecha_Respuesta_Navision__c)) {
                	GCRCalloutClass.createResidente(opp.Residente__c, opp.Pagador__c, opp.id);
        		}
            }
    	}
    }
}