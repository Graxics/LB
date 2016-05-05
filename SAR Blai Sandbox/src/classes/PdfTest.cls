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
 * methods. Classes defined with the @isTest annotation do not couzonant against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class PdfTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Account a1 = new Account();
        a1.FirstName = '1';
        a1.LastName = 'cliente1';
        a1.Perfil__c = 'Autónomo';
        a1.Idioma_de_Contacto__pc = 'Catalán';
        a1.personeMail = 'test@test.com';
        a1.Residente__c = true;
        a1.Phone = '523423423455';
        a1.RecordTypeId = '012b0000000QAe0AAG';
        a1.Tipo_Documento_Sanitario__c = 'NCS';
        a1.Nuermo_Documento_Sanitario__c = '111';
        a1.Estado_Civil__c = 'Casado/a';
        a1.Sexo__c = 'Hombre';
        a1.Tipo_Documento_Identidad__c = 'DNI';
        a1.CIF_NIF__c = '31884155Z';
        a1.Calle__c = 'Carrer de buenos aires 34';
        a1.Ciudad__c = 'Barcelona';
        a1.PersonBirthdate = Date.today();
        a1.Codigo_postal__c  = '08036';
        triggerHelper.recursiveHelper2(true);
        insert a1;
        triggerHelper.recursiveHelper2(false);
        
        Account a2 = new Account();
        a2.FirstName = '2';
        a2.LastName = 'cliente2';
        a2.Perfil__c = 'Autónomo';
        a2.PersonEmail = 'test@tes.com';
        a2.Idioma_de_Contacto__pc = 'Catalan';
        a2.Residente__c = true;
        a2.RecordTypeId = '012b0000000QAe0AAG';
        a2.Tipo_Documento_Sanitario__c = 'NCS';
        a2.Nuermo_Documento_Sanitario__c = '222';
        a2.Estado_Civil__c = 'Casado/a';
        a2.Sexo__c = 'Hombre';
        a2.Phone = '5552342343245';
        a2.Calle__c = 'Gran Via 24';
        a2.Ciudad__c = 'Madrid';
        a2.PersonBirthdate = Date.today();
        a2.Codigo_postal__c  = '28013';
        triggerHelper.recursiveHelper2(true);
        insert a2;
        triggerHelper.recursiveHelper2(false);
        
        Account sociedad = new Account();
        sociedad.name='sociedad';
        sociedad.RecordTypeId = '012b0000000QAe5';
        insert sociedad;    
        
        Account centro1 = new Account();
        centro1.Name = 'Centro1';
        centro1.RecordTypeId = '012b0000000QAeAAAW';
        centro1.Zona_comercial__c = 'Centro';
        centro1.Division__c = 'Residencial';
        centro1.Phone = '442342343244';
        centro1.Activo__c = true;
        centro1.Director_del_centro__c = '005b0000001JTCKAA4';
        centro1.Responsable_PlanPersonal__c='Director/a SARquavitae';
        centro1.Sociedad__c=sociedad.id;
        triggerHelper.recursiveHelper2(true);
        insert centro1;
        triggerHelper.recursiveHelper2(false);
        
        Account centro2 = new Account();
        centro2.Name = 'Centro2';
        centro2.RecordTypeId = '012b0000000QAd7AAG';
        centro2.Sede_o_Delegaci_n__c = 'Sede';
        centro2.Tipo_analisis__c = 'Prescriptor';
        centro2.Clasificacion__c = 'Asociaciones';
        centro2.Clasificacion_tipo_recomendador__c = 'A';
        centro2.Residencial__c = true;
        centro2.Phone = '666666666';
        centro2.Calle__c = 'Calle1';
        centro2.Ciudad__c = 'Ciudad1';
        centro2.Codigo_postal__c = '08620';
        centro2.Provincia__c = 'Barcelona';
        centro2.Zona_Comercial_del__c = 'Barcelona';
        centro2.Zona_Comercial__c = 'Este';
        centro2.Responsable_PlanPersonal__c='Director/a SARquavitae';
        triggerHelper.recursiveHelper2(true);
        insert centro2;
        triggerHelper.recursiveHelper2(false);
        
        Servicio__c sc = new Servicio__c();
        sc.Name = 'serv';
        sc.Tipo_Servicio__c = 'Residencial';
        sc.Tipo_Estancia__c = 'Permanente';
        sc.Tipo_Ocupacion__c = 'HI';
        sc.Grado_Dependencia__c = 'Grado3';
        triggerHelper.recursiveHelper2(true);
        insert sc;
        triggerHelper.recursiveHelper2(false);
        
        NOC__c noc2 = new NOC__c();
        noc2.RecordTypeId = '012b0000000QBclAAG';
        noc2.Estado_Flujo__c = 'Aprobado';
        noc2.Fecha_inicio__c = Date.today().addDays(-30);
        noc2.Fecha_fin__c = Date.today().addDays(30);
        noc2.Name = 'noc2';
        noc2.Descuento_aplicado__c = 10.00;
        noc2.Id_contrato__c='CTR00001'; //formato [C]{1}[T]{1}[R]{1}[0-9]{5}
        triggerHelper.recursiveHelper2(true);
        insert noc2;
        
        
        NOC__c noc3 = new NOC__c();
        noc3.RecordTypeId = '012b0000000QBclAAG';
        noc3.Estado_Flujo__c = 'Aprobado';
        noc3.Fecha_inicio__c = Date.today().addDays(-30);
        noc3.Fecha_fin__c = Date.today().addDays(30);
        noc3.Name = 'noc2';
        noc3.Descuento_aplicado__c = 10.00;
        noc3.Tipo_de_tarifa_autorizada__c = 'Tarifa Test';
        noc3.Id_contrato__c='CTR00001'; //formato [C]{1}[T]{1}[R]{1}[0-9]{5}
        triggerHelper.recursiveHelper2(true);
        insert noc3;        
        
        
        triggerHelper.recursiveHelper2(false);
        
        Tarifa__c t1 = new Tarifa__c();
        t1.Name = 't1';
        t1.Servicio__c = sc.Id;
        t1.Centro__c = centro1.Id;
        t1.Tipo_Tarifa__c = 'Diaria';
        t1.Precio__c = 10.00;
        t1.Precio__c = 0.00;
        t1.NOC__c = noc2.Id;
        triggerHelper.recursiveHelper2(true);
        insert t1;
        triggerHelper.recursiveHelper2(false);
        
        Oportunidad_platform__c op = new Oportunidad_platform__c();
        op.ambito__c = 'Residencial';
        op.Pagador__c = a2.Id;
        op.Residente__c = a1.Id;
        op.Etapa__c = 'Visita Planificada / Espontánea';
        op.Centro2__c = centro1.Id;
        op.Canal__c = 'Llamada al Cat';
        op.Procedencia__c = 'Vecindad';
        op.Tipo_de_tarifa__c = 'Diaria';
        op.Tipo_de_pago__c = 'gratis';
        op.Regimen__c = 'UED';
        op.RecordTypeId = '012b0000000QBG6AAO';
        op.Tipo_de_Financiacion__c = 'Privado';
        op.Fecha_prevista_de_ingreso__c = Date.today();
        op.Servicio__c = sc.Id;
        op.Tarifa__c = t1.Id;
        op.Visita_realizada_en__c = 'Centro';
        op.No_se_solicita_descuento__c=true;


        
        triggerHelper.recursiveHelper2(true);        
        insert op;
        triggerHelper.recursiveHelper2(false);
        
        ApexPages.StandardController stanc = new ApexPages.StandardController(op);
        GenerateOpportunity go = new GenerateOpportunity(stanc);
        
        
        PageReference pageRef = Page.PlanPersonalResiPDF;
        ApexPages.currentPage().getParameters().put('id', String.ValueOf(op.id));
        test.setCurrentpage(pageRef);
        PlanPersonalController  plan = new  PlanPersonalController(stanc);
        plan.load();
        plan.getIdioma();
        plan.getHTML_Saludo();
        plan.getLit_TarifaServicio();
        plan.getLit_ImporteFinal();
        plan.getPromocion();
        plan.getFormato_Plan_Personalizado();
        plan.getEsResi();
        plan.getEsDia();
        plan.getCentro_name();
        plan.getlit_GradoDependencia();
        plan.getImporteFianza();
        plan.getLIT_SERVICIOS_ASISTENCIALES();
        plan.getLIT_SERVICIOS_DE_BIEN_ESTAR();
        plan.getLIT_SERVICIOS_DE_ATENCION();
        plan.getLIT_TARIFAS_ESPECIALES();
        plan.getLIT_CONDICIONES_ECONOMICAS();
        plan.getLIT_CONDICIONES_DE_INGRESO();
        plan.getHTML_FIANZA();
        plan.getHTML_FIANZA_IMPORTE();
        plan.getLIT_SERVICIOS_INCLUIDOS();
        plan.getHTML_SERVICIOS1();
        plan.getHTML_SERVICIOS2();        
        
    //nos guardamos en el map la info asociada
        
        Recordtype RtypeTareaRecomendador = [Select Id, Name From RecordType Where Name = 'Tarea Recomendador' LIMIT 1];
   		Recordtype RtypeTareaCatOtros = [Select Id, Name From RecordType Where DeveloperName = 'Tarea_CAT_Otros' LIMIT 1];
    	RecordType RtypeTareaCatInformacion = [Select Id, Name From RecordType Where Name = 'CAT - Información'];
    	RecordType RtypeTareaTareaPersonal = [Select Id, Name From RecordType Where Name = 'Tarea Personal'];
		List<Account> comodinAux = [Select id,name from Account where name = 'Cliente Comodín' and recordtypeid = '012b0000000QAe0'];
        
        Task t2 = new Task(RecordTypeId = RtypeTareaRecomendador.id);
        insert t2;
        Task t4 = new Task(RecordTypeId = RtypeTareaCatOtros.id);
        insert t4;           
        Task t5 = new Task(RecordTypeId = RtypeTareaTareaPersonal.id);
        insert t5;        
    }
}