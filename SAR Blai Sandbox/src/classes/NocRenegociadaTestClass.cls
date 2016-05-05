/** 
* File Name:   NocRenegociadaTestClass 
* Description: Classe test de la crida a NAV de la NocRenegociada
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		16/06/2015  Xavier Garcia
* =============================================================== 
**/ 
@isTest
private class NocRenegociadaTestClass {
    static testMethod void myUnitTest() {
        
        RecordType rtNoc9 = [SELECT Id,Name FROM RecordType WHERE Name='NOC 9 Comunicaciones, presentaciones y campañas'];
        RecordType rtNoc10 = [SELECT Id,Name FROM RecordType WHERE Name='NOC 10 Tarifas de clientes privados'];
        RecordType rtNoc11C = [SELECT Id,Name FROM RecordType WHERE Name='NOC 11 Descuento General Centro'];
        RecordType rtNoc12 = [SELECT Id,Name FROM RecordType WHERE Name='NOC 12 Convenios'];
        RecordType rtNocPers = [SELECT Id,Name FROM RecordType WHERE Name='NOC 11 Descuento Personal Puntual'];
        RecordType rtNocPersRen = [SELECT Id,Name FROM RecordType WHERE Name='NOC 11 Descuento Personal Renegociado'];
        
        Account a1 = new Account();
        a1.FirstName = '1';
        a1.PersonEmail = 'test@test.com';
        a1.LastName = 'cliente1';
        a1.Phone = '442342342344';
        a1.Perfil__c = 'Autónomo';
        a1.Idioma_de_Contacto__pc = 'Catalan';
        a1.Residente__c = true;
        a1.RecordTypeId = '012b0000000QAe0AAG';
        a1.Tipo_Documento_Identidad__c = 'DNI';
        a1.CIF_NIF__c = '68966939J';
        a1.Tipo_Documento_Sanitario__c = 'NCS';
        a1.Nuermo_Documento_Sanitario__c = '111';
        a1.Estado_Civil__c = 'Casado/a';
        a1.Sexo__c = 'Hombre';
        a1.Calle__c = 'Carrer de buenos aires 34';
        a1.Ciudad__c = 'Barcelona';
        a1.PersonBirthdate = Date.parse('02/02/1920');
        a1.Fecha_aviso_Aniversario2__c = Date.parse('02/02/1920');
        a1.Pais__c = 'España';
        a1.Provincia__c = 'Barcelona';
        a1.Codigo_postal__c  = '08036';
        a1.Actualizar_direccion__c = false;      
        a1.Preferencia_de_envio_de_factura__c = 'Recogida en centro';
        insert a1;   
        
        
        Account centro1 = new Account();
        centro1.Name = 'Centro1';
        centro1.RecordTypeId = '012b0000000QAeAAAW';
        centro1.Zona_Comercial_del__c = 'Centro';
        centro1.Phone = '4234234234444';
        centro1.Activo__c = true;
        centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.IdNAV__c = 'CANBUXERES';
        centro1.ATC_Centro__c = '005b0000001Lgzf';
        centro1.Division__c = 'Residencial';
        centro1.Residencial__c = true;
        insert centro1;
    
        
        Servicio__c sc = new Servicio__c();
        sc.Name = 'serv';
        sc.Grado_Dependencia__c = 'Grado 1';
        sc.Tipo_Servicio__c = 'Convalecencia';
        sc.Tipo_Ocupacion__c = 'HD';
        sc.Tipo_Estancia__c = 'Permanente';
        sc.Transporte__c = 'Si';
        insert sc;
        
        
        NOC__c noc2 = new NOC__c();
        noc2.RecordTypeId = rtNoc10.Id;
        noc2.Estado_Flujo__c = 'Aprobado';
        noc2.Fecha_inicio__c = Date.today().addDays(-30);
        noc2.Fecha_fin__c = Date.today().addDays(30);
        noc2.Name = 'noc2';
        noc2.Descuento_aplicado__c = 10.00;
        insert noc2;
        
        Tarifa__c t1 = new Tarifa__c();
        t1.Name = 't1';
        t1.Servicio__c = sc.Id;
        t1.Centro__c = centro1.Id;
        t1.Tipo_Tarifa__c = 'Diaria';
        t1.Precio__c = 100;
        t1.NOC__c = noc2.Id;
        t1.Tarifa_Vigente__c = true;
        insert t1;
    
        
        
        Oportunidad_platform__c op1 = new Oportunidad_platform__c();
        op1.Pagador__c = a1.Id;
        op1.Residente__c = a1.Id;
        op1.Etapa__c = 'Preingreso';
        op1.Fecha_finalizacion__c=Date.today().addDays(5);
        op1.Centro2__c = centro1.Id;
        //op.Contacto_Recomendador__c = rec.Id;
        op1.Canal__c = 'Llamada al Cat';
        op1.Procedencia__c = 'Vecindad';
        op1.Tipo_de_tarifa__c = 'Diaria';
        op1.Tipo_de_pago__c = 'gratis';
        op1.Regimen__c = 'UED';
        op1.Tipo_de_Financiacion__c = 'Privado';
        op1.Fecha_prevista_de_ingreso__c = Date.today();
        op1.Servicio__c = sc.Id;
        op1.Visita_realizada_en__c = 'Centro';
        op1.Descuento_Ofertado__c = null;
        op1.Precio_Ofertado__c = null;
        op1.Forma_de_pago__c = 'Recibo domiciliado';
        op1.Fecha_real_de_ingreso__c = null;
        op1.Precio__c = 100;
        op1.Precio_Plus__c = 20;
        op1.Fecha_prevista_de_ingreso__c = System.today();
        op1.No_se_solicita_descuento__c=true;
        triggerHelper.recursiveHelper1(true); 
        insert op1; 
        triggerHelper.recursiveHelper1(false);
        
        op1.Tipo_de_cobro__c = 'Anticipado';
        op1.IBAN__c = 'ES9121000418450200051332';
        op1.Nombre_Entidad_Bancaria__c = 'aa';
        op1.Localidad_Entidad_Bancaria__c = 'aa';
        op1.Forma_de_pago__c= 'Recibo domiciliado';
        op1.Etapa__c = 'Ingreso';
        op1.Fecha_cierre__c = null;
        triggerHelper.recursiveHelper1(true); 
        update op1;
        triggerHelper.recursiveHelper1(false);
        
        NOC__c nocreng = new NOC__c();
        //noc4.Fecha_inicio__c = Date.today().addDays(-30);
        nocreng.Name = 'noc4';
        nocreng.Estado_Flujo__c = 'Aprobado';
        nocreng.Importe_Mes_1__c = 0.5;
        nocreng.Importe_Mes_2__c = 0.5;
        nocreng.Importe_Mes_3__c = 0.5;
        nocreng.Importe_Mes_4__c = 0.5;
        nocreng.Importe_Mes_5__c = 0.5;
        nocreng.Importe_Mes_6__c = 0.5;
        nocreng.Descuento_permanente__c = false;
        //noc4.Descuento_aplicado__c = 0.2;
        //noc4.Fecha_inicio__c = Date.today();
        nocreng.Fecha_Inicio_1__c = Date.today();
        nocreng.Fecha_Inicio_2__c = Date.today().addDays(2);
        nocreng.Fecha_Inicio_3__c = Date.today().addDays(4);
        nocreng.Fecha_Inicio_4__c = Date.today().addDays(6);
        nocreng.Fecha_Inicio_5__c = Date.today().addDays(8);
        nocreng.Fecha_Inicio_6__c = Date.today().addDays(10);
        nocreng.Fecha_Fin_1__c = Date.today().addDays(1);
        nocreng.Fecha_Fin_2__c = Date.today().addDays(3);
        nocreng.Fecha_Fin_3__c = Date.today().addDays(5);
        nocreng.Fecha_Fin_4__c = Date.today().addDays(7);
        nocreng.Fecha_Fin_5__c = Date.today().addDays(9);
        nocreng.Fecha_Fin_6__c = Date.today().addDays(11);
        nocreng.RecordTypeId = rtNocPersRen.id;
        nocreng.Oportunidad_renegociada__c = op1.id;
        nocreng.Id_contrato__c ='CTR00001';
        insert nocreng;
        
        calloutNavisionWS.enviar_noc_renegociada(nocreng.id);
    }
		
}