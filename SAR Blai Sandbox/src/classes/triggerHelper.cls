//*14/09/2015 Añadido la función addErrorOp(Oportunidad_platform__c opc, string valor)

public with sharing class triggerHelper {

	public static boolean b1=false;
	public static boolean b2=false;
	public static boolean b3=false;
	public static boolean b4=false;
	public static boolean b5=false;
	public static boolean b6=false;
	public static boolean b7=false;
	public static boolean b8=false;

	//A boolean that is set and then checked at the beginning of update triggers to be sure they only execute once
	public static  void  recursiveHelper1 (Boolean tempBool){
	    b1=tempBool;
	}
	
	public static  void  recursiveHelper2 (Boolean tempBool){
	    b2=tempBool;
	}
	
	public static  void  recursiveHelper3 (Boolean tempBool){
	    b3=tempBool;
	}
	
	public static  void  recursiveHelper4 (Boolean tempBool){
	    b4=tempBool;
	}
	
	public static  void  recursiveHelper5 (Boolean tempBool){
	    b5=tempBool;
	}
	
	public static  void  recursiveHelper6 (Boolean tempBool){
	    b6=tempBool;
	}
	
	public static  void  recursiveHelper7 (Boolean tempBool){
	    b7=tempBool;
	}
	
	public static  void  recursiveHelper8 (Boolean tempBool){
	    b8=tempBool;
	}
	
	public static  boolean  todofalse (){
	    if(!b1 && !b2 && !b3 && !b4 && !b5 && !b6 && !b7 && !b8) return true;
	    else return false;
	}
	public static void setTodoFalse(){
		b1 = b2 = b3 = b4 = b5= b6 = b7 = b8 = false;
	}
	
	//separa apellidos que están juntos en dos
	public static String[] sepLastName (String ln) {
		String[] sln = new String[] {' ',' '};
		String[] nameSpl = ln.split(' ');
		String preps = 'de la del las los les els el lo mac mc van von san santa';
		Integer nLastname = 0;
		for(integer i = 0; i < nameSpl.Size(); ++i) {
			if(sln[nLastName] == ' ') sln[nLastName] = '';
			else sln[nLastName] = sln[nLastName] + ' ';
			sln[nLastName] = sln[nLastName] + nameSpl[i];
			if(!(preps.contains(nameSpl[i].toLowerCase()) || nameSpl[i].length() <= 2) && nLastname == 0) ++nLastname;
		}
		return sln;
	}
	
	public static void sendMail (String error) {
		//todo: send the error to a mail
		try {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
			mail.setToAddresses(Label.Email_Soporte.split(';'));
			mail.setSubject('Salesforce: Error en la llamada a webservice'); 
			String body = error; 
			mail.setPlainTextBody(body); 
			if(!Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail});
		}
		catch(Exception e) {
			system.debug(e);
		}
	}
	
	public static void sendMail (String error, List<String> mails, String link) {
		//todo: send the error to a mail
		try {
			List<String> mailsIT = new List<String>();
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
			mail.setToAddresses(Label.Email_Soporte.split(';')); 
			mail.setSubject('Salesforce: Error en la llamada a webservice'); 
			String body = error; 
			mail.setPlainTextBody(body); 
			
			Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage(); 
			mail2.setToAddresses(mails); 
			mail2.setSubject('Salesforce: Error en la llamada a webservice'); 
			String body2 = 'Apreciado/a,\n Se ha producido un error al intentar crear la oportunidad o modificar el contacto en Navision o GCR. Pulsa el siguiente link para ver el registro que ha dado error: ' + link + ' \n Póngase en contacto con el administrador.'; 
			mail2.setPlainTextBody(body2); 
			
			if(!Test.isRunningTest()) {
				Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail});
				//Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail2});
			}
		}
		catch(Exception e) {
			system.debug(e);
		}
	}

	// Usado en tgOportunitatsNoc 
	// Objetivo: NO generar error si la oportunidad empieza por "XX/" ni por "OP"
    public static void addErrorOp(Oportunidad_platform__c opc, string valor) {
        if (opc.Name != null) {
            if (!(opc.name.startswith('XX/') || opc.name.startswith('OP'))) opc.addError(valor); 
        }
        else {
            opc.addError(valor);
        }    
    }    
    
}