public with sharing class hojaResumen {
    public String htmlText {get;set;}
    public Oportunidad_platform__c op {get;set;}
    public Relacion_entre_contactos__c usuarioPrincipal {get;set;}
    public Relacion_entre_contactos__c pagador {get;set;}
    public List<Relacion_entre_contactos__c> usuarioColgante = new List<Relacion_entre_contactos__c>();
    public Account ac_usuarioPrincipal {get;set;}
    public Account ac_pagador {get;set;}
    public Account ac_usuarioColgante {get;set;}
    public EmailTemplate plantilla {get;set;}
   
    public hojaResumen(ApexPages.StandardController controller){
     
        //seleccionamos la oportunidad
        try{
        op = [SELECT id, RecordType.Name, Owner.Name, Empresa_Recomendadora__r.Name, IBAN__c, Fecha_solicitud__c, Tarifa__r.RecordType.Name, Precio_servicio__c, Servicio__r.RecordType.Name, Servicio__r.Name, Servicio__r.Tipo_de_dispositivos__c, NOC__r.Name, NOC_12_Convenios__r.Name, Persona_de_contacto__r.Name, Compania_telef__c, Descripcion__c FROM Oportunidad_platform__c WHERE id = :controller.getId()];
        }catch (Exception e) { throw new myException('Error imposible: No se ha encontrado oportunidad');      }   
        //Solo se genera la hoja resumen para oportunidades TAD, TAM o TA Dúo. El nombre de la hoja resumen està formado por 'Hoja resumen ' + tipo de registro la oportunidad
        String hojaResumen;
        if (ApexPages.currentPage().getParameters().get('POAS') == 'true') {
            hojaResumen='Hoja resumen POAS';
            plantilla = [SELECT Id, Name, HtmlValue, Body FROM EmailTemplate WHERE Name = :hojaResumen];
            htmlText = plantilla.HtmlValue;
        }else{
            // Si la oportunidad es tipo TA Dúo le asignamos la misma hoja resumen que para oportunidades tipo TAM
            if(op.RecordType.Name == 'Oportunidad TA Dúo') hojaResumen = 'Hoja resumen Oportunidad TAM';
            // Sino, estará formado por 'Hoja resumen ' + tipo oportunidad. Por ejemplo si el tipo de registro de la oportunidad es 'Oportunidad TAD' la hoja resumen sera 'Hoja resumen Oportunidad TAD'
            else hojaResumen = 'Hoja resumen ' + op.RecordType.Name;
            //Seleccionamos la plantilla corresponidente
            plantilla = [SELECT Id, Name, HtmlValue, Body FROM EmailTemplate WHERE Name = :hojaResumen];
            htmlText = plantilla.HtmlValue;
         }
         
         
            //seleccionamos las relaciones entre contactos correspondientes a la oportunidad de tipo usuario principal, pagador, y beneficiario con o sin colgante . Las guardamos por separado.
            //Si no existe alguna relacion de estas tres se puede generar igualmente la hoja resumen, lo que se generará con todos los campos corrspondientes vacios
            try{
            usuarioPrincipal = [SELECT Beneficiario__c FROM Relacion_entre_contactos__c WHERE Oportunidad__c = :op.id AND Usuario_principal__c=true];
            }catch (Exception e){
                htmlText = htmlText.replace('{!Usuario_principal.provincia}', '');
                htmlText = htmlText.replace('{!Beneficiario.Nombre}', '');
                htmlText = htmlText.replace('{!Beneficiario.Apellidos}', '');
                htmlText = htmlText.replace('{!Beneficiario.DNI}', '');
                htmlText = htmlText.replace('{!Beneficiario.Domicilio}', '');
                htmlText = htmlText.replace('{!Beneficiario.Telefono}', '');
                htmlText = htmlText.replace('{!Beneficiario.Nacimineto}', '');
                htmlText = htmlText.replace('{!Beneficiario.Email}', '');
            }
            try{
            pagador = [SELECT Beneficiario__c FROM Relacion_entre_contactos__c WHERE Oportunidad__c = :op.id AND Pagador__c=true];
            }catch (Exception e){
                htmlText = htmlText.replace('{!Pagador.nombre}', '');
                htmlText = htmlText.replace('{!Pagador.Apellidos}', '');
                htmlText = htmlText.replace('{!Pagador.DNI}', '');
                htmlText = htmlText.replace('{!Pagador.Domicilio}', '');
                htmlText = htmlText.replace('{!Pagador.Telefono}', '');
            }
            //la información del usuario con o sin colgante solo es necesaria si la oportunidad es de tipo TAD
            if(op.RecordType.Name == 'Oportunidad TAD'){
                usuarioColgante = [SELECT Beneficiario__c FROM Relacion_entre_contactos__c WHERE Oportunidad__c = :op.id AND (Beneficiario_con_colgante__c=true OR Beneficiario_sin_colgante__c=true)];
                if(usuarioColgante.size() == 0){ 
                    htmlText = htmlText.replace('{!Beneficiario2.Nombre}', '');
                    htmlText = htmlText.replace('{!Beneficiario2.Apellidos}', '');
                    htmlText = htmlText.replace('{!Beneficiario2.DNI}', '');
                    htmlText = htmlText.replace('{!Beneficiario2.Domicilio}', '');
                    htmlText = htmlText.replace('{!Beneficiario2.Telefono}', '');
                    htmlText = htmlText.replace('{!Beneficiario2.Nacimineto}', '');
                }
            }
            
            //substituimos la información correspondiente a la oportunidad
            if(op.Empresa_Recomendadora__r.Name != null) htmlText = htmlText.replace('{!Empresa_Recomendadora.Name}', op.Empresa_Recomendadora__r.Name);
            else htmlText = htmlText.replace('{!Empresa_Recomendadora.Name}', '');
            if(op.Fecha_solicitud__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Fecha_solicitud__c}', String.valueOf(op.Fecha_solicitud__c));
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Fecha_solicitud__c}', '');
            if(op.Precio_servicio__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Servicio__c}', String.valueOf(op.Precio_servicio__c));
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Precio_Servicio__c}', '');
            if(op.Servicio__r.Name != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Servicio.Name}', op.Servicio__r.Name);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Servicio.Name}', '');
            if(op.NOC__c != null) htmlText = htmlText.replace('{!NOC.Nombre}', op.NOC__r.Name);
            else if (op.NOC_12_Convenios__c != null) htmlText = htmlText.replace('{!NOC.Nombre}', op.NOC_12_Convenios__r.Name);
            else htmlText = htmlText.replace('{!NOC.Nombre}', '');
            if(op.IBAN__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.IBAN__c}', op.IBAN__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.IBAN__c}', '');
            if(op.Servicio__r.Tipo_de_dispositivos__c != null) htmlText = htmlText.replace('{!Oportunidad_platform__c.Servicio.Tipo_de_dispositivos__c}', op.Servicio__r.Tipo_de_dispositivos__c);
            else htmlText = htmlText.replace('{!Oportunidad_platform__c.Servicio.Tipo_de_dispositivos__c}', '');
            
           //substituimos informacion del pagador, si existe
           if(pagador != null){
                ac_pagador = [SELECT FirstName, LastName, Phone, CIF_NIF__c, Calle__c, Ciudad__c, Provincia__c, Codigo_Postal__c FROM Account WHERE Id =: pagador.Beneficiario__c];
                if(ac_pagador.FirstName != null) htmlText = htmlText.replace('{!Pagador.nombre}', ac_pagador.FirstName);
                else htmlText = htmlText.replace('{!Pagador.nombre}', '');
                if(ac_pagador.LastName != null) htmlText = htmlText.replace('{!Pagador.Apellidos}', ac_pagador.LastName);
                else htmlText = htmlText.replace('{!Pagador.Apellidos}', '');
                if(ac_pagador.CIF_NIF__c != null) htmlText = htmlText.replace('{!Pagador.DNI}', ac_pagador.CIF_NIF__c);
                else htmlText = htmlText.replace('{!Pagador.DNI}', '');
                String domicili = '';
                if(ac_pagador.Calle__c != null) domicili = ac_pagador.Calle__c + ' ';
                if(ac_pagador.Ciudad__c !=null) domicili = domicili + ac_pagador.Ciudad__c + ' ';
                if(ac_pagador.Codigo_postal__c != null) domicili = domicili + ac_pagador.Codigo_postal__c + ' ';
                if(ac_pagador.Provincia__c != null) domicili = domicili + ac_pagador.Provincia__c;
                htmlText = htmlText.replace('{!Pagador.Domicilio}', domicili);
                if(ac_pagador.Phone != null) htmlText = htmlText.replace('{!Pagador.Telefono}', ac_pagador.Phone);
                else htmlText = htmlText.replace('{!Pagador.Telefono}', '');
             }
            
            //substituimos informacion beneficiario 1 (usuario principal), si existe
            if(usuarioPrincipal != null){
                ac_usuarioPrincipal = [SELECT FirstName, LastName, Phone, PersonBirthdate, CIF_NIF__c, Ciudad__c, Calle__c, Provincia__c, Codigo_Postal__c, PersonEmail FROM Account WHERE Id =: usuarioPrincipal.Beneficiario__c];
                if(ac_usuarioPrincipal.Provincia__c != null ) htmlText = htmlText.replace('{!Usuario_principal.provincia}', ac_usuarioPrincipal.Provincia__c);
                else htmlText = htmlText.replace('{!Usuario_principal.provincia}', '');
                if(ac_usuarioPrincipal.FirstName != null ) htmlText = htmlText.replace('{!Beneficiario.Nombre}', ac_usuarioPrincipal.FirstName);
                else htmlText = htmlText.replace('{!Beneficiario.Nombre}', '');
                if(ac_usuarioPrincipal.LastName != null ) htmlText = htmlText.replace('{!Beneficiario.Apellidos}', ac_usuarioPrincipal.LastName);
                else htmlText = htmlText.replace('{!Beneficiario.Apellidos}', '');
                if(ac_usuarioPrincipal.CIF_NIF__c != null ) htmlText = htmlText.replace('{!Beneficiario.DNI}', ac_usuarioPrincipal.CIF_NIF__c);
                else htmlText = htmlText.replace('{!Beneficiario.DNI}', '');
                String domicili_benef = '';
                if(ac_usuarioPrincipal.Calle__c != null) domicili_benef = ac_usuarioPrincipal.Calle__c;
                if(ac_usuarioPrincipal.Ciudad__c !=null) domicili_benef = domicili_benef + ', ' + ac_usuarioPrincipal.Ciudad__c;
                if(ac_usuarioPrincipal.Codigo_postal__c != null) domicili_benef = domicili_benef + ', ' + ac_usuarioPrincipal.Codigo_postal__c;
                if(ac_usuarioPrincipal.Provincia__c != null) domicili_benef = domicili_benef + ', ' + ac_usuarioPrincipal.Provincia__c;
                htmlText = htmlText.replace('{!Beneficiario.Domicilio}', domicili_benef);
                if(ac_usuarioPrincipal.Phone != null ) htmlText = htmlText.replace('{!Beneficiario.Telefono}', ac_usuarioPrincipal.Phone);
                else htmlText = htmlText.replace('{!Beneficiario.Telefono}', '');
                if(ac_usuarioPrincipal.PersonBirthdate != null ) htmlText = htmlText.replace('{!Beneficiario.Nacimineto}', String.valueOf(ac_usuarioPrincipal.PersonBirthdate));
                else htmlText = htmlText.replace('{!Beneficiario.Nacimineto}', '');
                if(ac_usuarioPrincipal.PersonEmail != null) htmlText = htmlText.replace('{!Beneficiario.Email}', ac_usuarioPrincipal.PersonEmail);
                else htmlText = htmlText.replace('{!Beneficiario.Email}', '');
             }
             
            // La información del beneficiario 2 (usuario con o sin colgante) solo nos interesa si la oportunidad es de tipo TAD
            if(op.RecordType.Name == 'Oportunidad TAD'){
                 //substituimos la informacion del beneficiario 2, si existe. En este caso, puede haber más de un beneficiario de este tipo. Solamente, seleccionaremos uno (el primero de la lista).
                 if(usuarioColgante.size() != 0){
                    ac_usuarioColgante = [SELECT FirstName, LastName, Phone, PersonBirthdate, CIF_NIF__c, Calle__c, Ciudad__c, Provincia__c, Codigo_Postal__c FROM Account WHERE Id =: usuarioColgante.get(0).Beneficiario__c];
                    if(ac_usuarioColgante.FirstName != null ) htmlText = htmlText.replace('{!Beneficiario2.Nombre}', ac_usuarioColgante.FirstName);
                    else htmlText = htmlText.replace('{!Beneficiario2.Nombre}', '');
                    if(ac_usuarioColgante.LastName != null ) htmlText = htmlText.replace('{!Beneficiario2.Apellidos}', ac_usuarioColgante.LastName);
                    else htmlText = htmlText.replace('{!Beneficiario2.Apellidos}', '');
                    if(ac_usuarioColgante.CIF_NIF__c != null ) htmlText = htmlText.replace('{!Beneficiario2.DNI}', ac_usuarioColgante.CIF_NIF__c);
                    else htmlText = htmlText.replace('{!Beneficiario2.DNI}', '');
                    String domicili_benef2 = '';
                    if(ac_usuarioColgante.Calle__c != null) domicili_benef2 = ac_usuarioColgante.Calle__c + ' ';
                    if(ac_usuarioColgante.Ciudad__c !=null) domicili_benef2 = domicili_benef2 + ac_usuarioColgante.Ciudad__c + ' ';
                    if(ac_usuarioColgante.Codigo_postal__c != null) domicili_benef2 = domicili_benef2 + ac_usuarioColgante.Codigo_postal__c + ' ';
                    if(ac_usuarioColgante.Provincia__c != null) domicili_benef2 = domicili_benef2 + ac_usuarioColgante.Provincia__c + ' ';
                    htmlText = htmlText.replace('{!Beneficiario2.Domicilio}', domicili_benef2);
                    if(ac_usuarioColgante.Phone != null ) htmlText = htmlText.replace('{!Beneficiario2.Telefono}', ac_usuarioColgante.Phone);
                    else htmlText = htmlText.replace('{!Beneficiario2.Telefono}', '');
                    if(ac_usuarioColgante.PersonBirthdate != null ) htmlText = htmlText.replace('{!Beneficiario2.Nacimineto}', String.valueOf(ac_usuarioColgante.PersonBirthdate));
                    else htmlText = htmlText.replace('{!Beneficiario2.Nacimineto}', '');
                    
                    
                }
             }
             
             //La persona de contacto solo es necesaria para oportunidades de tipo TAM o TA Dúo
             if(op.RecordType.Name == 'Oportunidad TAM' || op.RecordType.Name == 'Oportunidad TA Dúo' ) htmlText = htmlText.replace('{!Oportunidad_platform__c.Persona_de_Contacto__c}', op.Persona_de_Contacto__r.Name);
             if(op.Compania_telef__c != null ) htmlText = htmlText.replace('{!Oportunidad_platform__c.Compania_telef__c}', op.Compania_telef__c);
             else htmlText = htmlText.replace('{!Oportunidad_platform__c.Compania_telef__c}', '');
             if(op.Descripcion__c != null ) htmlText = htmlText.replace('{!Oportunidad_platform__c.Descripcion__c}', op.Descripcion__c);
                                                               
             else htmlText = htmlText.replace('{!Oportunidad_platform__c.Descripcion__c}', '');
             //Substituimo el campo de propetario de la cuenta
             htmlText = htmlText.replace('{!Oportunidad_platform__c.Propietario}', op.Owner.Name);
    }
}