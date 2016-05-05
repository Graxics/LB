/** 
* File Name:   TestTriggerCreateTasks 
* Description: Test del trigger tgCreateTasks
* Copyright:   Konozca 
* @author:     Hector Mañosas
* Modification Log 
* =============================================================== 
*Date     		Author          Modification 
* 16/10/2014 	HManosas		
* =============================================================== 
**/

@isTest

private class TestTriggerCreateTasks 
{
	static testMethod void myUnitTest() 
	{			
		//Contacto Recomendador
		Account c = new Account();
		c.RecordTypeId = '012b0000000QAd7AAG';
		c.Name = 'Recomendador';
		c.Type = 'Prescriptor';
		c.Clasificacion__c = 'Hospitales';
		c.Clasificacion_tipo_recomendador__c = 'B';
		c.Phone = '666666666';
        c.zona_comercial__c = 'Barcelona';
		c.Sur_Occidental__c = true;
        c.Residencial__c = true;
        c.Clasificacion_tipo_recomendador__c = 'A';
        c.Provincia__c = 'Barcelona';
		triggerHelper.recursiveHelper1(true);   
		insert c;
		triggerHelper.recursiveHelper1(false);
		
		//Persona de contacto
		Account pc = new Account();
		pc.RecordTypeId = '012b0000000QAe0AAG';
        pc.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        pc.PersonEmail = 'test@test.com';
		pc.FirstName = 'FName';
        pc.LastName = 'LName';
        pc.Perfil__c = 'Autónomo';
        pc.Idioma_de_Contacto__pc = 'Catalan';
        pc.Residente__c = true;
        pc.Phone = '523423423455';
        pc.Tipo_Documento_Identidad__c = 'DNI';        
        pc.CIF_NIF__c = '67023159D';
        pc.Tipo_Documento_Sanitario__c = 'NCS';
        pc.Nuermo_Documento_Sanitario__c = '111';
        pc.Estado_Civil__c = 'Casado/a';
        pc.Sexo__c = 'Hombre';        
        pc.Calle__c = 'Carrer de buenos aires 34';
        pc.Ciudad__c = 'Barcelona';
        pc.PersonBirthdate = Date.today().addDays(-15);
        pc.Codigo_postal__c  = '08036';
        triggerHelper.recursiveHelper1(true);	
        insert pc;
        triggerHelper.recursiveHelper1(false);
        
        //Entidad recomendadora
        Account er = new Account();
        er.RecordTypeId = '012b0000000QAd7AAG';
        er.Name = 'Entidad Recomendadora';
		er.Type = 'Prescriptor';
		er.Clasificacion__c = 'Hospitales';
		er.Clasificacion_tipo_recomendador__c = 'A';
		er.Calle__c = 'Calle1';
		er.Ciudad__c = 'Ciudad1';
		er.Codigo_postal__c = '08030';
		er.Provincia__c = 'Barcelona';	
        er.zona_comercial__c = 'Barcelona';
		er.Pais__c = 'España';
		er.Phone = '933333333';
        er.Residencial__c = true;
        er.Clasificacion_tipo_recomendador__c = 'A';
		er.Sur_Occidental__c = true;	
		triggerHelper.recursiveHelper1(true);   
		insert er;
		triggerHelper.recursiveHelper1(false);
			
		//Creamos una Oportunidad
        Oportunidad_platform__c op = new Oportunidad_platform__c();
        op.Contacto_Recomendador__c = c.Id;        
        op.Persona_de_Contacto__c = pc.Id;
        op.Empresa_Recomendadora__c = er.Id;
        op.Procedencia__c = 'Prescriptor';        
        op.Etapa__c = 'Pendiente Visita';
        op.Canal__c = 'Llamada al centro';   
        triggerHelper.recursiveHelper1(true);
        insert op;  
        triggerHelper.recursiveHelper1(false);
        
        Task t = new Task();
        t = [SELECT id, Subject, WhatId from TASK where WhatId = :op.id];
        System.debug('tarea' + t);
        System.assertEquals(t.Subject, 'Llamada recibida');
        
        Document d = new Document();
        d.Name = 'Tabla Eventos Visitas';
        d.FolderId = '005b0000000kj7HAAQ';
        insert d;
        
        //Centro
        Account centro = new Account();
        centro.RecordTypeId = '012b0000000QAeAAAW';
        centro.Name = 'centro1';
        centro.Division__c = 'Residencial';
        centro.Phone = '93333333333';
        centro.Director_del_centro__c = '005b0000000kj7HAAQ';
        centro.zona_comercial__c = 'Barcelona';
        centro.Activo__c = true;
        triggerHelper.recursiveHelper2(true);
        insert centro;
        triggerHelper.recursiveHelper2(false);
        
        //Persona de contacto
		Account pc2 = new Account();
		pc2.RecordTypeId = '012b0000000QAe0AAG';
		pc2.FirstName = 'FName2';
        pc2.LastName = 'LName2';
        pc2.PersonEmail = 'test@test.com';
        pc2.Perfil__c = 'Autónomo';
        pc2.Idioma_de_Contacto__pc = 'Catalan';
        pc2.Residente__c = true;
        pc2.Phone = '523423423455';
        pc2.Tipo_Documento_Identidad__c = 'DNI';        
        pc2.CIF_NIF__c = '66099481B';
        pc2.Tipo_Documento_Sanitario__c = 'NCS';
        pc2.Nuermo_Documento_Sanitario__c = '222';
        pc2.Estado_Civil__c = 'Casado/a';
        pc2.Sexo__c = 'Hombre';        
        pc2.Calle__c = 'Carrer de buenos aires 34';
        pc2.Ciudad__c = 'Barcelona';
        pc2.PersonBirthdate = Date.today().addDays(-15);
        pc2.Codigo_postal__c  = '08036';
        triggerHelper.recursiveHelper1(true);	
        insert pc2;
        triggerHelper.recursiveHelper1(false);
        
        //Relacion contacto Residente
        Relacion_entre_contactos__c r = new Relacion_entre_contactos__c();
        r.Contacto__c = pc2.Id;
        r.Residente__c = pc.Id;
        r.Familiar_de_referencia__c = true;
        triggerHelper.recursiveHelper1(true);
        insert r;     
        triggerHelper.recursiveHelper1(false);
        
        Oportunidad_platform__c op3 = new Oportunidad_platform__c();
        op3.recordtypeid = '012b0000000QBG6';
        op3.Contacto_Recomendador__c = c.Id;        
        op3.Persona_de_Contacto__c = pc.Id;
        op3.Residente__c = pc.Id;
        op3.Empresa_Recomendadora__c = er.Id;
        op3.Procedencia__c = 'Prescriptor';        
        //op3.Etapa__c = 'Visita Planificada / Espontánea';
        op3.Etapa__c ='Pendiente de visita';
        op3.Canal__c = 'Llamada desde el centro';
        op3.Visita_realizada_en__c = 'Centro';
        op3.Centro2__c = centro.Id;
        op3.No_se_solicita_descuento__c=true;
        triggerHelper.recursiveHelper1(true);
        insert op3;
        triggerHelper.recursiveHelper1(false);
              
        
        //Creamos una NOC
        NOC__c noc = new NOC__c();
        noc.RecordTypeId = '012b0000000QBclAAG';
        noc.Estado_Flujo__c = 'Aprobado';
        noc.Fecha_inicio__c = Date.today().addDays(-30);
        noc.Fecha_fin__c = Date.today().addDays(30);
        noc.Name = 'noc1';
        noc.Division__c = 'Residencial';
        noc.Ano_Tarifa__c = '2014';
       
        noc.Id_contrato__c = 'CTR00000';
        triggerHelper.recursiveHelper1(true);
        insert noc;
        triggerHelper.recursiveHelper1(false);
        
        //Creamos un servicio
        Servicio__c sc = new Servicio__c();
        sc.Name = 'serv';
        sc.Tipo_Servicio__c = 'Residencial';
        sc.Tipo_Estancia__c = 'Permanente';
        sc.Tipo_Ocupacion__c = 'HI';
        sc.Grado_Dependencia__c = 'Grado3';
        triggerHelper.recursiveHelper1(true);
        insert sc;
        triggerHelper.recursiveHelper1(false);
        
        //Creamos una nueva Tarifa  y la asigamos al centro1 y Noc1
        Tarifa__c t1 = new Tarifa__c();
        t1.RecordTypeId = '012b0000000QBcHAAW';
        t1.Name = 't1';
        t1.Servicio__c = sc.Id;
        t1.Tipo_Contrato__c = 'Privado';
        t1.Centro__c = centro.Id;
        t1.Tipo_Tarifa__c = 'Mensual';
        t1.Tarifa_Vigente__c = true;
        t1.Precio__c = 10.00;
        t1.Precio_Plus__c = 0.00;
        t1.NOC__c = noc.Id;
        triggerHelper.recursiveHelper1(true);
        insert t1;      
        triggerHelper.recursiveHelper1(false);
        
        op3.Etapa__c = 'Pendiente de Visita';
        op3.Servicio__c = sc.Id;
        op3.Fecha_finalizacion__c = Date.Today().addDays(1);
        op3.Tipo_de_tarifa__c = 'Mensual';
        op3.Fecha_Plan_Personal__c = Date.today().addDays(-1);  
        triggerHelper.recursiveHelper1(true);
        update op3;
        triggerHelper.recursiveHelper1(false);
        op3.Etapa__c = 'Visita Planificada / Espontánea';
        op3.Fecha_prevista_de_ingreso__c = Date.today();
        op3.Tipo_de_Financiacion__c = 'Privada';
        triggerHelper.recursiveHelper1(true);
        update op3;
        triggerHelper.recursiveHelper1(false);
        op3.Fecha_real_de_ingreso__c = Date.today();
        op3.Regimen__c = 'Residencia';
        op3.Tipo_de_cobro__c = 'Vencido';
        op3.Forma_de_pago__c = 'Efectivo / Transferencia';
        op3.Etapa__c = 'Presentado Plan Personal';
        op3.Pagador__c = pc.id;
        TriggerHelperExecuteOnce.firstRun6 = true;
        update op3;
		
	}
	

}