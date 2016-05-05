//transforma los motivos de alta de GCR a salesforce
public with sharing class MotivosAlta {
	private List<List<String>> tabla = new List<List<String>>();
	//tipo ingreso, motivo de alta (literal), tipo estancia (ID), destino (ID), resultado (literal, motivo alta)
	public MotivosAlta() {
        tabla.add(new List<String>{'Oportunidad privada', 'Z.Éxitus (hasta 28.02.2014)',                     '',       '',       'Exitus'});
		tabla.add(new List<String>{'Oportunidad privada', 'Éxitus en Centro',                                '',       '',       'Exitus'});
		tabla.add(new List<String>{'Oportunidad privada', 'Éxitus en Domicilio',                             '',       '',       'Exitus'});
		tabla.add(new List<String>{'Oportunidad privada', 'Éxitus en Hospital',                              '',       '',       'Exitus'});
		tabla.add(new List<String>{'Oportunidad privada', 'Destinación al propio domicilio',                 '3396',   '',       'Fin Respiro'});
		tabla.add(new List<String>{'Oportunidad privada', 'Destinación al propio domicilio',                 '3067',   '',       'Fin Convalecencia'});
		tabla.add(new List<String>{'Oportunidad privada', 'Destinación al propio domicilio',                 'Resto',  '',       'A domicilio'});
		tabla.add(new List<String>{'Oportunidad privada', 'Traslado a un hospital de agudos',                '3396',   '',       'Fin Respiro'});
		tabla.add(new List<String>{'Oportunidad privada', 'Traslado a un hospital de agudos',                '3067',   '',       'Fin Convalecencia'});
		tabla.add(new List<String>{'Oportunidad privada', 'Traslado a un hospital de agudos',                'Resto',  '',       'Hospital Agudos'});
		tabla.add(new List<String>{'Oportunidad privada', 'No exitus y No Destinación al propio domicilio',  'Resto',  '3955',   'A plaza pública mismo centro'});
		tabla.add(new List<String>{'Oportunidad privada', 'No exitus y No Destinación al propio domicilio',  '',       '3026',   'A plaza pública otro centro'});
		tabla.add(new List<String>{'Oportunidad privada', 'No exitus y No Destinación al propio domicilio',  '',       '3414',   'Competencia'});
		tabla.add(new List<String>{'Oportunidad privada', 'No exitus y No Destinación al propio domicilio',  '3396',   '',       'Fin Respiro'});
		tabla.add(new List<String>{'Oportunidad privada', 'No exitus y No Destinación al propio domicilio',  '3067',   '',       'Fin Convalecencia'});
		tabla.add(new List<String>{'Oportunidad privada', 'No exitus y No Destinación al propio domicilio',  'Resto',  '36',     'A domicilio'});
		tabla.add(new List<String>{'Oportunidad privada', 'No exitus y No Destinación al propio domicilio',  'Resto',  '78',     'A domicilio'});
		tabla.add(new List<String>{'Oportunidad privada', 'No exitus y No Destinación al propio domicilio',  'Resto',  '3021',   'Hospital Agudos'});
		tabla.add(new List<String>{'Oportunidad privada', 'No exitus y No Destinación al propio domicilio',  'Resto',  '3022',   'Hospital Agudos'});
		tabla.add(new List<String>{'Oportunidad privada', 'No exitus y No Destinación al propio domicilio',  'Resto',  'Resto',  'Otros'});
		tabla.add(new List<String>{'Oportunidad pública', '',                                                '',       '',       'Público'});
	}
	
	public String getSFMotivo(List<String> ls) {
		for(integer i = 0; i < tabla.Size(); ++i) {
			Boolean dif = false;
			for(integer j = 0; j < ls.size() && !dif; ++j) {
				if(tabla[i][j] == 'No exitus y No Destinación al propio domicilio' && (ls[j] == 'Destinación al propio domicilio' || ls[j].contains('Éxitus'))) dif = true;
				else if(tabla[i][j] != ls[j] && tabla[i][j] != 'Resto' && tabla[i][j] != '' && tabla[i][j] != 'No exitus y No Destinación al propio domicilio') dif = true;
			}
			if(!dif) return tabla[i][4];
		}
		return null;
	}
}