//clase encargada de realizar la conexión con GCR
public class GCRCalloutClass {
	
	@future (callout=true)
	public static void modifyResident(Id resi) {
		try {
			triggerhelper.recursiveHelper1(true);
		
			Account r = [Select Id, FirstName, PersonMobilePhone,No_tiene_correo_electronico__c, No_tiene_telefono__c, Pais__c, Provincia__c, Estado_Civil__c, LastName, Phone, Calle__c, IdNAV_RES__c, Tipo_Documento_Identidad__c, Tipo_Documento_Sanitario__c, CIF_NIF__c,Ciudad__c, Codigo_postal__c, PersonBirthdate, PersonEmail, Nuermo_Documento_Sanitario__c, Sexo__c, IdGCR__c From Account Where Id = :resi];
			
			if(r.Calle__c == null) r.Calle__c = ' ';
			if(r.Ciudad__c == null) r.Ciudad__c = ' ';
			if(r.Pais__c == null) r.Pais__c = ' ';
			if(r.Provincia__c == null) r.Provincia__c = ' ';
			if(r.Codigo_postal__c == null) r.Codigo_postal__c = '  ';
			//if(r.Phone == null) r.Phone = ' ';
			//if(r.PersonMobilePhone == null) r.PersonMobilePhone = ' ';
			//if(r.PersonEmail == null) r.PersonEmail = ' ';
			
			InterfacaIGCR.ResidenteGCR GCRres = new InterfacaIGCR.ResidenteGCR();
			
			GCRres.TipoAccion = (r.IdGCR__c == NULL)?1:2;
			GCRres.IdNAV_RES = r.IdNAV_RES__c;
			GCRres.FirstName = r.FirstName;
			String[] surnames = triggerHelper.sepLastName(r.LastName);
			GCRres.LastName1 = surnames[0];
			GCRres.LastName2 = surnames[1];
			GCRres.Tipo_Documento_Identidad = r.Tipo_Documento_Identidad__c;
			GCRres.Numero_Documento_Identidad = r.CIF_NIF__c;
			GCRres.Tipo_Documento_Sanitario = r.Tipo_Documento_Sanitario__c;
			GCRres.Numero_Documento_Sanitario = r.Nuermo_Documento_Sanitario__c;
			GCRres.Estado_Civil = r.Estado_Civil__c;
			GCRres.Sexo = r.Sexo__c;
			GCRres.Fecha_Nacimiento = r.PersonBirthdate;
			GCRres.Phone = r.Phone;
			GCRres.PersonMobilePhone = r.PersonMobilePhone;
			GCRres.PersonEmail = r.PersonEmail;
			GCRres.Calle = r.Calle__c;
			GCRres.Ciudad = r.Ciudad__c;
			GCRres.Provincia = r.Provincia__c;
			GCRres.CodigoPostal = r.Codigo_postal__c;
			GCRres.Pais = r.Pais__c;
			//comprobamos si tiene telefono o mail
			if((r.Phone == null || r.Phone == ' ') && (r.PersonMobilePhone == null || r.PersonMobilePhone == ' ')) {
				GCRres.NoTieneTelefono = true;
			}
			else GCRres.NoTieneTelefono = false;
			if(r.PersonEmail == null || r.PersonEmail == ' ') {
				GCRres.NoTieneMail = true;
			}
			else GCRres.NoTieneMail = false;
			
			GCRWebService.BasicHttpBinding_IGCRInterface wsGCR = new GCRWebService.BasicHttpBinding_IGCRInterface();
			String fieldBef = r.IdGCR__c;
			system.debug('resident to create: ' + GCRres); 
			InterfaceGCR.ResidenteGCRRespuesta resp = new InterfaceGCR.ResidenteGCRRespuesta();
			resp = wsGCR.createCustomerGCR(GCRres);
			system.debug('Respuesta residente: ' + resp);
			if (!Test.isRunningTest()) {
				if(resp.IdGCR != 0 && resp.IdGCR != -1) r.IdGCR__c = String.valueof(resp.IdGCR);
				else {
				    if(resp.Motivo_Rechazo.contains('IdPersona: ')){
						r.IdGCR__c = resp.Motivo_Rechazo.split('IdPersona: ')[1];
						GCRres.TipoAccion = 2;
						InterfaceGCR.ResidenteGCRRespuesta resp2 = wsGCR.createCustomerGCR(GCRres);
						if(resp2.IdGCR == -1 || resp2.IdGCR == 0) {
							triggerhelper.sendMail('Error en la creación de residente (createCustomerGCR) al WebService GCR:  https://sarquavitae.my.salesforce.com/' + resi + ' \nResultado:' + resp2.Motivo_Rechazo + '\n');
						}
					}
					else triggerhelper.sendMail('Error en la modificación de residente en GCR: https://sarquavitae.my.salesforce.com/' + resi + ' \nResultado: ' + resp.Motivo_Rechazo);
				}
				system.debug('Respuesta residente: ' + resp);
			}
			
			if(fieldBef != r.IdGCR__c) update r;
			triggerhelper.recursiveHelper1(false);
		} catch (Exception e) {
			triggerhelper.setTodoFalse();
			triggerhelper.sendMail('Error en la modificación de residente en GCR: https://sarquavitae.my.salesforce.com/' + resi + ' \nResultado: ' + e);
		}
			
	}
	
	@future (callout=true)
	public static void modifyOpp( Id op) {
		try {
			triggerhelper.recursiveHelper7(true);
			Oportunidad_platform__c opc =[Select Id, Name, Tipo_de_cobro__c, Tipo_de_Financiacion__c, Centro2__c, IdGCR_EPS__c, Residente__c, Servicio__c From Oportunidad_platform__c Where Id = :op];
			Servicio__c sc = [Select Id, Name, Tipo_Servicio__c From Servicio__c Where Id = :opc.Servicio__c];
			Account cent = [Select Id, Name, IdNAV__c From Account Where Id = :opc.Centro2__c];
			Account res = [Select Id, IdGCR__c From Account Where Id = :opc.Residente__c];
			 
			InterfacaIGCR.OportunidadGCR GCROp = new InterfacaIGCR.OportunidadGCR();
			GCROp.TipoAccion = (opc.IdGCR_EPS__c == NULL)?1:2;
			if(res.IdGCR__c!= null) GCROp.IdPersona = integer.valueof(res.IdGCR__c); 
			GCROp.Fecha_de_Solicitud = Date.today();
			GCROp.Tipo_de_Servicio = sc.Tipo_Servicio__c;
			GCROp.Tipo_de_Financiacion = opc.Tipo_de_Financiacion__c;
			GCROp.Centro = cent.IdNAV__c;
			GCROp.IDOportunidadSF = opc.Id;
			system.debug('opportunity to create: ' + GCROp);
			
			GCRWebService.BasicHttpBinding_IGCRInterface wsGCR = new GCRWebService.BasicHttpBinding_IGCRInterface();
			InterfaceGCR.OportunidadGCRRespuesta respOp = new InterfaceGCR.OportunidadGCRRespuesta();
			respOp = wsGCR.createOportunidadGCR(GCROp);	
			if(respOP.IDOportunidad != 1) triggerhelper.sendMail('Error en la creación de oportunidad en GCR: https://sarquavitae.my.salesforce.com/' + op + ' \nResultado: ' +  respOp.Motivo_Rechazo);
			if (!Test.isRunningTest()) system.debug('Respuesta Oportunidad: ' +respOp);
			
			triggerhelper.recursiveHelper7(false);
		} catch (Exception e) {
			triggerhelper.setTodoFalse();
			triggerhelper.sendMail('Error en la creación de oportunidad en GCR: https://sarquavitae.my.salesforce.com/' + op + ' \nResultado: ' +  e);
		}		
	}
	
	@future (callout=true)
	public static void modifyContact(Id resi, Id rel) {
		Relacion_entre_contactos__c relacion = [Select Id, IdGCR__c, Contacto__c, Residente__c, Familiar_de_referencia__c, Relacion_personal__c From Relacion_entre_contactos__c Where Residente__c = :resi and Contacto__c = :rel];
		Account contacto = [Select Id, FirstName, LastName, Pais__c, No_tiene_correo_electronico__c, No_tiene_telefono__c, Provincia__c, Correo_Electronico_Generico__c, PersonMobilePhone, Phone, Calle__c, IdNAV_RES__c, Tipo_Documento_Identidad__c, Tipo_Documento_Sanitario__c, CIF_NIF__c, Ciudad__c, Codigo_postal__c, PersonBirthdate, PersonEmail, Nuermo_Documento_Sanitario__c, Sexo__c, IdGCR__c From Account Where Id = :rel];
			
		try {
			triggerhelper.recursiveHelper2(true);
			
			//if(contacto.Phone == null) contacto.Phone = ' ';
			//if(contacto.PersonMobilePhone == null) contacto.PersonMobilePhone = ' ';
			//if(contacto.PersonEmail == null) contacto.PersonEmail = ' ';
			if(contacto.Calle__c == null) contacto.Calle__c = ' ';
			if(contacto.Ciudad__c == null) contacto.Ciudad__c = ' ';
			if(contacto.Pais__c == null) contacto.Pais__c = ' ';
			if(contacto.Codigo_postal__c == null) contacto.Codigo_postal__c = '  ';
			if(contacto.Provincia__c == null) contacto.Provincia__c = ' ';
			
			String gcrid = [Select Id, IdGCR__c FROM Account WHERE Id = :resi].IdGCR__c; 
		    InterfacaIGCR.ContactoGCR GCRCon = new InterfacaIGCR.ContactoGCR();
		    GCRCon.TipoAccion = (relacion.IdGCR__c == NULL)?1:2;
			GCRCon.IDContactoGCR = (relacion.IdGCR__c == NULL)?0:(Integer.valueof(relacion.IdGCR__c));
			if(gcrid != null) GCRCon.IDResidenteGCR = Integer.valueof(gcrid);
			GCRCon.Tipo_Contacto = relacion.Relacion_personal__c;
			GCRCon.FirstName = contacto.FirstName;
			String[] surnames = triggerHelper.sepLastName(contacto.LastName);
			GCRCon.LastName1 = surnames[0];
			GCRCon.LastName2 = surnames[1];
			GCRCon.Tipo_Documento_Identidad = contacto.Tipo_Documento_Identidad__c;
			GCRCon.Numero_Documento_Identidad = contacto.CIF_NIF__c;
			GCRCon.Sexo = contacto.Sexo__c;
			GCRCon.Fecha_Nacimiento = contacto.PersonBirthdate;
			GCRCon.Phone = contacto.Phone;
			GCRCon.PersonMobilePhone = contacto.PersonMobilePhone;
			GCRCon.PersonEmail = contacto.PersonEmail;
			GCRCon.Calle = contacto.Calle__c;
			GCRCon.Ciudad = contacto.Ciudad__c;
			GCRCon.CodigoPostal = contacto.Codigo_postal__c;
			GCRCon.Provincia = contacto.Provincia__c;
			GCRCon.Pais = contacto.Pais__c;
			if((contacto.Phone == null || contacto.Phone == ' ') && (contacto.PersonMobilePhone == null || contacto.PersonMobilePhone == ' ')) {
				GCRCon.NoTieneTelefono = true;
			}
			else GCRCon.NoTieneTelefono = false;
			if(contacto.PersonEmail == null || contacto.PersonEmail == ' ') {
				GCRCon.NoTieneMail = true;
			}
			else GCRCon.NoTieneMail = false;
			GCRCon.EsReferencia = relacion.Familiar_de_referencia__c;
			GCRWebService.BasicHttpBinding_IGCRInterface wsGCR = new GCRWebService.BasicHttpBinding_IGCRInterface();
			InterfaceGCR.ContactoGCRRespuesta resp2 = new InterfaceGCR.ContactoGCRRespuesta();
			system.debug('contact to create: ' + GCRCon); 
			resp2 = wsGCR.createContactoGCR(GCRCon);
			String fieldBef = relacion.IdGCR__c;
			if (!Test.isRunningTest()) {
				if(resp2.ID_ContactoGCR != -1 && resp2.ID_ContactoGCR != 0) relacion.IdGCR__c = String.valueof(resp2.ID_ContactoGCR);
				else {
					if(resp2.Motivo_Rechazo.contains('IdPersona: ')){
						relacion.IdGCR__c = resp2.Motivo_Rechazo.split('IdPersona: ')[1];
						GCRCon.IDContactoGCR = Integer.valueof(relacion.IdGCR__c);
						GCRCon.TipoAccion = 2;
						InterfaceGCR.ContactoGCRRespuesta resp3 = wsGCR.createContactoGCR(GCRCon);
						if(resp3.ID_ContactoGCR == -1 || resp3.ID_ContactoGCR == 0) {
							triggerhelper.sendMail('Error en la creación de contacto (createContactoGCR) al WebService GCR:  https://sarquavitae.my.salesforce.com/' + relacion.Id + ' \nResultado:' + resp3.Motivo_Rechazo + '\n');
						}
					}
					else triggerhelper.sendMail('Error en la creación de contacto en GCR: https://sarquavitae.my.salesforce.com/' + relacion.Id + ' \nResultado: ' + resp2.Motivo_Rechazo);
				}
				system.debug('Respuesta contacto: ' + resp2);
			}
			
			if(fieldBef != relacion.IdGCR__c) update relacion;
			triggerhelper.recursiveHelper2(false);
		} catch (Exception e) {
			triggerhelper.setTodoFalse();
			triggerhelper.sendMail('Error en la creación de contacto en GCR: https://sarquavitae.my.salesforce.com/' + relacion.Id + ' \n resultado: ' + e);
		}
	}
    
    @future(callout = true) public static void createResidente(Id resi, Id rel, Id opc){
         triggerhelper.recursiveHelper3(true);
       		Account r = [Select Id, FirstName, LastName, PersonMobilePhone, CreatedById, Estado_Civil__c, No_tiene_telefono__c, Provincia__c, No_tiene_correo_electronico__c, Phone, Calle__c, IdNAV_RES__c, Tipo_Documento_Identidad__c, Tipo_Documento_Sanitario__c, CIF_NIF__c,Ciudad__c, Pais__c, Codigo_postal__c, PersonBirthdate, PersonEmail, Nuermo_Documento_Sanitario__c, Sexo__c, IdGCR__c From Account Where Id = :resi];
        	Oportunidad_platform__c opc2 =[Select Id, Name, CreatedById, OwnerId, Tipo_de_Financiacion__c, Precio_Total__c, Tipo_de_cobro__c, Centro2__c, IdGCR_EPS__c, Residente__c, Servicio__c From Oportunidad_platform__c Where Id = :opc];
        	Servicio__c sc = [Select Id, Name, Tipo_Servicio__c From Servicio__c Where Id = :opc2.Servicio__c];
        	Account cent = [Select Id, Name, Division__c, IdNAV__c From Account Where Id = :opc2.Centro2__c];
        	User creator = [Select Id, Name, Email From User Where Id = :opc2.OwnerId]; 
            GCRWebService.BasicHttpBinding_IGCRInterface wsGCR = new GCRWebService.BasicHttpBinding_IGCRInterface();  
        	String mailBody = '';
            try {
                
                InterfacaIGCR.ResidenteGCR GCRres = new InterfacaIGCR.ResidenteGCR();
                
                GCRres.TipoAccion = (r.IdGCR__c == NULL)?1:2;
                GCRres.IdNAV_RES = r.IdNAV_RES__c;
                GCRres.FirstName = r.FirstName;
               String[] surnames = triggerHelper.sepLastName(r.LastName);
                GCRres.LastName1 = surnames[0];
                GCRres.LastName2 = surnames[1];
                GCRres.Tipo_Documento_Identidad = r.Tipo_Documento_Identidad__c;
                GCRres.Numero_Documento_Identidad = r.CIF_NIF__c;
                GCRres.Tipo_Documento_Sanitario = r.Tipo_Documento_Sanitario__c;
                GCRres.Numero_Documento_Sanitario = r.Nuermo_Documento_Sanitario__c;
                GCRres.Estado_Civil = r.Estado_Civil__c;
                GCRres.Sexo = r.Sexo__c;
                GCRres.Fecha_Nacimiento = r.PersonBirthdate;
                GCRres.Phone = r.Phone;
                GCRres.PersonMobilePhone = r.PersonMobilePhone;
                GCRres.PersonEmail = r.PersonEmail;
                GCRres.Calle = r.Calle__c;
                GCRres.Ciudad = r.Ciudad__c;
                GCRres.Provincia = r.Provincia__c;
                GCRres.CodigoPostal = r.Codigo_postal__c;
                GCRres.Pais = r.Pais__c;
                //controlamos si se informa telefono o mail
                if((r.Phone == null || r.Phone == ' ') && (r.PersonMobilePhone == null || r.PersonMobilePhone == ' ')) {
                    GCRres.NoTieneTelefono = true;
                }
                else GCRres.NoTieneTelefono = false;
                if(r.PersonEmail == null || r.PersonEmail == ' ') {
                    GCRres.NoTieneMail = true;
                }
                else GCRres.NoTieneMail = false;
                
                system.debug('resident to create: ' + GCRres); 
                InterfaceGCR.ResidenteGCRRespuesta resp = new InterfaceGCR.ResidenteGCRRespuesta();
                resp = wsGCR.createCustomerGCR(GCRres);
                system.debug('Respuesta residente: ' + resp);
                system.debug('Respuesta residente2: ' + resp.idGCR);
                System.debug('PROVAAAAAAAAAAA');
                //if (!Test.isRunningTest()) {
                    if(resp.IdGCR != 0 && resp.IdGCR != -1) r.IdGCR__c = String.valueof(resp.IdGCR);
                    else {  
                        //si ya estaba actualizamos el registro
                        if(resp.Motivo_Rechazo.contains('IdPersona: ')){
                            r.IdGCR__c = resp.Motivo_Rechazo.split('IdPersona: ')[1];
                            System.debug('IDGCR RESIDENTE: '+r.IdGCR__c);
                            GCRres.TipoAccion = 2;
                            InterfaceGCR.ResidenteGCRRespuesta resp4 = wsGCR.createCustomerGCR(GCRres);
                            if(resp4.IdGCR == -1 || resp4.IdGCR == 0) {
                                
                                
                                Boolean trobat = false;
                                for (Integer cont = 0;cont < 3 && !trobat; ++cont) {
                                    Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
                                    Integer delayInMilliseconds = 30000; // One-second delay
                                    while (System.now().getTime() - startingTime < delayInMilliseconds) {
                                        // Do nothing until desired delay has passed
                                    }
                                    resp4 = wsGCR.createCustomerGCR(GCRres);
                                    if (resp4.IdGCR != -1 && resp4.IdGCR != 0) {
                                        trobat = true;
                                    }
                                }
                                if (!trobat) {
                                    mailBody += 'Error en la creación de residente (createCustomerGCR) al WebService GCR:  https://sarquavitae.my.salesforce.com/' + opc + ' \nResultado:' + resp4.Motivo_Rechazo + '\n';
                                } 
  
                            }
                        }
                        Boolean trobat = false;
                        for (Integer cont = 0;cont < 3 && !trobat; ++cont) {
                            Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
                            Integer delayInMilliseconds = 30000; // One-second delay
                            while (System.now().getTime() - startingTime < delayInMilliseconds) {
                                // Do nothing until desired delay has passed
                            }
                            resp = wsGCR.createCustomerGCR(GCRres);
                            if (resp.IdGCR != -1 && resp.IdGCR != 0) {
                                trobat = true;
                            }
                        }
                        if (!trobat) {
                            mailBody += 'Error en la creación de residente (createCustomerGCR) en GCR: https://sarquavitae.my.salesforce.com/' + opc + ' \nResultado: ' + resp.Motivo_Rechazo + '\n';
                        }  
                    }
                    system.debug('Respuesta residente: ' + resp);
                /*}*/
            } catch(Exception e) {
                System.debug('EL ERROR ES: '+e);
                System.debug('MAIL BODY: '+mailBody);
                mailBody += 'Error en la creación de residente (createCustomerGCR) en GCR: https://sarquavitae.my.salesforce.com/' + opc + ' \nResultado: ' + e + '\n';
            }
            
            list<Relacion_entre_contactos__c> relaciones = [Select Id, IdGCR__c, Contacto__c, Residente__c, Familiar_de_referencia__c, Relacion_personal__c From Relacion_entre_contactos__c Where Residente__c = :resi];
            List<Id> conts = new List<Id>();
            for(integer k = 0; k < relaciones.Size(); ++k) conts.add(relaciones[k].Contacto__c);
            list<Account> contactos = [Select Id, FirstName, LastName, Pais__c, No_tiene_correo_electronico__c, No_tiene_telefono__c, Provincia__c, Correo_Electronico_Generico__c, PersonMobilePhone, Phone, Calle__c, IdNAV_RES__c, Tipo_Documento_Identidad__c, Tipo_Documento_Sanitario__c, CIF_NIF__c,Ciudad__c, Codigo_postal__c, PersonBirthdate, PersonEmail, Nuermo_Documento_Sanitario__c, Sexo__c, IdGCR__c From Account Where Id In :conts];
            
            
                
            for(integer i = 0; i < relaciones.Size(); ++i) {
                
                try {
                    
                    integer j = 0;
                    boolean enc = false;
                    while(j < contactos.Size() && !enc) {
                        if(contactos[j].Id == relaciones[i].Contacto__c)  {
                            enc = true;
                        }
                        ++j;
                    }
                    --j;
                    
                    //if(contactos[j].Phone == null) contactos[j].Phone = ' ';
                    //if(contactos[j].PersonMobilePhone == null) contactos[j].PersonMobilePhone = ' ';
                    //if(contactos[j].PersonEmail == null) contactos[j].PersonEmail = ' ';
                    if(contactos[j].Calle__c == null) contactos[j].Calle__c = ' ';
                    if(contactos[j].Ciudad__c == null) contactos[j].Ciudad__c = ' ';
                    if(contactos[j].Pais__c == null) contactos[j].Pais__c = ' ';
                    if(contactos[j].Provincia__c == null) contactos[j].Provincia__c = ' ';
                    if(contactos[j].Codigo_postal__c == null) contactos[j].Codigo_postal__c = '  ';
                    
                    String[] surnamesCon = triggerHelper.sepLastName(contactos[j].LastName);
                    
                    String gcrid = r.IdGCR__c; 
                    InterfacaIGCR.ContactoGCR GCRCon = new InterfacaIGCR.ContactoGCR();
                    GCRCon.TipoAccion = (relaciones[i].IdGCR__c == NULL)?1:2;
                    GCRCon.IDContactoGCR = (relaciones[i].IdGCR__c == NULL)?0:(Integer.valueof(relaciones[i].IdGCR__c));
                    if(r.IdGCR__c != null) GCRCon.IDResidenteGCR = Integer.valueof(r.IdGCR__c);
                    GCRCon.Tipo_Contacto = relaciones[i].Relacion_personal__c;
                    GCRCon.FirstName = contactos[j].FirstName;
                    GCRCon.LastName1 = surnamesCon[0];
                    GCRCon.LastName2 = surnamesCon[1];
                    GCRCon.Tipo_Documento_Identidad = contactos[j].Tipo_Documento_Identidad__c;
                    GCRCon.Numero_Documento_Identidad = contactos[j].CIF_NIF__c;
                    GCRCon.Sexo = contactos[j].Sexo__c;
                    GCRCon.Fecha_Nacimiento = contactos[j].PersonBirthdate;
                    GCRCon.Phone = contactos[j].Phone;
                    GCRCon.PersonMobilePhone = contactos[j].PersonMobilePhone;
                    GCRCon.PersonEmail = contactos[j].PersonEmail;
                    GCRCon.Calle = contactos[j].Calle__c;
                    GCRCon.Ciudad = contactos[j].Ciudad__c;
                    GCRCon.CodigoPostal = contactos[j].Codigo_postal__c;
                    GCRCon.Provincia = contactos[j].Provincia__c;
                    GCRCon.Pais = contactos[j].Pais__c;
                    //controlamos si se informa telefono o mail
                    if((contactos[j].Phone == null || contactos[j].Phone == ' ') && (contactos[j].PersonMobilePhone == null || contactos[j].PersonMobilePhone == ' ')) {
                        GCRCon.NoTieneTelefono = true;
                    }
                    else GCRCon.NoTieneTelefono = false;
                    if(contactos[j].PersonEmail == null || contactos[j].PersonEmail == ' ') {
                        GCRCon.NoTieneMail = true;
                    }
                    else GCRCon.NoTieneMail = false;
                    GCRCon.EsReferencia = relaciones[i].Familiar_de_referencia__c;
                    
                    InterfaceGCR.ContactoGCRRespuesta resp2 = new InterfaceGCR.ContactoGCRRespuesta();
                    system.debug('contact to create: ' + GCRCon); 
                    resp2 = wsGCR.createContactoGCR(GCRCon);
                    if (!Test.isRunningTest()) {
                        if(resp2.ID_ContactoGCR != -1 && resp2.ID_ContactoGCR != 0) relaciones[i].IdGCR__c = String.valueof(resp2.ID_ContactoGCR);
                        else {
                            //si el contacto ya existia lo actualizamos
                            if(resp2.Motivo_Rechazo.contains('IdPersona: ')){
                                relaciones[i].IdGCR__c = resp2.Motivo_Rechazo.split('IdPersona: ')[1];
                                GCRCon.IDContactoGCR = Integer.valueof(relaciones[i].IdGCR__c);
                                GCRCon.TipoAccion = 2;
                                InterfaceGCR.ContactoGCRRespuesta resp3 = wsGCR.createContactoGCR(GCRCon);
                                if(resp3.ID_ContactoGCR == -1 || resp3.ID_ContactoGCR == 0) {
                                    
										Boolean trobat = false;
                                        for (Integer cont = 0;cont < 3 && !trobat; ++cont) {
                                            Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
                                            Integer delayInMilliseconds = 30000; // One-second delay
                                            while (System.now().getTime() - startingTime < delayInMilliseconds) {
                                                // Do nothing until desired delay has passed
                                            }
                                            resp3 = wsGCR.createContactoGCR(GCRCon);
                                            if (resp3.ID_ContactoGCR != -1 && resp3.ID_ContactoGCR != 0) {
                                                trobat = true;
                                            }
                                        }
                                        if (!trobat) {
                                            mailBody += 'Error en la creación de contacto (createContactoGCR) al WebService GCR:  https://sarquavitae.my.salesforce.com/' + relaciones[i].Id + ' \nResultado:' + resp3.Motivo_Rechazo + '\n';
                                        }  
                                }
                            }
                            
                            else {
                                Boolean trobat = false;
                                for (Integer cont = 0;cont < 3 && !trobat; ++cont) {
                                    Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
                                    Integer delayInMilliseconds = 30000; // One-second delay
                                    while (System.now().getTime() - startingTime < delayInMilliseconds) {
                                        // Do nothing until desired delay has passed
                                    }
                                    resp2 = wsGCR.createContactoGCR(GCRCon);
                                    if (!resp2.Motivo_Rechazo.contains('IdPersona: ')) {
                                        trobat = true;
                                    }
                                }
                                if (!trobat) {
                                    mailBody += 'Error en la creación de contacto (createContactoGCR) al WebService GCR:  https://sarquavitae.my.salesforce.com/' + relaciones[i].Id + ' \nResultado:' + resp2.Motivo_Rechazo + '\n';
                                }  
                            }
                        }
                        system.debug('Respuesta contacto: ' + resp2);
                    }
                        
                } catch(Exception e) {
                    //triggerhelper.setTodoFalse();
                    mailBody += 'Error en la creación de contacto (createContactoGCR) al WebService GCR:  https://sarquavitae.my.salesforce.com/' + relaciones[i].Id + ' \nResultado:' + e + '\n';
                }
            }
            
            
            try {
                InterfacaIGCR.OportunidadGCR GCROp = new InterfacaIGCR.OportunidadGCR();
                GCROp.TipoAccion = (opc2.IdGCR_EPS__c == NULL)?1:2;
                if(r.IdGCR__c!= null) GCROp.IdPersona = integer.valueof(r.IdGCR__c); 
                GCROp.Fecha_de_Solicitud = Date.today();
                GCROp.Tipo_de_Servicio = sc.Tipo_Servicio__c;
                GCROp.Tipo_de_Financiacion = opc2.Tipo_de_Financiacion__c;
                GCROp.Centro = cent.IdNAV__c;
                GCROp.IDOportunidadSF = opc2.Id;
                system.debug('opportunity to create: ' + GCROp);
                InterfaceGCR.OportunidadGCRRespuesta respOp = new InterfaceGCR.OportunidadGCRRespuesta();
                respOp = wsGCR.createOportunidadGCR(GCROp); 
                
                if(respOp.IDOportunidad != 1) {
                    Boolean trobat = false;
                        for (Integer cont = 0;cont < 3 && !trobat; ++cont) {
                            Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
							Integer delayInMilliseconds = 30000; // One-second delay
                            while (System.now().getTime() - startingTime < delayInMilliseconds) {
                                        // Do nothing until desired delay has passed
                            }
                           respOp = wsGCR.createOportunidadGCR(GCROp); 
                            if (respOp.IDOportunidad == 1) {
                                trobat = true;
                            }
                        }
                    if (!trobat) {
                        mailBody += 'Error en la creación de oportunidad (createOportunidadGCR) en GCR:  https://sarquavitae.my.salesforce.com/' + opc + ' \nResultado: ' + respOp.Motivo_Rechazo + '\n';
                    }
                    
               	}
                if(respOp.IDOportunidad != 1) mailBody += 'Error en la creación de oportunidad (createOportunidadGCR) en GCR:  https://sarquavitae.my.salesforce.com/' + opc + ' \nResultado: ' + respOp.Motivo_Rechazo + '\n';
                if (!Test.isRunningTest()) system.debug('Respuesta Oportunidad: ' +respOp);

            } catch(Exception e) {
                //triggerhelper.setTodoFalse();
                mailBody += 'Error en la creación de oportunidad (createOportunidadGCR) en GCR:  https://sarquavitae.my.salesforce.com/' + opc + ' \nResultado: ' + e + '\n';
            }
            
            update r;
            //update contactos;
            update relaciones;
            if(mailBody != '') triggerhelper.sendMail(mailBody, new List<String> {creator.Email}, 'https://sarquavitae.my.salesforce.com/' + opc);
            triggerhelper.recursiveHelper3(false);
        }
	
}