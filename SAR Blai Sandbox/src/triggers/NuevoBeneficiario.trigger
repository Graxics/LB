/** 
* File Name:   NuevoBeneficiario 
* Description: Trigger que lanza errores si no se cumplen ciertas condiciones al insertar/modificar Relaciones entre contactos
Con tipo de Registro Relacion de beneficiarios
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Date           Author          Modification 
* 15/05/2015    Xavier Garcia     
* =============================================================== 
**/
trigger NuevoBeneficiario on Relacion_entre_contactos__c (before insert) {
    if(triggerHelper.todofalse()) {
    System.debug('ENTRAnuevobeneficiario');
    List<id> Oportunidades = new List<id>();
    Id perfilid = UserInfo.getProfileId();
    Profile p = [Select name from profile where id =:perfilid];
    if (p.name != 'Administrador del Sistema (force.com)') {
        System.debug('ENTRAnuevobeneficiario222');
        for (Relacion_entre_contactos__c relacion:Trigger.new) {
            if (relacion.recordtypeid == '012b0000000QIjXAAW') {
                if (relacion.Usuario_principal__c && relacion.Activo__c && relacion.historico__c == false) {
                    System.debug('ENTRAnuevobeneficiario333');
                    Oportunidades.add(relacion.Oportunidad__c);
                }
            }
    	}
    List<Relacion_entre_contactos__c> UsuariosPrincipalesOld = new List<Relacion_entre_contactos__c>();
    for (Relacion_entre_contactos__c beneficiario:[Select id,oportunidad__c,pagador__c,Usuario_principal__c,Beneficiario_con_colgante__c,Beneficiario_sin_colgante__c,Activo__c from Relacion_entre_contactos__c where oportunidad__c IN:Oportunidades and Activo__c = true and oportunidad__r.etapa__c = 'Cerrada ganada' and Usuario_principal__c = true]) {
        Relacion_entre_contactos__c rel = new Relacion_entre_contactos__c(id = beneficiario.id);
        rel.Usuario_principal__c = false;
        rel.Beneficiario_con_colgante__c = true;
        UsuariosPrincipalesOld.add(rel);
        System.debug('Nuevo beneficiario: '+rel);
    }
    update UsuariosPrincipalesOld;
   }
  }  
}