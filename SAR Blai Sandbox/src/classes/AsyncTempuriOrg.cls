//Generated by wsdl2apex

public class AsyncTempuriOrg {
    public class CreateServiceResponse_elementFuture extends System.WebServiceCalloutFuture {
        public tempuriOrgSarBackofficeinterfaceWcf.ReturnMessage getValue() {
            tempuriOrg.CreateServiceResponse_element response = (tempuriOrg.CreateServiceResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.CreateServiceResult;
        }
    }
    public class GetInvoicesInformationByPeriodResponse_elementFuture extends System.WebServiceCalloutFuture {
        public tempuriOrg.ArrayOfInvoiceInformationResponse getValue() {
            tempuriOrg.GetInvoicesInformationByPeriodResponse_element response = (tempuriOrg.GetInvoicesInformationByPeriodResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GetInvoicesInformationByPeriodResult;
        }
    }
    public class SendResidentCodeToSalesForceResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            tempuriOrg.SendResidentCodeToSalesForceResponse_element response = (tempuriOrg.SendResidentCodeToSalesForceResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.SendResidentCodeToSalesForceResult;
        }
    }
    public class CreateContractResponse_elementFuture extends System.WebServiceCalloutFuture {
        public tempuriOrgSarBackofficeinterfaceWcf.ReturnMessage getValue() {
            tempuriOrg.CreateContractResponse_element response = (tempuriOrg.CreateContractResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.CreateContractResult;
        }
    }
    public class CreateNOCResponse_elementFuture extends System.WebServiceCalloutFuture {
        public tempuriOrgSarBackofficeinterfaceWcf.ReturnMessage getValue() {
            tempuriOrg.CreateNOCResponse_element response = (tempuriOrg.CreateNOCResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.CreateNOCResult;
        }
    }
    public class SendCustomerCodeToSalesForceResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            tempuriOrg.SendCustomerCodeToSalesForceResponse_element response = (tempuriOrg.SendCustomerCodeToSalesForceResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.SendCustomerCodeToSalesForceResult;
        }
    }
    public class CreateCustomerResponse_elementFuture extends System.WebServiceCalloutFuture {
        public tempuriOrgSarBackofficeinterfaceWcf.ReturnMessage getValue() {
            tempuriOrg.CreateCustomerResponse_element response = (tempuriOrg.CreateCustomerResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.CreateCustomerResult;
        }
    }
    public class CreateResidentResponse_elementFuture extends System.WebServiceCalloutFuture {
        public tempuriOrgSarBackofficeinterfaceWcf.ReturnMessage getValue() {
            tempuriOrg.CreateResidentResponse_element response = (tempuriOrg.CreateResidentResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.CreateResidentResult;
        }
    }
    public class CreateInvoicesSyncResponse_elementFuture extends System.WebServiceCalloutFuture {
        public tempuriOrg.ArrayOfInvoiceReturnMessage getValue() {
            tempuriOrg.CreateInvoicesSyncResponse_element response = (tempuriOrg.CreateInvoicesSyncResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.CreateInvoicesSyncResult;
        }
    }
    public class GetInvoicesInformationByCodeResponse_elementFuture extends System.WebServiceCalloutFuture {
        public tempuriOrg.ArrayOfInvoiceInformationResponse getValue() {
            tempuriOrg.GetInvoicesInformationByCodeResponse_element response = (tempuriOrg.GetInvoicesInformationByCodeResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.GetInvoicesInformationByCodeResult;
        }
    }
    public class CreateInvoicesAsyncResponse_elementFuture extends System.WebServiceCalloutFuture {
        public tempuriOrg.ArrayOfInvoiceReturnMessage getValue() {
            tempuriOrg.CreateInvoicesAsyncResponse_element response = (tempuriOrg.CreateInvoicesAsyncResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.CreateInvoicesAsyncResult;
        }
    }
    public class SendContractCodeToSalesForceResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            tempuriOrg.SendContractCodeToSalesForceResponse_element response = (tempuriOrg.SendContractCodeToSalesForceResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.SendContractCodeToSalesForceResult;
        }
    }
    public class CreatePrescriptorResponse_elementFuture extends System.WebServiceCalloutFuture {
        public tempuriOrgSarBackofficeinterfaceWcf.ReturnMessage getValue() {
            tempuriOrg.CreatePrescriptorResponse_element response = (tempuriOrg.CreatePrescriptorResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.CreatePrescriptorResult;
        }
    }
    public class SendContactCodeToSalesForceResponse_elementFuture extends System.WebServiceCalloutFuture {
        public String getValue() {
            tempuriOrg.SendContactCodeToSalesForceResponse_element response = (tempuriOrg.SendContactCodeToSalesForceResponse_element)System.WebServiceCallout.endInvoke(this);
            return response.SendContactCodeToSalesForceResult;
        }
    }
    public class AsyncbasicEndpoint {
        public String endpoint_x = 'http://81.47.204.12:5070/NavisionInterface.svc';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/', 'tempuriOrg', 'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface', 'tempuriOrgSarBackofficeinterfaceWcf'};
        public AsyncTempuriOrg.CreateServiceResponse_elementFuture beginCreateService(System.Continuation continuation,tempuriOrgSarBackofficeinterfaceWcf.ServiceRequest serviceData) {
            tempuriOrg.CreateService_element request_x = new tempuriOrg.CreateService_element();
            request_x.serviceData = serviceData;
            return (AsyncTempuriOrg.CreateServiceResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.CreateServiceResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/createService',
              'http://tempuri.org/',
              'CreateService',
              'http://tempuri.org/',
              'CreateServiceResponse',
              'tempuriOrg.CreateServiceResponse_element'}
            );
        }
        public AsyncTempuriOrg.GetInvoicesInformationByPeriodResponse_elementFuture beginGetInvoicesInformationByPeriod(System.Continuation continuation,tempuriOrg.InvoiceByPeriodInformationRequest invoicePeriod) {
            tempuriOrg.GetInvoicesInformationByPeriod_element request_x = new tempuriOrg.GetInvoicesInformationByPeriod_element();
            request_x.invoicePeriod = invoicePeriod;
            return (AsyncTempuriOrg.GetInvoicesInformationByPeriodResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.GetInvoicesInformationByPeriodResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/getInvoicesInformationByPeriod',
              'http://tempuri.org/',
              'GetInvoicesInformationByPeriod',
              'http://tempuri.org/',
              'GetInvoicesInformationByPeriodResponse',
              'tempuriOrg.GetInvoicesInformationByPeriodResponse_element'}
            );
        }
        public AsyncTempuriOrg.SendResidentCodeToSalesForceResponse_elementFuture beginSendResidentCodeToSalesForce(System.Continuation continuation,String residentID) {
            tempuriOrg.SendResidentCodeToSalesForce_element request_x = new tempuriOrg.SendResidentCodeToSalesForce_element();
            request_x.residentID = residentID;
            return (AsyncTempuriOrg.SendResidentCodeToSalesForceResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.SendResidentCodeToSalesForceResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/sendResidentCodeToSalesForce',
              'http://tempuri.org/',
              'SendResidentCodeToSalesForce',
              'http://tempuri.org/',
              'SendResidentCodeToSalesForceResponse',
              'tempuriOrg.SendResidentCodeToSalesForceResponse_element'}
            );
        }
        public AsyncTempuriOrg.CreateContractResponse_elementFuture beginCreateContract(System.Continuation continuation,tempuriOrgSarBackofficeinterfaceWcf.ContractRequest contractData) {
            tempuriOrg.CreateContract_element request_x = new tempuriOrg.CreateContract_element();
            request_x.contractData = contractData;
            return (AsyncTempuriOrg.CreateContractResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.CreateContractResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/createContract',
              'http://tempuri.org/',
              'CreateContract',
              'http://tempuri.org/',
              'CreateContractResponse',
              'tempuriOrg.CreateContractResponse_element'}
            );
        }
        public AsyncTempuriOrg.CreateNOCResponse_elementFuture beginCreateNOC(System.Continuation continuation,tempuriOrgSarBackofficeinterfaceWcf.NOCRequest prescriptorData) {
            tempuriOrg.CreateNOC_element request_x = new tempuriOrg.CreateNOC_element();
            request_x.prescriptorData = prescriptorData;
            return (AsyncTempuriOrg.CreateNOCResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.CreateNOCResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/createNOC',
              'http://tempuri.org/',
              'CreateNOC',
              'http://tempuri.org/',
              'CreateNOCResponse',
              'tempuriOrg.CreateNOCResponse_element'}
            );
        }
        public AsyncTempuriOrg.SendCustomerCodeToSalesForceResponse_elementFuture beginSendCustomerCodeToSalesForce(System.Continuation continuation,String customerID) {
            tempuriOrg.SendCustomerCodeToSalesForce_element request_x = new tempuriOrg.SendCustomerCodeToSalesForce_element();
            request_x.customerID = customerID;
            return (AsyncTempuriOrg.SendCustomerCodeToSalesForceResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.SendCustomerCodeToSalesForceResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/sendCustomerCodeToSalesForce',
              'http://tempuri.org/',
              'SendCustomerCodeToSalesForce',
              'http://tempuri.org/',
              'SendCustomerCodeToSalesForceResponse',
              'tempuriOrg.SendCustomerCodeToSalesForceResponse_element'}
            );
        }
        public AsyncTempuriOrg.CreateCustomerResponse_elementFuture beginCreateCustomer(System.Continuation continuation,tempuriOrgSarBackofficeinterfaceWcf.CustomerRequest customerData) {
            tempuriOrg.CreateCustomer_element request_x = new tempuriOrg.CreateCustomer_element();
            request_x.customerData = customerData;
            return (AsyncTempuriOrg.CreateCustomerResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.CreateCustomerResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/createCustomer',
              'http://tempuri.org/',
              'CreateCustomer',
              'http://tempuri.org/',
              'CreateCustomerResponse',
              'tempuriOrg.CreateCustomerResponse_element'}
            );
        }
        public AsyncTempuriOrg.CreateResidentResponse_elementFuture beginCreateResident(System.Continuation continuation,tempuriOrgSarBackofficeinterfaceWcf.ResidentRequest residentData) {
            tempuriOrg.CreateResident_element request_x = new tempuriOrg.CreateResident_element();
            request_x.residentData = residentData;
            return (AsyncTempuriOrg.CreateResidentResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.CreateResidentResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/createResident',
              'http://tempuri.org/',
              'CreateResident',
              'http://tempuri.org/',
              'CreateResidentResponse',
              'tempuriOrg.CreateResidentResponse_element'}
            );
        }
        public AsyncTempuriOrg.CreateInvoicesSyncResponse_elementFuture beginCreateInvoicesSync(System.Continuation continuation,tempuriOrgSarBackofficeinterfaceWcf.InvoiceRequest invoiceData) {
            tempuriOrg.CreateInvoicesSync_element request_x = new tempuriOrg.CreateInvoicesSync_element();
            request_x.invoiceData = invoiceData;
            return (AsyncTempuriOrg.CreateInvoicesSyncResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.CreateInvoicesSyncResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/createInvoicesSync',
              'http://tempuri.org/',
              'CreateInvoicesSync',
              'http://tempuri.org/',
              'CreateInvoicesSyncResponse',
              'tempuriOrg.CreateInvoicesSyncResponse_element'}
            );
        }
        public AsyncTempuriOrg.GetInvoicesInformationByCodeResponse_elementFuture beginGetInvoicesInformationByCode(System.Continuation continuation,tempuriOrg.ArrayOfInvoiceByCodeInformationRequest invoiceExternalDocumentNos) {
            tempuriOrg.GetInvoicesInformationByCode_element request_x = new tempuriOrg.GetInvoicesInformationByCode_element();
            request_x.invoiceExternalDocumentNos = invoiceExternalDocumentNos;
            return (AsyncTempuriOrg.GetInvoicesInformationByCodeResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.GetInvoicesInformationByCodeResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/getInvoicesInformationByCode',
              'http://tempuri.org/',
              'GetInvoicesInformationByCode',
              'http://tempuri.org/',
              'GetInvoicesInformationByCodeResponse',
              'tempuriOrg.GetInvoicesInformationByCodeResponse_element'}
            );
        }
        public AsyncTempuriOrg.CreateInvoicesAsyncResponse_elementFuture beginCreateInvoicesAsync(System.Continuation continuation,tempuriOrgSarBackofficeinterfaceWcf.InvoiceRequest invoiceData) {
            tempuriOrg.CreateInvoicesAsync_element request_x = new tempuriOrg.CreateInvoicesAsync_element();
            request_x.invoiceData = invoiceData;
            return (AsyncTempuriOrg.CreateInvoicesAsyncResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.CreateInvoicesAsyncResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/createInvoicesAsync',
              'http://tempuri.org/',
              'CreateInvoicesAsync',
              'http://tempuri.org/',
              'CreateInvoicesAsyncResponse',
              'tempuriOrg.CreateInvoicesAsyncResponse_element'}
            );
        }
        public AsyncTempuriOrg.SendContractCodeToSalesForceResponse_elementFuture beginSendContractCodeToSalesForce(System.Continuation continuation,String externalContractID,String contractCode) {
            tempuriOrg.SendContractCodeToSalesForce_element request_x = new tempuriOrg.SendContractCodeToSalesForce_element();
            request_x.externalContractID = externalContractID;
            request_x.contractCode = contractCode;
            return (AsyncTempuriOrg.SendContractCodeToSalesForceResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.SendContractCodeToSalesForceResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/sendContractCodeToSalesForce',
              'http://tempuri.org/',
              'SendContractCodeToSalesForce',
              'http://tempuri.org/',
              'SendContractCodeToSalesForceResponse',
              'tempuriOrg.SendContractCodeToSalesForceResponse_element'}
            );
        }
        public AsyncTempuriOrg.CreatePrescriptorResponse_elementFuture beginCreatePrescriptor(System.Continuation continuation,tempuriOrgSarBackofficeinterfaceWcf.PrescriptorRequest prescriptorData) {
            tempuriOrg.CreatePrescriptor_element request_x = new tempuriOrg.CreatePrescriptor_element();
            request_x.prescriptorData = prescriptorData;
            return (AsyncTempuriOrg.CreatePrescriptorResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.CreatePrescriptorResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/createPrescriptor',
              'http://tempuri.org/',
              'CreatePrescriptor',
              'http://tempuri.org/',
              'CreatePrescriptorResponse',
              'tempuriOrg.CreatePrescriptorResponse_element'}
            );
        }
        public AsyncTempuriOrg.SendContactCodeToSalesForceResponse_elementFuture beginSendContactCodeToSalesForce(System.Continuation continuation,String contactID) {
            tempuriOrg.SendContactCodeToSalesForce_element request_x = new tempuriOrg.SendContactCodeToSalesForce_element();
            request_x.contactID = contactID;
            return (AsyncTempuriOrg.SendContactCodeToSalesForceResponse_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncTempuriOrg.SendContactCodeToSalesForceResponse_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'http://tempuri.org/SAR.BackOfficeInterface.WCF.WebService/NavisionInterface/sendContactCodeToSalesForce',
              'http://tempuri.org/',
              'SendContactCodeToSalesForce',
              'http://tempuri.org/',
              'SendContactCodeToSalesForceResponse',
              'tempuriOrg.SendContactCodeToSalesForceResponse_element'}
            );
        }
    }
}