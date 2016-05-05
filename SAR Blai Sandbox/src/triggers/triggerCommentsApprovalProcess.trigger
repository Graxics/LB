/** 
* File Name:   triggerCommentsApprovalProcess 
* Description: Añade los comentarios del proceso de aprobacion
* Copyright:   Konozca 
* @author:     Héctor Mañosas
* Modification Log 
* =============================================================== 
*Date     Author           Modification 
* 31/07/2014	HManosas	
* =============================================================== 
**/ 
trigger triggerCommentsApprovalProcess on NOC__c (before update) 
{
	if(triggerhelper.todofalse())
	{
		Map<Id, NOC__c> mapNocs = new Map<Id, NOC__c>();
		Map<Id, Id> mapProcessNOC  = new Map<Id, Id>();
		List<Id> listaActorId = new List<Id>();
		List<QueueSobject> listaCola = new List<QueueSobject>();
		List<User> listaUsuarios = new List<User>();	
				
		//Cogemos las NOC con estado flujo = Aprobado
		for (NOC__c n : trigger.new)
		{
			if(n.Approval_Status__c == 'Approved')
			{
				mapNocs.put(n.Id, n);
			}		
		}
		
		List<Id> processInstanceIds = new List<Id>();
			
		//Obtenemos el Id de los Process Instance de cada NOC
		if(!mapNocs.isEmpty())
		{
			for (NOC__c invs : [SELECT Id, (SELECT ID
												FROM ProcessInstances
												ORDER BY CreatedDate DESC
												LIMIT 1)
								FROM NOC__c
								WHERE ID IN : mapNocs.KeySet()])
			{
					processInstanceIds.add(invs.ProcessInstances[0].Id);
					mapProcessNOC.put(invs.ProcessInstances[0].Id, invs.Id);											
			}
			
			//Obtenemos el nombre de la Etiqueta QueueSObject
			listaCola = [SELECT Id, QueueId, Queue.Name FROM QueueSobject];
			//Obtenemos el Nombre del Usuario
			listaUsuarios = [SELECT Id, Name FROM User];
			
			//Obtenemos los Steps de cada Process Instance de la NOC modificada
			for (ProcessInstance pi : [SELECT ID, TargetObjectId,
													(SELECT OriginalActorId, ActorId, Comments
													FROM Steps
													ORDER BY CreatedDate DESC)
										FROM ProcessInstance
										WHERE Id IN : processInstanceIds])
			{
				
				//Obtenemos el ID de la NOC para añadir los comentarios de los Steps
				Id nocId = mapProcessNOC.get(pi.Id);
				NOC__c noc = mapNocs.get(nocId);			
				noc.Comentarios_de_aprobacion__c = null;
				Boolean sinComentarios = true;
				
				for(Integer i = 0; i < pi.Steps.size(); i++)
				{
					for(QueueSobject q : listaCola)
					{
						if(q.QueueId == pi.Steps[i].OriginalActorId)
						{
							for(User u : listaUsuarios)
							{
								if(u.Id == pi.Steps[i].ActorId)
								{
									//Añadimos el Nombre Usuario, Asignado a y los Comments
									if(pi.Steps[i].Comments != null)
									{
										sinComentarios = false;
										if(noc.Comentarios_de_aprobacion__c == null) noc.Comentarios_de_aprobacion__c = u.Name + ', ' + q.Queue.Name + '\n' + '"' + pi.Steps[i].Comments + '"' + '\n';
										else noc.Comentarios_de_aprobacion__c = noc.Comentarios_de_aprobacion__c + '\n' + u.Name + ', ' + q.Queue.Name + '\n' + '"' + pi.Steps[i].Comments + '"' + '\n';
									}								
									
								}							
								
							}
							
						}			
						
					}									
									
				}
				
				if(sinComentarios) noc.Comentarios_de_aprobacion__c = '"No hay comentarios"'; 	
			
			}
		}
	}

}