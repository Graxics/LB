/** 
* File Name:   TriggerVisibilidadNOC 
* Description: Añade la visibilidad de centros y zona comercial a la NOC
* Copyright:   Konozca 
* @author:     Hector Mañosas
* Modification Log 
* =============================================================== 
*Date     		Author          Modification 
* 22/07/2014 	HManosas		
* =============================================================== 
**/

@isTest
private class TestTriggerVisibilidadNOC {

    static testMethod void myUnitTest() {
                
        //Creamos una Account de tipo Centro
        Account centro1 = new Account();
        centro1.Name = 'Centro1';
        //centro1.RecordTypeId = '012b0000000QAeAAAW';     //Centro   getRecordTypeId
        centro1.RecordTypeId = getRecordTypeId('Centro');
        //centro1.RecordTypeId = getRecordTypeId('Centro');
        centro1.Phone = '442342343244';
        centro1.Activo__c = true;
        centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.Division__c = 'Residencial';
        centro1.Zona_Comercial_del__c = 'Barcelona';
        centro1.IdNAV__c = 'CANBUXERES';
        centro1.Tipo_centro__c = 'Mixto';
        triggerHelper.recursiveHelper1(true);
        insert centro1;
        triggerHelper.recursiveHelper1(false);
        
        //Creamos una nueva Account de tipo Centro
        Account centro2 = new Account();
        centro2.Name = 'Centro2';
        //centro2.RecordTypeId = '012b0000000QAeAAAW';      //Centro  
        centro2.RecordTypeId = getRecordTypeId('Centro');
        centro2.Phone = '442342343244';
        centro2.Activo__c = true;
        centro2.Director_del_centro__c = '005b0000001JTCKAA4';
        centro2.Division__c = 'Residencial';
        centro2.Zona_Comercial_del__c = 'Centro';
        centro2.IdNAV__c = 'MONTMARTI';
        triggerHelper.recursiveHelper1(true);
        insert centro2;
        triggerHelper.recursiveHelper1(false);
        
        //Creamos una NOC de tipo Convenio
        NOC__c noc1 = new NOC__c();
        //noc1.RecordTypeId = '012b0000000QBd0AAG'; //NOC12 Convenios
        noc1.RecordTypeId = getRecordTypeId('NOC 12 Convenios');
        noc1.Name = 'noc1';
        noc1.Estado_Flujo__c = 'Aprobado';        
        noc1.Fecha_inicio__c = Date.today().addDays(-30);
        noc1.Fecha_fin__c = Date.today().addDays(30);
        noc1.Descuento_permanente__c = true;
        noc1.Residencial__c = true;
        //noc1.Duracion_del_descuento__c = 30;
        triggerHelper.recursiveHelper1(true);       
        insert noc1;
        triggerHelper.recursiveHelper1(false);
        
        RecordType rtCNoc1 = [SELECT Id,Name FROM RecordType WHERE Developername='Centros_Servicios_NOC_mejorada']; 
        
        //Creamos un centroNOC para la NOC2 Convenio
        Centros_NOC__c cNoc1 = new Centros_NOC__c();
        cNoc1.RecordTypeId = rtCNoc1.Id;
        cNoc1.NOC__c = noc1.Id;
        cNoc1.Centro__c = null;
        cNoc1.Zona_Comercial_2__c = null;
        cNoc1.Division__c = 'Residencial';
        cNoc1.Precio__c = 10;
        cNoc1.Tipo_Servicio_2__c = 'Residencial';
        cNoc1.Tipo_Estancia_2__c = 'Permanente';
        cNoc1.Tipo_Ocupacion_2__c = 'HD';
        cNoc1.Grado__c = 'Grado1';        
        insert cNoc1;
        
        //Creamos un nuevo centroNOC para la NOC2 Convenio
        Centros_NOC__c cNoc2 = new Centros_NOC__c();
        cNoc2.RecordTypeId = rtCNoc1.Id;
        cNoc2.NOC__c = noc1.Id;
        cNoc2.Centro__c = null;
        cNoc2.Zona_Comercial_2__c = null;
        cNoc2.Division__c = 'Residencial';
        cNoc2.Precio__c = 10;
        cNoc2.Tipo_Servicio_2__c = 'Residencial';
        cNoc2.Tipo_Estancia_2__c = 'Permanente';
        cNoc2.Tipo_Ocupacion_2__c = 'HD';
        cNoc2.Grado__c = 'Grado2';
		
        insert cNoc2;
        
        //Actualizamos la Zona Comercial del centro NOC
        cNoc1.Zona_Comercial_2__c = 'Barcelona';
        cNoc1.Division__c = null;
        update cNoc1;
        
        //Actualizamos el centro del centro NOC
        cNoc1.Centro__c = centro1.Id;
        cNoc1.Zona_Comercial_2__c = null;
        update cNoc1;
        
        //Creamos un nuevo centroNOC para la NOC2 Convenio
        Centros_NOC__c cNoc3 = new Centros_NOC__c();
        cNoc3.RecordTypeId = rtCNoc1.Id;
        cNoc3.NOC__c = noc1.Id;
        cNoc3.Centro__c = centro2.Id;
        cNoc3.Zona_Comercial_2__c = null;
        cNoc3.Division__c = null;
        cNoc3.Descuento__c = 25;
        cNoc3.Tipo_Servicio_2__c = 'Residencial';
        cNoc3.Tipo_Estancia_2__c = 'Permanente';
        cNoc3.Tipo_Ocupacion_2__c = 'HD';
        cNoc3.Grado__c = 'Grado2';        
        insert cNoc3;             
        
        //Borramos el centro NOC
        delete cNoc1;        
        
    }
    
    public static String getRecordTypeId(String name){
        List<RecordType> rt = [ Select id FROM RecordType WHERE Name =: name LIMIT 1 ];
        return (rt.size()> 0) ? rt.get(0).id : null;
    }
}