global class SchedulableAsignarVisita implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        Date avui = Date.today();
        //Se tienen que ejecutar el 15 de octubre y el 1 de junio
        //if (avui.month() == 10 || avui.month() == 6) {
        BatchAsignarVisita clsBatchItUpSon = new BatchAsignarVisita();
        ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);
        /*}*/
    }
    
}