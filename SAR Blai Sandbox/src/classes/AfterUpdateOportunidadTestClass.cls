/** 
* File Name:   AfterUpdateOportunidadTestClass 
* Description: Classe test del trigger AfterUpdateOportunidad
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		09/02/2015  Xavier Garcia
* =============================================================== 
**/ 
@isTest
private class AfterUpdateOportunidadTestClass {
    static testMethod void myUnitTest() {
        date avui = date.today();
        integer mesActual = avui.month();
        Document d = new Document();
		d.DeveloperName = 'Mapeig_Ambito_Servicio1';
        d.Name = 'Mapeig_Ambito_Servicio';
		d.Body = Blob.valueof('Residencial:Centro de Noche, Convalecencia,Fijo Discontinuo,Hospital de Día,Paliativo,Residencial,Respiro,UDC,UPG,USM,UTC,Apartamento,Sociosanitario Privado;Centro de Día:Centro de Día;');	
		d.FolderId = UserInfo.getUserId();
        insert d;
        //Crear Entidad Recomendadora
        Account centrorec = new Account();
        centrorec.Name = 'Centro3';
        centrorec.RecordTypeId = '012b0000000QAd7AAG';
        centrorec.Zona_Comercial__c = 'Barcelona';
        centrorec.Phone = '444123123222224';
        centrorec.Activo__c = true;
        centrorec.Zona_Comercial__c = 'Barcelona';
        centrorec.Division__c = 'Residencial';
        centrorec.Categoria__c = 'Exclusive';
        centrorec.Institucion_facturable__c = true;
        centrorec.Residencial__c = true;
        centrorec.Clasificacion_tipo_recomendador__c = 'A';
        centrorec.Fecha_apertura__c = System.today().addDays(-15);
        centrorec.Capacidad_Teorica__c = 100;
        centrorec.Provincia__c = 'Barcelona';
        triggerHelper.recursiveHelper1(true);        
        insert centrorec;
        triggerHelper.recursiveHelper1(false);
        
        
        //Crear Centro
        Account centro1 = new Account();
        centro1.RecordTypeId = '012b0000000QAeAAAW'; 
        centro1.Name = 'Centro1';
        centro1.Zona_Comercial__c = 'Barcelona';
        centro1.Fecha_apertura__c = date.newinstance(2010, 1, 1);
        centro1.Capacidad_Teorica__c = 50;
        centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.NIF_director_centro__c = '43539233A';
        centro1.Division__c = 'Residencial';
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
        residente1.PersonEmail = 'residente1@gmail.com';
        residente1.Pais__c = 'España';
        residente1.Ciudad__c = 'Barcelona';
        residente1.Codigo_postal__c = '08016';
        residente1.IdNAV_RES__c = 'TRES55560';
        residente1.Historia_de_vida_adjunta__c = false;
        residente1.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        triggerHelper.recursiveHelper1(true);
        insert residente1;
        triggerHelper.recursiveHelper1(false);
                
        //Crear Familiar
        Account familiar1 = new Account();
        familiar1.RecordTypeId = '012b0000000QAe0AAG';
        familiar1.FirstName = 'Familiar1';
        familiar1.LastName = 'Familiar1';
        familiar1.Residente__c = false;
        familiar1.Perfil__c = 'Autónomo';
        familiar1.Sexo__c = 'Hombre';
        familiar1.Estado_Civil__c = 'Soltero/a';
        familiar1.PersonBirthdate = date.newinstance(1950, mesActual, 2);
        familiar1.Tipo_Documento_Identidad__c = 'DNI';
        familiar1.CIF_NIF__c = '71501448Z';
        familiar1.PersonEmail = 'familiar1@gmail.com';
        familiar1.Tipo_Documento_Sanitario__c = 'NSS';
        familiar1.Nuermo_Documento_Sanitario__c = '11111';
        familiar1.Idioma_de_Contacto__pc = 'Castellano';
        familiar1.Phone = '660085345';
        familiar1.Calle__c = 'Pablo Iglesias';
        familiar1.Provincia__c = 'Barcelona';
        familiar1.Pais__c = 'España';
        familiar1.Ciudad__c = 'Barcelona';
        familiar1.Codigo_postal__c = '08016';
        familiar1.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        triggerHelper.recursiveHelper1(true);
        insert familiar1;
        triggerHelper.recursiveHelper1(false);
        
        //Crear Relacion entre contactos
        Relacion_entre_contactos__c rel1 = new Relacion_entre_contactos__c();
        rel1.RecordTypeId = '012b0000000QCby';
        rel1.Residente__c = residente1.Id;
        rel1.Contacto__c = familiar1.Id;
        rel1.Relacion_personal__c = 'Hijo/a';
        triggerHelper.recursiveHelper1(true);
        insert rel1;
        triggerHelper.recursiveHelper1(false);
        
        //Crear Familiar
        Account familiar2 = new Account();
        familiar2.RecordTypeId = '012b0000000QAe0AAG';
        familiar2.FirstName = 'Familiar2';
        familiar2.LastName = 'Familiar2';
        familiar2.Residente__c = false;
        familiar2.Perfil__c = 'Autónomo';
        familiar2.Sexo__c = 'Hombre';
        familiar2.Estado_Civil__c = 'Soltero/a';
        familiar2.PersonBirthdate = date.newinstance(1950, mesActual, 2);
        familiar2.Tipo_Documento_Identidad__c = 'DNI';
        familiar2.CIF_NIF__c = '43539233A';
        familiar2.PersonEmail = 'familiar2@gmail.com';
        familiar2.Tipo_Documento_Sanitario__c = 'NSS';
        familiar2.Nuermo_Documento_Sanitario__c = '11111';
        familiar2.Idioma_de_Contacto__pc = 'Catalán';
        familiar2.Phone = '660085345';
        familiar2.Calle__c = 'Pablo Iglesias';
        familiar2.Provincia__c = 'Barcelona';
        familiar2.Pais__c = 'España';
        familiar2.Ciudad__c = 'Barcelona';
        familiar2.Codigo_postal__c = '08016';
        familiar2.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        triggerHelper.recursiveHelper1(true);
        insert familiar2;
        triggerHelper.recursiveHelper1(false);
        
        //Crear Relacion entre contactos
        Relacion_entre_contactos__c rel2 = new Relacion_entre_contactos__c();
        rel2.RecordTypeId = '012b0000000QCby';
        rel2.Residente__c = residente1.Id;
        rel2.Contacto__c = familiar2.Id;
        rel2.Relacion_personal__c = 'Hijo/a';
        rel2.Familiar_de_referencia__c = true;
        triggerHelper.recursiveHelper1(true);
        insert rel2;
        triggerHelper.recursiveHelper1(false);
        
         //Crear Familiar
        Account familiar3 = new Account();
        familiar3.RecordTypeId = '012b0000000QAe0AAG';
        familiar3.FirstName = 'Familiar2';
        familiar3.LastName = 'Familiar2';
        familiar3.Residente__c = false;
        familiar3.Perfil__c = 'Autónomo';
        familiar3.Sexo__c = 'Hombre';
        familiar3.Estado_Civil__c = 'Soltero/a';
        familiar3.PersonBirthdate = date.newinstance(1950, mesActual, 2);
        familiar3.Tipo_Documento_Identidad__c = 'DNI';
        familiar3.CIF_NIF__c = '90520562Z';
        familiar3.PersonEmail = 'familiar3@gmail.com';
        familiar3.Tipo_Documento_Sanitario__c = 'NSS';
        familiar3.Nuermo_Documento_Sanitario__c = '11111';
        familiar3.Idioma_de_Contacto__pc = 'Euskera';
        familiar3.Phone = '660085345';
        familiar3.Calle__c = 'Pablo Iglesias';
        familiar3.Provincia__c = 'Barcelona';
        familiar3.Pais__c = 'España';
        familiar3.Ciudad__c = 'Barcelona';
        familiar3.Codigo_postal__c = '08016';
        familiar3.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        triggerHelper.recursiveHelper1(true);
        insert familiar3;
        triggerHelper.recursiveHelper1(false);
        
        //Crear Relacion entre contactos
        Relacion_entre_contactos__c rel3 = new Relacion_entre_contactos__c();
        rel3.RecordTypeId = '012b0000000QCby';
        rel3.Residente__c = residente1.Id;
        rel3.Contacto__c = familiar3.Id;
        rel3.Relacion_personal__c = 'Hijo/a';
        rel3.Familiar_de_referencia__c = true;
        triggerHelper.recursiveHelper1(true);
        insert rel3;
        triggerHelper.recursiveHelper1(false);
        
        //Creamos un servicio
        Servicio__c sc = new Servicio__c();
        sc.Name = 'serv';
        sc.Tipo_Servicio__c = 'Residencial';
        sc.Tipo_Estancia__c = 'Temporal';
        sc.Tipo_Ocupacion__c = 'HD';
        sc.Grado_Dependencia__c = 'Grado1';
        triggerHelper.recursiveHelper1(true);
        insert sc;
        triggerHelper.recursiveHelper1(false); 
        
        
        //Crear Oportunidad
        Oportunidad_platform__c op = new Oportunidad_platform__c();        
        op.Residente__c = residente1.Id;
        op.Persona_de_Contacto__c = residente1.Id;
        op.Pagador__c = residente1.Id;
        op.Etapa__c = 'Preingreso';
        op.Centro2__c = centro1.Id;
        op.Canal__c = 'Llamada al Cat';
        op.Procedencia__c = 'Vecindad';
        op.Tipo_de_tarifa__c = 'Diaria';
        op.Tipo_de_pago__c = 'gratis';
        op.IBAN__c = 'ES9121000418450200051332';
        op.Regimen__c = 'UED';
        op.RecordTypeId = '012b0000000QBG1';
        op.Tipo_de_Financiacion__c = 'Privado';
        op.Fecha_prevista_de_ingreso__c = Date.today();
        op.Fecha_finalizacion__c = System.today().addDays(15);
        op.Servicio__c = sc.Id;
        op.Visita_realizada_en__c = 'Centro';
        op.Motivio_de_Alta_GCR__c = 'aaa';
        op.Tipo_de_pago__c = 'Gratis';
        op.Visita_realizada_en__c = 'Centro';
        op.Institucion__c = centrorec.Id;  
        triggerHelper.recursiveHelper1(true);
        insert op;
        triggerHelper.recursiveHelper1(false);
        op.Etapa__c = 'Ingreso';
        op.Motivio_de_Alta_GCR__c = null;
        op.Fecha_de_Alta__c = null; 
        triggerHelper.recursiveHelper1(true);
        update op;
        triggerHelper.recursiveHelper1(false);
        EnviarEmailCentre.EnviarEmail(centro1.id,'Director');
        BatchableEmailOcio clsBatchItUpSon = new BatchableEmailOcio();
        ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);
        BatchableEmailMenus clsBatchItUpSon2 = new BatchableEmailMenus();
        ID idBatch2 = Database.executeBatch(clsBatchItUpSon2, 200);
        BatchableTareaOcioyCumple clsBatchItUpSon3 = new BatchableTareaOcioyCumple();
        ID idBatch3 = Database.executeBatch(clsBatchItUpSon3, 200);
        BatchableTareaMenus clsBatchItUpSon4 = new BatchableTareaMenus();
        ID idBatch4 = Database.executeBatch(clsBatchItUpSon4, 200);
 
    }
    
}