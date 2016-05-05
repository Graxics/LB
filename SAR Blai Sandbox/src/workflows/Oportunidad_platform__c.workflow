<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>prueba</fullName>
        <description>prueba</description>
        <protected>false</protected>
        <recipients>
            <recipient>sarquavitae@konozca.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Nuevos_contratos/Contrato_TAD</template>
    </alerts>
    <alerts>
        <fullName>verificar_recomendador</fullName>
        <ccEmails>cristina.andinach@konozca.com</ccEmails>
        <description>verificar recomendador</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WF_contacto/Propietarios_cuenta_y_contacto_diferentes</template>
    </alerts>
    <alerts>
        <fullName>verificar_recomendador_2</fullName>
        <ccEmails>cristina.andinach@konozca.com</ccEmails>
        <description>verificar recomendador 2</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WF_contacto/Propietarios_cuenta_y_contacto_diferentes</template>
    </alerts>
    <fieldUpdates>
        <fullName>Actualizar_Descuento_Ofertado</fullName>
        <field>Descuento_Ofertado__c</field>
        <formula>if( ISBLANK( Precio_Plus__c ),
if(ISBLANK(Precio_Ofertado__c) , Descuento__c, (Precio__c-Precio_Ofertado__c) / Precio__c),
if(ISBLANK(Precio_Ofertado__c) , Descuento__c, ((Precio__c+Precio_Plus__c)-Precio_Ofertado__c) / Precio__c)
 )</formula>
        <name>Actualizar Descuento Ofertado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_Precio_Ofertado</fullName>
        <field>Precio_Ofertado__c</field>
        <formula>if( ISBLANK( Precio_Plus__c),Precio__c, Precio__c+ Precio_Plus__c )</formula>
        <name>Actualizar Precio Ofertado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_campo</fullName>
        <field>Fecha_cierre__c</field>
        <formula>today()</formula>
        <name>Actualizar campo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_campo_cerrada_por_el_sistema</fullName>
        <field>Etapa__c</field>
        <literalValue>Cerrada por el sistema</literalValue>
        <name>Actualizar campo cerrada por el sistema</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_etapa_Cerrada_sistema_TAD</fullName>
        <field>Etapa__c</field>
        <literalValue>Cerrada por el sistema</literalValue>
        <name>Actualizar etapa = Cerrada sistema TAD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_fecha_solicitud</fullName>
        <field>Fecha_solicitud__c</field>
        <formula>TODAY()</formula>
        <name>Actualizar fecha solicitud</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_motivo_de_Alta_Comercial</fullName>
        <field>Motivo_de_Alta_Comercial__c</field>
        <formula>IF( Motivio_de_Alta_GCR__c=&apos;Exitus en centro&apos; ||Motivio_de_Alta_GCR__c=&apos;Exitus en domicilio&apos;
 ||Motivio_de_Alta_GCR__c= &apos;Exitus en hospital&apos;
, &apos;Exitus&apos;, 

IF(Motivio_de_Alta_GCR__c=&apos;Destinación al propio domicilio&apos; 
, &apos;&apos;, &apos;&apos;) )</formula>
        <name>Actualizar motivo de Alta Comercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Actualizar_no_ingreso</fullName>
        <field>Etapa__c</field>
        <literalValue>No ingreso</literalValue>
        <name>Actualizar no ingreso</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cerrada_por_sistema</fullName>
        <field>Etapa__c</field>
        <literalValue>Cerrada por el sistema</literalValue>
        <name>Cerrada por sistema</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Actualización fecha cierre</fullName>
        <actions>
            <name>Actualizar_campo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Oportunidad_platform__c.Etapa__c</field>
            <operation>equals</operation>
            <value>Ingreso,No ingreso,Cerrada por el sistema,Cerrada ganada,Cerrada perdida</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar Precio y Descuento Ofertado</fullName>
        <actions>
            <name>Actualizar_Descuento_Ofertado</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Actualizar_Precio_Ofertado</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISBLANK( Precio_Ofertado__c )  &amp;&amp;  ISBLANK( Descuento_Ofertado__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar etapa %3D Cerrada sistema</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Oportunidad_platform__c.Etapa__c</field>
            <operation>equals</operation>
            <value>Pendiente visita,Presentado Plan Personal,Visita Planificada / Espontánea,Información / Visita,Abierta,Negociación</value>
        </criteriaItems>
        <criteriaItems>
            <field>Oportunidad_platform__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Oportunidad pública,Oportunidad privada,Oportunidad TAD,Oportunidad TAM,Oportunidad TA Dúo</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Cerrada_por_sistema</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Actualizar etapa %3D Cerrada sistema Adorea</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Oportunidad_platform__c.Etapa__c</field>
            <operation>equals</operation>
            <value>Pendiente visita,Presentado Plan Personal,Visita Planificada / Espontánea,Información / Visita,Abierta</value>
        </criteriaItems>
        <criteriaItems>
            <field>Oportunidad_platform__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Oportunidad Adorea</value>
        </criteriaItems>
        <description>Al cabo de 3 meses</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Actualizar_etapa_Cerrada_sistema_TAD</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Actualizar etapa%3D Cerrada por el sistema Adorea</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Oportunidad_platform__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Oportunidad Adorea</value>
        </criteriaItems>
        <criteriaItems>
            <field>Oportunidad_platform__c.Fecha_prevista_de_entrada__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Actualizar_campo_cerrada_por_el_sistema</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Oportunidad_platform__c.Fecha_prevista_de_entrada__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Actualizar fecha solicitud</fullName>
        <actions>
            <name>Actualizar_fecha_solicitud</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Oportunidad_platform__c.Contrato_Firmado__c</field>
            <operation>equals</operation>
            <value>Verdadero</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Actualizar no ingreso</fullName>
        <actions>
            <name>Actualizar_no_ingreso</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Oportunidad_platform__c.Fecha_cierre_No_Ingreso__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Oportunidad_platform__c.Motivo_no_Ingreso__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Oportunidad_platform__c.Etapa__c</field>
            <operation>equals</operation>
            <value>Información / Visita,Pendiente visita,Visita Planificada / Espontánea,Presentado Plan Personal,Preingreso</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Crear tarea recordatorio reconfirmación fehca entrada Adorea</fullName>
        <actions>
            <name>Recordatorio_Llamar_al_cliente_para_reconfirmar_fecha_prevista_entrada</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Oportunidad_platform__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Oportunidad Adorea</value>
        </criteriaItems>
        <criteriaItems>
            <field>Oportunidad_platform__c.Fecha_prevista_de_entrada__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Informar motivos no Ingreso</fullName>
        <actions>
            <name>Recordatorio_llamada_No_ingreso_Interesa_a_medio_plazo</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Oportunidad_platform__c.Motivo_no_Ingreso__c</field>
            <operation>equals</operation>
            <value>Interesa a medio plazo</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Reclamar datos facturación</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Oportunidad_platform__c.Etapa__c</field>
            <operation>equals</operation>
            <value>Preingreso</value>
        </criteriaItems>
        <criteriaItems>
            <field>Oportunidad_platform__c.Fecha_real_de_ingreso__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Oportunidad_platform__c.IBAN__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Solicitar_datos_de_Facturaci_n</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Oportunidad_platform__c.Fecha_real_de_ingreso__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>prueba campo formula</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Oportunidad_platform__c.Campo_prueba__c</field>
            <operation>equals</operation>
            <value>Verdadero</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>prueba</name>
                <type>Alert</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Agradecer_ingreso_al_recomendador</fullName>
        <assignedToType>owner</assignedToType>
        <description>Ha ingresado un nuevo residente con un recomendador informado. Recuerde llamarlo y agraceder su recomendación.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Pendiente</status>
        <subject>Agradecer ingreso al recomendador</subject>
    </tasks>
    <tasks>
        <fullName>Recordatorio_Llamar_al_cliente_para_reconfirmar_fecha_prevista_entrada</fullName>
        <assignedToType>owner</assignedToType>
        <description>Llamar al cliente para reconfirmar la fecha prevista entrada</description>
        <dueDateOffset>-2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Oportunidad_platform__c.Fecha_prevista_de_entrada__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Pendiente</status>
        <subject>Recordatorio: Llamar al cliente para reconfirmar fecha prevista entrada</subject>
    </tasks>
    <tasks>
        <fullName>Recordatorio_llamada_No_ingreso_Interesa_a_medio_plazo</fullName>
        <assignedToType>owner</assignedToType>
        <description>Póngase en contacto de nuevo con el cliente de esta oportunidad. El motivo de cierre de esta oportunidad fue &apos;Interesa a medio plazo&apos;.</description>
        <dueDateOffset>60</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Pendiente</status>
        <subject>Recordatorio llamada No ingreso=Interesa a medio plazo</subject>
    </tasks>
    <tasks>
        <fullName>Solicitar_datos_de_Facturaci_n</fullName>
        <assignedToType>owner</assignedToType>
        <description>El cliente hace 3 días que ha ingresado y la etapa de la oportunidad aún está en Preingreso. Por favor, complimente los datos de facturación y actualice la etapa de esta oportunidad a &apos;Ingreso&apos;</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Pendiente</status>
        <subject>Solicitar datos de Facturación</subject>
    </tasks>
</Workflow>
