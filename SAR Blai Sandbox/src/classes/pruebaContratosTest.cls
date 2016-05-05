/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class pruebaContratosTest {
	
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        /*Account ac = new Account();
        Oportunidad_platform__c op = new Oportunidad_platform__c;
        op.RecordTypeId = '012b0000000QIDZAA4';*/

		//Crear Persona de contacto
        Account familiar1 = new Account();
        //familiar1.RecordTypeId = '012b0000000QAe0AAG'; // Cliente/Familiar
        familiar1.RecordTypeId = getRecordTypeId('Cliente/Familiar');
        familiar1.FirstName = 'Familiar1';
        familiar1.LastName = 'Familiar1';
        familiar1.Residente__c = false;
        familiar1.Perfil__c = 'Autónomo';
        familiar1.Sexo__c = 'Hombre';
        familiar1.Estado_Civil__c = 'Soltero/a';
        familiar1.PersonBirthdate = date.newinstance(1950, 7, 2);
        familiar1.Tipo_Documento_Identidad__c = 'DNI';
        familiar1.CIF_NIF__c = '61502084S';
        familiar1.PersonEmail = 'xgg.1990@gmail.com';
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
        
        
        //Crear Central
        Account centrorec = new Account();
        //centrorec.RecordTypeId = '012b0000000QAeAAAW'; // Centro
        centrorec.RecordTypeId = getRecordTypeId('Centro');
        centrorec.Name = 'MADRID_Prueba';
        centrorec.Division__c = 'Domiciliaria';
        centrorec.Activo__c = true;
        centrorec.Director_del_centro__c = '005b0000001JTCKAA4';   
        centrorec.NIF_director_centro__c = '43539233A';
        centrorec.Ciudad__c = 'Madrid';
        centrorec.Pais__c = 'España';
        centrorec.Fecha_apertura__c = date.newinstance(2016, 5, 8);
        centrorec.Capacidad_Teorica__c = 2222222;
        triggerHelper.recursiveHelper1(true);        
        insert centrorec;
        triggerHelper.recursiveHelper1(false);
        
        
        //Crear Centro
        /*Account centro1 = new Account();
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
        triggerHelper.recursiveHelper1(false);*/
        
       
        //--------------------------------------------------------------------
        //Crear Centro
        Account centro1 = new Account();
        //centro1.RecordTypeId = '012b0000000QAeAAAW'; 
        centro1.RecordTypeId = getRecordTypeId('Centro');
        centro1.Name = 'Centro1';
        centro1.Zona_Comercial__c = 'Barcelona';
        centro1.Fecha_apertura__c = date.newinstance(2015, 5, 8);
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
        
        //Crear Pagador
        Account residente1 = new Account();
        //residente1.RecordTypeId = '012b0000000QAe0AAG';
        residente1.RecordTypeId = getRecordTypeId('Cliente/Familiar');
        residente1.FirstName = 'Nombre1';
        residente1.LastName = 'Apellido1';
        residente1.Residente__c = true;
        residente1.Perfil__c = 'Autónomo';
        residente1.Sexo__c = 'Hombre';
        residente1.Estado_Civil__c = 'Soltero/a';
        residente1.PersonBirthdate = date.newinstance(1940, 7, 2);
        residente1.Tipo_Documento_Identidad__c = 'DNI';
        residente1.CIF_NIF__c = '16289994Z';
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
       // residente1.IdNAV_RES__c = 'TRES55560';
        /*residente1.Historia_de_vida_adjunta__c = false;
        residente1.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';*/
        triggerHelper.recursiveHelper1(true);
        insert residente1;
        triggerHelper.recursiveHelper1(false);
                
         //Crear Oportunidad
        Oportunidad_platform__c op = new Oportunidad_platform__c();
        //op.RecordTypeId = '012b0000000QIDZAA4'; //Oportunidad TAD
        op.RecordTypeId = getRecordTypeId('Oportunidad TAD');
        op.Etapa__c = 'Abierta';
        op.Residente__c = residente1.id;
        op.Persona_de_Contacto__c = familiar1.id;
        op.Central__c = centrorec.id;
        op.Canal__c = 'Chat';
        op.Centro2__c = centro1.Id;
        op.Procedencia__c = 'Clientes';
        triggerHelper.recursiveHelper1(true);        
        insert op;
        triggerHelper.recursiveHelper1(false);
        
        
        
        //Crear Relacion entre contactos
        Relacion_entre_contactos__c rel1 = new Relacion_entre_contactos__c();
        //rel1.RecordTypeId = (!Test.isRunningTest()) ? '012b0000000QIjXAAW' : '012110000000hjIAAQ';   // en test es = 012110000000hjIAAQ
        rel1.RecordTypeId = getRecordTypeId('Relacion de beneficiarios');
        rel1.Oportunidad__c = op.id;
        rel1.Beneficiario__c = residente1.Id;
        rel1.Pagador__c = true;
        rel1.Activo__c = true;
        triggerHelper.recursiveHelper1(true);
        insert rel1;
        triggerHelper.recursiveHelper1(false);
        
        //Crear Usuario Principal
        Account familiar2 = new Account();
        //familiar2.RecordTypeId = '012b0000000QAe0AAG'; 
        familiar2.RecordTypeId = getRecordTypeId('Cliente/Familiar');
        familiar2.FirstName = 'Familiar2';
        familiar2.LastName = 'Familiar2';
        familiar2.Residente__c = false;
        familiar2.Perfil__c = 'Autónomo';
        familiar2.Sexo__c = 'Hombre';
        familiar2.Estado_Civil__c = 'Soltero/a';
        familiar2.PersonBirthdate = date.newinstance(1950, 7, 2);
        familiar2.Tipo_Documento_Identidad__c = 'DNI';
        familiar2.CIF_NIF__c = '99448956S';
        familiar2.PersonEmail = 'xgg.1990@gmail.com';
        familiar2.Tipo_Documento_Sanitario__c = 'NSS';
        familiar2.Nuermo_Documento_Sanitario__c = '11111';
        familiar2.Idioma_de_Contacto__pc = 'Catalán';
        familiar2.Phone = '660085345';
        
        familiar2.Calle__c = 'Pablo Iglesias';
        familiar2.Provincia__c = 'Barcelona';
        familiar2.Pais__c = 'España';
        familiar2.Ciudad__c = 'Barcelona';
        familiar2.Codigo_postal__c = '08016';
        //familiar2.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        triggerHelper.recursiveHelper1(true);
        insert familiar2;
        triggerHelper.recursiveHelper1(false);
        
        //Crear Relacion entre contactos
        Relacion_entre_contactos__c rel2 = new Relacion_entre_contactos__c();
        //rel2.RecordTypeId = (!Test.isRunningTest()) ? '012b0000000QIjXAAW' : '012110000000hjIAAQ';   // en test es = 012110000000hjIAAQ
        rel2.RecordTypeId = getRecordTypeId('Relación Familiar');
        rel2.Oportunidad__c = op.id;
        rel2.Beneficiario__c = familiar2.id;
        rel2.Usuario_principal__c = true;
        rel2.Activo__c = true;
        triggerHelper.recursiveHelper1(true);
        insert rel2;
        triggerHelper.recursiveHelper1(false);
        
         //Crear Usuario con colgante
        Account familiar3 = new Account();
        //familiar3.RecordTypeId = '012b0000000QAe0AAG';
        familiar3.RecordTypeId = getRecordTypeId('Cliente/Familiar');
        familiar3.FirstName = 'Familiar3';
        familiar3.LastName = 'Familiar3';
        familiar3.Residente__c = false;
        familiar3.Perfil__c = 'Autónomo';
        familiar3.Sexo__c = 'Hombre';
        familiar3.Estado_Civil__c = 'Soltero/a';
        familiar3.PersonBirthdate = date.newinstance(1950, 7, 2);
        familiar3.Tipo_Documento_Identidad__c = 'DNI';
        familiar3.CIF_NIF__c = '45283272K';
        familiar3.PersonEmail = 'xgg.1990@gmail.com';
        familiar3.Tipo_Documento_Sanitario__c = 'NSS';
        familiar3.Nuermo_Documento_Sanitario__c = '11111';
        familiar3.Idioma_de_Contacto__pc = 'Euskera';
        familiar3.Phone = '660085345';
        familiar3.Calle__c = 'Pablo Iglesias';
        familiar3.Provincia__c = 'Barcelona';
        familiar3.Pais__c = 'España';
        familiar3.Ciudad__c = 'Barcelona';
        familiar3.Codigo_postal__c = '08016';
        //familiar3.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        triggerHelper.recursiveHelper1(true);
        insert familiar3;
        triggerHelper.recursiveHelper1(false);
        
        //Crear Relacion entre contactos
        Relacion_entre_contactos__c rel3 = new Relacion_entre_contactos__c();
        rel3.Oportunidad__c = op.id;
        //rel3.RecordTypeId = (!Test.isRunningTest()) ? '012b0000000QIjXAAW' : '012110000000hjIAAQ';   // en test es = 012110000000hjIAAQ
        rel3.RecordTypeId = getRecordTypeId('Relacion de beneficiarios');
        rel3.Beneficiario__c = familiar3.id;
        rel3.Beneficiario_con_colgante__c = true;
        rel3.Activo__c = true;
        triggerHelper.recursiveHelper1(true);
        insert rel3;
        triggerHelper.recursiveHelper1(false);
        
        //Crear Usuario sin colgante
        /*Account familiar4 = new Account();
        familiar4.RecordTypeId = '012b0000000QAe0AAG';
        familiar4.FirstName = 'Familiar4';
        familiar4.LastName = 'Familiar4';
        familiar4.Residente__c = false;
        familiar4.Perfil__c = 'Autónomo';
        familiar4.Sexo__c = 'Hombre';
        familiar4.Estado_Civil__c = 'Soltero/a';
        familiar4.PersonBirthdate = date.newinstance(1950, 7, 2);
        familiar4.Tipo_Documento_Identidad__c = 'DNI';
        familiar4.CIF_NIF__c = '90520563Z';
        familiar4.PersonEmail = 'xgg.1990@gmail.com';
        familiar4.Tipo_Documento_Sanitario__c = 'NSS';
        familiar4.Nuermo_Documento_Sanitario__c = '11111';
        familiar4.Idioma_de_Contacto__pc = 'Euskera';
        familiar4.Phone = '660085345';
        familiar4.Calle__c = 'Pablo Iglesias';
        familiar4.Provincia__c = 'Barcelona';
        familiar4.Pais__c = 'España';
        familiar4.Ciudad__c = 'Barcelona';
        familiar4.Codigo_postal__c = '08016';
        //familiar4.Preferencia_de_envio_de_factura__c = 'Recogida en el centro';
        triggerHelper.recursiveHelper1(true);
        insert familiar4;
        triggerHelper.recursiveHelper1(false);
       
       //Crear Relacion entre contactos
        Relacion_entre_contactos__c rel4 = new Relacion_entre_contactos__c();
        rel4.Oportunidad__c = op.id;
        rel4.RecordTypeId = '012b0000000QIjXAAW';  //en test es 012110000000hjIAAQ
        rel4.Beneficiario__c = familiar4.id;
        rel4.Beneficiario_sin_colgante__c = true;
        rel4.Activo__c = true;
        triggerHelper.recursiveHelper1(true);
        insert rel4;
        triggerHelper.recursiveHelper1(false);*/
        
        
        
        //Creamos un servicio
        Servicio__c sc = new Servicio__c();
        //sc.RecordTypeId = '012b0000000QIES'; //Servicios Residenciales
        sc.RecordTypeId = getRecordTypeId('Servicios Residenciales');
        sc.Name = 'Hogar+Contigo';
        //sc.Tipo_Servicio__c = 'Residencial';
        sc.Tipo_de_servicio_TA__c = 'Agenda';
        //sc.Tipo_Estancia__c = 'Temporal';
        //sc.Tipo_Ocupacion__c = 'HD';
        sc.Tipo_de_dispositivos__c = 'GT300';
        sc.Activo__c = true;
        //sc.Grado_Dependencia__c = 'Grado1';
        triggerHelper.recursiveHelper1(true);
        insert sc;
        triggerHelper.recursiveHelper1(false); 
        
        //Creamos NOC 10
        NOC__c noc10 = new NOC__c();
        //noc10.RecordTypeId = '012b0000000QBclAAG'; 
        noc10.RecordTypeId = getRecordTypeId('NOC 10 Tarifas de clientes privados');
        noc10.Name = 'NOC 10';
        noc10.Division__c = 'Teleasistencia';
        noc10.Ano_Tarifa__c = '2015';
        noc10.Estado_Flujo__c = 'Aprobado';
        noc10.Tipo_de_tarifa_autorizada__c = 'Tarifas anuales';
        noc10.Incremento_medio_para_clientes_actuales__c = 0.01;
        noc10.Incremento_medio_para_nuevos_clientes__c = 0.01;
        noc10.Fecha_Inicio__c = date.newinstance(2016, 5, 20);
        noc10.Fecha_fin__c = date.newinstance(2025, 6, 20);
        
        //Creamos una tarifa
        Tarifa__c tr = new Tarifa__c();
        //tr.RecordTypeId = (!Test.isRunningTest()) ? '012b0000000QIjXAAW' : '012110000000hjIAAQ';   // en test es = 012110000000hjIAAQ
        tr.RecordTypeId = getRecordTypeId('Tarifas Centro');
        tr.Name = 'Tarifa Prueba';
        tr.Central__c = centrorec.id;
        tr.Servicio__c = sc.id;
        tr.NOC__c = noc10.id;
        tr.Tarifa_Vigente__c = true;
        tr.Precio_servicio__c = 33;
        tr.Precio_dispositivo__c = 40;
        triggerHelper.recursiveHelper1(true);
        insert tr;
        triggerHelper.recursiveHelper1(false);
        
        //Cramos Entidad Recomendadora
        Account entidad = new Account();
        //entidad.RecordTypeId = '012b0000000QAd7AAG';
        entidad.RecordTypeId = getRecordTypeId('Entidad Recomendadora');
        entidad.Name = 'Entidad Recomendadora prueba';
        entidad.Sede_o_Delegaci_n__c = 'Sede Central';
        entidad.Type = 'Colectivo';
        entidad.Clasificacion__c = 'Agencias Públicas, Empresas Públicas, Institutos Públicos';
        entidad.Phone = '31854011813';
        entidad.Calle__c = 'Cervantes';
        entidad.Ciudad__c = 'Albacete';
        entidad.Codigo_postal__c = '08292';
        entidad.Provincia__c = 'Albacete';
        entidad.Pais__c = 'España';
        entidad.Clasificacion_tipo_recomendador__c = 'B';
        entidad.Residencial__c = true;
        entidad.logo__c = 'https://sarquavitae--test--c.cs18.content.force.com/servlet/servlet.ImageServer?id=01511000000afpI&oid=00D1100000C0aak&lastMod=1437377012000';
        triggerHelper.recursiveHelper1(true);
        insert entidad;
        triggerHelper.recursiveHelper1(false);
        
        
        //Creamos NOC
        NOC__c noc = new NOC__c();
        //noc.RecordTypeId = '012b0000000QBd0AAG';
        noc.RecordTypeId = getRecordTypeId('NOC 12 Convenios');
        noc.Name = 'prova_NOC12';
        noc.Descripcion__c = 'Prueba de la NOC 12';
        noc.Tipo__c = 'Acuerdo comercial';
        noc.Recomendador__c = entidad.id;
        noc.Fecha_inicio__c = date.newinstance(2016, 6, 23);
        noc.Fecha_fin__c = date.newinstance(2025, 8, 7);
        noc.Estado_Flujo__c = 'Aprobado';
        noc.Residencial__c = true;
        noc.Anexo__c = true;
        noc.Descuento_permanente__c = true;
        triggerHelper.recursiveHelper1(true);
        insert noc;
        triggerHelper.recursiveHelper1(false);
        
        //Creamos centro NOC
        Centros_NOC__c centroNOC = new Centros_NOC__c();
        //centroNOC.RecordTypeId = '012110000000hj3AAA';
        centroNOC.RecordTypeId = getRecordTypeId('Centros/Servicios NOC TA');
        centroNOC.NOC_TAD__c = noc.id;
        centroNOC.Central__c = centrorec.id;
        centroNOC.Servicio_TA__c = sc.id;
        centroNOC.Importe_Periodo_1__c = 20;
        centroNOC.Duracion_Periodo_1__c = 4;
        centroNOC.Importe_Periodo_2__c = 30;
        centroNOC.Duracion_Periodo_3__c = 20;
        centroNOC.Duracion_Periodo_3__c = 6;
        centroNOC.Precio__c = 10;
        
        /*
        ApexPages.StandardController controller2 = new ApexPages.StandardController(op);
        pruebaContratos prCo2 = new pruebaContratos(controller2);
        
        //actualizamos oportunidad        
        //op.Residente__c = residente1.Id;
        //op.Persona_de_Contacto__c = residente1.Id;
        //op.Pagador__c = residente1.Id;
        //op.Etapa__c = 'Preingreso';
        //op.Centro2__c = centro1.Id;
        //op.Canal__c = 'Llamada al Cat';
        //op.Procedencia__c = 'Vecindad';
        op.Servicio__c = sc.id;
        op.Tarifa__c = tr.id;
        //op.NOC_12_Convenios__c = 'a041100000B5VYaAAN';
        //op.Tipo_de_tarifa__c = 'Diaria';
        //op.Tipo_de_pago__c = 'gratis';
        op.Nombre_Entidad_Bancaria__c = 'BANCO POPULAR';
        op.Localidad_Entidad_Bancaria__c = 'Santander';
        op.IBAN__c = 'ES9121000418450200051332';
        op.NOC_12_Convenios__c = noc.id;
        //op.Regimen__c = 'UED';
        //op.RecordTypeId = '012b0000000QBG1';
        //op.Tipo_de_Financiacion__c = 'Privado';
        //op.Fecha_prevista_de_ingreso__c = Date.today();
        //op.Fecha_finalizacion__c = System.today().addDays(15);
        op.Fecha_cierre__c = date.newinstance(2015, 7, 21);
        op.Etapa__c = 'Cerrada perdida';
        //op.Visita_realizada_en__c = 'Centro';
        //op.Motivio_de_Alta_GCR__c = 'aaa';
        //op.Tipo_de_pago__c = 'Gratis';
        //op.Precio_Cuota_Mensual__c = 34;
        op.Precio_Colgantes__c = 14;
        op.Forma_de_pago_Dispositivo__c = 'Fraccionado';
        op.Motivo_Cerrada_perdida__c = 'motivo...';
        //op.Visita_realizada_en__c = 'Centro';
        //op.Institucion__c = centrorec.Id;  
        triggerHelper.recursiveHelper1(true);
        update op;
        																																																																																																																																											   							
        ApexPages.StandardController controller = new ApexPages.StandardController(op);
        
        //pruebaContratos prCo = new pruebaContratos(controller);
        
        
        
        /*
        //op.Etapa__c = 'PreIngreso';
        op.Servicio__c = null;
        op.Tarifa__c = null;
        op.NOC_12_Convenios__c = null;
        triggerHelper.recursiveHelper1(true);        
        //update op;
        triggerHelper.recursiveHelper1(false);
        
        ApexPages.StandardController controller2 = new ApexPages.StandardController(op);
        pruebaContratos prCo2 = new pruebaContratos(controller2);*/
        
    }
    
    public static String getRecordTypeId(String name){
        List<RecordType> rt = [ Select id FROM RecordType WHERE Name =: name LIMIT 1 ];
        return (rt.size()> 0) ? rt.get(0).id : null;
    }    
}