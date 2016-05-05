global class AvisoNocSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      AvisoNocBatch anb = new AvisoNocBatch(); 
      database.executebatch(anb);
   }
}