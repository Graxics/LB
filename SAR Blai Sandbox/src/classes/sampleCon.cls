public class sampleCon {
String country = null;
    
    public PageReference test() {
    return null;
	}
    
    public List<SelectOption> getItems() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('US','tableta 1'));
    options.add(new SelectOption('CANADA','tableta 1'));
    options.add(new SelectOption('MEXICO','tableta 1')); 
    return options;
    }
    
    public String getCountry() {
    return country;
    }
    
    public void setCountry(String country) { this.country = country; }
    }