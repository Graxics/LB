public with sharing class GenerateContract {

    public String htmlText {get;set;}   
    public Oportunidad_platform__c op {get;set;}
    public Account cr {get;set;}
    public Account cp {get;set;}
    public Servicio__c sr {get;set;}
    public Account contacto {get;set;}
    public Relacion_entre_contactos__c relacionContacto {get;set;}
    public String nombrePlantSaved {get;set;}
    public String idioma;
    public list<Condiciones_Contratos__c> condiciones;
    public Condiciones_Contratos__c condicion;
        
    public GenerateContract(ApexPages.StandardController controller){   
        System.debug(LoggingLevel.Info, 'SALTA GenerateContract');
        String dia,mes,anyo;
        String nombrePlant;
        Boolean encontrado = false;
         
        //Identificamos la oportunidad de la pagina VF
        try {
        op = [SELECT Id, Name, Residente__c, Pagador__c, Persona_de_Contacto__c, Servicio__c, Tipo_Servicio__c,Tipo_estancia2__c,Servicio__r.Tipo_Estancia__c, Tipo_de_estancia__c,Tipo_de_pago__c, Tipo_de_tarifa__c, Nombre_Centro__c, Ciudad_Centro__c, Director_Centro_First__c, Director_Centro_Last__c, DNI_Director__c, Calle_Centro__c, Codigo_Postal_Centro__c, N_Vivienda__c, Planta__c, Nombre_Edificio__c, Sociedad_Centro__c, Calle_Sociedad__c, Ciudad_Sociedad__c, CIF_Sociedad__c, Codigo_Postal_Sociedad__c, Residente_First_Name__c, Residente_Last_Name__c, DNI_Residente__c, Calle_Residente__c, Nombre_Avalista__c, Apellido_Avalista__c, DNI_Avalista__c, Calle_Avalista__c, Ciudad_Avalista__c, Codigo_Postal_Avalista__c, Testimonio_que_acredita_su_calidad__c, Fecha_prevista_de_ingreso__c, Fecha_finalizacion__c, N_dias_contrato__c, Tipo_Habitacion__c, Grado_Dependencia__c, Nombre_Entidad_Bancaria__c, Localidad_Entidad_Bancaria__c, IBAN__c, Cuenta_Pagador__c, Precio_Total__c, Pagador_First_Name__c, Pagador_Last_Name__c, DNI_Pagador__c, Calle_Pagador__c, Ciudad_Pagador__c, DNI_Contacto__c, Calle_Contacto__c, Ciudad_Contacto__c, Telefono_Contacto__c, Tipo_manutencion__c, Tipo_de_Financiacion__c, F1__c, F2__c, F3__c, F4__c, F5__c, Hora_inicio_SN__c, Hora_fin_SN__c, Frecuencia_SN__c, Nombre_representante_legal__c, Apellido_representante_legal__c, Nombre_representante_legal_Cond__c, Apellido_representante_legal_Cond__c, DNI_representante_legal__c, DNI_representante_legal_Cond__c, Calle_representate_legal__c, Calle_representate_legal_Cond__c, Ciudad_representante_legal__c, Ciudad_representante_legal_Cond__c, Telefono_representante_legal__c, Telefono_representante_legal_Cond__c, Persona_de_referencia__c, Representate_legagal__c, Precio_Diario__c, Atencion_sanitaria__c, lavanderia_y_limpieza__c, Podologia_y_corte_de_pelo__c, logo_ayuntamiento__c, Frecuencia_CD__c, Precio_reserva__c, Nombre_propio_y_plena_capacidad_de__c FROM Oportunidad_platform__c WHERE Id = :controller.getId()];
        } catch (Exception e) { throw new myException('Error imposible: No se ha encontrado oportunidad');      }   
            
        //Identificamos la cuenta del residente de la oportunidad  
        try {     
        if(op.Residente__c != null) cr = [SELECT Id, phone, ciudad__c, Nuermo_Documento_Sanitario__c FROM Account WHERE Id = :op.Residente__c];        
        } catch (Exception e) { throw new myException('No se ha encontrado el residnte');      }   
        
        //Identificamos la cuenta del pagador de la oportunidad
        try {       
        if(op.Pagador__c != null) cp = [SELECT Id, phone, Name, codigo_postal__c, Idioma_de_Contacto__pc FROM Account WHERE Id = :op.Pagador__c];
        } catch (Exception e) { throw new myException('No se ha encontrado el pagador');      }   
        
         //Identificamos el servicio    
         try {     
        sr = [SELECT Id, Transporte__c FROM Servicio__c WHERE Id = :op.Servicio__c];
        } catch (Exception e) { throw new myException('No se ha encontrado el servicio');      }  
        
        //Comprovamos si el servicio tinene transpote, ya que em algunos contratos se debe mostrar el precio según tenga o no transporte
        Boolean transporte = false;
        if(sr.Transporte__c == 'Si' || sr.Transporte__c == 'Medio'){
          transporte =true;
        }
     
        //Identificamos la cuenta del residente y contacto en el objeto Relacion Familiar
        try {
        relacionContacto = [SELECT Id, Residente__c, Contacto__c, Familiar_de_referencia__c, Relacion_personal__c 
                            FROM Relacion_entre_contactos__c 
                            WHERE Residente__c =: cr.Id AND Familiar_de_referencia__c = true  LIMIT 1];
        } catch (Exception e) { throw new myException('No se ha encontrado una una relación familiar');    }   
            
        //Identificamos la persona de referencia (Contacto)
        try {
        if(relacionContacto != null) contacto = [SELECT Id, FirstName, LastName, CIF_NIF__c, Calle__c, Ciudad__c, codigo_postal__c, Phone, PersonMobilePhone FROM Account WHERE Id = : relacionContacto.Contacto__c];
        else contacto = [SELECT Id, FirstName, LastName, CIF_NIF__c, Calle__c, Ciudad__c, codigo_postal__c, Phone, PersonMobilePhone FROM Account WHERE Id = : op.Persona_de_Contacto__c];
        } catch (Exception e) { throw new myException('No se encontro una relación familiar entre el residente y el pagador');      }     
            
            
        //Buscamos las condiciones del contrato
               
        condiciones = [SELECT Name, Num_Contrato__c, Tipo_Servicio__c, Tipo_Estancia__c, Centro__c, Idioma__c, 
                       Tipo_de_Financiacion__c, Titulo__c, Protocolo__c, Codigo__c, Revision__c, Registro__c, Aplica__c 
                       FROM Condiciones_Contratos__c 
                       WHERE Centro__c = :op.Nombre_Centro__c AND Tipo_Servicio__c = :op.Tipo_Servicio__c AND 
                       (Tipo_Estancia__c = :op.Servicio__r.Tipo_Estancia__c OR Tipo_Estancia__c =:NULL OR Tipo_Estancia__c = '') 
                       AND (Tipo_de_Financiacion__c = :op.Tipo_de_Financiacion__c OR Tipo_de_Financiacion__c= :op.Tipo_de_pago__c OR Tipo_de_Financiacion__c =:NULL OR Tipo_de_Financiacion__c = '')];
        if (condiciones.size()==0) {
            throw new myException('No se ha encontrado un contrato para este centro y/o servicio');
        }
        
        if(condiciones.size() > 1)
        {
          boolean trobat = false;
          for(Condiciones_Contratos__c cd : condiciones)
          {
            if(cd.Idioma__c == cp.Idioma_de_Contacto__pc)
            {
              condicion = cd;
              trobat = true;
            }                    
          }
          if(!trobat) 
          {
            for(Condiciones_Contratos__c cd : condiciones)
            {
              if(cd.Idioma__c == 'Castellano') condicion = cd;                    
            }
          }          
        }
        else if(condiciones.size() == 1) condicion = condiciones[0];
        
        
        //Guardamos el idioma para acceder desde la página VF
        idioma = condicion.Idioma__c;
        
        //Escogemos la plantilla contrato
        EmailTemplate[] plantilla = [SELECT Id, Name, HtmlValue, Body FROM EmailTemplate];
        
        //Miramos que el nombre de la plantilla empiece por c + Num_Contrato
        Integer i = 0;
        while(i < plantilla.size()-1 && !encontrado)
        {           
            nombrePlant = plantilla[i].Name;
            //Cogemos el nombre de contrato
            nombrePlant = nombrePlant.substring(1, 3);
            System.debug(LoggingLevel.Info, 'IF -> ' + condicion.Num_Contrato__c + ' == ' + nombrePlant);
            
            if(condicion.Num_Contrato__c == nombrePlant)
            {
                htmlText = plantilla[i].HtmlValue;
                encontrado = true;
                System.debug(LoggingLevel.Info, 'ENCONTRADO nombrePlant = ' + nombrePlant);
                System.debug(LoggingLevel.Info, 'condicion.Num_Contrato__c = ' + condicion.Num_Contrato__c);
            }
            else encontrado = false;
            i++;                
        }
        
        nombrePlantSaved = nombrePlant;
        
        if(encontrado)
        {       
            //Reemplazamos los campos de la oportunidad      
            
            if(op.Nombre_Centro__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Nombre_Centro__c}', op.Nombre_Centro__c);
            else  htmlText = htmlText.replace('{!Oportunidad_platform__c.Nombre_Centro__c}', '.............. ');
            if(op.Ciudad_Centro__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Centro__c}', op.Ciudad_Centro__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Centro__c}', '.............. ');
            
            dia = String.valueOf(Date.today().day());
            mes = String.valueOf(Date.Today().Month());
            //Transformamos formato mes
            if(mes == '1') mes = 'Enero';
            if(mes == '2') mes = 'Febrero';
            if(mes == '3') mes = 'Marzo';
            if(mes == '4') mes = 'Abril';
            if(mes == '5') mes = 'Mayo';
            if(mes == '6') mes = 'Junio';
            if(mes == '7') mes = 'Julio';
            if(mes == '8') mes = 'Agosto';
            if(mes == '9') mes = 'Septiembre';
            if(mes == '10') mes = 'Octubre';
            if(mes == '11') mes = 'Noviembre';
            if(mes == '12') mes = 'Diciembre';
            anyo = String.valueOf(Date.today().year());         
            
            htmlText = htmlText.replace('{!Fecha_Dia}', dia);
            htmlText = htmlText.replace('{!Fecha_Mes}', mes);
            htmlText = htmlText.replace('{!Fecha_Anyo}', anyo);
            
            if(op.Director_Centro_First__c != null) htmlText = htmlText.replace('{!Director.FirstName}', op.Director_Centro_First__c);
            else htmlText = htmlText.replace('{!Director.FirstName}', '..............');
            if(op.Director_Centro_Last__c != null) htmlText = htmlText.replace('{!Director.LastName}', op.Director_Centro_Last__c);
            else htmlText = htmlText.replace('{!Director.LastName}', '.............. ');
            if(op.DNI_Director__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.DNI_Director__c}', op.DNI_Director__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.DNI_Director__c}', '.............. ');
            if(op.Calle_Centro__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Calle_Centro__c}', op.Calle_Centro__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Calle_Centro__c}', ' ..............');
            if(op.Codigo_Postal_Centro__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__CP_Centro__c}', op.Codigo_Postal_Centro__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__CP_Centro__c}', ' ..............');
            if(op.Sociedad_Centro__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Sociedad_Centro__c}', op.Sociedad_Centro__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Sociedad_Centro__c}', '.............. ');
            if(op.Calle_Sociedad__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Calle_Sociedad__c}', op.Calle_Sociedad__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Calle_Sociedad__c}', ' ..............');
            if(op.Ciudad_Sociedad__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Sociedad__c}', op.Ciudad_Sociedad__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Sociedad__c}', ' ..............');
            if(op.CIF_Sociedad__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.CIF_Sociedad__c}', op.CIF_Sociedad__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.CIF_Sociedad__c}', '.............. ');
            if(op.Codigo_Postal_Sociedad__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__CP_Sociedad__c}', op.Codigo_Postal_Sociedad__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__CP_Sociedad__c}', '.............. ');
            if(op.Residente_First_Name__c!= null) htmlText = htmlText.replace('{!Residente.FirstName}', op.Residente_First_Name__c);
            else htmlText = htmlText.replace('{!Residente.FirstName}', '.............. ');
            if(op.Residente_Last_Name__c!= null) htmlText = htmlText.replace('{!Residente.LastName}', op.Residente_Last_Name__c);
            else htmlText = htmlText.replace('{!Residente.LastName}', '.............. ');
            if(op.DNI_Residente__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.DNI_Residente__c}', op.DNI_Residente__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.DNI_Residente__c}', ' ..............');
            if(op.Tipo_de_Financiacion__c != null) htmlText = htmlText.replace('{!Tipo_de_Financiacion}', op.Tipo_de_Financiacion__c);
            else htmlText = htmlText.replace('{!Tipo_de_Financiacion}', ' ..............');
            if (op.Servicio__r.Tipo_Estancia__c != null) {
                htmlText = htmlText.replace('{!Servicio.Tipo_estancia}', op.Servicio__r.Tipo_Estancia__c);
            }
            else {
                htmlText.replace('{!Servicio.Tipo_estancia}', ' ..............');
            }
            if (op.Servicio__r.Tipo_Estancia__c == 'Permanente'){
               htmlText = htmlText.replace('{!mes_o_dia}', 'mes');
            }
            else if (op.Servicio__r.Tipo_Estancia__c != 'Permanente') {
               htmlText = htmlText.replace('{!mes_o_dia}', 'día');
            }
            
            if(cr != null)
            {
              if(cr.Nuermo_Documento_Sanitario__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__SS_Residente__c}', cr.Nuermo_Documento_Sanitario__c);
              else htmlText = htmlText.replace('{!Oportunidad_platform__SS_Residente__c}', ' ..............');
              if(cr.ciudad__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Residente__c}', cr.ciudad__c);
              else htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Residente__c}', '.............. ');
              if(cr.phone!= null) htmlText = htmlText.replace('{!Oportunidad_platform__Residente_Phone}', string.valueof(cr.phone));
              else htmlText = htmlText.replace('{!Oportunidad_platform__Residente_Phone}', '.............. ');              
            }
            else
            {
              htmlText = htmlText.replace('{!Oportunidad_platform__SS_Residente__c}', ' ..............');
              htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Residente__c}', '.............. ');
              htmlText = htmlText.replace('{!Oportunidad_platform__Residente_Phone}', '.............. ');
            }            
            
            if(op.Calle_Residente__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Calle_Residente__c}', op.Calle_Residente__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Calle_Residente__c}', '.............. ');            
            if(op.N_Vivienda__c != null) htmlText = htmlText.replace('{!Numero_De_Vivienda}', op.N_Vivienda__c);
            else htmlText = htmlText.replace('{!Numero_De_Vivienda}', '.............. ');
            if(op.Planta__c != null) htmlText = htmlText.replace('{!Numero_planta}', op.Planta__c);
            else htmlText = htmlText.replace('{!Numero_planta}', '.............. ');
            if(op.Nombre_Edificio__c != null) htmlText = htmlText.replace('{!Nombre_Edificio}', op.Nombre_Edificio__c);
            else htmlText = htmlText.replace('{!Nombre_Edificio}', '.............. ');
            if(op.N_dias_contrato__c != null) htmlText = htmlText.replace('{!Numero_Dias_Contrato}', string.valueof(op.N_dias_contrato__c));
            else htmlText = htmlText.replace('{!Numero_Dias_Contrato}', '.............. ');
            if(op.F5__c != null) htmlText = htmlText.replace('{!F5}', string.valueof(op.F5__c));
            else htmlText = htmlText.replace('{!F5}', '.............. ');
             
            if(op.Apellido_representante_legal__c!= null) htmlText = htmlText.replace('{!Representante.LastName}', op.Apellido_representante_legal__c);
            else htmlText = htmlText.replace('{!Representante.LastName}', '.............. ');
            if(op.Nombre_representante_legal__c!= null) htmlText = htmlText.replace('{!Representante.FirstName}', op.Nombre_representante_legal__c);
            else htmlText = htmlText.replace('{!Representante.FirstName}', '.............. ');
            if(op.DNI_representante_legal__c!= null) htmlText = htmlText.replace('{!Representante.CIF_NIF__c}', op.DNI_representante_legal__c);
            else htmlText = htmlText.replace('{!Representante.CIF_NIF__c}', '.............. ');
            if(op.calle_representate_legal__c!= null) htmlText = htmlText.replace('{!Representante.Calle}', op.calle_representate_legal__c);
            else htmlText = htmlText.replace('{!Representante.Calle}', '.............. ');
             if(op.ciudad_representante_legal__c!= null) htmlText = htmlText.replace('{!Oportunidad_platform__Localidad_Representante__c}', op.ciudad_representante_legal__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__Localidad_Representante__c}', '.............. ');
            if(op.telefono_representante_legal__c!= null) htmlText = htmlText.replace('{!Representante.Phone}', op.telefono_representante_legal__c);
            else htmlText = htmlText.replace('{!Representante.Phone}', '.............. ');
            if(op.Nombre_Avalista__c!= null) htmlText = htmlText.replace('{!Avalista.FirstName}', op.Nombre_Avalista__c);
            else htmlText = htmlText.replace('{!Avalista.FirstName}', '.............. ');
            if(op.Apellido_Avalista__c!= null) htmlText = htmlText.replace('{!Avalista.LastName}', op.Apellido_Avalista__c);
            else htmlText = htmlText.replace('{!Avalista.LastName}', '.............. ');
            if(op.DNI_Avalista__c!= null) htmlText = htmlText.replace('{!Avalista.DNI}', op.DNI_Avalista__c);
            else htmlText = htmlText.replace('{!Avalista.DNI}', '.............. ');
            if(op.Calle_Avalista__c!= null) htmlText = htmlText.replace('{!Avalista.Calle}', op.Calle_Avalista__c);
            else htmlText = htmlText.replace('{!Avalista.Calle}', '.............. ');
            if(op.Ciudad_Avalista__c!= null) htmlText = htmlText.replace('{!Avalista.Ciudad}', op.Ciudad_Avalista__c);
            else htmlText = htmlText.replace('{!Avalista.Ciudad}', '.............. ');
             if(op.Codigo_Postal_Avalista__c!= null) htmlText = htmlText.replace('{!Avalista.CP}', op.Codigo_Postal_Avalista__c);
            else htmlText = htmlText.replace('{!Avalista.CP}', '.............. ');
            if(op.Precio_Diario__c!= null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Diario__c}', op.Precio_Diario__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Diario__c}', '.............. ');
            if(op.Tipo_manutencion__c!= null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_manutencion__c}', op.Tipo_manutencion__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_manutencion__c}', '.............. ');
            if(op.Atencion_sanitaria__c== true) htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Atencion_Sanitaria__c}', 'Atención sanitaria (control y vigilancia).');
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Atencion_Sanitaria__c}', ' ');
            if(op.lavanderia_y_limpieza__c== true) htmlText = htmlText.replace('{!Oportunidad_platform__c.Lavanderia_y_limpieza__c}', 'Lavandería y limipeza.');
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Lavanderia_y_limpieza__c}', ' ');
            if(op.podologia_y_corte_de_pelo__c== true) htmlText = htmlText.replace('{!Oportunidad_platform__c.Podologia_y_corte_de_pelo__c}', 'Servicio de podología y un corte de pelo gratuitos cada 45 días, siempre que sea solicitado por la familia, o, en su defecto, con el consentimiento de ella. ');
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Podologia_y_corte_de_pelo__c}', ' ');
            if(op.Tipo_de_tarifa__c!= null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Tarifa}', op.Tipo_de_tarifa__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Tarifa}', '.............. ');
            if(sr.Transporte__c != null && sr.Transporte__c=='Si') htmlText = htmlText.replace('{!Servicio__c.Transporte__c}', 'El Centro SARquavitae Alcudia ofrece a los usuarios como servicio opcional el traslado en transporte adaptado desde el domicilio del usuario al Centro. Los usuarios que opten por este servicio deberán comunicar a la Dirección del Centro la franja horaria que prefieren para la recogida y entrega del usuario.\nEl horario de recogida y entrega del usuario de centro de día en su domicilio, puede verse modificado por el aumento o disminución del número de beneficiarios de las mismas y por el tráfico o por la atención puntual y/o de urgencia de cualquier usuario entre ruta y ruta.\n Cuando un usuario sufra de enfermedad común repentina, o un incremento de dolencias habituales que le impidan venir al centro de día por tiempo definido o indefinido, será obligatorio comunicarlo para no pasar la ruta por el domicilio innecesariamente. El centro recoge estos avisos las 24 horas del día, entendiendo que no se volverá a pasar por esta vivienda hasta recibir la comunicación oportuna para volver a recogerle.' );
            else htmlText = htmlText.replace('{!Servicio__c.Transporte__c}', 'No aplica.');
            if(op.logo_ayuntamiento__c!= null) htmlText = htmlText.replace('{!logo_ayuntamiento}', op.logo_ayuntamiento__c);
            else htmlText = htmlText.replace('{!logo_ayuntamiento}', '.............. ');
            if(op.Frecuencia_CD__c!= null) htmlText = htmlText.replace('{!Oportunidad_platform__Frecuencia_CD}', op.Frecuencia_CD__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__Frecuencia_CD}', '.............. ');
            if(op.Hora_inicio_SN__c!= null) htmlText = htmlText.replace('{!Hora_Inicio_SN}', op.Hora_inicio_SN__c);
            else htmlText = htmlText.replace('{!Hora_Inicio_SN}', '.............. ');
            if(op.Hora_fin_SN__c!= null) htmlText = htmlText.replace('{!Hora_Fin_SN}', op.Hora_fin_SN__c);
            else htmlText = htmlText.replace('{!Hora_Fin_SN}', '.............. ');
            if(op.Frecuencia_SN__c!= null) htmlText = htmlText.replace('{!Frecuencia_CD}', op.Frecuencia_SN__c);
            else htmlText = htmlText.replace('{!Frecuencia_SN}', '.............. ');
            if(op.Tipo_de_pago__c== 'Gratis') htmlText = htmlText.replace('{!Condicion}', 'No obstante lo anterior, el número máximo  de faltas permitidas es de 45 días, y si el usuario faltase más de lo  estipulado puede perder su plaza en el centro.');
            else htmlText = htmlText.replace('{!Codicion}', '');
            if(op.Precio_reserva__c!= null) htmlText = htmlText.replace('{!Precio_reserva}', String.valueOf(op.Precio_reserva__c));
            else htmlText = htmlText.replace('{!Precio_reserva}', '.............. ');
            
            
            //Condicionales            
            htmlText = htmlText.replace('{!F1}',op.F1__c);
            htmlText = htmlText.replace('{!F2}',op.F2__c);
            htmlText = htmlText.replace('{!F3}',op.F3__c);
            htmlText = htmlText.replace('{!F4}', op.F4__c);
             
            
           /* if(op.Persona_de_referencia__c == true) 
            {                   
                 if(contacto != null)
                 {
                   if(contacto.FirstName != null) htmlText = htmlText.replace('{!Persona_Referencia_con.FirstName}', contacto.FirstName);
                  else htmlText = htmlText.replace('{!Persona_Referencia_con.FirstName}', '..............');
                  if(contacto.LastName != null) htmlText = htmlText.replace('{!Persona_Referencia_con.LastName}', contacto.LastName);
                  else htmlText = htmlText.replace('{!Persona_Referencia_con.LastName}', '..............');
                  if(contacto.CIF_NIF__c != null) htmlText = htmlText.replace('{!Persona_Referencia_con.CIF_NIF__c}', contacto.CIF_NIF__c);
                  else htmlText = htmlText.replace('{!Persona_Referencia_con.CIF_NIF__c}', '..............');
                  if(contacto.Calle__c!= null) htmlText = htmlText.replace('{!Persona_Referencia_con.Calle}', contacto.Calle__c);
                  else htmlText = htmlText.replace('{!Persona_Referencia_con.Calle}', '..............');
                  if(contacto.Ciudad__c != null) htmlText = htmlText.replace('{!Persona_Referencia_con.Ciudad}', contacto.Ciudad__c);
                  else htmlText = htmlText.replace('{!Persona_Referencia_con.Ciudad}', '..............');
                  if(contacto.Phone != null) htmlText = htmlText.replace('{!Persona_Referencia_con.Phone}', contacto.Phone);
                  else htmlText = htmlText.replace('{!Persona_Referencia_con.Phone}', '..............');
                  if(contacto.codigo_postal__c != null) htmlText = htmlText.replace('{!Persona_Referencia_con.codigo_postal}', contacto.codigo_postal__c);
                  else htmlText = htmlText.replace('{!Persona_Referencia_con.codigo_postal}', '..............');
                 }
                 else
                 {
                   htmlText = htmlText.replace('{!Persona_Referencia.FirstName}','..............');
                  htmlText = htmlText.replace('{!Persona_Referencia.LastName}','..............');
                  htmlText = htmlText.replace('{!Persona_Referencia.CIF_NIF__c}','..............');
                  htmlText = htmlText.replace('{!Persona_Referencia.Calle}','..............');
                  htmlText = htmlText.replace('{!Persona_Referencia.Ciudad}','..............');
                  htmlText = htmlText.replace('{!Persona_Referencia.Phone}','..............');
                  htmlText = htmlText.replace('{!Persona_Referencia.Movil}','..............');
                  htmlText = htmlText.replace('{!relacionContacto.Relacion_personal__c}','..............');                   
                 }                
            }
            else
            {
                htmlText = htmlText.replace('{!Persona_Referencia_con.FirstName}', '..............');
                htmlText = htmlText.replace('{!Persona_Referencia_con.LastName}', '..............');
                htmlText = htmlText.replace('{!Persona_Referencia_con.CIF_NIF__c}', '..............');
                htmlText = htmlText.replace('{!Persona_Referencia_con.Calle}', '..............');
                htmlText = htmlText.replace('{!Persona_Referencia_con.Ciudad}', '..............');
                htmlText = htmlText.replace('{!Persona_Referencia_con.Phone}', '..............');
                htmlText = htmlText.replace('{!Persona_Referencia_con.codigo_postal}', '..............');
            }*/
            
            //if(op.Representate_legagal__c == true)
            //{
                if(op.Nombre_representante_legal_Cond__c != null) htmlText = htmlText.replace('{!Representante_con.FirstName}', op.Nombre_representante_legal_Cond__c);
                else htmlText = htmlText.replace('{!Representante_con.FirstName}', '..............');
                if(op.Apellido_representante_legal_Cond__c != null) htmlText = htmlText.replace('{!Representante_con.LastName}', op.Apellido_representante_legal_Cond__c);
                else htmlText = htmlText.replace('{!Representante_con.LastName}', '..............');
                if(op.DNI_representante_legal_Cond__c != null) htmlText = htmlText.replace('{!Representante_con.CIF_NIF__c}', op.DNI_representante_legal_Cond__c);
                else htmlText = htmlText.replace('{!Representante_con.CIF_NIF__c}', '..............'); 
                if(op.Calle_representate_legal_Cond__c != null) htmlText = htmlText.replace('{!Representante_con.Calle}', op.Calle_representate_legal_Cond__c);
                else htmlText = htmlText.replace('{!Representante_con.Calle}', '..............');
                if(op.Ciudad_representante_legal_Cond__c != null) htmlText = htmlText.replace('{!Representante_con.Ciudad}', op.Ciudad_representante_legal_Cond__c);
                else htmlText = htmlText.replace('{!Representante_con.Ciudad}', '..............');
                if(op.Telefono_representante_legal_Cond__c != null) htmlText = htmlText.replace('{!Representante_con.Phone}', op.Telefono_representante_legal_Cond__c);
                else htmlText = htmlText.replace('{!Representante_con.Phone}', '..............');            
            //}
            //Si no esta marcado Representante Legal aparece el residente
            /*else
            {
                htmlText = htmlText.replace('{!Nombre_residente_rep_legal}', op.Residente_First_Name__c);
                htmlText = htmlText.replace('{!Apellidos_residente_rep_legal}', op.Residente_Last_Name__c);
                htmlText = htmlText.replace('{!Representante_con.CIF_NIF__c}', '..............');
                htmlText = htmlText.replace('{!Representante_con.Calle}', '..............');
                htmlText = htmlText.replace('{!Representante_con.Ciudad}', '..............');
                htmlText = htmlText.replace('{!Representante_con.Phone}', '..............');                
            }*/          
            if(op.Representate_legagal__c == true)
            {
              if(op.Nombre_representante_legal__c != null) htmlText = htmlText.replace('{!Nombre_residente_rep_legal}', op.Nombre_representante_legal__c);
              else htmlText = htmlText.replace('{!Nombre_residente_rep_legal}', '..............');
              if(op.Apellido_representante_legal__c != null) htmlText = htmlText.replace('{!Apellidos_residente_rep_legal}', op.Apellido_representante_legal__c);
              else htmlText = htmlText.replace('{!Apellidos_residente_rep_legal}', '..............');
            }
            else
            {
              System.debug(LoggingLevel.Info, 'Persona de referencia: '+op.Persona_de_referencia__c);
                if (op.Persona_de_referencia__c == true) {
                    if(contacto.FirstName != null) htmlText = htmlText.replace('{!Nombre_residente_rep_legal}', contacto.FirstName);
                    else htmlText = htmlText.replace('{!Nombre_residente_rep_legal}', '..............');
                    if(contacto.LastName != null) htmlText = htmlText.replace('{!Apellidos_residente_rep_legal}', contacto.LastName);
                    else htmlText = htmlText.replace('{!Apellidos_residente_rep_legal}', '..............');
                }
                else {
                    if(op.Residente_First_Name__c != null) htmlText = htmlText.replace('{!Nombre_residente_rep_legal}', op.Residente_First_Name__c);
                    else htmlText = htmlText.replace('{!Nombre_residente_rep_legal}', '..............');
                    if(op.Residente_Last_Name__c != null) htmlText = htmlText.replace('{!Apellidos_residente_rep_legal}', op.Residente_Last_Name__c);
                    else htmlText = htmlText.replace('{!Apellidos_residente_rep_legal}', '..............');
                }
              
              
            }
            
            if(op.Testimonio_que_acredita_su_calidad__c != null) htmlText = htmlText.replace('{!Testimonio_que_acredita_su_calidad__c}', op.Testimonio_que_acredita_su_calidad__c);
            else htmlText = htmlText.replace('{!Testimonio_que_acredita_su_calidad__c}', '..............');
            
            if(op.Testimonio_que_acredita_su_calidad__c != null)  htmlText = htmlText.replace('{!Oportunidad_platform__c.Testimonio_que_acredita_su_calidad__c}', op.Testimonio_que_acredita_su_calidad__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Testimonio_que_acredita_su_calidad__c}', '..............');
            if(op.Fecha_prevista_de_ingreso__c != null) 
            {
                dia = String.valueOf(op.Fecha_prevista_de_ingreso__c.day());
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Dia_Ingreso}', dia);
                mes = String.valueOf(op.Fecha_prevista_de_ingreso__c.month());
                    if(mes == '1') mes = 'Enero';
                    if(mes == '2') mes = 'Febrero';
                    if(mes == '3') mes = 'Marzo';
                    if(mes == '4') mes = 'Abril';
                    if(mes == '5') mes = 'Mayo';
                    if(mes == '6') mes = 'Junio';
                    if(mes == '7') mes = 'Julio';
                    if(mes == '8') mes = 'Agosto';
                    if(mes == '9') mes = 'Septiembre';
                    if(mes == '10') mes = 'Octubre';
                    if(mes == '11') mes = 'Noviembre';
                    if(mes == '12') mes = 'Diciembre';
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Mes_Ingreso}', mes);
                anyo = String.valueOf(op.Fecha_prevista_de_ingreso__c.year());
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Anyo_Ingreso}', anyo);
            }
            else
            {
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Dia_Ingreso}', '..............');
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Mes_Ingreso}', '..............');
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Anyo_Ingreso}', '..............');
            }
            
            if(op.Fecha_finalizacion__c != null) 
            {
                dia = String.valueOf(op.Fecha_finalizacion__c.day());
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Dia_Salida}', dia);
                mes = String.valueOf(op.Fecha_finalizacion__c.month());
                    if(mes == '1') mes = 'Enero';
                    if(mes == '2') mes = 'Febrero';
                    if(mes == '3') mes = 'Marzo';
                    if(mes == '4') mes = 'Abril';
                    if(mes == '5') mes = 'Mayo';
                    if(mes == '6') mes = 'Junio';
                    if(mes == '7') mes = 'Julio';
                    if(mes == '8') mes = 'Agosto';
                    if(mes == '9') mes = 'Septiembre';
                    if(mes == '10') mes = 'Octubre';
                    if(mes == '11') mes = 'Noviembre';
                    if(mes == '12') mes = 'Diciembre';
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Mes_Salida}', mes);
                anyo = String.valueOf(op.Fecha_finalizacion__c.year());
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Anyo_Salida}', anyo);
            }
            else
            {
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Dia_Salida}', '..............');
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Mes_Salida}', '..............');
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Anyo_Salida}', '..............');
            }
            
            if(op.Tipo_estancia2__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Estancia__c}',op.Tipo_estancia2__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Estancia__c}','..............');            
            if(op.Tipo_Servicio__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Servicio__c}',op.Tipo_Servicio__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Servicio__c}','..............');
            if(op.Tipo_Habitacion__c != null) 
            {
                if(op.Tipo_Habitacion__c == 'HD') htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Habitacion__c}','doble');
                else if(op.Tipo_Habitacion__c == 'HI') htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Habitacion__c}','individual');
                else {
                    htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Habitacion__c}',op.Tipo_Habitacion__c);
                }
                
            }
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Tipo_Habitacion__c}','..............');
            if(op.Grado_Dependencia__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Grado_Dependencia__c}',op.Grado_Dependencia__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Grado_Dependencia__c}','..............');
            if(op.Precio_Total__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Total__c}',String.valueOf(op.Precio_Total__c));
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Total__c}','..............');
            if(op.Nombre_Entidad_Bancaria__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Nombre_Entidad_Bancaria__c}',op.Nombre_Entidad_Bancaria__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Nombre_Entidad_Bancaria__c}','..............');
            if(op.Localidad_Entidad_Bancaria__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Localidad_Entidad_Bancaria__c}',op.Localidad_Entidad_Bancaria__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Localidad_Entidad_Bancaria__c}','..............');
            if(op.IBAN__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.N_Oficina_Entidad_Bancaria__c}',op.IBAN__c.substring(4,8));
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.N_Oficina_Entidad_Bancaria__c}','..............');
            if(op.IBAN__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.IBAN__c}',op.IBAN__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.IBAN__c}','..............');
            if(op.Cuenta_Pagador__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Cuenta_Pagador__c}',op.Cuenta_Pagador__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Cuenta_Pagador__c}','..............');
            if(op.Pagador_First_Name__c != null) htmlText = htmlText.replace('{!Pagador.FirstName}',op.Pagador_First_Name__c);
            else htmlText = htmlText.replace('{!Pagador.FirstName}','..............');
            if(op.Pagador_Last_Name__c != null) htmlText = htmlText.replace('{!Pagador.LastName}',op.Pagador_Last_Name__c);
            else htmlText = htmlText.replace('{!Pagador.LastName}','..............');
            if(op.DNI_Pagador__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.DNI_Pagador__c}',op.DNI_Pagador__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.DNI_Pagador__c}','..............');
            if(op.Calle_Pagador__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Calle_Pagador__c}',op.Calle_Pagador__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Calle_Pagador__c}','..............');
            if(op.Ciudad_Pagador__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Pagador__c}',op.Ciudad_Pagador__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Pagador__c}','..............');
            
            //en algunos contratos se debe mostrar el precio segun tenga o no transporte
            if(!transporte){
              htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_sinTransporte__c}', String.valueOf(op.Precio_Total__c));
              htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_conTransporte__c}', '..............');
            }else{
              htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_conTransporte__c}', String.valueOf(op.Precio_Total__c));
              htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_sinTransporte__c}', '..............');
            }
            
            if(cp != null)
            {
              if(cp.codigo_postal__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Codigo_Postal_Pagador__c}',cp.Codigo_postal__c);
              else htmlText = htmlText.replace('{!Oportunidad_platform__c.Codigo_Postal_Pagador__c}','..............');
               if(cp.phone != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Telefono_Pagador__c}',cp.phone);
              else htmlText = htmlText.replace('{!Oportunidad_platform__c.Telefono_Pagador__c}','..............');
            }
            else
            {
              htmlText.replace('{!Oportunidad_platform__c.Codigo_Postal_Pagador__c}','..............');
              htmlText = htmlText.replace('{!Oportunidad_platform__c.Telefono_Pagador__c}','..............');              
            }            
            if(contacto != null)                
            {
                if(contacto.FirstName != null) htmlText = htmlText.replace('{!Persona_Referencia.FirstName}',contacto.FirstName);
                else htmlText = htmlText.replace('{!Persona_Referencia.FirstName}','..............');
                if(contacto.LastName != null) htmlText = htmlText.replace('{!Persona_Referencia.LastName}',contacto.LastName);
                else htmlText = htmlText.replace('{!Persona_Referencia.LastName}','..............');
                if(contacto.CIF_NIF__c != null) htmlText = htmlText.replace('{!Persona_Referencia.CIF_NIF__c}',contacto.CIF_NIF__c);
                else htmlText = htmlText.replace('{!Persona_Referencia.CIF_NIF__c}','..............');
                if(contacto.Calle__c != null) htmlText = htmlText.replace('{!Persona_Referencia.Calle}',contacto.Calle__c);
                else htmlText = htmlText.replace('{!Persona_Referencia.Calle}','..............');
                if(contacto.Ciudad__c != null) htmlText = htmlText.replace('{!Persona_Referencia.Ciudad}',contacto.Ciudad__c);
                else htmlText = htmlText.replace('{!Persona_Referencia.Ciudad}','..............');
                if(contacto.Phone != null) htmlText = htmlText.replace('{!Persona_Referencia.Phone}',contacto.Phone);
                else htmlText = htmlText.replace('{!Persona_Referencia.Phone}','..............');
                if(contacto.PersonMobilePhone != null) htmlText = htmlText.replace('{!Persona_Referencia.Movil}',contacto.PersonMobilePhone);
                else htmlText = htmlText.replace('{!Persona_Referencia.Movil}','..............');
                if(contacto.Id != cr.Id) htmlText = htmlText.replace('{!relacionContacto.Relacion_personal__c}',relacionContacto.Relacion_personal__c);
                else htmlText = htmlText.replace('{!relacionContacto.Relacion_personal__c}','..............');           
            }
            else 
            {
                htmlText = htmlText.replace('{!Persona_Referencia.FirstName}','..............');
                htmlText = htmlText.replace('{!Persona_Referencia.LastName}','..............');
                htmlText = htmlText.replace('{!Persona_Referencia.CIF_NIF__c}','..............');
                htmlText = htmlText.replace('{!Persona_Referencia.Calle}','..............');
                htmlText = htmlText.replace('{!Persona_Referencia.Ciudad}','..............');
                htmlText = htmlText.replace('{!Persona_Referencia.Phone}','..............');
                htmlText = htmlText.replace('{!Persona_Referencia.Movil}','..............');
                htmlText = htmlText.replace('{!relacionContacto.Relacion_personal__c}','..............');            
            }
            if(op.DNI_Contacto__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.DNI_Contacto__c}',op.DNI_Contacto__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.DNI_Contacto__c}','..............');
            if(op.Calle_Contacto__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Calle_Contacto__c}',op.Calle_Contacto__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Calle_Contacto__c}','..............');
            if(op.Ciudad_Contacto__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Contacto__c}',op.Ciudad_Contacto__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Ciudad_Contacto__c}','..............');
            if(op.Telefono_Contacto__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Telefono_Contacto__c}',op.Telefono_Contacto__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Telefono_Contacto__c}','..............');
        }else{
            System.debug(LoggingLevel.Info, 'NO ENCONTRADO');
            System.debug(LoggingLevel.Info, condiciones);
        }
   
    }
    
    public void saveNombrePlant() {
    
        //Guardamos el nombre de la plantilla en la oportunidad
        Oportunidad_platform__c oAux = new Oportunidad_platform__c ();
        oAux.Id = op.Id;        
        oAux.Plantilla_Contrato__c= nombrePlantSaved;      
        update oAux;
    }
    
    //Métodos que devuelven texto de la cabecera en función del Idioma  
    
    public string getCodigo()
    {
      String codigo;
      if (idioma == 'Castellano' || idioma == null || idioma == 'Gallego') codigo = 'Código: ';
      else if(idioma == 'Catalán') codigo = 'Codi: ';
      else if(idioma == 'Inglés') codigo = 'Code: '; 
      return codigo + condicion.Codigo__c;
    }
    
    public String getCentro()
    {
      string centro;
      
      if(idioma == 'Castellano' || idioma == null || idioma == 'Gallego') centro = 'Centro: ';
      else if(idioma == 'Catalán') centro = 'Centre: ';
      else if(idioma == 'Inglés') centro = 'Center: '; 
      
      return centro + op.Nombre_Centro__c;
    }
    
    public String getRevision()
    {
      string revision;
      
      if(idioma == 'Castellano' || idioma == null || idioma == 'Gallego') revision = 'Revisado: ';
      else if(idioma == 'Catalán') revision = 'Revisat: ';
      else if(idioma == 'Inglés') revision = 'Revised: ';
      
      return revision + condicion.Revision__c;
    }
    
    public String getPagina()
    {
      string pagina;
      
      if(idioma == 'Castellano' || idioma == null) pagina = 'Página: ';
      else if (idioma == 'Catalán') pagina = 'Pàgina: ';
      else if(idioma == 'Inglés') pagina = 'Page: ';
      else if(idioma == 'Gallego') pagina = 'Páxina: ';
      
      return pagina;
    }
    
    public String getDe()
    {
      String de;
      
      if(idioma == 'Inglés') de = 'of';
      else de = 'de';
      
      return de;
    }
    
    public String getTitulo()
    {
      return condicion.Titulo__c;
    }
    
    public String getProtocolo()
    {
      string protocolo;
      
      if(idioma == 'Castellano' || idioma == null || idioma == 'Gallego') protocolo = 'Protocolo';
      else if (idioma == 'Catalán') protocolo = 'Protocol';
      else if(idioma == 'Inglés') protocolo = 'Protocol';
      
      return protocolo;
    }
    
    public String getProtocoloDetail()
    {
      return condicion.Protocolo__c;
    }
    
    public String getRegistro()
    {
      string registro;
      
      if(idioma == 'Castellano' || idioma == null) registro = 'Registro';
      else if (idioma == 'Catalán') registro = 'Registre';
      else if(idioma == 'Inglés') registro = 'Register';
      else if(idioma == 'Gallego') registro = 'Rexistro';      
      
      return registro;
    }
    
    public String getDetailRegistro()
    {
      return condicion.Registro__c;
    }
    
    public String getAplicaA()
    {
      String aplica;
      
      if(idioma == 'Castellano' || idioma == null || idioma == 'Catalán' || idioma == 'Gallego') aplica = 'Aplica a';
      else if(idioma == 'Inglés') aplica = 'Applies to';
      
      return aplica;  
    }
    
    public String getDetailAplica()
    {
      return condicion.Aplica__c;
    }
}