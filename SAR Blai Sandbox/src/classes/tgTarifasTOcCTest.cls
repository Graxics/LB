/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class tgTarifasTOcCTest {

    static testMethod void myUnitTest() {
    	
    	Servicio__c sc1 = new Servicio__c();
    	sc1.Name = 'sc1';
    	sc1.Tipo_Servicio__c = 'Residencial';
    	sc1.Tipo_Estancia__c = 'Permanente';
    	sc1.Tipo_Ocupacion__c = 'HD';
    	sc1.Grado_Dependencia__c = 'Grado 1';
    	insert sc1;
    	
    	Servicio__c sc2 = new Servicio__c();
      	sc2.Name = 'sc2';
    	sc2.Tipo_Servicio__c = 'Residencial';
    	sc2.Tipo_Estancia__c = 'Permanente';
    	sc2.Tipo_Ocupacion__c = 'HD';
    	sc2.Grado_Dependencia__c = 'Grado 2';
    	insert sc2;
    	
    	Servicio__c sc3 = new Servicio__c();
      	sc3.Name = 'sc3';
    	sc3.Tipo_Servicio__c = 'Residencial';
    	sc3.Tipo_Estancia__c = 'Permanente';
    	sc3.Tipo_Ocupacion__c = 'HD';
    	sc3.Grado_Dependencia__c = 'Grado 3';
    	insert sc3;
    	
    	Servicio__c sc4 = new Servicio__c();
       	sc4.Name = 'sc4';
    	sc4.Tipo_Servicio__c = 'Residencial';
    	sc4.Tipo_Estancia__c = 'Permanente';
    	sc4.Tipo_Ocupacion__c = 'HI';
    	sc4.Grado_Dependencia__c = 'Grado 1';
    	insert sc4;
    	
    	Servicio__c sc5 = new Servicio__c();
       	sc5.Name = 'sc5';
    	sc5.Tipo_Servicio__c = 'Residencial';
    	sc5.Tipo_Estancia__c = 'Permanente';
    	sc5.Tipo_Ocupacion__c = 'HI';
    	sc5.Grado_Dependencia__c = 'Grado 2';
    	insert sc5;
    	
    	Servicio__c sc6 = new Servicio__c();
    	sc6.Name = 'sc6';
    	sc6.Tipo_Servicio__c = 'Residencial';
    	sc6.Tipo_Estancia__c = 'Permanente';
    	sc6.Tipo_Ocupacion__c = 'HI';
    	sc6.Grado_Dependencia__c = 'Grado 3';
    	insert sc6;
    	
        Account com1 = new Account();
        com1.RecordTypeId = '012b0000000QC89AAG';
        com1.Name = 'com1';
        //com1.PersonEmail = 'test@test.com';
        com1.Phone = '4441556454';
        com1.Calle__c = 'Carrer valencia 20';
        com1.Ciudad__c = 'Barcelona';
        com1.Codigo_postal__c = '08505';
        com1.Provincia__c = 'Barcelona';
        com1.Tipo_analisis__c = 'Febrero';
	    com1.Ano_analisis__c = '2010';
	    com1.Precio_HD_Grado_1__c = 25.50;
		com1.Precio_HD_Grado_2__c = 90.50;
		com1.Precio_HD_Grado_3__c = 150.50;
		com1.Precio_HI_Grado_1__c = 22.00;
		com1.Precio_HI_Grado_2__c = 80.00;
		com1.Precio_HI_Grado_3__c = 100.00;
        insert com1;
    }
}