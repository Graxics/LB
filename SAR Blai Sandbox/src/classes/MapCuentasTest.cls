@isTest
private class MapCuentasTest {

    static testMethod void myUnitTest() {
        MapCuentas mc = new MapCuentas();
    	String A = mc.getCuenta('1679');
        Map<String,String> mp = mc.getMap();
    }
    
	
}