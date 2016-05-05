/** 
* File Name:   tgUpdatePrecioDispOp
* Description: Actualiza el precio del dispositivo y el descuento del colgante
* Copyright:   Konozca 
* @author:     Jose M Perez
*/

trigger TgUpdatePrecioDispOp on Oportunidad_platform__c (before insert, before update) {
    System.debug('entra en TgUpdatePrecioDispOp');
    RecordType RTDuo = [Select id from Recordtype where DeveloperName = 'Oportunidad_TA_Duo'];
    RecordType RTTAD = [Select id from Recordtype where DeveloperName = 'Oportunidad_TAD'];
    RecordType RTTAM = [Select id from Recordtype where DeveloperName = 'Oportunidad_TAM'];
    for (Oportunidad_platform__c opc:Trigger.new) {
        if (opc.RecordTypeId == RTDuo.id || opc.RecordTypeId == RTTAD.id ||opc.RecordTypeId == RTTAM.id) {
            
        // ACTUALIZAR DESCUENTO COLGANT
        if(opc.NOC__c==null && opc.NOC_12_Convenios__c==null){
            opc.Descuento_colgante__c = null;
            opc.Descuento__c = null;
        }
        
        //ACTUALIZAR PRECIO DEL DISPOSITIVO
        opc.Precio_Dispositivo_new__c = 0;
        //si la Oportunidad NOC tiene una NOC12, asignar tarifa de NOC12
        System.debug('op name = ' + opc.Name);
        System.debug('NOC_12_Convenios__c = ' + opc.NOC_12_Convenios__c);
        if(opc.NOC_12_Convenios__c != null){
            System.debug('NOC12 encontrada');
            //primero: seleccionar noc 12 asociada a la opc
            //segundo: de la lista de centros/servicios asociados a la noc12,
            //seleccionar aquel con Servicio TA igual al Servicio TA de la opc
            
            List <Centros_NOC__c> lcnoc12 = [ SELECT id, Name, NOC_TAD__c, Precio_dispositivo__c, Servicio_TA__c 
                                             FROM Centros_NOC__c WHERE NOC_TAD__c =: opc.id ];
            
            System.debug('lnoc12 size = ' + lcnoc12.size());
            for(Centros_NOC__c cnoc12 : lcnoc12){
                if(cnoc12.Servicio_TA__c == opc.Servicio__c && cnoc12.Precio_Dispositivo__c!=null){
                    opc.Precio_Dispositivo_new__c = cnoc12.Precio_Dispositivo__c;
                    System.debug('OP + ' + opc.Name + ' Asignado precio dipositivo = ' +
                                 opc.Precio_Dispositivo_new__c);
                    break;
                }
            }
        }
        //si la Oportunidad NOC tiene una NOC9, asignar tarifa de NOC9 aqui
        else if(opc.NOC__c != null){
            //System.debug('NOC9 encontrada');
            List <Centros_NOC__c> lcnoc9 = [ SELECT id, Name, NOC_TAD__c, Precio_dispositivo__c, Servicio_TA__c 
                                            FROM Centros_NOC__c WHERE NOC_TAD__c =: opc.id ];
            
            //System.debug('lnoc9 size = ' + lcnoc9.size());
            for(Centros_NOC__c cnoc9 : lcnoc9){
                if(cnoc9.Servicio_TA__c == opc.Servicio__c && cnoc9.Precio_Dispositivo__c!=null){
                    opc.Precio_Dispositivo_new__c = cnoc9.Precio_Dispositivo__c;
                    //System.debug('OP + ' + op.Name + ' Asignado precio dipositivo = ' + 
                    //            op.Precio_Dispositivo_new__c);
                    break;
                }
            }
        } }                   
    }
}