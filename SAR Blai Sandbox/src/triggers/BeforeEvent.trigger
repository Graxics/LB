/** 
* File Name:   BeforeEvent 
* Description:Trigger que al guardar un evento recomendador comprueba que ni el contacto recomendador (whoid) ni 
la empresa recomendadora (whatid) tengan seleccionado el campo baja.
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		11/02/2015  Xavier Garcia
* =============================================================== 
**/ 
trigger BeforeEvent on Event (before insert,before update) {
    if(triggerHelper.todofalse()) {
	//Mensaje de error que se mostrará
	final String errorMess = 'Ni el contacto recomendador ni la empresa recomendadora pueden tener seleccionado el campo baja.';
    //Nos guardamos el recordtype del evento recomendador
    Recordtype RtypeEventoRecomendador = [Select Id, Name From RecordType Where Name = 'Evento a Recomendador' LIMIT 1];
    //Listas de ids de Contactos (whoid) y Empresas (whatid)
    List<id> Contactos = new List<id>();
    List<id> Empresas = new List<id>();
    //Maps que contendrán para cada id de contacto y de empresa, información relacionada con ese contacto y empresa (baja)
    Map<id,Contact> ContactosyBaja = new Map<id,Contact>();
    Map<id,Account> EmpresasyBaja =  new Map<id,Account>();
    //Recorremos todas las tareas que se van a modificar y, si es Evento a Recomendador, 
    //nos guardamos el whoid y el what id en las listas de ids
    for( Event e : Trigger.new ) {
        if (e.RecordTypeId == RtypeEventoRecomendador.id) {
            Contactos.add(e.WhoId);
            Empresas.add(e.WhatId);
        }
    }
    //Recorremos todos los contactos  relacionados con los eventos modificados y
    //nos guardamos en el map la info asociada
    for (contact contacto: [SELECT id, Account.baja__c from contact where id IN:Contactos and account.recordtypeid = '012b0000000QCbt']) {
        ContactosyBaja.put(contacto.id, contacto);
        
    }
    //Recorremos todas las empresas recomendadoras relacionadas con los eventos modificados y
    //nos guardamos en el map la info asociada
    for (Account empresa: [SELECT id, baja__c from account where id IN:Empresas and recordtypeid = '012b0000000QAd7']) {
        EmpresasyBaja.put(empresa.id, empresa);
        
    }
    //Recorremos todas los eventos modificadas y comprovamos, en primer lugar, si existen
    //el whatid y el whoid en el evento y en caso de que existan miramos el valor del campo baja desde el map.
    //Si la empresa o el contacto son baja -> Se mostrará el error con el mensaje.
    for( Event e : Trigger.new ) {
        if (e.RecordTypeId == RtypeEventoRecomendador.id) {
            if (ContactosyBaja.get(e.WhoId) != null) {
                if (ContactosyBaja.get(e.WhoId).Account.baja__c == true) {
                    e.addError(errorMess);
                }
                else {
                     if (EmpresasyBaja.get(e.WhatId) != null) {
                         if (EmpresasyBaja.get(e.WhatId).baja__c == true) {
                    			e.addError(errorMess);
                			}
                     }  
                }
            }
            if (EmpresasyBaja.get(e.WhatId) != null) {
                         if (EmpresasyBaja.get(e.WhatId).baja__c == true) {
                    			e.addError(errorMess);
                		  }
            } 
        }
    }
  }  
}