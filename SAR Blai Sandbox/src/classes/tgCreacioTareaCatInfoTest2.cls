@isTest
private class tgCreacioTareaCatInfoTest2 {
    static testMethod void myUnitTest() {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {
            User testUser = new User();
            testUser.Username= 'pruebaCATINFO@company.com';
            testUser.Email = 'testuser1@company.com';
            testUser.Lastname = 'user';
            testUser.Firstname = 'test';
            testUser.Alias = 'test';
            testUser.CommunityNickname = '12346';
            //Role ATC Zona
            testUser.UserRole = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%Zona%' LIMIT 1];
            testUser.ProfileId = '00eb0000000dTGnAAM';    
            testUser.TimeZoneSidKey = 'GMT';
            testUser.LocaleSidKey = 'en_US';
            testUser.EmailEncodingKey = 'ISO-8859-1';
            testUser.LanguageLocaleKey = 'en_US';
            testUser.UserPermissionsMobileUser = false;
            testUser.Zona_Comercial__c = 'Barcelona';
            testUser.isActive = true;  
            triggerHelper.recursiveHelper1(true);
            insert testUser;
            triggerHelper.recursiveHelper1(false);
        
    	
	    	Account centro1 = new Account();
	        centro1.Name = 'Centro1';
	        centro1.RecordTypeId = '012b0000000QAeAAAW';
	        centro1.Zona_Comercial_del__c = 'Barcelona';
	        centro1.Phone = '442342343244';
	        centro1.Activo__c = true;
	        centro1.Director_del_centro__c = '005b0000000kj7HAAQ';
	        centro1.ATC_Zona__c = '005b0000001JTAn';
            centro1.Division__c = 'Residencial';
            triggerHelper.recursiveHelper1(true);
	        insert centro1;
            triggerHelper.recursiveHelper1(false);
            
            Account centro2 = new Account();
	        centro2.Name = 'Centro1';
	        centro2.RecordTypeId = '012b0000000QAeAAAW';
	        centro2.Zona_Comercial_del__c = 'Barcelona';
	        centro2.Phone = '442342343244';
	        centro2.Activo__c = true;
	        centro2.Director_del_centro__c = '005b0000000kj7HAAQ';
	        centro2.ATC_Zona__c = '005b0000001JTAn';
            centro2.Division__c = 'Domiciliaria';
            triggerHelper.recursiveHelper1(true);
	        insert centro2;
            triggerHelper.recursiveHelper1(false);
            
            
            
             //Crear Residente
        Account residente1 = new Account();
        residente1.RecordTypeId = '012b0000000QAe0AAG';
        residente1.FirstName = 'Nombre1';
        residente1.LastName = 'Apellido1';
        residente1.Residente__c = true;
        residente1.Perfil__c = 'Autónomo';
        residente1.Sexo__c = 'Hombre';
        residente1.Estado_Civil__c = 'Soltero/a';
        residente1.Tipo_Documento_Identidad__c = 'DNI';
        residente1.CIF_NIF__c = '32146871R';
        residente1.Tipo_Documento_Sanitario__c = 'NSS';
        residente1.Nuermo_Documento_Sanitario__c = '11111';
        residente1.Idioma_de_Contacto__pc = 'Castellano';
        residente1.Phone = '660085345';
        residente1.Calle__c = 'Pablo Iglesias';
        residente1.Provincia__c = 'Barcelona';
        residente1.PersonEmail = 'xgg.1990@gmail.com';
        residente1.Pais__c = 'España';
        residente1.Ciudad__c = 'Barcelona';
        residente1.Codigo_postal__c = '08016';
        residente1.IdNAV_RES__c = 'TRES55560';
        residente1.Historia_de_vida_adjunta__c = false;
        residente1.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        triggerHelper.recursiveHelper1(true);
        insert residente1;
        triggerHelper.recursiveHelper1(false);
            RecordType RecCatInfo = [select id from recordtype where name= 'CAT - Información'];
            Task t2 = new Task();
	        t2.RecordTypeId = RecCatInfo.id;
	        t2.Resultado__c = 'Información';
	        t2.Subject = 'Interés residencias de una Zona Comercial';
	        t2.Procedencia__c = 'Vecindad';
	        t2.Status = 'Pendiente';
	        t2.Priority = 'Normal';
	        t2.OwnerId = UserInfo.getUserId();
	        t2.WhatId = centro1.Id;
            t2.Canal__c = 'Chat';
	        t2.Zona_Comercial__c = 'Barcelona';
            t2.Centro_residencial__c = centro1.id;
	        insert t2;
        }
	}
}