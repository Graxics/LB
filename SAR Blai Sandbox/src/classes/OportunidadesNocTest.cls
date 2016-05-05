/** 
* File Name:   OportunidadesNocTest 
* Description: Test del trigger tgOportunitatsNoc
* Copyright:   Konozca 
* @author:     Hector Mañosas
* Modification Log 
* =============================================================== 
*Date     		Author          Modification 
* 01/08/2014 	HManosas			
* =============================================================== 
**/

@isTest
private class OportunidadesNocTest {

    static testMethod void myUnitTest() {
        //TriggerHelperExecuteOnce.executar2();
        date avui = date.today();
        integer mesActual = avui.month();
		//Creamos una NOC de tipo NOC 11 Descuento General Centro
        NOC__c noc1 = new NOC__c();
        noc1.RecordTypeId = '012b0000000QBcqAAG';
        noc1.Name = 'noc1';
        noc1.Estado_Flujo__c = 'Aprobado';
        noc1.Fecha_inicio__c = Date.today().addDays(-30);
        noc1.Fecha_fin__c = Date.today().addDays(5);
        noc1.Descuento_permanente__c = false;
        noc1.Tipo__c = 'General';
        noc1.Ratio_de_ocupacion_actual__c = 90;
        noc1.Limite_de_plazas__c = true;
        noc1.Numero_de_plazas__c = 50;
        noc1.Duracion_del_descuento__c = 10;
        noc1.Id_contrato__c = 'CTR00000';
        //triggerHelper.recursiveHelper3(true);           
        insert noc1;
        //triggerHelper.recursiveHelper3(false);
        /*
        NOC__c noc11 = new NOC__c();
        noc11.RecordTypeId = '012b0000000QBcqAAG';
        noc11.Name = 'noc11';
        noc11.Estado_Flujo__c = 'Aprobado';
        noc11.Fecha_inicio__c = Date.today().addDays(-30);
        noc11.Fecha_fin__c = Date.today().addDays(5);
        noc11.Descuento_permanente__c = false;
        noc11.Tipo__c = 'General';
        noc11.Ratio_de_ocupacion_actual__c = 90;
        noc11.Limite_de_plazas_en_rotacion__c = true;
        noc11.Numero_de_plazas_en_rotacion__c = 50;
        noc11.Duracion_del_descuento__c = 10;
        noc11.Id_contrato__c = 'CTR00000';
        triggerHelper.recursiveHelper3(true);           
        insert noc11;
        triggerHelper.recursiveHelper3(false);
        */
        RecordType rtCNoc1 = [SELECT Name FROM RecordType WHERE Developername='Centros_Servicios_NOC_mejorada' LIMIT 1];
        
        //Creamos un centro NOC para la NOC 11
        Centros_NOC__c cNoc1 = new Centros_NOC__c();
        cNoc1.RecordTypeId = rtCNoc1.Id;
        cNoc1.NOC__c = noc1.Id;       
        cNoc1.Descuento__c = 5;
        cNoc1.Division__c = 'Residencial';
        cNoc1.Tipo_Servicio_2__c = 'Residencial';
        cNoc1.Tipo_Estancia_2__c = 'Temporal';
        cNoc1.Tipo_Ocupacion_2__c = 'HD';
        cNoc1.Grado__c = 'Grado1';
        cNoc1.Transporte__c = 'No';
        //triggerHelper.recursiveHelper3(true);
        insert cNoc1;
        //triggerHelper.recursiveHelper3(false);
                       
        //Creamos un servicio
        Servicio__c sc = new Servicio__c();
        sc.Name = 'serv';
        sc.Tipo_Servicio__c = 'Residencial';
        sc.Tipo_Estancia__c = 'Temporal';
        sc.Tipo_Ocupacion__c = 'HD';
        sc.Grado_Dependencia__c = 'Grado1';
        sc.Transporte__c = 'No';
        //triggerHelper.recursiveHelper3(true);
        insert sc;
        //triggerHelper.recursiveHelper3(false);
        Recordtype Rec_STA = [select id from recordtype where name = 'Servicios TA'];
        Servicio__c scTA = new Servicio__c();
        scTA.Name = 'serv2';
        scTA.RecordTypeId = Rec_STA.id;
        scTA.Tipo_de_servicio_TA__c = 'Adapta 24';
        scTA.Tipo_de_periferico__c = 'Periférico Gas';
        scTA.Activo__c = true;
        scTA.Cuota_inicial__c = false;
        //triggerHelper.recursiveHelper3(true);
        insert scTA;
        //triggerHelper.recursiveHelper3(false);
        
        //Creamos una Account de tipo Centro
        Account centro1 = new Account();
        centro1.Name = 'Can Buxeres';
        centro1.RecordTypeId = '012b0000000QAeAAAW';        
        centro1.Phone = '442342343244';
        centro1.Activo__c = true;
        centro1.Director_del_centro__c = '005b0000000kj7HAAQ';
        centro1.Division__c = 'Residencial';
        centro1.Zona_comercial__c = 'Barcelona';
        centro1.IdNAV__c = 'CANBUXERES';
        //triggerHelper.recursiveHelper3(true);
        insert centro1;
        //triggerHelper.recursiveHelper3(false);
        /*
        //Creamos otro centro NOC para la NOC 11
        Centros_NOC__c cNoc2 = new Centros_NOC__c();
        cNoc2.RecordTypeId = rtCNoc1.Id;
        cNoc2.NOC__c = noc11.Id;       
        cNoc2.Precio__c = 5;
        cNoc2.Centro__c = centro1.Id;
        cNoc2.Tipo_Servicio_2__c = 'Residencial';
        cNoc2.Tipo_Estancia_2__c = 'Temporal';
        cNoc2.Tipo_Ocupacion_2__c = 'HD';
        cNoc2.Grado__c = 'Grado1';
        cNoc2.Transporte__c = 'No';
        triggerHelper.recursiveHelper3(true);
        insert cNoc2;
        triggerHelper.recursiveHelper3(false);
        
        //Creamos otro centro NOC para la NOC 11
        Centros_NOC__c cNoc3 = new Centros_NOC__c();
        cNoc3.RecordTypeId = rtCNoc1.Id;
        cNoc3.NOC__c = noc1.Id;       
        cNoc3.Descuento__c = 5;
        cNoc3.Zona_Comercial_2__c = 'Barcelona';
        cNoc3.Tipo_Servicio_2__c = 'Residencial';
        cNoc3.Tipo_Estancia_2__c = 'Temporal';
        cNoc3.Tipo_Ocupacion_2__c = 'HD';
        cNoc3.Grado__c = 'Grado1';
        cNoc3.Transporte__c = 'No';
        triggerHelper.recursiveHelper3(true);
        insert cNoc3;
        triggerHelper.recursiveHelper3(false);
        */
        //Creamos una Account de tipo Cliente   
        Account a1 = new Account();
        a1.FirstName = 'FName';
        a1.LastName = 'cliente1 apell';
        a1.Apellido_2__c = 'apell';
        a1.Perfil__c = 'Autónomo';
        a1.PersonEmail = 'test@test.com';
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
        a1.Preferencia_de_envio_de_factura__c = 'Correo ordinario';
        a1.Codigo_postal__c  = '08036';
        //triggerHelper.recursiveHelper3(true);
        insert a1;
       // triggerHelper.recursiveHelper3(false);
        
        //Account Cliente (Persona Contacto)
        Account a2 = new Account();
        a2.FirstName = '2';
        a2.LastName = 'cliente2 apell';
        a2.personEmail = 'test@t.com';
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
        a2.Provincia__c = 'Guipuzkoa';
        a2.Pais__c = 'España';
        //triggerHelper.recursiveHelper3(true);
        insert a2;
        //triggerHelper.recursiveHelper3(false);
/*        
        //Establecemos una relacion familiar entre los dos Clientes
        Relacion_entre_contactos__c rc = new Relacion_entre_contactos__c();
        rc.RecordTypeId = '012b0000000QCbyAAG';
        rc.Residente__c = a1.Id;
        rc.Contacto__c = a2.Id;
        rc.Familiar_de_referencia__c = true;
        triggerHelper.recursiveHelper3(true);
        insert rc;
        triggerHelper.recursiveHelper3(false);
 */     
        //Creamos una NOC de tipo Tarifa Cliente Privado
        NOC__c noc2 = new NOC__c();
        noc2.RecordTypeId = '012b0000000QBclAAG';
        noc2.Estado_Flujo__c = 'Aprobado';
        noc2.Fecha_inicio__c = Date.today().addDays(-30);
        noc2.Fecha_fin__c = Date.today().addDays(5);
        noc2.Name = 'noc2';
        noc2.Division__c = 'Residencial';
        noc2.Ano_Tarifa__c = '2014';
		noc2.Id_contrato__c = 'CTR00000';        
       // triggerHelper.recursiveHelper3(true);
        insert noc2;
       // triggerHelper.recursiveHelper3(false); 

        //Recordtype RTTarTa = [select id,name from recordtype where name= 'Tarifas TAM' Limit 1];

        //Creamos una nueva Tarifa  y la asigamos al centro1 y Noc1
        Tarifa__c t1 = new Tarifa__c();
        t1.RecordTypeId = '012b0000000QBcHAAW';
        t1.Name = 't1';
        t1.Servicio__c = sc.Id;
        t1.Tipo_Contrato__c = 'Privado';
        t1.Centro__c = centro1.Id;
        t1.Tipo_Tarifa__c = 'Diaria';
        t1.Tarifa_Vigente__c = true;
        t1.Precio__c = 10.00;
        t1.Precio_Plus__c = 0.00;
        t1.NOC__c = noc2.Id;
       // triggerHelper.recursiveHelper3(true);
        insert t1;
        //triggerHelper.recursiveHelper3(false);
 /*       
        Tarifa__c t2 = new Tarifa__c();
        t2.RecordTypeId = RTTarTa.id;
        t2.Name = 't2';
        t2.Servicio_TA__c = scTA.Id;
        t2.Central__c = centro1.Id;
        t2.Tarifa_Vigente__c = true;
        t2.Precio_dispositivo__c = 30;
        t2.Precio_servicio__c = 20;
        t2.NOC__c = noc2.Id;
        triggerHelper.recursiveHelper3(true);
        insert t2;
        triggerHelper.recursiveHelper3(false);
*/
        //Creamos una nueva Account de Tipo Empresa Recomendador         
	    Account centrorec = new Account();
        centrorec.Name = 'Centro3';
        centrorec.RecordTypeId = '012b0000000QAd7AAG';
        centrorec.Zona_Comercial_del__c = 'Barcelona';
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
        //triggerHelper.recursiveHelper3(true);        
        insert centrorec;
        //triggerHelper.recursiveHelper3(false);
        
        //Creamos una Oportunidad
        Oportunidad_platform__c op = new Oportunidad_platform__c();        
        op.Residente__c = a1.Id;
        op.Persona_de_Contacto__c = a1.Id;
        op.Pagador__c = a1.Id;
        op.Empresa_Recomendadora__c = centrorec.Id;
        op.Residente__c = a1.Id;
        op.Procedencia__c = 'Prescriptor';  
        op.Etapa__c = 'Pendiente Visita';
        op.Centro2__c = centro1.Id;
        op.Canal__c = 'Llamada al centro';
        op.Procedencia__c = 'Prescriptor';
        op.Tipo_de_tarifa__c = 'Diaria';
        op.Tipo_de_pago__c = 'gratis';
        op.Regimen__c = 'UED';
        op.RecordTypeId = '012b0000000QBG6AAO';
        op.Tipo_de_Financiacion__c = 'Privado';
        op.Fecha_prevista_de_ingreso__c = Date.today();
        op.Fecha_finalizacion__c = System.today().addDays(3);
        op.Servicio__c = sc.Id;
        op.Visita_realizada_en__c = 'Centro';
        op.Motivo_de_Alta_Comercial__c = 'Exitus';
        op.Motivio_de_Alta_GCR__c = 'Exitus';
        op.No_se_solicita_descuento__c=true;
        insert op;
        op.Etapa__c = 'Visita Planificada / Espontánea';
        triggerHelper.recursiveHelper3(true); 
        //Task t = new Task();
        //t = [SELECT id, Subject, WhatId from TASK where WhatId = :op.id and Subject = 'Llamada recibida' LIMIT 1];
        //System.debug('TAREAS: ' + t);
        //System.assertEquals(t.Subject, 'Llamada recibida');
        //update op;
        triggerHelper.recursiveHelper3(false);
/*        

        op.Fecha_Plan_Personal__c = System.today();
        triggerHelper.recursiveHelper3(true);  
        // update op;
        triggerHelper.recursiveHelper3(false);
       
        op.Etapa__c = 'Presentado Plan Personal';
        op.NOC_11_Centro__c = noc1.Id; 
        op.No_se_solicita_descuento__c=false;
        triggerHelper.recursiveHelper3(true);  
       // update op;
        triggerHelper.recursiveHelper3(false);       
        
        //Oportunidad Ingreso
         
        op.Etapa__c = 'Preingreso';
        op.Forma_de_pago__c = 'Recibo domiciliado';
        op.IBAN__c = 'ES0801825706040201507814';
        op.Localidad_Entidad_Bancaria__c = 'Donostia';
        op.Nombre_Entidad_Bancaria__c = 'BBVA';
        op.Tipo_de_cobro__c = 'Anticipado';
        op.Fecha_real_de_ingreso__c = System.today().addDays(2); 
        triggerHelper.recursiveHelper3(true); 
        //update op;
        triggerHelper.recursiveHelper3(false); 
        
        
        TriggerHelperExecuteOnce.executar2();
      
        //Creamos una NOC 11 Persona
        NOC__c noc3 = new NOC__c();
        noc3.RecordTypeId = '012b0000000QBcvAAG';
        noc3.Estado_Flujo__c = 'Aprobado';
        noc3.Fecha_inicio__c = Date.today().addDays(-30);
        noc3.Fecha_fin__c = Date.today().addDays(5);
        noc3.Name = 'noc3';
        noc3.Descripcion__c = 'aaaa';
        noc3.Oportunidad__c = op.Id;
        noc3.Descuento_aplicado__c = 10; 
        noc3.Id_contrato__c = 'CTR00000';
        triggerHelper.recursiveHelper3(true);
        insert noc3;
        triggerHelper.recursiveHelper3(false);       
       
        
        //NOC 11 Renegociado
        RecordType tipoRegistro = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName = 'NOC_11_Descuento_Personal_Renegociado' LIMIT 1];
        NOC__c noc4 = new NOC__c();
        noc4.RecordTypeId = tipoRegistro.Id;
        noc4.Estado_Flujo__c = 'Aprobado';
        noc4.Fecha_inicio__c = Date.today().addDays(-30);
        noc4.Fecha_fin__c = Date.today().addDays(5);
        noc4.Name = 'noc4';
        noc4.Descripcion__c = 'aaaa';
        noc4.Oportunidad__c = op.Id;
        noc4.Descuento_aplicado__c = 10; 
        noc4.Id_contrato__c = 'CTR00001';
        triggerHelper.recursiveHelper3(true);
        insert noc4;
        triggerHelper.recursiveHelper3(false);                     
          
     /*
        //NOC 12 Renegociado
        RecordType tipoRegistroNoc12 = [SELECT Id, Name, DeveloperName FROM RecordType WHERE Name = 'NOC 12 Convenios' LIMIT 1];
        NOC__c noc12 = new NOC__c();
        noc12.RecordTypeId = tipoRegistroNoc12.Id;
        noc12.Estado_Flujo__c = 'Aprobado';
        noc12.Fecha_inicio__c = Date.today().addDays(-30);
        noc12.Fecha_fin__c = Date.today().addDays(5);
        noc12.Name = 'noc4';
        noc12.Descripcion__c = 'aaaa';
        noc12.Oportunidad__c = op.Id;
        noc12.Descuento_aplicado__c = 10; 
        noc12.Id_contrato__c = 'CTR00001';
        noc12.Division__c = 'Teleasistencia';
        noc12.Domiciliaria__c = true;
        triggerHelper.recursiveHelper3(true);
        insert noc12;
        triggerHelper.recursiveHelper3(false);          
        
		Oportunidad_platform__c op2 = new Oportunidad_platform__c();        
        op2.Persona_de_Contacto__c = a1.Id;
        op2.Pagador__c = a1.Id;
        op2.Empresa_Recomendadora__c = centrorec.Id;
        op2.Residente__c = a2.Id;
        op2.Procedencia__c = 'Prescriptor';  
        op2.Etapa__c = 'Preingreso';
        op2.Centro2__c = centro1.Id;
        op2.Canal__c = 'Llamada al Cat';
        op2.Procedencia__c = 'Prescriptor';
        op2.Tipo_de_tarifa__c = 'Diaria';
        op2.Tipo_de_pago__c = 'gratis';
        op2.Regimen__c = 'UED';
        op2.RecordTypeId = '012b0000000QBG6AAO';
        op2.Tipo_de_Financiacion__c = 'Privado';
        op2.Fecha_prevista_de_ingreso__c = Date.today();
        op2.Fecha_finalizacion__c = System.today().addDays(3);
        op2.Servicio__c = sc.Id;
        op2.Visita_realizada_en__c = 'Centro';
        op2.Motivo_de_Alta_Comercial__c = 'Exitus';
        op2.Motivio_de_Alta_GCR__c = 'Exitus';
        op2.No_se_solicita_descuento__c = false;
        op2.NOC_12_Convenios__c = noc12.id;
        insert op2;        
        System.debug('noc12 = ' + op2.NOC_12_Convenios__c);       
        op2.Etapa__c = 'Ingreso';
        op2.Forma_de_pago__c = 'Efectivo / Transferencia';
        op2.Tipo_de_cobro__c = 'Vencido';
        //update op2;
    */  
  /*     
        //Informamos el Centro
        cNoc1.Division__c = null;
        cNoc1.Zona_Comercial_2__c = null;
        cNoc1.Centro__c = centro1.Id;
        triggerHelper.recursiveHelper3(true);
        //update cNoc1;
        triggerHelper.recursiveHelper3(false); 
        
        //op.Descuento_Ofertado__c = null;
        //op.Precio_Ofertado__c = null;
        //triggerHelper.recursiveHelper3(true);        
        ////update op;
        triggerHelper.recursiveHelper3(false);               
        
        
        //Informamos Precio en lugar de Descuento
        cNoc1.Centro__c = null;
        cNoc1.Division__c = null;
        cNoc1.Zona_Comercial_2__c = 'Barcelona';
        cNoc1.Precio__c = 5;
        cNoc1.Descuento__c = null;
        triggerHelper.recursiveHelper3(true);        
        //update cNoc1;
        triggerHelper.recursiveHelper3(false);
        
        triggerHelper.recursiveHelper3(true);
        ////update op;
        triggerHelper.recursiveHelper3(false);
        
        NOC__c noc10 = new NOC__c();
        noc10.RecordTypeId = '012b0000000QBcl';
        noc10.Name = 'noc11';
        noc10.division__c = 'Teleasistencia';
        noc10.Ano_Tarifa__c = '2015';
        noc10.Estado_Flujo__c = 'Aprobado';
        noc10.Fecha_inicio__c = Date.today().addDays(-30);
        noc10.Fecha_fin__c = Date.today().addDays(5);
        noc10.Descuento_permanente__c = false;
        noc10.Id_contrato__c = 'CTR00000';
        triggerHelper.recursiveHelper3(true);           
        insert noc10;
        triggerHelper.recursiveHelper3(false);
        
        
        Servicio__c scTA2 = new Servicio__c();
        scTA2.Name = 'serv2';
        scTA2.RecordTypeId = Rec_STA.id;
        scTA2.Tipo_de_servicio_TA__c = 'Adapta 24';
        scTA2.Tipo_de_periferico__c = 'Periférico Gas';
        scTA2.Activo__c = true;
        scTA2.Cuota_inicial__c = false;
        triggerHelper.recursiveHelper3(true);
        insert scTA2;
        triggerHelper.recursiveHelper3(false);
        
        Tarifa__c tTA = new Tarifa__c();
        tTa.RecordTypeId = RTTarTa.id;
        tTa.NOC__c = noc10.id;
        tTa.Servicio_TA__c = scTA2.id;
        tTa.Central__c = centro1.id;
        tTa.Precio_servicio__c = 50;
        triggerHelper.recursiveHelper3(true);
        insert tTA;
        triggerHelper.recursiveHelper3(false);
    */    
   
    }
}