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
private class testFelicitaciones {

    static testMethod void testBatch() {

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
        a1.CIF_NIF__c = '47794178V';
        a1.Calle__c = 'Carrer de buenos aires 34';
        a1.Ciudad__c = 'Barcelona';
        a1.PersonBirthdate = Date.today().addYears(-1).addDays(7);
        a1.Codigo_postal__c  = '08036';
        insert a1;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    	
    	System.runAs ( thisUser ) {
	        User uAux = [Select Id, Zona_comercial__c, ProfileId From User LIMIT 1];
			uAux.Zona_comercial__c = 'Barcelona';
			uAux.UserRoleId = '00Eb0000000h3VX';
			update uAux;
    	}
		
		Account empRec = new Account();
		empRec.RecordTypeId = '012b0000000QAd7AAG';
		empRec.Name = 'rec1 rec1';
		empRec.Phone = '412321233144';
		empRec.Clasificacion__c = 'otros';
		empRec.Calle__c = 'C/ Madrid';
		empRec.Ciudad__c = 'Barcelona';
		empRec.Codigo_postal__c = '02805';
		empRec.Fecha_apertura__c = Date.today().addYears(-1).addDays(7);
		empRec.Pais__c = 'España';
		empRec.Provincia__c = 'Barcelona';
		empRec.Zona_Comercial__c = 'Barcelona';
        empRec.Residencial__c = true;
		empRec.Clasificacion_tipo_recomendador__c = 'A';
		insert empRec;
		
        Account rec = new Account();
		rec.RecordTypeId = '012b0000000QCbtAAG';
        rec.personemail = 'test@test.com';
		rec.FirstName = 'rc1';
		rec.LastName = 'rec1 rec1';
		rec.Phone = '412321233144';
		rec.Empresa_recomendadora__c = empRec.Id;
        rec.Residencial__c = true;
		rec.PersonBirthdate = Date.today().addYears(-1).addDays(7);
		rec.Activo__c = true;
		rec.Clasificacion_tipo_recomendador__c = 'A';
		insert rec;
        
        scheduleBatch m = new scheduleBatch();
		String sch = '20 30 8 10 2 ?';
		String jobID = system.schedule('Merge Job', sch, m);
		
		Test.StartTest();
		Felicitaciones fels = new Felicitaciones();
		ID batchprocessid = Database.executeBatch(fels);
		Test.StopTest();
	
    }
}