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
private class tgDNITest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
         Account a1 = new Account();
        a1.FirstName = '1';
        a1.PersonEmail = 'test@test.com';
        a1.LastName = 'cliente1 apell';
        a1.Apellido_2__c = 'apell';
        a1.Perfil__c = 'Autónomo';
        a1.Idioma_de_Contacto__pc = 'Catalan';
        a1.Residente__c = true;
        a1.Phone = '523423423455';
        a1.RecordTypeId = '012b0000000QAe0AAG';
        a1.CIF_NIF__c = '32146871R';
        a1.Tipo_Documento_Sanitario__c = 'NCS';
        a1.Nuermo_Documento_Sanitario__c = '111';
        a1.Estado_Civil__c = 'Casado/a';
        a1.Sexo__c = 'Hombre';
        a1.Tipo_Documento_Identidad__c = 'DNI';
        a1.CIF_NIF__c = '47794178V';
        a1.Calle__c = 'Carrer de buenos aires 34';
        a1.Ciudad__c = 'Barcelona';
        a1.PersonBirthdate = Date.today();
        a1.Codigo_postal__c  = '08036';
        insert a1;
        
        Account a2 = new Account();
        a2.FirstName = '1';
        a2.LastName = 'cliente1 apell';
        a2.Apellido_2__c = 'apell';
        a2.personemail = 'test@test.com';
        a2.Perfil__c = 'Autónomo';
        a2.Idioma_de_Contacto__pc = 'Catalan';
        a2.Residente__c = true;
        a2.Phone = '523423423455';
        a2.RecordTypeId = '012b0000000QAe0AAG';
        a2.CIF_NIF__c = '19179504B';
        a2.Tipo_Documento_Sanitario__c = 'NCS';
        a2.Nuermo_Documento_Sanitario__c = '111';
        a2.Estado_Civil__c = 'Casado/a';
        a2.Sexo__c = 'Hombre';
        a2.Tipo_Documento_Identidad__c = 'DNI';
        a2.CIF_NIF__c = '56356686Q';
        a2.Calle__c = 'Carrer de buenos aires 34';
        a2.Ciudad__c = 'Barcelona';
        a2.PersonBirthdate = Date.today();
        a2.Codigo_postal__c  = '08036';
        insert a2;
    }
}