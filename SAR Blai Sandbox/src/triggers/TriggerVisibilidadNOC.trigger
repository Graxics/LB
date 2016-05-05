/** 
* File Name:   TriggerVisibilidadNOC 
* Description: Añade la visibilidad de centros y zona comercial a la NOC
* Copyright:   Konozca 
* @author:     Hector Mañosas
* Modification Log 
* =============================================================== 
*Date           Author          Modification 
* 22/07/2014    HManosas
* 25/07/2014    HManosas        Desaparece visibilidad ZonaComercial        
* =============================================================== 
**/

trigger TriggerVisibilidadNOC on Centros_NOC__c (after delete, after insert, after update) {
    
    if(triggerhelper.todofalse())
    {
    
        set<Id> listaCentrosNocId = new set<Id>();
        list<NOC__c> listaCentros = new list<NOC__c>();
        set<Id> listaBorarCentros = new set<Id>();
        list<Centros_NOC__c> listaCentrosNOC = new list<Centros_NOC__c>();
        list<Centros_NOC__c> listaCentrosNOCTotal = new list<Centros_NOC__c>();
        list<NOC__c> listaActualizarNOC = new list<NOC__c>();
        List<Id> listaCentrosNOCBorradoId = new List<Id>();
        String ncentro;
        Boolean borrado, contiene;
        
        
        //Obtenemos el Id del RecordType "Centro"
        RecordType recordCentro = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'Centro' AND SObjectType = 'Account' LIMIT 1];
            
        //cogemos los Accounts tipo = "Centro" privados o mixtos
        List<Account> centros = [SELECT Id, IdNAV__c, Division__c, Zona_Comercial_del__c,Tipo_centro__c FROM Account WHERE (Tipo_centro__c = 'Mixto' or Tipo_centro__c = 'Privado') and RecordTypeId =: recordCentro.Id];
            
        if(Trigger.isInsert || Trigger.isUpdate)
        {
            for(Centros_NOC__c cn : trigger.new)
            {
                listaCentrosNocId.add(cn.NOC__c);
                listaCentrosNOC.add(cn);
            } 
            listaCentrosNOCTotal = [SELECT Id, Centro__c, Centro__r.IdNav__c, Centro__r.Tipo_centro__c, Division__c, Zona_Comercial_2__c, NOC__c FROM Centros_NOC__c WHERE NOC__c IN : listaCentrosNocId];
        }
        if(Trigger.isDelete)
        {
            for(Centros_NOC__c cn : trigger.old)
            {
                listaCentrosNocId.add(cn.NOC__c);            
                listaCentrosNOCBorradoId.add(cn.Id);
            }
            listaCentrosNOCTotal = [SELECT Id, Centro__c, Centro__r.IdNav__c, Division__c,Centro__r.Tipo_centro__c, Zona_Comercial_2__c, NOC__c FROM Centros_NOC__c WHERE NOC__c IN : listaCentrosNocId AND Id NOT IN : listaCentrosNOCBorradoId]; //añadido total
     
        }  
		System.debug('CENTROS INCLUIDOS: ');      
        for (Centros_NOC__c cnn : listaCentrosNOCTotal) {
            System.debug(cnn.Centro__r.idNav__c);
        }
                
            //Cogemos la NOC asociada a cada centro_NOC
            listaCentros = [SELECT Id, Visibilidad_Centros_1__c, Visibilidad_Centros_2__c, Visibilidad_Centros_3__c, Visibilidad_Centros_4__c, Visibilidad_Centros_5__c FROM NOC__c WHERE Id IN :listaCentrosNocId];
              
            //BORRAMOS LAS VISIBILIDADES Y COGEMOS CENTROS
            for(NOC__c n : listaCentros)
            {
                n.Visibilidad_Centros_1__c = null;
                n.Visibilidad_Centros_2__c = null;
                n.Visibilidad_Centros_3__c = null;
                n.Visibilidad_Centros_4__c = null;
                n.Visibilidad_Centros_5__c = null;          
                
                String lcentro;
                //Miramos cada centro NOC modificado/insertado          
                for(Centros_NOC__c cna : listaCentrosNOCTotal) //añadido Total
                {
                    if(cna.NOC__c == n.Id)
                    {
                        if(cna.Division__c != null)
                        {//Miramos si ha informado Division
                            if(cna.Centro__c == null && cna.Zona_Comercial_2__c == null && cna.Division__c.contains('Residencial') || cna.Division__c.contains('Adorea') || cna.Division__c.contains('SAR Domus') || cna.Division__c.contains('Domiciliaria') || cna.Division__c.contains('Teleasistencia') || cna.Division__c.contains('Formación')  || cna.Division__c.contains('CEX'))
                            {
                                //Rellenamos visibilidad con todos los centros Residenciales
                                for(Account ce : centros)
                                {
                                    if(ce.Division__c != null)                           
                                    {
                                        if(cna.Division__c.contains(ce.Division__c))
                                        {
                                            if (ce.Division__c == 'Residencial') {
                                                //if (ce.Tipo_centro__c == 'Mixto' || ce.Tipo_centro__c == 'Privado') {
                                                    if(lcentro == null) lcentro = ce.IdNAV__c + ';';
                                            		else lcentro = lcentro + ce.IdNAV__c + ';';  
                                                /*}*/
                                            }
                                            else {
                                                if(lcentro == null) lcentro = ce.IdNAV__c + ';';
                                            	else lcentro = lcentro + ce.IdNAV__c + ';'; 
                                            }
                                                                        
                                        }
                                    }                                                                                                       
                                }
                            }               
                        }
                            
                        //Miramos si ha informado la Zona Comercial
                        else if(cna.Zona_Comercial_2__c != null)
                        {
                            String lzona = cna.Zona_Comercial_2__c;
                            List<String> splitZona = new List<String>();
                            
                            splitZona = lzona.split(';');
                            
                            for(Account ce : centros)
                            {
                                for(String z : splitZona)
                                {
                                    if(ce.Zona_Comercial_del__c == z)
                                    {
                                        if(lcentro == null) lcentro = ce.IdNAV__c + ';';
                                        else lcentro = lcentro + ce.IdNAV__c + ';'; 
                                    }
                                }                           
                            }                       
                        }
                        //Miramos si ha informado el Centro
                        else if(cna.Centro__c != null)
                        {
                            for(Account ce : centros)
                            {
                                if(cna.Centro__c == ce.Id)
                                {
                                    lcentro = ce.IdNAV__c + ';';                                                            
                                }
                            }
                            
                        }
                    } 
                }            
                
                //Miramos si hay centros diferentes en las linias NO existentes (Division, ZComercial y centros)
               for(Centros_NOC__c cn : listaCentrosNOCTotal)
               {
                    if(cn.NOC__c == n.Id)
                    {               
                        for(Account ce : centros)
                        {
                            if(cn.Centro__c == ce.Id)
                            {
                                if(lcentro != null)
                                {
                                    if(!lcentro.contains(ce.IdNAV__c)) lcentro = lcentro + ce.IdNAV__c + ';';
                                }
                            }
                            else if(cn.Division__c != null)
                            {
                                if(ce.Division__c != null)
                                {
                                    if(cn.Division__c.contains(ce.Division__c)) 
                                    {
                                        if(ce.IdNAV__c != null && lcentro != null)
                                        {
                                            if(!lcentro.contains(ce.IdNAV__c)) lcentro = lcentro + ce.IdNAV__c + ';';
                                        }
                                                                   
                                    }
                                }
                            }
                            else if(cn.Zona_Comercial_2__c != null)
                            {
                                String lzona = cn.Zona_Comercial_2__c;
                                List<String> splitZona = new List<String>();                    
                                splitZona = lzona.split(';');
                                
                                for(String z : splitZona)
                                {
                                    if(ce.Zona_Comercial_del__c == z)
                                    {
                                        if(lcentro == null) lcentro = ce.IdNAV__c + ';';
                                        else if (!lcentro.contains(ce.IdNAV__c)) lcentro = lcentro + ce.IdNAV__c + ';'; 
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }       
                
                //RELLENAMOS LAS VISIBILDADES
                List<String> splitCentros = new List<String>();
                if(lcentro != null) splitCentros = lcentro.split(';');
                                
                //Miramos que la lista de centros no este vacia
                if(splitCentros.size() > 0)
                {
                    for(String l : splitCentros)
                    {
                        contiene = false;
                        
                        if(n.Visibilidad_Centros_1__c == null && n.Visibilidad_Centros_2__c == null && n.Visibilidad_Centros_3__c == null && n.Visibilidad_Centros_4__c == null && n.Visibilidad_Centros_5__c == null)
                        {
                            if(255 > l.length() + 1) 
                            {
                                n.Visibilidad_Centros_1__c = l + ';';
                                contiene = true;
                            }
                        }
                        else
                        {
                            if(n.Visibilidad_Centros_1__c != null || n.Visibilidad_Centros_2__c != null || n.Visibilidad_Centros_3__c != null || n.Visibilidad_Centros_4__c != null || n.Visibilidad_Centros_5__c != null)
                            {
                                if(n.Visibilidad_Centros_1__c.contains(l)) contiene = true;
                            }
                            else if (n.Visibilidad_Centros_2__c != null)
                            {
                                if(n.Visibilidad_Centros_1__c.contains(l) || n.Visibilidad_Centros_2__c.contains(l)) contiene = true;
                            }
                            else if(n.Visibilidad_Centros_3__c != null)
                            {
                                if(n.Visibilidad_Centros_1__c.contains(l) || n.Visibilidad_Centros_2__c.contains(l) || n.Visibilidad_Centros_3__c.contains(l)) contiene = true;
                            }
                            else if(n.Visibilidad_Centros_4__c != null)
                            {
                                if(n.Visibilidad_Centros_1__c.contains(l) || n.Visibilidad_Centros_2__c.contains(l) || n.Visibilidad_Centros_3__c.contains(l) || n.Visibilidad_Centros_4__c.contains(l)) contiene = true;
                            }
                            else if(n.Visibilidad_Centros_5__c != null)
                            {
                                if(n.Visibilidad_Centros_1__c.contains(l) || n.Visibilidad_Centros_2__c.contains(l) || n.Visibilidad_Centros_3__c.contains(l) || n.Visibilidad_Centros_4__c.contains(l) || n.Visibilidad_Centros_5__c.contains(l)) contiene = true;
                            }
                        }
                                
                        //Si no esta el centro lo añadimos
                        if(!contiene)
                        {
                            //si el centro cabe en visibilidad1
                            if(255 - n.Visibilidad_Centros_1__c.length() > l.length() + 1)
                            {
                                if(n.Visibilidad_Centros_1__c == null) n.Visibilidad_Centros_1__c = l + ';';
                                n.Visibilidad_Centros_1__c = n.Visibilidad_Centros_1__c + l + ';';
                            }
                            else if (n.Visibilidad_Centros_2__c == null || 255 - n.Visibilidad_Centros_2__c.length() > l.length() + 1)
                            {
                                if(n.Visibilidad_Centros_2__c == null) n.Visibilidad_Centros_2__c = l + ';';
                                else n.Visibilidad_Centros_2__c = n.Visibilidad_Centros_2__c + l + ';';
                            }
                            else if (n.Visibilidad_Centros_3__c == null || 255 - n.Visibilidad_Centros_3__c.length() > l.length() + 1)
                            {
                                if(n.Visibilidad_Centros_3__c == null) n.Visibilidad_Centros_3__c = l + ';';
                                else n.Visibilidad_Centros_3__c = n.Visibilidad_Centros_3__c + l + ';';
                            }
                            else if (n.Visibilidad_Centros_4__c == null || 255 - n.Visibilidad_Centros_4__c.length() > l.length() + 1)
                            {
                                if(n.Visibilidad_Centros_4__c == null) n.Visibilidad_Centros_4__c = l + ';';
                                else n.Visibilidad_Centros_4__c = n.Visibilidad_Centros_4__c + l + ';';
                            }
                            else if (n.Visibilidad_Centros_5__c == null || 255 - n.Visibilidad_Centros_5__c.length() > l.length() + 1)
                            {
                                if(n.Visibilidad_Centros_5__c == null) n.Visibilidad_Centros_5__c = l + ';';
                                else n.Visibilidad_Centros_5__c = n.Visibilidad_Centros_5__c + l + ';';
                            }
                        }
                    }
                }
                listaActualizarNOC.add(n);
            }    
        
        update listaActualizarNOC;
    }  

}