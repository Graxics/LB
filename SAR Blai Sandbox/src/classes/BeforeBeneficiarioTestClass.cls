/** 
* File Name:   BeforeBeneficiarioTestClass 
* Description: Classe test del trigger TriggerBeforeBeneficiario
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version    Date        Author           Modification 
* 01        06/05/2015  Xavier Garcia
* =============================================================== 
**/ 
@isTest
private class BeforeBeneficiarioTestClass {
    static testMethod void myUnitTest() {
        //Recordtype RtypeTareaCliente = [Select Id, Name From RecordType Where Name = 'Tarea Cliente' LIMIT 1];
        date avui = date.today();
        integer mesActual = avui.month();
        //Crear Centro
        Account centro1 = new Account();
        centro1.RecordTypeId = '012b0000000QAeAAAW'; 
        centro1.Name = 'Centro1';
        centro1.Zona_Comercial__c = 'Barcelona';
        centro1.Fecha_apertura__c = date.newinstance(2010, 1, 1);
        centro1.Capacidad_Teorica__c = 50;
        centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.NIF_director_centro__c = '43539233A';
        centro1.Division__c = 'Domiciliaria';
        centro1.Phone = '933599023';
        centro1.Comunicacion_con_familias__c = true;
        centro1.Activo__c = true;
        centro1.Categoria__c = 'Exclusive';
        centro1.ATC_Centro__c = '005b0000001Lgzf';
        centro1.Blog__c = 'http://www.sarquavitae.es/blog/residenciaclaret-barcelo/';
        triggerHelper.recursiveHelper1(true);
        insert centro1;
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
        triggerHelper.recursiveHelper1(true);
        insert residente1;
        triggerHelper.recursiveHelper1(false);
        
        //Crear Residente
        Account residente2 = new Account();
        residente2.RecordTypeId = '012b0000000QAe0AAG';
        residente2.FirstName = 'Nombre2';
        residente2.LastName = 'Apellido2';
        residente2.Residente__c = true;
        residente2.Perfil__c = 'Autónomo';
        residente2.Sexo__c = 'Hombre';
        residente2.Estado_Civil__c = 'Soltero/a';
        residente2.PersonBirthdate = date.newinstance(1940, mesActual, 2);
        residente2.Tipo_Documento_Identidad__c = 'DNI';
        residente2.CIF_NIF__c = '43539233A';
        residente2.Tipo_Documento_Sanitario__c = 'NSS';
        residente2.Nuermo_Documento_Sanitario__c = '2222';
        residente2.Idioma_de_Contacto__pc = 'Castellano';
        residente2.Phone = '660085345';
        residente2.Calle__c = 'Pablo Iglesias';
        residente2.Provincia__c = 'Barcelona';
        residente2.PersonEmail = 'xgg.1990@gmail.com';
        residente2.Pais__c = 'España';
        residente2.Ciudad__c = 'Barcelona';
        residente2.Codigo_postal__c = '08016';
        residente2.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        triggerHelper.recursiveHelper1(true);
        insert residente2;
        triggerHelper.recursiveHelper1(false);
        
        Recordtype RTOpTA = [select id,name from recordtype where name= 'Oportunidad TAM'];
        //Crear Oportunidad
        Oportunidad_platform__c op = new Oportunidad_platform__c();        
        op.Residente__c = residente1.Id;
        op.Persona_de_Contacto__c = residente1.Id;
        op.Pagador__c = residente1.Id;
        op.Etapa__c = 'Abierta';
        op.Central__c = centro1.Id;
        op.Canal__c = 'Llamada al Cat';
        op.Procedencia__c = 'Internet';
        op.Pagina_web__c = 'Google';
        op.Tipo_de_tarifa__c = 'Diaria';
        op.Tipo_de_pago__c = 'gratis';
        op.IBAN__c = 'ES9121000418450200051332';
        op.Regimen__c = 'UED';
        op.RecordTypeId = RTOpTA.id;
        op.Tipo_de_Financiacion__c = 'Privado';
        op.Fecha_prevista_de_ingreso__c = Date.today();
        op.Fecha_finalizacion__c = System.today().addDays(15);
        op.Visita_realizada_en__c = 'Centro';
        op.Tipo_de_pago__c = 'Gratis';
        triggerHelper.recursiveHelper1(true);                   
        insert op;
        triggerHelper.recursiveHelper1(false);
        /*Task TPrimerContacto = new Task();
        TPrimerContacto.Description = 'Tarea recordatorio primer contacto';
        TPrimerContacto.Status = 'Pendiente';
        TPrimerContacto.ActivityDate = avui.addDays(3);
        TPrimerContacto.Subject = 'Tarea recordatorio primer contacto';
        TPrimerContacto.OwnerId = '005b0000000kj7H';
        TPrimerContacto.Priority = 'Normal';
        TPrimerContacto.WhatId = op.Id;
        //TPrimerContacto.WhoId = ResiContact.get(oportunidad_nuevo.residente__c).id;
        TPrimerContacto.RecordTypeId = '012b0000000QBdP';
        insert TPrimerContacto;
        TPrimerContacto.Resultado__c = 'No contactado';
        update TPrimerContacto;
        TPrimerContacto.Resultado__c = 'contactado';
        update TPrimerContacto;*/
        Recordtype Rec_STA = [select id from recordtype where name = 'Servicios TA'];
        Servicio__c scTA = new Servicio__c();
        scTA.Name = 'serv2';
        scTA.RecordTypeId = Rec_STA.id;
        scTA.Tipo_de_servicio_TA__c = 'Adapta 24';
        scTA.Tipo_de_periferico__c = 'Periférico Gas';
        scTA.Activo__c = true;
        scTA.Cuota_inicial__c = false;
        triggerHelper.recursiveHelper3(true);
        insert scTA;
        triggerHelper.recursiveHelper3(false);
        
        
        //Crear Oportunidad
        Oportunidad_platform__c op2 = new Oportunidad_platform__c();        
        op2.Residente__c = residente2.Id;
        op2.Persona_de_Contacto__c = residente2.Id;
        op2.Pagador__c = residente2.Id;
        op2.Central__c = centro1.Id;
        op2.Canal__c = 'Llamada al Cat';
        op2.Procedencia__c = 'Internet';
        op2.Pagina_web__c = 'Google';
        op2.Regimen__c = 'UED';
        op2.RecordTypeId = RTOpTA.id;
        op2.Tipo_de_Financiacion__c = 'Privado';
        op2.Fecha_prevista_de_ingreso__c = Date.today();
        op2.Fecha_finalizacion__c = System.today().addDays(15);
        op2.Visita_realizada_en__c = 'Centro';
        op2.Motivio_de_Alta_GCR__c = 'aaa';
        op2.Servicio__c = scTA.id;
        op2.Tipo_de_pago__c = 'Gratis';
        op.Etapa__c = 'Abierta';
        triggerHelper.recursiveHelper1(true);  
        TriggerHelperExecuteOnce.executar1();
        insert op2;
        op2.Etapa__c = 'Negociación';
        TriggerHelperExecuteOnce.executar1();
        update op2;
        /*TPrimerContacto.Description = 'Tarea recordatorio seguimiento negociación';
        TPrimerContacto.Status = 'Pendiente';
        TPrimerContacto.ActivityDate = avui.addDays(3);
        TPrimerContacto.Subject = 'Tarea recordatorio seguimiento negociación';
        TPrimerContacto.WhatId = op2.Id;
        TPrimerContacto.Resultado__c = 'Interesado';
        update TPrimerContacto;
        /*triggerHelper.recursiveHelper1(false);
        TPrimerContacto.Resultado__c = 'Interesado';
        triggerHelper.recursiveHelper1(true);
        update TNegociacion;
        triggerHelper.recursiveHelper1(false);*/
        
        Recordtype RTRelBen= [select id,name from recordtype where name= 'Relacion de beneficiarios'];
        Relacion_entre_contactos__c rel3 = new Relacion_entre_contactos__c();
        rel3.RecordTypeId = RTRelBen.id;
        rel3.Residente__c = residente1.Id;
        rel3.Oportunidad__c = op.Id;
        rel3.Usuario_principal__c = true;
        rel3.Activo__c = true;
        triggerHelper.recursiveHelper1(true);
         
        insert rel3;
        triggerHelper.recursiveHelper1(false);
        
        Relacion_entre_contactos__c rel2 = new Relacion_entre_contactos__c();
        rel2.RecordTypeId = RTRelBen.id;
        rel2.Residente__c = residente1.Id;
        rel2.Oportunidad__c = op.Id;
        rel2.Usuario_principal__c = false;
        rel2.Activo__c = false;
        rel2.Beneficiario_con_colgante__c = true;
        triggerHelper.recursiveHelper1(true);
        insert rel2;
        triggerHelper.recursiveHelper1(false);
        rel2.Beneficiario_con_colgante__c = false;
        rel2.Beneficiario_sin_colgante__c = true;
        update rel2;
        TriggerHelperExecuteOnce.executar1();
        op.Etapa__c = 'Cerrada por el sistema';
       triggerHelper.recursiveHelper1(true);                   
        update op;
        triggerHelper.recursiveHelper1(false);
        
        
    }
}