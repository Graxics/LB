public with sharing class escogerTableta {

    String tableta= null;
    
    public Oportunidad_platform__c op {get;set;}
    public Account ac {get;set;}
    public class xException extends Exception {}
    public String idTablet {
        get;
        // *** setter is NOT being called ***
        set {
            idTablet = value;
        }
    } 
    public String pagOP {
        get;
        // *** setter is NOT being called ***
        set {
            pagOP = value;
        }
    }      
    private Map<String, String> result;
    List<SelectOption> options;

    public escogerTableta(){
        op = [ SELECT id, Name, RecordType.Name, Centro2__c, 
              Director_Centro_First__c, Director_Centro_Last__c, DNI_Director__c,
              Residente_First_Name__c, Residente_Last_Name__c, DNI_Residente__c, Autorizacion_judicial_de_internamiento__c,
              Nombre_representante_legal__c, Apellido_representante_legal__c, DNI_representante_legal__c,
              Nombre_propio_y_plena_capacidad_de__c, Representate_legagal__c, Persona_de_referencia__c, 
              Nombre_Avalista__c, Apellido_Avalista__c, DNI_Avalista__c,
              Pagador_First_Name__c, Pagador_Last_Name__c, Residente__c, DNI_Pagador__c,
              ID_Doc_Firmado__c, Enviado_a_signar__c, Pagador__c
              FROM Oportunidad_platform__c 
              WHERE id =: ApexPages.currentPage().getParameters().get('id') ];
        ac = [ SELECT id, Name, Correo_Electronico_Generico__c, Utiliza_firma_biometrica__c, NIF_director_centro__c, Tableta_1__c, Tableta_2__c, Tableta_3__c, 
                Nombre_Tablet_1__c, Nombre_Tablet_2__c, Nombre_Tablet_3__c, userVidsigner__c, passVidsigner__c  
               FROM Account WHERE id =: op.Centro2__c ];

        
    }
  
    public PageReference enviarPDF() {
       
        REST_WebService ws = new REST_WebService(ac.userVidsigner__c, ac.passVidsigner__c);
        if(op.Enviado_a_signar__c){
            result = new Map<String, String>();
            result.put(REST_WebService.STATUS, 'El contrato ya se ha enviado a signar');
            return null;
        }
        Map<String, Object> p = new Map<String, Object>();
        p.put(REST_WebService.USER_VIDSIGNER, ac.userVidsigner__c);
        p.put(REST_WebService.PASS_VIDSIGNER, ac.passVidsigner__c);        
        p.put(REST_WebService.OP_ID , String.valueOf(op.id));
        p.put(REST_WebService.OP_NAME, op.Name);
        p.put(REST_WebService.EMAIL, (ac.Correo_Electronico_Generico__c!=null) ? ac.Correo_Electronico_Generico__c : '');
        p.put(REST_WebService.TABLET_ID, idTablet);
        p.put(REST_WebService.SIGNERS , CalloutVidsigner.getSigners(ac, op));
        
        result = ws.postDocuments(p);
        
        if(result !=null && result.get(REST_WebService.STATUS)=='OK'){ //PDF subido correctamente -> guardar ID Doc
            String docGUI = CalloutVidsigner.getJSONValue(result.get(REST_WebService.RESPONSE), 'DocGUI');
            op.ID_Doc_Firmado__c = docGUI;
            op.Enviado_a_signar__c = true;
            update op;
        }
        
        return null;
    }

    public List<SelectOption> getItems() {
        options = new List<SelectOption>();
        
        if(ac.Tableta_1__c!=null && ac.Tableta_1__c !=''){
            options.add(new SelectOption(ac.Tableta_1__c, ac.Nombre_Tablet_1__c ));     
        }
        if(ac.Tableta_2__c!=null && ac.Tableta_2__c !=''){
            options.add(new SelectOption(ac.Tableta_2__c, ac.Nombre_Tablet_2__c ));      
        }
        if(ac.Tableta_3__c!=null && ac.Tableta_3__c !=''){
            options.add(new SelectOption(ac.Tableta_3__c, ac.Nombre_Tablet_3__c ));     
        }
        
        return options;
    }
    
    public String getTableta() {
        return tableta;
    }
    
    public void setTableta(String tableta) { 
        this.tableta = tableta; 
    }
  
    public String getResult(){
        String r = 'a';
         r = (result!=null) ? result.get(REST_WebService.RESPONSE) : '';
            if(r.contains('DocGUI')){
                r = result.get(REST_WebService.STATUS);
            }

            return r;
        //return (result!=null) ? result.get(REST_WebService.RESPONSE) : '';
        //return ( (r!=null) ? (r.contains('DocGUI') ? result.get(REST_WebService.STATUS) : r );
    }
 
    public String getVisible(){
        return (result==null) ? 'display:none;' : '';
    }
   
    public PageReference backOP(){
        return new PageReference('/' + op.Id);
    }    

}