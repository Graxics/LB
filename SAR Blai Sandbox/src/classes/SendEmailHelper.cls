/** 
* File Name:   SendEmailHelper 
* Description: Classe auxiliar que proporciona funcions per l'enviament de mails
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		27/01/2015  Xavier Garcia
* =============================================================== 
**/ 
public with sharing class SendEmailHelper {
    public String convertir_mes(Integer mes) {
        List<String> meses = new List<String> ();
        meses.add('Enero');
        meses.add('Febrero');
        meses.add('Marzo');
        meses.add('Abril');
        meses.add('Mayo');
        meses.add('Junio');
        meses.add('Julio');
        meses.add('Agosto');
        meses.add('Septiembre');
        meses.add('Octubre');
        meses.add('Noviembre');
        meses.add('Diciembre');
        return meses[mes-1];
    }
    public String convertir_mes_cat(Integer mes) {
        List<String> meses = new List<String> ();
        meses.add('Gener');
        meses.add('Febrer');
        meses.add('Març');
        meses.add('Abril');
        meses.add('Maig');
        meses.add('Juny');
        meses.add('Juliol');
        meses.add('Agost');
        meses.add('Setembre');
        meses.add('Octubre');
        meses.add('Novembre');
        meses.add('Desembre');
        return meses[mes-1];
    }
    public String convertir_mes_eus(Integer mes) {
        List<String> meses = new List<String> ();
        meses.add('Urtarrila');
        meses.add('Otsaila');
        meses.add('Martxoa');
        meses.add('Apirila');
        meses.add('Maiatza');
        meses.add('Ekaina');
        meses.add('Uztaila');
        meses.add('Abuztua');
        meses.add('Iraila');
        meses.add('Urria');
        meses.add('Azaroa');
        meses.add('Abendua');
        return meses[mes-1];
    }
    public String convertir_mes_gal(Integer mes) {
        List<String> meses = new List<String> ();
        meses.add('Xaneiro');
        meses.add('Febreiro');
        meses.add('Marzo');
        meses.add('Abril');
        meses.add('Maio');
        meses.add('Xuño');
        meses.add('Xullo');
        meses.add('Agosto');
        meses.add('Setembro');
        meses.add('Outubro');
        meses.add('Novembro');
        meses.add('Decembro');
        return meses[mes-1];
    }
}