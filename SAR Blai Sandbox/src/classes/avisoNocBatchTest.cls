@isTest
public class avisoNocBatchTest {

    static testMethod void testBatch() {
    	
    	User u = [SELECT Id, Name FROM User WHERE Name = 'Admin Konozca'];
    	   	
    	Document d = new Document();
    	d.Name = 'Tabla Eventos Visitas';
    	d.FolderId = u.Id;
    	insert d;
        
        Servicio__c sc = new Servicio__c();
        sc.Name = 'serv';
        sc.Tipo_Servicio__c = 'Residencial';
        sc.Tipo_Estancia__c = 'Temporal';
        sc.Tipo_Ocupacion__c = 'HD';
        sc.Grado_Dependencia__c = 'Grado 1';
        insert sc;
        
        Account a1 = new Account();
        a1.FirstName = '1';
        a1.PersonEmail = 'test@test.com';
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
        a1.PersonBirthdate = Date.today();
        a1.Codigo_postal__c  = '08036';
        insert a1;
        
        Account a2 = new Account();
        a2.FirstName = '2';
        a2.personEmail = 'test@test.com';
        a2.LastName = 'cliente2 apell';
        a2.Perfil__c = 'Autónomo';
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
        insert a2;
        
        Account centro1 = new Account();
        centro1.Name = 'Centro1';
        //centro1.PersonEmail = 'test@test.com';
        centro1.RecordTypeId = '012b0000000QAeAAAW';
        centro1.Zona_comercial__c = 'Centro';
        centro1.Phone = '442342343244';
        centro1.Activo__c = true;
        centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.ATC_Zona__c = '005b0000001JOei';
        centro1.Division__c = 'Residencial';
        insert centro1;
        
        Account rec = new Account();
        rec.RecordTypeId = '012b0000000QCbtAAG';
        rec.FirstName = 'rc1';
        rec.LastName = 'rec1';
        rec.PersonEmail = 'test@test.com';
        rec.Phone = '412321233144';
        rec.Activo__c = true;
        rec.Clasificacion_tipo_recomendador__c = 'A';
        rec.Residencial__c = true;
        insert rec;
        
        Account centrorec = new Account();
        centrorec.Name = 'Centro1';
        //centrorec.PersonEmail = 'test@test.com';
        centrorec.RecordTypeId = '012b0000000QAd7AAG';
        centrorec.Zona_Comercial_del__c = 'Centro';
        centrorec.Phone = '444123123222224';
        centrorec.Activo__c = true;
        centrorec.Zona_Comercial__c = 'Barcelona';
        centrorec.Residencial__c = true;
        centrorec.Provincia__c = 'Barcelona';
        centrorec.Clasificacion_tipo_recomendador__c = 'A';
        insert centrorec;
        
        NOC__c noc10 = new NOC__c();
        noc10.RecordTypeId = '012b0000000QBclAAG';
        noc10.Name = 'Noc10';
        noc10.Division__c = 'Residencial';
        noc10.Ano_Tarifa__c = '2014';
        noc10.Fecha_fin__c = System.today().addDays(15);
        noc10.Fecha_inicio__c = System.today().addDays(-30);
        noc10.Estado_Flujo__c = 'Aprobado';
        noc10.Id_contrato__c = 'CTR00000';
        insert noc10;
        
        Tarifa__c t = new Tarifa__c();
        t.Name = 'TarifaTest';
        t.Servicio__c = sc.Id;
        t.Centro__c = centro1.Id;
        t.NOC__c = noc10.Id;
        t.Tipo_Contrato__c = 'Privado';
        t.Tipo_Tarifa__c = 'Diaria';
        t.Precio__c = 100;
        t.Tarifa_Vigente__c = true;
        insert t;
        
        Oportunidad_platform__c op = new Oportunidad_platform__c();
        op.Pagador__c = a2.Id;
        op.Residente__c = a1.Id;
        op.Etapa__c = 'Visita Planificada / Espontánea';
        op.Centro2__c = centro1.Id;
        op.Canal__c = 'Llamada al centro';
        op.Procedencia__c = 'Prescriptor';
        op.Tipo_de_tarifa__c = 'Diaria';
        op.Contacto_Recomendador__c = rec.Id;
        op.Persona_de_Contacto__c = a2.Id;
        op.Empresa_Recomendadora__c = centrorec.Id;        
        op.Visita_realizada_en__c = 'Centro';        
        op.Tipo_de_Financiacion__c = 'Privado';
        op.Fecha_prevista_de_ingreso__c = Date.today();
        op.Servicio__c = sc.Id;
        op.Visita_realizada_en__c = 'Centro';
        op.No_se_solicita_descuento__c=true;
        //op.OwnerId = '005b0000000kj7HAAQ';
        op.No_se_solicita_descuento__c=true;
        triggerHelper.recursiveHelper1(true);
        insert op;
        triggerHelper.recursiveHelper1(false);
        
        Id noc11p = '012b0000000QBcvAAG';
        NOC__c noc = new NOC__c();
        noc.RecordTypeId = noc11p;
        noc.Name = 'noc';
        noc.Estado_Flujo__c = 'Aprobado';
        noc.Fecha_inicio__c = Date.today().addDays(-30);
        noc.Fecha_fin__c = Date.today().addDays(15);
        noc.Centro__c = centro1.Id;
        noc.Descuento_aplicado__c = 10;
        noc.Oportunidad__c = op.Id;
        noc.Id_contrato__c = 'CTR00000';
        insert noc;      
                      
        AvisoNocSchedule m = new AvisoNocSchedule();
        String sch = '20 30 8 10 2 ?';
        String jobID = system.schedule('Merge Job', sch, m);
        
        Test.StartTest();
        AvisoNocBatch anb = new AvisoNocBatch();
        ID batchprocessid = Database.executeBatch(anb);
        Test.StopTest();
        SchedulableContext sss;
        SchedulableEmailMenus sm = new SchedulableEmailMenus();
        sm.execute(sss);
        SchedulableEmailOcio sm2 = new SchedulableEmailOcio();
        sm2.execute(sss);
        SchedulableTareaMenus sm3 = new SchedulableTareaMenus();
        sm3.execute(sss);
        SchedulableTareaOcioyCumple sm4 = new SchedulableTareaOcioyCumple();
        sm4.execute(sss);
    }
}