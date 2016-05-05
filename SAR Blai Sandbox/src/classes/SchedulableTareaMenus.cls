/** 
* File Name:   SchedulableTareaMenus 
* Description: Classe schedulable que es crida el 1 de cada mes (pero només s'executa al juny i al desembre) 
que crida al batchable de creació de la tarea d'actualització del menú
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		22/01/2015  Xavier Garcia
* =============================================================== 
**/ 
global class SchedulableTareaMenus implements Schedulable {
 global void execute(SchedulableContext SC) {
     Date avui = Date.today();
     //Se tienen que ejecutar el 7 de octubre y el 23 de mayo
     //if (avui.month() == 10 || avui.month() == 5) {
        BatchableTareaMenus clsBatchItUpSon = new BatchableTareaMenus();
        ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);
     /*}*/
   }
}