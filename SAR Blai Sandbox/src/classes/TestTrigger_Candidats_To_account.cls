/** 
* File Name:   TestTrigger_Candidats_To_account
* Description: Test del trigger TriggerCandidatsToAccount
* Copyright:   Konozca 
* @author:     Alexander Gimenez
* Modification Log 
* =============================================================== 
*Date          Author           Modification 
 15/12/2014     AGimenez 
* =============================================================== 
**/

// El caso que se prueba es creando dos Cuentas con el mismo correo, una vip y otra no
// Creamosa continuacion una Lead con el mismo correo y que llene algunos de los campos 
// que la de vip no tenia, asi como algunos campos que si que tenian ambas. 
// El test comprueba que los cambios se han realizado efectivamente. 


@istest
private class TestTrigger_Candidats_To_account {
    static testMethod void myUnitTest() {
       // Creamos un account de tipo  no vip y tipo Servicios centrales
       Account a1 = new Account();
        a1.FirstName = 'Servicios';
        a1.PersonEmail = 'testtest@test.com';
        a1.LastName = 'centrales';
        a1.Perfil__c = 'Autónomo';
        a1.Idioma_de_Contacto__pc = 'Catalan';
        a1.Residente__c = true;
        a1.Phone = '523423423455';
        a1.Fuente__c= 'Consejeros Confide;Bancos y Cajas';
        a1.RecordTypeId = '012b0000000QFtb';
        a1.CIF_NIF__c = '53652208A';
        a1.Tipo_Documento_Sanitario__c = 'NCS';
        a1.Nuermo_Documento_Sanitario__c = '111';
        a1.Estado_Civil__c = 'Casado/a';
        a1.Sexo__c = 'Hombre';
        a1.Tipo_Documento_Identidad__c = 'DNI';
        a1.CIF_NIF__c = '04304479Y';
        a1.Calle__c = 'Carrer de buenos aires 34';
        a1.Ciudad__c = 'Barcelona';
        a1.VIP__c = false;
        a1.PersonBirthdate = Date.today().addDays(-15);
        a1.Codigo_postal__c  = '08036';
        triggerHelper.recursiveHelper1(true);
        insert a1;
        triggerHelper.recursiveHelper1(false);

		// Creo una cuenta tipo vip y servicios centrales 
		Account a2 = new Account();
        a2.FirstName = '2';
        a2.LastName = 'cliente2 apell';
        a2.PersonEmail ='test@test.com';
        a2.Perfil__c = 'Autónomo';
        a2.Apellido_2__c = 'apell';
        a2.Residente__c = true;
        a2.Categoria_Profesional__pc = 'Enfermero';
        a2.Especialidad_Medica__pc = '';
        a2.RecordTypeId = '012b0000000QFtb';
        a2.Tipo_Documento_Sanitario__c = 'NCS';
        a2.Tipo_Documento_Identidad__c = 'DNI';
        a2.CIF_NIF__c =  '71501448Z';
        a2.Nuermo_Documento_Sanitario__c = '222';
        a2.PersonEmail = 'testtest@test.com';
        a2.Sexo__c = 'Hombre';
        a2.Phone = '5552342343245';
        a2.Calle__c = 'Gran Via 24';
        a2.Ciudad__c = 'Madrid';
        a2.Vip__c = true;
        a2.PersonBirthdate = Date.today();
        a2.Codigo_postal__c  = '28013';
        triggerHelper.recursiveHelper1(true);
        insert a2;
        triggerHelper.recursiveHelper1(false);      
        
   		 // Creamos una Lead de tipo vip 
		Lead l1 = new Lead();
		l1.FirstName = 'Servicios';
        l1.LastName = 'centrales';
        l1.Idioma_de_contacto__c = 'Catalan';
       	l1.Sexo__c = 'Hombre';
        l1.VIP__c = false;
        l1.Fuente__c= 'Web';
        l1.Division__c = 'TESTING';
        // PROVAMOS EL CASO QUE HACE SALTAR LA REGLA DE VALIDACION PARA VER SI EL TRIGGER ESTA BIEN PROGRAMADO
        l1.Categoria_Profesional__c = 'Enfermero';
        l1.Especialidad_Medica__c = 'Gastroenterólogo';
        l1.Departamento__c = 'Ventas';
        l1.Email = 'testtest@test.com';
        l1.No_tiene_telefono__c = false;
        l1.Ciudad__c = 'Barcelona';
        l1.Provincia__c = 'Barcelona';
        l1.Fax='8888888';
        l1.Codigo_Postal__c = '08110';
        l1.Calle__c = 'Julio Garcia 16B';
        l1.Country = 'España';
        l1.MobilePhone = '606975863';
        triggerHelper.recursiveHelper1(true);
        insert l1;
        triggerHelper.recursiveHelper1(false);
        
        // Creamos una Lead de tipo vip 
		Lead l2 = new Lead();
		l2.FirstName = 'VIP';
        l2.LastName = 'VIP';
        l2.Idioma_de_contacto__c = 'Catalan';
       	l2.Sexo__c = 'Hombre';
        l2.VIP__c = true;
        l2.Fuente__c= 'Web';
        l2.Division__c = 'TESTING';
        l2.Categoria_Profesional__c = 'Directivo';
        l2.Especialidad_Medica__c = 'Gastroenterólogo';
        l2.Departamento__c = 'Ventas';
        l2.Email = 'testtest@test.com';
        l2.No_tiene_telefono__c = false;
        l2.Ciudad__c = 'Barcelona';
        l2.Provincia__c = 'Barcelona';
        l2.Codigo_Postal__c = '08110';
        l2.Calle__c = 'Julio Garcia 16B';
        l2.Country = 'España';
        l2.MobilePhone = '606975863';
        triggerHelper.recursiveHelper1(true);
        insert l2;
        triggerHelper.recursiveHelper1(false);   
     }    
}