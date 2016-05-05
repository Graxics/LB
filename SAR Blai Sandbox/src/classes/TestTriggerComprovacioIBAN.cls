/** 
* File Name:   TestTriggerComprovacioIBAN  
* Description: Test del trigger TriggerComprovacioIBAN
* Copyright:   Konozca 
* @author:     Hector Mañosas
* Modification Log 
* =============================================================== 
*Date          Author           Modification 
* 13/08/2014   hManosas
* =============================================================== 
**/


@isTest

private class TestTriggerComprovacioIBAN {

    static testMethod void myUnitTest() {
        
         //Creamos una Account de tipo Cliente   
        Account a1 = new Account();
        a1.FirstName = '1';
        a1.PersonEmail = 'person@test.com';
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
        a1.CIF_NIF__c = '04304479Y';
        a1.Calle__c = 'Carrer de buenos aires 34';
        a1.Ciudad__c = 'Barcelona';
        a1.PersonBirthdate = Date.today().addDays(-15);
        a1.Codigo_postal__c  = '08036';
        triggerHelper.recursiveHelper1(true);
        insert a1;
        triggerHelper.recursiveHelper1(false);
        
        //Creamos una segunda Account Cliente
        Account a2 = new Account();
        a2.FirstName = '2';
        a2.LastName = 'cliente2 apell';
        a2.Perfil__c = 'Autónomo';
        a2.PersonEmail = 'person@test.com';
        a2.Apellido_2__c = 'apell';
        a2.Idioma_de_Contacto__pc = 'Catalan';
        a2.Residente__c = true;
        a2.RecordTypeId = '012b0000000QAe0AAG';
        a2.Tipo_Documento_Sanitario__c = 'NCS';
        a2.Tipo_Documento_Identidad__c = 'DNI';
        a2.CIF_NIF__c =  '71501448Z';
        a2.Nuermo_Documento_Sanitario__c = '222';
        a2.Estado_Civil__c = 'Casado/a';
        a2.Sexo__c = 'Hombre';
        a2.Phone = '5552342343245';
        a2.Calle__c = 'Gran Via 24';
        a2.Ciudad__c = 'Madrid';
        a2.PersonBirthdate = Date.today();
        a2.Codigo_postal__c  = '28013';
        triggerHelper.recursiveHelper1(true);
        insert a2;
        triggerHelper.recursiveHelper1(false);
        
        //Creamos una nueva Account de Tipo Empresa Recomendador         
        Account centrorec = new Account();
        centrorec.Name = 'Centro3';
        centrorec.RecordTypeId = '012b0000000QAd7AAG';
        centrorec.Zona_Comercial__c = 'Barcelona';
        centrorec.Phone = '444123123222224';
        centrorec.Activo__c = true;
        centrorec.Zona_Comercial__c = 'Barcelona';
        centrorec.IdNAV__c = 'CANBUXERES3';
        centrorec.Division__c = 'Residencial';
        centrorec.Categoria__c = 'Exclusive';
        centrorec.Fecha_apertura__c = System.today().addDays(-15);
        centrorec.Capacidad_Teorica__c = 100;
        centrorec.Residencial__c = true;
        centrorec.Clasificacion_tipo_recomendador__c = 'A';
        centrorec.Provincia__c = 'Barcelona';
        triggerHelper.recursiveHelper1(true);        
        insert centrorec;
        triggerHelper.recursiveHelper1(false);
        
        //Creamos una Account de tipo Centro
        Account centro1 = new Account();
        centro1.Name = 'Can Buxeres';
        centro1.RecordTypeId = '012b0000000QAeAAAW';        
        centro1.Phone = '442342343244';
        centro1.Activo__c = true;
        centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.Division__c = 'Residencial';
        centro1.Zona_Comercial_del__c = 'Barcelona';
        centro1.IdNAV__c = 'CANBUXERES';
        triggerHelper.recursiveHelper1(true);
        insert centro1;
        triggerHelper.recursiveHelper1(false);
        
        //Creamos un servicio
        Servicio__c sc = new Servicio__c();
        sc.Name = 'serv';
        sc.Tipo_Servicio__c = 'Residencial';
        sc.Tipo_Estancia__c = 'Temporal';
        sc.Tipo_Ocupacion__c = 'HD';
        sc.Grado_Dependencia__c = 'Grado1';
        insert sc;        
                
        //Creamos una Oportunidad
        Oportunidad_platform__c op = new Oportunidad_platform__c();        
        op.Residente__c = a1.Id;
        op.Persona_de_Contacto__c = a2.Id;
        op.Pagador__c = a2.Id;
        op.Empresa_Recomendadora__c = centrorec.Id;
        op.Etapa__c = 'Pendiente Visita';
        op.Centro2__c = centro1.Id;
        op.Canal__c = 'Llamada al Cat';
        op.Procedencia__c = 'Prescriptor';
        op.Tipo_de_tarifa__c = 'Diaria';
        op.Tipo_de_pago__c = 'gratis';
        op.IBAN__c = 'ES9121000418450200051332';
        op.Regimen__c = 'UED';
        op.RecordTypeId = '012b0000000QBG6AAO';
        op.Tipo_de_Financiacion__c = 'Privado';
        op.Fecha_prevista_de_ingreso__c = Date.today();
        op.Fecha_finalizacion__c = System.today().addDays(15);
        op.Servicio__c = sc.Id;
        op.Visita_realizada_en__c = 'Centro';
        op.Motivio_de_Alta_GCR__c = 'aaa';
        triggerHelper.recursiveHelper1(true);                   
        insert op;
        triggerHelper.recursiveHelper1(false); 
    }
}