/** 
* File Name:   CalloutT24WebService 
* Description: Classe encargada de realizar la conexion con T24
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version    Date        Author           Modification 
* 01        14/05/2015  Xavier Garcia
* =============================================================== 
**/ 
global class CalloutT24WebService {
    public static void insertar_beneficiario(Id relacionBeneficiario) {
        List<Relacion_entre_contactos__c> relaciones = [Select oportunidad__c from Relacion_entre_contactos__c where id =:relacionBeneficiario and Activo__c = true and oportunidad__r.Id_VIV_T24__c != null and oportunidad__r.etapa__c = 'Cerrada ganada' and oportunidad__r.recordtypeid = '012b0000000QIDZ'];
        if (relaciones.size() > 0) {
            crear_beneficiario(relaciones[0].Oportunidad__c);
        }
    }
    
    public static void modificacion_cuenta(Id beneficiario) {
        List<Relacion_entre_contactos__c> relaciones = [Select oportunidad__c from Relacion_entre_contactos__c where beneficiario__c =:beneficiario and Activo__c = true and oportunidad__r.Id_VIV_T24__c != null and oportunidad__r.recordtypeid = '012b0000000QIDZ'];
        System.debug('MODIF.CUENTA!!');
        if (relaciones.size() > 0) {
            System.debug('CRIDA A CREAR_BENEFICIARIOSI');
            crear_beneficiario(relaciones[0].Oportunidad__c);
        }
    }
    
    Webservice static void crear_beneficiarioWS(Id op) {
        crear_beneficiario(op);
    }
    
    //Funcion que llama al WS para crear o actualizar los beneficiarios en T24
    @future (callout=true)
    public static void crear_beneficiario(Id op) {
        Try {
        Datetime ara = Datetime.now();
        //Peticion = Fecha+Hora actual
        String peticion = String.valueOf(ara);
        //Cogemos todos los datos de la op que enviaremos
        Oportunidad_platform__c oportunidad = [SELECT id,Historico__c,idLinia__c,IVA_del_dispositivo__c,Precio_Dispositivo__c,Servicio__r.Tipo_de_dispositivos__c,Empresa_Recomendadora__c,Empresa_Recomendadora__r.name,Servicio__c,Servicio__r.name,Precio_sin_colgante__c,Precio_Colgantes__c,IVA__c,Precio_Servicio__c,central__c,central__r.name,NOC__c,NOC_12_Convenios__c,IBAN__c,Id_VIV_T24__c from Oportunidad_platform__c where id =: op];
        //Guardamos en una variable la BD que enviaremos (Madrid o sevilla)
        String BD = oportunidad.Central__r.name;
        if (BD == 'SEVILLA NACIONAL') {
            BD = 'SEVILLA';
        }
        String t24_colectivo = '';
        List<id> idNocs = new List<id>();
        id idNoc;
        //Nos guardamos en una lista de id las Nocs relacionadas con la op
        if (oportunidad.NOC_12_Convenios__c != null) {
            //idNocs.add(oportunidad.NOC_12_Convenios__c);
            idNoc = oportunidad.NOC_12_Convenios__c;
        }
        else if (oportunidad.NOC__c != null) {
            //idNocs.add(oportunidad.NOC__c);
            idNoc = oportunidad.NOC__c;
        }
        Noc__c NocDescuento = new Noc__c();
        Centros_NOC__c liniaNoc = new Centros_NOC__c();
        if (idNoc != null) {
            NocDescuento = [SELECT id,Duracion_del_descuento__c,Duracion_del_descuento_meses__c,fecha_inicio__c,fecha_fin__c from Noc__c where id =: idNoc];
            if (oportunidad.idLinia__c != null) {
                liniaNoc = [Select Tarifa_Ta__c,Descuento_permanente_1__c,Descuento_permanente_2__c,Descuento_permanente_3__c,Importe_Periodo_1__c,Importe_Periodo_2__c,Importe_Periodo_3__c,Descuento_Periodo_2__c,Descuento_Periodo_3__c,Descuento_Periodo_1__c,Duracion_Periodo_1__c,Duracion_Periodo_2__c,Duracion_Periodo_3__c from Centros_NOC__c where id =:oportunidad.idLinia__c limit 1];
            }  
        }
        //Nos guardamos en una lista de Nocs toda la info de las Noc relacionada con la op
        //List<Noc__c> Nocs = [SELECT id,Duracion_del_descuento__c,Duracion_del_descuento_meses__c,fecha_inicio__c,fecha_fin__c from Noc__c where id IN:idNocs];
        
        Map<id,Relacion_entre_contactos__c> BeneficiariosActivos = new Map<id,Relacion_entre_contactos__c>();
        //Obtenemos todos los beneficiarios activos relacionados con la op
        List<Relacion_entre_contactos__c> Relaciones = [Select id,oportunidad__c,Usuario_principal__c,Beneficiario_con_colgante__c,Beneficiario_sin_colgante__c,Activo__c,Pagador__c,beneficiario__c,beneficiario__r.phone from Relacion_entre_contactos__c where oportunidad__c =:op and Activo__c = true];
        //Para cada beneficiario nos guardamos en un map la asociacion idCuenta-Relacion
        Integer NumColgantes = 0;
        Integer NumSinColgantes = 0;
        String Tel_viv;
        for (Relacion_entre_contactos__c rel:Relaciones) {
            if (rel.Usuario_principal__c) {
                Tel_viv = rel.Beneficiario__r.phone;
            }
            BeneficiariosActivos.put(rel.beneficiario__c,rel);
            if (rel.Beneficiario_con_colgante__c) {
                NumColgantes++;
            }
            if (rel.Beneficiario_sin_colgante__c) {
                NumSinColgantes++;
            }
        }
        
        List<interT24Sf.USUARIORequest> usuarios = new List<interT24Sf.USUARIORequest>();
        //Para cada beneficiario, le pasaremos la informacion a T24.
        for (Account beneficiario:[Select id,CIF_NIF__c,phone,PersonMobilePhone,firstName,LastName,Codigo_postal__c,Calle__c,Ciudad__c,Provincia__c,Pais__c,Comunidad_Autonoma__c,estado_fisico__c,estado_cognitivo__c from Account where id IN:BeneficiariosActivos.keySet()]) {
            if (BeneficiariosActivos.get(beneficiario.id) != null) {
                if (BeneficiariosActivos.get(beneficiario.id).Pagador__c) {
                    interT24Sf.USUARIORequest usuario = new interT24Sf.USUARIORequest();
                    System.debug('ES PAGADOR');
                    //Pasar los campos exclusivos del pagador
                    usuario.VIV_CALLE = beneficiario.Calle__c;
                    usuario.VIV_CPOSTAL = beneficiario.Codigo_postal__c;
                    usuario.VIV_POBLACION = beneficiario.Ciudad__c;
                    usuario.VIV_PROVINCIA = beneficiario.Provincia__c;
                    usuario.IBAN = oportunidad.IBAN__c;
                    usuario.USU_TIPO = '99';
                    usuario.VIV_TELEFONO = Tel_viv;
                    usuario.CUENTA = beneficiario.id;
                    usuario.REL_BENEFICIARIO = BeneficiariosActivos.get(beneficiario.id).id;
                    usuario.NIF = beneficiario.CIF_NIF__c;
                    usuario.NOMBRE = beneficiario.firstName;
                    usuario.APELLIDO1 =beneficiario.LastName;
                    usuario.APELLIDO2 = '';
                    if (beneficiario.PersonMobilePhone != null) {
                        usuario.TEL_MOV = beneficiario.PersonMobilePhone;
                    }
                    else {
                        usuario.TEL_MOV = beneficiario.phone;
                    }
                    usuario.SIT_FISICA = beneficiario.estado_fisico__c;
                    usuario.SIT_PSIQUICA = beneficiario.estado_cognitivo__c;
                    usuario.DISPOSITIVO_NOMBRE = oportunidad.Servicio__r.Tipo_de_dispositivos__c;
                    usuario.DISPOSITIVO_PRECIO = oportunidad.Precio_Dispositivo__c;
                    usuario.DISPOSITIVO_IVA = oportunidad.IVA_del_dispositivo__c;
                    
                    
                    usuario.TARIFA_IVA = oportunidad.IVA__c;
                    usuario.TARIFA_DOM = oportunidad.Precio_Servicio__c;
                    if (oportunidad.Precio_Colgantes__c != null) {
                        usuario.TARIFA_BEN_CUCR = oportunidad.Precio_Colgantes__c/NumColgantes;
                    }
                    if (oportunidad.Precio_sin_colgante__c != null) {
                        usuario.TARIFA_BEN_SUCR = oportunidad.Precio_sin_colgante__c/NumSinColgantes;
                    }
                    if (idNoc != null && oportunidad.idLinia__c != null ) {
                       // if (liniaNoc.Descuento_Periodo_1__c == null)usuario.DTO1 = ;
                       Decimal d1 = liniaNoc.Importe_Periodo_1__c;
                        Decimal d2 = liniaNoc.Importe_Periodo_2__c;
                        Decimal d3 = liniaNOc.Importe_Periodo_3__c;
                  
                       usuario.DTO1 = (liniaNoc.Descuento_Periodo_1__c == null)? 1.0-d1.divide(oportunidad.Precio_Servicio__c, 2): liniaNoc.Descuento_Periodo_1__c;
                        
                        //Si hay descuento permanente los otros periodos tendran descuento 0
                        if(liniaNoc.Descuento_permanente_1__c) {
                            usuario.DTO2 = 0;
                            usuario.DTO3 = 0;
                        } else {
                            //informamos el descuento del periodo 2
                            usuario.DTO2 = (liniaNoc.Descuento_Periodo_2__c == null)? 1.0-d2.divide(oportunidad.Precio_Servicio__c, 2) : liniaNoc.Descuento_Periodo_2__c;
                            //Si no hay descuento permanente informamos el descuento del periodo 3
                            if(!liniaNoc.Descuento_permanente_2__c) {
                                usuario.DTO3 = (liniaNoc.Descuento_Periodo_3__c == null)? 1.0-d1.divide(oportunidad.Precio_Servicio__c, 2) : liniaNoc.Descuento_Periodo_3__c;
                            }
                        }
                      
                        
                        /*usuario.DTO4 = 2;*/
                      /*  usuario.DTO5 = 2;
                        usuario.DTO6 = 2;*/
                        if (liniaNoc.Descuento_permanente_1__c) {
                            usuario.DTO_DIAS1 = 0;
                        }
                        else {
                            if (liniaNoc.Duracion_Periodo_1__c !=null) {
                                usuario.DTO_DIAS1 = liniaNoc.Duracion_Periodo_1__c.intValue();
                            }
                        }
                        if (liniaNoc.Descuento_permanente_2__c) {
                            usuario.DTO_DIAS2 = 0;
                        }
                        else {
                            if (liniaNoc.Duracion_Periodo_2__c != null) {
                                usuario.DTO_DIAS2 = liniaNoc.Duracion_Periodo_2__c.intValue();
                            }
                        }
                        if (liniaNoc.Descuento_permanente_3__c) {
                            usuario.DTO_DIAS2 = 0;
                        }
                        else {
                            if (liniaNoc.Duracion_Periodo_3__c != null) {
                                usuario.DTO_DIAS3 = liniaNoc.Duracion_Periodo_3__c.intValue();
                            }
                        }
                        
                        /*usuario.DTO_DIAS4 = 2;
                        usuario.DTO_DIAS5 = 2;
                        usuario.DTO_DIAS6 = 2;*/                       
                    }
                   
                    usuarios.add(usuario);
                }
                if (BeneficiariosActivos.get(beneficiario.id).Usuario_principal__c) {
                    interT24Sf.USUARIORequest usuario = new interT24Sf.USUARIORequest();
                    System.debug('ES USUARIO PRINCIPAL');
                    //Pasar los campos exclusivos del usuario principal
                    usuario.VIV_CALLE = beneficiario.Calle__c;
                    usuario.VIV_CPOSTAL = beneficiario.Codigo_postal__c;
                    usuario.VIV_POBLACION = beneficiario.Ciudad__c;
                    usuario.VIV_PROVINCIA = beneficiario.Provincia__c;
                    usuario.USU_TIPO = '01';
                    usuario.VIV_TELEFONO = Tel_viv;
                    usuario.CUENTA = beneficiario.id;
                    usuario.REL_BENEFICIARIO = BeneficiariosActivos.get(beneficiario.id).id;
                    usuario.NIF = beneficiario.CIF_NIF__c;
                    usuario.NOMBRE = beneficiario.firstName;
                    usuario.APELLIDO1 =beneficiario.LastName;
                    usuario.APELLIDO2 = '';
                    usuario.TEL_MOV = beneficiario.PersonMobilePhone;
                    usuario.SIT_FISICA = beneficiario.estado_fisico__c;
                    usuario.SIT_PSIQUICA = beneficiario.estado_cognitivo__c;
                    usuarios.add(usuario);
                }
                if (BeneficiariosActivos.get(beneficiario.id).Beneficiario_con_colgante__c) {
                    interT24Sf.USUARIORequest usuario = new interT24Sf.USUARIORequest();
                    System.debug('ES beneficiario CON colgante');
                    usuario.USU_TIPO = '10';
                    usuario.CUENTA = beneficiario.id;
                    usuario.REL_BENEFICIARIO = BeneficiariosActivos.get(beneficiario.id).id;
                    usuario.NIF = beneficiario.CIF_NIF__c;
                    usuario.NOMBRE = beneficiario.firstName;
                    usuario.APELLIDO1 =beneficiario.LastName;
                    usuario.APELLIDO2 = '';
                    usuario.TEL_MOV = beneficiario.PersonMobilePhone;
                    usuario.SIT_FISICA = beneficiario.estado_fisico__c;
                    usuario.SIT_PSIQUICA = beneficiario.estado_cognitivo__c;
                    usuario.VIV_TELEFONO = Tel_viv;
                    usuarios.add(usuario);
                }
                if (BeneficiariosActivos.get(beneficiario.id).Beneficiario_sin_colgante__c) {
                    interT24Sf.USUARIORequest usuario = new interT24Sf.USUARIORequest();
                    System.debug('ES beneficiario SIN colgante');
                    usuario.USU_TIPO = '20';
                    usuario.CUENTA = beneficiario.id;
                    usuario.REL_BENEFICIARIO = BeneficiariosActivos.get(beneficiario.id).id;
                    usuario.NIF = beneficiario.CIF_NIF__c;
                    usuario.NOMBRE = beneficiario.firstName;
                    usuario.APELLIDO1 =beneficiario.LastName;
                    usuario.APELLIDO2 = '';
                    usuario.TEL_MOV = beneficiario.PersonMobilePhone;
                    usuario.SIT_FISICA = beneficiario.estado_fisico__c;
                    usuario.SIT_PSIQUICA = beneficiario.estado_cognitivo__c;
                    usuario.VIV_TELEFONO = Tel_viv;
                    usuarios.add(usuario);
                }
                //Pasar los campos para todos los usuarios
            }
        }
        //Le pasamos la lista de usuarios
        interT24Sf.USUARIOSRequest usersAT24 = new interT24Sf.USUARIOSRequest();
        usersAT24.USUARIO = usuarios;
        //Llenamos los Datos de la peticion
        interT24Sf.DATOSRequest DatosPeticion = new interT24Sf.DATOSRequest();
        DatosPeticion.PETICION = peticion;
        DatosPeticion.BD = BD;
        DatosPeticion.OPORTUNIDAD = op;
        DatosPeticion.T24_COLECTIVO = t24_colectivo;
        DatosPeticion.SERVICIO_ID = oportunidad.Servicio__c;
        DatosPeticion.SERVICIO_NOMBRE = oportunidad.Servicio__r.name;
        DatosPeticion.RECOMENDADOR_ID = oportunidad.Empresa_Recomendadora__c;
        DatosPeticion.RECOMENDADOR_NOMBRE = oportunidad.Empresa_Recomendadora__r.name;
        DatosPeticion.USUARIOS = usersAT24;
        if (oportunidad.Historico__c) {
            DatosPeticion.HISTORICO = '1';
        }
        else {
            DatosPeticion.HISTORICO = '0';
        }
        System.debug('NUMERO DE USUARIOS A T24: '+usuarios.size());
        System.debug('USUARIOS: '+usersAT24);
        
        //Declaramos una variable de tipo respuesta
        interT24Sf.Usuarios_AYM_SF_T24Result_element respuesta = new interT24Sf.Usuarios_AYM_SF_T24Result_element();
        //Declaramos una variable de tipo llamada
        interT24Sf.INTER_T24_SFSOAPPort llamada= new interT24Sf.INTER_T24_SFSOAPPort();
        interT24Sf.DATOSResponse DatosRespuesta = new interT24Sf.DATOSResponse();
        //Hacer la llamada
        if(!Test.isRunningTest()) {
            respuesta = llamada.Usuarios_AYM_SF_T24(DatosPeticion);
            DatosRespuesta = respuesta.DATOS;
        //Tratar la respuesta de T24
        System.debug('RESPUESTA: '+respuesta);
        }
        else {
            DatosRespuesta.OK = '0';
            DatosRespuesta.OPORTUNIDAD = op;
        }
        List<Account> cuentasMod = new List<Account>();
        Map<String,String> Cuentast24 = new Map<String,String>();
        String idVivt24;
        //Si ha habido algun error en el envio de datos a T24, lo tenemos que tratar y enviar un correo.
        if (DatosRespuesta.OK == '0') {
            String MailBody = '<p>Se ha producido un error al enviar la oportunidad cerrada ganada a T24: https://sarquavitae.my.salesforce.com/'+op+'</p>';
            MailBody += '<p> Peticion: '+DatosRespuesta.T24_ID_PETICION+'</p>';
            MailBody += '<p> Mensaje de error de T24: <strong>'+DatosRespuesta.LIT_KO+'</strong></p>';
            MailBody += '<p> USUARIOS: </p>';
            interT24Sf.USUARIOSResponse UsuariosRespuesta = new interT24Sf.USUARIOSResponse();
            if (DatosRespuesta.USUARIOS != null) {
                UsuariosRespuesta = DatosRespuesta.USUARIOS;
            List<interT24Sf.USUARIOResponse> UsuariosRespuestaLista = new List<interT24Sf.USUARIOResponse>();
            if (UsuariosRespuesta.USUARIO != null) {
                UsuariosRespuestaLista = UsuariosRespuesta.USUARIO;
                System.debug('Numero de usuarios respuesta: '+UsuariosRespuestaLista.size());
                for (interT24Sf.USUARIOResponse usuario:UsuariosRespuestaLista) {
                    if (usuario.USU_OK == '0') {
                        MailBody += '<p> Usuario https://sarquavitae.my.salesforce.com/'+usuario.CUENTA+'<strong> ERROR: '+usuario.LIT_KO+'</strong></p>';
                    }
                    else if (usuario.USU_OK == '1') {
                        MailBody += '<p>Usuario https://sarquavitae.my.salesforce.com/'+usuario.CUENTA+' OK</p>';
                    }
                    else if (usuario.USU_OK == '-') {
                        MailBody += '<p>Usuario https://sarquavitae.my.salesforce.com/'+usuario.CUENTA+' Sin verificar</p>';
                    }
                /*
                else {
                    MailBody += '<p> Usuario https://sarquavitae.my.salesforce.com/'+usuario.CUENTA+'<strong> ERROR: '+usuario.LIT_KO+'</strong></p>';
                }*/
                }
            }
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setHtmlBody(MailBody);
            mail.setSubject('Salesforce: Error en la llamada a webservice TA');
            List<String> Adreces = new List<String>();
            Adreces.add('alexander.shubin@konozca.com');
            Adreces.add('cristina.andinach@konozca.com');
            Adreces.add('backoffice@soporte.sarquavitae.es');
            mail.setToAddresses(Adreces);
            if(!Test.isRunningTest()) {
                Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail});
            }
            
            
        }
        else {
            interT24Sf.USUARIOSResponse UsuariosRespuesta = new interT24Sf.USUARIOSResponse();
            if (DatosRespuesta.USUARIOS != null) {
                idVivt24 = DatosRespuesta.T24_ID_VIVIENDA;
                UsuariosRespuesta = DatosRespuesta.USUARIOS;
            List<interT24Sf.USUARIOResponse> UsuariosRespuestaLista = new List<interT24Sf.USUARIOResponse>();
            if (UsuariosRespuesta.USUARIO != null) {
                UsuariosRespuestaLista = UsuariosRespuesta.USUARIO;
                System.debug('Numero de usuarios respuesta: '+UsuariosRespuestaLista.size());
                for (interT24Sf.USUARIOResponse usuario:UsuariosRespuestaLista) {
                    Cuentast24.put(usuario.CUENTA, usuario.T24_ID_USUARIO);
                }
            }
            }
        }
        for (Account a:[Select id, Id_T24__c from Account where id IN:Cuentast24.keySet()]) {
            if (a.Id_T24__c == null) {
                Account ac = new Account(id = a.id);
                if (BD == 'MADRID') {
                    ac.Id_T24__c = 'M'+Cuentast24.get(a.id);
                }
                else {
                    ac.Id_T24__c = 'S'+Cuentast24.get(a.id);
                }
                
                cuentasMod.add(ac);
            }
        }
        if (idVivt24 != null && oportunidad.Id_VIV_T24__c == null) {
            Oportunidad_platform__c opUp = new Oportunidad_platform__c(id =op);
            if (BD == 'MADRID') {
                    opUp.Id_VIV_T24__c = 'M'+idVivt24;
            }
            else {
                opUp.Id_VIV_T24__c = 'S'+idVivt24;
            }
            opUp.Id_VIV_T24__c = idVivt24;
            update opUp;
        }
        
        update cuentasMod;
    }
        catch(Exception e) {
            String MailBody = '<p>Se ha producido un error al enviar la oportunidad cerrada ganada a T24: https://sarquavitae.my.salesforce.com/'+op+': '+e+' </p>';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setHtmlBody(MailBody);
            mail.setSubject('Salesforce: Error en la llamada a webservice TA');
            List<String> Adreces = new List<String>();
            Adreces.add('alexander.shubin@konozca.com');
            Adreces.add('cristina.andinach@konozca.com');
            Adreces.add('backoffice@soporte.sarquavitae.es');
            mail.setToAddresses(Adreces);
            if(!Test.isRunningTest()) {
                Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail});
            }
    }   
    }
    
        
    

}