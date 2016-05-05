/** 
* File Name:   TestCalloutVidsigner
* Description: Classe test de la clase CalloutVidsigner
* Copyright:   Konozca 
* @author:     Jose M Perez
* Modification Log 
**/ 

@isTest
public class TestCalloutVidsigner {
    static testMethod void myUnitTest() {
        
        date avui = date.today();
        integer mesActual = avui.month();
        
        Account centro1 = new Account();
        centro1.Utiliza_firma_biometrica__c = true;
        centro1.userVidsigner__c = 'userVid';
        centro1.passVidsigner__c = 'passVid';
        centro1.Tableta_1__c = 'idtablet1';
        centro1.Tableta_2__c = 'idtablet2';
        centro1.Tableta_3__c = 'idtablet3';
        centro1.Nombre_Tablet_1__c = 'nombre tablet 1';
        centro1.Nombre_Tablet_2__c = 'nombre tablet 2';
        centro1.Nombre_Tablet_3__c = 'nombre tablet 3';
        centro1.RecordTypeId = getRecordTypeId('Centro');
        centro1.Name = 'Central1';
        centro1.Zona_Comercial__c = 'Barcelona';
        centro1.Fecha_apertura__c = date.newinstance(2010, 1, 1);
        centro1.Capacidad_Teorica__c = 50;
        //centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.NIF_director_centro__c = '43539233A';
        centro1.Division__c = 'Teleasistencia';
        centro1.Phone = '933599023';
        centro1.Activo__c = true;
        centro1.Categoria__c = 'Exclusive';
        //centro1.ATC_Centro__c = '005b0000001Lgzf';
        centro1.Division__c = 'Domiciliaria';
        
        triggerHelper.recursiveHelper3(true);
        insert centro1;
        triggerHelper.recursiveHelper3(false);        
        
        RecordType rtCNoc1 = [SELECT Id,Name FROM RecordType WHERE Developername='Centros_Servicios_NOC_TA'];
		NOC__c noc12 = new NOC__c();
        noc12.RecordTypeId = getRecordTypeId('NOC 12 Convenios');
        noc12.Name = 'noc11';
        noc12.Estado_Flujo__c = 'Aprobado';
        noc12.Fecha_inicio__c = Date.today().addDays(-30);
        noc12.Descuento_permanente__c = true;
        noc12.Tipo__c = 'General';
        noc12.Ratio_de_ocupacion_actual__c = 90;
        noc12.Residencial__c = true;
        
        NOC__c noc10 = new NOC__c();
        noc10.RecordTypeId = getRecordTypeId('NOC 10 Tarifas de clientes privados');
        noc10.Name = 'noc11';
        noc10.division__c = 'Teleasistencia';
        noc10.Ano_Tarifa__c = '2015';
        noc10.Estado_Flujo__c = 'Aprobado';
        noc10.Fecha_inicio__c = Date.today().addDays(-30);
        noc10.Fecha_fin__c = Date.today().addDays(5);
        noc10.Descuento_permanente__c = false;
        noc10.Duracion_del_descuento__c = 30;
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
        
		Recordtype RTTarTa = [SELECT id,name FROM recordtype WHERE name= 'Tarifas TAM'];
        Tarifa__c tTA = new Tarifa__c();
        tTa.RecordTypeId = RTTarTa.id;
        tTa.NOC__c = noc10.id;
        tTa.Servicio_TA__c = scTA.id;
        tTa.Central__c = centro1.id;
        tTa.Precio_servicio__c = 50;
        tTA.Tarifa_Vigente__c = true;
        triggerHelper.recursiveHelper3(true);
        insert tTA;
        
        Centros_NOC__c cNoc1 = new Centros_NOC__c();
        cNoc1.RecordTypeId = rtCNoc1.Id;
        cNoc1.NOC_TAD__c = noc12.Id;       
        cNoc1.Descuento__c = 5;
        cNoc1.Division__c = 'Residencial';
        cNoc1.Tipo_Servicio_2__c = 'Residencial';
        cNoc1.Tipo_Estancia_2__c = 'Temporal';
        cNoc1.Tipo_Ocupacion_2__c = 'HD';
        cNoc1.Grado__c = 'Grado1';
        cNoc1.Transporte__c = 'No';
        cNoc1.Duracion_Periodo_1__c = 10;
        cNoc1.Duracion_Periodo_2__c = 10;
        cNoc1.Duracion_Periodo_3__c = 10;
        cNoc1.Descuento_Periodo_1__c = 10;
        cNoc1.Descuento_Periodo_2__c = 10;
        cNoc1.Descuento_Periodo_3__c = 10;
        cNoc1.Tarifa_TA__c = tTA.id;
        triggerHelper.recursiveHelper3(true);
        insert cNoc1;
        triggerHelper.recursiveHelper3(false);        
        
        
        //Crear Residente
        Account residente1 = new Account();
        residente1.RecordTypeId = getRecordTypeId('Cliente/Familiar');
        residente1.FirstName = 'Nombre1';
        residente1.LastName = 'Apellido1';
        residente1.Residente__c = true;
        residente1.Perfil__c = 'Autónomo';
        residente1.Sexo__c = 'Hombre';
        residente1.Estado_Civil__c = 'Soltero/a';
        residente1.PersonBirthdate = date.newinstance(1940, mesActual, 2);
        residente1.Tipo_Documento_Identidad__c = 'DNI';
        residente1.CIF_NIF__c = '32146871R';
        residente1.Apellido_2__c = 'aaa';
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
        
        Recordtype RTOpTA = [SELECT id,name FROM recordtype WHERE name= 'Oportunidad TAD'];
        
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
        op.idLinia__c = cNoc1.id;
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
        op.Nombre_propio_y_plena_capacidad_de__c = true;
        op.Nombre_Avalista__c = 'sr avalista';
        op.Centro2__c = centro1.Id;
        triggerHelper.recursiveHelper3(true);                  
        insert op;     
        
        //Crear Oportunidad 2
        Oportunidad_platform__c op2 = new Oportunidad_platform__c();        
        op2.Residente__c = residente1.Id;
        op2.Persona_de_Contacto__c = residente1.Id;
        op2.Pagador__c = residente1.Id;
        op2.Etapa__c = 'Abierta';
        op2.Central__c = centro1.Id;
        op2.Canal__c = 'Llamada al Cat';
        op2.Procedencia__c = 'Internet';
        op2.Pagina_web__c = 'Google';
        op2.Tipo_de_tarifa__c = 'Diaria';
        op2.Tipo_de_pago__c = 'gratis';
        op2.idLinia__c = cNoc1.id;
        op2.IBAN__c = 'ES9121000418450200051332';
        op2.Regimen__c = 'UED';
        op2.RecordTypeId = RTOpTA.id;
        op2.Tipo_de_Financiacion__c = 'Privado';
        op2.Fecha_prevista_de_ingreso__c = Date.today();
        op2.Fecha_finalizacion__c = System.today().addDays(15);
        op2.Visita_realizada_en__c = 'Centro';
        op2.Tipo_de_pago__c = 'Gratis';
        op2.Precio_Colgantes__c = 10;
        op2.Precio_sin_colgante__c = 5;
        op2.Nombre_propio_y_plena_capacidad_de__c = false;
        op2.Persona_de_referencia__c = true;
        op2.Nombre_Avalista__c = 'sr avalista';
        op2.Centro2__c = centro1.Id;
        triggerHelper.recursiveHelper3(true);                  
        insert op2;   
        
        //Crear Oportunidad 3
        Oportunidad_platform__c op3 = new Oportunidad_platform__c();        
        op3.Residente__c = residente1.Id;
        op3.Persona_de_Contacto__c = residente1.Id;
        op3.Pagador__c = residente1.Id;
        op3.Etapa__c = 'Abierta';
        op3.Central__c = centro1.Id;
        op3.Canal__c = 'Llamada al Cat';
        op3.Procedencia__c = 'Internet';
        op3.Pagina_web__c = 'Google';
        op3.Tipo_de_tarifa__c = 'Diaria';
        op3.Tipo_de_pago__c = 'gratis';
        op3.idLinia__c = cNoc1.id;
        op3.IBAN__c = 'ES9121000418450200051332';
        op3.Regimen__c = 'UED';
        op3.RecordTypeId = RTOpTA.id;
        op3.Tipo_de_Financiacion__c = 'Privado';
        op3.Fecha_prevista_de_ingreso__c = Date.today();
        op3.Fecha_finalizacion__c = System.today().addDays(15);
        op3.Visita_realizada_en__c = 'Centro';
        op3.Tipo_de_pago__c = 'Gratis';
        op3.Precio_Colgantes__c = 15;
        op3.Precio_sin_colgante__c = 5;
        op3.Nombre_propio_y_plena_capacidad_de__c = false;
        op3.Persona_de_referencia__c = false;
        op3.Representate_legagal__c = true;
        op3.Nombre_Avalista__c = 'sr avalista';
        op3.Centro2__c = centro1.Id;
        op3.DNI_representante_legal__c = 'dni rep';
        op3.Nombre_representante_legal__c = 'nombre rep';
        op3.Apellido_representante_legal__c = 'apellido rep';
        triggerHelper.recursiveHelper3(true);                  
        insert op3;     
        
        Contact c1 = new Contact();
        c1.FirstName = 'c1 first name';
        c1.LastName = 'last name';
        c1.AccountId = centro1.Id;
        c1.Correo_Electronico__c = 'correotest@gmail.com';
        c1.Idioma_de_Contacto__c = 'Castellano';
        c1.Categoria_Profesional__c = 'Director';
        c1.Cargo__c = 'cargo';
        c1.Especialidad_Medica__c = 'Cirujano';
        insert c1;
        
        Relacion_entre_contactos__c rec = new Relacion_entre_contactos__c();
        rec.Residente__c = op2.Residente__c;
        rec.Activo__c = true;
        rec.Familiar_de_referencia__c = true;
        
        insert rec;
        
        CalloutVidsigner.getSigners(centro1, op);
        CalloutVidsigner.getSigners(centro1, op2);
        CalloutVidsigner.getSigners(centro1, op3);
        String docGUI = CalloutVidsigner.getJSONValue('{"DocGUI": "..." }', 'DocGUI');
        String aux = CalloutVidsigner.sendContract(op.Id, 'idTablet');
        CalloutVidsigner.getDoc(op.Id, '{"DocContent": "", "FileName": "file.pdf"}');
        CalloutVidsigner.cancelSign(op.Id, docGUI);
        DocDelete.deleteDocumentFuture(op.ID_Doc_Firmado__c, 'null');
        
    }
    public static String getRecordTypeId(String name){
        List<RecordType> rt = [ SELECT id FROM RecordType WHERE Name =: name LIMIT 1 ];
        return (rt.size()> 0) ? rt.get(0).id : null;
    }    
}