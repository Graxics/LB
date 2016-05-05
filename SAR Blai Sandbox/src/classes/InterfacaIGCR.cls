//Generated by wsdl2apex

public class InterfacaIGCR {
    public class ResidenteGCR {
        public Integer TipoAccion;
        public String IdNAV_RES;
        public String FirstName;
        public String LastName1;
        public String LastName2;
        public String Tipo_Documento_Identidad;
        public String Numero_Documento_Identidad;
        public String Tipo_Documento_Sanitario;
        public String Numero_Documento_Sanitario;
        public String Estado_Civil;
        public String Sexo;
        public DateTime Fecha_Nacimiento;
        public String Phone;
        public String PersonMobilePhone;
        public String PersonEmail;
        public String Calle;
        public String Ciudad;
        public String CodigoPostal;
        public String Provincia;
        public String Pais;
        public Boolean NoTieneMail;
        public Boolean NoTieneTelefono;
        private String[] TipoAccion_type_info = new String[]{'TipoAccion','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] IdNAV_RES_type_info = new String[]{'IdNAV_RES','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] LastName1_type_info = new String[]{'LastName1','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] LastName2_type_info = new String[]{'LastName2','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Tipo_Documento_Identidad_type_info = new String[]{'Tipo_Documento_Identidad','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Numero_Documento_Identidad_type_info = new String[]{'Numero_Documento_Identidad','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Tipo_Documento_Sanitario_type_info = new String[]{'Tipo_Documento_Sanitario','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Numero_Documento_Sanitario_type_info = new String[]{'Numero_Documento_Sanitario','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Estado_Civil_type_info = new String[]{'Estado_Civil','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Sexo_type_info = new String[]{'Sexo','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Fecha_Nacimiento_type_info = new String[]{'Fecha_Nacimiento','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] Phone_type_info = new String[]{'Phone','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] PersonMobilePhone_type_info = new String[]{'PersonMobilePhone','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] PersonEmail_type_info = new String[]{'PersonEmail','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Calle_type_info = new String[]{'Calle','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Ciudad_type_info = new String[]{'Ciudad','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] CodigoPostal_type_info = new String[]{'CodigoPostal','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Provincia_type_info = new String[]{'Provincia','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Pais_type_info = new String[]{'Pais','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] NoTieneMail_type_info = new String[]{'NoTieneMail','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] NoTieneTelefono_type_info = new String[]{'NoTieneTelefono','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca','true','false'};
        private String[] field_order_type_info = new String[]{'TipoAccion','IdNAV_RES','FirstName','LastName1','LastName2','Tipo_Documento_Identidad','Numero_Documento_Identidad','Tipo_Documento_Sanitario','Numero_Documento_Sanitario','Estado_Civil','Sexo','Fecha_Nacimiento','Phone','PersonMobilePhone','PersonEmail','Calle','Ciudad','CodigoPostal','Provincia','Pais','NoTieneMail','NoTieneTelefono'};
    }
    public class ContactoGCR {
        public Integer TipoAccion;
        public Integer IDContactoGCR;
        public Integer IDResidenteGCR;
        public String Tipo_Contacto;
        public String FirstName;
        public String LastName1;
        public String LastName2;
        public String Tipo_Documento_Identidad;
        public String Numero_Documento_Identidad;
        public String Sexo;
        public DateTime Fecha_Nacimiento;
        public String Phone;
        public String PersonMobilePhone;
        public String PersonEmail;
        public String Calle;
        public String Ciudad;
        public String CodigoPostal;
        public String Provincia;
        public String Pais;
        public Boolean NoTieneMail;
        public Boolean NoTieneTelefono;
        public Boolean EsReferencia;
        private String[] TipoAccion_type_info = new String[]{'TipoAccion','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] IDContactoGCR_type_info = new String[]{'IDContactoGCR','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] IDResidenteGCR_type_info = new String[]{'IDResidenteGCR','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] Tipo_Contacto_type_info = new String[]{'Tipo_Contacto','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] LastName1_type_info = new String[]{'LastName1','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] LastName2_type_info = new String[]{'LastName2','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Tipo_Documento_Identidad_type_info = new String[]{'Tipo_Documento_Identidad','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Numero_Documento_Identidad_type_info = new String[]{'Numero_Documento_Identidad','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Sexo_type_info = new String[]{'Sexo','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Fecha_Nacimiento_type_info = new String[]{'Fecha_Nacimiento','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','true'};
        private String[] Phone_type_info = new String[]{'Phone','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] PersonMobilePhone_type_info = new String[]{'PersonMobilePhone','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] PersonEmail_type_info = new String[]{'PersonEmail','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Calle_type_info = new String[]{'Calle','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Ciudad_type_info = new String[]{'Ciudad','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] CodigoPostal_type_info = new String[]{'CodigoPostal','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Provincia_type_info = new String[]{'Provincia','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Pais_type_info = new String[]{'Pais','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] NoTieneMail_type_info = new String[]{'NoTieneMail','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] NoTieneTelefono_type_info = new String[]{'NoTieneTelefono','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] EsReferencia_type_info = new String[]{'EsReferencia','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca','true','false'};
        private String[] field_order_type_info = new String[]{'TipoAccion','IDContactoGCR','IDResidenteGCR','Tipo_Contacto','FirstName','LastName1','LastName2','Tipo_Documento_Identidad','Numero_Documento_Identidad','Sexo','Fecha_Nacimiento','Phone','PersonMobilePhone','PersonEmail','Calle','Ciudad','CodigoPostal','Provincia','Pais','NoTieneMail','NoTieneTelefono','EsReferencia'};
    }
    public class OportunidadGCR {
        public Integer TipoAccion;
        public Integer IdPersona;
        public DateTime Fecha_de_Solicitud;
        public String Tipo_de_Servicio;
        public String Tipo_de_Financiacion;
        public String Centro;
        public String IDOportunidadSF;
        private String[] TipoAccion_type_info = new String[]{'TipoAccion','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] IdPersona_type_info = new String[]{'IdPersona','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] Fecha_de_Solicitud_type_info = new String[]{'Fecha_de_Solicitud','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'1','1','false'};
        private String[] Tipo_de_Servicio_type_info = new String[]{'Tipo_de_Servicio','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Tipo_de_Financiacion_type_info = new String[]{'Tipo_de_Financiacion','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] Centro_type_info = new String[]{'Centro','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] IDOportunidadSF_type_info = new String[]{'IDOportunidadSF','http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/SAR.BackOfficeInterface.WCF.GCR/IGCRInterfaca','true','false'};
        private String[] field_order_type_info = new String[]{'TipoAccion','IdPersona','Fecha_de_Solicitud','Tipo_de_Servicio','Tipo_de_Financiacion','Centro','IDOportunidadSF'};
    }
}