/** 
* File Name:   BeforeUpdateOportunidad
* Description:Trigger que comprueba que cuando se escoje un servicio de la oportunidad, coincida con el ámbito de ésta.
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version    Date        Author           Modification 
* 01        05/03/2015  Xavier Garcia
* =============================================================== 
**/ 
trigger BeforeUpdateOportunidad on Oportunidad_platform__c (before update,before insert) {

	if(triggerHelper.todofalse()) {
        
        if (TriggerHelperExecuteOnce.executar2() == true && userInfo.getUserName() != 'wssarq@sarquavitae.es') {
            Date Inicio = Date.newInstance(2015,3,10);
            //Mensaje de error que se mostrará si no coincide el tipo de servicio con el ámbito
            String ErrorMessage = 'El tipo de servicio tiene que coincidir con el ámbito';
            //Lista de Oportunidades las cuales se le modifican el servicio o el ambito
            List<Oportunidad_platform__c> OpsModificadas = new List<Oportunidad_platform__c>();
            //Lista de id de servicios
            List<id> IdsServicios = new List<id>();
            //Map de las oportunidades modificadas donde el boolean nos indicará si se tiene que mostrar el error o no.
            Map<id,Boolean> OpsError = new Map<id,Boolean>();
            //Map de Servicios
            Map<ID, Servicio__c> MapServicios = new Map<ID, Servicio__c>();
            List<id> opTa = new List<id>();
            //Recorremos todas las ops modificadas y si se modifica el ambito o el tipo de servicio y, ademas,
            //Ninguno de los dos es nulo, guardamos la opp y el servicio en sus listas
            for (Oportunidad_platform__c oportunidad:Trigger.new) {
                if (Trigger.isUpdate) {
                    Oportunidad_platform__c OldOportunitat = Trigger.oldMap.get(oportunidad.Id);
                //if (OldOportunitat.Servicio__c != oportunidad.Servicio__c || OldOportunitat.ambito__c != oportunidad.ambito__c ) {*/
                    if ((oportunidad.recordtypeid == '012b0000000QBG6' || oportunidad.recordtypeid == '012b0000000QBG1') && oportunidad.Servicio__c != null && oportunidad.ambito__c != null && OldOportunitat.Etapa__c != 'Ingreso' && OldOportunitat.Etapa__c != 'Cerrada por el sistema' && OldOportunitat.Etapa__c != 'No ingreso') {
                        OpsModificadas.add(oportunidad);
                        IdsServicios.add(oportunidad.Servicio__c);
                    }
                    if (oportunidad.etapa__c == 'Cerrada ganada' && oportunidad.etapa__c != OldOportunitat.etapa__c) {
                        opTa.add(oportunidad.id);
                    }
                }
                else if (Trigger.isInsert) {
                    if ((oportunidad.recordtypeid == '012b0000000QBG6' || oportunidad.recordtypeid == '012b0000000QBG1') && oportunidad.Servicio__c != null && oportunidad.ambito__c != null) {
                        OpsModificadas.add(oportunidad);
                        IdsServicios.add(oportunidad.Servicio__c);
                    }
                }
            }
            //Recorremos todos los servicios de las ops modicadas y nos guardamos en el map los datos del servicio
            for (Servicio__c servicio:[SELECT id,Tipo_Servicio__c from Servicio__c where id IN:IdsServicios]) {
                MapServicios.put(servicio.id, servicio);
            }
            if (OpsModificadas.size() > 0) {
                //Obtenemos el documento y convertimos a String el texto del documento para poder hacer el mapeo
                List<Document> mapeos = [Select Id, Name, Body FROM Document WHERE DeveloperName = 'Mapeig_Ambito_Servicio' LIMIT 1];
                Document mapeo = new Document();
                if (mapeos.size() > 0) {
                    mapeo = mapeos[0];
                    //Document mapeo = [Select Id, Name, Body FROM Document WHERE DeveloperName = 'Mapeig_Ambito_Servicio' LIMIT 1];
                    String TextoDocumento = mapeo.Body.toString();
                    //Para todas las ops que cumplen las condiciones, miramos si el servicio seleccionado corresponde al ambito.
                    for (Oportunidad_platform__c opModificada:OpsModificadas) {
                        String ambito = opModificada.ambito__c;
                        System.debug('AMBITO: '+ambito);
                        String TipoServicio = MapServicios.get(opModificada.Servicio__c).Tipo_Servicio__c;
                        System.debug('TipoServicio: '+TipoServicio);
                        //Obtenemos el substring entre el ambito y el primer ; que encuentre, de modo que es en donde buscaremos si
                        //el tipo de servicio es correcto.
                        String subTexto = TextoDocumento.substringBetween(ambito, ';');
                        System.debug('SUBTEXTO: '+subTexto);
                        //Buscamos en el substring el tipo de servicio. Si no lo encuentra (posicion = -1),devolverá ERROR.
                        Integer posicio = subTexto.indexOf(TipoServicio);
                        System.debug('POSICIO: '+posicio);
                        if (posicio < 0) {
                            OpsError.put(opModificada.id,true);
                        }
                        else {
                            OpsError.put(opModificada.id,false);
                        }
                    }
                    //Recorremos las opps y devolvemos un error en caso de que el servicio no corresponda al ámbito
                    for (Oportunidad_platform__c oportunidad:Trigger.new) {
                        if (OpsError.get(oportunidad.id) == true) {
                            oportunidad.addError(ErrorMessage);
                        }
                    }
               }
            }
            Map<id,Boolean> OpsTABones = new Map<id,Boolean>();
            for (Relacion_entre_contactos__c rel:[Select id,oportunidad__c,usuario_principal__c from Relacion_entre_contactos__c where oportunidad__c IN:opTa and usuario_principal__c = true and activo__c = true]) {
                OpsTABones.put(rel.oportunidad__c,true);
            }
            for (Oportunidad_platform__c op:trigger.new) {
                if (Trigger.isUpdate) {
                    Oportunidad_platform__c OldOportunitat = Trigger.oldMap.get(op.Id);
                    if (op.etapa__c == 'Cerrada ganada' && op.etapa__c != OldOportunitat.etapa__c) {
                        if (OpsTABones.get(op.id) == null) {
                            op.AddError('No se puede pasar la oportunidad a cerrada ganada si no tiene un usuario principal');
                        }
                    }
                }
            }//fin FOR
    	}// fin IF 
        
	}//fin IF  
  
}//fin TRIGGER