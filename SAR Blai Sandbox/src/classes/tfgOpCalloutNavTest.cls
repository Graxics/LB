@isTest
private class tfgOpCalloutNavTest {
 
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        TriggerHelperExecuteOnce.firstrun13 = false;
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
        insert a1;       
        
        Account a2 = new Account();
        a2.FirstName = '2';
        a2.LastName = 'cliente2';
        a2.Perfil__c = 'Autónomo';
        a2.Phone = '552342234255';
        a2.Idioma_de_Contacto__pc = 'Catalan';
        a2.Residente__c = false;
        a2.PersonEmail = 'test@test.com';
        a2.RecordTypeId = '012b0000000QAe0AAG';
        a2.Tipo_Documento_Sanitario__c = 'NCS';
        a2.Nuermo_Documento_Sanitario__c = '222';
        a2.Tipo_Documento_Identidad__c = 'DNI';
        a2.CIF_NIF__c = '91797849L';
        a2.Estado_Civil__c = 'Casado/a';
        a2.Sexo__c = 'Hombre';
        a2.Calle__c = 'Gran Via 24';
        a2.Preferencia_de_envio_de_factura__c= 'Correo Ordinario';
        a2.Ciudad__c = 'Madrid';
        a2.Provincia__c = 'Madrid';
        a2.Pais__c = 'España';
        a2.Fecha_aviso_Aniversario2__c = Date.parse('02/02/1921');
        a2.PersonBirthdate = Date.parse('02/02/1921');
        a2.Codigo_postal__c  = '28013';
      
        insert a2;
        
        Account soc = new Account();
        soc.Name =  'soc';
        soc.RecordTypeId = '012b0000000QAe5AAG';
        soc.Actualizar_direccion__c = false;        
        triggerHelper.recursiveHelper1(true); 
        insert soc;
        
        soc.Actualizar_direccion__c = true;

        update soc;
        
        RecordType rtNoc9 = [SELECT Id,Name FROM RecordType WHERE Name='NOC 9 Comunicaciones, presentaciones y campañas'];
        RecordType rtNoc10 = [SELECT Id,Name FROM RecordType WHERE Name='NOC 10 Tarifas de clientes privados'];
        RecordType rtNoc11C = [SELECT Id,Name FROM RecordType WHERE Name='NOC 11 Descuento General Centro'];
        RecordType rtNoc12 = [SELECT Id,Name FROM RecordType WHERE Name='NOC 12 Convenios'];
        RecordType rtNocPers = [SELECT Id,Name FROM RecordType WHERE Name='NOC 11 Descuento Personal Puntual'];
        RecordType rtNocPersRen = [SELECT Id,Name FROM RecordType WHERE Name='NOC 11 Descuento Personal Renegociado'];
        
        Account centro = new Account();
        centro.Name =  'centro';
        centro.ParentId = soc.Id;
        centro.Division__c = 'Residencial';
        centro.Categoria__c = 'Premium';
        centro.Zona_Territorial__c = 'Baleares';
        centro.Fecha_apertura__c = Date.today();
        centro.Phone = '6234234233636';
        centro.Capacidad_Teorica__c = 25;
        centro.RecordTypeId = '012b0000000QAeAAAW';

        insert centro;
        
        Servicio__c sc = new Servicio__c();
        sc.Name = 'serv';
        sc.Grado_Dependencia__c = 'Grado 1';
        sc.Tipo_Servicio__c = 'Convalecencia';
        sc.Tipo_Ocupacion__c = 'HD';
        sc.Tipo_Estancia__c = 'Permanente';
        sc.Transporte__c = 'Si';

        insert sc;
        
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
        insert centro1;
        
        NOC__c noc2 = new NOC__c();
        noc2.RecordTypeId = rtNoc10.Id;
        noc2.Estado_Flujo__c = 'Aprobado';
        noc2.Fecha_inicio__c = Date.today().addDays(-30);
        noc2.Fecha_fin__c = Date.today().addDays(30);
        noc2.Name = 'noc2';
        noc2.Descuento_aplicado__c = 10.00;
        triggerHelper.recursiveHelper1(true); 
        insert noc2;
        
        NOC__c noc3 = new NOC__c();
        noc3.RecordTypeId = rtNoc11C.Id;
        noc3.Estado_Flujo__c = 'Aprobado';
        noc3.Fecha_inicio__c = Date.today().addDays(-30);
        noc3.Fecha_fin__c = Date.today().addDays(30);
        noc3.Name = 'noc3';
        noc3.Descuento_aplicado__c = 10.00;
        noc3.Ratio_de_ocupacion_actual__c = 90;
        noc3.Duracion_del_descuento__c = 60;

        insert noc3;
        
        
        
        Centros_NOC__c cn = new Centros_NOC__c();
        cn.Centro__c = centro1.Id;
        cn.Tipo_Servicio_2__c = 'Convalecencia';
        cn.Tipo_Estancia_2__c = 'Permanente';
        cn.Tipo_Ocupacion_2__c = 'HD';
        cn.Grado__c = 'Grado 1';
        cn.Descuento__c = 10;
        cn.NOC__c = noc3.Id;
        triggerHelper.recursiveHelper1(true); 
        insert cn;
        
        Tarifa__c t1 = new Tarifa__c();
        t1.Name = 't1';
        t1.Servicio__c = sc.Id;
        t1.Centro__c = centro1.Id;
        t1.Tipo_Tarifa__c = 'Diaria';
        t1.Precio__c = 10.00;
        t1.NOC__c = noc2.Id;
        t1.Tarifa_Vigente__c = true;

        insert t1;
        
        RecordType rfam = [SELECT Id,Name FROM RecordType WHERE Name='Relación Familiar' LIMIT 1];
        Relacion_entre_contactos__c rc = new Relacion_entre_contactos__c();
        rc.RecordTypeId = rfam.Id;
        rc.Residente__c = a1.Id;
        rc.Contacto__c = a2.Id;
        rc.Familiar_de_referencia__c = true;
        triggerHelper.recursiveHelper1(true); 
        insert rc;
        
        
        RecordType cr = [Select Id, Name From RecordType Where Name = 'Contacto Recomendador' LIMIT 1];
        
        User uAux = [Select Id, Zona_Comercial__c, ProfileId From User where Id = :UserInfo.getUserId() LIMIT 1];        
        
        Account rec = new Account();
        rec.RecordTypeId = cr.Id;
        rec.PersonEmail = 'test@test.com';
        rec.FirstName = 'rc1';
        rec.LastName = 'rec1';
        rec.Phone = '423423423444';
        //rec.ATC_Zona__c = uAux.Id;
        rec.Activo__c = true;
        rec.Clasificacion_tipo_recomendador__c = 'A';
        rec.Residencial__c = true;

        insert rec;
        /*
        Oportunidad_platform__c op = new Oportunidad_platform__c();
        op.Pagador__c = a2.Id;
        op.Residente__c = a1.Id;
        op.Etapa__c = 'Preingreso';
        op.Fecha_finalizacion__c=Date.today().addDays(5);
        op.Centro2__c = centro1.Id;
        op.NOC_11_Centro__c = noc3.Id;
        //op.Contacto_Recomendador__c = rec.Id;
        op.Canal__c = 'Llamada al Cat';
        op.Procedencia__c = 'Vecindad';
        op.Tipo_de_tarifa__c = 'Diaria';
        op.Tipo_de_pago__c = 'gratis';
        op.Regimen__c = 'UED';
        op.Tipo_de_Financiacion__c = 'Privado';
        op.Fecha_prevista_de_ingreso__c = Date.today();
        op.Servicio__c = sc.Id;
        op.Visita_realizada_en__c = 'Centro';
        op.Descuento_Ofertado__c = null;
        op.Precio_Ofertado__c = null;
        op.Forma_de_pago__c = 'Recibo domiciliado';
        op.Fecha_real_de_ingreso__c = null;
        op.Fecha_prevista_de_ingreso__c = System.today();
         triggerHelper.recursiveHelper1(true); 
        insert op;       
         triggerHelper.recursiveHelper1(false); 
        op.Tipo_de_cobro__c = 'Anticipado';
        op.IBAN__c = 'ES9121000418450200051332';
        op.NOC_11_Centro__c = noc3.Id;
        op.Nombre_Entidad_Bancaria__c = 'aa';
        op.Localidad_Entidad_Bancaria__c = 'aa';
        op.Forma_de_pago__c= 'Recibo domiciliado';
        op.Etapa__c = 'Ingreso';
        op.Fecha_cierre__c = null;
        triggerHelper.recursiveHelper1(true);        
        update op;
        triggerHelper.recursiveHelper1(false); */
        
        Oportunidad_platform__c op1 = new Oportunidad_platform__c();
        op1.Pagador__c = a2.Id;
        op1.Residente__c = a1.Id;
        op1.Etapa__c = 'Preingreso';
        op1.Fecha_finalizacion__c=Date.today().addDays(5);
        op1.Centro2__c = centro1.Id;
        op1.NOC_11_Centro__c = noc3.Id;
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
        op1.Fecha_prevista_de_ingreso__c = System.today();
        triggerHelper.recursiveHelper1(true); 
        insert op1; 
        triggerHelper.recursiveHelper1(false); 
        
        TriggerHelperExecuteOnce.firstRun10 = true;
        
        op1.NOC_11_Centro__c = null;
       // op1.NOC_11_Persona__c = noc4.id;
        op1.Tipo_de_cobro__c = 'Anticipado';
        op1.IBAN__c = 'ES9121000418450200051332';
        op1.NOC_11_Centro__c = noc3.Id;
        op1.Nombre_Entidad_Bancaria__c = 'aa';
        op1.Localidad_Entidad_Bancaria__c = 'aa';
        op1.Forma_de_pago__c= 'Recibo domiciliado';
        op1.Etapa__c = 'Ingreso';
        op1.Fecha_cierre__c = null;
        triggerHelper.recursiveHelper1(true);        
        //update op1;
        triggerHelper.recursiveHelper1(false);
        

        a1.LastName = 'camb';
        a1.IdNAV_RES__c = 'RES1223';
        a1.Ultima_Mod__c = null;
        a1.Actualizar_direccion__c = true;
        triggerHelper.recursiveHelper1(true); 
        update a1;
        
        calloutNavisionWS.createResident(a1.Id);
        //calloutNavisionWS.modifyCustomer(a2.Id);
        calloutNavisionWS.createIngresoWS(op1.Id);
        //calloutNavisionWS.enviar_noc_renegociada(noc4.id);
        
        triggerHelper.sendMail('Exception');
        triggerHelper.sendMail('Exception', new List<String>{'sergiaguilar@konozca.com'}, 'https://sarquavitae.my.salesforce.com/');
        CalloutNavisionWS.modifyCustomer(a1.Id);
         
        GCRWebService.createOportunidadGCRResponse_element gc1 = new  GCRWebService.createOportunidadGCRResponse_element();
        GCRWebService.createCustomerGCR_element gc2 = new  GCRWebService.createCustomerGCR_element();
        GCRWebService.createContactoGCR_element gc3 = new  GCRWebService.createContactoGCR_element();
        GCRWebService.GCRTestResponse_element gc4 = new  GCRWebService.GCRTestResponse_element();
        GCRWebService.createContactoGCRResponse_element gc5 = new  GCRWebService.createContactoGCRResponse_element();
        GCRWebService.createOportunidadGCR_element gc6 = new  GCRWebService.createOportunidadGCR_element();
        GCRWebService.createCustomerGCRResponse_element gc7 = new  GCRWebService.createCustomerGCRResponse_element();
       
        tempuriOrg.createCustomer_element to1 = new tempuriOrg.createCustomer_element();
        tempuriOrg.createCustomerResponse_element to2 = new tempuriOrg.createCustomerResponse_element();
        tempuriOrg.createServiceResponse_element to3 = new tempuriOrg.createServiceResponse_element();
        tempuriOrg.createService_element to4 = new tempuriOrg.createService_element();
        tempuriOrg.createResidentResponse_element to5 = new tempuriOrg.createResidentResponse_element();
        tempuriOrg.createResident_element to6 = new tempuriOrg.createResident_element();
        tempuriOrg.CreateContract_element to7 = new tempuriOrg.CreateContract_element();
        TriggerHelperExecuteOnce.firstRun10 = false;
    }
}