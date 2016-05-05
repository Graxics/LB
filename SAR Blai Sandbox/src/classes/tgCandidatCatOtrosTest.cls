@isTest
public class tgCandidatCatOtrosTest {
    static testMethod void myUnitTest() {
   //   User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
   		Profile MarketingProfile = [select id from Profile where Name = 'Usuario de Marketing (new)'];
       	User MarketingUser = [select id from User where profileid = :MarketingProfile.id limit 1];
        String cpid = '';
        System.runAs(MarketingUser) {
            Campaign cpgn = new Campaign();
            cpgn.StartDate = Date.today().addDays(3);
       		cpgn.EndDate = Date.today().addDays(20);
        	cpgn.Name = 'Test Campaign XX';
       		insert cpgn;
            cpgn = [select id, id_campana__c from Campaign where id = :cpgn.id];
            cpid = cpgn.ID_Campana__c;
        }
        List<Lead> candidatos = new List<Lead>();
     // System.runAs(thisUser) {

        for (Integer i = 1; i < 10; ++i) {
            		Lead c = new Lead(FirstName = 'Prueba', LastName = 'Tarea Abierta', Email = 'alejandronavas@hotmail.com',Sexo__c = 'Hombre', Fuente__c = 'Web');
                c.Numero_de_formulario__c = '01';
                c.Motivo_Consulta__c = 'Residencia';
                c.Nombre_Centro__c = 'prueba1';
                c.ID_Centro__c = '000000';
                c.Provincia__c = 'Córdoba';
                c.Fuente__c = 'Web';
                c.FirstName = 'Firstname';
                c.LastName = 'Lastname';       
                c.Email = 'emailtest@test.com';
                c.Phone = '666448779';
                c.Cuenta_Bancaria__c = 'ES91 8378 1287 2189 3298';
                c.Nombre_Usuario__c = 'Nombre Usuario';
                c.Apellidos_Usuario__c ='Apellidos Usuario';
                c.Provincia_Usuario__c = 'Provincia';
              //  c.DNI_Usuario__c = '11111111P';
                c.Telefono_Usuario__c = '123456788';   
                c.Calle__c = 'Calle';
                c.NumCalle__c = '1';
                c.Piso__c = '2';
                c.Puerta__c  = '3';
                c.Escalera__c = 'B';
                c.Codigo_Postal__c = '89778';
                c.City = 'Granada';
                c.Hora_de_llamada__c = '08-09 h';
                c.Mensaje__c = 'Mensaje prueba';
                c.Nombre_Familiar__c = 'Carmen';
                c.Apellidos_Familiar__c = 'Gómez';
                c.Concepto__c = 'Concepto';
                c.ID_Campa_a__c = cpid;
                c.ID_Centro__c = '26420';
                System.debug('ID Camapaña T-T-T-Test: '+cpid);
                c.id = null;
                c.Numero_de_formulario__c = '0'+i;
                if (i == 3) c.Email = 'testclassemail2@test.com'; //probamos asociacion contacto existente
                else  c.Email = 'testclassemail'+i+'@test.com';
                c.DNI_Solicitante__c = i+'0000000J';
                c.DNI_Usuario__c = i+'1111111P';
            	candidatos.add(c);
        }
        insert candidatos;

 //     
       /*		candidatos.add(c);
       //     Lead c2 = new Lead(Firstname = 'Heyhey',Lastname = 'heyhey', email = 'hooola@hello.com', Numero_de_formulario__c = '07' );
      //      candidatos.add(c2);
            insert candidatos;
            
            
         //   Recordtype RtypeTareaCatOtros = [Select Id, Name From RecordType Where Name = 'CAT - Otros' LIMIT 1];
         	Recordtype RtypeCuentaSC = [Select Id, Name From RecordType Where Name = 'Contacto Servicios Centrales' LIMIT 1];
            Date hoy = Date.today();
           // Task t1 = [select Id, Description, RecordTypeId,createddate, Status, Subject from Task Where (RecordTypeId = :RTypeTareaCatOtros.Id ) limit 1];
         // 	Account a = [select id, recordtypeid, createddate, PersonEmail from Account where createddate = :hoy and recordtypeid = '012b0000000QFtbAAG' limit 1];
         //   System.debug('AAAAAAAAAQUIIIII EMPIEZAAAAAAAA \n'+a.PersonEmail);
//            System.debug('SUBJECT: '+t1.Subject); */

      }
}