trigger candidats_to_cat_otros  on Lead (after insert)  {
    System.debug('TRIGGER@candidats_to_cat_otros');
    List <User> volanteCAT = [ SELECT Id FROM User WHERE Alias = 'vcat' LIMIT 1 ];
    Id volanteCATID = (volanteCAT.size() > 0) ? volanteCAT.get(0).Id : null;
    Boolean deleteLeads = (Label.BorrarCandidatosWeb == 'Si') ? true: false;
    // PONER LOS IFS PARA QUE NO ENTRE EN BUCLE
    MapIDCentros mic = new MapIDCentros();
    Map<String,String> centros = mic.getMap();
    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    //User thisUser = [SELECT id FROM User WHERE alias = 'wsarq'];
    List<Lead> candidats = Trigger.new;
    List<Lead> candidatos_newsletter= new List<Lead>();
    List<Lead> candidatos_jornadas = new List<Lead>();
    Set<String> newsletter_emails = new Set<String>();
    Set<String> jornadas_emails = new Set<String>();
    List<String> lead_emails = new List<String>();
    List<String> id_campanas = new List<String>();
    List<Task> tareas = new List<Task>();
    Task debug = new Task(Subject = 'Contacto Web', Status = 'Pendiente');
    List<Account> cuentas = new List<Account>();
    List<Task> tasksToUpdate = new List<Task>();

    Recordtype RtypeTareaCatOtros = [Select Id, Name From RecordType Where Name = 'CAT - Otros' LIMIT 1];
    List<id> id_candidats = new List<id>();
    Map<String,String> mapcodigoscentro = new Map<String,String>();
    Map<String, ID> mapemailcuenta = new Map<String,ID>();
    Map<String,ID> mapidcampana = new Map<String,ID>();
    Map<String,String> MapContactCampaign = new Map <String,String>();
    List <Account> lcc = [ SELECT Id FROM Account WHERE Name = 'Cliente Comodín' ];
	Id idCC = (lcc.size() > 0) ? lcc.get(0).Id : null; //id del cliente comodin 
    System.debug('idCC = ' + idCC);
    for (Lead c:candidats) {
        if (c.Email != null) lead_emails.add(c.Email);
        //c.OwnerId = (volanteCATID!=null) ? volanteCATID : '00511000002g1IdAAI';
    }
    
   // debug.Description += 'cts size: '+cts.size();
   	List<Account> cuentasupdate = new List<Account>();
   	Map<String,Account> Mapemailcuentafull = new Map<String,Account>();
    for (Account a:[select id, PersonEmail,Description from Account where PersonEmail <> null and PersonEmail in :lead_emails]) {
        mapemailcuenta.put(a.personemail, a.id);
        mapemailcuentafull.put(a.personemail, a);
    }
	System.debug('mapemailcuenta: ');
    System.debug(mapemailcuenta);
    System.debug('*****');
	User tareaowner = [Select id from User where alias = :Label.UsuarioTareasCAT];   
    for(Lead c:candidats) {
        String nombrecentro;
        if (c.ID_Centro__c != null)   nombrecentro = c.Nombre_Centro__c; // nombrecentro = mapcodigoscentro.get(c.ID_Centro__c);
        String nform = c.Numero_de_formulario__c;
        String formattedphone = '';
        System.debug('entra 1');
        if (nform != null) {
            System.debug('entra 2');
            id_candidats.add(c.id);
            Task tarea = new Task(Subject = 'Contacto Web', Status = 'Pendiente');
            tarea.Status = 'Pendiente';
            tarea.OwnerId = tareaowner.id; //thisUser.Id;
            tarea.RecordTypeId = RtypeTareaCatOtros.Id;
            tarea.Canal__c = 'Registro vía web';
            tarea.Priority = 'Normal';
            tarea.ActivityDate = Date.today().addDays(2);    
 
            String obs = '';
             if (nform.equals('01')) {//Formulario: Te puedo ayudar 01
              //  tarea.Subject = 'Formulario 01';
                obs = 'Formulario 01: ¿Te puedo ayudar? \n';
                obs = obs+'Nombre: '+c.FirstName+' '+c.LastName+'\n';
                obs = obs+'Email: '+c.Email+'\n';
                obs = obs+'Teléfono: '+c.Phone+'\n';
                obs = obs+'Horario de contacto: '+c.Hora_de_llamada__c+'\n';
                obs = obs+'Provincia: '+c.Provincia__c+'\n';
             //   obs = obs+'Centro: '+nombrecentro+'  ('+c.ID_Centro__c+')\n';
                obs = obs+'Motivo de consulta: '+c.Motivo_Consulta__c+'\n';
                 System.debug('mapemailcuenta.get(c.Email) = ' + mapemailcuenta.get(c.Email));
                if (mapemailcuenta.containsKey(c.Email)) tarea.Whatid = mapemailcuenta.get(c.Email);
                
                 
            } 
            else if (nform.equals('02')) { //Formulario: Contrato de teleasistencia
             //   tarea.Subject = 'Formulario 02';
                obs = 'Formulario 02: Contrato de teleasistencia\n';
                obs = obs+'Nombre Solicitante: '+c.FirstName+' '+c.LastName+'\n';
                obs = obs+'DNI Solicitante: '+c.DNI_Solicitante__c+'\n';
                obs = obs+'Email Solicitante: '+c.Email+'\n';
                obs = obs+'Teléfono Solicitante: '+c.Phone+'\n';
                obs = obs+'Cuenta Bancaria: '+c.Cuenta_Bancaria__c+'\n';
                obs = obs+'Nombre Usuario:'+c.Nombre_Usuario__c+' '+c.Apellidos_Usuario__c+'\n';
                obs = obs+'Provincia Usuario: '+c.Provincia_Usuario__c+'\n';
                obs = obs+'DNI Usuario: '+c.DNI_Usuario__c+'\n';
                obs = obs+'Teléfono al que se aplica: '+c.Telefono_Usuario__c+'\n';
                String direccion = '';
                if (c.Calle__c != null) direccion += c.Calle__c;
                if (c.NumCalle__c != null) direccion += ', '+c.NumCalle__c;
                if (c.Piso__c != null) direccion += ', '+c.Piso__c+'º ';
                if (c.Puerta__c != null ) direccion += c.Puerta__c;
                if (c.Escalera__c != null) direccion += ' - Escalera '+c.Escalera__c;  
                obs = obs+'Dirección: '+direccion+'\n';
                obs = obs+c.Codigo_Postal__c+' '+ ((c.Ciudad__c!=null && c.Ciudad__c!='null') ?
                    c.Ciudad__c : '')+'\n'; 
                System.debug('mapemailcuenta.get(c.Email) = ' + mapemailcuenta.get(c.Email));
                if (mapemailcuenta.containsKey(c.Email)) tarea.Whatid = mapemailcuenta.get(c.Email);
            } 
            else if (nform.equals('03') || nform.equals('08') || nform.equals('09') ||nform.equals('10') || nform.equals('11')) {
             //   tarea.Subject = 'Formulario 03';
                if (nform.equals('11')){obs = 'Formulario '+nform+': Campaña\n';}
                else{obs = 'Formulario '+nform+': Contacte con nosotros\n';}
                obs = obs+'Nombre: '+c.FirstName+' '+c.Lastname+'\n';
                obs = obs+'Email: '+c.Email+'\n';
                obs = obs+'Teléfono: '+c.Phone+'\n';
                obs = obs+'Hora de llamada: '+c.Hora_de_llamada__c+'\n';
                obs = obs+'Provincia: '+c.Provincia__c+'\n';
                obs = obs+'Motivo de consulta: '+c.Mensaje__c+'\n';   
                if (mapemailcuenta.containskey(c.Email) != null) tarea.Whatid = mapemailcuenta.get(c.Email);
            } 
            else if (nform.equals('04')) {
              //  tarea.Subject = 'Formulario 04';
                obs = 'Formulario 04: Envía un mensaje a tu familiar\n';
                obs = obs+'Nombre completo del familiar o amigo:' + c.Nombre_Familiar__c+'\n';
                obs = obs+'Mi Nombre: '+c.FirstName+'\n';
                obs = obs+'Mis Apellidos: '+c.LastName+'\n';
                obs = obs+'Email: '+c.Email+'\n';
                obs = obs+'Mensaje: '+c.Mensaje__c+'\n';
                System.debug('mapemailcuenta.get(c.Email) = ' + mapemailcuenta.get(c.Email));
                if (mapemailcuenta.containskey(c.Email) != null) tarea.Whatid = mapemailcuenta.get(c.Email);
            } 
            else if (nform.equals('05')) {
             //   tarea.Subject = 'Formulario 05';
                obs = 'Formulario 05: Sugerencias\n';
                obs = obs+'Concepto: '+c.Concepto__c+'\n';
                obs = obs+'Nombre: '+c.FirstName+' '+c.LastName+'\n';
                obs = obs+'Teléfono: '+c.Phone+'\n';
                obs = obs+'Email: '+c.Email+'\n';
                obs = obs+'Nombre del familiar: '+c.Nombre_Familiar__c+'\n';
                obs = obs+'Apellidos del familiar: '+c.Apellidos_Familiar__c+'\n';
                obs = obs+'Mensaje: '+c.Mensaje__c+'\n';
                //tarea.WhoId = c.Id; //candidato (Nombre)
                
                if (mapemailcuenta.containskey(c.Email) != null){
                    tarea.Whatid = mapemailcuenta.get(c.Email);
                }else if(idCC!=null){
                    tarea.Whatid = idCC;
                } 
 
            }
            //formulario jornadas
            else if (nform.equals('06')) {
                if (c.ID_Campa_a__c != null) {
                    candidatos_jornadas.add(c);
                	jornadas_emails.add(c.Email);
                	id_campanas.add(c.ID_Campa_a__c);
               	 	mapcontactcampaign.put(c.Email,c.ID_Campa_a__c);
                	if (c.Centro_SARquavitae__c != null) {
                    	if (mapemailcuentafull.containskey(c.Email)) {
                        	Account cu = mapemailcuentafull.get(c.Email);
                        	if (cu.Description == null ) cu.Description = 'Centro SARquavitae: '+c.Centro_SARquavitae__c;
                        	else cu.Description += '\n Centro SARquavitae: '+c.Centro_SARquavitae__c;
                        	cuentasupdate.add(cu);
                            System.debug('cu OwnerId = ' + cu.OwnerId);
                   		}
                	}
                }
                
            }
            else if (nform.equals('07')) {
                obs = 'Formulario 07: Suscripción al Newsletter\n';
                obs += 'Nombre: '+c.Firstname+'\n';
                obs += 'Email: '+c.Email+'\n';
                candidatos_newsletter.add(c);
                newsletter_emails.add(c.Email);
                Account cu2 = mapemailcuentafull.get(c.Email);
                if(cu2!=null){
                    cu2.Fuente__c = 'Suscriptores newsletter';
                    cu2.Clasificacion__c = 'Particulares';
                    cu2.Responsable_contacto__c = 'Marketing';
                    cu2.PersonEmail = c.Email;                
                    cuentasupdate.add(cu2);
                }
               
            }
            if( nform.equals('08') || nform.equals('09') || nform.equals('10') || nform.equals('03') ) {
                if (c.Id_servicio__c != null) obs += 'Servicio: '+c.Id_servicio__c+' - '+c.Servicio__c+'\n';
            }
            if (nform.equals('11')) {
                obs += 'Campaña: '+c.ID_Campa_a__c;
            }
            System.debug('entra 3');
            if (!nform.equals('07') && !nform.equals('06')) {
                if (c.ID_Centro__c != null) {
                    if (centros.containskey(c.ID_Centro__c)) {
                         obs += 'Centro: '+centros.get(c.ID_Centro__c)+'\n';
                   		 obs += 'ID Centro: '+c.ID_Centro__c+'\n';
                    }
                }
                
                //tarea.WhoId = c.Id; //candidato o contacto (nombre)
                /*
                if (mapemailcuenta.containskey(c.Email) != null){
                    tarea.Whatid = mapemailcuenta.get(c.Email); //cuenta
                }
                */
                
                if (mapemailcuenta.containskey(c.Email) != null){
                    tarea.Whatid = mapemailcuenta.get(c.Email);
                }else if(idCC!=null){
                    tarea.Whatid = idCC;
                } 

                tarea.Description = obs;
                System.debug('entra 4');
                if(tarea.WhatId!=null) tarea.WhoId = null;
                if (nform != '04') tareas.add(tarea);
           }
                    
    	}
    }
 
 	 ////CAMPAÑAS
  	Map <String,ID> mapemailcontact = new Map<String,ID>();
    
     for (Contact ct :[select id, email from Contact where email in :jornadas_emails]) {
        	jornadas_emails.remove(ct.Email);
         	mapemailcontact.put(ct.Email,ct.ID);
     }
  
     List<Account> cuentasjornadas = new List<Account>();
     Recordtype CSC = [select id from recordtype where name = 'Contacto Servicios Centrales'];
     for (Lead c:candidatos_jornadas) {
         if(jornadas_emails.contains(c.Email)) {
             Account cuenta = new Account(recordtypeid = CSC.id, firstname = c.Firstname, lastname = c.lastname); 
             if (c.Phone != null) {
                 String formattedphone = c.Phone;
            	formattedphone = formattedphone.replace(' ','');
            	formattedphone = formattedphone.replace('.','');
            	formattedphone = formattedphone.replace('-','');
           		formattedphone = formattedphone.replace('(','');
            	formattedphone = formattedphone.replace(')','');
                formattedphone = formattedphone.replace('+','00');
          		cuenta.Phone = formattedphone;   
             } 
             if (c.Titulacion__c != null) cuenta.PersonTitle = c.Titulacion__c;
           	 cuenta.PersonEmail = c.Email; 
             cuenta.Responsable_contacto__c = 'Marketing';
             //if (UserInfo.GetUsername().indexof('.test') >= 0) cuenta.Ownerid = '00511000002g1IdAAI';
             //else cuenta.OwnerId = '005b0000002XqTU'; // usuario Volante - CAT
             cuenta.OwnerId = (volanteCATID!=null) ? volanteCATID : '00511000002g1IdAAI';
             cuenta.Fuente__c = 'Jornadas y eventos';
             if (c.Provincia_Usuario__c != null) cuenta.Provincia__c = c.Provincia_Usuario__c;
             if (c.Provincia__c != null) cuenta.Provincia__c = c.Provincia__c;
             if (c.Calle__c != null) cuenta.Calle__c = c.Calle__c;
             if (c.DNI_Solicitante__c != null) {
                 String dni = c.DNI_Solicitante__c.replace('.','');
                 dni = dni.replace(' ','');
                 dni = dni.replace('-','');
                 cuenta.CIF_NIF__c = dni;
             }
                  
             if (c.City != null) cuenta.Ciudad__c = c.City;
             if (c.Centro_Trabajo__c != null) cuenta.Entidad_Centro_de_trabajo__c = c.Centro_Trabajo__c;
         //    cuenta.PersonMailingAddress = c.Direccion__c;
         	 if (c.Direccion__c != null) cuenta.Calle__c = c.Direccion__c;
             if (c.Pais__c != null ) cuenta.PersonMailingCountry = c.Pais__c;
             if (c.Codigo_Postal__c != null) cuenta.Codigo_postal__c = c.Codigo_Postal__c;
             if (c.Mensaje__c != null) cuenta.Observaciones_personales__c = c.Mensaje__c;         
             cuentasjornadas.add(cuenta);
             System.debug('cuenta2 OwnerId = ' + cuenta.OwnerId);
         }
     }
    
   	
    for (Contact ct :[select id, email from Contact where email in :jornadas_emails]) {
        	jornadas_emails.remove(ct.Email);
         	mapemailcontact.put(ct.Email,ct.ID);
     }
    for (Campaign cp : [select id, id_campana__c from Campaign where id_campana__c in:id_campanas]) {
        mapidcampana.put(cp.id_campana__c,cp.id);
    }
    List<CampaignMember> miembrosCampana = new List<CampaignMember>();
   	for (String email :mapcontactcampaign.keySet()) {
        debug.Description += mapcontactcampaign.keySet()+'\n';
        CampaignMember cm = new CampaignMember(ContactID = mapemailcontact.get(email), 
                                               CampaignID = mapidcampana.get(mapcontactcampaign.get(email)));
        miembrosCampana.add(cm);	
     }

    //// NEWSLETTER
    List<Contact> contacts = new List<Contact>();
    for (Contact ct :[select id, email from Contact where email in :newsletter_emails]) {
        ct.HasOptedOutOfEmail = false;
        contacts.add(ct);
        //newsletter_emails.remove(ct.Email);
    }
    
    boolean cuentaInsertada = false;
    for (Lead c: candidatos_newsletter) {
        System.debug('lead c.Email =' + c.Email);
        
        if (newsletter_emails.contains(c.Email)){
         	Account cuenta = new Account(recordtypeid = CSC.id, lastname = c.Lastname, firstname = c.FirstName);
            cuenta.Responsable_contacto__c = 'Marketing';
            cuenta.OwnerId = (volanteCATID!=null) ? volanteCATID : '00511000002g1IdAAI';
            cuenta.Fuente__c = 'Suscriptores newsletter';
            cuenta.Clasificacion__c = 'Particulares';
            cuenta.Responsable_contacto__c = 'Marketing';
            cuenta.PersonEmail = c.Email;
            cuentas.add(cuenta);
            cuentaInsertada = true;
        }
    }
    
    //tareas.add(debug);
    //insert tareas;
    if(!cuentaInsertada) {
        insert cuentasjornadas;
        System.debug(cuentasjornadas.size() + ' cuentasjornadas insertadas');
    }
    else{
        insert cuentas;
        System.debug(cuentas.size() + ' cuentas insertadas');
    }
    insertar(tareas);
    System.debug(tareas.size() + ' tareas insertadas');
    
    try{
        insert miembrosCampana; 
        //System.debug(miembrosCampana.size() + ' miembrosCampana insertadas');
    }catch( Exception e){
        System.Debug('Error: '+e.getMessage());
    }
    
    update contacts;
    try {
        update cuentasupdate;
        update tasksToUpdate;
        update cuentas;
        List <Account> accountsToUpdate2 = new List<Account>();
        Id oId = (volanteCATID!=null) ? volanteCATID : '00511000002g1IdAAI';
        for(Task ttu : tareas){
            accountsToUpdate2.add(new Account(Id = ttu.WhatId, OwnerId = oId ));
        }
        update accountsToUpdate2;
        
        /*
            if(cuentas.size() > 0 && cuentaInsertada && volanteCATID!=null){
                System.debug('entra AQUI');
                System.debug('cuentas.get(0).Name = ' + cuentas.get(0).Name);
                System.debug('cuentas.get(0).Name = ' + cuentas.get(0).Id);
                System.debug('volanteCATID = ' + volanteCATID);
                List<Account> accAux = [ SELECT Id, Name FROM Account WHERE Id = :cuentas.get(0).Id ];
                String nameStr = (accAux.size() > 0)? accAux.get(0).Name : null;  
                List<Account> accountToDelete = [SELECT Id FROM Account 
                WHERE Name = : nameStr
                AND (Fuente__c = null OR Fuente__c = '')
                AND OwnerId != :volanteCATID
                ORDER BY CreatedDate DESC LIMIT 1];
                System.debug('accountToDelete.size = ' + accountToDelete.size());
                    if(accountToDelete.size() > 0){
                    delete accountToDelete;
                    System.debug('accountToDelete');
                    System.debug(accountToDelete.get(0).Id);
                }
            }
            */
        
    } catch (Exception e) {
        System.Debug('Falló: '+e.getMessage());
    }
    /*
    System.debug(tareas);
    System.debug(miembrosCampana);
    System.debug(contacts);
    System.debug(cuentas);
    */
    if(deleteLeads) {
        Lead[] leadstodelete = [SELECT id from Lead where id in :id_candidats];
            try{
                delete leadstodelete;
            }catch (Exception e) {
                System.Debug(e.getMessage()); 
            }
    }
            
    private void insertar(List <Task> ts){
        for(Task t : ts){
            if(t.WhatId==null && t.WhoId==null && idCC!=null){
                t.WhatId = idCC;
                System.debug('asignado idCC');
            } else System.debug('idCC2 = ' + idCC); 
                
        }
        Database.SaveResult[] srList = Database.insert(ts, false);
		// Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted tasks. Task ID: ' + sr.getId());
                tasksToUpdate.add(new Task(Id = sr.getId(), Status = 'Pendiente' ));
            }
            else {
                // Operation failed, so get all errors               
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                   
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Task fields that affected this error: ' + err.getFields());
            	}
            }
        }
    }// fin insertar()
}