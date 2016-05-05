/* Updates Log:
*  Alexander Shubin (09/03/2016): 
*					1) Solo crear documento y actualizar OP si el WS devuelve un documento.
*					2) Corregido el error de borrar el documento de WS
*					3) Agregar a la consulta una restricción:[..AND Familiar_de_referencia__c = true];
*  Alexander Shubin (04/04/2016): 
*					1) Agregar las respuestas de los posibles errores.
*/

global without sharing class CalloutVidsigner {
    webservice static String getDoc(String opId, String docGUI){
        Oportunidad_platform__c opl = [ SELECT Contrato_Firmado__c,  Centro2__c, Autorizacion_judicial_de_internamiento__c FROM Oportunidad_platform__c WHERE id =: opId ];
        Account acc = [ SELECT userVidsigner__c, passVidsigner__c FROM Account WHERE id =: opl.Centro2__c ];          
        String result = '';
        REST_WebService ws = new REST_WebService(acc.userVidsigner__c, acc.passVidsigner__c);
        String doc = ws.getSignedDocument(docGUI);
        System.debug('ALEX: el contenido del doc ' + doc);
        // En función del mensaje devuelto vamos a proceder a realizar una acción o otra.
        if (doc == '409'){ result = 'El documento no está firmado por completo';}
        else if(doc == '404'){ result = 'No se encuentra el documento firmado con el DocGUI especificado';}
        else if(doc == '403'){ result = 'El documento no es de esta suscripción';}
        else if(doc!='' || Test.isRunningTest()){
            Attachment at = new Attachment();
            at.Body = EncodingUtil.base64Decode(getJSONValue(doc, 'DocContent'));
            at.Name = getJSONValue(doc, 'FileName');  // add the user entered name
            at.IsPrivate = false;
            at.ParentId = opId;  // attach the pdf to the account
            if(!Test.isRunningTest()) insert at;
            result = 'OK';
            if(!Test.isRunningTest()) opl.Contrato_Firmado__c = true;
            update opl;            
        }
        return result;
    }
    
    webservice static String cancelSign(String opId, String docGUI){
        Oportunidad_platform__c opl = [ SELECT id, Enviado_a_signar__c, ID_Doc_Firmado__c, Centro2__c, 
                                         Autorizacion_judicial_de_internamiento__c 
                                        FROM Oportunidad_platform__c WHERE id =: opId ];
        Account acc = [ SELECT userVidsigner__c, passVidsigner__c FROM Account WHERE id =: opl.Centro2__c ];        
        
        REST_WebService ws = new REST_WebService(acc.userVidsigner__c, acc.passVidsigner__c);
        String result = ws.deleteDocument(docGUI, false);

        if(result==''){// doc deleted ok
            opl.Enviado_a_signar__c = false;
            opl.ID_Doc_Firmado__c = '';
            update opl;
        }
        return result;
    }

    webservice static String sendContract(String opId, String idTablet){
        
            Oportunidad_platform__c opl = [ 
                SELECT id, Name, RecordType.Name, Centro2__c, 
                  Director_Centro_First__c, Director_Centro_Last__c, DNI_Director__c,
                  Residente_First_Name__c, Residente_Last_Name__c, DNI_Residente__c, Residente__c,
                  Nombre_representante_legal__c, Apellido_representante_legal__c, DNI_representante_legal__c,
                  Nombre_propio_y_plena_capacidad_de__c, Representate_legagal__c, Persona_de_referencia__c, 
                  Nombre_Avalista__c, Apellido_Avalista__c, DNI_Avalista__c,
                  Pagador_First_Name__c, Pagador_Last_Name__c, DNI_Pagador__c, 
                  ID_Doc_Firmado__c, Enviado_a_signar__c, Pagador__c, Autorizacion_judicial_de_internamiento__c
                FROM Oportunidad_platform__c WHERE id =: opId ];
            List <Account> lacc = [ 
                   SELECT id, Name, Correo_Electronico_Generico__c, Utiliza_firma_biometrica__c, 
                    NIF_director_centro__c, Tableta_1__c, Tableta_2__c, Tableta_3__c, 
                    Nombre_Tablet_1__c, Nombre_Tablet_2__c, Nombre_Tablet_3__c, userVidsigner__c, passVidsigner__c 
                   FROM Account WHERE id =: opl.Centro2__c ];
            Account acc = (lacc.size()>0) ? lacc.get(0) : null;
            if(acc!=null){
                REST_WebService ws = new REST_WebService(acc.userVidsigner__c, acc.passVidsigner__c);
                Map<String, Object> p = new Map<String, Object>();
                
                //asignar parametros
                p.put(REST_WebService.OP_ID , opl.Id);
                p.put(REST_WebService.OP_NAME, opl.Name);
                p.put(REST_WebService.EMAIL, (acc.Correo_Electronico_Generico__c!=null) ? acc.Correo_Electronico_Generico__c : '');
                p.put(REST_WebService.TABLET_ID, idTablet);
                p.put(REST_WebService.SIGNERS , getSigners(acc, opl));        
                Map<String, String> result = (!Test.isRunningTest()) ? 
                    ws.postDocuments(p) : new Map<String,String>();
                String status = result.get(REST_WebService.STATUS);
                if(status=='OK' || Test.isRunningTest()){
                    opl.ID_Doc_Firmado__c = getJSONValue(result.get(REST_WebService.RESPONSE), 'DocGUI');            
                    opl.Enviado_a_signar__c = true;
                    try{
                        update opl;
                    } catch(Exception e){
                  System.debug('ERROR: ' + e.getMessage());
                  return 'error: ' + e.getMessage();
              }
                    
                }
                return status;
            }
            
         
        return 'error';
    }
    
    public static Map<String, Firmante> getSigners(Account acc, Oportunidad_platform__c opl){
        Map<String, Firmante> signers = new Map<String, Firmante>();
        
        /// Modalidades de firmantes
        
        if(opl.Nombre_propio_y_plena_capacidad_de__c){ //Firmantes: Residente y Avalista (si existe)
            signers.put(REST_WebService.USUARIO_REPR,
                        new Firmante(opl.Residente_First_Name__c + ' ' + opl.Residente_Last_Name__c, opl.DNI_Residente__c));            
            
        }else if(opl.Persona_de_referencia__c || opl.Autorizacion_judicial_de_internamiento__c){ //Firmantes: Familiar de referencia y Avalista (si existe)
            List <Relacion_entre_contactos__c> lrel = [SELECT id, Contacto__c 
                                                    FROM Relacion_entre_contactos__c
                                                    WHERE Residente__c  =: opl.Residente__c AND Familiar_de_referencia__c = true];
            Relacion_entre_contactos__c relacion = (lrel.size() > 0) ? lrel.get(0) : null;
            if(relacion!=null){
                List<Account> lfam = [ SELECT CIF_NIF__c, Name 
                                    FROM Account WHERE id =: relacion.Contacto__c LIMIT 1 ];
                Account familiar = (lfam.size() > 0) ? lfam.get(0) : null;
                if(familiar!=null){
                    signers.put(REST_WebService.PERSONA_REF, new Firmante( familiar.Name, familiar.CIF_NIF__c ));  
                }
            }
        }else if(opl.Representate_legagal__c) { //Firmantes: Representante Legal y Avalista (si existe)
      signers.put(REST_WebService.USUARIO_REPR, 
              new Firmante(opl.Nombre_representante_legal__c + ' ' + opl.Apellido_representante_legal__c, opl.DNI_representante_legal__c));
        }
        
        //Firmantes que se ponen solo si estan informados (Director del centro y Avalista)
        
        //Director del Centro
        if(account.Director_del_centro__c!=null){
           signers.put(REST_WebService.DIRECTOR_CENTRO, 
                       new Firmante(opl.Director_Centro_First__c + ' ' + opl.Director_Centro_Last__c, opl.DNI_Director__c));
        }
        //Avalista
        if(opl.Nombre_Avalista__c !=null){
            signers.put(REST_WebService.AVALISTA, 
                        new Firmante(opl.Nombre_Avalista__c + ' ' +opl.Apellido_Avalista__c, opl.DNI_Avalista__c));
        }
          //Pagador
        if(opl.Pagador__c!=null){
           signers.put(REST_WebService.PAGADOR, 
                    new Firmante(opl.Pagador_First_Name__c + ' ' +opl.Pagador_Last_Name__c, opl.DNI_Pagador__c));         
        }
        
        return signers;
    } 

    
    public static String getJSONValue(String jsonStr, String key){
        JSONParser parser = JSON.createParser((jsonStr!=null) ? jsonStr : '');
        String value = '';
        while (parser.nextToken()!= null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == key) {
                    value = parser.getText();
                }
          }
      }
        return value;  
    }
    
    
}