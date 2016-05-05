/** 
* File Name:   tgRejectComments 
* Description: Obliga a poner comentarios cuando se rechaza un flujos de aprobación
* Copyright:   Konozca 
* @author:     Sergi Aguilar
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 
* =============================================================== 
**/ 
trigger tgRejectComments on NOC__c (before update,before insert) {
    if (Trigger.isUpdate) {
        Map<Id, NOC__c> rejectedStatements = new Map<Id, NOC__c>{};
    
      for(NOC__c inv: trigger.new)
      {   NOC__c OldNOC = Trigger.oldMap.get(inv.Id);
       if (inv.RecordTypeId == '012b0000000QBcq' && inv.Numero_de_plazas__c != OldNOC.Numero_de_plazas__c && inv.Estado_Flujo__c != 'Aprobado') {
           inv.Numero_de_plazas_libres__c = inv.Numero_de_plazas__c;
       }
       if (inv.RecordTypeId == '012b0000000QBcq' && inv.Numero_de_plazas_en_rotacion__c != OldNOC.Numero_de_plazas_en_rotacion__c && inv.Estado_Flujo__c != 'Aprobado') {
           inv.Numero_de_plazas_en_rotacion_libres__c = inv.Numero_de_plazas_en_rotacion__c;
       }
          
        /* 
          Get the old object record, and check if the approval status 
          field has been updated to rejected. If so, put it in a map 
          so we only have to use 1 SOQL query to do all checks.
        */
        NOC__c oldInv = System.Trigger.oldMap.get(inv.Id);
    
        if (oldInv.Approval_Status__c != 'Rejected' 
         && inv.Approval_Status__c == 'Rejected')
        { 
          rejectedStatements.put(inv.Id, inv);  
        }
      }
       
      if (!rejectedStatements.isEmpty())  
      {
        // UPDATE 2/1/2014: Get the most recent approval process instance for the object.
        // If there are some approvals to be reviewed for approval, then
        // get the most recent process instance for each object.
        List<Id> processInstanceIds = new List<Id>{};
        
        for (NOC__c invs : [SELECT (SELECT ID
                                                  FROM ProcessInstances
                                                  ORDER BY CreatedDate DESC
                                                  LIMIT 1)
                                          FROM NOC__c
                                          WHERE ID IN :rejectedStatements.keySet()])
        {
            processInstanceIds.add(invs.ProcessInstances[0].Id);
        }
          
        // Now that we have the most recent process instances, we can check
        // the most recent process steps for comments.  
        for (ProcessInstance pi : [SELECT TargetObjectId,
                                       (SELECT Id, StepStatus, Comments 
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                   FROM ProcessInstance
                                   WHERE Id IN :processInstanceIds
                                   ORDER BY CreatedDate DESC])   
        {                   
          if ((pi.Steps[0].Comments == null || 
               pi.Steps[0].Comments.trim().length() == 0))
          {
            rejectedStatements.get(pi.TargetObjectId).addError(
              'Se tiene que informar una razón de rechazo!');
          }
        }  
      }
    }
    if (Trigger.isInsert) {
        for(NOC__c inv: trigger.new) {
            if (inv.RecordTypeId == '012b0000000QBcq' && inv.Numero_de_plazas__c != null && inv.Estado_Flujo__c != 'Aprobado') {
               inv.Numero_de_plazas_libres__c = inv.Numero_de_plazas__c;
           }
           if (inv.RecordTypeId == '012b0000000QBcq' && inv.Numero_de_plazas_en_rotacion__c != null && inv.Estado_Flujo__c != 'Aprobado') {
               inv.Numero_de_plazas_en_rotacion_libres__c = inv.Numero_de_plazas_en_rotacion__c;
           }
      } 
    }    
}