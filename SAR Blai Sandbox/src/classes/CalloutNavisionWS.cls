/** 
* File Name:   CalloutNavisionWS 
* Description: Classe encargada de realizar la conexion con Navision
* Copyright:   Konozca 
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 02		12/02/2015  Xavier Garcia	Convertir la llamada de creación del cliente en dos llamadas distintas (cliente y contrato)
* =============================================================== 
**/ 
global class CalloutNavisionWS {
    
    private static integer getPosition(List<Schema.PicklistEntry> pL, String s) {
        for(integer i = 0; i < pL.size(); ++i) {
            if(pL[i].getValue() == s) return i+1;
        }
        return null;
    }    
    
    @future (callout=true)
    public static void modifyCustomer(Id cli) {
        try {
            triggerhelper.recursiveHelper4(true);
            
            //Add code to perform callout
            //Oportunidad_platform__c o = [Select Id, RecordTypeId, IBAN__c, CreatedById, OwnerId, NOC__c, Residente__c, NOC_11_Centro__c, NOC_11_Persona__c, NOC_12_Convenios__c, Precio_Total__c, Servicio__c, No_Finanza__c, Fecha_real_de_ingreso__c, Fecha_prevista_de_ingreso__c, LastModifiedBy.Name, Centro2__c, Regimen__c, Tipo_de_tarifa__c, Tipo_de_cobro__c, Tipo_de_pago__c, Institucion__c, Concierto__c, Forma_de_pago__c From Oportunidad_platform__c Where Pagador__c = :cli and Etapa__c = 'Ingreso' and Fecha_de_Alta__c = null ORDER BY Fecha_prevista_de_ingreso__c DESC LIMIT 1];
            //Add code to perform callout
            Account c = [Select Id, OwnerId, FirstName, LastName, IdNAV_CL__c, Phone, Calle__c, Provincia__c, CreatedById, IdNAV_RES__c, Tipo_Documento_Identidad__c, Tipo_Documento_Sanitario__c, CIF_NIF__c,Ciudad__c, Codigo_postal__c, PersonBirthdate, PersonEmail, Nuermo_Documento_Sanitario__c, Sexo__c From Account Where Id = :cli];
            User creator = [Select Id, Name, Email From User Where Id = :c.OwnerId];
            
            Schema.DescribeFieldResult fieldSexo = account.Sexo__c.getDescribe();
            List<Schema.PicklistEntry> sexList = fieldSexo.getPicklistValues();
            
            Schema.DescribeFieldResult fieldTDS = account.Tipo_Documento_Sanitario__c.getDescribe();
            List<Schema.PicklistEntry> tdsList = fieldTDS.getPicklistValues();
            
            Schema.DescribeFieldResult fieldTDI = account.Tipo_Documento_Identidad__c.getDescribe();
            List<Schema.PicklistEntry> tdiList = fieldTDI.getPicklistValues();
            
            Schema.DescribeFieldResult fieldTT = Oportunidad_platform__c.Tipo_de_tarifa__c.getDescribe();
            List<Schema.PicklistEntry> TTList = fieldTT.getPicklistValues();

            Schema.DescribeFieldResult fieldTC = Oportunidad_platform__c.Tipo_de_cobro__c.getDescribe();
            List<Schema.PicklistEntry> TCList = fieldTC.getPicklistValues();
            
            Schema.DescribeFieldResult fieldTP = Oportunidad_platform__c.Tipo_de_pago__c.getDescribe();
            List<Schema.PicklistEntry> TPList = fieldTP.getPicklistValues();
            
           
            if(c.Calle__c == null) c.Calle__c = ' ';
            if(c.Ciudad__c == null) c.Ciudad__c = ' ';
            if(c.Codigo_postal__c == null) c.Codigo_postal__c = ' ';
            System.debug('ENTRES1');
            //create resident and ws callout
            //tempuriOrgSarBackofficeinterfaceWcf2.CustomerRequest cr = new tempuriOrgSarBackofficeinterfaceWcf2.CustomerRequest();
            tempuriOrg2.CustomerRequestAsync cr = new tempuriOrg2.CustomerRequestAsync();
			cr.ExternalID = c.id;
            cr.First_Name = c.FirstName;
            String[] surnames = triggerHelper.sepLastName(c.LastName);
            cr.Middle_Name = surnames[0];
            cr.Surname = surnames[1];
            cr.Tipo_via = 1;
            cr.Nombre_calle = c.Calle__c;
            cr.Numero = '';
            cr.Bloque = '';
            cr.Escalera = '';
            cr.Piso = '';
            cr.Puerta = '';
            cr.City = c.Ciudad__c;
            cr.Phone_No_x = c.Phone;
            cr.VAT_Registration_No_x = c.CIF_NIF__c;
            cr.Post_Code = c.Codigo_postal__c;
            if(c.PersonEmail != null) cr.E_Mail = c.PersonEmail;
            else cr.E_Mail = '';
            cr.Fecha_nacimiento = c.PersonBirthdate; 
            cr.Sexo = CalloutNavisionWS.getPosition(sexList, c.Sexo__c);
            if (c.Tipo_Documento_Sanitario__c != null) {
                	cr.Tipo_documento_sanitario = CalloutNavisionWS.getPosition(tdsList, c.Tipo_Documento_Sanitario__c);
                	if(cr.Tipo_documento_sanitario == null) cr.Tipo_documento_sanitario = 5;
            }
            else {
                cr.Tipo_documento_sanitario = 0;
            }
            cr.Documento_sanitario = c.Nuermo_Documento_Sanitario__c;
            cr.Tipo_documento = CalloutNavisionWS.getPosition(tdiList, c.Tipo_Documento_Identidad__c);
            cr.SourceAppUser = '';
            cr.SourceApp = 'SF';
            System.debug('ENTRES2');
            //tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessage rmidCLN = new tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessage();
            tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessageAsync rmidCLN = new tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessageAsync();
            tempuriOrg2.basicEndpoint WS = new tempuriOrg2.basicEndpoint();
            
            system.debug('customer to create: ' + cr);
            //rmidCLN = WS.createCustomer(cr); //llamada sincrona ???
            if(!Test.isRunningTest()) {
            	rmidCLN = WS.createCustomerAsync(cr);
            }
            String fieldBef = c.IdNAV_CL__c;
            
            // FALTA rmidCLN.Code
            Boolean success = rmidCLN.result;
            String result = rmidCLN.Level;
            String message = rmidCLN.Message;            
            /*
            String idcl = rmidCLN.Code;
            String result = rmidCLN.Level;
            String message = rmidCLN.Message;
			*/
            if(success) {
                System.debug('CUSTOMER REQUEST SUCCESSFUL');
            } else {
                system.debug('LEVEL: ' + result);
                system.debug('MESSAGE: ' + message);
            }             
            //if(idcl.contains('CL')) c.IdNAV_CL__c = idcl;
            if(result != 'info') {
                System.debug('Error en la modificación del cliente (createCustomer) en Navision:');
                System.debug(result);
                System.debug(cli);
                //triggerhelper.sendMail('Error en la modificación del cliente (createCustomer) en Navision: https://sarquavitae.my.salesforce.com/' + cli + ' \nRespuesta: ' + result + ' '+ message, new List<String>{creator.Email}, 'https://sarquavitae.my.salesforce.com/' + cli);
            }
            //System.debug('IDCL PAGADOR INGRESO: '+idcl);
             //CONTRATO
            tempuriOrgSarBackofficeinterfaceWcf2.ContractRequest contract = new tempuriOrgSarBackofficeinterfaceWcf2.ContractRequest();
            //cr.Tipo_Contrato = ('012b0000000QBG1AAO' == o.RecordTypeId) ? 0:1;
            contract.Tipo_Contrato = 0;
            contract.Servicio = '';            
            contract.PaymentMethod = '';
            //contract.CreateContract = false;
            contract.FechaInicio = Date.parse('01/01/1753');
            contract.IBAN = '';
            contract.NOCFianza = '';
            contract.ResidentNo = '';
            contract.Fianza = false;
            contract.Cod_Centro = '';
            contract.Tipo_Tarifa = 0;
            contract.Tipo_Cobro = 0;
            contract.Tipo_Pago = 0;
            contract.Concierto = '';
            update c;
            //if(fieldBef != c.IdNAV_CL__c) update c;
            triggerhelper.recursiveHelper4(false);
        }
        catch (Exception e) {
            triggerhelper.setTodoFalse();
            //triggerhelper.sendMail('Error en la modificación del cliente (createCustomer) en Navision: https://sarquavitae.my.salesforce.com/' + cli +  ' \nRespuesta: ' + e);
        }
    }
    
        
    Webservice static void createIngresoWS(Id op) {
        Oportunidad_platform__c o = [Select Id, Pagador__c, Residente__c From Oportunidad_platform__c Where Id = :op];
        createIngreso(o.Pagador__c, op);
        System.debug('ENTRES000001');
    }
    
    Webservice static void enviar_noc_renegociadaWS(Id Nocid) {
        enviar_noc_renegociada(Nocid);
    }
    
    @future (callout=true)
    public static void enviar_noc_renegociada (id Nocid)
    {	String mailBody;
        Noc__c naux = [Select LastModifiedBy.Name,id,Id_contrato__c,Nueva_Tarifa__r.Servicio__c, Fianza_a_cobrar__c, Importe_Fianza_a_cobrar__c,Oportunidad_renegociada__c,Descuento_permanente__c,Precio_propuesto__c,name,Importe_Mes_1__c,Importe_Mes_2__c,Importe_Mes_3__c,Importe_Mes_4__c,Importe_Mes_5__c,Importe_Mes_6__c,Fecha_Inicio_1__c,Fecha_Inicio_2__c,Fecha_Inicio_3__c,Fecha_Inicio_4__c,Fecha_Inicio_5__c,Fecha_Inicio_6__c,Fecha_Fin_1__c,Fecha_Fin_2__c,Fecha_Fin_3__c,Fecha_Fin_4__c,Fecha_Fin_5__c,Fecha_Fin_6__c,Fecha_inicio__c,Fecha_fin__c,nueva_tarifa_oficial__c from Noc__c where id=: Nocid];
        Id idOp = naux.Oportunidad_renegociada__c;
        Oportunidad_platform__c o = [Select Precio_Total__c,centro2__r.IdNAV__c,Id_contrato__c,Precio_Ofertado__c,Descuento_Ofertado__c,Precio_Plus__c,Precio__c from Oportunidad_platform__c where id =:idOp];
		List<tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions> listacpc = new List<tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions>();
                        if (naux.Importe_Mes_1__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions();
                                if (naux.Fecha_Inicio_1__c != null && naux.Fecha_Fin_1__c != null) {
                                    System.debug('ARRIBES10');
                                    if (o.Precio_Ofertado__c != null || o.Descuento_Ofertado__c != null) {
                                        cpc.Precio = o.Precio_Total__c;
                                    }
                                    else {
                                        cpc.Precio = naux.Importe_Mes_1__c;
                                    }
                                		cpc.FechaInicio = naux.Fecha_Inicio_1__c;
                                		cpc.FechaFin = naux.Fecha_Fin_1__c;
                                    System.debug('ARRIBES11');
                                    listacpc.add(cpc);
                                }
                            System.debug('ARRIBES02');
                        }
                        if (naux.Importe_Mes_2__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions();
                                if (naux.Fecha_Inicio_2__c != null && naux.Fecha_Fin_2__c != null) {
                                    	cpc.Precio = naux.Importe_Mes_2__c;
                                		cpc.FechaInicio = naux.Fecha_Inicio_2__c;
                                		cpc.FechaFin = naux.Fecha_Fin_2__c;
                                    listacpc.add(cpc);
                                }
                        }
                        if (naux.Importe_Mes_3__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions();
                                if (naux.Fecha_Inicio_3__c != null && naux.Fecha_Fin_3__c != null) {
                                    	cpc.Precio = naux.Importe_Mes_3__c;
                                		cpc.FechaInicio = naux.Fecha_Inicio_3__c;
                                		cpc.FechaFin = naux.Fecha_Fin_3__c;
                                    listacpc.add(cpc);
                                }
                        }
                        if (naux.Importe_Mes_4__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions();
                                if (naux.Fecha_Inicio_4__c != null && naux.Fecha_Fin_4__c != null) {
                                    	cpc.Precio = naux.Importe_Mes_4__c;
                                		cpc.FechaInicio = naux.Fecha_Inicio_4__c;
                                		cpc.FechaFin = naux.Fecha_Fin_4__c;
                                    listacpc.add(cpc);
                                } 
                        }
                        if (naux.Importe_Mes_5__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions();
                                if (naux.Fecha_Inicio_5__c != null && naux.Fecha_Fin_5__c != null) {
                                    	cpc.Precio = naux.Importe_Mes_5__c;
                                		cpc.FechaInicio = naux.Fecha_Inicio_5__c;
                                		cpc.FechaFin = naux.Fecha_Fin_5__c;
                                    listacpc.add(cpc);
                                }
                        }
                        if (naux.Importe_Mes_6__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions();
                                if (naux.Fecha_Inicio_6__c != null && naux.Fecha_Fin_6__c != null) {
                                    	cpc.Precio = naux.Importe_Mes_6__c;
                                		cpc.FechaInicio = naux.Fecha_Inicio_6__c;
                                		cpc.FechaFin = naux.Fecha_Fin_6__c;
                                    listacpc.add(cpc);
                                }
                        }
                        if (naux.Precio_propuesto__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions();
                            if (naux.Descuento_permanente__c == true) {
                                cpc.Precio = naux.Precio_propuesto__c;
                                
                                if (naux.Fecha_inicio__c != null) {
                                    cpc.FechaInicio = naux.Fecha_inicio__c;
                                }
                                listacpc.add(cpc);
                            }
                            else {
                                if (naux.Fecha_inicio__c != null && naux.Fecha_fin__c != null) {
                                    	cpc.Precio = naux.Precio_propuesto__c;
                                		cpc.FechaInicio = naux.Fecha_inicio__c;
                                		cpc.FechaFin = naux.Fecha_fin__c;
                                    listacpc.add(cpc);
                                }
                            } 
                        }
                        if (listacpc.size() > 0 && naux.Descuento_permanente__c == false) {
                            System.debug('ARRIBAAAAAAAAAAAAAS');
                            tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions cpc3 = new tempuriOrgSarBackofficeinterfaceWcf.ContractPriceConditions();
                            DateTime DataIniciUltim = listacpc[listacpc.size()-1].FechaFin;
                            System.debug('ARRIBAAAAAAAAAAAAAS2');
                            cpc3.Precio = naux.nueva_tarifa_oficial__c; 
                            
                            System.debug('ARRIBAAAAAAAAAAAAAS3');
                            System.debug('fecha inicio ultima: '+DataIniciUltim);
                            cpc3.FechaInicio = DataIniciUltim.addDays(1);
                            System.debug('ARRIBAAAAAAAAAAAAAS4');
                            listacpc.add(cpc3);
                        }
     					boolean fianza_indicada = false;
     					Decimal importe_fianza = 0;
    					if (naux.Importe_Fianza_a_cobrar__c != null || naux.Fianza_a_cobrar__c != null) {
                            fianza_indicada = true;
                            importe_fianza = naux.Importe_Fianza_a_cobrar__c;
     					}
                         
                  
					
        				//Fer la crida a Navision
        				tempuriOrgSarBackofficeinterfaceWcf.NOCRequest nocReq = new tempuriOrgSarBackofficeinterfaceWcf.NOCRequest();
        				nocReq.ContractPriceConditions = listacpc;
        				nocReq.IdCentro = o.centro2__r.IdNAV__c;
                        nocReq.IdContract = naux.Id_contrato__c;
                        nocReq.NombreNoc = naux.Name;
                        nocReq.IdNoc = naux.Id;
     					nocReq.SourceAppUser = naux.LastModifiedBy.Name;
                		nocReq.SourceApp = 'SF';
     					nocReq.Servicio = naux.Nueva_Tarifa__r.Servicio__c;
     					nocReq.ModificacionFianza = fianza_indicada;
     					nocReq.PrecioFianza = importe_fianza;
     					System.debug('NOC REQUEST: '+nocReq);
        				tempuriOrgSarBackofficeinterfaceWcf.ReturnMessage respuestaNoc= new tempuriOrgSarBackofficeinterfaceWcf.ReturnMessage();
        				tempuriOrg.basicEndpoint intNav = new tempuriOrg.basicEndpoint();
                        Try {
                            respuestaNoc = intNav.CreateNOC(nocReq);
                            System.debug('NOC RESPONSE: '+respuestaNoc);
                            String result = respuestaNoc.Level;
                            String message = respuestaNoc.Message;
                            if(result != 'info') {
                                Boolean trobat = false;
                                if (message.contains('Read timed out')) {
                                    for (Integer cont = 0;cont < 3 && !trobat; ++cont) {
                                        Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
                                        Integer delayInMilliseconds = 30000; // One-second delay
                                        while (System.now().getTime() - startingTime < delayInMilliseconds) {
                                                    // Do nothing until desired delay has passed
                                        }
                                        respuestaNoc = intNav.CreateNOC(nocReq);
                                        result = respuestaNoc.Level;
                                        if (result.contains('info')) {
                                            trobat = true;
                                            result = respuestaNoc.Level;
                                            message = respuestaNoc.Message;
                                        }
                                    }
                                }
                                if(result != 'info') {
                                    mailBody += 'Error en el envío de la Noc renegociada (createNoc) en Navision: https://sarquavitae.my.salesforce.com/' + Nocid + ' \nResultado: ' + result + ' '+ message + '\n';
                                }
                                }
                            
                        }
                        catch(exception e) {
                			mailBody += 'Error en el envió de la Noc renegociada '+'https://sarquavitae.my.salesforce.com/' + Nocid +  '\nResultado: ' + e + '\n';
            			}
                        //contract.ContractPriceConditions = listacpc;       
        
        
    }    
    @future (callout=true)
    public static void createIngreso(Id cli, Id op) {
        System.debug('ENTRES0');
        //Add code to perform callout
        Account c = [Select Id, FirstName, LastName, Phone, Calle__c,Pais__c, OwnerId, IdNAV_RES__c, Tipo_Documento_Identidad__c, Tipo_Documento_Sanitario__c, CIF_NIF__c,Ciudad__c, Codigo_postal__c, PersonBirthdate, PersonEmail, Nuermo_Documento_Sanitario__c, Sexo__c From Account Where Id = :cli];
        Oportunidad_platform__c o = [Select Id,Precio__c,Precio_Plus__c, RecordTypeId, IBAN__c, OwnerId, Tipo_de_Financiacion__c, Precio_Total__c, NOC__c, Residente__c,Pagador__c, NOC_11_Centro__c, IdGCR_EPS__c, NOC_11_Persona__c, NOC_12_Convenios__c, Servicio__c, No_Finanza__c, Fecha_real_de_ingreso__c, Fecha_prevista_de_ingreso__c, LastModifiedBy.Name, Centro2__c, Regimen__c, Tipo_de_tarifa__c, Tipo_de_cobro__c, Tipo_de_pago__c, Institucion__c, Concierto__c, CreatedById, Forma_de_pago__c,Descuento_Ofertado__c,Precio_Ofertado__c FROM Oportunidad_platform__c WHERE Id = :op];
        User creator = [Select Id, Name, Email From User Where Id = :o.OwnerId];
        String codigoFormaPago = 'RECIBO DOM';
        if (o.Forma_de_pago__c != null) {
            if (o.Forma_de_pago__c  == 'Efectivo / Transferencia') {
                codigoFormaPago = 'CAJA';
            }
            else if(o.Forma_de_pago__c  == 'Recibo domiciliado') {
                codigoFormaPago = 'RECIBO DOM';
            }
        }
        else {
            if (o.Tipo_de_pago__c != null && o.Tipo_de_pago__c == 'Gratis') {
                codigoFormaPago = 'CAJA';
            }
        }
        if(c.Calle__c == null) c.Calle__c = ' ';
        if(c.Ciudad__c == null) c.Ciudad__c = ' ';
        if(c.Codigo_postal__c == null) c.Codigo_postal__c = ' ';
        
        String mailBody = '';
        //llamada al customer de navision
        try {
            try {
                System.debug('ENTRES0000000000000');
                System.debug('ID OPP: '+o.id);
                triggerhelper.recursiveHelper5(true);
                //create resident and ws callout
                Schema.DescribeFieldResult fieldSexo = account.Sexo__c.getDescribe();
                List<Schema.PicklistEntry> sexList = fieldSexo.getPicklistValues();
                    
                Schema.DescribeFieldResult fieldTDS = account.Tipo_Documento_Sanitario__c.getDescribe();
                List<Schema.PicklistEntry> tdsList = fieldTDS.getPicklistValues();
                    
                Schema.DescribeFieldResult fieldTDI = account.Tipo_Documento_Identidad__c.getDescribe();
                List<Schema.PicklistEntry> tdiList = fieldTDI.getPicklistValues();
                    
                Schema.DescribeFieldResult fieldTT = Oportunidad_platform__c.Tipo_de_tarifa__c.getDescribe();
                List<Schema.PicklistEntry> TTList = fieldTT.getPicklistValues();
        
                Schema.DescribeFieldResult fieldTC = Oportunidad_platform__c.Tipo_de_cobro__c.getDescribe();
                List<Schema.PicklistEntry> TCList = fieldTC.getPicklistValues();
                    
                Schema.DescribeFieldResult fieldTP = Oportunidad_platform__c.Tipo_de_pago__c.getDescribe();
                List<Schema.PicklistEntry> TPList = fieldTP.getPicklistValues();
                System.debug('ENTRES1');
            //MOdificacion por la nueva interficie de Navision
                tempuriOrg2.CustomerRequestAsync cr = new tempuriOrg2.CustomerRequestAsync();
                cr.ExternalID = c.id;
                cr.First_Name = c.FirstName;
                String[] surnames = triggerHelper.sepLastName(c.LastName);
                cr.Middle_Name = surnames[0];
                cr.Surname = surnames[1];
                cr.Tipo_via = 1;
                cr.Nombre_calle = c.Calle__c;
                cr.Numero = '';
                cr.Bloque = '';
                cr.Escalera = '';
                cr.Piso = '';
                cr.Puerta = '';
                cr.Post_Code = c.Codigo_postal__c;
                cr.City = c.Ciudad__c;
                cr.Country = c.Pais__c;
                //cr.Country = 'ES';
                cr.Tipo_documento = CalloutNavisionWS.getPosition(tdiList, c.Tipo_Documento_Identidad__c);  
                cr.VAT_Registration_No_x = c.CIF_NIF__c;
                if(c.Phone != null) cr.Phone_No_x = c.Phone;
                else cr.Phone_No_x = '';
                if(c.PersonEmail != null) cr.E_Mail = c.PersonEmail;
                else cr.E_Mail = '';
                //String idCliente = String.valueOf(c.id);
                cr.ClientID = c.id;
                if (o.IBAN__c != null) {
                    cr.IBAN = o.IBAN__c;
                }
                else {
                   cr.IBAN = ''; 
                }
                /*if(o.Forma_de_pago__c != null) cr.PaymentMethod = o.Forma_de_pago__c;
                else cr.PaymentMethod = 'Recibo domiciliado';*/
                cr.PaymentMethod = codigoFormaPago;
                //cr.PaymentTermsCode = '';
                cr.ClientType = 'NAC';
                //cr.CustomerPostingGroup = '';
                if(c.PersonBirthdate != null) cr.Fecha_nacimiento = c.PersonBirthdate;
                else cr.Fecha_nacimiento = Date.parse('01/01/1753');
                cr.Sexo = CalloutNavisionWS.getPosition(sexList, c.Sexo__c);
                if (c.Tipo_Documento_Sanitario__c != null) {
                	cr.Tipo_documento_sanitario = CalloutNavisionWS.getPosition(tdsList, c.Tipo_Documento_Sanitario__c);
                	if(cr.Tipo_documento_sanitario == null) cr.Tipo_documento_sanitario = 5;
               	}
            	else {
                    cr.Tipo_documento_sanitario = 0;
                }
                if(c.Nuermo_Documento_Sanitario__c != null) cr.Documento_sanitario = c.Nuermo_Documento_Sanitario__c;
                else cr.Documento_sanitario = '';
                //cr.Cod_Centro = [Select Id, IdNAV__c, Name FROM Account WHERE Id = :o.Centro2__c].IdNAV__c;
                System.debug('');
                //Este campo es nuevo
                cr.SourceAppUser = o.LastModifiedBy.Name;
                cr.SourceApp = 'SF';
                //Creamos una tempuriOrgSarBackofficeinterfaceWcf.ReturnMessage, en donde guardaremos el retorno de la llamada createCustomer.
                System.debug('ENTRES2');
                tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessageAsync rmidCLN = new tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessageAsync();
                tempuriOrg2.basicEndpoint WS = new tempuriOrg2.basicEndpoint();
                System.debug('ENTRES3');
                system.debug('customer to create: ' + cr);
                if(!Test.isRunningTest()) {
                	rmidCLN = WS.createCustomerAsync(cr);
				} 
                
                Boolean success = rmidCLN.result;
                String result = rmidCLN.Level;
                String message = rmidCLN.Message;
                
                if(success) {
                    System.debug('CUSTOMER REQUEST SUCCESSFUL');
                } else {
                    system.debug('LEVEL: ' + result);
                	system.debug('MESSAGE: ' + message);
                }
               
                //Creacion del contrato
                tempuriOrgSarBackofficeinterfaceWcf2.ContractRequest contract = new tempuriOrgSarBackofficeinterfaceWcf2.ContractRequest();
            	contract.Tipo_Contrato = ('012b0000000QBG1AAO' == o.RecordTypeId) ? 0:1;
                if(o.Servicio__c != null) contract.Servicio = o.Servicio__c;
                else contract.Servicio = '';
                if(o.Concierto__c != null) contract.Concierto =  [Select Id, IdNAV__c FROM Account WHERE Id = :o.Concierto__c].IdNAV__c;
                List<tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions> listacpc1 = new List<tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions>();
                tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc1 = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                cpc1.Precio = o.Precio_Total__c;
                if(o.Fecha_real_de_ingreso__c == null) {
                    contract.FechaInicio = o.Fecha_prevista_de_ingreso__c;
                    cpc1.FechaInicio = o.Fecha_prevista_de_ingreso__c;
                }
                else {
                    contract.FechaInicio = o.Fecha_real_de_ingreso__c;
                    cpc1.FechaInicio = o.Fecha_real_de_ingreso__c;  
                }
              	Account pagador = [select id, cif_nif__c from account where id = :o.Pagador__c];
                contract.VAT_Registration_No_x = pagador.CIF_NIF__c; //PREGUNTAR CIF PAGADOR??
        
                Id idNoc = NULL;
                if(o.NOC__c != NULL) {
                    idNoc = o.NOC__c;
                }
                else if(o.NOC_11_Centro__c != NULL) {
                    idNoc = o.NOC_11_Centro__c;
                }
                else if(o.NOC_11_Persona__c != NULL) {
                    idNoc = o.NOC_11_Persona__c;
                }
                else if(o.NOC_12_Convenios__c != NULL) {
                    idNoc = o.NOC_12_Convenios__c;
                }
                //contract.FechaFinPNF = Date.parse('01/01/1753');
                contract.NOCFianza = ' ';
                if(idNoc != Null) {
                    //S'HA DE SELECCIONAR: Duracion_del_descuento__c
                    NOC__c naux = [SELECT Id,Fianza_a_cobrar__c,Tarifa_oficial__c,Importe_Fianza_a_cobrar__c,Precio_propuesto__c, Fecha_fin__c,Fecha_inicio__c, Name, Descuento_permanente__c,Duracion_del_descuento__c,Duracion_del_descuento_meses__c,recordtypeid,Fecha_Inicio_1__c,Fecha_Inicio_2__c,Fecha_Inicio_3__c,Fecha_Inicio_4__c,Fecha_Inicio_5__c,Fecha_Inicio_6__c,Fecha_Fin_1__c,Fecha_Fin_2__c,Fecha_Fin_3__c,Fecha_Fin_4__c,Fecha_Fin_5__c,Fecha_Fin_6__c,Importe_Mes_1__c,Importe_Mes_2__c,Importe_Mes_3__c,Importe_Mes_4__c,Importe_Mes_5__c,Importe_Mes_6__c FROM NOC__c WHERE Id = :idNoc];
                    contract.NOCFianza = naux.Name;
                    Decimal DuracionDescuento = 0;
                    //NOC 9 i NOC 12 mirem el descompte permanent
                    if(o.NOC__c != null || o.NOC_12_Convenios__c != null || o.NOC_11_Centro__c != null)
                    {	
                        if (naux.Duracion_del_descuento__c != null) {
                            DuracionDescuento = naux.Duracion_del_descuento__c;
                        }
                        else if (naux.Duracion_del_descuento_meses__c != null) {
                            DuracionDescuento = naux.Duracion_del_descuento_meses__c*30;
                        }
                        //if(!naux.Descuento_permanente__c) naux.Fecha_fin__c = o.Fecha_real_de_ingreso__c.addYears(1);
                        if(!naux.Descuento_permanente__c) {
                            if (DuracionDescuento != null && DuracionDescuento != 0) {
                        		naux.Fecha_fin__c = o.Fecha_prevista_de_ingreso__c.addDays(DuracionDescuento.intValue());
                        	}
                        	cpc1.FechaFin = naux.Fecha_fin__c;
                            tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc2 = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                			cpc2.Precio = o.Precio__c;
                            if (o.Precio_Plus__c != null) {
                                cpc2.Precio = o.Precio__c+o.Precio_Plus__c;
                            }
                            cpc2.FechaInicio = cpc1.fechaFin.addDays(1);
                            listacpc1.add(cpc1);
                            listacpc1.add(cpc2);
                        }
                        else {
                            listacpc1.add(cpc1);
                        }
                            
                    }
                    contract.ContractPriceConditions = listacpc1;
                    //Si la NOC es personal puntual y tiene el campo fianza a cobrar informado le pasamos este campo a Navision
                    System.debug('AQUI arribes');
                    if (o.NOC_11_Persona__c != null) {
                        
                        System.debug('ENTRA1');
                        if (naux.Fianza_a_cobrar__c != null || naux.Importe_Fianza_a_cobrar__c != null) {
                            if (naux.Importe_Fianza_a_cobrar__c != null) {
                                contract.PrecioFianza = naux.Importe_Fianza_a_cobrar__c;
                            }
                            else if (naux.Fianza_a_cobrar__c != null) {
                                if (naux.Importe_Mes_1__c != null) {
                                    contract.PrecioFianza = (naux.Fianza_a_cobrar__c*naux.Importe_Mes_1__c)/100;
                                }
                                else if (naux.Precio_propuesto__c != null) {
                                    contract.PrecioFianza = (naux.Fianza_a_cobrar__c*naux.Precio_propuesto__c)/100;
                                }
                                
                            }  
                        }
                        List<tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions> listacpc = new List<tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions>();
                        if (naux.Importe_Mes_1__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                                if (naux.Fecha_Inicio_1__c != null && naux.Fecha_Fin_1__c != null) {
                                    System.debug('ARRIBES10');
                                    if (o.Precio_Ofertado__c != null || o.Descuento_Ofertado__c != null) {
                                        cpc.Precio = o.Precio_Total__c;
                                    }
                                    else {
                                        cpc.Precio = naux.Importe_Mes_1__c;
                                    }
                                		cpc.FechaInicio = naux.Fecha_Inicio_1__c;
                                		cpc.FechaFin = naux.Fecha_Fin_1__c;
                                    System.debug('ARRIBES11');
                                    listacpc.add(cpc);
                                }
                            System.debug('ARRIBES02');
                        }
                        if (naux.Importe_Mes_2__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                                if (naux.Fecha_Inicio_2__c != null && naux.Fecha_Fin_2__c != null) {
                                    	cpc.Precio = naux.Importe_Mes_2__c;
                                		cpc.FechaInicio = naux.Fecha_Inicio_2__c;
                                		cpc.FechaFin = naux.Fecha_Fin_2__c;
                                    listacpc.add(cpc);
                                }
                        }
                        if (naux.Importe_Mes_3__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                                if (naux.Fecha_Inicio_3__c != null && naux.Fecha_Fin_3__c != null) {
                                    	cpc.Precio = naux.Importe_Mes_3__c;
                                		cpc.FechaInicio = naux.Fecha_Inicio_3__c;
                                		cpc.FechaFin = naux.Fecha_Fin_3__c;
                                    listacpc.add(cpc);
                                }
                        }
                        if (naux.Importe_Mes_4__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                                if (naux.Fecha_Inicio_4__c != null && naux.Fecha_Fin_4__c != null) {
                                    	cpc.Precio = naux.Importe_Mes_4__c;
                                		cpc.FechaInicio = naux.Fecha_Inicio_4__c;
                                		cpc.FechaFin = naux.Fecha_Fin_4__c;
                                    listacpc.add(cpc);
                                } 
                        }
                        if (naux.Importe_Mes_5__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                                if (naux.Fecha_Inicio_5__c != null && naux.Fecha_Fin_5__c != null) {
                                    	cpc.Precio = naux.Importe_Mes_5__c;
                                		cpc.FechaInicio = naux.Fecha_Inicio_5__c;
                                		cpc.FechaFin = naux.Fecha_Fin_5__c;
                                    listacpc.add(cpc);
                                }
                        }
                        if (naux.Importe_Mes_6__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                                if (naux.Fecha_Inicio_6__c != null && naux.Fecha_Fin_6__c != null) {
                                    	cpc.Precio = naux.Importe_Mes_6__c;
                                		cpc.FechaInicio = naux.Fecha_Inicio_6__c;
                                		cpc.FechaFin = naux.Fecha_Fin_6__c;
                                    listacpc.add(cpc);
                                }
                        }
                        if (naux.Precio_propuesto__c != null) {
                            tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                            if (naux.Descuento_permanente__c == true) {
                                cpc.Precio = naux.Precio_propuesto__c;
                                
                                if (o.Fecha_prevista_de_ingreso__c != null) {
                                    cpc.FechaInicio = o.Fecha_prevista_de_ingreso__c;
                                }
                                listacpc.add(cpc);
                            }
                            else {
                                if (naux.Fecha_inicio__c != null && naux.Fecha_fin__c != null) {
                                    	cpc.Precio = naux.Precio_propuesto__c;
                                		cpc.FechaInicio = o.Fecha_prevista_de_ingreso__c;
                                		cpc.FechaFin = naux.Fecha_fin__c;
                                    listacpc.add(cpc);
                                }
                            } 
                        }
                        if (listacpc.size() > 0 && naux.Descuento_permanente__c == false) {
                            System.debug('ARRIBAAAAAAAAAAAAAS');
                            tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc3 = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                            DateTime DataIniciUltim = listacpc[listacpc.size()-1].FechaFin;
                            System.debug('ARRIBAAAAAAAAAAAAAS2');
                            cpc3.Precio = o.Precio__c;
                            if (o.Precio_Plus__c != null) {
                                cpc3.Precio = o.Precio__c+o.Precio_Plus__c;
                            }
                            System.debug('ARRIBAAAAAAAAAAAAAS3');
                            System.debug('fecha inicio ultima: '+DataIniciUltim);
                            cpc3.FechaInicio = DataIniciUltim.addDays(1);
                            System.debug('ARRIBAAAAAAAAAAAAAS4');
                            listacpc.add(cpc3);
                        }
                        else if (listacpc.size() == 0) {
                            tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions cpc3 = new tempuriOrgSarBackofficeinterfaceWcf2.ContractPriceConditions();
                            cpc3.Precio = o.Precio__c;
                            cpc3.FechaInicio = naux.fecha_inicio__c;
                            if (naux.Descuento_permanente__c == false) {
                                cpc3.FechaFin = naux.Fecha_fin__c;
                            }
                            listacpc.add(cpc3);
                        }
                        //System.debug(listacpc[0]);
                        contract.ContractPriceConditions = listacpc;
                    }
                    
                    //System.debug('Duracion Descuento: '+DuracionDescuento);
                    //System.debug('Fecha fin descuento: '+naux.Fecha_fin__c);
                   // if(naux.Fecha_fin__c != null) contract.FechaFinPNF = naux.Fecha_fin__c;
                    
                }
                else {
                    listacpc1.add(cpc1);
					contract.ContractPriceConditions = listacpc1;                    
                }
                
                contract.IBAN = o.IBAN__c;
                Account aaux = [Select Id, IdNAV_RES__c FROM Account WHERE Id = :o.Residente__c];
                if(aaux != null) contract.ResidentNo = aaux.IdNAV_RES__c;
                //Account aaux2 = [Select Id, IdNAV_CL__c FROM Account WHERE Id = :o.Pagador__c];
                //if(aaux2 != null) 
                contract.CustomerNo = '';//c.IdNAV_CL__c;
                if(o.No_Finanza__c == true) contract.Fianza = (!o.No_Finanza__c);
                else contract.Fianza = true;
                contract.Cod_Centro = [Select Id, IdNAV__c, Name FROM Account WHERE Id = :o.Centro2__c].IdNAV__c;
                if(o.Tipo_de_tarifa__c != null) contract.Tipo_Tarifa = CalloutNavisionWS.getPosition(TTList, o.Tipo_de_tarifa__c)-1;
                if(o.Tipo_de_cobro__c != null) contract.Tipo_Cobro = CalloutNavisionWS.getPosition(TCList, o.Tipo_de_cobro__c)-1;
                if(o.Tipo_de_pago__c != null) contract.Tipo_Pago = CalloutNavisionWS.getPosition(TPList, o.Tipo_de_pago__c)-1;
                if(o.Institucion__c != null) {
                    Account iaux = [Select Id, IdNAV__c FROM Account WHERE Id = :o.Institucion__c];
                    contract.Institucion = iaux.IdNAV__c;
                }

                contract.PaymentMethod = codigoFormaPago;
                contract.ExternalContractID = o.Id;
                contract.SourceAppUser = o.LastModifiedBy.Name;
                contract.SourceApp = 'SF';
                tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessage rmCont = new tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessage();
                tempuriOrg2.basicEndpoint WS2 = new tempuriOrg2.basicEndpoint();
                system.debug('contract to create: ' + contract);
                if (!Test.isRunningTest()) {
                	rmCont = WS2.createContract(contract);    
                } else {
                    rmCont.Code = 'TEST';
                }
                
                String codigo = rmCont.Code;
                System.debug('CODIGO CONTRATO: '+codigo);
                String result2 = rmCont.Level;
                String message2 = rmCont.Message;
                System.debug('MENSAJE CONTRATO: '+message2);              
                
               
               if(result2 != 'info') {
                    Boolean trobat = false;
                    if (message2.contains('Read timed out')) {
                        for (Integer cont = 0;cont < 3 && !trobat; ++cont) {
                            Long startingTime = System.now().getTime(); // Num milliseconds since Jan 1 1970
							Integer delayInMilliseconds = 30000; // One-second delay
                            while (System.now().getTime() - startingTime < delayInMilliseconds) {
                                        // Do nothing until desired delay has passed
                            }
                           rmCont = WS2.createContract(contract);
                            result2 = rmCont.Level;
                            if (result2.contains('info')) {
                                trobat = true;
                                result2 = rmCont.Level;
                                message2 = rmCont.Level;
                            }
                        }
                    }
                    if (!trobat) {
                        mailBody += 'Error en la creación del contrato (createContract) en Navision: https://sarquavitae.my.salesforce.com/' + op + '\nResultado: ' + result2 + ' ' + message2 + '\n';
                    }
                    
               	}
                triggerhelper.recursiveHelper5(false);
            } catch(exception e) {
                mailBody += 'Error en la creación de cliente (createCustomer) en Navision: https://sarquavitae.my.salesforce.com/' + op + '\nResultado: ' + e + '\n';
            }
            
            triggerhelper.recursiveHelper7(true);
            update c;
            if(mailBody != '') triggerhelper.sendMail(mailBody, new List<String>{creator.Email}, 'https://sarquavitae.my.salesforce.com/' + op);
            triggerhelper.recursiveHelper7(false);
        } catch(Exception e) {
            triggerhelper.setTodoFalse();
            triggerhelper.sendMail('Error en la creación o modificación de oportunidad en GCR o Navision: https://sarquavitae.my.salesforce.com/' + op + '\nRespuesta: ' + e , new List<String>{creator.Email}, 'https://sarquavitae.my.salesforce.com/' + op);
        }   
    }
    
    //Se crea el residente con codigo salesforce res en navision 
    @future (callout=true)
    public static void createResident(Id res) {
 		  Account r = [Select Id, FirstName, LastName, PersonMobilePhone, CreatedById, Estado_Civil__c, No_tiene_telefono__c, Provincia__c, No_tiene_correo_electronico__c, Phone, Calle__c, IdNAV_RES__c, Tipo_Documento_Identidad__c, Tipo_Documento_Sanitario__c, CIF_NIF__c,Ciudad__c, Pais__c, Codigo_postal__c, PersonBirthdate, PersonEmail, Nuermo_Documento_Sanitario__c, Sexo__c, IdGCR__c, lastmodifiedbyid From Account Where Id = :res];
        User creator = [Select Id, Email from User where id = :r.lastmodifiedbyid];
        String mailbody = '';
        try {
            triggerhelper.recursiveHelper6(true);
            Schema.DescribeFieldResult fieldSexo = account.Sexo__c.getDescribe();
            List<Schema.PicklistEntry> sexList = fieldSexo.getPicklistValues();
            
            Schema.DescribeFieldResult fieldTDS = account.Tipo_Documento_Sanitario__c.getDescribe();
            List<Schema.PicklistEntry> tdsList = fieldTDS.getPicklistValues();
            
            Schema.DescribeFieldResult fieldTDI = account.Tipo_Documento_Identidad__c.getDescribe();
            List<Schema.PicklistEntry> tdiList = fieldTDI.getPicklistValues();     
            

            
            String[] surnames = triggerHelper.sepLastName(r.LastName);
                
            if(r.Calle__c == null) r.Calle__c = ' ';
            if(r.Ciudad__c == null) r.Ciudad__c = ' ';
            if(r.Pais__c == null) r.Pais__c = ' ';
            if(r.Provincia__c == null) r.Provincia__c = ' ';
            
            try {
                //create resident and ws callout
                tempuriOrg2.ResidentRequestAsync rr1 = new tempuriOrg2.ResidentRequestAsync();
               	rr1.ExternalID = r.id;
                rr1.OportunityID = '';
                rr1.First_Name = r.FirstName;
                rr1.Middle_Name = surnames[0];
                rr1.Surname = surnames[1];
                rr1.Tipo_via = 1;
                rr1.Nombre_calle = r.Calle__c;
                rr1.Numero = '';
                rr1.Bloque = '';
                rr1.Escalera = '';
                rr1.Piso = '';
                rr1.Puerta = '';
                rr1.City = r.Ciudad__c;
                rr1.Country = r.Pais__c;
                if(r.Phone != null) rr1.Phone_No_x = r.Phone;
                else rr1.Phone_No_x = '';
                rr1.VAT_Registration_No_x = r.CIF_NIF__c;
                rr1.Post_Code = r.Codigo_postal__c;
                if(r.PersonEmail != null) rr1.E_Mail = r.PersonEmail;
                else rr1.E_Mail = '';
                rr1.Fecha_nacimiento = r.PersonBirthdate;
                rr1.Sexo = CalloutNavisionWS.getPosition(sexList, r.Sexo__c);
                if (r.Tipo_Documento_Sanitario__c != null) {
                	rr1.Tipo_documento_sanitario = CalloutNavisionWS.getPosition(tdsList, r.Tipo_Documento_Sanitario__c);
                	if(rr1.Tipo_documento_sanitario == null) rr1.Tipo_documento_sanitario = 5;
            	}
                else {
                    rr1.Tipo_documento_sanitario = 0;
                }
                rr1.Documento_sanitario = r.Nuermo_Documento_Sanitario__c;
                rr1.Tipo_documento = CalloutNavisionWS.getPosition(tdiList, r.Tipo_Documento_Identidad__c);
                rr1.SourceAppUser = r.LastModifiedById;
                rr1.SourceApp = 'SF';
                rr1.Residencial_Adoreas = 1;    
                
                tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessageAsync rmidResN1 = new tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessageAsync();
                tempuriOrg2.basicEndpoint WS1 = new tempuriOrg2.basicEndpoint();
              	System.debug('Callout starts here');
                rmidResN1 = WS1.CreateResidentAsync(rr1);
                Boolean success = rmidResN1.Result;
                String result = rmidResN1.Level;
                String message = rmidResN1.Message;
                if (success == null) System.debug('No response from Navision WS');
                if (!success) {
                    mailBody += 'Error en la actualización del residente en Navision\n';
                    System.debug('NAVISION WS CALLOUT FAILED');
                    System.debug(mailbody);
                }
                else {
                   System.debug('SUCCESS!!! SUCCESS!!!');
                   System.debug('RESULT: '+result);
                   System.debug('MESSAGE: '+message);
                }
            } catch(Exception e) {
                mailBody += 'En';
            }
            
            triggerhelper.recursiveHelper6(false);

        }
        catch (Exception e) {
            triggerhelper.setTodoFalse();
            triggerhelper.sendMail('Error en la actualización del residente en Navision', new List<String> {creator.Email}, 'https://sarquavitae.my.salesforce.com/' + res);
        }
    }
    
    Webservice static void reenvioPreIngresoWS(Id opc, String modName) {
        Oportunidad_platform__c o = [Select Id, Pagador__c, Residente__c From Oportunidad_platform__c Where Id = :opc];
        createPreIngreso(o.Residente__c, o.Pagador__c, o.id, modName, false);
        System.debug('He hecho reenvio preingreso');
    }
    
    //Se crea el residente con codigo salesforce res en navision 
    @future (callout=true)
    public static void createPreIngreso(Id res, Id con, Id opc, String modName, Boolean reenvio) {
        //Add code to perform callout
        System.debug('LAST MODIFIED BY: '+modName);
        Account r = [Select Id, FirstName, LastName, PersonMobilePhone, CreatedById, Estado_Civil__c, No_tiene_telefono__c, Provincia__c, No_tiene_correo_electronico__c, Phone, Calle__c, IdNAV_RES__c, Tipo_Documento_Identidad__c, Tipo_Documento_Sanitario__c, CIF_NIF__c,Ciudad__c, Pais__c, Codigo_postal__c, PersonBirthdate, PersonEmail, Nuermo_Documento_Sanitario__c, Sexo__c, IdGCR__c From Account Where Id = :res];
        Oportunidad_platform__c opc2 =[Select Id, Name, CreatedById, OwnerId, Tipo_de_Financiacion__c, Precio_Total__c, Tipo_de_cobro__c, Centro2__c, IdGCR_EPS__c, Residente__c, Servicio__c From Oportunidad_platform__c Where Id = :opc];
        Servicio__c sc = [Select Id, Name, Tipo_Servicio__c From Servicio__c Where Id = :opc2.Servicio__c];
        Account cent = [Select Id, Name, Division__c, IdNAV__c From Account Where Id = :opc2.Centro2__c];
        User creator = [Select Id, Name, Email From User Where Id = :opc2.OwnerId]; 
        String mailBody = '';
        
        try {
            triggerhelper.recursiveHelper6(true);
            Schema.DescribeFieldResult fieldSexo = account.Sexo__c.getDescribe();
            List<Schema.PicklistEntry> sexList = fieldSexo.getPicklistValues();
            
            Schema.DescribeFieldResult fieldTDS = account.Tipo_Documento_Sanitario__c.getDescribe();
            List<Schema.PicklistEntry> tdsList = fieldTDS.getPicklistValues();
            
            Schema.DescribeFieldResult fieldTDI = account.Tipo_Documento_Identidad__c.getDescribe();
            List<Schema.PicklistEntry> tdiList = fieldTDI.getPicklistValues();     
            

            
            String[] surnames = triggerHelper.sepLastName(r.LastName);
                
            if(r.Calle__c == null) r.Calle__c = ' ';
            if(r.Ciudad__c == null) r.Ciudad__c = ' ';
            if(r.Pais__c == null) r.Pais__c = ' ';
            if(r.Provincia__c == null) r.Provincia__c = ' ';
            
            try {
                //create resident and ws callout
               
                tempuriOrg2.ResidentRequestAsync rr1 = new tempuriOrg2.ResidentRequestAsync();
          		rr1.ExternalID = r.id;
                if(!reenvio) rr1.OportunityID = opc;
                rr1.First_Name = r.FirstName;
                rr1.Middle_Name = surnames[0];
                rr1.Surname = surnames[1];
                rr1.Tipo_via = 1;
                rr1.Nombre_calle = r.Calle__c;
                rr1.Numero = '';
                rr1.Bloque = '';
                rr1.Escalera = '';
                rr1.Piso = '';
                rr1.Puerta = '';
                rr1.City = r.Ciudad__c;
                rr1.Country = r.Pais__c;
                if(r.Phone != null) rr1.Phone_No_x = r.Phone;
                else rr1.Phone_No_x = '';
                rr1.VAT_Registration_No_x = r.CIF_NIF__c;
                rr1.Post_Code = r.Codigo_postal__c;
                if(r.PersonEmail != null) rr1.E_Mail = r.PersonEmail;
                else rr1.E_Mail = '';
                rr1.Fecha_nacimiento = r.PersonBirthdate;
                rr1.Sexo = CalloutNavisionWS.getPosition(sexList, r.Sexo__c);
                if (r.Tipo_Documento_Sanitario__c != null) {
                	rr1.Tipo_documento_sanitario = CalloutNavisionWS.getPosition(tdsList, r.Tipo_Documento_Sanitario__c);
                	if(rr1.Tipo_documento_sanitario == null) rr1.Tipo_documento_sanitario = 5;
            	}
                else {
                    rr1.Tipo_documento_sanitario = 0;
                }
                rr1.Documento_sanitario = r.Nuermo_Documento_Sanitario__c;
                rr1.Tipo_documento = CalloutNavisionWS.getPosition(tdiList, r.Tipo_Documento_Identidad__c);
                rr1.SourceAppUser = modName;
                rr1.SourceApp = 'SF';
                rr1.Residencial_Adoreas = (cent.Division__c == 'Adorea') ? 2:1;               
                system.debug('resident to create: ' + rr1);
                tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessageAsync rmidResN1 = new tempuriOrgSarBackofficeinterfaceWcf2.ReturnMessageAsync();
                tempuriOrg2.basicEndpoint WS1 = new tempuriOrg2.basicEndpoint();
              	System.debug('Callout starts here');
                try {
                	rmidResN1 = WS1.CreateResidentAsync(rr1);    
                } catch (Exception e) {
                    System.debug(e.getMessage());
                }
                
                Boolean success = rmidResN1.Result;
                String result = rmidResN1.Level;
                String message = rmidResN1.Message;
                if (success == null) System.debug('No response from Navision WS');
                if (!success) {
                    mailBody += 'Error en la creación de residente (createResident) en Navision: https://sarquavitae.my.salesforce.com/' + opc + ' \nResultado: ' + result + ' '+ message + '\n';
                    System.debug('NAVISION WS CALLOUT FAILED');
                    System.debug(mailbody);
                }
                else {
                   System.debug('SUCCESS!!! SUCCESS!!!');
                   System.debug('RESULT: '+result);
                   System.debug('MESSAGE: '+message);
                }
            } catch(Exception e) {
                mailBody += 'Error en la creación de residente (createResident) en Navision: https://sarquavitae.my.salesforce.com/' + opc + ' \nResultado: ' + e + '\n';
            }
            
            triggerhelper.recursiveHelper6(false);
            
            triggerhelper.recursiveHelper3(true);
			if(mailBody != '') triggerhelper.sendMail(mailBody, new List<String> {creator.Email}, 'https://sarquavitae.my.salesforce.com/' + opc);
            triggerhelper.recursiveHelper3(false);
        }
        catch (Exception e) {
            triggerhelper.setTodoFalse();
            triggerhelper.sendMail('Error en la integración con los WebServices GCR o NAV https://sarquavitae.my.salesforce.com/' + opc + ' ' + e, new List<String> {creator.Email}, 'https://sarquavitae.my.salesforce.com/' + opc);
        }
    }
    
    
    //Se crea el residente con codigo salesforce res en navision 
    @future (callout=true)
    public static void createServicio(Id ser) {
        try {
            Servicio__c s = [Select Id, Name, Grado_Dependencia__c, Tipo_Servicio__c, Transporte__c, Tipo_Ocupacion__c, Tipo_Estancia__c From Servicio__c Where Id = :ser];
            tempuriOrgSarBackofficeinterfaceWcf2.ServiceRequest sr = new tempuriOrgSarBackofficeinterfaceWcf2.ServiceRequest();
            sr.GradoDependencia = s.Grado_Dependencia__c;
            sr.ServicioNo = s.Id;
            sr.TipoEstancia = s.Tipo_Estancia__c;
            sr.TipoOcupacion = s.Tipo_Ocupacion__c;
            sr.TipoServicio = s.Tipo_Servicio__c;
            sr.Nombre = s.Name;
            if(s.Transporte__c == 'Si') sr.Transporte = true;
            else sr.Transporte = false;
            system.debug('service to create: ' + sr);
             
            tempuriOrg2.basicEndpoint WS = new tempuriOrg2.basicEndpoint();
            WS.createService(sr);
        }
        catch (Exception e) {
            triggerhelper.sendMail('Error en la llamada createService al WebService NAV: Exception https://sarquavitae.my.salesforce.com/' + ser + ' Error: ' + e.getMessage() + ' ' + e.getStackTraceString());
            system.debug('error en la llamada');
        }
    }
}