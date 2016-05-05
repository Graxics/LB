/** 
* File Name:   TestCalloutT24 
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
private class TestCalloutT24 {
    static testMethod void myUnitTest() {
        date avui = date.today();
        integer mesActual = avui.month();
        //Crear Centro
        Account centro1 = new Account();
        //centro1.RecordTypeId = '012b0000000QAeAAAW'; 
        centro1.RecordTypeId = getRecordTypeId('Centro');
        centro1.Name = 'Central1';
        centro1.Zona_Comercial__c = 'Barcelona';
        centro1.Fecha_apertura__c = date.newinstance(2010, 1, 1);
        centro1.Capacidad_Teorica__c = 50;
        centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.NIF_director_centro__c = '43539233A';
        centro1.Division__c = 'Teleasistencia';
        centro1.Phone = '933599023';
        centro1.Activo__c = true;
        centro1.Categoria__c = 'Exclusive';
        centro1.ATC_Centro__c = '005b0000001Lgzf';
        centro1.Division__c = 'Domiciliaria';
        //triggerHelper.recursiveHelper3(true);
        insert centro1;
        //triggerHelper.recursiveHelper3(false);
        
        
        
		NOC__c noc12 = new NOC__c();
        //noc12.RecordTypeId = '012b0000000QBd0';
        noc12.RecordTypeId = getRecordTypeId('NOC 12 Convenios');
        noc12.Name = 'noc11';
        noc12.Estado_Flujo__c = 'Aprobado';
        noc12.Fecha_inicio__c = Date.today().addDays(-30);
        noc12.Descuento_permanente__c = true;
        noc12.Tipo__c = 'General';
        noc12.Ratio_de_ocupacion_actual__c = 90;
        noc12.Residencial__c = true;
        //noc12.Duracion_del_descuento__c = 30;
        
       //triggerHelper.recursiveHelper3(true);           
        insert noc12;
        //triggerHelper.recursiveHelper3(false);
        
        NOC__c noc10 = new NOC__c();
        //noc10.RecordTypeId = '012b0000000QBcl';
        noc10.RecordTypeId = getRecordTypeId('NOC 10 Tarifas de clientes privados');
        noc10.Name = 'noc11';
        noc10.division__c = 'Teleasistencia';
        noc10.Ano_Tarifa__c = '2015';
        noc10.Estado_Flujo__c = 'Aprobado';
        noc10.Fecha_inicio__c = Date.today().addDays(-30);
        noc10.Fecha_fin__c = Date.today().addDays(5);
        noc10.Descuento_permanente__c = false;
        noc10.Duracion_del_descuento__c = 30;
       // triggerHelper.recursiveHelper3(true);           
        insert noc10;
        //triggerHelper.recursiveHelper3(false);
        
        RecordType rtCNoc1 = [SELECT Id,Name FROM RecordType WHERE Developername='Centros_Servicios_NOC_TA' LIMIT 1];
        
        //Creamos un centro NOC para la NOC 11
        
        Recordtype Rec_STA = [select id from recordtype where name = 'Servicios TA' LIMIT 1];                
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
        Recordtype RTTarTa = [select id,name from recordtype where name= 'Tarifas TAM'];
        Tarifa__c tTA = new Tarifa__c();
        tTa.RecordTypeId = RTTarTa.id;
        tTa.NOC__c = noc10.id;
        tTa.Servicio_TA__c = scTA.id;
        tTa.Central__c = centro1.id;
        tTa.Precio_servicio__c = 50;
        tTA.Tarifa_Vigente__c = true;
        //triggerHelper.recursiveHelper3(true);
        insert tTA;
        //triggerHelper.recursiveHelper3(false);
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
       // triggerHelper.recursiveHelper3(true);
        insert cNoc1;
       // triggerHelper.recursiveHelper3(false);
        
        
        //Crear Residente
        Account residente1 = new Account();
        residente1.RecordTypeId = '012b0000000QAe0AAG';
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
       // triggerHelper.recursiveHelper3(true);
        insert residente1;
       // triggerHelper.recursiveHelper3(false);
        
        //Crear Residente
        Account residente2 = new Account();
        //residente2.RecordTypeId = '012b0000000QAe0AAG';
        residente2.RecordTypeId = getRecordTypeId('Cliente/Familiar');
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
      //  triggerHelper.recursiveHelper3(true);
        insert residente2;
       // triggerHelper.recursiveHelper3(false);
        
        
        Account residente3 = new Account();
        //residente3.RecordTypeId = '012b0000000QAe0AAG';
        residente3.RecordTypeId = getRecordTypeId('Cliente/Familiar');
        residente3.FirstName = 'Nombre3';
        residente3.LastName = 'Apellido3';
        residente2.Residente__c = true;
        residente3.Perfil__c = 'Autónomo';
        residente3.Sexo__c = 'Hombre';
        residente3.Estado_Civil__c = 'Soltero/a';
        residente3.PersonBirthdate = date.newinstance(1940, mesActual, 2);
        residente3.Tipo_Documento_Identidad__c = 'DNI';
        residente3.CIF_NIF__c = '39463667Z';
        residente3.Tipo_Documento_Sanitario__c = 'NSS';
        residente3.Nuermo_Documento_Sanitario__c = '333';
        residente3.Idioma_de_Contacto__pc = 'Castellano';
        residente3.Phone = '660085345';
        residente3.Calle__c = 'Pablo Iglesias';
        residente3.Provincia__c = 'Barcelona';
        residente3.PersonEmail = 'xgg.1990@gmail.com';
        residente3.Pais__c = 'España';
        residente3.Ciudad__c = 'Barcelona';
        residente3.Codigo_postal__c = '08016';
        residente3.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
      //  triggerHelper.recursiveHelper3(true);
        insert residente3;
     //   triggerHelper.recursiveHelper3(false);
        
        Recordtype RTOpTA = [select id,name from recordtype where name= 'Oportunidad TAD'];
        
        
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
      //  triggerHelper.recursiveHelper3(true);                  
        insert op;
      //  triggerHelper.recursiveHelper3(true);
        
        Recordtype RTRelBen= [select id,name from recordtype where developername= 'Relacion_de_beneficiarios'];
        
        Relacion_entre_contactos__c rel2 = new Relacion_entre_contactos__c();
        rel2.RecordTypeId = RTRelBen.id;
        rel2.Beneficiario__c = residente1.Id;
        rel2.Oportunidad__c = op.Id;
        rel2.Usuario_principal__c = true;
        rel2.Activo__c = true;
        rel2.Pagador__c = true;
        rel2.Beneficiario_con_colgante__c = false;
      //  triggerHelper.recursiveHelper3(true);
        insert rel2;
      //  triggerHelper.recursiveHelper3(false);
        //update rel2;
        
        
        Relacion_entre_contactos__c rel3 = new Relacion_entre_contactos__c();
        rel3.RecordTypeId = RTRelBen.id;
        rel3.Beneficiario__c = residente2.Id;
        rel3.Oportunidad__c = op.Id;
        rel3.Usuario_principal__c = false;
        rel3.Activo__c = true;
        rel3.Pagador__c = false;
        rel3.Beneficiario_con_colgante__c = true;
      //  triggerHelper.recursiveHelper3(true);
        insert rel3;
      //  triggerHelper.recursiveHelper3(false);
        //update rel3;
        
         Relacion_entre_contactos__c rel4 = new Relacion_entre_contactos__c();
        rel4.RecordTypeId = RTRelBen.id;
        rel4.Beneficiario__c = residente3.Id;
        rel4.Oportunidad__c = op.Id;
        rel4.Usuario_principal__c = false;
        rel4.Activo__c = true;
        rel4.Pagador__c = false;
        rel4.Beneficiario_sin_colgante__c = true;
      //  triggerHelper.recursiveHelper3(true);
        insert rel4;
       // triggerHelper.recursiveHelper3(false);
        //update rel4;
        
        
        
        
        
        op.Servicio__c = scTA.id;
        op.Tarifa__c = tTA.id;
        op.NOC_12_Convenios__c = noc12.id;
        
        op.Etapa__c = 'Negociación';
        update op;
      //  TriggerHelperExecuteOnce.firstRun10 = true;
        op.Etapa__c = 'Cerrada ganada';
        op.Localidad_Entidad_Bancaria__c = 'Barcelona';
        op.IBAN__c = 'AL86751639367318444714198669';
        op.Nombre_Entidad_Bancaria__c = 'La caixa';
        op.Forma_de_pago_Dispositivo__c = 'Recibo domiciliado';
        op.Forma_de_pago_Servicio__c = 'Recibo domiciliado';
        //triggerHelper.setTodoFalse(); 
        //TriggerHelperExecuteOnce.firstRun2 = true;
        update op;   
        //CalloutT24WebService.modificacion_cuenta(residente1.id);
        
        
    }
    
    public static String getRecordTypeId(String name){
        List<RecordType> rt = [ Select id FROM RecordType WHERE Name =: name LIMIT 1 ];
        return (rt.size()> 0) ? rt.get(0).id : null;
    }
}