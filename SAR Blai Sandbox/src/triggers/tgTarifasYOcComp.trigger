/** 
* File Name:   tgTarifasYOcComp 
* Description: Crea registros en tarifas segun los campos introducidos
* Copyright:   Konozca 
* @author:     Sergi Aguilar
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 
* =============================================================== 
**/ 
trigger tgTarifasYOcComp on Account (after insert, after update) {
    
    if(triggerhelper.todofalse()) {
        //Lista de tarifas a anadir
        List<Tarifa__c> addTar = new List<Tarifa__c>();
        //Lista de antiguas tarifas
        List<Tarifa__c> antTar = [Select Id, Competidor__c From Tarifa__c];
        //accounts a hacer update
        Set<Account> laUpd = new Set<Account>(); 
        
        //Lista de antiguas tarifas
        List<Tarifa__c> novigentesTar = new List<Tarifa__c>();
        
        //cogemos los servicios
        List<Servicio__c> sc = [Select Id, Name, Tipo_Ocupacion__c, Grado_Dependencia__c From Servicio__c Where Tipo_Servicio__c = 'Residencial'];
        //guardamos los tipos de ocupacion a mirar
        List<String> TOcu = new String[9];
        TOcu[0] = 'HD';
        TOcu[1] = 'HD';
        TOcu[2] = 'HD';
        TOcu[3] = 'HI';
        TOcu[4] = 'HI';
        TOcu[5] = 'HI';
        TOcu[6] = 'Suite';
        TOcu[7] = 'Suite';
        TOcu[8] = 'Suite';
        
        //guardamos los grados de dependencia a mirar
        List<String> TGra = new String[9];
        TGra[0] = 'Grado 1';
        TGra[1] = 'Grado 2';
        TGra[2] = 'Grado 3';
        TGra[3] = 'Grado 1';
        TGra[4] = 'Grado 2';
        TGra[5] = 'Grado 3';
        TGra[6] = 'Grado 1';
        TGra[7] = 'Grado 2';
        TGra[8] = 'Grado 3';
        
        for(Account a : trigger.new) {
            
            if(a.RecordTypeId == '012b0000000QC89AAG') {
    
                //comprobamos si se han escrito campos
                if( a.Tipo_analisis__c <> Null && a.Ano_analisis__c <> Null) {
                    
                    for(integer j = 0; j < antTar.Size(); ++j) {
                        if(antTar[j].Competidor__c == a.Id) {
                            novigentesTar.add( new Tarifa__c(Id = antTar[j].Id,
                                                             Tarifa_Vigente__c = false) );
                        }
                    }
                    
                    List<double> prs = new List<double>();
                    prs.add(a.Precio_HD_Grado_1__c);
                    prs.add(a.Precio_HD_Grado_2__c);
                    prs.add(a.Precio_HD_Grado_3__c);
                    prs.add(a.Precio_HI_Grado_1__c);
                    prs.add(a.Precio_HI_Grado_2__c);
                    prs.add(a.Precio_HI_Grado_3__c);
                    prs.add(a.Precio_Suite_Grado_1__c);
                    prs.add(a.Precio_Suite_Grado_2__c);
                    prs.add(a.Precio_Suite_Grado_3__c);
                    
                    //por cada precio anadido
                    for(integer i = 0; i < prs.size(); ++i) {
                        if (prs[i] <> Null) {
                            Servicio__c s = new Servicio__c();
                            Boolean enc = false;
                            for(integer k = 0; k < sc.size() && !enc; ++k) {
                                if(sc[k].Grado_Dependencia__c == TGra[i] && sc[k].Tipo_Ocupacion__c == TOcu[i]) {
                                    enc = true;
                                    s = sc[k];
                                }
                            }
                            if(enc) {
                                Tarifa__c t = new Tarifa__c();                  
                                t.Name = a.Name + '/' + s.Name;
                                t.RecordTypeId = '012b0000000QBcMAAW';
                                t.Servicio__c = s.Id;
                                t.Tarifa_Vigente__c = true;
                                t.ano_analisis__c = a.Ano_analisis__c;
                                t.Tipo_Tarifa__c = a.Tipo_analisis__c;
                                t.Competidor__c = a.Id;
                                t.Fecha_Captaci_n__c = Date.today();
                                t.Precio__c = prs[i];
                                addTar.add(t);
                            }
                            else a.addError('Servicio no encontrado');
                        }
                        else {
                        
                        }
                    }
                   
                    //los ponemos otra vez a null
                    laUpd.add(new Account ( Id=a.Id,
                                            Tipo_analisis__c = Null,
                                            Ano_analisis__c = Null));
                }
            }
        }
        insert addTar;
        update novigentesTar;
        update new List<Account>(laUpd);
    }
}