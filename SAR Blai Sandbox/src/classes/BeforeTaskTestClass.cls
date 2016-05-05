/** 
* File Name:   BeforeTaskTestClass 
* Description: Classe test del trigger BeforeTask
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		11/02/2014  Xavier Garcia
* =============================================================== 
**/ 
@isTest
private class BeforeTaskTestClass {
	static testMethod void myUnitTest() {
        date avui = date.today();
        integer mesActual = avui.month();
        
       /* Account a = new Account();
        a.RecordTypeId = '012b0000000QAe0';
        a.FirstName = 'Cliente';
        a.LastName = 'Comodín';
        a.PersonEmail = 'test@test.test';
        a.Phone = '939999999';
        a.Baja__c = true;
        triggerHelper.recursiveHelper1(true);
        insert a;
        triggerHelper.recursiveHelper1(true);*/
        
        
         //Crear Entidad Recomendadora
        Account centrorec = new Account();
        centrorec.Name = 'Recomenadora1';
        centrorec.RecordTypeId = '012b0000000QAd7AAG';
        centrorec.Zona_Comercial__c = 'Barcelona';
        centrorec.Phone = '444123123222224';
        centrorec.Activo__c = true;
        centrorec.Zona_Comercial__c = 'Barcelona';
        centrorec.Division__c = 'Residencial';
        centrorec.Categoria__c = 'Exclusive';
        centrorec.Institucion_facturable__c = true;
        centrorec.Fecha_apertura__c = System.today().addDays(-15);
        centrorec.Capacidad_Teorica__c = 100;
        centrorec.Baja__c = true;
        centrorec.Residencial__c = true;
        centrorec.Clasificacion_tipo_recomendador__c = 'A';
        centrorec.Provincia__c = 'Barcelona';
        triggerHelper.recursiveHelper1(true);        
        insert centrorec;
        triggerHelper.recursiveHelper1(false);
        
        //Crear Cuenta Recomendador
        Account contacto = new Account();
       	contacto.FirstName = 'Contacto1';
        contacto.LastName = 'Contacto1';
        contacto.RecordTypeId = '012b0000000QCbt';
        contacto.Idioma_de_Contacto__pc = 'Castellano';
        contacto.Clasificacion_tipo_recomendador__c = 'A';
        contacto.Residencial__c = true;
        contacto.Baja__c = true;
        contacto.Phone = '660085378';
        triggerHelper.recursiveHelper1(true);        
        insert contacto;
        triggerHelper.recursiveHelper1(false);
        
        //Crear contacto
        /*Contact cont = new Contact();
        cont.AccountId = contacto.Id;
        triggerHelper.recursiveHelper1(true);        
       	insert cont;
        triggerHelper.recursiveHelper1(false);*/
        
        
        /*Recordtype RtypeTareaCatOtros = [Select Id, Name From RecordType Where DeveloperName = 'Tarea_CAT_Otros' LIMIT 1];
        Task tascaOtros = new Task();
        tascaOtros.RecordTypeId = RtypeTareaCatOtros.id;
        // tasca.WhoId = contacto.Id;
        tascaOtros.WhatId = null;
        tascaOtros.OwnerId = '005b0000000kj7H';
        tascaOtros.Subject = 'Llamada';
        tascaOtros.ActivityDate = avui.addDays(5);
        tascaOtros.Status = 'Completada';
        tascaOtros.Priority = 'Normal';       
        insert tascaOtros;*/
        
		Recordtype RtypeTareaRecomendador = [Select Id, Name From RecordType Where Name = 'Tarea Recomendador' LIMIT 1];
        
        try {
            Task tasca = new Task();
            tasca.RecordTypeId = RtypeTareaRecomendador.id;
           // tasca.WhoId = contacto.Id;
            tasca.WhatId = centrorec.Id;
            tasca.OwnerId = '005b0000000kj7H';
            tasca.Subject = 'Llamada';
            tasca.ActivityDate = avui.addDays(5);
            tasca.Status = 'Pendiente';
            tasca.Priority = 'Normal';       
            insert tasca;
            throw new MyException ('El trigger debería lanzar una excepción');
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Ni el contacto recomendador ni la empresa recomendadora pueden tener seleccionado el campo baja.') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
        }  
    }
}