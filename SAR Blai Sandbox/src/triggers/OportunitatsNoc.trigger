/** 
* File Name:   tgOportunitatsNoc 
* Description: Controla los NOCs asignados a las oportunidades
* Copyright:   Konozca 
* @author:     Sergi Aguilar / Hector Mañosas
* Modification Log 
* =============================================================== 
*Date           Author          Modification 
* 18/07/2014    HManosas        Replanteamiento NOC y precio total manual
* 25/07/2014    HManosas    
* 11/12/2014    AGimenez        Optimizacion del trigger y eliminacion de redundancias en el codigo
* 29/01/2015    XGarcia         Hacer que el trigger solo se ejecute una vez cuando se modifica la oportunidad.
* 10/03/2015    XGarcia         Hacer que se tenga en cuenta el campo transporte en la búsqueda del servicio de la NOC y
la modificación del número de plazas en las noc 11 centro
* 18/05/2015    XGarcia         Adaptar el trigger a los descuentos de TA
* 09/09/2015    EBarrero        Evitar generar errores a oportunidades que empiecen por "XX/" o "OP"  
*           cambio todos    addErrorOp('...');
*           por             triggerHelper.addErrorOp(opc,'...');
*           24 cambios
* 17/09/2015    EBarrero    Incidencia: No pueden cerrar oportunidades de la campaña de verano
*                           Al cerrar una oportunidad ganada y hacer click en "contrato firmado" obtienen este error: 
*                           La oportunidad de la NOC no coincide o no está activa
*                           Este mensaje aparece 4 veces y lo he marcado con un código para diferenciarlo

28/09/2015 XGarcia //Modificacion: Si la noc es campaña puede estar en una opp aunque no esté en periodo siempre que "estado campaña" esté abierta
                                         (Tanto en residencial como en TA)
*
* ========== ===================================================== 
**/ 
trigger OportunitatsNoc on Oportunidad_platform__c (before insert, before update) {
    /*List<Logs__c> logs = new List<Logs__c>();
    List<String> Errores = new List<String>();*/
    System.debug('salto trigger OportunitatsNoc');
    
    if (TriggerHelperExecuteOnce.executar4() == true && userInfo.getUserName() != 'wssarq@sarquavitae.es') {
        
        String divi, zComercial;
        Id centro,IdNoc,central;
        String centralName;
        String tServicio, tEstancia, tOcup, grado;
        Double minDescuentoCentro, minDescuentoZona, minDescuentoDivi,numPlazas,numPlazasRotacion,minDescuentoNoc9,minDescuentoNoc12,DescuentoColgante,PrecioDispositivo;
        Boolean encontrado, encontradoParcial, noCumple, recomendador,hayPlazas,hayPlazasRotacion,encontrado2,encontradoParcial2,noCumple2;   
        //System.debug('LABEL: '+Label.Activacion_de_la_integracion);
        //System.debug('todofalse: '+triggerHelper.todofalse());
        if(Label.Activacion_de_la_integracion != 'No' && triggerHelper.todofalse()) {
            
            Boolean isValidOp = false;
            /*for(Oportunidad_platform__c opc : trigger.new) {
                if (opc.RecordTypeId == '012b0000000QIjW' || opc.RecordTypeId == '012b0000000QIDZ' ||opc.RecordTypeId == '012b0000000QIDe' ||opc.RecordTypeId == '012b0000000QBG6' ||opc.RecordTypeId == '012b0000000QBG1') {
                    isValidOp = true;
                }
            }
            if (isValidOp) {*/
                List<NOC__c> NocsCentresModificades = new List<NOC__c>();
                id RTttad = Schema.SObjectType.Tarifa__c.getRecordTypeInfosByName().get('Tarifas TAD').getRecordTypeId();
                id RTttam= Schema.SObjectType.Tarifa__c.getRecordTypeInfosByName().get('Tarifas TAM').getRecordTypeId();
                List<Tarifa__c> lt = [Select Id,Tarifa_Vigente__c, Servicio__c, Centro__c, NOC__c, Tipo_Tarifa__c, Precio__c, Precio_Plus__c From Tarifa__c where recordtypeid = '012b0000000QBcH' or recordtypeid = '012b0000000QBcM'];
                List<Tarifa__c> TarifasTA = [Select Id,Precio_servicio__c,Precio_dispositivo__c,Precio_ucr_adicional__c,Precio_beneficiario_sin_ucr__c,Tarifa_Vigente__c,NOC__c,Central__c,Servicio_TA__c,Precio_cuota_inicial__c From Tarifa__c where recordtypeid =: RTttad or recordtypeid =:RTttam];
                //System.debug('TARIFAS TA.SIZE: '+TarifasTA.size());
                //cogemos las nocs con tipo de registro Noc10
                List<NOC__c> ln10 = [Select Id, Estado_Flujo__c, Fecha_inicio__c, Fecha_fin__c, Oportunidad__c, Oportunidad_renegociada__c, Descuento__c, Descuento_aplicado__c From NOC__c Where RecordTypeId = '012b0000000QBclAAG'];
                //cogemos todas las NOC
                List<NOC__c> lnoc = [Select Id,Importe_Fianza_a_cobrar__c,Fianza_a_cobrar__c, Estado_Campana__c,Numero_de_plazas_libres__c,Numero_de_plazas_en_rotacion_libres__c,Numero_de_plazas__c,Numero_de_plazas_en_rotacion__c, No_se_solicita_fianza__c, Centro__c, Estado_Flujo__c, Fecha_inicio__c, Fecha_fin__c, Oportunidad__c, Oportunidad_renegociada__c, Descuento__c, Descuento_aplicado__c, Descuento_permanente__c, Recomendador__c,Fecha_Inicio_1__c,Fecha_Inicio_2__c,Fecha_Inicio_3__c,Fecha_Inicio_4__c,Fecha_Inicio_5__c,Fecha_Inicio_6__c,Fecha_Fin_1__c,Fecha_Fin_2__c,Fecha_Fin_3__c,Fecha_Fin_4__c,Fecha_Fin_5__c,Fecha_Fin_6__c,Descuento_Mes_1__c,Descuento_Mes_2__c,Descuento_Mes_3__c,Descuento_Mes_4__c,Descuento_Mes_5__c,Descuento_Mes_6__c From NOC__c];
                //cogemos los centros NOC
                List<Centros_NOC__c> lCNoc = [Select Id,Descuento_Dispositivo__c,Precio_Dispositivo__c,Importe_Periodo_1__c,Central__c,Servicio_TA__c,Tarifa_TA__c,Centro__c,Tipo_de_servicio_TA__c,Tipo_de_periferico__c,Cuota_inicial__c,Activo__c,NOC_TAD__c,NOC__c, Division__c, Zona_Comercial_2__c, Tipo_Servicio_2__c, Tipo_Estancia_2__c, Tipo_Ocupacion_2__c, Grado__c, Descuento__c, Precio__c,Transporte__c,Descuento_Periodo_1__c,Descuento_Periodo_2__c,Descuento_Periodo_3__c From Centros_NOC__c];
                //Obtenemos el Id del RecordType "Centro"
                RecordType recordCentro = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'Centro' AND SObjectType = 'Account' LIMIT 1];
                //Obtenemos el Id del RecordType "Entidad Recomendadora"
                RecordType recordEntidad = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'Entidad Recomendadora' AND SObjectType = 'Account' LIMIT 1];
                //cogemos los Accounts tipo = "Centro"
                List<Account> centros = [SELECT Id, Name, Division__c, Zona_Comercial_del__c FROM Account WHERE RecordTypeId =: recordCentro.Id];
                //Cogemos los Accounts tipo = "Empresa_Recomendador"
                Map<Id, Account> recomendadoras = new Map<Id, Account>([SELECT Id, Name, ParentId FROM Account WHERE RecordTypeId =: recordEntidad.Id]);
                List<id> OportunidadesTAD = new List<id>();
                //Obtenemos la lista de Servicios
                id RTsta = Schema.SObjectType.Servicio__c.getRecordTypeInfosByName().get('Servicios TA').getRecordTypeId();
                id RTsres = Schema.SObjectType.Servicio__c.getRecordTypeInfosByName().get('Servicios Residenciales').getRecordTypeId();
                List<Servicio__c> servicios = [SELECT Id, Name, Tipo_Servicio__c, Tipo_Estancia__c, Tipo_Ocupacion__c, Grado_Dependencia__c,Transporte__c FROM Servicio__c where recordtypeid ='012b0000000QIES'];
                List<Servicio__c> serviciosTA = [SELECT Id, Name, Tipo_de_servicio_TA__c, Tipo_de_periferico__c,Activo__c,Cuota_inicial__c,Descripcion__c FROM Servicio__c where recordtypeid =: RTsta];
                /*List<Servicio__c> servicioColgante = [SELECT Id, Name, Tipo_de_servicio_TA__c, Tipo_de_periferico__c,Activo__c,Cuota_inicial__c,Descripcion__c FROM Servicio__c where recordtypeid = '012110000000hiy' and Servicio_con_Colgante__c = true];
                List<Servicio__c> servicioSinColgante = [SELECT Id, Name, Tipo_de_servicio_TA__c, Tipo_de_periferico__c,Activo__c,Cuota_inicial__c,Descripcion__c FROM Servicio__c where recordtypeid = '012110000000hiy' and Servicio_sin_Colgante__c = true];*/
                Map<id,boolean> ErroresResidente = new Map<id,boolean>();
                List<Id> idResidentes = new List<Id>();
                List<id> ResidentesTelefono = new List<id>();
                Map<id,Decimal> PreciosColgante = new Map<id,Decimal>();
                Map<id,Decimal> PreciosSinColgante = new Map<id,Decimal>();
                //Decimal PrecioColgante = 0;
                for(Oportunidad_platform__c opc : trigger.new) {
                    idResidentes.add(opc.Residente__c);
                    if ((opc.Etapa__c == 'Ingreso' || opc.etapa__c == 'Preingreso')&&(opc.recordtypeid == '012b0000000QBG6AAO' || opc.recordtypeid == '012b0000000QBG1')) {
                        ResidentesTelefono.add(opc.Residente__c);
                    }
                }
                if (ResidentesTelefono.size() > 0) {
                    for (Relacion_entre_contactos__c familiar:[select residente__c,contacto__c,contacto__r.Phone,contacto__r.PersonMobilePhone,contacto__r.Telefono_2__c,contacto__r.Telefono_3__c,contacto__r.Telefono_4__c,contacto__r.No_tiene_correo_electronico__c,contacto__r.PersonEmail from Relacion_entre_contactos__c where residente__c IN:ResidentesTelefono and (contacto__r.Phone = null or contacto__r.PersonEmail =null )]) {
                        if ((familiar.contacto__r.PersonEmail == null && familiar.contacto__r.Phone == null && familiar.contacto__r.PersonMobilePhone == null && familiar.contacto__r.Telefono_2__c == null && familiar.contacto__r.Telefono_3__c == null && familiar.contacto__r.Telefono_4__c == null)||(familiar.contacto__r.PersonEmail == null && familiar.contacto__r.No_tiene_correo_electronico__c == false)) {
                            ErroresResidente.put(familiar.residente__c,true);
                        }
                    }
                    for (Account residenteTel:[SELECT id,Phone,No_tiene_correo_electronico__c,PersonEmail,PersonMobilePhone,Telefono_2__c,Telefono_3__c,Telefono_4__c from account where id IN:ResidentesTelefono]) {
                        if ((residenteTel.PersonEmail == null && residenteTel.Phone == null && residenteTel.PersonMobilePhone == null && residenteTel.Telefono_2__c == null && residenteTel.Telefono_3__c == null && residenteTel.Telefono_4__c == null)||(residenteTel.PersonEmail == null && residenteTel.No_tiene_correo_electronico__c == false)) {
                                ErroresResidente.put(residenteTel.id,true);
                        }
                    }
                }
                List<Account> residentes = [Select Id, Name, PersonBirthdate FROM Account WHERE Id In :idResidentes];
                List<Account> restoUpd = new List<Account>();
                //relaciones de residentes y contactos
                List<Relacion_entre_contactos__c> lrec = [Select Id, Residente__c, Familiar_de_referencia__c, Contacto__c From Relacion_entre_contactos__c Where RecordTypeId = '012b0000000QCbyAAG' and Residente__c In :idResidentes];
                
                Integer pos = 0;
                //por cada oportunidad insertada
                for(Oportunidad_platform__c opc : trigger.new) {
                        
                    if (opc.recordtypeid == '012b0000000QBG6AAO' || opc.recordtypeid == '012b0000000QBG1') {
                        //Comprovaciones correo y telefono de los familiares en etapa ingreso
                        if (opc.Etapa__c == 'Ingreso' || opc.etapa__c == 'Preingreso') {
                            if (ErroresResidente.get(opc.residente__c) != null) triggerHelper.addErrorOp(opc,'Los familiares del residente tienen que tener el téléfono o el correo electrónico informado y tener el check de No_tiene_correo_electronico si no tiene correo.');
                        }
                        //comprobamos que solo haya como máximo un descuento
                        integer NDes = 0;
                        if(opc.NOC__c <> Null) ++NDes;
                        if(opc.NOC_11_Persona__c <> Null) ++NDes;
                        if(opc.NOC_11_Centro__c <> Null) ++NDes;
                        if(opc.NOC_11_Renegociado__c <> Null) ++NDes;
                        if(opc.NOC_12_Convenios__c <> Null) ++NDes;
                        
                        if(NDes == 0 && (opc.Descuento__c != null && opc.Descuento__c != 0)) {
                            opc.Descuento__c = null;
                            System.debug('NO TENGO DESCUENTOS');
                        }
                        else System.debug('Tengo algun descuento');


                        //Tarifa__c tarifa = [SELECT id FROM Tarifa__c WHERE id =: opc.Tarifa__c];

                        
                        if(opc.Motivio_de_Alta_GCR__c != NULL)  {
                            //comprobamos si ha habido una baja del residente que proviene de GCR y actualizamos a GCR
                            MotivosAlta ma = new MotivosAlta(); 
                            String tipOp = '';
                            if(opc.RecordTypeId == '012b0000000QBG6AAO') {
                                tipOp = 'Oportunidad privada';
                            }
                            else if(opc.RecordTypeId == '012b0000000QBG1AAO') {
                                tipOp = 'Oportunidad pública';
                            }
                            opc.Motivo_de_Alta_Comercial__c = ma.getSFMotivo(new List<String>{tipOp, (opc.Motivio_de_Alta_GCR__c==NULL) ? '' : opc.Motivio_de_Alta_GCR__c, (opc.Tipo_de_estancia__c==NULL) ? '' : opc.Tipo_de_estancia__c, (opc.Destino__c==NULL) ? '' : opc.Destino__c});
                            Account res = new Account();
                            Boolean upd = false;
                            res.Id = opc.Residente__c;
                            if(opc.Motivo_de_Alta_Comercial__c != null) {
                                res.Exitus__c = false;
                                res.Baja__c = true;
                                upd = true;
                                if(opc.Motivo_de_Alta_Comercial__c == 'Exitus') {
                                    res.Exitus__c = true;
                                }   
                            }
                            //si hay fecha real de ingreso baja tiene que ser false
                            if(opc.Fecha_real_de_ingreso__c != Null && opc.Motivo_de_Alta_Comercial__c == Null) {
                                res.Baja__c = false;
                                upd = true;
                            }
                            if(upd && res.Id != Null) {
                                res.Ultima_Mod__c = 'fromGCR';
                                restoUpd.add(res);
                                
                            }
                        }
                        
                        //comprobamos que el residente y persona de contacto son correctos en la etapa preingreso
                        if((opc.Etapa__c == 'Preingreso' || opc.Etapa__c == 'Ingreso') && (opc.RecordTypeId != '012b0000000QC6IAAW')) { //se ha añadido la comprobación de si es una oportunidad Adorea
                            //comprobamos si la fecha de nacimiento esta indicada
                            Boolean enRes = false;
                            for(Integer i = 0; i < residentes.Size() && !enRes; ++i) {
                                if(residentes[i].Id == opc.Residente__c) {
                                    enRes = true;
                                    //Si la op ha sido creada por el Admin, proviene de una carga de datos
                                    if(residentes[i].PersonBirthdate == null && opc.CreatedById != '005b0000000kj7HAAQ') {
                                            triggerHelper.addErrorOp(opc,'El residente no tiene la fecha de nacimiento informada');
                                    }    
                                }
                            }
                            
                            //comprobamos las relaciones entre residente, pagador y persona de contacto
                            Boolean en = false;
                            Boolean enPag = false;
                            Boolean enPCon = false;
                            if(opc.Persona_de_Contacto__c == null) enPCon = true;
                            for(Integer i = 0; i < lrec.Size() && (!en || !enPag); ++i) {
                                if(lrec[i].Residente__c == opc.Residente__c) {
                                    if(!en && lrec[i].Familiar_de_referencia__c == true) en = true;
                                    if(!enPag && lrec[i].Contacto__c == opc.Pagador__c && opc.Residente__c != opc.Pagador__c) enPag = true;
                                    if(!enPCon && lrec[i].Contacto__c == opc.Persona_de_Contacto__c && opc.Residente__c != opc.Persona_de_Contacto__c) enPCon = true;
                                }
                            }
                            if(!en && opc.CreatedById != '005b0000000kj7HAAQ') {
                                    triggerHelper.addErrorOp(opc,'El residente no tiene ningún familiar de referencia');
                            }
                            if(!enPag && opc.Pagador__c != null && opc.Residente__c != opc.Pagador__c && opc.CreatedById != '005b0000000kj7HAAQ') {
                                triggerHelper.addErrorOp(opc,'El pagador no tiene relación con el residente');
                            }
                            if(!enPCon && opc.Residente__c != opc.Persona_de_Contacto__c && opc.CreatedById != '005b0000000kj7HAAQ') triggerHelper.addErrorOp(opc,'La persona de contacto no tiene relación con el residente');
                        }
                        System.debug('Arribes');
                        //comprobamos que la etapa sea correcta
                        if ((opc.Etapa__c == 'Pendiente Visita' || opc.Etapa__c == 'Visita Planificada / Espontánea' || opc.Etapa__c == 'Presentado Plan Personal' || opc.Etapa__c == 'Preingreso' || opc.Etapa__c == 'Ingreso' || opc.Etapa__c == 'No ingreso') && opc.RecordTypeId != '012b0000000QBG1AAO') 
                        {
                            try {
                                //vaciamos algunos campos
                                opc.Precio_Plus__c = Null;
                                opc.Precio__c = Null;
                                opc.No_Finanza__c = false;
                                
                                //comprobamos la tarifa
                                Boolean enc = false;

                                //buscamos la tarifa que corresponde a la oportunidad
                                for(integer i = 0; i < lt.Size() && !enc; ++i) 
                                {
                                    System.debug('arribes2');
                                    if(lt[i].Tarifa_vigente__c && lt[i].Servicio__c == opc.Servicio__c && lt[i].Tipo_Tarifa__c == opc.Tipo_de_tarifa__c && lt[i].Centro__c == opc.Centro2__c) {
                                        //buscamos una noc en la tarifa que cumpla los requisitos
                                        System.debug('arribes2555');
                                        for(integer j = 0; j < ln10.Size() && !enc; ++j) {
                                            System.debug('arribes3');
                                            if(lt[i].NOC__c == ln10[j].Id) {
                                                System.debug('arribes4');
                                                if(trigger.IsUpdate && ln10[j].Estado_Flujo__c == 'Aprobado' && ln10[j].Fecha_inicio__c <= opc.CreatedDate && ln10[j].Fecha_fin__c >= opc.CreatedDate ) {
                                                    enc = true;
                                                    opc.Precio__c = lt[i].Precio__c;
                                                    if(opc.Plus__c) opc.Precio_Plus__c = lt[i].Precio_Plus__c;                                                                           
                                                    opc.Tarifa__c = lt[i].Id;
                                                    System.debug('Tarifa encontrada');
                                                }
                                                else if(ln10[j].Estado_Flujo__c == 'Aprobado' && ln10[j].Fecha_inicio__c <= Date.today() && ln10[j].Fecha_fin__c >= Date.today()) {
                                                    enc = true;
                                                    opc.Precio__c = lt[i].Precio__c;
                                                    if(opc.Plus__c) opc.Precio_Plus__c = lt[i].Precio_Plus__c;                                                                           
                                                    opc.Tarifa__c = lt[i].Id; 
                                                    System.debug('Tarifa encontrada');
                                                }
                                            } 
                                        }
                                    } 
                                }
                                if(opc.Plus__c && opc.Precio_Plus__c == null && opc.CreatedById != '005b0000000kj7HAAQ') triggerHelper.addErrorOp(opc,'La Tarifa seleccionada no tiene precio Plus');
                                if(!enc && !((opc.Servicio__c == null || opc.Tipo_de_tarifa__c == null)) && opc.CreatedById != '005b0000000kj7HAAQ') triggerHelper.addErrorOp(opc,'No se encontró tarifa para la combinación de servicio y tipo de tarifa seleccionada');
                                
                                if(NDes > 1) triggerHelper.addErrorOp(opc,'Solo se permite aplicar un único descuento');
                                else if(NDes == 1) 
                                {
                                    System.debug('Vamosa buscarque descuento es el mas idoneo para este caso');
                                    Double descuento = null;
                                    Boolean noFianza = false;
                                    encontrado = false;
                                    //hacemos una accion o otra en funcion del tipo de NOC
                                    Boolean encN = false;                  
                                    
                                    //NOC 11 persona: comprobamos que el NOC apunte a esta oportunidad
                                    if(opc.NOC_11_Persona__c <> Null) 
                                    {
                                        for(integer i = 0; i < lnoc.Size() && !encN; ++i) 
                                        {
                                            if(lnoc[i].Id == opc.NOC_11_Persona__c) 
                                            {
                                                System.debug('ES NOC PERSONAL');
                                                if (lnoc[i].Fecha_inicio__c != null || lnoc[i].Fecha_fin__c != null) {
                                                    System.debug('ES NOC PERSONAL sense periodes');
                                                    if(lnoc[i].Oportunidad__c == opc.Id && lnoc[i].Estado_Flujo__c == 'Aprobado' && lnoc[i].Fecha_inicio__c <= Date.today() && lnoc[i].Fecha_fin__c >= Date.today() && !lnoc[i].Descuento_permanente__c || (lnoc[i].Oportunidad__c == opc.Id && lnoc[i].Estado_Flujo__c == 'Aprobado' && lnoc[i].Fecha_inicio__c <= Date.today() && lnoc[i].Descuento_permanente__c)) 
                                                    {
                                                        encN = true;
                                                        descuento = lnoc[i].Descuento_Aplicado__c;
                                                        if (lnoc[i].Importe_Fianza_a_cobrar__c == 0 || lnoc[i].Fianza_a_cobrar__c == 0) {
                                                            noFianza = true;
                                                        }
                                                        
                                                        encontrado = true;    
                                                        System.debug('Decuento encontrado 1');
                                                    }
                                                    else 
                                                    {
                                                        if (opc.Etapa__c != 'Ingreso') {
                                                            triggerHelper.addErrorOp(opc,'La Oportunidad de la NOC no coincide o no está activa');
                                                        }
                                                    }
                                                }
                                                else if (lnoc[i].Fecha_Fin_1__c != null || lnoc[i].Fecha_Fin_2__c != null || lnoc[i].Fecha_Fin_3__c != null || lnoc[i].Fecha_Fin_4__c != null || lnoc[i].Fecha_Fin_5__c != null || lnoc[i].Fecha_Fin_6__c != null) {
                                                    System.debug('ES NOC PERSONAL AMB periodes');
                                                    Date FechaInicio = lnoc[i].Fecha_Inicio_1__c;
                                                    Date FechaFin = lnoc[i].Fecha_Fin_1__c;
                                                    Decimal DescuentoPeriodo = lnoc[i].Descuento_Mes_1__c;
                                                    if (lnoc[i].Fecha_Fin_2__c != null) {
                                                        FechaFin = lnoc[i].Fecha_Fin_2__c;
                                                        //DescuentoPeriodo = lnoc[i].Descuento_Mes_2__c;
                                                    }
                                                    if (lnoc[i].Fecha_Fin_3__c != null) {
                                                        FechaFin = lnoc[i].Fecha_Fin_3__c;
                                                        //DescuentoPeriodo = lnoc[i].Descuento_Mes_3__c;
                                                    }
                                                    if (lnoc[i].Fecha_Fin_4__c != null) {
                                                        FechaFin = lnoc[i].Fecha_Fin_4__c;
                                                        //DescuentoPeriodo = lnoc[i].Descuento_Mes_4__c;
                                                    }
                                                    if (lnoc[i].Fecha_Fin_5__c != null) {
                                                        FechaFin = lnoc[i].Fecha_Fin_5__c;
                                                       // DescuentoPeriodo = lnoc[i].Descuento_Mes_5__c;
                                                    }
                                                    if (lnoc[i].Fecha_Fin_6__c != null) {
                                                        FechaFin = lnoc[i].Fecha_Fin_6__c;
                                                       // DescuentoPeriodo = lnoc[i].Descuento_Mes_6__c;
                                                    }
                                                    System.debug('DESCUENTO POR PERIODO: '+DescuentoPeriodo);
                                                    System.debug('FECHA FIN POR PERIODO: '+FechaFin);
                                                    if(lnoc[i].Oportunidad__c == opc.Id && lnoc[i].Estado_Flujo__c == 'Aprobado' && FechaInicio <= Date.today() && FechaFin >= Date.today() && !lnoc[i].Descuento_permanente__c) 
                                                    {
                                                        encN = true;
                                                        descuento = DescuentoPeriodo;
                                                        if (lnoc[i].Importe_Fianza_a_cobrar__c == 0 || lnoc[i].Fianza_a_cobrar__c == 0) {
                                                            noFianza = true;
                                                        }
                                                        encontrado = true;    
                                                        System.debug('Decuento encontrado periodo!!!!');
                                                    }
                                                    else 
                                                    {
                                                        if (opc.Etapa__c != 'Ingreso') {
                                                            triggerHelper.addErrorOp(opc,'La oportunidad De la NOC no coincide o no está activa');
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                    else if(opc.NOC_11_Renegociado__c <> null) 
                                    {
                                        for(integer i = 0; i < lnoc.Size() && !encN; ++i) 
                                        {
                                            if(lnoc[i].Id == opc.NOC_11_Renegociado__c) 
                                            {
                                                if (lnoc[i].Fecha_inicio__c != null || lnoc[i].Fecha_fin__c != null)  {
                                                    if(lnoc[i].Oportunidad_renegociada__c == opc.Id && lnoc[i].Estado_Flujo__c == 'Aprobado' && lnoc[i].Fecha_inicio__c <= Date.today() && lnoc[i].Fecha_fin__c >= Date.today() && !lnoc[i].Descuento_permanente__c || (lnoc[i].Oportunidad__c == opc.Id && lnoc[i].Estado_Flujo__c == 'Aprobado' && lnoc[i].Fecha_inicio__c <= Date.today() && lnoc[i].Descuento_permanente__c)) 
                                                    {
                                                        encN = true;
                                                        descuento = lnoc[i].Descuento_Aplicado__c;
                                                        if (lnoc[i].Importe_Fianza_a_cobrar__c == 0 || lnoc[i].Fianza_a_cobrar__c == 0) {
                                                            noFianza = true;
                                                        }
                                                        encontrado = true; 
                                                        System.debug('Decuento encontrado 2');
                                                    }
                                                    else 
                                                    {
                                                        //NEW
                                                        if (opc.Etapa__c != 'Ingreso') {
                                                            triggerHelper.addErrorOp(opc,'La oportunidad de la NOC no coincide o no está activa');
                                                        }
                                                    }
                                                }
                                                else if (lnoc[i].Fecha_Fin_1__c != null || lnoc[i].Fecha_Fin_2__c != null || lnoc[i].Fecha_Fin_3__c != null || lnoc[i].Fecha_Fin_4__c != null || lnoc[i].Fecha_Fin_5__c != null || lnoc[i].Fecha_Fin_6__c != null) {
                                                    Date FechaInicio = lnoc[i].Fecha_Inicio_1__c;
                                                    Date FechaFin = lnoc[i].Fecha_Fin_1__c;
                                                    if (lnoc[i].Fecha_Fin_2__c != null) {
                                                        FechaFin = lnoc[i].Fecha_Fin_2__c;
                                                    }
                                                    if (lnoc[i].Fecha_Fin_3__c != null) {
                                                        FechaFin = lnoc[i].Fecha_Fin_3__c;
                                                    }
                                                    if (lnoc[i].Fecha_Fin_4__c != null) {
                                                        FechaFin = lnoc[i].Fecha_Fin_4__c;
                                                    }
                                                    if (lnoc[i].Fecha_Fin_5__c != null) {
                                                        FechaFin = lnoc[i].Fecha_Fin_5__c;
                                                    }
                                                    if (lnoc[i].Fecha_Fin_6__c != null) {
                                                        FechaFin = lnoc[i].Fecha_Fin_6__c;
                                                    }
                                                    if(lnoc[i].Oportunidad__c == opc.Id && lnoc[i].Estado_Flujo__c == 'Aprobado' && FechaInicio <= Date.today() && FechaFin >= Date.today() && !lnoc[i].Descuento_permanente__c) 
                                                    {
                                                        encN = true;
                                                        descuento = lnoc[i].Descuento_Aplicado__c;
                                                        if (lnoc[i].Importe_Fianza_a_cobrar__c == 0 || lnoc[i].Fianza_a_cobrar__c == 0) {
                                                            noFianza = true;
                                                        }
                                                        encontrado = true;    
                                                        System.debug('Decuento encontrado 1');
                                                    }
                                                    else 
                                                    {
                                                        if (opc.Etapa__c != 'Ingreso') {
                                                            triggerHelper.addErrorOp(opc,'La oportunidad de la NOC no coincide o no está activa');
                                                        }
                                                    }
                                                }
                                                
                                                
                                            }
                                        }
                                    }
                                    else if(opc.NOC__c <> null || opc.NOC_11_Centro__c <> null || opc.NOC_12_Convenios__c <> Null)
                                    {
                                        System.debug('Estoy en el caso de descuento centro, voy a calcular');
                                        noCumple = false;
                                        recomendador = false;   
                                        encontrado = false;
                                        hayPlazas = true;
                                        hayPlazasRotacion = true;
                                        for(integer i = 0; i < lnoc.size(); ++i)
                                        {
                                            encontradoParcial = false;
                                            if(
                                                (//Modificacion: Si la noc es campaña puede estar en una opp aunque no esté en periodo siempre que "estado campaña" esté abierta
                                                    (lnoc[i].Id == opc.NOC__c && (lnoc[i].Estado_Campana__c == 'Abierta' || lnoc[i].Estado_Campana__c == 'Cerrada') && ((Trigger.isUpdate && Trigger.oldMap.get(opc.Id).NOC__c != null && lnoc[i].Estado_Campana__c == 'Abierta') || (lnoc[i].Fecha_inicio__c <= Date.today() && lnoc[i].Fecha_fin__c >= Date.today() && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(opc.Id).NOC__c == null)))))
                                                    || 
                                                    (lnoc[i].Id == opc.NOC_11_Centro__c && lnoc[i].Fecha_inicio__c <= Date.today() && lnoc[i].Fecha_fin__c >= Date.today())
                                                    || 
                                                    (lnoc[i].Id == opc.NOC_12_Convenios__c && lnoc[i].Fecha_inicio__c <= Date.today() && lnoc[i].Fecha_fin__c >= Date.today())
                                                ) 
                                                && 
                                                lnoc[i].Estado_Flujo__c == 'Aprobado' 
                                            )
                                            {
                                                
                                                /*if (opc.NOC_11_Centro__c <> null && lnoc[i].Numero_de_plazas_libres__c <> null && lnoc[i].Numero_de_plazas_libres__c <= 0) {
                                                    hayPlazas = false;
                                                }
                                                if (opc.NOC_11_Centro__c <> null && lnoc[i].Numero_de_plazas_libres__c <> null) {
                                                    IdNoc = lnoc[i].id;
                                                    NumPlazas = lnoc[i].Numero_de_plazas_libres__c;
                                                }*/
                                                //Comprovamos que si la NOC es de tipo 11 general centro, hay plazas o no.
                                                //En caso de que no haya plazas, cambiamos el estado del boleano.
                                                if (opc.NOC_11_Centro__c <> null && (lnoc[i].Numero_de_plazas_libres__c <> null||lnoc[i].Numero_de_plazas_en_rotacion_libres__c <> null)) {
                                                    if (lnoc[i].Numero_de_plazas_libres__c <> null) {
                                                        if (lnoc[i].Numero_de_plazas_libres__c <= 0 ) {
                                                            hayPlazas = false;
                                                        }
                                                        IdNoc = lnoc[i].id;
                                                        NumPlazas = lnoc[i].Numero_de_plazas_libres__c;
                                                    }
                                                    else if (lnoc[i].Numero_de_plazas_en_rotacion_libres__c <> null) {
                                                        if (lnoc[i].Numero_de_plazas_en_rotacion_libres__c <= 0) {
                                                            hayPlazasRotacion = false;
                                                        }
                                                        IdNoc = lnoc[i].id;
                                                        NumPlazasRotacion = lnoc[i].Numero_de_plazas_en_rotacion_libres__c;
                                                    }
                                                    
                                                }
                                                
                                                System.debug('HAY PLAZAS: '+hayPlazas);
                                                System.debug('ID NOC: '+IdNoc);
                                                System.debug('NUMERO DE PLAZAS: '+NumPlazas);
                                                System.debug('Cumplo las condiciones de noc correcta');                           
                                                noCumple = true;
                                                Boolean cnEnc = false;
                                                //Buscamos la Division, Zona Comercial, Nombre centro del Centro Oportunidad
                                                for(Account ce : centros) 
                                                {                                        
                                                    if(ce.Id == opc.Centro2__c)
                                                    {
                                                        divi = ce.Division__c;
                                                        zComercial = ce.Zona_Comercial_del__c;
                                                        centro = ce.Id;
                                                        minDescuentoCentro = null;   
                                                        minDescuentoZona = null;
                                                        minDescuentoDivi = null;  
                                                        System.debug('Centro: '+centro); 
                                                        
                                                        
                                                        for(Centros_NOC__c cnoc : lCNoc)
                                                        {
                                                            
                                                            //Miramos que el centro este informado
                                                            if(cnoc.NOC__c == lnoc[i].Id)
                                                            {
                                                                System.debug('NOC: '+cnoc.NOC__c);
                                                                
                                                                //System.debug(cnoc + ' ' + ce);
                                                                //Coincide Centro Oportunidad con Centro linia NOC   
                                                                                                  
                                                                if((cnoc.Centro__c != null && cnoc.Centro__c == centro) || (cnoc.Zona_Comercial_2__c != null && cnoc.Zona_Comercial_2__c.contains(zComercial)) || (cnoc.Division__c != null && cnoc.Division__c.contains(divi)))
                                                                {
                                                                    
                                                                    //Buscamos el Servicio de la Oportunidad                                                    
                                                                    for(Servicio__c s : servicios)
                                                                    {System.debug('servicio!: '+s);
                                                                        
                                                                        if(opc.Servicio__c == s.Id)
                                                                        {   
                                                                            //Coincide el Tipo servicio Oportunidad - CentroNoc
                                                                            if(cnoc.Tipo_Servicio_2__c == null || cnoc.Tipo_Servicio_2__c.contains(s.Tipo_Servicio__c))
                                                                            {   System.debug('TIPO SERVICIO: '+cnoc.Tipo_Servicio_2__c);
                                                                                
                                                                                //Coincide el Tipo Estancia Oportunidad - CentroNoc
                                                                                if(cnoc.Tipo_Estancia_2__c == null || cnoc.Tipo_Estancia_2__c.contains(s.Tipo_Estancia__c))
                                                                                {System.debug('TIPO ESTANCIA: '+cnoc.Tipo_Estancia_2__c);
                                                                                    
                                                                                    //Coincide el Tipo de Ocupacion Oportunidad - CentroNoc
                                                                                    if(cnoc.Tipo_Ocupacion_2__c == null || cnoc.Tipo_Ocupacion_2__c.contains(s.Tipo_Ocupacion__c))
                                                                                    {       System.debug('ENTRES2: ');
                                                                                            
                                                                                        //Errores.add('TIPO OCUYPACION: '+cnoc.Tipo_Ocupacion_2__c);
                                                                                        //Coincide el Grado Oportunidad - CentroNoc
                                                                                        System.debug('SERVICIO DE LA OPP: '+s);
                                                                                        System.debug('Grado del servicio DE LA OPP: '+s.Grado_Dependencia__c);
                                                                                        if(cnoc.Grado__c == null || s.Grado_Dependencia__c == null || cnoc.Grado__c.contains(s.Grado_Dependencia__c))
                                                                                        { 
                                                                                            //Errores.add('GRADO: '+cnoc.Grado__c);
                                                                                             System.debug('ENTRES0: ');
                                                                                        if(cnoc.Transporte__c == null || s.Transporte__c == null || cnoc.Transporte__c.contains(s.Transporte__c))
                                                                                        { 
                                                                                            System.debug('TRANSPORTE LINIA NOC: '+cnoc.Transporte__c);
                                                                                            System.debug('TRANSPORTE SERVICIO: '+s.Transporte__c);
                                                                                            System.debug('ENTRES1: ');
                                                                                            
                                                                                            if(cnoc.Descuento__c != null)
                                                                                            {
                                                                                                
                                                                                                //Si el centro NOC tiene Centro informado
                                                                                                if(cnoc.Centro__c != null && cnoc.Centro__c == centro && (cnoc.Zona_Comercial_2__c == null || cnoc.Zona_Comercial_2__c.contains(zComercial)) && (cnoc.Division__c == null || cnoc.Division__c.contains(divi)))
                                                                                                {
                                                                                                    
                                                                                                    encontradoParcial = true;
                                                                                                    encontrado = true;
                                                                                                    System.debug('Decuento encontrado 3');
                                                                                                    // Si el descuento del centro NOC es inferior al anterior nos quedamos el menor
                                                                                                    if(minDescuentoCentro == null || cnoc.Descuento__c < minDescuentoCentro) {
                                                                                                        System.debug('cnoc.descuento: ' + cnoc.Descuento__c);
                                                                                                        minDescuentoCentro = cnoc.Descuento__c;   
                                                                                                    }                                                                                       
                                                                                                    
                                                                                                }
                                                                                                //Si la Zona Comercial esta informada
                                                                                                else if(cnoc.Zona_Comercial_2__c != null && cnoc.Zona_Comercial_2__c.contains(zComercial) && (cnoc.Centro__c == null || cnoc.Centro__c == centro) && (cnoc.Division__c == null || cnoc.Division__c.contains(divi))) 
                                                                                                {
                                                                                                    encontradoParcial = true;
                                                                                                    encontrado = true;
                                                                                                    System.debug('Decuento encontrado 4');
                                                                                                    if(minDescuentoZona == null || cnoc.Descuento__c < minDescuentoZona) minDescuentoZona = cnoc.Descuento__c;
                                                                                                }
                                                                                                else if (cnoc.Division__c != null && cnoc.Division__c.contains(divi) && (cnoc.Centro__c == null || cnoc.Centro__c == centro) && ((cnoc.Zona_Comercial_2__c == null || cnoc.Zona_Comercial_2__c.contains(zComercial))))
                                                                                                {
                                                                                                    encontradoParcial = true;
                                                                                                    encontrado = true;
                                                                                                    System.debug('Decuento encontrado 5');
                                                                                                    if(minDescuentoDivi == null || cnoc.Descuento__c < minDescuentoDivi) minDescuentoDivi = cnoc.Descuento__c;
                                                                                                }
                                                                                            }
                                                                                            //Si el precio esta informado en lugar del descuento
                                                                                            else if(cnoc.Precio__c != null)
                                                                                            {
                                                                                                
                                                                                                if(cnoc.Centro__c != null && cnoc.Centro__c == centro && (cnoc.Zona_Comercial_2__c == null || cnoc.Zona_Comercial_2__c.contains(zComercial)) && (cnoc.Division__c == null || cnoc.Division__c.contains(divi)))
                                                                                                {     
                                                                                                    encontrado = true;
                                                                                                    System.debug('Decuento encontrado 6');
                                                                                                    encontradoParcial = true;                                                                                   
                                                                                                    //calculamos el descuento a aplicar
                                                                                                    Double descuentoParcial = (opc.Precio__c - cnoc.Precio__c) / opc.Precio__c * 100;
                                                                                                    if(minDescuentoCentro == null || descuentoParcial < minDescuentoCentro) minDescuentoCentro = descuentoParcial;
                                                                                                }
                                                                                                else if(cnoc.Zona_Comercial_2__c != null && cnoc.Zona_Comercial_2__c.contains(zComercial) && (cnoc.Centro__c == null || cnoc.Centro__c == centro) && (cnoc.Division__c == null ||cnoc.Division__c.contains(divi))) 
                                                                                                {
                                                                                                    encontrado = true;
                                                                                                    System.debug('Decuento encontrado 7');
                                                                                                    encontradoParcial = true;
                                                                                                    Double descuentoParcial = (opc.Precio__c - cnoc.Precio__c) / opc.Precio__c * 100;
                                                                                                    if(minDescuentoZona == null || descuentoParcial < minDescuentoZona) minDescuentoZona = descuentoParcial;
                                                                                                } 
                                                                                                else if (cnoc.Division__c != null && cnoc.Division__c.contains(divi) && (cnoc.Centro__c == null || cnoc.Centro__c == centro) && ((cnoc.Zona_Comercial_2__c == null || cnoc.Zona_Comercial_2__c.contains(zComercial))))
                                                                                                {
                                                                                                    encontrado = true;
                                                                                                    System.debug('Decuento encontrado 8');
                                                                                                    encontradoParcial = true;
                                                                                                    Double descuentoParcial = (opc.Precio__c - cnoc.Precio__c) / opc.Precio__c * 100;
                                                                                                    if(minDescuentoDivi == null || descuentoParcial < minDescuentoDivi) minDescuentoDivi = descuentoParcial;
                                                                                                }
                                                                                            }                                                                               
                                                                                        }
                                                                                            else {encontradoParcial = false; 
                                                                                            System.debug('AQUI ENTRES12345???');
                                                                                                  }
                                                                                        }
                                                                                        else encontradoParcial = false;
                                                                                    }
                                                                                    else encontradoParcial = false;
                                                                                }
                                                                                else encontradoParcial = false;
                                                                            }
                                                                            else encontradoParcial = false;
                                                                            System.debug('AQUI ENTRES0000???');
                                                                        }
                                                                        else encontradoParcial = false;
                                                                    } 
                                                                    
                                                                }
                                                            }
                                                        } 
                                                    }    
                                                }
                                               // if(opc.Empresa_Recomendadora__c == lnoc[i].Recomendador__c || recomendadoras.get(opc.Empresa_Recomendadora__c).ParentId == lnoc[i].Recomendador__c) recomendador = true;                                  
                                            }
                                            
                                            
                                        }                           
                                    }
                                    System.debug('TEST');
                                    
                                    if(opc.NOC_11_Persona__c == Null && opc.NOC_11_Renegociado__c == null)
                                    {
                                        if(!noCumple && opc.Etapa__c != 'Ingreso') triggerHelper.addErrorOp(opc,'La NOC no cumple los requisitos');
                                        //if(!recomendador && opc.NOC_12_Convenios__c <> Null && opc.Etapa__c != 'Ingreso') triggerHelper.addErrorOp(opc,'El recomendador de la Oportunidad no coincide con el de la NOC');
                                        if(minDescuentoCentro != null) {
                                            System.debug('ENTRES IF 1');
                                            System.debug('ID NOC: '+IdNoc);
                                            System.debug('NUMERO DE PLAZAS: '+NumPlazas);
                                            opc.Descuento__c = minDescuentoCentro;
                                        }
                                        else if(minDescuentoCentro == null && minDescuentoZona != null) {
                                            opc.Descuento__c = minDescuentoZona;
                                        }
                                            
                                        else if(minDescuentoCentro == null && minDescuentoZona == null && minDescuentoDivi != null) {
                                            opc.Descuento__c = minDescuentoDivi;
                                        }
                                        
                                            
                                        else {
                                            System.debug('HE llegado al ultimo else del final');
                                            opc.Descuento__c = null;
                                            
                                        }
                                        if (opc.NOC_11_Centro__c != null && NumPlazas != null) {
                                                if (opc.Etapa__c == 'Preingreso') {
                                                        if (trigger.isInsert) {
                                                            if (hayPlazas == false) {
                                                                triggerHelper.addErrorOp(opc,'No quedan plazas para esta NOC');
                                                            }
                                                            else {
                                                                NOC__c nocAmodificar = new NOC__c(id = IdNoc,Numero_de_plazas_libres__c = NumPlazas-1);
                                                                NocsCentresModificades.add(nocAmodificar);
                                                            }
                                                            
                                                        }
                                                        else if (trigger.isUpdate) {
                                                            Oportunidad_platform__c OldOportunitat = Trigger.oldMap.get(opc.Id);                  
                                                            if (OldOportunitat.Etapa__c != opc.Etapa__c) {
                                                               if (hayPlazas == false) {
                                                                triggerHelper.addErrorOp(opc,'No quedan plazas para esta NOC');
                                                                }
                                                                else {
                                                                    NOC__c nocAmodificar = new NOC__c(id = IdNoc,Numero_de_plazas_libres__c = NumPlazas-1);
                                                                    NocsCentresModificades.add(nocAmodificar);
                                                                }
                                                            }
                                                        }   
                                                }
                                                 else if (opc.Etapa__c == 'No ingreso') {
                                                        Oportunidad_platform__c OldOportunitat = Trigger.oldMap.get(opc.Id);                  
                                                            if (OldOportunitat.Etapa__c != opc.Etapa__c && OldOportunitat.Etapa__c == 'Preingreso') {
                                                                NOC__c nocAmodificar = new NOC__c(id = IdNoc,Numero_de_plazas_libres__c = NumPlazas+1);
                                                                NocsCentresModificades.add(nocAmodificar);
                                                            }
                                                 }
                                            /*
                                                 else {
                                                    if (opc.Etapa__c != 'Cerrada por el sistema' && opc.Etapa__c != 'Ingreso') {
                                                        if (hayPlazas == false) {
                                                            triggerHelper.addErrorOp(opc,'No quedan plazas para esta NOC');
                                                        }
                                                    }
                                                }*/
                                            }
                                            
                                            
                                           //Si la Noc es de tipo 11 general centro y esta marcado el check de límite de plazas en ROTACION,
                                            //comprovamos si esta opp puede tener esta NOC teniendo en cuenta este limite
                                            if (opc.NOC_11_Centro__c != null && NumPlazasRotacion != null) {
                                                //Si la etapa está en preingreso, miramos el limite:
                                                //Si no quedan plazas lanzamos el error.
                                                //Si quedan plazas, le restamos una plaza al límite
                                                if (opc.Etapa__c == 'Preingreso') {
                                                        if (trigger.isInsert) {
                                                            if (hayPlazasRotacion == false) {
                                                                triggerHelper.addErrorOp(opc,'No quedan plazas en rotación para esta NOC');
                                                            }
                                                            else {
                                                                NOC__c nocAmodificar = new NOC__c(id = IdNoc,Numero_de_plazas_en_rotacion_libres__c = NumPlazasRotacion-1);
                                                                NocsCentresModificades.add(nocAmodificar);
                                                            }
                                                            
                                                        }
                                                        else if (trigger.isUpdate) {
                                                            Oportunidad_platform__c OldOportunitat = Trigger.oldMap.get(opc.Id);                  
                                                            if (OldOportunitat.Etapa__c != opc.Etapa__c) {
                                                               if (hayPlazasRotacion == false) {
                                                                triggerHelper.addErrorOp(opc,'No quedan plazas en rotación para esta NOC');
                                                                }
                                                                else {
                                                                    NOC__c nocAmodificar = new NOC__c(id = IdNoc,Numero_de_plazas_en_rotacion_libres__c = NumPlazasRotacion-1);
                                                                    NocsCentresModificades.add(nocAmodificar);
                                                                }
                                                            }
                                                        }   
                                                }
                                                //Si pasamos de preingreso a No ingreso, le sumamos uno al límite de plazas en ROTACION
                                                 else if (opc.Etapa__c == 'No ingreso') {
                                                        Oportunidad_platform__c OldOportunitat = Trigger.oldMap.get(opc.Id);                  
                                                            if (OldOportunitat.Etapa__c != opc.Etapa__c && OldOportunitat.Etapa__c == 'Preingreso') {
                                                                NOC__c nocAmodificar = new NOC__c(id = IdNoc,Numero_de_plazas_en_rotacion_libres__c = NumPlazasRotacion+1);
                                                                NocsCentresModificades.add(nocAmodificar);
                                                            }
                                                 }
                                                else if (opc.Etapa__c == 'Ingreso') {
                                                    Oportunidad_platform__c OldOportunitat = Trigger.oldMap.get(opc.Id);
                                                    if (OldOportunitat.Fecha_de_Alta__c != opc.Fecha_de_Alta__c) {
                                                        NOC__c nocAmodificar = new NOC__c(id = IdNoc,Numero_de_plazas_en_rotacion_libres__c = NumPlazasRotacion+1);
                                                        NocsCentresModificades.add(nocAmodificar);
                                                    }
                                                }
                                                //Si estamos en etapa distinta de preingreso,ingreso,no ingreso o cerrada por el sistema,
                                                //Comprovamos si esta opp puede usar esta Noc teniendo en cuenta el limite de plazas.
                                               /* else {
                                                    if (opc.Etapa__c != 'Cerrada por el sistema') {
                                                        if (hayPlazasRotacion == false) {
                                                            triggerHelper.addErrorOp(opc,'No quedan plazas en rotación para esta NOC');
                                                        }
                                                    }
                                                }*/
                                            } 
                                    } 
                                    else opc.Descuento__c = descuento;                     
                                    opc.No_Finanza__c = noFianza;  
                                    /*for (String e:Errores) {
                                        Logs__c log = new Logs__c();
                                        log.Error__c = e;
                                        logs.add(log);
                                        
                                    }
                                    insert logs;*/
                                     
                                    if(!encontrado && opc.Etapa__c != 'Ingreso') triggerHelper.addErrorOp(opc,'La oportunidad de la NOC no coincide o no está activa');
                                }                   
                            }
                            catch (Exception e)
                            {
                                
                            }
                            ++pos;            
                            
                        }      
                        try 
                        {
                            triggerHelper.recursiveHelper3(true);
                            update restoUpd;
                            update NocsCentresModificades;
                            triggerHelper.recursiveHelper3(false);
                        } 
                        catch(Exception e) 
                        {
                            triggerHelper.setTodoFalse();
                        }
                    }
                    else if (opc.RecordTypeId == Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TAD').getRecordTypeId() || opc.recordtypeid  == Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TAM').getRecordTypeId()|| opc.recordtypeid  ==  Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TA Dúo').getRecordTypeId()) {
                        System.debug('Entres a TARIFAS TA');
                        if (Trigger.isUpdate) {
                            OportunidadesTAD.add(opc.Id);
                        }
                        Boolean trobat = false;
                        for(integer i = 0; i < TarifasTA.Size() && !trobat; ++i) {
                            System.debug('Entres a TARIFAS TA01');
                            System.debug('SERVICIO OP: '+opc.Servicio__c);
                            if(TarifasTA[i].Tarifa_vigente__c && TarifasTA[i].Servicio_TA__c == opc.Servicio__c && TarifasTA[i].Central__c == opc.Central__c && opc.Servicio__c != null) {
                                        //buscamos una noc en la tarifa que cumpla los requisitos
                                        System.debug('Entres a TARIFAS TA1');
                                        for(integer j = 0; j < ln10.Size() && !trobat; ++j) {
                                            System.debug('Entres a TARIFAS TA2');
                                            if(TarifasTA[i].NOC__c == ln10[j].Id) {
                                                System.debug('Entres a TARIFAS TA3');
                                                if(trigger.IsUpdate && ln10[j].Estado_Flujo__c == 'Aprobado' && ln10[j].Fecha_inicio__c <= opc.CreatedDate && ln10[j].Fecha_fin__c >= opc.CreatedDate ) {
                                                    trobat = true;
                                                    //opc.Precio_Servicio__c = TarifasTA[i].Precio_Servicio__c;
                                                    //opc.Precio_Dispositivo__c = TarifasTA[i].Precio_Dispositivo__c;                                                                     
                                                    opc.Tarifa__c = TarifasTA[i].Id;
                                                    if (TarifasTA[i].Precio_ucr_adicional__c != null) {
                                                        PreciosColgante.put(opc.id,TarifasTA[i].Precio_ucr_adicional__c);
                                                    }
                                                    System.debug('Tarifa TA encontrada');
                                                }
                                                else if(ln10[j].Estado_Flujo__c == 'Aprobado' && ln10[j].Fecha_inicio__c <= Date.today() && ln10[j].Fecha_fin__c >= Date.today()) {
                                                    trobat = true;
                                                    //opc.Precio_Servicio__c = TarifasTA[i].Precio_Servicio__c;
                                                   // opc.Precio_Dispositivo__c = TarifasTA[i].Precio_Dispositivo__c;                                                                     
                                                    opc.Tarifa__c = TarifasTA[i].Id;
                                                    if (TarifasTA[i].Precio_ucr_adicional__c != null) {
                                                        PreciosColgante.put(opc.id,TarifasTA[i].Precio_ucr_adicional__c);
                                                    }
                                                    System.debug('Tarifa TA encontrada');
                                                }
                                            } 
                                        }
                                    } 
                        }
                        if (trobat == false && opc.Servicio__c != null && opc.Central__c != null) {
                            triggerHelper.addErrorOp(opc,'No se encontró tarifa para la combinación de servicio y central seleccionados');
                        }
                        Boolean trobat2 = false;
                        Boolean trobat3 = false;
                        /*if (servicioColgante.size() == 1 && Trigger.isUpdate) {
                            for(integer i = 0; i < TarifasTA.Size() && !trobat2; ++i) {
                                if (TarifasTA[i].Servicio_TA__c == servicioColgante[0].id && opc.Central__c == TarifasTA[i].Central__c) {
                                    System.debug('Precio colgante: '+TarifasTA[i].precio_total__c);
                                    PreciosColgante.put(opc.id,TarifasTA[i].precio_total__c);
                                    trobat2 = true;
                                }
                            }
                        }
                        if (servicioSinColgante.size() == 1 && Trigger.isUpdate) {
                            System.debug('SERVICIO SIN COLGANTE!');
                            for(integer i = 0; i < TarifasTA.Size() && !trobat3; ++i) {
                                if (TarifasTA[i].Servicio_TA__c == servicioSinColgante[0].id && opc.Central__c == TarifasTA[i].Central__c) {
                                    System.debug('Precio sin colgante: '+TarifasTA[i].precio_total__c);
                                    PreciosSinColgante.put(opc.id,TarifasTA[i].precio_total__c);
                                    trobat3 = true;
                                }
                            }
                        }*/
                        
                        //comprobamos que solo haya como máximo un descuento
                        integer NDes = 0;
                        if(opc.NOC__c <> Null) ++NDes;
                        if(opc.NOC_11_Persona__c <> Null) ++NDes;
                        if(opc.NOC_11_Centro__c <> Null) ++NDes;
                        if(opc.NOC_11_Renegociado__c <> Null) ++NDes;
                        if(opc.NOC_12_Convenios__c <> Null) ++NDes;
                        
                        if(NDes == 0 && (opc.Descuento__c != null && opc.Descuento__c != 0)) {
                            opc.Descuento__c = null;
                            System.debug('OP TAM no tiene descuentos');
                        }else {
                            System.debug('OP TAM tiene algun descuento');
                        }                    
                    }

                }//fin FOR
                
                Boolean primera = true;
                Id OportunidadActual;
                Map<id,Integer> NumBeneficiariosOp = new Map<id,Integer>();
                Map<id,Integer> NumBeneficiariosOpSin = new Map<id,Integer>();
                id RecTypeBen = Schema.SObjectType.Relacion_entre_contactos__c.getRecordTypeInfosByName().get('Relacion de beneficiarios').getRecordTypeId();
                for (Relacion_entre_contactos__c relacion:[Select id,oportunidad__c from Relacion_entre_contactos__c where oportunidad__c IN:OportunidadesTAD and recordtypeid =: RecTypeBen and Beneficiario_con_colgante__c = true order by oportunidad__c]) {
                    if (NumBeneficiariosOp.get(relacion.oportunidad__c) == null) {
                        NumBeneficiariosOp.put(relacion.oportunidad__c,1);
                    }
                    else {
                        Integer NumBen = NumBeneficiariosOp.get(relacion.oportunidad__c)+1;
                        NumBeneficiariosOp.put(relacion.oportunidad__c,NumBen);
                    }
                    System.debug('Numero de beneficiarios: '+NumBeneficiariosOp.get(relacion.oportunidad__c));
                }
                for (Relacion_entre_contactos__c relacion:[Select id,oportunidad__c from Relacion_entre_contactos__c where oportunidad__c IN:OportunidadesTAD and recordtypeid =: RecTypeBen and Beneficiario_sin_colgante__c = true order by oportunidad__c]) {
                    if (NumBeneficiariosOpSin.get(relacion.oportunidad__c) == null) {
                        NumBeneficiariosOpSin.put(relacion.oportunidad__c,1);
                    }
                    else {
                        Integer NumBen = NumBeneficiariosOpSin.get(relacion.oportunidad__c)+1;
                        NumBeneficiariosOpSin.put(relacion.oportunidad__c,NumBen);
                    }
                    System.debug('Numero de beneficiarios: '+NumBeneficiariosOp.get(relacion.oportunidad__c));
                }
                
                for (Oportunidad_platform__c opc:Trigger.new) {
                    
                    if ((opc.RecordTypeId == Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TAD').getRecordTypeId() || opc.recordtypeid  == Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TAM').getRecordTypeId()|| opc.recordtypeid  ==  Schema.SObjectType.Oportunidad_platform__c.getRecordTypeInfosByName().get('Oportunidad TA Dúo').getRecordTypeId())) {
                        DescuentoColgante = null;
                        for(Tarifa__c tTA : TarifasTA)
                        {
                            if(opc.tarifa__c == tTA.Id)
                            {
                                // if(cnoc.Central__c == opc.Central__c)   {
                                    if (NumBeneficiariosOp.get(opc.id) != null && tTA.Precio_ucr_adicional__c != null ) {
                                        opc.Precio_Colgantes__c = NumBeneficiariosOp.get(opc.id)*tTA.Precio_ucr_adicional__c;
                                    }
                                    else {
                                        opc.Precio_Colgantes__c = null;
                                    }
                                    if (NumBeneficiariosOpSin.get(opc.id) != null && tTA.Precio_beneficiario_sin_ucr__c != null) {
                                        opc.Precio_sin_colgante__c = NumBeneficiariosOpSin.get(opc.id)*tTA.Precio_beneficiario_sin_ucr__c;
                                    }
                                    else {
                                        opc.Precio_sin_colgante__c = null;
                                    }
                                 }
                            }
                        
                        
                        
                            for(integer i = 0; i < lnoc.size(); ++i){
                                            
                                            encontradoParcial = false;
                                            if((opc.NOC_12_Convenios__c <> Null &&
                                                (
                                                    lnoc[i].Id == opc.NOC_12_Convenios__c
                                                ) 
                                                && 
                                                lnoc[i].Estado_Flujo__c == 'Aprobado' 
                                                && 
                                                lnoc[i].Fecha_inicio__c <= Date.today() 
                                                && 
                                                //Modificacion: Si la noc es campaña puede estar en una opp aunque no esté en periodo siempre que "estado campaña" esté abierta
                                                lnoc[i].Fecha_fin__c >= Date.today() ) || (lnoc[i].Id == opc.NOC__c && (lnoc[i].Estado_Campana__c == 'Abierta' || lnoc[i].Estado_Campana__c == 'Cerrada') && ((Trigger.isUpdate && Trigger.oldMap.get(opc.Id).NOC__c != null && lnoc[i].Estado_Campana__c == 'Abierta') || (lnoc[i].Fecha_inicio__c <= Date.today() && lnoc[i].Fecha_fin__c >= Date.today() && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(opc.Id).NOC__c == null)))))
                                            ) {
                                               //Buscamos la Division, Zona Comercial, Nombre centro del Centro Oportunidad
                                                for(Account ce : centros) {                                        
                                                    if(ce.Id == opc.Central__c) {
                                                        centralName = ce.Name;
                                                        central = ce.Id;
                                                        minDescuentoNoc12 = null;                                        
                                                        
                                                        for(Centros_NOC__c cnoc : lCNoc){
                                                            //System.debug('comprobacion para el centro dela noc ' + cnoc.NOC__c);
                                                            //Miramos que el centro este informado
                                                            if(cnoc.NOC_TAD__c == lnoc[i].Id) { 
                                                               for(Tarifa__c tTA : TarifasTA)
                                                                    {
                                                                        if(opc.tarifa__c == tTA.Id)
                                                                        {
                                                                           // if(cnoc.Central__c == opc.Central__c)   {
                                                                                if (tTA.id == cnoc.Tarifa_TA__c) {
                                                                                    if (cnoc.Descuento_Periodo_1__c != null) {
                                                                                                    
                                                                                                        if (minDescuentoNoc12 == null || cnoc.Descuento_Periodo_1__c < minDescuentoNoc12) {
                                                                                                            minDescuentoNoc12 = cnoc.Descuento_Periodo_1__c; 
                                                                                                        }
                                                                                                        if (DescuentoColgante == null || cnoc.Descuento__c > DescuentoColgante) {
                                                                                                            DescuentoColgante = cnoc.Descuento__c; 
                                                                                                            System.debug('DESCUENTO COLGANTE1: '+DescuentoColgante);
                                                                                                        }
                                                                                                        opc.idLinia__c = cnoc.id;
                                                                                        }
                                                                                                        
                                                                                    
                                                                                                /*
                                                                                                if (cnoc.Importe_Periodo_1__c != null) {
                                                                                                    System.debug('Servicio con colgante: '+cnoc.Servicio_con_colgante__c);
                                                                                                    Double descuentoParcial = (opc.Precio_Servicio__c - cnoc.Importe_Periodo_1__c) / opc.Precio_Servicio__c * 100;
                                                                                                    if (s.Servicio_con_colgante__c == false) {
                                                                                                        if(minDescuentoNoc12 == null || descuentoParcial < minDescuentoNoc12) minDescuentoNoc12 = descuentoParcial;
                                                                                                    }
                                                                                                    else {
                                                                                                        System.debug('DESCUENTO COLGANTE22222: ');
                                                                                                        if (opc.Precio_Colgantes__c != null)  {
                                                                                                            descuentoParcial = (opc.Precio_Colgantes__c - cnoc.Precio__c) / opc.Precio_Colgantes__c * 100;
                                                                                                            if (DescuentoColgante == null || descuentoParcial > DescuentoColgante) {
                                                                                                                DescuentoColgante = descuentoParcial; 
                                                                                                                System.debug('DESCUENTO COLGANTE2: '+DescuentoColgante);
                                                                                                            }
                                                                                                        }
                                                                                                            
                                                                                                    }
                                                                                                    
                                                                                                }*/
                                                                                    
                                                                            }
                                                                            else {
                                                                                if (cnoc.Tarifa_TA__c == null) {
                                                                                    if (cnoc.Central__c.contains(centralName)) {
                                                                                        for (Servicio__c serv:serviciosTA) {
                                                                                            if (opc.Servicio__c ==serv.id ) {
                                                                                                if (serv.id == cnoc.Servicio_TA__c) {
                                                                                                    System.debug('COINCIDEIX SERVICIO Y CENTRAL TA');
                                                                                                    if (cnoc.Descuento_Periodo_1__c != null) {
                                                                                                        
                                                                                                            if (minDescuentoNoc12 == null || cnoc.Descuento_Periodo_1__c < minDescuentoNoc12) {
                                                                                                                minDescuentoNoc12 = cnoc.Descuento_Periodo_1__c; 
                                                                                                            }
                                                                                                            
                                                                                                            opc.idLinia__c = cnoc.id;
                                                                                                    }
                                                                                                    if (cnoc.Descuento__c != null) {
                                                                                                        if (DescuentoColgante == null || cnoc.Descuento__c > DescuentoColgante) {
                                                                                                                DescuentoColgante = cnoc.Descuento__c; 
                                                                                                                System.debug('DESCUENTO COLGANTE1: '+DescuentoColgante);
                                                                                                    }
                                                                                                    }
                                                                                                    if (cnoc.Importe_Periodo_1__c != null)  {
                                                                                                        Double descuentoParcialTA = (tTA.Precio_servicio__c - cnoc.Importe_Periodo_1__c) / tTA.Precio_servicio__c * 100;
                                                                                                        if (minDescuentoNoc12 == null || descuentoParcialTA < minDescuentoNoc12) {
                                                                                                            minDescuentoNoc12 = descuentoParcialTA; 
                                                                                                        }
                                                                                                        
                                                                                                            opc.idLinia__c = cnoc.id;
                                                                                                    }
                                                                                                    System.debug(Logginglevel.INFO, 'ENTRA AQUI');
                                                                                                    System.debug(Logginglevel.INFO, 'cnoc.Precio__c==NULL ->' + (cnoc.Precio__c != null));
                                                                                                    if (cnoc.Precio__c != null) {
                                                                                                        Double descuentoColganteParcial = (tTA.Precio_ucr_adicional__c - cnoc.Precio__c) / tTA.Precio_ucr_adicional__c * 100;
                                                                                                            if (DescuentoColgante == null || descuentoColganteParcial > DescuentoColgante) {
                                                                                                                DescuentoColgante = descuentoColganteParcial; 
                                                                                                                System.debug('precio COLGANTE1: '+DescuentoColgante);
                                                                                                            }
                                                                                                    }
                                                                                                    System.debug(Logginglevel.INFO, 'cnoc.Descuento_Dispositivo__c==NULL ->' + (cnoc.Descuento_Dispositivo__c != null));
                                                                                                    if (cnoc.Descuento_Dispositivo__c != null) {
                                                                                                        Double PrecioDispositivoParcial = tTA.Precio_dispositivo__c-(tTA.Precio_dispositivo__c*cnoc.Descuento_Dispositivo__c/100);
                                                                                                            if (PrecioDispositivo == null || PrecioDispositivoParcial > PrecioDispositivo) {
                                                                                                                PrecioDispositivo = PrecioDispositivoParcial; 
                                                                                                                System.debug(Logginglevel.INFO, 'precio dispositivo1: '+PrecioDispositivo);
                                                                                                            }
                                                                                                    }
                                                                                                    System.debug(Logginglevel.INFO, 'cnoc.Precio_Dispositivo__c es NULL -> ' + (cnoc.Precio_Dispositivo__c==NULL));
                                                                                                    System.debug(Logginglevel.INFO, 'cnoc.Precio_Dispositivo__c =' + cnoc.Precio_Dispositivo__c);
                                                                                                    if (cnoc.Precio_Dispositivo__c != null) {
                                                                                                        
                                                                                                        if (PrecioDispositivo == null || cnoc.Precio_Dispositivo__c > PrecioDispositivo) {
                                                                                                                PrecioDispositivo = cnoc.Precio_Dispositivo__c; 
                                                                                                                System.debug(Logginglevel.INFO, 'precio dispositivo: '+PrecioDispositivo);
                                                                                                        }
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                                
                                                                            }
                                                                            
                                                                                
                                                                                /*if(s.Tipo_de_servicio_TA__c == null || cnoc.Tipo_de_servicio_TA__c.contains(s.Tipo_de_servicio_TA__c) || cnoc.Servicio_con_colgante__c ==true)
                                                                                {
                                                                                    if(s.Tipo_de_periferico__c == null || cnoc.Tipo_de_periferico__c == null || cnoc.Tipo_de_periferico__c.contains(s.Tipo_de_periferico__c))
                                                                                    {
                                                                                        if ((s.Activo__c == true && cnoc.Activo__c.contains('Si')) || (s.Activo__c == false && cnoc.Activo__c.contains('No'))) {
                                                                                            if ((s.Cuota_inicial__c == true && cnoc.Cuota_inicial__c.contains('Si')) || (s.Cuota_inicial__c == false && cnoc.Cuota_inicial__c.contains('No'))) {
                                                                                                if (cnoc.Descuento__c != null) {
                                                                                                    System.debug('Servicio con colgante: '+cnoc.Servicio_con_colgante__c);
                                                                                                    if (cnoc.Servicio_con_colgante__c == false) {
                                                                                                        if (minDescuentoNoc12 == null || cnoc.Descuento__c < minDescuentoNoc12) {
                                                                                                            minDescuentoNoc12 = cnoc.Descuento__c; 
                                                                                                        }
                                                                                                    }
                                                                                                    else {
                                                                                                        System.debug('DESCUENTO COLGANTE11111: ');
                                                                                                            if (DescuentoColgante == null || cnoc.Descuento__c > DescuentoColgante) {
                                                                                                                DescuentoColgante = cnoc.Descuento__c; 
                                                                                                                System.debug('DESCUENTO COLGANTE1: '+DescuentoColgante);
                                                                                                            }   
                                      
                                                                                                    }
                                                                                                }
                                                                                                if (cnoc.Precio__c != null) {
                                                                                                    System.debug('Servicio con colgante: '+cnoc.Servicio_con_colgante__c);
                                                                                                    Double descuentoParcial = (opc.Precio_Servicio__c - cnoc.Precio__c) / opc.Precio_Servicio__c * 100;
                                                                                                    if (cnoc.Servicio_con_colgante__c == false) {
                                                                                                        if(minDescuentoNoc12 == null || descuentoParcial < minDescuentoNoc12) minDescuentoNoc12 = descuentoParcial;
                                                                                                    }
                                                                                                    else {
                                                                                                        System.debug('DESCUENTO COLGANTE22222: ');
                                                                                                        if (opc.Precio_Colgantes__c != null)  {
                                                                                                            descuentoParcial = (opc.Precio_Colgantes__c - cnoc.Precio__c) / opc.Precio_Colgantes__c * 100;
                                                                                                            if (DescuentoColgante == null || descuentoParcial > DescuentoColgante) {
                                                                                                                DescuentoColgante = descuentoParcial; 
                                                                                                                System.debug('DESCUENTO COLGANTE2: '+DescuentoColgante);
                                                                                                            }
                                                                                                        }
                                                                                                            
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                                
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }*/
                                                                           }
																}
															}
														}
													}
												}
											}      
							}
                        
                        /*if(opc.NOC__c <> Null) {
                            for(integer i = 0; i < lnoc.size(); ++i)
                                        {
                                            
                                            encontradoParcial = false;
                                            if(
                                                (
                                                    (lnoc[i].Id == opc.NOC__c && (lnoc[i].Estado_Campana__c == 'Abierta' || lnoc[i].Estado_Campana__c == 'Cerrada')) 
                                                ) 
                                                && 
                                                lnoc[i].Estado_Flujo__c == 'Aprobado' 
                                                && 
                                                lnoc[i].Fecha_inicio__c <= Date.today() 
                                                && 
                                                lnoc[i].Fecha_fin__c >= Date.today() 
                                            )
                                            {
                                               //Buscamos la Division, Zona Comercial, Nombre centro del Centro Oportunidad
                                                for(Account ce : centros) 
                                                {                                        
                                                    if(ce.Id == opc.Central__c)
                                                    {
                                                        central = ce.Id;
                                                        minDescuentoNoc9 = null;   
                                                        System.debug('COINCIDEIX LA CENTRAL');
                                                        
                                                        for(Centros_NOC__c cnoc : lCNoc)
                                                        {
                             
                                                            //Miramos que el centro este informado
                                                            if(cnoc.NOC_TAD__c == lnoc[i].Id)
                                                            { 
                                                                System.debug('COINCIDEIX LA NOC');
                                                               for(Tarifa__c tTA : TarifasTA)
                                                                    {
                                                                        if(opc.tarifa__c == tTA.Id)
                                                                        {
                                                                            /*System.debug('COINCIDEIX EL SERVICIO');
                                                                            if(cnoc.Central__c == opc.Central__c)   {
                                                                                System.debug('COINCIDEIX LA CENTRAL2');*/
                                                                                /* if (tTA.id == cnoc.Tarifa_TA__c) {
                                                                                    if (cnoc.Descuento_Periodo_1__c != null) {
                                                                                        if (minDescuentoNoc9 == null || cnoc.Descuento_Periodo_1__c < minDescuentoNoc9) {
                                                                                            minDescuentoNoc9 = cnoc.Descuento_Periodo_1__c; 
                                                                                        }   
                                                                                        if (DescuentoColgante == null || cnoc.Descuento__c > DescuentoColgante) {
                                                                                            DescuentoColgante = cnoc.Descuento__c; 
                                                                                        }
                                                                                        if (NumBeneficiariosOp.get(opc.id) != null && tTA.Precio_ucr_adicional__c != null ) {
                                                                                            opc.Precio_Colgantes__c = NumBeneficiariosOp.get(opc.id)*tTA.Precio_ucr_adicional__c;
                                                                                        }
                                                                                        else {
                                                                                            opc.Precio_Colgantes__c = null;
                                                                                        }
                                                                                        if (NumBeneficiariosOpSin.get(opc.id) != null && tTA.Precio_beneficiario_sin_ucr__c != null) {
                                                                                            opc.Precio_sin_colgante__c = NumBeneficiariosOpSin.get(opc.id)*tTA.Precio_beneficiario_sin_ucr__c;
                                                                                        }
                                                                                        else {
                                                                                            opc.Precio_sin_colgante__c = null;
                                                                                        }
                                                                                                    
                                                                                    }
                                                                                                /*if (cnoc.Importe_Periodo_1__c != null) {
                                                                                                    Double descuentoParcial = (opc.Precio_Servicio__c - cnoc.Importe_Periodo_1__c) / opc.Precio_Servicio__c * 100;
                                                                                                    System.debug('Servicio con colgante: '+cnoc.Servicio_con_colgante__c);
                                                                                                    if (s.Servicio_con_colgante__c == false) {
                                                                                                        if(minDescuentoNoc9 == null || descuentoParcial < minDescuentoNoc9) minDescuentoNoc9 = descuentoParcial;
                                                                                                    }
                                                                                                    else {
                                                                                                        System.debug('DESCUENTO COLGANTE4444: ');
                                                                                                        if (opc.Precio_Colgantes__c != null) {
                                                                                                            descuentoParcial = (opc.Precio_Colgantes__c - cnoc.Precio__c) / opc.Precio_Colgantes__c * 100;
                                                                                                            if (DescuentoColgante == null || descuentoParcial > DescuentoColgante) {
                                                                                                                DescuentoColgante = descuentoParcial; 
                                                                                                                System.debug('DESCUENTO COLGANTE4: '+DescuentoColgante);
                                                                                                            }   
                                                                                                        }
                                                                                                        
                                                                                                    }
                                                                                            }*/
                                                                                 /* }
                                                                                /*if(s.Tipo_de_servicio_TA__c == null || cnoc.Tipo_de_servicio_TA__c.contains(s.Tipo_de_servicio_TA__c) || cnoc.Servicio_con_colgante__c == true)
                                                                                {
                                                                                    System.debug('COINCIDEIX EL TIPO SERVICIO');
                                                                                    if(s.Tipo_de_periferico__c == null || cnoc.Tipo_de_periferico__c == null || cnoc.Tipo_de_periferico__c.contains(s.Tipo_de_periferico__c))
                                                                                        
                                                                                    {
                                                                                        if ((s.Activo__c == true && cnoc.Activo__c.contains('Si')) || (s.Activo__c == false && cnoc.Activo__c.contains('No'))) {
                                                                                            if ((s.Cuota_inicial__c == true && cnoc.Cuota_inicial__c.contains('Si')) || (s.Cuota_inicial__c == false && cnoc.Cuota_inicial__c.contains('No'))) {
                                                                                                if (cnoc.Descuento__c != null) {
                                                                                                    System.debug('Servicio con colgante: '+cnoc.Servicio_con_colgante__c);
                                                                                                    if (cnoc.Servicio_con_colgante__c == false) {
                                                                                                        if (minDescuentoNoc9 == null || cnoc.Descuento__c < minDescuentoNoc9) {
                                                                                                            minDescuentoNoc9 = cnoc.Descuento__c; 
                                                                                                        }   
                                                                                                    }
                                                                                                    else {
                                                                                                                System.debug('DESCUENTO COLGANTE33333: ');
                                                                                                        
                                                                                                            if (DescuentoColgante == null || cnoc.Descuento__c > DescuentoColgante) {
                                                                                                                DescuentoColgante = cnoc.Descuento__c; 
                                                                                                                System.debug('DESCUENTO COLGANTE3: '+DescuentoColgante);
                                                                                                            }   
            
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                                if (cnoc.Precio__c != null) {
                                                                                                    Double descuentoParcial = (opc.Precio_Servicio__c - cnoc.Precio__c) / opc.Precio_Servicio__c * 100;
                                                                                                    System.debug('Servicio con colgante: '+cnoc.Servicio_con_colgante__c);
                                                                                                    if (cnoc.Servicio_con_colgante__c == false) {
                                                                                                        if(minDescuentoNoc9 == null || descuentoParcial < minDescuentoNoc9) minDescuentoNoc9 = descuentoParcial;
                                                                                                    }
                                                                                                    else {
                                                                                                        System.debug('DESCUENTO COLGANTE4444: ');
                                                                                                        if (opc.Precio_Colgantes__c != null) {
                                                                                                            descuentoParcial = (opc.Precio_Colgantes__c - cnoc.Precio__c) / opc.Precio_Colgantes__c * 100;
                                                                                                            if (DescuentoColgante == null || descuentoParcial > DescuentoColgante) {
                                                                                                                DescuentoColgante = descuentoParcial; 
                                                                                                                System.debug('DESCUENTO COLGANTE4: '+DescuentoColgante);
                                                                                                            }   
                                                                                                        }
                                                                                                        
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                                
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }/*
                                                                           }
                                                                        }
                                                                    }
                                                            }
                                                        }
                                                   }
                                                }
                                            }
                              }      */
                        /*if (minDescuentoNoc9 != null) {
                            opc.Descuento_Campa_a__c = minDescuentoNoc9;
                        }
                        else {
                            if (opc.NOC__c != null) {
                                triggerHelper.addErrorOp(opc,'La noc no coincide o no está activa');
                            }
                            
                        }*/
							if (minDescuentoNoc12 != null) {
								opc.Descuento__c = minDescuentoNoc12;
							}
							else {
								if (opc.NOC_12_Convenios__c != null || opc.NOC__c != null) {
									triggerHelper.addErrorOp(opc,'La noc no coincide o no está activa');
								}
							}
							if (DescuentoColgante != null) {
								opc.Descuento_colgante__c = DescuentoColgante;
							}
							if (PrecioDispositivo != null) {
								opc.Precio_Dispositivo_new__c = PrecioDispositivo;
							}
                        
    
                        
						}   
                    try{
                        //Si la oportunidad pasa a ingreso, asegurar que check de baja del residente es false

                        if(Trigger.isUpdate){
                            if(Trigger.oldMap.get(opc.Id).Etapa__c != 'Ingreso' && opc.Etapa__c == 'Ingreso'){
                                opc.Residente__r.Baja__c = false;
                                System.debug('residente baja = false');
                            }                            
                        }else{
                            if(opc.Etapa__c == 'Ingreso'&& opc.Residente__c!=null){
                                opc.Residente__r.Baja__c = false;
                                System.debug('residente baja = false');
                            }                            
                        }                        
                    }catch(Exception e){
                        System.debug( e.getMessage());
                    }

                        
                        
                }//fin for   
  
            
         //}   
		} 
    }
}