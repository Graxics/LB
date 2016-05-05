public class DocDelete {
    
    // URL's we want to access
    private static final String URL_API_PROD = 'https://vidsignercloud.validatedid.com/api';
    private static final String URL_API_PRE = 'https://pre-vidsignercloud.validatedid.com/api';
    private static final String URL_GET_DEVICES = URL_API_PRE + '/devices'; 
    private static final String URL_POST_DOCUMENTS = URL_API_PRE + '/documents/'; 
    private static final String URL_SIGNED_DOCUMENTS = URL_API_PRE + '/signeddocuments/';
    
    public class VariableRequest {
        @InvocableVariable
        public String Doc_Gui;
        @InvocableVariable
		public String Id_Pagador;
    }
      
	@InvocableMethod
    public static void deleteDocument(List<VariableRequest> requests){   
        for(VariableRequest requestObj:requests){
            Account pagador = [Select 	userVidsigner__c, 	passVidsigner__c 	FROM Account Where ID =:requestObj.Id_Pagador];
            String Doc_Gui = requestObj.Doc_Gui;
            Blob headerValue = Blob.valueOf(pagador.userVidsigner__c +':' + pagador.passVidsigner__c);        
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue); 
            deleteDocumentFuture(Doc_Gui, authorizationHeader);
        }
    }
    
    @future(callout=true)
    public static void deleteDocumentFuture(String Doc_Gui, String authorizationHeader){
            Http httpCall = new Http();         
            HTTPRequest req = new HTTPRequest();
            HttpResponse resp = new HttpResponse();        
            req.setEndpoint( ( (true) ? URL_SIGNED_DOCUMENTS : URL_POST_DOCUMENTS ) + Doc_Gui);         
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
               // throw new MyException('Please wait till the DML operation is commited and try again');
            }
            System.debug('resp.getStatus() = ' + resp.getStatus());
            System.debug('resp.getBody() = ' + resp.getBody());       
    }
    
    
    
}