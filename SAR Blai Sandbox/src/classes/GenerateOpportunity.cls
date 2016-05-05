public with sharing class GenerateOpportunity {

    public Oportunidad_platform__c ofc{get; set;}
    public Account res{get; set;}
    public Account centro{get; set;}
    public Tarifa__c tarifa{get; set;}
    public Servicio__c serv{get; set;}
    public NOC__c noc{get; set;}
    public String nocGet{get; set;}
    public String ATCName{get; set;}
    public String td{get; set;}
    public String fianza{get; set;}
    public String temps{get; set;}
    public String fFi{get; set;}
    public String tarifaOfic{get; set;}
    public String fila1{get; set;}
    public String fila2{get; set;}
    public String fila3{get; set;}
    public String fila4{get; set;}
    public String tit1{get; set;}
    public String tit2{get; set;}
    public String tit3{get; set;}
    public String tit4{get; set;}
    public Double descnto{get; set;}
    public List<String> mes = new List<String> {'', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'};
    
    public GenerateOpportunity(ApexPages.StandardController controller) {
        ofc = [SELECT Id, Name, CreatedBy.Name, Fecha_de_Alta__c, Residente__c, Centro2__c, Tarifa__c, No_Finanza__c, Precio_Total__c, Descuento__c, Descuento_Ofertado__c, Servicio__c, Precio_Plus__c, Fecha_finalizacion__c, NOC__c, NOC_11_Centro__c, NOC_11_Persona__c, NOC_12_Convenios__c FROM Oportunidad_platform__c WHERE Id = :controller.getId()];
        res = [SELECT Id, Name, CIF_NIF__c, Idioma_de_Contacto__pc FROM Account WHERE Id = :ofc.Residente__c];
        centro = [SELECT Id, Name, Ciudad__c, ATC_Centro2__c, Director_del_centro__c FROM Account WHERE Id = :ofc.Centro2__c];
        
        tarifa = [Select Id, Servicio__c, Centro__c, NOC__c, Tipo_Tarifa__c, Precio__c, Precio_Plus__c From Tarifa__c Where Id = :ofc.Tarifa__c];
        
        serv = [SELECT Id, Tipo_Ocupacion__c, Grado_Dependencia__c FROM Servicio__c WHERE Id = :ofc.Servicio__c];
        if(tarifa.Tipo_Tarifa__c == 'Diaria') {
             fianza = '0.00';
             temps = 'diaria';
        }
        else {
            fianza = ofc.Precio_Total__c +'';
            temps = 'mensual';
        }
        Id nc = Null;
        if(ofc.NOC__c != NULL) nc = ofc.NOC__c;
        else if (ofc.NOC_11_Centro__c != NULL) nc = ofc.NOC_11_Centro__c;
        else if (ofc.NOC_11_Persona__c != NULL) nc = ofc.NOC_11_Persona__c;
        else if(ofc.NOC_12_Convenios__c != NULL) nc = ofc.NOC_12_Convenios__c;
        else {
            nocGet = ' ';
        }
        if(nc != NULL){
            noc = [SELECT Id, Name FROM NOC__c WHERE Id = :nc];
            nocGet = '('+noc.Name+')';
        }
        
        td = '' + Date.today().day() + ' de ' + mes[Date.today().month()] + ' de ' + Date.today().year();
        fFi = Date.today().addDays(30).day() + '-' + Date.today().addDays(30).month() + '-' + Date.today().addDays(30).year();
        if(ofc.Precio_Plus__c != NULL) tarifaOfic = String.ValueOf(ofc.Precio_Plus__c + tarifa.Precio__c);
        else tarifaOfic = String.ValueOf(tarifa.Precio__c);
        User atc = new User();
        if(centro.ATC_Centro2__c != null) atc = [Select Id, Name From User WHERE Id = :centro.ATC_Centro2__c];
        else if (centro.Director_del_centro__c != null) atc = [Select Id, Name From User WHERE Id = :centro.Director_del_centro__c];
        if(atc != null) ATCName = '     ' + atc.Name; 
        else ATCName = ' ';
        if(tarifaOfic.endsWith('.0')) tarifaOfic.replace('.0', '.00');
        fila1 = fila2 = fila3 = fila4 = '';
        tit1 = tit2 = tit3 = tit4 = '';
        //escribimos en las filas
        String serTOc = '';
        if(serv.Tipo_Ocupacion__c == 'HI') serTOc = 'Habitación Individual';
        else if(serv.Tipo_Ocupacion__c == 'HD') serTOc = 'Habitación Doble';
        else serTOc = serv.Tipo_Ocupacion__c;
        
        fila1 = temps + ' ' + serTOc;
        tit1  = '• Servicio: ';
        if(ofc.Descuento__c == null || ofc.Descuento_Ofertado__c <= 0) {
            tit2 = '• Precio Final: ';
            fila2 = ofc.Precio_Total__c + '€';
        }
        else {
            tit3 = '• Promoción: ';
            tit4 = '• Precio Final: ';
            fila2 = '• Tarifa oficial: ' + tarifaOfic + '€';
            
            if (ofc.Descuento_Ofertado__c!= NULL) fila3 = ofc.Descuento_Ofertado__c + '% ';
            else if(ofc.Descuento__c!= NULL) fila3 = ofc.Descuento__c + '% ';
            
            fila4 = ofc.Precio_Total__c + '€';
        }
        
    }
}