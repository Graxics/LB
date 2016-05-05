/** 
* File Name:   BeforeTask 
* Description:Trigger que al guardar una tarea recomendador comprueba que ni el contacto recomendador (whoid) ni 
la empresa recomendadora (whatid) tengan seleccionado el campo baja.
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version    Date        Author           Modification 
* 01        11/02/2015  Xavier Garcia
*           17/09/2015  EBarrero         Incidencia con el Workflow. "Actualizar Estado Tarea" Se ejecuta después de "tgCreacioTareaCATINFO"
                                         Y este trigger, que es un "after insert task", no tiene el valor status='Completado', por lo que he 
                                         copiado la funcionalidad del WFlow en este trigger para asegurar que el campo status este actulizado
                                         cuando lo consultemos desde "tgCreacioTareaCATINFO"
                                         Marca de modificación: // Inc Nº1
            02/10/2015  Cristina         Incidencia: Problemas de derechos insuficientes en las tareas 'Interés desconocido' al asignarlo a la 
                                         cuenta comodin. Comentamos código. Marca de modificación // Inc Nº2

* =============================================================== 
**/ 
trigger BeforeTask on Task (before insert,before update) {
    if(triggerHelper.todofalse()) {
    //Mensaje de error que se mostrará
    final String errorMess = 'Ni el contacto recomendador ni la empresa recomendadora pueden tener seleccionado el campo baja.';
    //Nos guardamos el recordtype de la tarea recomendador
    Recordtype RtypeTareaRecomendador = [Select Id, Name From RecordType Where Name = 'Tarea Recomendador' LIMIT 1];
    Recordtype RtypeTareaCatOtros = [Select Id, Name From RecordType Where DeveloperName = 'Tarea_CAT_Otros' LIMIT 1];
    RecordType RtypeTareaCatInformacion = [Select Id, Name From RecordType Where Name = 'CAT - Información'];
    RecordType RtypeTareaTareaPersonal = [Select Id, Name From RecordType Where Name = 'Tarea Personal'];
    List<Account> comodinAux = [Select id,name from Account where name = 'Cliente Comodín' and recordtypeid = '012b0000000QAe0'];
    
    //Listas de ids de Contactos (whoid) y Empresas (whatid)
    List<id> Contactos = new List<id>();
    List<id> Empresas = new List<id>();
    //Maps que contendrán para cada id de contacto y de empresa, información relacionada con ese contacto y empresa (baja)
    Map<id,Contact> ContactosyBaja = new Map<id,Contact>();
    Map<id,Account> EmpresasyBaja =  new Map<id,Account>();
    //Recorremos todas las tareas que se van a modificar y, si es Tarea Recomendador, 
    //nos guardamos el whoid y el what id en las listas de ids
    for( Task t : Trigger.new ) {
        if (t.RecordTypeId == RtypeTareaRecomendador.id) {
            Contactos.add(t.WhoId);
            Empresas.add(t.WhatId);
            System.debug('WHOID: '+t.WhoId);
            System.debug('WHATID: '+t.WhatId);
        }
        /* Inc Nº2
        if ((t.RecordTypeId == RtypeTareaCatOtros.id) || (t.RecordTypeId == RtypeTareaCatInformacion.id && t.Subject == 'Interés desconocido') || (t.RecordTypeId == RtypeTareaTareaPersonal.id)) {
            if (t.WhatId == null) {
                Account comodin = comodinAux[0];
                t.WhatId = comodin.id;
            }
        }
        */
        // Inc Nº1
        if (trigger.isInsert && 
           (t.RecordTypeId == RtypeTareaCatInformacion.id || t.RecordTypeId == RtypeTareaCatOtros.id)  && 
            t.Subject != 'Interés desconocido') {
          // t.Status = 'Completada'; //Esto cierra las tareas CAT Otros -- Mirar en que casos no se debe cerrar
           
        }   
    }
    //Recorremos todos los contactos  relacionados con las tareas modificadas y
    //nos guardamos en el map la info asociada
    for (contact contacto: [SELECT id, Account.baja__c from contact where id IN:Contactos and account.recordtypeid = '012b0000000QCbt']) {
        ContactosyBaja.put(contacto.id, contacto);
        
    }
    //Recorremos todas las empresas recomendadoras relacionadas con las tareas modificadas y
    //nos guardamos en el map la info asociada
    for (Account empresa: [SELECT id, baja__c from account where id IN:Empresas and recordtypeid = '012b0000000QAd7']) {
        EmpresasyBaja.put(empresa.id, empresa);
        
    }
    //Recorremos todas las tareas modificadas y comprovamos, en primer lugar, si existen
    //el whatid y el whoid en la tarea y en caso de que existan miramos el valor del campo baja desde el map.
    //Si la empresa o el contacto son baja -> Se mostrará el error con el mensaje.
    for( Task t : Trigger.new ) {
        if (t.RecordTypeId == RtypeTareaRecomendador.id) {
            if (ContactosyBaja.get(t.WhoId) != null) {
                if (ContactosyBaja.get(t.WhoId).Account.baja__c == true) {
                    t.addError(errorMess);
                }
                else {
                     if (EmpresasyBaja.get(t.WhatId) != null) {
                         if (EmpresasyBaja.get(t.WhatId).baja__c == true) {
                                t.addError(errorMess);
                            }
                     }  
                }
            }
            else {
                if (EmpresasyBaja.get(t.WhatId) != null) {
                         if (EmpresasyBaja.get(t.WhatId).baja__c == true) {
                                t.addError(errorMess);
                          }
                } 
            }
        }
    }
 }   
}