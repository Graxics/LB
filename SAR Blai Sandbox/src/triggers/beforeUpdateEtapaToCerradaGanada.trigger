trigger beforeUpdateEtapaToCerradaGanada on Oportunidad_platform__c (before update) {
    if(triggerHelper.todofalse() && userInfo.getUserName() != 'wssarq@sarquavitae.es') {
     if (TriggerHelperExecuteOnce.executar3() == true ) {   
    System.debug('Entra en el trigger');
    List<Id> opportunityId = new List<Id>();
    Map<id,Boolean> Errores= new Map<id,Boolean>();
    Map<id,Boolean> Errores2= new Map<id,Boolean>();
    Map<id,Boolean> Pagadores = new Map<id,Boolean>();
    Map<id,Boolean> Principales = new Map<id,Boolean>();
    Map<id,Boolean> ErroresPagador = new Map<id,Boolean>();
    Map<id,Boolean> ErroresPrincipal = new Map<id,Boolean>();
    for(Oportunidad_platform__c op:Trigger.new){
        System.debug('OK 1');
        //les que ja estaven en 'Cerrada ganada! no fa falta comprovarles
        Oportunidad_platform__c opp_old = Trigger.oldMap.get(op.id);
        //afegim a la llista nomes aquelles que s'actualitzen a 'Cerrada ganada'
        if(opp_old.Etapa__c != 'Cerrada ganada' && op.Etapa__c == 'Cerrada ganada'){
            opportunityId.add(op.id);
        }
    }
    id RecTypeBen = Schema.SObjectType.Relacion_entre_contactos__c.getRecordTypeInfosByName().get('Relacion de beneficiarios').getRecordTypeId();
    //selecionem les relaciones entre contactos que pertanyen a les oportunitats anteriorment seleccionades
    List<Relacion_entre_contactos__c> relcon = [SELECT Oportunidad__c, id, Usuario_Principal__c,Beneficiario__r.CIF_NIF__c,Beneficiario__r.pais__c,Beneficiario__r.phone,Beneficiario__r.provincia__c,Beneficiario__r.calle__c,Beneficiario__r.Tipo_Documento_Identidad__c, Activo__c,Pagador__c, RecordTypeId,Beneficiario__r.Codigo_postal__c,Beneficiario__r.Ciudad__c FROM Relacion_entre_contactos__c WHERE Oportunidad__c = :opportunityId AND RecordTypeId=:RecTypeBen and Activo__c = true];
    
    
    //Map<Id, Relacion_entre_contactos__c> mapOr = new Map<Id, Relacion_entre_contactos__c>();
    
    //per si pot haver mes d'una relacio de tipus beneficiari per cada oportunitat
    /*Map<Id, List<Relacion_entre_contactos__c>> mapOr = new Map<Id, List<Relacion_entre_contactos__c>>();
    for(Relacion_entre_contactos__c rc:relcon){
        List<Relacion_entre_contactos__c> l = List<Relacion_entre_contactos__c>();
        if(mapOr.containsKey(rc.id)){
            l = mapOr.get(rc.id);
            l.add(rc);
        }else{
            l.add(rc);
        }
        mapOr.put(rc.Oportunidad__c, l);
    }*/
    
    //per si nomes hi pot haver una relacio de tipus beneficiari per cada oportunitat
    Map<Id, Relacion_entre_contactos__c> mapOr = new Map<Id, Relacion_entre_contactos__c>();
    for(Relacion_entre_contactos__c rc:relcon){
        if (rc.Activo__c && rc.Usuario_principal__c) {
            if (Principales.get(rc.Oportunidad__c) != null) {
                ErroresPrincipal.put(rc.Oportunidad__c, true);
            }
            if (rc.Beneficiario__r.phone == null || rc.Beneficiario__r.calle__c == null  || rc.Beneficiario__r.Codigo_postal__c == null || rc.Beneficiario__r.Ciudad__c == null || rc.Beneficiario__r.provincia__c == null || rc.Beneficiario__r.pais__c == null) {
                Errores2.put(rc.Oportunidad__c,true);
            }
            Principales.put(rc.Oportunidad__c,true);
            mapOr.put(rc.Oportunidad__c, rc);
        }
        
        if (rc.Pagador__c) {
            if (rc.Beneficiario__r.CIF_NIF__c == null || rc.Beneficiario__r.calle__c == null ||rc.Beneficiario__r.Tipo_Documento_Identidad__c == null || rc.Beneficiario__r.Codigo_postal__c == null || rc.Beneficiario__r.Ciudad__c == null || rc.Beneficiario__r.provincia__c == null) {
                Errores.put(rc.Oportunidad__c,true);
            }
            if (Pagadores.get(rc.Oportunidad__c) != null) {
                ErroresPagador.put(rc.Oportunidad__c, true);
            }
            Pagadores.put(rc.Oportunidad__c,true);
            
    	}
    }
    

    for(Oportunidad_platform__c op:Trigger.new){
        //si "Beneficiario con colgante" i "Beneficiario activo" no estan a true, no pot deixar crear la oportunitat
        //Oportunidad_platform__c errorOpp = mapOr.get(rc.id);
        Relacion_entre_contactos__c con = mapOr.get(op.id);
        System.debug('Llega casi al final');
        Oportunidad_platform__c opp_old = Trigger.oldMap.get(op.id);
        if(opp_old.Etapa__c != 'Cerrada ganada' && op.Etapa__c == 'Cerrada ganada'){
            if (Pagadores.get(op.id) == null) {
                 op.AddError('Tiene que existir un pagador activo si la etapa de la Oportunidad es Cerrada ganada');
            }
            if (ErroresPagador.get(op.id) != null) {
                 op.AddError('No puede existir más de 1 pagador activo para una misma oportunidad');
            }if (ErroresPrincipal.get(op.id) != null) {
                 op.AddError('No puede existir más de 1 usuario principal activo para una misma oportunidad');
            }
            if (Errores.get(op.id) != null) {
                op.AddError('El Tipo de documento, el NIF, la calle, el código postal, la ciudad y la provincia son obligatorios en el pagador');
            }
            if (Errores2.get(op.id) != null) {
                op.AddError('La calle, el código postal, la ciudad,la provincia,el país y el teléfono son obligatorios en el usuario principal');
            }
            
        
        if (con != null){
            System.debug('OK 2');
            if(!con.Usuario_Principal__c || !con.Activo__c){
                System.debug('OOOOOKKKKK');
                op.addError('Si la oportunidad es cerrada ganada, debe haber una relacion entre contactos con beneficiario con colgante y beneficiario activo');
            }
        }
        else {
            op.addError('Si la oportunidad es cerrada ganada, debe haber una relacion entre contactos con beneficiario con colgante y beneficiario activo');
        }
       }
    }
         }
   }     
}