/** 
* File Name:   BeforeDeleteRecomendadoraTestClass 
* Description: Classe de test del trigger BeforeDeleteRecomendadora
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		02/04/2015  Xavier Garcia
* =============================================================== 
**/ 
@isTest
private class BeforeDeleteRecomendadoraTestClass {
    static testMethod void myUnitTest() {
        id RecomendadoraRType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Entidad Recomendadora').getRecordTypeId();
        id RecordTypeContacto = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contacto Recomendador').getRecordTypeId();
        Account recomendadora = new Account();
        recomendadora.RecordTypeId = RecomendadoraRType;
        recomendadora.Institucion_facturable__c = true;
        recomendadora.name = 'rec1';
        recomendadora.Sede_o_Delegaci_n__c = 'Sede Central';
        recomendadora.Type = 'Colectivo';
        recomendadora.Clasificacion__c = 'Asociaciones';
        recomendadora.Phone = '933589085';
        recomendadora.Provincia__c = 'Barcelona';
        recomendadora.Calle__c = 'Passeig de gracia';
        recomendadora.Ciudad__c = 'Barcelona';
        recomendadora.Codigo_postal__c = '08026';
        recomendadora.Residencial__c = true;
        recomendadora.Clasificacion_tipo_recomendador__c = 'B';
        triggerHelper.recursiveHelper1(true); 
        insert recomendadora;
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
        contact1.Empresa_recomendadora__c = recomendadora.id;      
        insert contact1;
        
        delete recomendadora;
        
    }

	
}