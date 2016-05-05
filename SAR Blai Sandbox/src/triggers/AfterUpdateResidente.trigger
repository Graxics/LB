/** 
* File Name:   AfterUpdateResidente
* Description:Trigger que se ejecutará siempre que se modifique una cuenta. En este trigger se generaran las tareas de baja y condolencias
cuando se actualize el campo baja i/o exitus.
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version    Date        Author           Modification 
* 01        09/02/2015  Xavier Garcia
* =============================================================== 
**/ 
trigger AfterUpdateResidente on Account (after update) {
    if(triggerHelper.todofalse()) {
    Date avui = Date.today();
    //Declaramos las listas de Ids i tareas
    List<id> IDresidentesBaja = new List<id>();
    List<Task> tasksBaja = new List<Task>();
    List<id> IDresidentesExitus = new List<id>();
    List<Task> tasksExitus = new List<Task>();
    for (Account ac:Trigger.new) {
        //Si la cuenta es un residente y baja es true y exitus es falso,
        //añadimos el residente a la lista de id de bajas
        if (ac.Baja__c == true && ac.Exitus__c == false && ac.Residente__c == true) {
            Account oldAccount = Trigger.oldMap.get(ac.id);
            if (oldAccount.Baja__c != ac.Baja__c) {IDresidentesBaja.add(ac.id);}
        }
        
        //Si la cuenta es un residente y baja es true y exitus es true,
        //añadimos el residente a la lista de id de exitus
        if (ac.Baja__c == true && ac.Exitus__c == true && ac.Residente__c == true) {
            Account oldAccount = Trigger.oldMap.get(ac.id);
            if (oldAccount.Baja__c != ac.Baja__c && oldAccount.Exitus__c != ac.Exitus__c) {IDresidentesExitus.add(ac.id);}
        }
    }
    
    /*GENERAR TAREA BAJA*/
    //Si hay residentes que se han dado de baja, generaremos la Tarea.
    if (IDresidentesBaja.size() > 0) {
        Recordtype RtypeTareaCliente = [Select Id, Name From RecordType Where Name = 'Tarea Cliente' LIMIT 1];
        //Tenemos que tratar la lista de ID de residentes, para generar una lista de oportunidades
        //con la oportunidad del ultimo ingreso del residente, ya que sino
        //se podrian generar tareas para mas de una oportunidad del mismo residente
        Map<id,Oportunidad_platform__c> ResidentiOpps = new Map<id,Oportunidad_platform__c>();
        //Set<id> opsBaja = new Set<id> ();
        Map<id,id> IdOppsBaja = new Map<id,id>();
        for (Oportunidad_platform__c bajaOpp: [SELECT Residente__c,id,Fecha_real_de_ingreso__c from Oportunidad_platform__c where Residente__c IN: IDresidentesBaja]) {
            if (ResidentiOpps.get(bajaOpp.Residente__c) != null) {		Oportunidad_platform__c existent = ResidentiOpps.get(bajaOpp.Residente__c);
                if (bajaOpp.Fecha_real_de_ingreso__c > existent.Fecha_real_de_ingreso__c ) {
                    ResidentiOpps.put(bajaOpp.Residente__c, bajaOpp);	IdOppsBaja.put(bajaOpp.Residente__c,bajaOpp.Id);     
                }
            }
            else {	ResidentiOpps.put(bajaOpp.Residente__c, bajaOpp);	IdOppsBaja.put(bajaOpp.Residente__c,bajaOpp.Id); }
        }
        
        //Recorremos todas las oportunidades asociadas a los residentes que se han dado de baja
        //ya que la opp es la unica manera de acceder al centro y a su director
        for (Oportunidad_platform__c baja: [SELECT Residente__c,Residente__r.name,Centro2__r.name,Centro2__r.Director_del_centro__c,Centro2__r.ATC_centro__c,Centro2__r.Comunicacion_con_Familias__c from Oportunidad_platform__c where ID IN: IdOppsBaja.values() and Centro2__r.Comunicacion_con_Familias__c = true and Centro2__r.Division__c = 'Residencial']) {
                    //Obtenim el id del Director del centre
                    Id IdDirector= baja.Centro2__r.Director_del_centro__c;		id IdAtc = baja.Centro2__r.ATC_centro__c;
                    //Creem la tarea amb els camps necessaris
                    //associada al director del centre i amb what_id = resident.
                    Task tbaja = new Task();
                    tbaja.Description = 'AVISO: El residente '+baja.Residente__r.name+' ha causado baja.Prepara la entrevista de salida. En caso de alta temporal, recuerda preparar una carpeta con la carta de fidelización y el material promocional.Consulta el manual de comunicación con familias ”Guía de actuación ante el alta privada” para más información. Recuerda al encargado/a de SSHH que deberá gestionar las pertenencias del residente.';
                    tbaja.Status = 'Pendiente';			tbaja.ActivityDate = avui.addDays(3);
                    tbaja.Subject = 'AVISO: El residente '+baja.Residente__r.name+' ha causado baja.';
                    tbaja.OwnerId = IdAtc;				tbaja.Priority = 'Normal';
                    tbaja.WhatId = baja.Residente__c;	tbaja.recordtypeid = RtypeTareaCliente.id;
                    tbaja.IsFromTrigger__c = true;
                    //Afegim la tarea a la llista de tareas per posteriorment, insertar-les a la BD
                    tasksBaja.add(tbaja);
                    System.debug('Residente baja: :'+baja.Residente__c);
                    System.debug('Centro baja: :'+baja.Centro2__r.name);
                    System.debug('Director baja: :'+baja.Centro2__r.Director_del_centro__c);
        }
        insert tasksBaja;
    }
    
    
    /*GENERAR TAREA CONDOLENCIAS*/
    //Si hay residentes que han pasado a estado exitus, generaremos la Tarea.
    if (IDresidentesExitus.size() > 0) {
         Recordtype RtypeTareaCliente = [Select Id, Name From RecordType Where Name = 'Tarea Cliente' LIMIT 1];
        System.debug('EXITUS SIZE: '+IDresidentesExitus.size());
        //Tenemos que tratar la lista de ID de residentes, para generar una lista de oportunidades
        //con la oportunidad del ultimo ingreso del residente, ya que sino
        //se podrian generar tareas para mas de una oportunidad del mismo residente
        Map<id,Oportunidad_platform__c> ResidentiOpps = new Map<id,Oportunidad_platform__c>();
        Map<id,id> opsExitus = new Map<id,id>();
        for (Oportunidad_platform__c ExitusOpp: [SELECT Residente__c,id,Fecha_real_de_ingreso__c from Oportunidad_platform__c where Residente__c IN: IDresidentesExitus]) {
            if (ResidentiOpps.get(ExitusOpp.Residente__c) != null) {
                Oportunidad_platform__c existent = ResidentiOpps.get(ExitusOpp.Residente__c);
                if (ExitusOpp.Fecha_real_de_ingreso__c > existent.Fecha_real_de_ingreso__c ) {
                    ResidentiOpps.put(ExitusOpp.Residente__c, ExitusOpp);
                    opsExitus.put(ExitusOpp.Residente__c,ExitusOpp.Id);
                    
                }
            }
            else {
                ResidentiOpps.put(ExitusOpp.Residente__c, ExitusOpp);
                opsExitus.put(ExitusOpp.Residente__c,ExitusOpp.Id);
            }
        }
        
        //Recorremos todas las oportunidades asociadas a los residentes que han pasado a estado exitus
        //ya que la opp es la unica manera de acceder al centro y a su director
        for (Oportunidad_platform__c exitus: [SELECT Residente__c,Residente__r.name,Centro2__r.name,Centro2__r.Director_del_centro__c,Centro2__r.ATC_centro__c from Oportunidad_platform__c where ID IN: opsExitus.values() and Centro2__r.Comunicacion_con_Familias__c = true and Centro2__r.Division__c = 'Residencial']) {
                //Obtenim el id del Director del centre
                Id IdDirector= exitus.Centro2__r.Director_del_centro__c;
                Id IdATC = exitus.Centro2__r.ATC_centro__c;
                System.debug('ID DIRECTOR: ' +IdDirector);
                //Tarea 1 Director
                Task texitus = new Task();
                texitus.Description = 'AVISO: El residente '+exitus.Residente__r.name+' ha causado baja por éxitus.Recuerda realizar la llamada de condolencias a la familia.Consulta el manual de comunicación con familias ”Procedimiento de comunicación tras éxitus” para más información. (URL intranet)';
                texitus.Status = 'Pendiente';
                texitus.ActivityDate = avui;
                texitus.Subject = 'AVISO: El residente '+exitus.Residente__r.name+' ha causado baja por éxitus.';
                texitus.OwnerId = IdDirector;
                texitus.Priority = 'Normal';
                texitus.WhatId = exitus.Residente__c;
                texitus.recordtypeid = RtypeTareaCliente.id;
                texitus.IsFromTrigger__c = true;
                //Afegim la tarea a la llista de tareas per posteriorment, insertar-les a la BD
                tasksExitus.add(texitus);
                //Tarea 2 Director
                Task texitus2 = new Task();
                texitus2.Description = 'AVISO: Envía la carta formal de condolencias a la familia del residente '+exitus.Residente__r.name+' .Consulta el manual de comunicación con familias ”Procedimiento de comunicación tras éxitus” para más información.';
                texitus2.Status = 'Pendiente';
                texitus2.ActivityDate = avui.addDays(3);
                texitus2.Subject = 'AVISO: Envía la carta formal de condolencias a la familia del residente '+exitus.Residente__r.name+' .';
                texitus2.OwnerId = IdDirector;
                texitus2.Priority = 'Normal';
                texitus2.WhatId = exitus.Residente__c;
                texitus2.recordtypeid = RtypeTareaCliente.id;
                texitus2.IsFromTrigger__c = true;
                //Afegim la tarea a la llista de tareas per posteriorment, insertar-les a la BD
                tasksExitus.add(texitus2);
            
                //Tarea ATC
                Task texitus3 = new Task();
                texitus3.Description = 'AVISO: El residente '+exitus.Residente__r.name+' ha causado baja por éxitus.Recuerda al encargado/a de SSHH que deberá gestionar las pertenencias del residente y, en caso que sea necesario, preparar la habitación y el espacio para el duelo de la familia.';
                texitus3.Status = 'Pendiente';
                texitus3.ActivityDate = avui;
                texitus3.Subject = 'AVISO: El residente '+exitus.Residente__r.name+' ha causado baja por éxitus.';
                texitus3.OwnerId = IdATC;
                texitus3.Priority = 'Normal';
                texitus3.WhatId = exitus.Residente__c;
                texitus3.recordtypeid = RtypeTareaCliente.id;
                texitus3.IsFromTrigger__c = true;
                //Afegim la tarea a la llista de tareas per posteriorment, insertar-les a la BD
                tasksExitus.add(texitus3);
                System.debug('Residente exitus: :'+exitus.Residente__c);
                System.debug('Centro exitus:'+exitus.Centro2__r.name);
                System.debug('Director exitus:'+exitus.Centro2__r.Director_del_centro__c);
        }
        insert tasksExitus;
    }
        }
}