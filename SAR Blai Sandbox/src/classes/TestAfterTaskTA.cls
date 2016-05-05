/** 
* File Name:   TestAfterTaskTA 
* Description: Crea tareas en funcion de la etapa de la oportunidad TA 
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 08/05/2015
* =============================================================== 
**/ 
@isTest
private class TestAfterTaskTA {

    static testMethod void myUnitTest() {
        Recordtype RtypeTareaCliente = [Select Id, Name From RecordType Where Name = 'Tarea Cliente' LIMIT 1];
        date avui = date.today();
        integer mesActual = avui.month();
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
        triggerHelper.recursiveHelper3(true);
        insert residente1;
        triggerHelper.recursiveHelper3(false);
        
        
        
        //Crear Centro
        Account centro1 = new Account();
        centro1.RecordTypeId = '012b0000000QAeAAAW'; 
        centro1.Name = 'Central1';
        centro1.Zona_Comercial__c = 'Barcelona';
        centro1.Fecha_apertura__c = date.newinstance(2010, 1, 1);
        centro1.Capacidad_Teorica__c = 50;
        centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.NIF_director_centro__c = '43539233A';
        centro1.Division__c = 'Domiciliaria';
        centro1.Phone = '933599023';
        centro1.Activo__c = true;
        centro1.Categoria__c = 'Exclusive';
        centro1.ATC_Centro__c = '005b0000001Lgzf';
        triggerHelper.recursiveHelper3(true);
        insert centro1;
        triggerHelper.recursiveHelper3(false);
        
        NOC__c noc10 = new NOC__c();
        noc10.RecordTypeId = '012b0000000QBcl';
        noc10.Name = 'noc10';
        noc10.division__c = 'Teleasistencia';
        noc10.Ano_Tarifa__c = '2015';
        noc10.Estado_Flujo__c = 'Aprobado';
        noc10.Fecha_inicio__c = Date.today().addDays(-30);
        noc10.Fecha_fin__c = Date.today().addDays(5);
        noc10.Descuento_permanente__c = false;
        triggerHelper.recursiveHelper3(true);           
        insert noc10;
        triggerHelper.recursiveHelper3(false);
        
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
        Recordtype RTTarTa = [select id,name from recordtype where name= 'Tarifas TAM'];
        Tarifa__c tTA = new Tarifa__c();
        tTa.RecordTypeId = RTTarTa.id;
        tTa.NOC__c = noc10.id;
        tTa.Servicio_TA__c = scTA.id;
        tTa.Central__c = centro1.id;
        tTa.Precio_servicio__c = 50;
        tTA.Tarifa_Vigente__c = true;
        triggerHelper.recursiveHelper3(true);
        insert tTA;
        triggerHelper.recursiveHelper3(false);
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
        op.Precio_Colgantes__c = 10;
        op.Precio_sin_colgante__c = 5;
        op.ownerid = '005b0000000kj7H';
        op.Servicio__c = scTA.id;
        triggerHelper.recursiveHelper3(true);                  
        insert op;
        triggerHelper.recursiveHelper3(true);
        
        
        
       Task TPrimerContacto = new Task();
        TPrimerContacto.Description = 'Tarea recordatorio primer contacto';
        TPrimerContacto.Status = 'Pendiente';
        TPrimerContacto.ActivityDate = avui.addDays(3);
        TPrimerContacto.Subject = 'Tarea recordatorio primer contacto';
        TPrimerContacto.OwnerId = op.ownerid;
        TPrimerContacto.Priority = 'Normal';
        TPrimerContacto.WhatId = op.Id;
        //TPrimerContacto.WhoId = ResiContact.get(oportunidad_nuevo.residente__c).id;
        TPrimerContacto.RecordTypeId = RtypeTareaCliente.id;
        insert TPrimerContacto;
    	TPrimerContacto.resultado__c = 'No contactado';
        update TPrimerContacto;
        TPrimerContacto.resultado__c = 'Contactado';
        update TPrimerContacto;
        
        
        Task TNegociacion = new Task();
        TNegociacion.Description = 'Tarea recordatorio seguimiento negociación';
        TNegociacion.Status = 'Pendiente';
        TNegociacion.ActivityDate = avui.addDays(7);
        TNegociacion.Subject = 'Tarea recordatorio seguimiento negociación';
        TNegociacion.OwnerId = op.ownerid;
        TNegociacion.Priority = 'Normal';
        TNegociacion.WhatId = op.Id;
        //TNegociacion.WhoId = ResiContact.get(oportunidad_nuevo.residente__c).id;
        TNegociacion.RecordTypeId = RtypeTareaCliente.id;
        insert TNegociacion;
        TNegociacion.resultado__c = 'Interesado';
        update TNegociacion;
        TNegociacion.resultado__c = 'No Interesado';
        tNegociacion.Motivo_no_interesado__c = 'No contesta';
        update TNegociacion;
        
        op.Tarifa__c = tTA.id;
        
        op.Etapa__c = 'Negociación';
        triggerHelper.recursiveHelper3(true);  
        //update op;
        triggerHelper.recursiveHelper3(false);  
    }

}