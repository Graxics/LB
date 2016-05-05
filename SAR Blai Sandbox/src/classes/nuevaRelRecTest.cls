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
private class nuevaRelRecTest {

    static testMethod void myUnitTest() {
    	
    	User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    	
    	System.runAs ( thisUser ) {
    	
	        User uAux = [Select Id, Zona_Comercial__c, ProfileId From User LIMIT 1];
			uAux.Zona_Comercial__c = 'Barcelona';
			uAux.UserRoleId = '00Eb0000000h3VX';
			update uAux;
    	}
		
		Account centro1 = new Account();
        centro1.Name = 'Centro1';
        centro1.RecordTypeId = '012b0000000QAd7AAG';
        centro1.Zona_comercial__c = 'Centro';
        centro1.Phone = '444123123222224';
        centro1.Activo__c = true;
        centro1.Zona_Comercial__c = 'Barcelona';
        centro1.Clasificacion_tipo_recomendador__c = 'A';
        centro1.Residencial__c = true;
        centro1.Provincia__c = 'Barcelona';
        insert centro1;
		
        Account rec = new Account();
		rec.RecordTypeId = '012b0000000QCbtAAG';
		rec.FirstName = 'rc1';
        rec.PersonEmail = 'test@test.com';
		rec.LastName = 'rec1';
		rec.Phone = '412321233144';
		rec.Activo__c = true;
		rec.Clasificacion_tipo_recomendador__c = 'A';
        rec.Residencial__c = true;
		insert rec;
		
		 Account a1 = new Account();
        a1.FirstName = '1';
        a1.LastName = 'cliente1 apell';
        a1.PersonEmail = 'test@test.com';
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
        a1.CIF_NIF__c = '53788260T';
        a1.Calle__c = 'Carrer de buenos aires 34';
        a1.Ciudad__c = 'Barcelona';
        a1.PersonBirthdate = Date.today();
        a1.Codigo_postal__c  = '08036';
        insert a1;
        
        Account a2 = new Account();
        a2.FirstName = '2';
        a2.LastName = 'cliente2 apell';
        a2.Perfil__c = 'Autónomo';
        a2.PersonEmail = 'test@test.com';
        a2.Apellido_2__c = 'apell';
        a2.Idioma_de_Contacto__pc = 'Catalan';
        a2.Residente__c = true;
        a2.RecordTypeId = '012b0000000QAe0AAG';
        a2.Tipo_Documento_Sanitario__c = 'NCS';
        a2.Tipo_Documento_Identidad__c = 'DNI';
        a2.CIF_NIF__c =  '70016556W';
        a2.Nuermo_Documento_Sanitario__c = '222';
        a2.Estado_Civil__c = 'Casado/a';
        a2.Sexo__c = 'Hombre';
        a2.Phone = '5552342343245';
        a2.Calle__c = 'Gran Via 24';
        a2.Ciudad__c = 'Madrid';
        a2.PersonBirthdate = Date.today();
        a2.Codigo_postal__c  = '28013';
        insert a2;
        
		Relacion_entre_contactos__c rer = new Relacion_entre_contactos__c();
		rer.RecordTypeId = '012b0000000QCc3AAG';
		rer.Contacto_Recomendador__c = rec.Id;
		rer.Empresa_recomendadora__c = centro1.Id;
		insert rer;
		
		Relacion_entre_contactos__c rer2 = new Relacion_entre_contactos__c();
		rer2.RecordTypeId = '012b0000000QCbyAAG';
		rer2.Residente__c = a1.Id;
		rer2.Contacto__c = a2.Id;
		insert rer2;
		
		rer2.Ultima_Mod__c = 'fromGCR';
		update rer2;
    }
}