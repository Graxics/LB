/** 
* File Name:   SchedulableEmailOcio 
* Description: Classe schedulable que se llama el 1 de cada mes y que llama al batchable de Envío de correo
de la agenda de ocio
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		18/02/2015  Xavier Garcia
* =============================================================== 
**/ 
global class SchedulableEmailOcio implements Schedulable {
 global void execute(SchedulableContext SC) {
        BatchableEmailOcio clsBatchItUpSon = new BatchableEmailOcio();
        ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);
   }
}