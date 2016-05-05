/** 
* File Name:   TestTgNocRechazada 
* Description: Test del trigger TgNocAprobada
* Copyright:   Konozca 
* @author:     Hector Mañosas
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 11/10/2014
* =============================================================== 
**/ 
@isTest
private class TestTgNocAprobada {

    static testMethod void myUnitTest() {
    	
    	RecordType rtn = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE DeveloperName = 'NOC_9_Campana'];
    	RecordType rc = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE DeveloperName = 'Centros_Servicios_NOC_mejorada' LIMIT 1];
    	
    	//Insert NOC    	
        NOC__c testIS = new NOC__c();
        testIS.RecordTypeId = rtn.Id;
        testIS.Estado_Flujo__c = 'Pendiente';        
        testIS.Fecha_inicio__c = System.today().addDays(-30);
        testIS.Fecha_fin__c = System.today().addDays(15);
        testIs.Visibilidad_Centros_1__c = 'CANBUXERES';
        testIS.Duracion_del_descuento__c = 10;
        //testIS.Id_contrato__c = 'CTR00001';
        testIS.Residencial__c = true;
        triggerHelper.recursiveHelper3(true);        
        insert testIS;
        triggerHelper.recursiveHelper3(false);
        
        //Creamos una Account de tipo Centro
        Account centro1 = new Account();
        centro1.Name = 'Can Buxeres';
        centro1.RecordTypeId = '012b0000000QAeAAAW';        
        centro1.Phone = '442342343244';
        centro1.Activo__c = true;
        centro1.Director_del_centro__c = '005b0000000kj7HAAQ';
        centro1.Division__c = 'Residencial';
        centro1.Zona_Comercial_del__c = 'Barcelona';
        centro1.IdNAV__c = 'CANBUXERES';
        triggerHelper.recursiveHelper3(true);
        insert centro1;
        triggerHelper.recursiveHelper3(false);
        
        //Creamos un centro NOC para la NOC 9
        Centros_NOC__c cNoc1 = new Centros_NOC__c();
        cNoc1.RecordTypeId = rc.Id;	        
        cNoc1.NOC__c = testIS.Id;       
        cNoc1.Descuento__c = 12;
        cNoc1.Division__c = 'Residencial';
        cNoc1.Tipo_Servicio_2__c = 'Residencial';
        cNoc1.Tipo_Estancia_2__c = 'Temporal';
        cNoc1.Tipo_Ocupacion_2__c = 'HD';
        cNoc1.Grado__c = 'Grado1';        
        insert cNoc1;
        
        testIS.Estado_Flujo__c = 'Aprobado';
        update testIS;   	
//anulo el último update debido a la nueva regla que ha añadido cristina
//
// TestTgNocAprobada.myUnitTest(), Details: System.DmlException: Update failed. First exception on row 0 with id a04b000000HNJTGAA5; 
// first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, No se puede modificar una NOC aprobada: [] Class.TestTgNocAprobada.myUnitTest: line 59, column 1        
// Eugenio
         
   		} 	
}