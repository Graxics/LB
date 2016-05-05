/** 
* File Name:   TriggerComprovacioIBAN  
* Description: Comprueba que el IBAN sea correcto
* Copyright:   Konozca 
* @author:     Hector Mañosas
* Modification Log 
* =============================================================== 
*Date          Author           Modification 
* 13/08/2014   hManosas
* =============================================================== 
**/

trigger TriggerComprovacioIBAN on Oportunidad_platform__c (before insert, before update) {
    
    //Primero comprovamos que el dígito de Control sea correcto
    for(Oportunidad_platform__c op : trigger.new)
    {
        String iban = op.IBAN__c;
        
        if(iban != null)
        {
            if(iban.length() >= 15)
            {
                if(!iban.substring(0,2).isNumeric() && iban.substring(2,iban.length()).isNumeric() && iban != null)
                {
                    //Miramos si es un IBAN español     
                    if(iban.substring(0,2) == 'ES')
                    {
                        //Comprovamos que el código de cuenta sea correcto para IBAN ES
                        try
                        {
                            //Cogemos los dígitos del banco, sucursal i dc
                            String banco = iban.substring(4,8);
                            String sucursal = iban.substring(8,12);
                            String dc = iban.substring(12,14);
                            String cccCuenta = iban.substring(14,24);
                            
                            String bancoSucursal = '00' + banco + sucursal;
                            
                            if(!obtenerDC(bancoSucursal).equalsignorecase(dc.substring(0,1)) || !obtenerDC(cccCuenta).equalsIgnoreCase(dc.substring(1, 2)))
                            {
                                op.IBAN__c.addError('CCC incorrecto');
                            }
                            else
                            {
                                //Comprovamos los digitos de control del IBAN
                                if(!SEPA_Toolkit.SEPAUtilities.ValidateIBAN(iban)) op.IBAN__c.addError('IBAN incorrecto');
                            }
                            
                                            
                        }
                        catch (Exception e)
                        {
                            op.addError('IBAN incorrecto');
                        }       
                            
                    }
                    //Comprovamos los digitos de control del IBAN para cuentas extranjeras
                    else
                    {
                        if(!SEPA_Toolkit.SEPAUtilities.ValidateIBAN(iban)) op.IBAN__c.addError('IBAN incorrecto');
                    }
                
                }
                else op.IBAN__c.addError('IBAN incorrecto');
            
            }
            else op.IBAN__c.addError('IBAN incorrecto');
            
        }
        
    }
    
    
    //Funciones auxiliares
    private static String obtenerDC(String valor)
    {
        Integer[] valores = new Integer[]{1, 2, 4, 8, 5, 10, 9, 7, 3, 6};
        Integer control = 0;
        for(Integer i=0; i<=9; i++)
        {
            control += Integer.valueOf(valor.substring(i,i+1)) * valores[i];
        }
        control = 11 - math.mod(control, 11);
        if(control == 11) control = 0;
        else if(control == 10) control = 1;     
        return String.valueOf(control);
    }

}