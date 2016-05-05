/** 
* File Name:   SchedulableEmailMenus 
* Description: Classe schedulable que se llama el 1 de cada mes y que llama al batchable de Envío de correo
de los menús.
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		22/01/2015  Xavier Garcia
* =============================================================== 
**/ 

global class SchedulableEmailMenus implements Schedulable {
 global void execute(SchedulableContext SC) {
      Date avui = Date.today();
      //Se tienen que ejecutar el 15 de octubre y el 1 de junio
     //if (avui.month() == 10 || avui.month() == 6) {
        BatchableEmailMenus clsBatchItUpSon = new BatchableEmailMenus();
        ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);
     /*}*/
   }
}