/*
* LOG de Modifcaciones:
*	Alexander Shubin (04/11/2016): Modificar el código para que se generen plantillas en función de la siguiente petición: (Lineas afectadas 61-67)
*			Necesitamos que para aquellas oportunidades de TAD fija en las cuales anotemos el servicio como "Hogar + GSM" u "Hogar Contigo + GSM" en el contrato aparezcan las dos anotaciones señaladas en el pantallazo adjunto. Es decir que en la cuarta clausula:  
*			- Aparezca que "El precio indicado en esta cláusula incluye el coste.." es decir, en este caso hay que eliminar el "no" 
*			- El pago de los servicios corresponden al CONTRATANTE" en éste ultimo hay que eliminar "las citadas llamadas"
*
* 
*/

public with sharing class pruebaContratos {

    public Oportunidad_platform__c op {get;set;}
    public String htmlText {get;set;}
    public String htmlText2 {get;set;}
    public String htmlText3 {get;set;}
    public EmailTemplate plantilla {get;set;}
    public EmailTemplate plantilla2 {get;set;}
    public EmailTemplate plantilla3 {get;set;}
    public Relacion_entre_contactos__c usuarioPrincipal {get;set;}
    public Relacion_entre_contactos__c pagador {get;set;}
    public List<Relacion_entre_contactos__c> usuarioColgante = new List<Relacion_entre_contactos__c>();
    public User us {get;set;}
    public Account cp {get;set;}
    public Account ac_up {get;set;}
    public Account ac_uc {get;set;}
    public Account ac_uc2 {get;set;}
    public String idioma;
    public list<Condiciones_Contratos__c> condiciones;
    public Condiciones_Contratos__c condicion;
    public List<String> meses = new List<String>{'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'};
    public Boolean anexo {get;set;}
    public String logo {get;set;}
    
    public pruebaContratos(ApexPages.StandardController controller){
    
        String dia,mes,anyo;
        String nombrePlant;
        //Boolean unidadMovil = false;
        Integer nMes;
        String s1 = 'El precio indicado en esta cl&aacute;usula incluye';
        String s2 = 'El pago de servicios corresponden al <strong>CONTRATANTE';
        
        //seleccionamos la informacion de la oportunidad
        try{                
            op = [SELECT Id, RecordType.Name, Empresa_Recomendadora__r.logo__c, Central__r.Ciudad__c, Central__r.Name, Pagador__c, NOC__r.Name, NOC__r.Anexo__c, NOC_12_Convenios__r.Name, NOC_12_Convenios__r.Anexo__c, NOC_12_Convenios__r.Recomendador__r.logo__c, Servicio__r.Name, Precio_Cuota_Mensual__c, Precio_Cuota_Mensual_Sin_Descuento__c, Precio_Servicio__c, Precio_Colgantes__c, Servicio__r.Tipo_de_servicio_TA__c, Servicio__r.Tipo_de_dispositivos__c, Nombre_Entidad_Bancaria__c, IBAN__c, Forma_de_pago_Dispositivo__c, Precio_Dispositivo__c, Precio_Dispositivo_new__c,Fecha_cierre__c, Descuento__c FROM Oportunidad_platform__c WHERE Id =: controller.getId()];
        }catch (Exception e) { throw new myException('Error imposible: No se ha encontrado oportunidad');}   
        
        //seleccionamos plantilla
        if(op.RecordType.Name == 'Oportunidad TAD'){
                nombrePlant = (op.NOC_12_Convenios__c!=null && op.Servicio__r.Name =='Esencial 10') ? 
                				'Contrato Esencial 10' : 'Contrato TAD';          
        } else if(op.RecordType.Name == 'Oportunidad TAM' || op.RecordType.Name == 'Oportunidad TA Dúo') {
            //nombrePlant = 'Contrato TAM';
            nombrePlant = (op.NOC_12_Convenios__c!=null && 
                           op.NOC_12_Convenios__r.Name == 'TE ACOMPAÑA EMPLEADOS BBVA') ? 
                				'Contrato TAM BBVA' : 'Contrato TAM';
        }
        
        plantilla = [SELECT Id, Name, HtmlValue, Body FROM EmailTemplate WHERE Name = :nombrePlant];
        htmlText = plantilla.HtmlValue;
        
        // Modificar el texto final de las plantillas en función del servicio ofrecido
        if (op.Servicio__r.Name == 'Hogar + GSM' || op.Servicio__r.Name == 'Hogar Contigo + GSM'){
            htmlText = htmlText.replace('El precio indicado en esta cl&aacute;usula no incluye', s1);
            htmlText = htmlText.replace('El pago de las citadas llamadas y  servicios corresponden al <strong>CONTRATANTE', s2);
        }
        System.debug(plantilla.id);
        
        //seleccionamos pagador
        try{pagador = [SELECT Beneficiario__c FROM Relacion_entre_contactos__c WHERE Oportunidad__c = :op.Id AND Pagador__c=true];}
        catch (Exception e){throw new myException('La oportunidad debe estar en Cerrado ganada i por tanto debe existir un pagador');}
            
        //selecionamos usuario principal
         try{
            usuarioPrincipal = [SELECT Beneficiario__c FROM Relacion_entre_contactos__c WHERE Oportunidad__c = :op.Id AND Usuario_principal__c=true];
         }catch (Exception e){
                /*htmlText = htmlText.replace('{!UsuarioPrincipal.Nombre}', '..............');
                htmlText = htmlText.replace('{!UsuarioPrincipal.Tipo_Documento}', '..............');
                htmlText = htmlText.replace('{!UsuarioPrincipal.CIF_NIF}', '..............');
                htmlText = htmlText.replace('{!UsuarioPrincipal.Calle}', '..............');
                htmlText = htmlText.replace('{!UsuarioPrincipal.CP}', '..............');
                htmlText = htmlText.replace('{!UsuarioPrincipal.Ciudad}', '..............');
                htmlText = htmlText.replace('{!UsuarioPrincipal.Provincia}', '..............');*/
                throw new myException('La oportunidad debe estar en cerrado ganada y pot tanto debe existir un usuario principal');
         }
         
        //seleccionamos beneficiario con o sin colgante
        usuarioColgante = [SELECT Beneficiario__c FROM Relacion_entre_contactos__c WHERE Oportunidad__c =: op.Id AND (Beneficiario_con_colgante__c=true OR Beneficiario_sin_colgante__c=true)];
        /*if(usuarioColgante.size() == 0){ 
            htmlText = htmlText.replace('{!UsuarioColgante.Nombre}', '..............');
            htmlText = htmlText.replace('{!UsuarioColgante.Tipo_Documento}', '..............');
           /* htmlText = htmlText.replace('{!UsuarioColgante.CIF_NIF}', '..............');
            htmlText = htmlText.replace('{!UsuarioColgante.Calle}', '..............');
            htmlText = htmlText.replace('{!UsuarioColgante.CP}', '..............');
            htmlText = htmlText.replace('{!UsuarioColgante.Ciudad}', '..............');
            htmlText = htmlText.replace('{!UsuarioColgante.Provincia}', '..............');
            
        }*/
        
        //seleccionamos la informacion del pagador
        if(pagador != null){
            cp = [SELECT Id, FirstName, LastName, Tipo_Documento_Identidad__c, CIF_NIF__c, Calle__c, Codigo_Postal__c, Ciudad__c, Provincia__c FROM Account WHERE Id =: pagador.Beneficiario__c];
        }  
        
        //seleccioanmos la informacion del usuario principal
        if(usuarioPrincipal != null){
            ac_up = [SELECT Id, FirstName, LastName, Tipo_Documento_Identidad__c, CIF_NIF__c FROM Account WHERE id =: usuarioPrincipal.Beneficiario__c];
        }
        //seleccionamos la informacion del beneficiario con o sin colgante
        if(usuarioColgante.size() != 0){
            ac_uc = [SELECT Id, FirstName, LastName, Tipo_Documento_Identidad__c, CIF_NIF__c FROM Account WHERE id =: usuarioColgante.get(0).Beneficiario__c];
            if(usuarioColgante.size() > 1){
                ac_uc2 = [SELECT Id, FirstName, LastName, Tipo_Documento_Identidad__c, CIF_NIF__c FROM Account WHERE id =: usuarioColgante.get(1).Beneficiario__c];
            }
        }
        
        
        
        /*dia = String.valueOf(Date.today().day());
        nMes = Date.Today().Month();
        //Transformamos formato mes
        mes = meses.get(nMes-1);
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
        htmlText = htmlText.replace('{!Fecha_Anyo}', anyo);*/
        if(op.Fecha_Cierre__c != null){
            htmlText = htmlText.replace('{!Oportunidad_platform__c.Dia_Fecha_Cierre}', String.valueOf(op.Fecha_Cierre__c.day()));
            nMes = op.Fecha_Cierre__c.month();
            mes = meses.get(nMes-1);
            htmlText = htmlText.replace('{!Oportunidad_platform__c.Mes_Fecha_Cierre}', mes);
            htmlText = htmlText.replace('{!Oportunidad_platform__c.Año_Fecha_Cierre}', String.valueOf(op.Fecha_Cierre__c.year()));
        }// si Fecha_Cierre = null
            htmlText = htmlText.replace('{!Oportunidad_platform__c.Dia_Fecha_Cierre}', '..............');                               
            htmlText = htmlText.replace('{!Oportunidad_platform__c.Mes_Fecha_Cierre}', '..............');
            htmlText = htmlText.replace('{!Oportunidad_platform__c.Año_Fecha_Cierre}', '..............');
        
        //Comprovamos si hace falta anexo
        anexo = false;
        String nom_NOC;
        ID id_NOC;
        if(op.NOC__c != null){
            nom_NOC = op.NOC__r.Name;
            id_NOC = op.NOC__c;
            anexo = op.NOC__r.Anexo__c;
        }else if (op.NOC_12_Convenios__c != null){
            nom_NOC = op.NOC_12_Convenios__r.Name;
            id_NOC = op.NOC_12_Convenios__c;
            anexo = op.NOC_12_Convenios__r.Anexo__c;
            //para el contrato TAD es necesario el logo del recomendador de la NOC_12, si lo hay
            if(op.NOC_12_Convenios__r.Recomendador__r != null){
                logo = op.NOC_12_Convenios__r.Recomendador__r.logo__c;
            }
        }
        
        //--------------------
        if(op.Central__r.Ciudad__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Central}', op.Central__r.Ciudad__c);
        else htmlText = htmlText.replace('{!Oportunidad_platform__c.Central}', '..............');
        
        
        if(nom_NOC != null) htmlText = htmlText.replace('{!NOC.Nombre}', nom_NOC);
        else htmlText = htmlText.replace('{!NOC.Nombre}', '..............');

      	List <Relacion_entre_contactos__c> benef = [SELECT Beneficiario__c FROM Relacion_entre_contactos__c 
                                                        WHERE Oportunidad__c =: op.Id AND (Beneficiario_con_colgante__c = true 
                                                        OR Beneficiario_sin_colgante__c = true OR Usuario_principal__c = true )];
		Integer numBeneficiarios = Math.max(1, benef.size());
        String txtUsers = (numBeneficiarios < 2) ? 'USUARIO' : 'USUARIOS';
        
        if(numBeneficiarios < 2 && usuarioColgante.size() > 0){
            if(op.Precio_Colgantes__c != null)  {
                htmlText = htmlText.replace('{!Beneficiario_Adicional}', 'CADA BENEFICIARIO ADICIONAL: CUOTA ' + op.Precio_Colgantes__c/usuarioColgante.size() + ' €/MES');
            } else {
                htmlText = htmlText.replace('{!Beneficiario_Adicional}', 'CADA BENEFICIARIO ADICIONAL: CUOTA .............. €/MES');
            }
        }else htmlText = htmlText.replace('{!Beneficiario_Adicional}', '');
         
        //------- TABLA OFERTAS -------//
        Decimal precioServicio;
		Integer numPeriodos = 0;
        String htmlTablaOfertas = '';   
	    boolean hayDescuentos = false;		
        
        if(op.NOC__c!=null || op.NOC_12_Convenios__c!=null || op.Servicio__c!=null){
            if(op.NOC__c!=null || op.NOC_12_Convenios__c!=null){
                NOC__c noc = (op.NOC__c!=null) ? op.NOC__r : op.NOC_12_Convenios__r;
                //seleccionar el primer centro asociados a esa noc
                List<Centros_NOC__c> lcnoc = [ SELECT Id, Name, NOC__c, NOC_TAD__c, Duracion_Periodo_1__c, 
                                       Duracion_Periodo_2__c, Duracion_Periodo_3__c, 
                                       Importe_Periodo_1__c, Importe_Periodo_2__c, Importe_Periodo_3__c, Descuento_permanente_1__c, 
                                       Descuento_Periodo_1__c, Descuento_Periodo_2__c, Descuento_Periodo_3__c, Precio__c, Descuento__c, Precio_UCR_adicional_Base__c
                                       FROM Centros_NOC__c WHERE NOC_TAD__c =: noc.id and Servicio_TA__c  = :op.Servicio__c
															 and Central__c INCLUDES (:op.Central__r.Name) LIMIT 1 ];
                Centros_NOC__c cnoc = (lcnoc.size()>0) ? lcnoc.get(0)  : null;
                if(cnoc!=null){
					//si esta marcado descuento permanente entonces Precio en contrato es Quota Mensual
                    if(cnoc.Descuento_permanente_1__c){
                        numPeriodos = 1;
                        Decimal importePeriodo = op.Precio_Cuota_Mensual__c;
                        Decimal descuento = op.Descuento__c;
                        Decimal adicionalUsuarios = 0;
                        Decimal numAdicional = numBeneficiarios - 1.0;
                        if (numAdicional > 0) {
                            if (cnoc.Precio__c != null) adicionalUsuarios = (numAdicional.divide(1,2))*cnoc.Precio__c;
                            else adicionalUsuarios = (numAdicional.divide(1,2))*(cnoc.Precio_UCR_adicional_Base__c*(1.0-cnoc.Descuento__c));
                        }
                        
                        hayDescuentos = (descuento > 0);
                            htmlTablaOfertas += 
                            '<tr>' + 
                            '<td> permanente </td>' + 
                            '<td>' + ( (descuento!=null) ? descuento.divide(1, 2) : 100 - (importePeriodo.divide(op.Precio_Servicio__c, 2) * 100)  ) + '%</td>' + 
                            '<td>' + op.Precio_Cuota_Mensual__c + ' €/MES</td>' +
                            '</tr>'; 
                       
                        
                    //sino, tabla de ofertas    
                    }else{
                        for(Integer i = 1; i < 4; i++){
                            Integer duracionPeriodo = Integer.valueOf(cnoc.get('Duracion_Periodo_' + i + '__c'));
                            Decimal importePeriodo = (Decimal) cnoc.get('Importe_Periodo_'+ i + '__c');
                            Decimal descuento = (Decimal) cnoc.get('Descuento_Periodo_'+ i + '__c');
                            if (descuento != null) descuento = descuento.divide(1,2);
                            String periodo = (( duracionPeriodo!=null) ? duracionPeriodo + ' dias '  : 'Permanente' );
                            Decimal adicionalUsuarios = 0;
                            Decimal numAdicional = numBeneficiarios - 1.0;
                            if (numAdicional > 0) {
                                if (cnoc.Precio__c != null) adicionalUsuarios = (numAdicional.divide(1,2))*cnoc.Precio__c;
                                else adicionalUsuarios = (numAdicional.divide(1,2))*(cnoc.Precio_UCR_adicional_Base__c*(1.0-cnoc.Descuento__c.divide(1,2)));
                            }
                            hayDescuentos |= (descuento > 0);
                            if(importePeriodo!=null || descuento!=null){
                                numPeriodos++;
                                htmlTablaOfertas += 
                                    '<tr>' + 
                                        '<td>' + periodo + '</td>' + 
                                        '<td>' + ( (descuento!=null) ? descuento.divide(1, 2) : 100 - (importePeriodo.divide(op.Precio_Servicio__c, 2) * 100)  ) + '%</td>' + 
                                        '<td>' + ( (importePeriodo!=null) ? importePeriodo.divide(1,2) + adicionalusuarios : op.Precio_Servicio__c - (op.Precio_Servicio__c*descuento/100.0) +adicionalUsuarios).setScale(2) + ' €/MES</td>' +
                                    '</tr>';                        
                            }
                        } //fin for
                    }
                }
            //Servicio "Esencial 10"    
            } else {	
                List<Servicio__c> ls = [SELECT Name FROM Servicio__c WHERE id =: op.Servicio__c];
                if(ls.size() > 0){
                    Servicio__c s = ls.get(0);
                    System.debug('s.Name = ' + s.Name);
                    if(s.Name == 'Esencial 10'){
                        htmlTablaOfertas = 
                            '<tr>' + 
                            '<td> permanente </td>' + 
                            '<td>&nbsp;</td>' + 
                            '<td>' + op.Precio_Cuota_Mensual__c + ' €/MES</td>' +
                            '</tr>';                           
                    }
                }
        	}
            
            htmlTablaOfertas = (htmlTablaOfertas!='') ? 
                '<table style="width:100%;">' +
                '<tr><td><b>Periodo</b></td><td>' + 
                	((hayDescuentos) ? '<b>Descuento</b>' : '&nbsp;') +
                '</td><td><b>Importe final</b></td></tr>' + 
                ((hayDescuentos) ? htmlTablaOfertas : htmlTablaOfertas.replaceAll('0.00%', '')) +
                '</table>'
                : 
            '';
            
            htmlText = htmlText.replace('{!Tabla_Ofertas}', htmlTablaOfertas);                 
            
            //------ FIN Tabla de Ofertas -----

        
            if(nom_NOC != null){
                  NOC__c nc = [SELECT Name, Anexo__c FROM NOC__c WHERE id =: id_NOC];
                  if(nc.Anexo__c == true){
                      precioServicio = op.Precio_Servicio__c;
                      htmlText = htmlText.replace('{!Aplica_Descuento}', '');
                  }else{
                      precioServicio = op.Precio_Cuota_Mensual__c;
                      htmlText = htmlText.replace('{!Aplica_Descuento}', '*Esta tarifa tiene aplicado descuento por "' + nc.Name + '"');
                  }
                  //htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Servicio}', String.valueOf(precioServicio));       
                  //htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Servicio}', String.valueOf(numBeneficiarios + ' ' + txtUsers + ': CUOTA ' + String.valueOf(op.Precio_Servicio__c)));              
                  htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Servicio}', String.valueOf(numBeneficiarios + ' ' + txtUsers ));              
            }else{
                  htmlText = htmlText.replace('{!Aplica_Descuento}', '');
            }        
             
            
            if((precioServicio == null) && (op.Precio_Servicio__c != null)) {
                ////ej-> 2 USUARIOS: CUOTA 42.30 €/MES 
                String cuota = (numPeriodos<1) ? ': CUOTA ' + String.valueOf(op.Precio_Servicio__c) + ' €/MES' : '';
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Servicio}', 
                                              String.valueOf(numBeneficiarios + ' ' + txtUsers)); // + cuota));
            } else if ((precioServicio == null) && (op.Precio_Servicio__c == null)) {
                htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Servicio}', '..............  €/MES');
            }            
        }
        
        //-------------------------------------------  
        //Informacion para contrato TAM
        if(op.Servicio__c != null){
               /*if(op.Servicio__r.Tipo_de_dispositivos__c == 'MIMOV' || op.Servicio__r.Tipo_de_dispositivos__c == null){
                   htmlText = htmlText.replace('{!MIMOV}', 'X');
                   htmlText = htmlText.replace('{!GT300}', '');*/
               if((op.Servicio__r.Tipo_de_dispositivos__c == 'GT300') || (op.Servicio__r.Tipo_de_dispositivos__c == 'GSM')){
                   htmlText = htmlText.replace('{!GT300}', 'X');
                    htmlText = htmlText.replace('{!MIMOV}', '');
                 //Si dispositivo es 'MIMOV' o null o cualquier otro
               }else{
                   htmlText = htmlText.replace('{!MIMOV}', 'X');
                   htmlText = htmlText.replace('{!GT300}', '');
               }
         }else{
             htmlText = htmlText.replace('{!MIMOV}', '');
             htmlText = htmlText.replace('{!GT300}', '');
         }
         
         if(op.Servicio__r.Name != null) htmlText = htmlText.replace('{!Servicio.Nombre}', op.Servicio__r.Name);
         else htmlText = htmlText.replace('{!Servicio.Nombre}', '..............');
         if(op.Precio_Cuota_Mensual__c != null) htmlText = htmlText.replace('{!Servicio.Cuota_Mensual}', String.valueOf(op.Precio_Cuota_Mensual__c));
         else htmlText = htmlText.replace('{!Servicio.Cuota_Mensual}', '..............');
         if(op.Nombre_Entidad_Bancaria__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Nombre_Entidad}', op.Nombre_Entidad_Bancaria__c);
         else htmlText = htmlText.replace('{!Oportunidad_platform__c.Nombre_Entidad}', '..............');  
         if(op.IBAN__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.IBAN}', op.IBAN__c);
         else htmlText = htmlText.replace('{!Oportunidad_platform__c.IBAN}', '..............');
         /*
         if(op.Forma_de_pago_Dispositivo__c == 'Fraccionado') htmlText = htmlText.replace('{!Fraccionado}', 'X');
         else htmlText = htmlText.replace('{!Fraccionado}', '');
         if(op.Precio_Dispositivo__c != null) htmlText = htmlText.replace('{!Precio_Dispositivo}', String.valueOf(op.Precio_Dispositivo__c));
         else htmlText = htmlText.replace('{!Precio_Dispositivo}', '..............');
         */
        /* if(op.Precio_Dispositivo__c != null){*/
         
             htmlText = htmlText.replace('{!Compra_Terminal}', 'COMPRA DEL TERMINAL MÓVIL ESPECÍFICO:');
             if(op.Forma_de_pago_Dispositivo__c == 'Fraccionado'){
                 /*htmlText = htmlText.replace('{!Fraccionado}', '<div class="recuadro" style="width:12px; height:12px;text-align:center;">X</div>');
                 htmlText = htmlText.replace('{!Is_Pago_Contado}', '<div class="recuadro" style="width:12px; height:12px;text-align:center;"></div>'); */  
                 htmlText = htmlText.replace('{!Fraccionado}', 'X');
                 htmlText = htmlText.replace('{!Is_Pago_Contado}', '');
             }else{
                 htmlText = htmlText.replace('{!Fraccionado}', '');
                 htmlText = htmlText.replace('{!Is_Pago_Contado}', 'X');
                 /*htmlText = htmlText.replace('{!Fraccionado}', '<div class="recuadro" style="width:12px; height:12px;text-align:center;"></div>');
                 htmlText = htmlText.replace('{!Is_Pago_Contado}','<div class="recuadro" style="width:12px; height:12px;text-align:center;">X</div>');*/
             }
             /*htmlText = htmlText.replace('{!Pago_Al_Contado}', 'Pago al contado:');*/
        	Recordtype oportunidadTAM = [select id from recordtype where name = 'Oportunidad TAM'];
             if(op.Precio_Dispositivo__c != null){
                 if (op.Precio_Dispositivo_new__c != null && op.Precio_Dispositivo_new__c == 0 && op.RecordTypeId == oportunidadTAM.id) {
                     htmlText = htmlText.replace('{!Precio_Dispositivo}', 'Pagado');
                     htmlText = htmlText.replace('{!Pago_Mes}', '..............');
                     htmlText = htmlText.replace('{!Pago_Total}', '..............');
                 } else {
                    htmlText = htmlText.replace('{!Precio_Dispositivo}', String.valueOf(op.Precio_Dispositivo__c));
                 	Decimal pagoMes = op.Precio_Dispositivo__c/10;
                 	htmlText = htmlText.replace('{!Pago_Mes}', String.valueOf(pagoMes));
                 	htmlText = htmlText.replace('{!Pago_Total}', String.valueOf(pagoMes*11));
                 }
                
             }//si precio_dispositivo = null
                 htmlText = htmlText.replace('{!Precio_Dispositivo}', '..............');
                 htmlText = htmlText.replace('{!Pago_Mes}', '..............');
                 htmlText = htmlText.replace('{!Pago_Total}', '..............');
             
             /*htmlText = htmlText.replace('{!Pago_Financiado}', 'Pago financiado 11 meses');
             htmlText = htmlText.replace('{!Cuotas}', '18,00 €/mes x 11 cuotas');
             htmlText = htmlText.replace('{!Total}', '(total 198,00€)*');*/
         /*}
         else{
             htmlText = htmlText.replace('{!Compra_Terminal}', '');
             htmlText = htmlText.replace('{!Pago_Al_Contado}', '');
                                           
             htmlText = htmlText.replace('{!Fraccionado}', '');
             htmlText = htmlText.replace('{!Is_Pago_Contado}', '');
             htmlText = htmlText.replace('{!Precio_Dispositivo}', '');
             htmlText = htmlText.replace('{!Pago_Financiado}', '');
             htmlText = htmlText.replace('{!Cuotas}', '');
             htmlText = htmlText.replace('{!Total}', '');
         }  */                
        
        if(cp != null){
            if(cp != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Pagador}', cp.FirstName + ' ' + cp.LastName);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Pagador}', '..............'); 
            
            //informacion contrato de prestacion de teleasistencia
            if(cp.Tipo_Documento_Identidad__c != null) htmlText = htmlText.replace('{!Pagador.Tipo_Documento}', cp.Tipo_Documento_Identidad__c);
            else htmlText = htmlText.replace('{!Pagador.Tipo_Documento}', '..............');
            
            if(cp.CIF_NIF__c != null) htmlText = htmlText.replace('{!Pagador.CIF_NIF}', cp.CIF_NIF__c);
            else htmlText = htmlText.replace('{!Pagador.CIF_NIF}', '..............');
            
            if(cp.Calle__c != null) htmlText = htmlText.replace('{!Pagador.Calle}', cp.Calle__c);
            else htmlText = htmlText.replace('{!Pagador.Calle}', '..............');
            if(cp.Codigo_Postal__c != null)  htmlText = htmlText.replace('{!Pagador.CP}', cp.Codigo_Postal__c);
            else htmlText = htmlText.replace('{!Pagador.CP}', '..............');
            if(cp.Ciudad__c != null) htmlText = htmlText.replace('{!Pagador.Ciudad}', cp.Ciudad__c);
            else htmlText = htmlText.replace('{!Pagador.Ciudad}', '..............');
            if (cp.Provincia__c != null) htmlText = htmlText.replace('{!Pagador.Provincia}', cp.Provincia__c);
            else htmlText = htmlText.replace('{!Pagador.Provincia}', '..............');
        }
        
        if(ac_up != null){                
            htmlText = htmlText.replace('{!UsuarioPrincipal.Nombre}', ac_up.FirstName + ' ' + ac_up.LastName);
            if(ac_up.Tipo_Documento_Identidad__c != null) htmlText = htmlText.replace('{!UsuarioPrincipal.Tipo_Documento}', ac_up.Tipo_Documento_Identidad__c);
            else htmlText = htmlText.replace('{!UsuarioPrincipal.Tipo_Documento}', '..............');
            if(ac_up.CIF_NIF__c != null) htmlText = htmlText.replace('{!UsuarioPrincipal.CIF_NIF}', ac_up.CIF_NIF__c);
            else htmlText = htmlText.replace('{!UsuarioPrincipal.CIF_NIF}', '..............');
         }
         //si hay usuarios con colgante deben aparecer en el cuarto punto de la seccion 'Exponen'
         String nom, tipo_documento, dni;
         if(ac_uc != null){
            /* htmlText = htmlText.replace('{!UsuarioColgante.Nombre}', ac_uc.FirstName + ' ' + ac_uc.LastName);
             if(ac_uc.Tipo_Documento_Identidad__c != null) htmlText = htmlText.replace('{!UsuarioColgante.Tipo_Documento}', ac_uc.Tipo_Documento_Identidad__c);
             else htmlText = htmlText.replace('{!UsuarioColgante.Tipo_Documento}', '..............');
             if(ac_uc.CIF_NIF__c != null) htmlText = htmlText.replace('{!UsuarioColgante.CIF_NIF}', ac_uc.CIF_NIF__c);
             else htmlText = htmlText.replace('{!UsuarioColgante.CIF_NIF}', '..............');*/
             nom = ac_uc.FirstName + ' ' + ac_uc.LastName;
             if(ac_uc.Tipo_Documento_Identidad__c != null) tipo_documento = ac_uc.Tipo_Documento_Identidad__c;
             else tipo_documento = '..............';
             if(ac_uc.CIF_NIF__c != null) dni = ac_uc.CIF_NIF__c;
             else dni = '..............';
             htmlText = htmlText.replace('{!BeneficiarioColgante1}', 'D./Dña.: <font style="text-transform:uppercase;">' + nom + '</font> con ' + tipo_documento + ' Nº ' + dni);
          }else htmlText = htmlText.replace('{!BeneficiarioColgante1}', ''); 
          if(ac_uc2 != null){
             nom = ac_uc2.FirstName + ' ' + ac_uc2.LastName;
             if(ac_uc2.Tipo_Documento_Identidad__c != null) tipo_documento = ac_uc2.Tipo_Documento_Identidad__c;
             else tipo_documento = '..............';
             if(ac_uc2.CIF_NIF__c != null) dni = ac_uc2.CIF_NIF__c;
             else dni = '..............';
             htmlText = htmlText.replace('{!BeneficiarioColgante2}', 'D./Dña.: <font style="text-transform:uppercase;">' + nom + '</font> con ' + tipo_documento + ' Nº ' + dni);
          }else htmlText = htmlText.replace('{!BeneficiarioColgante2}', ''); 
          
         //Informacion para anexo al contrato
         if(anexo == true){
             plantilla2 = [SELECT Id, Name, HtmlValue, Body FROM EmailTemplate WHERE Name = 'Anexo campaña verano'];
             htmlText2 = plantilla2.HtmlValue;
             
             htmlText2 = htmlText2.replace('{!NOC.Nombre}', nom_NOC);
             htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.Servicio.Name}', op.Servicio__r.Name);
             
             List <Relacion_entre_contactos__c> beneficiarios = [SELECT Beneficiario__c FROM Relacion_entre_contactos__c WHERE Oportunidad__c =: op.Id AND (Beneficiario_con_colgante__c = true OR Beneficiario_sin_colgante__c = true OR Usuario_principal__c = true OR Pagador__c = true)];

            if(beneficiarios.size() == 1) {
                 htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.N_Beneficiarios}', '1 usuario');
                 /*if(op.Precio_Cuota_Mensual__c != null) htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.Cuota_mensual}', String.valueOf(op.Precio_Cuota_Mensual__c));
                 else htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.Cuota_mensual}', '..............');*/
            }else{
                htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.N_Beneficiarios}', String.valueOf(beneficiarios.size()) + ' usuarios');
                
               /* if(op.Precio_Colgantes__c != null) htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.Cuota_mensual}', String.valueOf(op.Precio_Colgantes__c));
                else htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.Cuota_mensual}', '..............');*/
            }
            /*Decimal total;
            if(op.Precio_Colgantes__c != null){
                total = op.Precio_Cuota_Mensual__c + op.Precio_Colgantes__c;
            }else{
                total = op.Precio_Cuota_Mensual__c;
            }*/
            htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.Cuota_mensual}', String.valueOf(op.Precio_Cuota_Mensual__c));
            htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.Cuota_mensual_sin_descuento}', String.valueOf(op.Precio_Cuota_Mensual_Sin_Descuento__c));
            htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.Pagador}', cp.FirstName + ' ' + cp.LastName);
            precioServicio = op.Precio_Servicio__c;
            htmlText2 = htmlText2.replace('{!Oportunidad_platform__c.Precio_Servicio}', String.valueOf(precioServicio)) + ' €/MES';
            
            
            /*if(us != null) htmlText2 = htmlText2.replace('{!Director_Terriorial_Domiciliaria}', us.Name);
            else htmlText2 = htmlText2.replace('{!Director_Territorial_Domiciliaria}', '..............');*/
         }
  
          
          
        //Autorización domiciliación bancaria
        plantilla3 = [SELECT Id, Name, HtmlValue, Body FROM EmailTemplate WHERE Name = 'Autorización domiciliación bancaria'];
        htmlText3 = plantilla3.HtmlValue;
        
        if(cp != null){
            htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.Pagador}', cp.FirstName + ' ' + cp.LastName);
            if(cp.Tipo_Documento_Identidad__c != null) htmlText3 = htmlText3.replace('{!Pagador.Tipo_Documento}', cp.Tipo_Documento_Identidad__c);
            else htmlText3 = htmlText3.replace('{!Pagador.Tipo_Documento}', '..............');
            if(cp.CIF_NIF__c != null) htmlText3 = htmlText3.replace('{!Pagador.CIF_NIF}', cp.CIF_NIF__c);
            else htmlText3 = htmlText3.replace('{!Pagador.CIF_NIF}', '..............');
            if(cp.Calle__c != null) htmlText3 = htmlText3.replace('{!Pagador.Calle}', cp.Calle__c);
            else htmlText3 = htmlText3.replace('{!Pagador.Calle}', '..............');
        }
        if((ac_up != null) && (ac_up.Id != cp.Id)){
            htmlText3 = htmlText3.replace('{!UsuarioPrincipal.Nombre}', ac_up.FirstName + ' ' + ac_up.LastName);
            //String tipo_documento_up = '..............', dni_up = '..............';
            String tipo_documento_up = (ac_up.Tipo_Documento_Identidad__c!=null) ? ac_up.Tipo_Documento_Identidad__c : '..............';
            String dni_up = (ac_up.CIF_NIF__c !=null) ? ac_up.CIF_NIF__c : '..............';
            if(ac_up.Tipo_Documento_Identidad__c != null) htmlText3 = htmlText3.replace('{!UsuarioPrincipal.Tipo_Documento}', ac_up.Tipo_Documento_Identidad__c);
            //else htmlText3 = htmlText3.replace('{!UsuarioPrincipal.Tipo_Documento}', '..............');
            if(ac_up.CIF_NIF__c != null) htmlText3 = htmlText3.replace('{!UsuarioPrincipal.CIF_NIF}', ac_up.CIF_NIF__c);
            //else htmlText3 = htmlText3.replace('{!UsuarioPrincipal.CIF_NIF}', '..............');
            htmlText3 = htmlText3.replace('{!Beneficiario.Informacion}', ' <strong>o en representacion de D./Dña.</strong> ' + ac_up.FirstName + ' ' + ac_up.LastName + ' con <strong>' + tipo_documento_up + ' número:</strong> ' + dni_up);
        }else htmlText3 = htmlText3.replace('{!Beneficiario.Informacion}', '');                                                                                                                 
        if(op.IBAN__c != null) htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.IBAN}', op.IBAN__c);
        else htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.IBAN}', '..............');
        
        if(op.Fecha_cierre__c != null) {
             htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.Dia_Fecha_cierre}', String.valueOf(op.Fecha_cierre__c.day()));
             nMes = op.Fecha_cierre__c.month();
             mes = meses.get(nMes-1);
             htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.Mes_Fecha_cierre}', mes);
             htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.Año_Fecha_cierre}', String.valueOf(op.Fecha_cierre__c.year()));
        }// if Fecha_cierre = null
             htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.Dia_Fecha_cierre}', '..............');
             htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.Mes_Fecha_cierre}', '..............');
             htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.Año_Fecha_cierre}', '..............');
        
        if(op.Central__r.Ciudad__c != null) htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.Central}', op.Central__r.Ciudad__c);
        else htmlText3 = htmlText3.replace('{!Oportunidad_platform__c.Central}', '..............');
        //------------------------
        //if(us != null) htmlText = htmlText.replace('{!Director_Territorial_Domiciliaria}', us.Name); 
        /*else htmlText = htmlText.replace('{!Director_Territorial_Domiciliaria}', '..............');   */    
             
       
    }                                   
}