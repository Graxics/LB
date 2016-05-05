/** 
* File Name:   TestEnviarCorreuTask 
* Description: Test 
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 18/06/2015
* =============================================================== 
**/ 
@isTest

private class TestEnviarCorreuTask {
    static testMethod void myUnitTest() {
        Account residente1 = new Account();
        residente1.RecordTypeId = '012b0000000QAe0AAG';
        residente1.FirstName = 'Nombre1';
        residente1.LastName = 'Apellido1';
        residente1.Residente__c = true;
        residente1.Perfil__c = 'Autónomo';
        residente1.Sexo__c = 'Hombre';
        residente1.Estado_Civil__c = 'Soltero/a';
        residente1.PersonBirthdate = date.newinstance(1940, Date.today().month(), 2);
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
        triggerHelper.recursiveHelper3(true);
        insert residente1;
        triggerHelper.recursiveHelper3(false);
        
        
        Task t1 = new Task();
        t1.WhatId = residente1.id;
        t1.ADOREA_Benalmadena__c = true;
        t1.Subject = 'Información Otros Servicios';
        t1.RecordTypeId = '012b0000000QBdA';
        t1.Canal__c = 'Chat';
        t1.Procedencia__c = 'Vecinidad';
        t1.Recurso__c = 'OTROS';
        t1.Status = 'Completada';
        t1.Priority ='Media';
        t1.Entidad_Recomendadora__c = 'prova';
        t1.Contacto_Recomendador__c= 'prova';
        t1.Recurso__c = 'OTROS';
        t1.Description= 'prova';
        insert t1;
        
        Task t2 = new Task();
        t2.WhatId = residente1.id;
        t2.SAD_Barcelona__c = true;
        t2.Subject = 'Información Otros Servicios';
        t2.RecordTypeId = '012b0000000QBdA';
        t2.Canal__c = 'Chat';
        t2.Recurso__c = 'OTROS';
        t2.Status = 'Completada';
        t2.Priority ='Media';
        t2.Centro_de_procedencia__c = 'prova';
        insert t2;
        
        Task t3 = new Task();
        t3.WhatId = residente1.id;
        t3.SAD_resto_de_Espana__c = true;
        t3.Subject = 'Información Otros Servicios';
        t3.RecordTypeId = '012b0000000QBdA';
        t3.Canal__c = 'Chat';
        t3.Procedencia__c = 'Vecinidad';
        t3.Recurso__c = 'OTROS';
        t3.Status = 'Completada';
        t3.Priority ='Media';
        t3.Empleado_recomendador__c = 'prova';
        insert t3;
        
        Task t4 = new Task();
        t4.WhatId = residente1.id;
        t4.SARDOMUS__c = true;
        t4.Subject = 'Información Otros Servicios';
        t4.RecordTypeId = '012b0000000QBdA';
        t4.Canal__c = 'Chat';
        t4.Procedencia__c = 'Vecinidad';
        t4.Recurso__c = 'OTROS';
        t4.Status = 'Completada';
        t4.Priority ='Media';
        t4.Cliente_Recomendador__c = 'prova';
        insert t4;
        
        Task t5 = new Task();
        t5.WhatId = residente1.id;
        t5.ADOREA_Girona__c = true;
        t5.Subject = 'Información Otros Servicios';
        t5.RecordTypeId = '012b0000000QBdA';
        t5.Canal__c = 'Chat';
        t5.Procedencia__c = 'Vecinidad';
        t5.Recurso__c = 'OTROS';
        t5.Status = 'Completada';
        t5.Priority ='Media';
        insert t5;
        
        Task t6 = new Task();
        t6.WhatId = residente1.id;
        t6.ADOREA_Sevilla__c = true;
        t6.Subject = 'Información Otros Servicios';
        t6.RecordTypeId = '012b0000000QBdA';
        t6.Canal__c = 'Chat';
        t6.Procedencia__c = 'Vecinidad';
        t6.Recurso__c = 'OTROS';
        t6.Status = 'Completada';
        t6.Priority ='Media';
        insert t6;
        
        
    }
}