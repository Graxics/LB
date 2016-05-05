/** 
* File Name:   TestAfterRecomendadora 
* Description: Classe test del trigger AfterRecomendadora
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		10/07/2015  Xavier Garcia
* =============================================================== 
**/ 
@isTest


private class TestAfterRecomendadora {
    static testMethod void myUnitTest() {
        id RecomendadoraRType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Entidad Recomendadora').getRecordTypeId();
        id RecordTypeContacto = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contacto Recomendador').getRecordTypeId();
        Account centrorec = new Account();
        centrorec.Name = 'Centro3';
        centrorec.RecordTypeId = RecomendadoraRType;
        centrorec.Zona_Comercial__c = 'Barcelona';
        centrorec.Phone = '444123123222224';
        centrorec.Activo__c = true;
        centrorec.Zona_Comercial__c = 'Barcelona';
        centrorec.Division__c = 'Residencial';
        centrorec.Categoria__c = 'Exclusive';
        centrorec.Institucion_facturable__c = true;
        centrorec.Residencial__c = true;
        centrorec.Clasificacion_tipo_recomendador__c = 'A';
        centrorec.Fecha_apertura__c = System.today().addDays(-15);
        centrorec.Capacidad_Teorica__c = 100;
        centrorec.Provincia__c = 'Barcelona';
        triggerHelper.recursiveHelper1(true);        
        insert centrorec;
        triggerHelper.recursiveHelper1(false);
        
        Account contact1 = new Account();
        contact1.FirstName = 'contact1';
        contact1.LastName = 'contact1';
        contact1.RecordTypeId = RecordTypeContacto;
        contact1.Phone = '444123123222224';
        contact1.Division__c = 'Residencial';
        contact1.Categoria__c = 'Exclusive';
        contact1.Institucion_facturable__c = true;
        contact1.Residencial__c = true;
        contact1.Clasificacion_tipo_recomendador__c = 'A';
        contact1.Idioma_de_Contacto__pc = 'Castellano';
        contact1.Empresa_recomendadora__c = centrorec.id;
        triggerHelper.recursiveHelper1(true);        
        insert contact1;
        triggerHelper.recursiveHelper1(false);
        
        Account contact2 = new Account();
        contact2.FirstName = 'contact2';
        contact2.LastName = 'contact2';
        contact2.RecordTypeId = RecordTypeContacto;
        contact2.Phone = '444123123222224';
        contact2.Division__c = 'Residencial';
        contact2.Categoria__c = 'Exclusive';
        contact2.Institucion_facturable__c = true;
        contact2.Residencial__c = true;
        contact2.Clasificacion_tipo_recomendador__c = 'B';
        contact2.Idioma_de_Contacto__pc = 'Castellano';
        contact2.Empresa_recomendadora__c = centrorec.id;
        triggerHelper.recursiveHelper1(true);        
        insert contact2;
        triggerHelper.recursiveHelper1(false);
        
        centrorec.Clasificacion_tipo_recomendador__c = 'B';
        update centrorec;
        
        
        
    }
}