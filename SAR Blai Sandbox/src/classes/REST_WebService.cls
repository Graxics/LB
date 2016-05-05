/* Updates Log:
*  Alexander Shubin (09/03/2016): 
*					1) Solo crear documento y actualizar OP si el WS devuelve un documento.
*					2) Corregido el error de borrar el documento de WS
*  Alexander Shubin (04/04/2016): 
*					1) Agregar las respuestas de los posibles errores que pueden suceder.
*/

public class REST_WebService {
    
    private Blob headerValue;
    private String authorizationHeader;
    // URL's we want to access
    private static final String URL_API_PROD = 'https://vidsignercloud.validatedid.com/api';
    private static final String URL_API_PRE = 'https://pre-vidsignercloud.validatedid.com/api';
    private static final String URL_GET_DEVICES = URL_API_PROD + '/devices'; 
    private static final String URL_POST_DOCUMENTS = URL_API_PROD + '/documents/'; 
    private static final String URL_SIGNED_DOCUMENTS = URL_API_PROD + '/signeddocuments/';
    //field params
    public static final String OP_ID = 'OpID';
    public static final String OP_NAME = 'OpName';
    public static final String NUMBER_ID = 'NumberID';
    public static final String EMAIL = 'eMail';
    public static final String FIRST_NAME = 'firstName';
    public static final String LAS_NAME = 'lastName';
    public static final String TABLET_ID = 'tabletID';
    public static final String SIGNERS = 'signers';
    //signers
    public static final String DIRECTOR_CENTRO = 'directorCentro';
    public static final String USUARIO_REPR = 'usuarioRepresentante';
    public static final String PERSONA_REF = 'personaRef';
    public static final String AVALISTA = 'avalista';
    public static final String PAGADOR = 'pagador';
    //result
    public static final String STATUS = 'status';
    public static final String RESPONSE = 'response';
    //user/pass VidSigner
    public static final String USER_VIDSIGNER = 'userVidSigner';
    public static final String PASS_VIDSIGNER = 'passVidSigner';
    
    public REST_WebService(){ }
    
    public REST_WebService(String user, String pass){
        headerValue = Blob.valueOf(user +':' +pass);
        authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
    }

// ---------------------------------------------------------------------------------------------------------------------------    
     // Returns the list with all the available signature devices for a subscription. 
     // The subscription information is got from the Authorization header
     public void GetDevices(){       
        // Using the Http class to initiate an HTTP request and response. Calling to Webservice
        Http httpCall = new Http();         
        //Using the HttpRequest class to programmatically create HTTP requests like GET, POST, PUT, and DELETE
        HTTPRequest req = new HTTPRequest();
        HttpResponse resp = new HttpResponse();        
        //Setting the variable "endpoint" as the endpoint for the HTTPRequest variable "req"
        req.setEndpoint(URL_GET_DEVICES);         
        // Setting requiered headers
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        //Setting the HTTPRequest's request method to "GET"
        req.setMethod('GET');
         
        try {
         //Send the request and capture the results in an HTTPResponse variable called "resp"
            if(!Test.isRunningTest()) resp = httpCall.send(req);
            System.debug('Response: ' + resp.getBody());} 
        catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(resp.toString());}
    }
// ---------------------------------------------------------------------------------------------------------------------------     
    
    private String addSignerDTO(String key, String deviceName, 
                                String pictureURI, String sizeX, String sizeY, 
                                Map<String, Firmante> firmantes, String anchor){
        return '{' +
                    '"DeviceName": "' + deviceName + '",' +
                    '"NumberID": "' +  firmantes.get(key).getDNI() +'",' +                    
                    '"PictureURI": "' + pictureURI + '",' +
                    '"SignerGUI": null,' + //Must be set to null on the request
                    '"SignerName": "'+ firmantes.get(key).getName() +'",' +
                    '"DocusignSigner": false,' + 
                    '"UserNotices": null,' + //Information of the user notice
                    '"TypeOfID": "nif",' +
                    //'"eMail": "'+ p.get(EMAIL) +'",' +
                    '"Visible": {' +
                    '"Anchor": "' + anchor + '",' +
                    '"SizeX": ' + sizeX + ' ,' +
                    '"SizeY": ' + sizeY + ' ,' +
                    '}' +
            '}';        
    }
    
    public Map<String, String> postDocuments(Map<String, Object> p){             

        Map<String, String> result = new Map<String, String>();        
        Http httpCall = new Http();         
        HTTPRequest req = new HTTPRequest();
        HttpResponse resp = new HttpResponse();    
        System.debug('url = '+URL_POST_DOCUMENTS);
        req.setEndpoint(URL_POST_DOCUMENTS);  
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        //if(Test.isRunningTest()) return result;
        
        PageReference pdf = new PageReference('/apex/ContractPDF?Id=' + p.get(OP_ID));
    Blob body;
        String base64Text = '';
        if(!Test.isRunningTest()){
            body = pdf.getContentAsPDF();
      base64Text = EncodingUtil.base64Encode(body);            
        }
        String deviceName = (String) p.get(TABLET_ID);
        String sizeX = '70';
        String sizeY = '15';
        String pictureURI = 'http://a1.twimg.com/profile_images/542045222/ivan.jpg';
        String defaultSignerName = '';
        String defaultNumberID = '';
        List <String> signerDTO = new List<String>();
        Map<String, Firmante> firmantes = (Map<String, Firmante>) p.get(SIGNERS);
        if(firmantes!=null){
            if(firmantes.get(USUARIO_REPR)!=null){
                signerDTO.add(addSignerDTO(USUARIO_REPR, deviceName, pictureURI, sizeX, sizeY, firmantes, 'ANCHOR_USUARIO'));
            }        
            
            if(firmantes.get(DIRECTOR_CENTRO)!=null){
                signerDTO.add(addSignerDTO(DIRECTOR_CENTRO, deviceName, pictureURI, sizeX, sizeY, firmantes, 'ANCHOR_DIR'));
            }
           
            if(firmantes.get(PERSONA_REF)!=null){
                signerDTO.add(addSignerDTO(PERSONA_REF, deviceName, pictureURI, sizeX, sizeY, firmantes, 'ANCHOR_PER_REF'));
            }
            
            if(firmantes.get(AVALISTA)!=null){
                signerDTO.add(addSignerDTO(AVALISTA, deviceName, pictureURI, sizeX, sizeY, firmantes, 'ANCHOR_AVALISTA'));
            }
            
            if(firmantes.get(PAGADOR)!=null){
                signerDTO.add(addSignerDTO(PAGADOR, deviceName, pictureURI, sizeX, sizeY, firmantes, 'ANCHOR_PAGADOR'));
            }           
        }
        req.setBody(
            '{' +
                '"DocContent": "' + base64Text + '",' +
                '"FileName": "Contract_' + p.get(OP_NAME) +'.pdf",' +
                '"OrderedSignatures": false,' +
                '"AdditionalData": null,'+ //Extra information of the document sent on the post document
                '"DocusignInfo": null,'+
                '"Signers": [' + String.join(signerDTO, ',') + ']}'
        );
        System.debug(req.getBody());
        
        
        try {
         //Send the request and capture the results in an HTTPResponse variable called "resp"
            req.setTimeout(30000);    
            if(!Test.isRunningTest()) resp = httpCall.send(req);
            result.put(STATUS, resp.getStatus());
            result.put(RESPONSE, resp.getBody());
            
        } 
        catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(resp.toString());
        }
        
        return result;
    } //fin postDocuments
    
    //obtiene un documento firmado. Si va todo bien, retorna ok, sino retorna ''
    //@future(callout=true)
    public String getSignedDocument(String docGUI){
        Http httpCall = new Http();         
        HTTPRequest req = new HTTPRequest();
        HttpResponse resp = new HttpResponse();        
        req.setEndpoint(URL_SIGNED_DOCUMENTS + docGUI);         
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('GET'); 
        req.setTimeout(30000);
        
        try {
            if(!Test.isRunningTest()) resp = httpCall.send(req);
        }catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(resp.toString());
        } 
        // Modificación para enviar la respuesta adecuada.
        //return (resp!=null && resp.getStatus()=='OK') ? resp.getBody() : '';
        return (resp.getStatusCode() == 200 && resp!=null) ? resp.getBody() : string.valueof(resp.getStatusCode());
    }
    
    public class My1Exception extends Exception {}
    //borra un documento. Si todo va bien, retorna ok, sino retorna mensaje de error
    public String deleteDocument(String docGUI, boolean signedDocs){
        Http httpCall = new Http();         
        HTTPRequest req = new HTTPRequest();
        HttpResponse resp = new HttpResponse();        
        req.setEndpoint( ( (signedDocs) ? URL_SIGNED_DOCUMENTS : URL_POST_DOCUMENTS ) + docGUI);         
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('DELETE'); 
        req.setTimeout(30000);
        try {
            if(!Test.isRunningTest()) resp = httpCall.send(req);
            System.debug('OK');
        }catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(resp.toString());
            throw new My1Exception(e.getMessage());
        }
        System.debug('resp.getStatus() = ' + resp.getStatus());
        System.debug('resp.getBody() = ' + resp.getBody());
        return (resp!=null && resp.getStatus()=='No Content' ) ? '' : resp.getBody();
    }


    
}