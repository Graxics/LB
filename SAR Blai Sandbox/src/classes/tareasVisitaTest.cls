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
private class tareasVisitaTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        RecordType ev = [Select Id, Name From RecordType Where Name = 'Evento a Recomendador' LIMIT 1];
		RecordType cr = [Select Id, Name From RecordType Where Name = 'Contacto Recomendador' LIMIT 1];
		RecordType tr = [Select Id, Name From RecordType Where Name = 'Tarea Recomendador' LIMIT 1];
		
		Document d = new Document();
		d.Name = 'Tabla Eventos Visitas';
		d.Body = Blob.valueof('No es Director Centro ni ATC Centro del centro\n' +
		'[Zona,CentroA,CentroB,CentroC]\n' +
		'Zaragoza,6,4,2\n' +
		'Barcelona,6,4,2\n' +
		'Valencia,4,3,1\n' +
		'Centro,4,2,1\n' +
		'Sur Oriental,6,4,2\n' +
		'Sur Occidental,8,5,3\n' +
		'Mallorca,7,3,2\n' +
		'Norte,8,5,3\n' +
		'Oeste,1,1,1\n' +
		'Navarra,1,1,1\n' +
		'\n' +
		'El perfil tiene funcion de Director Centro o ATC Centro\n' +
		'[Zona,CentroA,CentroB,CentroC]\n' +
		'Zaragoza,6,4,2\n' +
		'Barcelona,3,1,1\n' +
		'Valencia,6,4,2\n' +
		'Centro,6,4,2\n' +
		'Sur Oriental,3,1,1\n' +
		'Sur Occidental,3,2,1\n' +
		'Mallorca,4,2,1\n' +
		'Norte,6,4,2\n' +
		'Oeste,5,2,1\n' +
		'Navarra,1,1,1\n');	
		d.FolderId = UserInfo.getUserId();
		insert d;
		
		User uAux = [Select Id, Zona_Comercial__c, ProfileId From User WHERE IsActive = true LIMIT 1];    
        User uAux2 = [Select Id, Zona_Comercial__c, ProfileId From User WHERE IsActive = true and profile.name = 'Comercial TA' LIMIT 1]; 
		
		Account rec = new Account();
		rec.RecordTypeId = cr.Id;
        rec.personEmail = 'test@test.com';
		rec.LastName = 'rec1';
		rec.Phone = '444484948844';
		rec.Clasificacion_tipo_recomendador__c = 'A';
        rec.Clasificacion_tipo_Recomendador_TA__c = 'A';
         rec.Residencial__c = true;
		triggerHelper.recursiveHelper1(true);
		insert rec;
		triggerHelper.recursiveHelper1(false);
		
		Contact rec2 = new Contact();
		rec2.LastName = 'rec2';
		rec2.Phone = '123456789';
		//rec2.AccountId = rec.Id;
		insert rec2;

		Event e = new Event();
		e.RecordTypeId = ev.Id;
		e.OwnerId = uAux.Id;
		e.Subject= 'Visita';
		e.WhoId = rec2.Id;
		e.Resultado__c = 'Acción Cerrada';
		e.StartDateTime = System.now();
		e.EndDateTime = System.now();
		insert e;
        
        Event et = new Event();
		et.RecordTypeId = ev.Id;
		et.OwnerId = uAux2.Id;
		et.Subject= 'Visita';
		et.WhoId = rec2.Id;
		et.Resultado__c = 'Acción Cerrada';
		et.StartDateTime = System.now();
		et.EndDateTime = System.now();
		insert et;
		
		
		Servicio__c sc = new Servicio__c();
        sc.Name = 'serv';
        insert sc;
        
		Account a1 = new Account();
        a1.FirstName = '1';
        a1.LastName = 'cliente1 apell';
        a1.Apellido_2__c = 'apell';
        a1.Perfil__c = 'Autónomo';
        a1.personemail = 'test@test.com';
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
        triggerHelper.recursiveHelper1(true);
        insert a1;
        triggerHelper.recursiveHelper1(false);
        
		Account centro1 = new Account();
        centro1.Name = 'Centro1';
        centro1.RecordTypeId = '012b0000000QAeAAAW';
        centro1.Zona_Comercial_del__c = 'Centro';
        centro1.Phone = '442342343244';
        centro1.Activo__c = true;
        centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.Recepcionista__c = '005b0000001JSQ6';
        centro1.Division__c = 'Residencial';
        triggerHelper.recursiveHelper1(true);
        insert centro1;
        triggerHelper.recursiveHelper1(false);
        
        Oportunidad_platform__c op = new Oportunidad_platform__c();
        op.Residente__c = a1.Id;
        op.Etapa__c = 'Pendiente visita';
        op.Centro2__c = centro1.Id;
        op.Canal__c = 'Llamada al Cat';
        op.Procedencia__c = 'Vecindad';
        op.Tipo_de_pago__c = 'gratis';
        op.Regimen__c = 'UED';
        op.RecordTypeId = '012b0000000QBG6AAO';
        op.Tipo_de_Financiacion__c = 'Privado';
        op.Fecha_prevista_de_ingreso__c = Date.today();
        op.Motivio_de_Alta_GCR__c = 'si';
        op.No_se_solicita_descuento__c=true;
        triggerHelper.recursiveHelper1(true);
        insert op;
        triggerHelper.recursiveHelper1(false);
        
        Event e2 = new Event();
		e2.RecordTypeId = '012b0000000QBdeAAG';
		e2.Subject= 'Visita concertada';
		e2.WhoId = rec2.Id;
		e2.WhatId = op.Id;
		e2.StartDateTime = System.now().addDays(5);
		e2.EndDateTime = System.now().addDays(5);
		e2.Lugar_de_la_visita__c = 'centro';
        e2.OwnerId = uAux2.Id;
		insert e2;
		
    }
}