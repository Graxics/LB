/** 
* File Name:   TestBatchAsignarVista 
* Description: Test para el BatchAsignarVisita 
* Copyright:   Konozca 
* @author:     Jose M Perez
* Modification Log 
* Fecha: 10/02/2016 
* =============================================================== 
**/

@isTest
private class TestBatchAsignarVista {
    static testMethod void myUnitTest() {
        Date avui = date.today();
        Integer mesActual = avui.month();
        //Crear Residente
        Account residente1 = new Account();
        residente1.RecordTypeId = getRecordTypeId('Contacto Recomendador');
        residente1.Clasificacion_tipo_recomendador__c = 'A';
        residente1.Residencial__c = true;
        residente1.FirstName = 'Nombre1';
        residente1.LastName = 'Apellido1';
        residente1.Residente__c = true;
        residente1.Perfil__c = 'Autónomo';
        residente1.Sexo__c = 'Hombre';
        residente1.Estado_Civil__c = 'Soltero/a';
        residente1.PersonBirthdate = date.newinstance(1940, mesActual, 2);
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
        insert residente1;
              
        Account ac1 = new Account();
        ac1.RecordTypeId = getRecordTypeId('Contacto Recomendador');
        ac1.Clasificacion_tipo_recomendador__c = 'B';
        ac1.Residencial__c = true;
        ac1.FirstName = 'Nombre2';
        ac1.LastName = 'Apellido2';
        ac1.Residente__c = true;
        ac1.Perfil__c = 'Autónomo';
        ac1.Sexo__c = 'Hombre';
        ac1.Estado_Civil__c = 'Soltero/a';
        ac1.PersonBirthdate = date.newinstance(1950, mesActual, 2);
        ac1.Tipo_Documento_Identidad__c = 'DNI';
        ac1.CIF_NIF__c = '55441122J';
        ac1.Tipo_Documento_Sanitario__c = 'NSS';
        ac1.Nuermo_Documento_Sanitario__c = '11111';
        ac1.Idioma_de_Contacto__pc = 'Castellano';
        ac1.Phone = '660085345';
        ac1.Calle__c = 'Pablo Iglesias';
        ac1.Provincia__c = 'Barcelona';
        ac1.PersonEmail = 'xgg2.1990@gmail.com';
        ac1.Pais__c = 'España';
        ac1.Ciudad__c = 'Barcelona';
        ac1.Codigo_postal__c = '08016';
        ac1.IdNAV_RES__c = 'TRES55560';
        ac1.Historia_de_vida_adjunta__c = false;
        ac1.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        insert ac1;        
        
		Event e1 = new Event(
            	Subject = 'Visita',
                EventSubtype = 'Event',
            	ActivityDate = Date.newInstance(Date.today().year(), 4, 30),
                ActivityDateTime = Datetime.newInstance(Date.today().year(), 4, 30, 10, 0, 0),
                DurationInMinutes = 60,
                RecordTypeId = getRecordTypeId('Evento a Recomendador'),
				Resultado__c = 'Acción Abierta',
                //OwnerId = ac1.OwnerId,
                WhatId = ac1.Id
                //WhoId = idAccToIdCont.get(ac1.Id)
            );        
        insert e1;
        
        BatchAsignarVisita clsBatchItUpSon = new BatchAsignarVisita();
		ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);
		/*
        Res_Aux__c resAux1 = new Res_Aux__c(Id = '001b000003Hb7iBAAR');
        Res_Aux__c resAux2 = new Res_Aux__c(Id = '001b000000jUJbAAAW');
        insert resAux1;
        insert resAux2;
        BatchAux clsBatchItUpSon2 = new BatchAux();
		ID idBatch2 = Database.executeBatch(clsBatchItUpSon2, 200);        
        */
        
    }
    
    private static Id getRecordTypeId(String str){
        List <RecordType>  rt = [ SELECT Id FROM RecordType WHERE Name = :str ];
        return (rt.size() > 0) ? rt.get(0).Id : null;
    }
}