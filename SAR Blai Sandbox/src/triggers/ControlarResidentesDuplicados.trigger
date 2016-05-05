/** 
* File Name:   ControlarResidentesDuplicados
* Description:Trigger before Oportunidad que controla que no existan dos oportunidades privadas abiertas con el mismo residente por centro y servicio
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version    Date        Author           Modification 
* 01        25/09/2015  Xavier Garcia
* =============================================================== 
**/ 
trigger ControlarResidentesDuplicados on Oportunidad_platform__c (before insert,before update) {
    if(triggerHelper.todofalse() && userInfo.getUserName() != 'wssarq@sarquavitae.es') {
    List<id> IdResidentes = new List<id>();
    List<id> IdOpsModificadas = new List<id>();
    List<id> ServiciosIds = new List<id>();
    Map<id,Servicio__c> InfoServicios = new Map<id,Servicio__c>();
    //Map de residentes existentes
    Map<id,Oportunidad_platform__c> ResidentesExistentes = new Map<id,Oportunidad_platform__c>();
    //Map de residentes duplicados
    Map<id,Boolean> ResidentesDuplicados = new Map<id,Boolean>();
    //Nos recorremos las ops modificadas y/o insertadas
    for (Oportunidad_platform__c op:Trigger.new) {
        //Si tiene el residente informado y la fecha de cierre no informada 
        //nos guardamos el id del residente en una lista de ids.
        if (op.Fecha_cierre__c == null && op.Residente__c != null  && op.Centro2__c != null && op.Servicio__c != null && op.recordtypeid =='012b0000000QBG6') {
            //Si el trigger es Update nos guardamos las ops para no mirarlas en el select,
            //sino en el for de despues
            if (Trigger.isUpdate) {
                IdOpsModificadas.add(op.id);
            }
            //Nos guardamos en una lista de ids los servicios de las ops modificadas
            ServiciosIds.add(op.Servicio__c);
            IdResidentes.add(op.Residente__c);
        }
    }
    //Hacemos una consulta de las ops donde el residente está en la lista de ids y las ops no son las modificadas
    for (Oportunidad_platform__c op:[Select id, residente__c, Servicio__r.Tipo_Servicio__c,centro2__c from Oportunidad_platform__c where residente__c IN:IdResidentes and id NOT IN:IdOpsModificadas and Fecha_cierre__c = null]) {
        System.debug('Ops existentes ControlarDuplicados');
        //Si el residente de la op Actual NO existe en el map, lo añadimos.
        if (ResidentesExistentes.get(op.Residente__c) == null) {
            ResidentesExistentes.put(op.Residente__c, op);
            System.debug('FOR1: Añadimos el residente al Map ResidentesExistentes porque el residente no existia');
        }
        //Si el residente de la op Actual SI existe en el map ->
        	//Miramos si el tipo de servicio y el centro de la op del residente coincide con el del map.
        	//Si coincide la opp está duplicada y lo añadimos al map.
        else {
            Oportunidad_platform__c OpExistente = ResidentesExistentes.get(op.Residente__c);
            if (op.Servicio__r.Tipo_Servicio__c == OpExistente.Servicio__r.Tipo_Servicio__c && op.centro2__c == OpExistente.Centro2__c) {
                ResidentesDuplicados.put(op.Residente__c, true);
                System.debug('FOR1: Añadimos el residente al Map ResidentesDuplicados porque el residente CENTRO/SERVICIO ya existia');
            }
            //Añadimos la opp al map de residentes existentes esté o no duplicada
            ResidentesExistentes.put(op.Residente__c, op);
        }
    }
    //Nos guardamos en un map la info de los servicios por id.
    for (Servicio__c s:[Select id,Tipo_Servicio__c from Servicio__c where id IN:ServiciosIds]) {
        InfoServicios.put(s.id, s);
        System.debug('FOR2: Añadimos el servicio al map InfoServicios');
    }
    //Nos recorremos las ops modificadas y/o insertadas. 
    for (Oportunidad_platform__c op:Trigger.new) {
        //Si tiene el residente informado y la fecha de cierre no informada
        if (op.Fecha_cierre__c == null && op.Residente__c != null  && op.Centro2__c != null && op.Servicio__c != null && op.recordtypeid =='012b0000000QBG6') {
            //Miramos si el residente existe en el map de duplicados. Si existe lanzamos un error.
            if (ResidentesDuplicados.get(op.Residente__c) == null) {
                System.debug('FOR3: Entramos en el if porque el residente no está duplicado');
                if (ResidentesExistentes.get(op.Residente__c) == null) {
            		ResidentesExistentes.put(op.Residente__c, op);
                    System.debug('FOR3: Añadimos el residente al Map ResidentesDuplicados porque el residente CENTRO/SERVICIO ya existia');
        		}
                else {
                    System.debug('FOR3: Entramos en el ELSE porque el residente ya existia en el map de ResidentesExistentes');
                    Oportunidad_platform__c OpExistente = ResidentesExistentes.get(op.Residente__c);
                    Servicio__c ServicioOppActual = InfoServicios.get(op.Servicio__c);
                    if (ServicioOppActual.Tipo_Servicio__c == OpExistente.Servicio__r.Tipo_Servicio__c && op.centro2__c == OpExistente.Centro2__c) {
                        ResidentesDuplicados.put(op.Residente__c, true);
                        System.debug('FOR3: Añadimos el residente '+op.Residente__c+' al Map ResidentesDuplicados porque el residente CENTRO/SERVICIO ya existia');
                    }
                    //Añadimos la opp al map de residentes existentes esté o no duplicada
                    ResidentesExistentes.put(op.Residente__c, op);
                }  
            }
        }
    }
    for (Oportunidad_platform__c op:Trigger.new) {
        //Si tiene el residente informado y la fecha de cierre no informada 
        //nos guardamos el id del residente en una lista de ids.
        if (op.Fecha_cierre__c == null && op.Residente__c != null  && op.Centro2__c != null && op.Servicio__c != null && op.recordtypeid =='012b0000000QBG6') {
            System.debug('FOR4: El residente es '+op.Residente__c);
            System.debug('FOR4: Resultado del map ResidentesDuplicados: '+ResidentesDuplicados.get(op.Residente__c));
            if (ResidentesDuplicados.get(op.Residente__c) != null) {
                System.debug('FOR4: Lanzamos error');
                op.addError('Este residente ya dispone de una oportunidad abierta para el mismo tipo de servicio y centro');
                
            }
        }
    }
    }
}