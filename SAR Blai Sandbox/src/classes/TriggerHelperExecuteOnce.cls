/** 
* File Name:   TriggerHelperExecuteOnce 
* Description: Classe auxiliar que disposa de variables i funcions de control
perquè els triggers s'executin només una vegada.
* Copyright:   Konozca 
* @author:     Xavier Garcia
* Modification Log 
* =============================================================== 
*Version	Date     	Author           Modification 
* 01		29/01/2014  Xavier Garcia
* =============================================================== 
**/
public with sharing class TriggerHelperExecuteOnce {
    public static boolean firstRun1=true;
    public static boolean firstRun2=true;
    public static boolean firstRun3=true;
    public static boolean firstRun4=true;
    public static boolean firstRun5=true;
    public static boolean firstRun6=true;
    public static boolean firstRun7=true;
    public static boolean firstRun8=true;
    public static boolean firstRun9=true;
    public static boolean firstRun10=true;
    public static boolean firstRun11=true;
    public static boolean firstRun12=true;
    public static boolean firstRun13=true;
    public static boolean firstRun14=true;
    public static boolean  executar1 (){
        if(firstRun1){
     		firstRun1=false;
     		return true;
        }else{
            return firstRun1;
        }
	}
    public static boolean  executar2 (){
        if(firstRun2){
     		firstRun2=false;
     		return true;
        }else{
            return firstRun2;
        }
	}
    public static boolean  executar3 (){
        if(firstRun3){
     		firstRun3=false;
     		return true;
        }else{
            return firstRun3;
        }
	}
    public static boolean  executar4 (){
        if(firstRun4){
     		firstRun4=false;
     		return true;
        }else{
            return firstRun4;
        }
	}
    public static boolean  executar5 (){
        if(firstRun5){
     		firstRun5=false;
     		return true;
        }else{
            return firstRun5;
        }
	}
    public static boolean  executar6 (){
        if(firstRun6){
     		firstRun6=false;
     		return true;
        }else{
            return firstRun6;
        }
	}
    public static boolean  executar7 (){
        if(firstRun7){
     		firstRun7=false;
     		return true;
        }else{
            return firstRun7;
        }
	}
    public static boolean  executar8 (){
        if(firstRun8){
     		firstRun8=false;
     		return true;
        }else{
            return firstRun8;
        }
	}
    public static boolean  executar9 (){
        if(firstRun9){
     		firstRun9=false;
     		return true;
        }else{
            return firstRun9;
        }
	}
    public static boolean  executar10 (){
        if(firstRun10){
     		firstRun10=false;
     		return true;
        }else{
            return firstRun10;
        }
	}
    public static boolean executar11() {
        if(firstRun11){
     		firstRun11=false;
     		return true;
        }else{
            return firstRun11;
        }
    }
     public static boolean executar12() {
        if(firstRun12){
     		firstRun12=false;
     		return true;
        }else{
            return firstRun12;
        }
    }
    public static boolean executar13() {
        if(firstRun13){
     		firstRun13=false;
     		return true;
        }else{
            return firstRun13;
        }
    }
    public static boolean executar14() {
        if(firstRun14){
     		firstRun14=false;
     		return true;
        }else{
            return firstRun14;
        }
    }
}