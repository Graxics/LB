/** 
* File Name:   Test_REST_WebService
* Description: Classe test de la clase REST_WebService
* Copyright:   Konozca 
* @author:     Jose M Perez
* Modification Log 
**/ 

@isTest
public class Test_REST_WebService {
    static testMethod void myUnitTest() {
        //Crear Oportunidad
        Oportunidad_platform__c op = new Oportunidad_platform__c();        
        op.Etapa__c = 'Abierta';
        op.Canal__c = 'Llamada al Cat';
        op.Procedencia__c = 'Internet';
        op.Pagina_web__c = 'Google';
        op.Tipo_de_tarifa__c = 'Diaria';
        op.Tipo_de_pago__c = 'gratis';
        op.IBAN__c = 'ES9121000418450200051332';
        op.Regimen__c = 'UED';
        op.Tipo_de_Financiacion__c = 'Privado';
        op.Fecha_prevista_de_ingreso__c = Date.today();
        op.Fecha_finalizacion__c = System.today().addDays(15);
        op.Visita_realizada_en__c = 'Centro';
        op.Tipo_de_pago__c = 'Gratis';
        op.Precio_Colgantes__c = 10;
        op.Precio_sin_colgante__c = 5;
        op.Nombre_propio_y_plena_capacidad_de__c = true;
        op.Nombre_Avalista__c = 'sr avalista';
        triggerHelper.recursiveHelper3(true);                  
        insert op;          
        
        
        REST_WebService ws = new REST_WebService('user', 'pass');
        ws.GetDevices();
        Map<String, Object> p = new Map<String, Object>();
        p.put(REST_WebService.USER_VIDSIGNER, 'ac.userVidsigner__c');
        p.put(REST_WebService.PASS_VIDSIGNER, 'ac.passVidsigner__c');        
        p.put(REST_WebService.OP_ID , String.valueOf(op.id));
        p.put(REST_WebService.OP_NAME, op.Name);
        ws.postDocuments(p);
        
    }
}