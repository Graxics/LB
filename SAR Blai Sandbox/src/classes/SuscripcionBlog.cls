public class SuscripcionBlog{
	@future(callout =true)
    public static void suscribirCuenta(String url, String body) {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody(body);
        //req.setCompressed(true); // otherwise we hit a limit of 32000
		System.Debug('AQUII: '+body);
       
        
            if (!Test.isRunningTest()) {
                 res = http.send(req);
                 System.debug(res.getBody());
            }

        
    }
        

}