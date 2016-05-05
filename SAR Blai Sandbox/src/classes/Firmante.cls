public class Firmante {
   
    private String name;
    private String DNI;
    private String email;
    
    public Firmante(String n, String dni){
        this.name = n;
        this.DNI = dni;
        this.email = '';
    }
    
    public Firmante(String n, String dni, String email){
        this.name = n;
        this.DNI = dni;
        this.email = email;
    }    
    
    public String getName(){
        return name;
    }
    
    public String getDNI(){
        return DNI;
    }
    
    public String getEmail(){
        return email;
    }
    
}