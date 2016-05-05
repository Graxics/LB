global class scheduleBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
      Felicitaciones f = new Felicitaciones(); 
      database.executebatch(f);
   }
}