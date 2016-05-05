/** 
* File Name:   TestTgNocRechazada 
* Description: Test del trigger TgNocRechazada
* Copyright:   Konozca 
* @author:     Hector Mañosas
* Modification Log 
* =============================================================== 
*   Version          Date        Author           Modification 
*     00             30/09/2014
*     01             17/12/2014  Agimenez         Correccion envio multiples emails
* =============================================================== 
**/ 
@isTest
private class TestTgNocRechazada {

    static testMethod void myUnitTest() {
        
        // Generate sample work item using utility method.
        Id testWorkItemId = generateAndSubmitObject();
        
        //Reject the submitted request, providing a comment
        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('Rejecting request with a comment.');
        testRej.setAction('Reject');
        testRej.setWorkitemId(testWorkItemId);
        
        Test.startTest();        
        // Process the rejection
        Approval.ProcessResult testRejResult =  Approval.process(testRej);
        Test.stopTest();
        
        // Verify the rejection results
        System.assert(testRejResult.isSuccess(), 'Rejections that include comments should be permitted');
        System.assertEquals('Rejected', testRejResult.getInstanceStatus(), 
          'Rejections that include comments should be successful and instance status should be Rejected');
    }
        
        private static Id generateAndSubmitObject()
    	{
	        // Create a sample invoice statement object and then submit it for approval.
	        NOC__c testIS = new NOC__c();        
	        testIS.Fecha_inicio__c = System.today().addDays(-30);
	        testIS.Fecha_fin__c = System.today().addDays(15);
            testIS.Duracion_del_descuento__c = 10;
            testIS.Residencial__c = true;
	        insert testIS;       	                
	        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
	        testReq.setComments('Submitting request for rejected.');
	        testReq.setObjectId(testIS.Id);
	        Approval.ProcessResult reqResult = Approval.process(testReq);
	        System.assert(reqResult.isSuccess(),'Unable to submit new invoice statement record for approval');	        
	        return reqResult.getNewWorkitemIds()[0];    
   		}

}