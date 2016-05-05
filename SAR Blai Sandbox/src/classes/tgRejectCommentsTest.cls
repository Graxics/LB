/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class tgRejectCommentsTest {

    static testMethod void testRejectionWithComment()
    {
        // Generate sample work item using utility method.
        Id testWorkItemId = generateAndSubmitObject();
        
        // Reject the submitted request, providing a comment.
        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('Rejecting request with a comment.');
        testRej.setAction('Reject');
        testRej.setWorkitemId(testWorkItemId);
    

            // Process the rejection
            Approval.ProcessResult testRejResult =  Approval.process(testRej);
        
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
        testReq.setComments('Submitting request for approval.');
        testReq.setObjectId(testIS.Id);
        Approval.ProcessResult reqResult = Approval.process(testReq);
            
        // Verify the result
        System.assert(reqResult.isSuccess());
        
        System.assertEquals(
            'Pending', reqResult.getInstanceStatus(), 
            'Instance Status'+reqResult.getInstanceStatus());
        
        return reqResult.getNewWorkitemIds()[0];
    }

}