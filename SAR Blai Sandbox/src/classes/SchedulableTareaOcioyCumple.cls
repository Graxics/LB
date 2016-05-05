/** 
* File Name:   SchedulableTareaOcioyCumple 
* Description: Classe schedulable que es crida el 1 de cada mes i que crida al batchable de creació de les
Tareas d'actualitzacio de la agenda de ocio i a la de cumpleaños
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		22/01/2015  Xavier Garcia
* =============================================================== 
**/ 
global class SchedulableTareaOcioyCumple implements Schedulable {
 global void execute(SchedulableContext SC) {
        BatchableTareaOcioyCumple clsBatchItUpSon = new BatchableTareaOcioyCumple();
        ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);
   }
}