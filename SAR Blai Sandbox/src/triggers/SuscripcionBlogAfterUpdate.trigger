trigger SuscripcionBlogAfterUpdate on Oportunidad_platform__c (after update) {
     if(triggerHelper.todofalse()) { 
         System.Debug('Entra antes de suscripcion blog');
 //  	if (TriggerHelperExecuteOnce.executar12() == true) {
            System.Debug('Entra en suscripcion blog');
            List<ID> residentes = new List<ID>();
            Set<ID> centros = new Set<ID>();
            Map<ID,ID> MapCentroOppt = new Map<ID,ID>();
            Recordtype rt = [select id, name from Recordtype where name = 'Centro' limit 1];
            Map<ID,String> CentrosBlog = new map<ID,String>();
            for (Account centro :[select id, Codigo_Blog__c from Account where recordtypeid = :rt.id and Codigo_Blog__c != null]) {
                System.debug('CENTRO: '+centro.id+' - BLOG :'+centro.Codigo_Blog__c);
                CentrosBlog.put(centro.id,centro.codigo_blog__c);
            }
            Set<ID> centrosconblog = CentrosBlog.keySet();
            
            Map<ID,String> ResidenteBlog = new Map<ID,String>();
            
            
            for (Oportunidad_platform__c opp : Trigger.new) {
                System.debug('OPP ID: '+opp.id);
                Oportunidad_platform__c oldopp = Trigger.oldmap.get(opp.id);
                System.debug('OLD Stage: '+oldopp.Etapa__c+' - NEW Stage: '+opp.Etapa__c);
                if (oldopp.Etapa__c != 'Ingreso' && opp.Etapa__c == 'Ingreso') {
                    if(centrosconblog.contains(opp.centro2__c)) {
                        if (opp.recordtypeid == '012b0000000QC6IAAW') residentes.add(opp.Cliente_residente__c);
                        else  residentes.add(opp.Residente__c);
                        ResidenteBlog.put(opp.Residente__c,CentrosBlog.get(opp.Centro2__c));
                    } 
                }
            }
            
            List<ID> familiares = new List<ID>();
            for (Relacion_entre_contactos__c rc : [select ID, Residente__c, Contacto__c from Relacion_entre_contactos__c where Residente__c in :residentes]) {
                ResidenteBlog.put(rc.Contacto__c,ResidenteBlog.get(rc.Residente__c));
                familiares.add(rc.Contacto__c);
            }
            System.debug(residentes);
            System.debug(familiares);
            List<String> emails = new List<String>();
            String url = 'http://www.sarquavitae.es/ws/ws_blog_subscribe.php';
             String body;
            for (Account a : [select id, personemail, firstname, lastname from Account where recordtypeid = '012b0000000QAe0AAG' and personemail != null and (id in :residentes or id in:familiares)]) {
          
                Blob targetBlob = Blob.valueof(a.personEmail+'ZSF345DFGPLWMU9743F9BHG');
                Blob hashSHA1 = Crypto.generateDigest('SHA1', targetBlob);
                String key = EncodingUtil.convertToHex(hashSHA1);
                
                if(Test.isRunningTest()) {
                     body = 'key='+key+'&post_author='+ResidenteBlog.get(a.id)+'&subscr_name='+a.firstname+' '+a.LastName+'&subscr_mail='+a.personemail;
                } else {
                    body = 'key='+key+'&post_author='+ResidenteBlog.get(a.id)+'&subscr_name='+a.firstname+' '+a.LastName+'&subscr_mail='+a.personemail;
                }
                
                SuscripcionBlog.suscribirCuenta(url, body);
     	}
     }
}