// 23/9/2015
//Llamadas telefónicas - Centro_LlamadasTelefonicas
//Venta de productos de higiene personal - Centro_VentaProductosHigiene
public with sharing class PlanPersonalController {

    	
    public Oportunidad_platform__c ofc{get; set;}
    public Account res{get; set;}
    public Account centro{get; set;}
    public Tarifa__c tarifa{get; set;}
    public Servicio__c serv{get; set;}
    public NOC__c noc{get; set;}
    private Account Sociedad;
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
    public List<String> mesCAT = new List<String> {'', 'de gener', 'de febrer', 'de Març', 'd\'abril', 'de maig', 'de juny', 'de juliol', 'd\'agost', 'de setembre', 'd\'octubre', 'de novembre', 'de desembre'};
        
    private map<integer,map<integer, string>> literales = new map<integer,map<integer, string>>();  
    //          idioma      orden    Descripción
    //          1 Castellano
    //          2 Català
    //          3 Galego
    //          4 Euskera
    //          ...
    private map<integer,list<String>> listas = new map<integer,list<String>>();
    
    public list<String> getList_Asistencial() 		{ return listas.get(1); }
    public list<String> getList_Bienestar() 		{ return listas.get(2); }
    public list<String> getList_Atencion() 			{ return listas.get(3); }
    public list<String> getList_TarEspeciales() 	{ return listas.get(4); }
    public list<String> getList_Asistencial_d()		{ return listas.get(5); }
    public list<String> getList_Bienestar_d() 		{ return listas.get(6); }
    public list<String> getList_Atencion_d() 		{ return listas.get(7); }   
    public list<String> getList_TarEspeciales_d() 	{ return listas.get(8); }
    
    public list<String> Espacios {get; set;}
    
    public PlanPersonalController(ApexPages.StandardController controller) {
        ofc = [SELECT Id, Name, CreatedBy.Name, Fecha_de_Alta__c, Residente__c, Centro2__c, Tarifa__c, No_Finanza__c, Precio_Total__c, Descuento__c, Descuento_Ofertado__c, Servicio__c, Precio_Plus__c, Fecha_finalizacion__c, NOC__c, NOC_11_Centro__c, NOC_11_Persona__c, NOC_12_Convenios__c, ambito__c,Idioma__c, Tipo_estancia2__c FROM Oportunidad_platform__c WHERE Id = :controller.getId()];
        res = [SELECT Id, Name, CIF_NIF__c, Idioma_de_Contacto__pc FROM Account WHERE Id = :ofc.Residente__c];
        centro = [SELECT Id, Name, Ciudad__c, ATC_Centro__c,ATC_Centro2__c, Director_del_centro__c, Formato_Plan_Personalizado__c,
                  Responsable_PlanPersonal__c,CD_UD__c,
				Medico_propio__c,Medico_24h__c,Servicio_de_enfermeria__c,Servicio_de_enfermeria_24h__c,Atencion_medica_enfermeria__c,Control_de_tratamientos_medicos__c,Evaluacion_gerontologica__c,Gestion_de_recetas_medicas__c,Valoracion_geriatrica_integral__c,Dietas_adaptadas__c,Apoyo_y_atencion_psicologica__c,Fisioterapia_individual__c,Talleres_de_memoria__c,Sistema_de_aviso_24h__c,Cama_ergonomica_y_bano_asistido__c,Limpieza_diaria_de_la_habitacion__c,Personalizar_la_habitacion__c,Lavanderia_y_planchado__c,Pension_completa__c,Pension_completaCD__c,Menu_degustacion__c,Transporte_de_Lunes_a_Viernes__c,Menus_a_familiares__c,podologia_profesional__c,Peluqueria_profesional__c,Actividades_ludicas__c,Gimnasio__c,Servicios_religiosos__c,Capilla__c,Jardin_y_terrazas__c,Jardin__c,Terrazas__c,Jardin_y_solarium__c,Sala_de_juegos__c,Cafeteria__c,Salas_de_estar__c,Floristeria__c,Caja_de_seguridad__c,Biblioteca__c,WiFi__c,Rincon_del_Juguete__c,Profesionales_socio_sanitarios__c,Servicio_de_atencion_familiar__c,Informes_de_la_evolucion__c,Orientacion_sobre_la_ley_de_dependencia__c,Horarios_libres_de_visita__c,Servicio_de_atencion_a_sugerencias__c,Horario_adaptable__c,Salas_para_las_visitas__c,Gestion_de_las_visitas__c,Parking_gratuito__c,Parking__c,Fisioterapia_y_rehabilitacion_especiales__c,Acompanamiento_para_salidas_medicas__c,Servicios_adicionales_de_peluqueria__c,Tintoreria__c,Alquiler_de_ayudas_tecnicas__c,pernoctacion_espordica_en_el_centro__c,Servicio_de_fin_de_semana__c,consultas_medicas_externas__c,InnovacionAlimentariaDietasTexturiza__c, PosivilidadExtenderContratacionServicio__c, Tipo_de_fianza__c               
                ,Centro_VentaProductosHigiene__c, Centro_LlamadasTelefonicas__c, sociedad__c  
                FROM Account WHERE Id = :ofc.Centro2__c];
        
        Sociedad = [Select 	
                    		Plan_personal_CAT_Hoja_1__c, 
                    		Plan_personal_CAT_Hoja_2__c, 
                    		Plan_personal_CAT_Pie_Hoja_1__c,
                    		Plan_personal_ESP_Hoja_1__c,
                    		Plan_personal_ESP_Hoja_2__c,
                    		Plan_personal_ESP_Pie_Hoja_1__c
                    from account
                    where id=:centro.Sociedad__c];
        
        tarifa = [Select Id, Servicio__c, Centro__c, NOC__c, Tipo_Tarifa__c, Precio__c, Precio_Plus__c From Tarifa__c Where Id = :ofc.Tarifa__c];
        
        serv = [SELECT Id, Tipo_Ocupacion__c, Grado_Dependencia__c, Transporte__c, Tipo_Servicio__c FROM Servicio__c WHERE Id = :ofc.Servicio__c];
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
        
        
        if (getIdioma()=='CAT') 
            td = '' + Date.today().day() + ' ' + mesCAT[Date.today().month()] + ' de ' + Date.today().year();
        else
        	td = '' + Date.today().day() + ' de ' + mes[Date.today().month()] + ' de ' + Date.today().year();
        
        
        fFi = Date.today().addDays(30).day() + '-' + Date.today().addDays(30).month() + '-' + Date.today().addDays(30).year();
        if(ofc.Precio_Plus__c != NULL) tarifaOfic = String.ValueOf(ofc.Precio_Plus__c + tarifa.Precio__c);
        else tarifaOfic = String.ValueOf(tarifa.Precio__c);

        List<User> atc = new List<User>();
       
        try {
            if (centro.Responsable_PlanPersonal__c=='Director/a SARquavitae') {
                atc = [Select Id, Name From User WHERE Id = :centro.Director_del_centro__c];
            } else { 
                atc = [Select Id, Name From User WHERE Id = :centro.ATC_Centro__c];
            } 
        } catch(myexception e) {ATCName='Falta';}
        
        if(atc.size()==1) ATCName = ' ' + atc.get(0).Name; 
        else ATCName = ' ';
          
        /*
        User atc = new User();
        if(centro.ATC_Centro2__c != null) atc = [Select Id, Name From User WHERE Id = :centro.ATC_Centro2__c];
        else if (centro.Director_del_centro__c != null) atc = [Select Id, Name From User WHERE Id = :centro.Director_del_centro__c];
        if(atc != null) ATCName = '     ' + atc.Name; 
        else ATCName = ' ';
        */
        
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
    
    private void cargarLiterales() {
        literales.put(1, new map<integer, string>());//          1 Castellano
        literales.put(2, new map<integer, string>());//          2 Català
        literales.put(3, new map<integer, string>());//          3 Galego
        literales.put(4, new map<integer, string>());//          4 Euskera
        
literales.get(1).put(1,'Médico propio.');
literales.get(1).put(2,'Médico 24 h.');
literales.get(1).put(3,'Servicio de enfermería.');
literales.get(1).put(4,'Servicio de enfermería 24 horas.');
literales.get(1).put(5,'Atención médica/enfermería.');
literales.get(1).put(6,'Control y aplicación de tratamientos médicos, cuidados de enfermería y seguimiento de medicación.');
literales.get(1).put(7,'Evaluación gerontológica.');
literales.get(1).put(8,'Valoración geriátrica integral.');
literales.get(1).put(9,'Gestión de recetas médicas.');
literales.get(1).put(10,'Dietas adaptadas a las necesidades individuales, programadas por el departamento de nutrición.');
literales.get(1).put(11,'Innovación alimentaria: dietas texturizadas.');
literales.get(1).put(12,'Apoyo y atención psicológica.');
literales.get(1).put(13,'Fisioterapia individual, rehabilitación y gimnasia de mantenimiento.');
literales.get(1).put(14,'Talleres de memoria y terapias de estimulación cognitiva y ocupacional.');
literales.get(1).put(15,'Sistema de aviso en la habitación 24 horas.');
literales.get(1).put(16,'Cama ergonómica y baño asistido en la habitación.');
literales.get(1).put(17,'Limpieza diaria de la habitación.');
literales.get(1).put(18,'Posibilidad de personalizar la habitación.');
literales.get(1).put(19,'Lavandería, planchado y repaso de ropa.');
literales.get(1).put(20,'Restauración propia elaborada con productos de calidad, en régimen de pensión completa que incluye desayuno, comida, merienda y cena.');
literales.get(1).put(21,'Restauración propia elaborada con productos de calidad. Incluye desayuno, comida y merienda.');
literales.get(1).put(22,'Menú degustación.');
literales.get(1).put(23,'Transporte de Lunes a Viernes.');
literales.get(1).put(24,'Menús a familiares y menús de eventos familiares .');
literales.get(1).put(25,'Un servicio al mes de podología profesional en el propio centro adaptado a sus necesidades.');
literales.get(1).put(26,'Peluquería profesional en el propio centro con servicio de lavado, corte y marcado.');
literales.get(1).put(27,'Actividades lúdicas diarias, celebraciones de cumpleaños, onomásticas y fiestas tradicionales.');
literales.get(1).put(28,'Gimnasio.');
literales.get(1).put(29,'Servicios religiosos.');
literales.get(1).put(30,'Capilla.');
literales.get(1).put(31,'Jardín y terrazas especialmente pensadas para disfrutar del aire libre.');
literales.get(1).put(32,'Jardín especialmente pensado para disfrutar del aire libre.');
literales.get(1).put(33,'Terrazas especialmente pensadas para disfrutar del aire libre.');
literales.get(1).put(34,'Jardín y solarium especialmente pensados para disfrutar del aire libre.');
literales.get(1).put(35,'Sala de juegos en la que se pueden desarrollar  actividades personales o en grupo.');
literales.get(1).put(36,'Cafetería.');
literales.get(1).put(37,'Salas de estar con prensa y televisión.');
literales.get(1).put(38,'Floristeria.');
literales.get(1).put(39,'Caja de seguridad.');
literales.get(1).put(40,'Biblioteca.');
literales.get(1).put(41,'WiFi.');
literales.get(1).put(42,'Rincón del Juguete.');
literales.get(1).put(43,'Profesionales sociosanitarios al servicio de los familiares.');
literales.get(1).put(44,'Servicio de atención familiar y encuentros periódicos con la familia.');
literales.get(1).put(45,'Informes de la evolución del residente.');
literales.get(1).put(46,'Orientación sobre la ley de dependencia y  otras ayudas.');
literales.get(1).put(47,'Horario libre de visitas y de recepción de llamadas.');
literales.get(1).put(48,'Servicio de atención a sugerencias.');
literales.get(1).put(49,'Horario adaptable a las necesidades del usuario y de sus familias.');
literales.get(1).put(50,'Salas especialmente acondicionadas para las visitas.');
literales.get(1).put(51,'Gestión de las visitas a especialistas médicos.');
literales.get(1).put(52,'Parking gratuito para las visitas.');
literales.get(1).put(53,'Parking para las visitas.');
literales.get(1).put(54,'Fisioterapia y rehabilitación especiales.');
literales.get(1).put(55,'Acompañamiento para salidas médicas o lúdicas periódicas.');
literales.get(1).put(56,'Servicios adicionales de peluquería, manicura y podología profesional.');
literales.get(1).put(57,'Servicios de arreglos especiales de ropa. Tintorería.');
literales.get(1).put(58,'Alquiler de ayudas técnicas.');
literales.get(1).put(59,'Posibilidad de extender la contratación del servicio según necesidades puntuales.');
literales.get(1).put(60,'Posibilidad de pernoctación esporádica en el centro.');
literales.get(1).put(61,'Servicio de fin de semana.');
literales.get(1).put(62,'Servicio de consultas médicas externas.');
literales.get(1).put(63,'Llamadas telefónicas.');
literales.get(1).put(64,'Venta de productos de higiene personal');

// ***********************************************************************CATALÂ
literales.get(2).put(1,'Metge propi.');
literales.get(2).put(2,'Metge 24h.');
literales.get(2).put(3,'Servei d\'infermeria.');
literales.get(2).put(4,'Servei d\'infermeria 24h.');
literales.get(2).put(5,'Valoració geriàtrica integral.');
literales.get(2).put(6,'Innovació aliment: dietes texturitzades.');
literales.get(2).put(7,'Tallers de memòria i teràpies d\'estimulació cognitiva i ocupacional.');
literales.get(2).put(8,'Sistema d\'avís a l\'habitació 24 hores.');
literales.get(2).put(9,'Atenció mèdica/infermeria.');
literales.get(2).put(10,'Control i aplicació de tractaments mèdics, cures d\'infermeria i seguiment de medicació.');
literales.get(2).put(11,'Avaluació gerontològica.');
literales.get(2).put(12,'Gestió de receptes mèdiques.');
literales.get(2).put(13,'Dietes adaptades a les necessitats individuals, programades pel departament de nutrició.');
literales.get(2).put(14,'Recolzament i atenció psicològica.');
literales.get(2).put(15,'Fisioteràpia individual, rehabilitació i gimnasia de manteniment.');
literales.get(2).put(16,'Llit ergonòmic i bany assistit a l’habitació');
literales.get(2).put(17,'Neteja diària de l’habitació');
literales.get(2).put(18,'Possibilitat d’incorporar mobiliari personal i elements decoratius a l’habitació');
literales.get(2).put(19,'Bugaderia, planxat i repàs de roba');
literales.get(2).put(20,'Restauració pròpia elaborada amb productes de qualitat, en règim de pensió completa, que inclou esmorzar, dinar, berenar i sopar');
literales.get(2).put(21,'Menús a familiars i menús d\'events familiars.');
literales.get(2).put(22,'Un servei al mes de podologia professional en el propi centre adaptat a les seves necessitats.');
literales.get(2).put(23,'Perruqueria professional en el propi centre amb servei de rentat, tallat i marcat.');
literales.get(2).put(24,'Gimnàs totalment condicionat ');
literales.get(2).put(25,'Capella.');
literales.get(2).put(26,'Terrasses especialment pensats per gaudir de l’aire lliure');
literales.get(2).put(27,'Jardí i solàrium especialment pensats per a gaudir de l\'aire lliure.');
literales.get(2).put(28,'Sala de jocs on es poden dur a terme activitats personals o de grup');
literales.get(2).put(29,'Cafeteria – restaurant ');
literales.get(2).put(30,'Sala d’estar amb premsa i televisió');
literales.get(2).put(31,'Floristeria.');
literales.get(2).put(32,'Caixa de seguretat.');
literales.get(2).put(33,'Biblioteca.');
literales.get(2).put(34,'WiFi.');
literales.get(2).put(35,'Racó del joguet.');
literales.get(2).put(36,'Restauració pròpia elaborada amb productes de qualitat. Inclou esmorzar, dinar i berenar.');
literales.get(2).put(37,'Menú degustació.');
literales.get(2).put(38,'Transport de Dilluns a Divendres.');
literales.get(2).put(39,'Activitats lúdiques diàries, celebracions d’aniversaris, onomàstiques i festes tradicionals, organitzades per monitors');
literales.get(2).put(40,'Serveis religiosos.');
literales.get(2).put(41,'Jardí i terrasses especialment pensats per a gaudir de l\'aire lliure.');
literales.get(2).put(42,'Jardí especialment pensat per a gaudir de l\'aire lliure.');
literales.get(2).put(43,'Professionals sociosanitaris al servei dels familiars. ');
literales.get(2).put(44,'Servei d\'atenció al familiar i trobades periòdiques amb la família.');
literales.get(2).put(45,'Informes d\'evolució del resident.');
literales.get(2).put(46,'Orientació sobre la llei de dependència i altres ajudes.');
literales.get(2).put(47,'Horaris lliures de visita i de recepció de trucades');
literales.get(2).put(48,'Servei d\'atenció a suggeriments');
literales.get(2).put(49,'Horari adaptable a les necessitats de l\'usuari i dels seus familiars.');
literales.get(2).put(50,'Sales especialment acondicionades per a les visites.');
literales.get(2).put(51,'Gestió de visites a especialistes mèdics');
literales.get(2).put(52,'Pàrquing gratuït per a les visites.');
literales.get(2).put(53,'Pàrquing per a les visites.');
literales.get(2).put(54,'Servei de fisioteràpia i rehabilitació especials');
literales.get(2).put(55,'Servei d’acompanyament per a sortides mèdiques o lúdiques periòdiques');
literales.get(2).put(56,'Serveis addicionals de perruqueria, manicura i podologia professional');
literales.get(2).put(57,'Serveis d’arranjaments especials de roba. Tintoreria.');
literales.get(2).put(58,'Lloguer d’ajudes tècniques');
literales.get(2).put(59,'Possibilitat d\'estendre la contractació del servei segons necessitats puntuals.');
literales.get(2).put(60,'Possibilitat de pernoctació esporàdica al centre.');
literales.get(2).put(61,'Serveis de cap de setmana.');
literales.get(2).put(62,'Serveis de consultes mèdiques externes.');
literales.get(2).put(63,'Trucades telefòniques');
literales.get(2).put(64,'Venda de productes d’higiene personal, accessoris ');


        
}
    public void  load() {
        cargarLiterales(); 
        
        
        integer idioma = 1;
		if (getIdioma()=='CAT')  idioma=2;
		
		
        map<integer, string> literal = literales.get(idioma); 
        
        listas.put(1,new List<string>());
        listas.put(2,new List<string>());
        listas.put(3,new List<string>());
        listas.put(4,new List<string>());
        listas.put(5,new List<string>());
        listas.put(6,new List<string>());   
        listas.put(7,new List<string>());   
        listas.put(8,new List<string>());   
        
        if (ofc.ambito__c == 'Centro de Día') { 
        if(centro.Atencion_medica_enfermeria__c) listas.get(1).add(literal.get(5));
        if(centro.Control_de_tratamientos_medicos__c) listas.get(1).add(literal.get(6));
        if(centro.Evaluacion_gerontologica__c) listas.get(1).add(literal.get(7));
        
        if(centro.Gestion_de_recetas_medicas__c) listas.get(1).add(literal.get(9));
        if(centro.Dietas_adaptadas__c) listas.get(1).add(literal.get(10));

        if(centro.Apoyo_y_atencion_psicologica__c) listas.get(1).add(literal.get(12));
        if(centro.Fisioterapia_individual__c) listas.get(1).add(literal.get(13));


        if(centro.Pension_completaCD__c) listas.get(2).add(literal.get(21));
        if(centro.Menu_degustacion__c) listas.get(2).add(literal.get(22));
        if(centro.Transporte_de_Lunes_a_Viernes__c) listas.get(2).add(literal.get(23));

        if(centro.Actividades_ludicas__c) listas.get(2).add(literal.get(27));
        if(centro.Gimnasio__c) listas.get(2).add(literal.get(28));
        if(centro.Servicios_religiosos__c) listas.get(2).add(literal.get(29));
        if(centro.Capilla__c) listas.get(2).add(literal.get(30));
        if(centro.Jardin_y_terrazas__c) listas.get(2).add(literal.get(31));
        if(centro.Jardin__c) listas.get(2).add(literal.get(32));

        if(centro.Jardin_y_solarium__c) listas.get(2).add(literal.get(34));
        if(centro.Sala_de_juegos__c) listas.get(2).add(literal.get(35));
        if(centro.Cafeteria__c) listas.get(2).add(literal.get(36));
        if(centro.Salas_de_estar__c) listas.get(2).add(literal.get(37));

        if(centro.Biblioteca__c) listas.get(2).add(literal.get(40));
        if(centro.WiFi__c) listas.get(2).add(literal.get(41));
        if(centro.Rincon_del_Juguete__c) listas.get(2).add(literal.get(42));
        if(centro.Profesionales_socio_sanitarios__c) listas.get(3).add(literal.get(43));
        if(centro.Servicio_de_atencion_familiar__c) listas.get(3).add(literal.get(44));
        if(centro.Informes_de_la_evolucion__c) listas.get(3).add(literal.get(45));
        if(centro.Orientacion_sobre_la_ley_de_dependencia__c) listas.get(3).add(literal.get(46));
        if(centro.Horarios_libres_de_visita__c) listas.get(3).add(literal.get(47));
        if(centro.Servicio_de_atencion_a_sugerencias__c) listas.get(3).add(literal.get(48));
        if(centro.Horario_adaptable__c) listas.get(3).add(literal.get(49));
        if(centro.Salas_para_las_visitas__c) listas.get(3).add(literal.get(50));
        if(centro.Gestion_de_las_visitas__c) listas.get(3).add(literal.get(51));
        if(centro.Parking_gratuito__c) listas.get(3).add(literal.get(52));
        if(centro.Parking__c) listas.get(3).add(literal.get(53));
        if(centro.Fisioterapia_y_rehabilitacion_especiales__c) listas.get(4).add(literal.get(54));
        if(centro.Acompanamiento_para_salidas_medicas__c) listas.get(4).add(literal.get(55));
        if(centro.Servicios_adicionales_de_peluqueria__c) listas.get(4).add(literal.get(56));
        if(centro.Tintoreria__c) listas.get(4).add(literal.get(57));
        if(centro.Alquiler_de_ayudas_tecnicas__c) listas.get(4).add(literal.get(58));
        if(centro.PosivilidadExtenderContratacionServicio__c) listas.get(4).add(literal.get(59));
        if(centro.pernoctacion_espordica_en_el_centro__c) listas.get(4).add(literal.get(60));
        if(centro.Servicio_de_fin_de_semana__c) listas.get(4).add(literal.get(61));
		}

        if (ofc.ambito__c  == 'Residencial') { 
        if(centro.Medico_propio__c) listas.get(1).add(literal.get(1));
        if(centro.Medico_24h__c) listas.get(1).add(literal.get(2));
        if(centro.Servicio_de_enfermeria__c) listas.get(1).add(literal.get(3));
        if(centro.Servicio_de_enfermeria_24h__c) listas.get(1).add(literal.get(4));

        if(centro.Control_de_tratamientos_medicos__c) listas.get(1).add(literal.get(6));

        if(centro.Valoracion_geriatrica_integral__c) listas.get(1).add(literal.get(8));
        if(centro.Gestion_de_recetas_medicas__c) listas.get(1).add(literal.get(9));
        if(centro.Dietas_adaptadas__c) listas.get(1).add(literal.get(10));
        if(centro.InnovacionAlimentariaDietasTexturiza__c) listas.get(1).add(literal.get(11));
        if(centro.Apoyo_y_atencion_psicologica__c) listas.get(1).add(literal.get(12));
        if(centro.Fisioterapia_individual__c) listas.get(1).add(literal.get(13));
        if(centro.Talleres_de_memoria__c) listas.get(1).add(literal.get(14));
        if(centro.Sistema_de_aviso_24h__c) listas.get(1).add(literal.get(15));
        if(centro.Cama_ergonomica_y_bano_asistido__c) listas.get(2).add(literal.get(16));
        if(centro.Limpieza_diaria_de_la_habitacion__c) listas.get(2).add(literal.get(17));
        if(centro.Personalizar_la_habitacion__c) listas.get(2).add(literal.get(18));
        if(centro.Lavanderia_y_planchado__c) listas.get(2).add(literal.get(19));
        if(centro.Pension_completa__c) listas.get(2).add(literal.get(20));
 		if(centro.Menu_degustacion__c) listas.get(2).add(literal.get(22));
        if(centro.Menus_a_familiares__c) listas.get(2).add(literal.get(24));
        if(centro.podologia_profesional__c) listas.get(2).add(literal.get(25));
        if(centro.Peluqueria_profesional__c) listas.get(2).add(literal.get(26));
        if(centro.Actividades_ludicas__c) listas.get(2).add(literal.get(27));
        if(centro.Gimnasio__c) listas.get(2).add(literal.get(28));
        if(centro.Servicios_religiosos__c) listas.get(2).add(literal.get(29));
        if(centro.Capilla__c) listas.get(2).add(literal.get(30));
        if(centro.Jardin_y_terrazas__c) listas.get(2).add(literal.get(31));
        if(centro.Jardin__c) listas.get(2).add(literal.get(32));
        if(centro.Terrazas__c) listas.get(2).add(literal.get(33));
        if(centro.Jardin_y_solarium__c) listas.get(2).add(literal.get(34));

        if(centro.Cafeteria__c) listas.get(2).add(literal.get(36));
        if(centro.Salas_de_estar__c) listas.get(2).add(literal.get(37));
        if(centro.Floristeria__c) listas.get(2).add(literal.get(38));
        if(centro.Caja_de_seguridad__c) listas.get(2).add(literal.get(39));
        if(centro.Biblioteca__c) listas.get(2).add(literal.get(40));
        if(centro.WiFi__c) listas.get(2).add(literal.get(41));
        if(centro.Rincon_del_Juguete__c) listas.get(2).add(literal.get(42));
        if(centro.Profesionales_socio_sanitarios__c) listas.get(3).add(literal.get(43));
        if(centro.Servicio_de_atencion_familiar__c) listas.get(3).add(literal.get(44));
        if(centro.Informes_de_la_evolucion__c) listas.get(3).add(literal.get(45));
        if(centro.Orientacion_sobre_la_ley_de_dependencia__c) listas.get(3).add(literal.get(46));
        if(centro.Horarios_libres_de_visita__c) listas.get(3).add(literal.get(47));
        if(centro.Servicio_de_atencion_a_sugerencias__c) listas.get(3).add(literal.get(48));

        if(centro.Salas_para_las_visitas__c) listas.get(3).add(literal.get(50));
        if(centro.Gestion_de_las_visitas__c) listas.get(3).add(literal.get(51));
        if(centro.Parking_gratuito__c) listas.get(3).add(literal.get(52));
        if(centro.Parking__c) listas.get(3).add(literal.get(53));
        if(centro.Fisioterapia_y_rehabilitacion_especiales__c) listas.get(4).add(literal.get(54));
        if(centro.Acompanamiento_para_salidas_medicas__c) listas.get(4).add(literal.get(55));
        if(centro.Servicios_adicionales_de_peluqueria__c) listas.get(4).add(literal.get(56));
        if(centro.Tintoreria__c) listas.get(4).add(literal.get(57));
        if(centro.Alquiler_de_ayudas_tecnicas__c) listas.get(4).add(literal.get(58));

        if(centro.consultas_medicas_externas__c) listas.get(4).add(literal.get(62));
        if (centro.Centro_LlamadasTelefonicas__c)  listas.get(4).add(literal.get(63));
        if (centro.Centro_VentaProductosHigiene__c) listas.get(4).add(literal.get(64));   
			}
        
        equilibrar(1,5);
        equilibrar(2,6);
        equilibrar(3,7);
 		equilibrar(4,8);
        
      
        
    }    
    private void equilibrar(integer ind1, integer ind2) {
        string literal;
        integer mitaz;
        List<String> origen = listas.get(ind1);
        if (origen.size() >2) {
            mitaz = (origen.size()/2);
            //if (math.mod(origen.size(),2)!=0) mitaz+=1;  
            for (integer bucle=mitaz; bucle < origen.size();bucle++ ) {
                literal = origen.get(bucle);
                listas.get(ind2).add(literal);
                
            }
            for (integer bucle=origen.size()-1; bucle >= mitaz;bucle-- ) {
				origen.remove(bucle);
            }            
            
            
        }
    }
    
    public String getLit_TarifaServicio() {
		String T = 'Tarifa servicio: '; 
		String DIA = 'día ';
		String CON_TRANS = '(con transporte)';
		String SIN_TRANS = '(sin transporte)';
        String r;
		
		if (getIdioma()=='CAT') {
			T = 'Tarifa servei: '; 
			DIA = 'dia ';
			CON_TRANS = '(amb transport)';
			SIN_TRANS = '(sense transport)';
		}
		
        if (ofc.ambito__c == 'Centro de Día') { 
               r=T;
        	   r+= tarifa.Precio__c.format() + ' € ';
               r+= (tarifa.Tipo_Tarifa__c == 'Diaria') ? DIA:'mes ';   
               r+= (serv.Transporte__c=='Si') ? CON_TRANS : SIN_TRANS;
     	}
        if (ofc.ambito__c ==  'Residencial') {
               r='Tarifa oficial: ';	
          	   r+= tarifa.Precio__c.format() + ' € ';
               r+= (tarifa.Tipo_Tarifa__c == 'Diaria') ? DIA:'mes ';   
               r+= serv.Tipo_Ocupacion__c;	
        }
        return r;
    } 
    public String getLit_ImporteFinal() {
		String PRECIO_FINAL ='Precio Final: '; 
		String DIA = 'día ';
		
		if (getIdioma()=='CAT') {
			PRECIO_FINAL ='Preu Final: '; 
			DIA = 'dia ';
		}

		
        String r='<li class="item"><b>' + PRECIO_FINAL + '</b>';
        if (ofc.ambito__c == 'Centro de Día') { 
        	   r+= ofc.Precio_Total__c.format() + ' € ';
     	}        
        if (ofc.ambito__c ==  'Residencial') {
          	   r+= ofc.Precio_Total__c.format() + ' € ';
               r+= (tarifa.Tipo_Tarifa__c == 'Diaria') ? DIA:'mes ';   
               r+= serv.Tipo_Ocupacion__c;	
        }
		return r + '</li>';        
    }
    public String getPromocion() {
		String PROMOCION = 'Promoción: ';

		if (getIdioma()=='CAT') {
			PROMOCION = 'Promoció: '; 
		}
		
        String r='VACIO';
        Decimal d = 0;
            if (ofc.Descuento_Ofertado__c!= NULL) d = ofc.Descuento_Ofertado__c;
            else if(ofc.Descuento__c!= NULL) d = ofc.Descuento__c;        
			d=d.setScale(2);
        
        if (d!= 0) { 
            r = PROMOCION + d.format() + ' %';
            /*
            String n = 'Promoción: ' +  d;
            r = n  + '% de descuento por ';
            r+= (ofc.NOC_12_Convenios__c != NULL) ? 'colectivo':nocGet;
			*/
        }
        return r;
    } 
    
    public String getFormato_Plan_Personalizado() {
        if (centro.Formato_Plan_Personalizado__c==null) return 'F22';
        return centro.Formato_Plan_Personalizado__c.substring(0,3);
    }
   
    public integer getEsResi() {
        return (ofc.ambito__c  == 'Residencial') ?1:0;
    }
    public integer getEsDia() {
        return (ofc.ambito__c == 'Centro de Día') ?1:0;
    }    
    

    public String getCentro_name() {
	String EL_CENTRO = 'El Centro ';	
		
		if (getIdioma()=='CAT') {
			EL_CENTRO = 'El Centre ';
		}		
	
        String r = ' ';
        if (getEsResi()==1) r= EL_CENTRO;    
        if (getEsDia()==1) { 
            if (centro.CD_UD__c=='Centro de día') r='El '; else r='La ';
        	r=r+centro.CD_UD__c + ' ';    
        }
        r=r + 'SARquavitae ' + centro.name; 
        return r; 
    }
    public String getlit_GradoDependencia() {
	String GRADO_DEPENDENCIA;
    String r = '';
    	if (serv.Grado_Dependencia__c!=null) {
    		
            if (getIdioma()=='CAT') {
                GRADO_DEPENDENCIA = 'Grau de dependència estimat: ';
                     if (serv.Grado_Dependencia__c=='Grado 1') GRADO_DEPENDENCIA+='Grau 1';
                else if (serv.Grado_Dependencia__c=='Grado 2') GRADO_DEPENDENCIA+='Grau 2';
                else if (serv.Grado_Dependencia__c=='Grado 3') GRADO_DEPENDENCIA+='Grau 3';
                else GRADO_DEPENDENCIA += serv.Grado_Dependencia__c;
            }	else {
                GRADO_DEPENDENCIA = 'Grado de dependencia estimado: ' + serv.Grado_Dependencia__c;
            }	
    
            r='<li class="item">' + GRADO_DEPENDENCIA  + '</li>';
        }
        return r;
    }
    public string getImporteFianza() {
        
        //String r = ( (lang=='CAT') ? '<b>Import fiança: </b>' : '<b>Importe fianza: </b>' );
        String r = '';
        
        //estancia permanente
        if (ofc.Tipo_estancia2__c=='mensual'){ 
            if (centro.Tipo_de_fianza__c=='una mensualidad') {
                r = ofc.Precio_Total__c.format();
            } else {
                r = (ofc.Precio_Total__c/2).format();
            }
        }
        
        /*
        if (centro.Tipo_de_fianza__c=='una mensualidad')
            r = ofc.Precio_Total__c.format() + ' € ';
        else 
            r = (ofc.Precio_Total__c/2).format() + ' € ';
		*/
        //return ( (lang=='CAT') ? '<b>Import fiança: </b>' : '<b>Importe fianza: </b>' ) + r;    
        return r;
    }
	public string getIdioma() {
        String r = 'POR_DEFECTO';
        if (ofc.Idioma__c=='Catalán') r='CAT';
		return r;
	}
    
    
    public string getHTML_Saludo() {
    String r='';    
        if (getIdioma()=='CAT') {
r='<p class="p1 ft1">' + getCentro_name() + ' us ofereix un servei integral personalitzat per gaudir de la màxima comoditat durant la vostra estada amb un tracte familiar i el millor equip especialitzat en l’atenció sociosanitària.</p>';
r+='<p class="p2 ft2">Durant la vostra estada s’inclouen i queden a la vostra total disposició els nostres serveis:</p>';
        } else {
r='<p class="p1 ft1">' + getCentro_name() + ' le ofrece un servicio integral personalizado para disfrutar de la máxima comodidad durante su estancia con un trato familiar y el mejor equipo de profesionales especializados en la atención sociosanitaria.</p>';
r+='<p class="p2 ft2">Durante su estancia se incluyen y quedan a su entera disposición nuestros servicios:</p>';
        }
        return r;
    }
    
    public string getLIT_SERVICIOS_ASISTENCIALES() {
    String r='SERVICIOS ASISTENCIALES';
        if (getIdioma()=='CAT') r= 'Serveis assistencials';
        return r;
    }
    
    public string getLIT_SERVICIOS_DE_BIEN_ESTAR() {
    String r='SERVICIOS DE BIEN ESTAR Y CONFORT';
        if (getIdioma()=='CAT') r= 'Serveis de CONFORT I OCI';
        return r;
    }

    
    public string getLIT_SERVICIOS_DE_ATENCION() {
    String r='SERVICIOS DE ATENCION AL FAMILIAR';
        if (getIdioma()=='CAT') r= 'Serveis d’ATENCIÓ AL FAMILIAR';
        return r;
    }
        
	
    public string getLIT_TARIFAS_ESPECIALES() {
    String r='TARIFAS ESPECIALES, SIEMPRE PODRÁ DECIDIR INCLUIR LA UTILIZACIÓN A SU ELECCIÓN';
        if (getIdioma()=='CAT') r= 'Tarifes especials, sempre podreu decidir incloure l’ús,  a la vostra ELECCIÓ,  dels  serveis següents';
        return r;
    }
        
    
    public string getLIT_CONDICIONES_ECONOMICAS() {
    String r='CONDICIONES ECONÓMICAS';
        if (getIdioma()=='CAT') r= 'Condicions econòmiques';
        return r;
    }
        
    
    public string getLIT_FECHA_VALIDEZ() {
    	//String r='Data de validesa del pressupost: Un mes';
    	String r='Fecha de validez del presupuesto: Un mes';
        if (getIdioma()=='CAT') r= 'Data de validesa del pressupost: Un mes';
        return r;
    }
    
    
    public string getLIT_CONDICIONES_DE_INGRESO() {
    String r='CONDICIONES DE INGRESO';
        if (getIdioma()=='CAT') r= 'Condicions d’ingrés';
        return r;
    }
    
    
    public string getHTML_FIANZA() {
    String r='<div class="item"><b>Fianza: </b>en el momento del ingreso se abonará el importe correspondiente de ' + centro.Tipo_de_fianza__c + ' para estancias superiores a un mes en concepto de fianza.</div>';
        if (getIdioma()=='CAT') r='<div class="item"><b>Fiança: </b>en el moment de l’ingrés s’abonarà l’import corresponent de mitja mensualitat per a  estades superiors a un mes, en concepte de fiança.</div>';
        return r;
    }
	
    public string getHTML_FIANZA_IMPORTE() {
        String lang = getIdioma();
        String fianza = getImporteFianza();
        
        String r='<div class="item"><b>Importe fianza: </b>' + fianza + ' € <br/> La facturación correspondiente al mes se realizará el primer día del mismo mes.</div>';
        if (lang=='CAT') r='<div class="item"><b>Import fiança: </b>' + fianza + ' € <br/> La facturació corresponent al mes es realitzarà el primer dia del mateix mes.</div>';
        
        return r;
    }
        
    public string getLIT_SERVICIOS_INCLUIDOS() {
    String r='SERVICIOS INCLUIDOS EN SU PLAN PERSONALIZADO';
        if (getIdioma()=='CAT') r= 'Serveis inclosos en el seu PLA personalitzat';
        return r;
    }

    public string getHTML_SERVICIOS1() {
    String r='';
        if (getIdioma()=='CAT') {
         r='<div class="item">Són els descrits al full anterior corresponents als apartats:</div>';
         r+='<div class="item"><SPAN class="ft2"> • </SPAN><b>Serveis ASSISTENCIALS</b></div>';
         r+='<div class="item"><SPAN class="ft2"> • </SPAN><b>Serveis de CONFORT I OCI</b></div>';
         r+='<div class="item"><SPAN class="ft2"> • </SPAN><b>Serveis d\'ATENCIÓ AL FAMILIAR</b></div>';
        } else {
         r='<div class="item">Son los descritos en la hoja anterior correspondientes a los apartados:</div>';
         r+='<div class="item"><SPAN class="ft2"> • </SPAN><b>Servicios ASISTENCIALES</b></div>';
         r+='<div class="item"><SPAN class="ft2"> • </SPAN><b>Servicios de CONFORT Y OCIO</b></div>';
         r+='<div class="item"><SPAN class="ft2"> • </SPAN><b>Servicios de ATENCIÓN AL FAMILIAR</b></div>';
        }    
        return r;
    }    
    public string getHTML_SERVICIOS2() {
    String r='';
        if (getIdioma()=='CAT') {
         r='<div class="item">Els serveis a la vostra ELECCIÓ no inclosos en el preu pressupostat d’aquest pla personalitzat es facturaran el mes següent al de la seva prestació.</div>';
         r+='<div class="item"><br/> </div>';
         r+='<div class="item">Moltes gràcies per confiar en SARquavitae.</div>';

        } else {
         r='<div class="item">Servicios a su ELECCIÓN no incluidos en el precio presupuestado de este plan personalizado se facturarán al mes siguiente al de su prestación.</div>';
         r+='<div class="item"><br/> </div>';
         r+='<div class="item">Muchas gracias por confiar en SARquavitae.</div>';
        }    
        return r;
    }       

    //Capçelera
    public String getID_Img1() {
        String r=sociedad.Plan_personal_ESP_Hoja_1__c; //'015b0000002EJza'; //015b0000002EJza '01511000000Wt3f'
        if (getIdioma()=='CAT') r=sociedad.Plan_personal_CAT_Hoja_1__c; //'015b0000002dUNL'; //015b0000002dUNL   '01511000000gaPH'
        return r;
    }
    //Peu
    public String getID_Img2() {
        String r=sociedad.Plan_personal_ESP_Pie_Hoja_1__c; //'015b0000002EJzZ'; //015b0000002EJzZ  '01511000000X5qy'
        if (getIdioma()=='CAT') r=sociedad.Plan_personal_CAT_Pie_Hoja_1__c; //'015b0000002dUNK'; //015b0000002dUNK   '01511000000gaPC'
        return r;
    }    
    // Segon full
    public String getID_Img3() {
        String r=sociedad.Plan_personal_ESP_Hoja_2__c; //'015b0000002EJzb';  //015b0000002EJzb 01511000000Wt3k
        if (getIdioma()=='CAT') r=sociedad.Plan_personal_CAT_Hoja_2__c; //'015b0000002dUNM'; //015b0000002dUNM  '01511000000gaPR'
        return r;
    }
    
    public String getDISPLAY_GRUPO(){
         return (ofc.Tipo_estancia2__c=='Mensual') ? '' : 'display: none';
    }
/*
    public String getHTML_APARTADO_FIANZA(){
        //Solo se muestra el apartado 'CONDICIONES DE INGRESO' si el plan es permanente
        return (ofc.Tipo_estancia2__c=='Mensual') ? 
            		'<div class="grupo">' +
							'<div Class="capitulo">' + getLIT_CONDICIONES_DE_INGRESO() + '</div>' + 
    						'<div class="parrafos">' + getHTML_FIANZA() + '</div>' +
    						'<div class="parrafos">' + getHTML_FIANZA_IMPORTE() + '</div>' +
					'</div>'
            		: '';
    }
  */      
}