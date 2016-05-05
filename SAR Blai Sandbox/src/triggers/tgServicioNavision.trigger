/** 
* File Name:   tgServicioNavision 
* Description: Crea servicios en Navision
* Copyright:   Konozca 
* @author:     Sergi Aguilar
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 
* =============================================================== 
**/ 
trigger tgServicioNavision on Servicio__c (after insert) {
	for(Servicio__c ser: trigger.new) {
		if(Label.Activacion_de_la_integracion != 'No') CalloutNavisionWS.createServicio(ser.Id);
	}
}