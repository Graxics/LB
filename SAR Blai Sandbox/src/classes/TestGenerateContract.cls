/** 
* File Name:   TestGenerateContract 
* Description: Test del controlador GenerateContract
* Copyright:   Konozca 
* @author:     Hector Mañosas
* Modification Log 
* =============================================================== 
*Date     		Author          Modification 
* 11/10/2014 	HManosas		
* =============================================================== 
**/

@isTest
private class TestGenerateContract {

    static testMethod void myUnitTest() {
    	
    	//Configuracion Personalizada
    	Condiciones_Contratos__c cc = new Condiciones_Contratos__c();
    	cc.Name = 'Can Buxeres Resi Privado CAST';
    	cc.Tipo_Servicio__c = 'Residencial';
    	cc.Idioma__c = 'Castellano';
    	cc.Titulo__c = 'Protocolo de Gestión Asistencial';
    	cc.Revision__c = 'Diciembre 2013';
    	cc.Protocolo__c = 'Protocolo de Acogida';
    	cc.Num_Contrato__c = '17';
    	cc.Centro__c = 'Can Buxeres';
    	cc.Tipo_de_Financiacion__c = 'Privado';
    	cc.Codigo__c = 'PR02-P03-R02.CAT-1';
    	cc.Aplica__c = 'Centros Residenciales SARquavitae (Cataluña)';
    	cc.Registro__c = 'Contrato asistencial de estancia y atención gerontológica en residencia para personas mayores (privados)';
    	insert cc;
        
        //Creamos una Account de tipo Centro
        Account centro1 = new Account();
        centro1.Name = 'Can Buxeres';
        centro1.RecordTypeId = '012b0000000QAeAAAW';        
        centro1.Phone = '442342343244';
        centro1.Activo__c = true;
        centro1.Director_del_centro__c = '005b0000000kj7HAAQ';
        centro1.Division__c = 'Residencial';
        centro1.Categoria__c = 'Exclusive';
        centro1.IdNAV__c = 'CANBUXERES';
        centro1.Zona_Comercial_del__c = 'Barcelona';
        centro1.IdNAV__c = 'CANBUXERES';
        triggerHelper.recursiveHelper3(true);
        insert centro1;
        triggerHelper.recursiveHelper3(false);
        
        //Account Cliente (Residente)  
        Account a1 = new Account();
        a1.FirstName = 'FName';
        a1.PersonEmail = 'test@test.com';
        a1.LastName = 'cliente1 apell';
        a1.Apellido_2__c = 'apell';
        a1.Perfil__c = 'Autónomo';
        a1.Idioma_de_Contacto__pc = 'Castellano';
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
        a1.Codigo_postal__c  = '08036';
        triggerHelper.recursiveHelper3(true);
        insert a1;
        triggerHelper.recursiveHelper3(false);
        
        //Account Cliente (Persona Contacto)
        Account a2 = new Account();
        a2.FirstName = 'NombreContacto';
        a2.LastName = 'ApellidoContacto';
        a2.PersonEmail = 'test@test.com';
        a2.Perfil__c = 'Autónomo';
        a2.Apellido_2__c = 'apellido';
        a2.Idioma_de_Contacto__pc = 'Castellano';
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
        triggerHelper.recursiveHelper3(true);
        insert a2;
        triggerHelper.recursiveHelper3(false);
        
        //Establecemos una relacion familiar entre los dos Clientes
        Relacion_entre_contactos__c rc = new Relacion_entre_contactos__c();
        rc.RecordTypeId = '012b0000000QCbyAAG';
        rc.Residente__c = a1.Id;
        rc.Contacto__c = a2.Id;
        rc.Familiar_de_referencia__c = true;
        rc.Relacion_personal__c = 'Amigo/a';
        triggerHelper.recursiveHelper3(true);
        insert rc;
        triggerHelper.recursiveHelper3(false);
        
        //Creamos un servicio
        Servicio__c sc = new Servicio__c();
        sc.Name = 'RESI_EP_ G3_HD_ST';
        sc.Tipo_Servicio__c = 'Residencial';
        sc.Tipo_Estancia__c = 'Permanente';
        sc.Tipo_Ocupacion__c = 'HD';
        sc.Grado_Dependencia__c = 'Grado3';
        sc.Transporte__c = 'No';
        triggerHelper.recursiveHelper3(true);
        insert sc;
        triggerHelper.recursiveHelper3(false);
        
        //Creamos una oportunidad
        Oportunidad_platform__c op = new Oportunidad_platform__c();
        op.Etapa__c = 'Pendiente Visita';
        op.Canal__c = 'Llamada al CAT';
        op.Procedencia__c = 'Vecindad';       
        op.Tipo_de_Financiacion__c = 'Privado';
        op.Persona_de_Contacto__c = a2.Id;
        op.Residente__c = a1.Id;
        op.Pagador__c = a1.Id;
        op.Centro2__c = centro1.Id;
        op.Servicio__c = sc.Id;
        triggerHelper.recursiveHelper3(true);
        insert op;
        triggerHelper.recursiveHelper3(false);
        
        ApexPages.StandardController stanc = new ApexPages.StandardController(op);
        GenerateContract gc = new GenerateContract(stanc);
        gc.getCodigo();
        gc.getCentro();
        gc.getRevision();
        gc.getPagina();
        gc.getDe();
        gc.getTitulo();
        gc.getProtocolo();
        gc.getProtocoloDetail();
        gc.getRegistro();
        gc.getDetailRegistro();
        gc.getAplicaA();
        gc.getDetailAplica();
        
        centro1.Director_del_centro__c = null;
        triggerHelper.recursiveHelper3(true);
        update centro1;
        triggerHelper.recursiveHelper3(false);
        
        op.Persona_de_referencia__c = false;
        op.Fecha_prevista_de_ingreso__c = System.today();
        op.Fecha_finalizacion__c = System.today().addDays(10);
        op.Persona_de_Contacto__c = null;               
        op.Representate_legagal__c = true;
        op.Nombre_representante_legal__c = 'Nombre';
        op.Apellido_representante_legal__c = 'Apellido';
        op.DNI_representante_legal__c = '123456789';
        op.Calle_representate_legal__c = 'Calle';
        op.Ciudad_representante_legal__c = 'Barcelona';
        op.Telefono_representante_legal__c = '666666666';        
        triggerHelper.recursiveHelper3(true);
        update op;
        triggerHelper.recursiveHelper3(false);
        
        ApexPages.StandardController stanc2 = new ApexPages.StandardController(op);
        GenerateContract gc2 = new GenerateContract(stanc2);
        
    }
}