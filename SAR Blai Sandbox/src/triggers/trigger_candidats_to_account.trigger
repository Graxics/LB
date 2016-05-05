/** 
* File Name:   trigger_candidats_to_account 
* Description: Crea o actualiza informacion de las cuentas al introducir nuevos candidatos
* Copyright:   Konozca 
* @author:     Alexander Gimenez
* Modification Log 
* =============================================================== 
*Date           Author          Modification 
 15/12/2014     AGimenez
 17/12/2014     AGimenez        Añadidas modificaciones para cuando se introduzcan especialistas de tipo enfermero o Ayudante social
* =============================================================== 
**/ 

trigger trigger_candidats_to_account on Lead (before insert) {
    // Guardo en mapCuentas TODOS los id's i todas las cuentas  de servicios centrales
    List <Lead> nuevos = trigger.new;
    Set <String> emailsnuevos = new Set <String>();
    for(Lead l : nuevos) emailsnuevos.add(l.email);
    List<Account> Cuentas = [SELECT Division_SS__c,Fuente__c,RecordTypeID,Codigo_postal__c,Ciudad__c,Provincia__c,Email_secundario__c,Phone, cargo__pc, FirstName,LastName, Sexo__c, PersonMobilePhone, PersonEmail, VIP__c, Idioma_de_Contacto__pc, PersonHasOptedOutOfEmail, Responsable_contacto__c, No_tiene_telefono__c, No_encuestar__c, Ownerid,PersonDepartment, division__c, categoria_profesional__pc, especialidad_medica__pc,PersonAssistantName,Entidad_Centro_de_trabajo__c,No_quiero_Recibir__c,PersonDoNotCall,Calle__c FROM Account WHERE PersonEmail in: emailsnuevos];   
    Map<id,Account> mapCuentas = new Map<id,Account>();
    for(Account Ac: Cuentas){
      mapCuentas.put(Ac.id,Ac);
    }
    List <Account> cuentas_a_updatear = new List<Account> ();
    List <Account> cuentas_a_insertar = new List<Account> ();
    for(Lead C : trigger.new){       
        // Recogemos el typo de RecordType para comprovar si es de tipo servicios centrales
        // ya que si no lo es no queremos hacer nada
        // 012b0000000QFtb
        // Seleccionamos las cuentas que tienen el mismo email que el Lead
        // Si la cuenta no existe la creamos 
        if(cuentas.isEmpty()){
            // Creamos la cuenta 
                Account cuenta = new Account();
                cuenta.RecordTypeId='012b0000000QFtb';
                String  fuentes = c.Fuente__c;
                cuenta.Fuente__c= fuentes;
                //creamos valores
                cuenta.Division_SS__c=c.Division__c;
                cuenta.FirstName=c.FirstName;
                cuenta.Description=c.Description;
                cuenta.Fax=c.Fax;
                cuenta.PersonBirthdate = c.Fecha_de_nacimiento__c;
                cuenta.LastName=c.LastName;
                cuenta.Sexo__c=c.Sexo__c;
                cuenta.Especialidad_Medica__pc=c.Especialidad_Medica__c;
                if(c.Especialidad_Medica__c!=null && ( c.Categoria_Profesional__c=='Enfermero' || c.Categoria_Profesional__c == 'Trabajador Social')) c.Categoria_Profesional__c='';
                cuenta.Categoria_Profesional__pc=c.Categoria_Profesional__c;              
                cuenta.Cargo__pc=c.Cargo__c;
                cuenta.PersonDepartment=c.Departamento__c; 
                cuenta.Entidad_Centro_de_trabajo__c=c.Company;
                c.Status = 'Convertido';
                cuenta.PersonAssistantName=c.Secretaria__c;
                cuenta.Calle__c=c.Calle__c;
                cuenta.Codigo_postal__c=c.Codigo_Postal__c;
                cuenta.Ciudad__c=c.Ciudad__c;
                cuenta.Provincia__c=c.Provincia__c;
                cuenta.PersonEmail=c.Email;
                cuenta.Email_secundario__c=c.Correo_electronico_secundaria__c;
                cuenta.Phone=c.Phone;
                cuenta.PersonMobilePhone=c.MobilePhone;
                cuenta.PersonDoNotCall = c.DoNotCall;
                cuenta.PersonHasOptedOutOfEmail=c.HasOptedOutOfEmail;
                cuenta.No_tiene_telefono__c=c.No_tiene_telefono__c;
                cuenta.No_encuestar_participar_en_estudios__pc=c.No_encuestar__c;
                cuenta.No_quiero_Recibir__c=c.No_quiero_Recibir__c;
                cuenta.Responsable_contacto__c=c.Responsable_contacto__c;
                cuenta.VIP__c=c.VIP__c;             
                cuentas_a_insertar.add(cuenta);
        }
        // Si existen cuentas para el Lead
        else{
            for(Account cuenta: Cuentas){
                //Solo modificamos si el email de la persona es el introducido
                if(cuenta.PersonEmail == c.Email){
                    
            // solo modificamos si el registro es del tipo servicios centrales
                    if(cuenta.RecordTypeId=='012b0000000QFtb'){
                        System.debug(cuenta.FirstName);
                        // añadimos las fuentes nuevas
                        if(cuenta.VIP__c && cuenta.Fuente__c== null) cuenta.Fuente__c=c.Fuente__c;
                        else if(cuenta.Fuente__c != null && c.Fuente__c!=null) {
                            String [] stringfuentesLead = c.Fuente__c.Split(';',14);
                            String [] stringfuentesCuenta = cuenta.Fuente__c.Split(';',14);
                            List <String> fuentesLead = new List<String> (stringfuentesLead);
                            Set <String> setfuentesLead = new Set<String> (fuentesLead);
                            List <String> fuentesCuenta = new List<String> (stringfuentesCuenta);
                            Set <String> setfuentesCuenta = new Set <String> (fuentesCuenta);
                            String fuenteFinal = '';
                            for(String sf : stringfuentesLead){
                                if(!setfuentesCuenta.contains(sf)) fuenteFinal+=(sf+';');                           
                            }
                             if(! cuenta.VIP__c)cuenta.Fuente__c += ';' + fuentefinal;
                        }
                        else if(cuenta.Fuente__c==null)cuenta.Fuente__c=c.Fuente__c;
                        //Añadimos las nuevas divisiones
                        if(cuenta.VIP__c && cuenta.Division_SS__c== null) cuenta.Division_SS__c=c.Division__c;
                        else if(cuenta.Division_SS__c != null && c.Division__c!=null) {
                            String [] stringdivisionLead = c.Division__c.Split(';',14);
                            String [] stringdivisionCuenta = cuenta.Division_SS__c.Split(';',14);
                            List <String> divisionLead = new List<String> (stringdivisionLead);
                            Set <String> setdivisionLead = new Set<String> (divisionLead);
                            List <String> divisionCuenta = new List<String> (stringdivisionCuenta);
                            Set <String> setdivisionCuenta = new Set <String> (divisionCuenta);
                            String divisionFinal = '';
                            for(String sf : stringdivisionLead){
                                if(!setdivisionCuenta.contains(sf)) divisionFinal+=(sf+';');                           
                            }
                            if(! cuenta.VIP__c)cuenta.Division_SS__c += ';' + divisionfinal;
                        }
                        else if (cuenta.Division_SS__c==null) cuenta.Division_SS__c=c.Division__c;
                        // actualizamos los valores 
                        if(c.FirstName!=null){
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.FirstName==null))  cuenta.FirstName=c.FirstName;
                            }                   
                        if(c.LastName!=null){
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.LastName==null)) cuenta.LastName=c.LastName;
                        } 
                        if(c.Sexo__c!=null) {
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Sexo__c==null)) cuenta.Sexo__c=c.Sexo__c;                        
                        }
                        Lead copia = c.clone(true,true);
                        String catego = copia.Categoria_Profesional__c;
                        String Especi = copia.Especialidad_Medica__c;
                        // comprovamos y si no se cumple la regla de validacion ponemos la categoria a nulo.
                        if(c.Especialidad_Medica__c!=null && ( c.Categoria_Profesional__c=='Enfermero' || c.Categoria_Profesional__c == 'Trabajador Social')) {
                            catego='';
                            especi ='';
                        }
                        else if(cuenta.Especialidad_Medica__pc!=null && (c.Categoria_Profesional__c=='Enfermero' || c.Categoria_Profesional__c == 'Trabajador Social')) {
                            catego='';
                            especi ='';
                        }
                        else if(cuenta.Especialidad_Medica__pc==null && c.Especialidad_Medica__c!=null && (cuenta.Categoria_Profesional__pc=='Enfermero' || cuenta.Categoria_Profesional__pc=='Trabajador Social' || c.Categoria_Profesional__c=='Trabajador Social' || c.Categoria_Profesional__c=='Enfermero')) {
                            catego='';
                            especi ='';
                        }
                        if(especi!=null){
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Especialidad_Medica__pc==null)) cuenta.Especialidad_Medica__pc=especi;
                        } 
                        if(catego!=null){
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Categoria_Profesional__pc==null)) cuenta.Categoria_Profesional__pc=catego;
                        } 
                        if(c.Cargo__c!=null){
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Cargo__pc==null)) cuenta.Cargo__pc=c.Cargo__c;
                        } 
                        if(c.Departamento__c!=null){
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.PersonDepartment==null)) cuenta.PersonDepartment=c.Departamento__c;  
                        } 
                        if(c.Company!=null){
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Entidad_Centro_de_trabajo__c==null))cuenta.Entidad_Centro_de_trabajo__c=c.Company;
                        } 
                        if(c.Secretaria__c!=null) {
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.PersonAssistantName==null)) cuenta.PersonAssistantName=c.Secretaria__c;
                        } 
                        if(c.Calle__c!=null) {
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Calle__c==null)) cuenta.Calle__c=c.calle__c;
                        } 
                        if(c.Codigo_Postal__c!=null) {
                        if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Codigo_postal__c==null)) cuenta.Codigo_postal__c=c.Codigo_Postal__c; 
                        } 
                        if(c.Ciudad__c!=null) {
                        if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Ciudad__c==null)) cuenta.Ciudad__c=c.Ciudad__c;  
                        } 
                        if(c.Provincia__c!=null) {
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Provincia__c==null)) cuenta.Provincia__c=c.Provincia__c;
                        } 
                        if(c.email!=null) {
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.PersonEmail==null)) cuenta.PersonEmail=c.Email;  
                        }
                        if(c.Fax!=null) {
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Fax==null)) cuenta.Fax=c.Fax;  
                        }
                        if(c.Description!=null) {
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Description==null)) cuenta.Description=c.Description;  
                        }
                        if(c.Correo_electronico_secundaria__c!= null) {
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Email_secundario__c==null)) cuenta.Email_secundario__c=c.Correo_electronico_secundaria__c; 
                        } cuenta.Email_secundario__c=c.Correo_electronico_secundaria__c;
                        if(c.Phone!=null) {
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Phone==null))  cuenta.Phone=c.Phone;
                        } 
                        if(c.MobilePhone!=null){
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.PersonMobilePhone==null)) cuenta.PersonMobilePhone=c.MobilePhone;
                        } 
                        if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Idioma_de_Contacto__pc==null)){
                            string idioma = c.Idioma_de_contacto__c;
                            cuenta.Idioma_de_Contacto__pc=idioma; 
                        } 
                        if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Idioma_de_Contacto__pc==null)) cuenta.PersonDoNotCall = c.DoNotCall;
                        if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Idioma_de_Contacto__pc==null)) cuenta.PersonHasOptedOutOfEmail=c.HasOptedOutOfEmail;   
                        if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Idioma_de_Contacto__pc==null)) cuenta.No_tiene_telefono__c=c.No_tiene_telefono__c; 
                        if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Idioma_de_Contacto__pc==null)) cuenta.No_encuestar_participar_en_estudios__pc=c.No_encuestar__c;  
                        if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Idioma_de_Contacto__pc==null)) cuenta.No_quiero_Recibir__c=c.No_quiero_Recibir__c;                    
                        if(c.Responsable_contacto__c!=null){
                            if(!cuenta.VIP__c || (cuenta.VIP__c && cuenta.Responsable_contacto__c==null)) cuenta.Responsable_contacto__c=c.Responsable_contacto__c;  
                        }
                        if(!cuenta.VIP__c && c.VIP__c) cuenta.VIP__c = true;
                        c.Status = 'Convertido';
                        cuentas_a_updatear.add(cuenta);             
                    }
                }
            }
        }
    }    
    insert cuentas_a_insertar;
    update cuentas_a_updatear;
    
}