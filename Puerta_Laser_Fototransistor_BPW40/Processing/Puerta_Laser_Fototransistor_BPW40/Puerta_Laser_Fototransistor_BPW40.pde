//Programa para PinPanLab Jesús Vicente
import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
String textError="";
Serial myPort1=null;  // The serial port1
int BAUD_RATE=9600;
boolean serialInited;
boolean conectado_d1 = false;
boolean primeravez=true;
PrintWriter output=null;
int winW             = 750;   // Window Width
int winH             = 600;   // Window Height
String [] CoorFunc;
float [][] CoorFuncAcum=new float[650][6];
String nameCSV="";
String Puerta1Ant="0";
String Puerta2Ant="0";
String Puerta3Ant="0";
String Puerta4Ant="0";
String Puerta5Ant="0";
float VelRPS=0;
float escala1=1;
float escala2=0.5;

float floatNaN=Float.NaN;
String StrVelRPS="0";
int index=0;
import controlP5.*;
ControlP5 cp5;
color c = color(0, 160, 100);
boolean AbrirExcel=false;
boolean CerrarExcel=false;
//Drops para puertos seriales
ScrollableList d1;
Button BotExcelAbrir;
//Textos de error para puertos seriales
Textlabel myTextlabelSeriald1, myTextlabelTitulo, myTextlabelLeyenda, myTextlabelPuerta1,  myTextlabelPuerta2, myTextlabelPuerta3, myTextlabelPuerta4, myTextlabelPuerta5,myTextlabelTiempos;
Textfield myTextPasos, myTextPuerta1A, myTextPuerta1C, myTextPuerta2A, myTextPuerta2C, myTextPuerta3A, myTextPuerta3C, myTextPuerta4A, myTextPuerta4C, myTextPuerta5A, myTextPuerta5C;

void setup() {

  // List all the available serial ports
  //println(Serial.list());
  size(750, 600);
  background(200);
  noStroke();
  smooth();
  frameRate(30);
  cp5 = new ControlP5(this);

  PintaTitulo ();
  PintarBotExcel();
  PintaCampos();
  PintaSeriales();
  PintaInfo();
  primeravez=true;
  
};

void draw() {
  background(200);
  strokeWeight(0);
  fill(255, 255, 255);
  stroke(255, 255, 255);
  rectMode(CORNERS);
  rect(0, 0, winW, 51);
  rect(499, 69, 651, 111);
  
  //PintaSistema();
  
  if (conectado_d1 == true) {
    
    if (myPort1.available ()>0) {
      myString = myPort1.readStringUntil(lf);
      
      if (myString != null) {
        CoorFunc = split(myString, ';');
        if (CoorFunc[0].substring(0,6).equals("Puerta") == true ){

          if(CoorFunc[0].equals("Puerta1") == true){ 
      
            if(trim(CoorFunc[2]).equals("0") == true){
              
              myTextPuerta1A.setText(CoorFunc[1].replace('.',','));
              Puerta1Ant="0";
          }else{
            if(trim(CoorFunc[2]).equals("1") == true){
              myTextPuerta1C.setText(CoorFunc[1].replace('.',','));
              Puerta1Ant="1";  
          }
            }
            //Puerta1Ant=trim(CoorFunc[2]);
            if (output!=null) {
             escribeExcel();
            };
          };
          if(CoorFunc[0].equals("Puerta2") == true){ 
      
            if(trim(CoorFunc[2]).equals("0") == true){
              
              myTextPuerta2A.setText(CoorFunc[1].replace('.',','));
              Puerta2Ant="0";  
          }else{
            if(trim(CoorFunc[2]).equals("1") == true){
              myTextPuerta2C.setText(CoorFunc[1].replace('.',','));
              Puerta2Ant="1";
            }
            }
            //Puerta2Ant=trim(CoorFunc[2]);
            if (output!=null) {
             escribeExcel();
            };
          };
          if(CoorFunc[0].equals("Puerta3") == true){ 
      
            if(trim(CoorFunc[2]).equals("0") == true){
              
              myTextPuerta3A.setText(CoorFunc[1].replace('.',','));
              Puerta3Ant="0";  
          }else{
            if(trim(CoorFunc[2]).equals("1") == true){
              myTextPuerta3C.setText(CoorFunc[1].replace('.',','));
              Puerta3Ant="1";
            }
            }
            //Puerta3Ant=trim(CoorFunc[2]);
            if (output!=null) {
             escribeExcel();
            };
          };
          if(CoorFunc[0].equals("Puerta4") == true){ 
      
            if(trim(CoorFunc[2]).equals("0") == true){
              
              myTextPuerta4A.setText(CoorFunc[1].replace('.',','));
              Puerta4Ant="0";  
          }else{
            if(trim(CoorFunc[2]).equals("1") == true){
              myTextPuerta4C.setText(CoorFunc[1].replace('.',','));
              Puerta4Ant="1";
            }
            }
            //Puerta4Ant=trim(CoorFunc[2]);
            if (output!=null) {
             escribeExcel();
            };
          };
          if(CoorFunc[0].equals("Puerta5") == true){ 
      
            if(trim(CoorFunc[2]).equals("0") == true){
              
              myTextPuerta5A.setText(CoorFunc[1].replace('.',','));
              Puerta5Ant="0";
            }else{
            if(trim(CoorFunc[2]).equals("1") == true){
              myTextPuerta5C.setText(CoorFunc[1].replace('.',','));
              Puerta5Ant="1";
            }
            }
            //Puerta5Ant=trim(CoorFunc[2]);
            if (output!=null) {
             escribeExcel();
            };
          };

};
      };
    };
  };
};

void PintaInfo() {
  Group g1 = cp5.addGroup("Info")
    .setPosition(50, 80)
    .setSize(50, 10)
    .setBackgroundHeight(0)
    .setColorBackground(color(40))

    ;
  g1.close();
  g1.setHeight(19);
  g1.setCaptionLabel("INFO");
  g1.getCaptionLabel().getStyle().setMarginTop(3);
  g1.getCaptionLabel().getStyle().setMarginLeft(3);
  g1.getCaptionLabel().setFont(createFont("arial", 9));

  cp5.addTextarea("txt")
    .setPosition(0, 0)
    .setSize(650, 430)
    .setFont(createFont("arial", 11))
    .setLineHeight(14)
    .setColor(color(0))
    .setColorBackground(color(255))
    .setColorForeground(color(255))
    .setGroup(g1)
    .setText(
                       " ******************************"+char(10)
                      +" ***      Modo de uso      ***"+char(10)
                      +" ****************************** "+char(10)
                      +" Las puertas fotoeléctricas se consideran cerradas si el laser llega al receptor y abiertas si no llega." +char(10)
                      +" El programa recoge cunado se abre y se cierra cada puerta." +char(10)
                      +" Se pueden leer hasta 5 puertas simultáneamente." +char(10)
                      +" Para empezar se conecta el arduino con las puertas fotoelectricas, al ordenador vía USB." +char(10)
                      +" Cuando se cambien las conexiones USB hay que cerrar y abrir el programa."+char(10)
                      +" Una vez abierto el programa:"+char(10)
                      +"    1º Se selecciona el puerto."+char(10)
                      +"    2º Se abre el Excel (CSV)."+char(10)
                      +"    3º Se guarda Excel (CSV). El archivo queda guardado en el mismo directorio del programa. Nombre del archivo: " +char(10)
                      +"        'dataProcess_añomesdía_horaminutosegundo.csv'   El archivo se abre automáticamente."+char(10)
                      +" ****************************************************************"+char(10)
                      +" ***       Archivo Excel (CSV)                                          ***"+char(10)
                      +" ****************************************************************"+char(10)
                      +" Formato:"+ char(10)
                      +" Tiempo en microsegundos|estado puerta 1 ('1' cerrada o '0' abierta)|estado puerta 2|estado puerta 3|estado puerta 4|estado puerta 5 " + char(10)
                      +" ****************************************************************"+char(10)
                      +" ***      Comunicación interna 'Processing - Arduino'     ***"+char(10)
                      +" ***      Formatos de entrada y salida                             ***"+char(10)
                      +" ****************************************************************"+char(10)
                      +" Formato de entrada del puerto:"+char(10)
                      +" La primera palabra es la puerta que cambia de estado 'Puerta1'o 'Puerta2' o 'Puerta3' o 'Puerta4' o'Puerta5' después viene el  tiempo en microsegundos y después el estado de la puerta ('1' cerrada y '0' abierta)." +char(10)
                      +" Los campos están separados por ';' y de una línea a otra se pasa por salto de línea Char(10)."+char(10)
                      +" Es decir:"+char(10)
                      +" Tiempo en microsegundos|Nombre de la puerta que cambia de estado ('Puerta1' o 'Puerta2' o 'Puerta3' o 'Puerta4' o 'Puerta5') | Estado de la puerta ('1' cerrada o '0' abierta)" + char(10)
                      +" Ej.:"+char(10)
                      +" Puerta1;1000000;0"+char(10)
                      );
};

void PintaTitulo() {
  String titulo="Puertas fotoeléctricas";
  myTextlabelTitulo = cp5.addTextlabel("labelTitulo")
    .setText(titulo)
    .setPosition((winW - titulo.length()*17)/2, 0)
    .setColorValue(0x00000000)
    .setFont(createFont("Caarial blacklibri", 35))
    ;
  cp5.addTextlabel("labelPrograma")
    .setText("PinPanLab")
    .setPosition(winW - 150, winH - 60)
    .setColorValue(0x00000000)
    .setFont(createFont("arial black", 20))
    ;
  cp5.addTextlabel("labelFirma")
    .setText("Jesús Vicente")
    .setPosition(winW - 130, winH - 30)
    .setColorValue(0x00000000)
    .setFont(createFont("arial", 15))
    ;
            
};

void PintarBotExcel() {


  BotExcelAbrir= cp5.addButton("Crear_Excel_y_grabar")
    .setValue(100)
    .setPosition(500, 70)
    .setSize(150, 40)
    .setColorActive(color(150, 255, 150))
    .setColorForeground(color(0, 255, 0))
    .setColorBackground(color(100, 200, 100))
    ;
    
  BotExcelAbrir.setColorLabel(color(50, 50, 50));
  BotExcelAbrir.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  BotExcelAbrir.setCaptionLabel("Crear Excel y Grabar");
  BotExcelAbrir.getCaptionLabel().setFont(createFont("arial black", 9));
  BotExcelAbrir.show();
};

void PintaCampos(){
 myTextlabelTiempos = cp5.addTextlabel("myTextlabelTiempos")
    .setText("Tiempos en microgundos")
      .setPosition(250, 145)
        .setColor(0)
          .setFont(createFont("Arial", 25))
            ;
  myTextlabelLeyenda = cp5.addTextlabel("myTextlabelLeyenda")
    .setText("                                     ÚLTIMA VEZ ABIERTA                 ÚLTIMA VEZ CERRADA")
      .setPosition(80, 200)
        .setColor(0)
          .setFont(createFont("Arial", 15))
            ;
  myTextlabelPuerta1 = cp5.addTextlabel("Pueta1")
    .setText("Puerta 1: Conector 3")
      .setPosition(50, 250)
        .setColor(0)
          .setFont(createFont("Arial", 15))
            ;
            
  myTextPuerta1A=cp5.addTextfield("myTextPuerta1A")
    .setPosition(240, 245)
      .setSize(150, 30)
        .setFont(createFont("arial", 15))
          .setColor(color(0, 0, 0))
            .setColorBackground(color(255))
              .setAutoClear(false)
              .setCaptionLabel("") 
              .lock()
              .setText("0")
                ;
    myTextPuerta1C=cp5.addTextfield("myTextPuerta1C")
    .setPosition(465, 245)
      .setSize(150, 30)
        .setFont(createFont("arial", 15))
          .setColor(color(0, 0, 0))
            .setColorBackground(color(255))
              .setAutoClear(false)
              .setCaptionLabel("") 
              .lock()
              .setText("0")
                ;
  myTextlabelPuerta2 = cp5.addTextlabel("Pueta2")
    .setText("Puerta 2: Conector 4")
      .setPosition(50, 300)
        .setColor(0)
          .setFont(createFont("Arial", 15))
            ;
            
  myTextPuerta2A=cp5.addTextfield("myTextPuerta2A")
    .setPosition(240, 295)
      .setSize(150, 30)
        .setFont(createFont("arial", 15))
          .setColor(color(0, 0, 0))
            .setColorBackground(color(255))
              .setAutoClear(false)
              .setCaptionLabel("") 
              .lock()
              .setText("0")
                ;
                
    myTextPuerta2C=cp5.addTextfield("myTextPuerta2C")
    .setPosition(465, 295)
      .setSize(150, 30)
        .setFont(createFont("arial", 15))
          .setColor(color(0, 0, 0))
            .setColorBackground(color(255))
              .setAutoClear(false)
              .setCaptionLabel("") 
              .lock()
              .setText("0")
                ;
   myTextlabelPuerta3 = cp5.addTextlabel("Pueta3")
    .setText("Puerta 3: Conector 5")
      .setPosition(50, 350)
        .setColor(0)
          .setFont(createFont("Arial", 15))
            ;
            
  myTextPuerta3A=cp5.addTextfield("myTextPuerta3A")
    .setPosition(240, 345)
      .setSize(150, 30)
        .setFont(createFont("arial", 15))
          .setColor(color(0, 0, 0))
            .setColorBackground(color(255))
              .setAutoClear(false)
              .setCaptionLabel("") 
              .lock()
              .setText("0")
                ;
    myTextPuerta3C=cp5.addTextfield("myTextPuerta3C")
    .setPosition(465, 345)
      .setSize(150, 30)
        .setFont(createFont("arial", 15))
          .setColor(color(0, 0, 0))
            .setColorBackground(color(255))
              .setAutoClear(false)
              .setCaptionLabel("") 
              .lock()
              .setText("0")
                ;
 /* myTextlabelPuerta4 = cp5.addTextlabel("Pueta4")
    .setText("Puerta 4")
      .setPosition(50, 400)
        .setColor(0)
          .setFont(createFont("Arial", 15))
            ;
            
  myTextPuerta4A=cp5.addTextfield("myTextPuerta4A")
    .setPosition(210, 395)
      .setSize(150, 30)
        .setFont(createFont("arial", 15))
          .setColor(color(0, 0, 0))
            .setColorBackground(color(255))
              .setAutoClear(false)
              .setCaptionLabel("") 
              .lock()
              .setText("0")
                ;
    myTextPuerta4C=cp5.addTextfield("myTextPuerta4C")
    .setPosition(465, 395)
      .setSize(150, 30)
        .setFont(createFont("arial", 15))
          .setColor(color(0, 0, 0))
            .setColorBackground(color(255))
              .setAutoClear(false)
              .setCaptionLabel("") 
              .lock()
              .setText("0")
                ;
 myTextlabelPuerta5 = cp5.addTextlabel("Pueta5")
    .setText("Puerta 5")
      .setPosition(50, 450)
        .setColor(0)
          .setFont(createFont("Arial", 15))
            ;
            
  myTextPuerta5A=cp5.addTextfield("myTextPuerta5A")
    .setPosition(210, 445)
      .setSize(150, 30)
        .setFont(createFont("arial", 15))
          .setColor(color(0, 0, 0))
            .setColorBackground(color(255))
              .setAutoClear(false)
              .setCaptionLabel("") 
              .lock()
              .setText("0")
                ;
    myTextPuerta5C=cp5.addTextfield("myTextPuerta5C")
    .setPosition(465, 445)
      .setSize(150, 30)
        .setFont(createFont("arial", 15))
          .setColor(color(0, 0, 0))
            .setColorBackground(color(255))
              .setAutoClear(false)
              .setCaptionLabel("") 
              .lock()
              .setText("0")
                ;
                */
};

void PintaSeriales() {
  //println(Serial.list().length);
  Textlabel myTextlabelSerial;
  myTextlabelSerial = cp5.addTextlabel("labelSerial")
    .setText("- Seleccionar puerto:")
    .setPosition(25, 95)
    .setColorValue(0x00000000)
    .setFont(createFont("Arial", 15))
    ;
  myTextlabelSeriald1 = cp5.addTextlabel("labelSeriald1")
    .setText("No conectado")
    .setPosition(50, 120)
    .setColorValue(0xffff0000)
    .setFont(createFont("arial", 10))
    ;
  d1 = cp5.addScrollableList("myList-d1", 50, 140, 100, 300)
    .setColorBackground(color(40))
    .setItemHeight(25)
    .setBarHeight(20)
    ;
  d1.setCaptionLabel("Puerto - A");
  d1.getCaptionLabel().getStyle().setMarginTop(3); 
  d1.getCaptionLabel().getStyle().setMarginLeft(3);
  d1.getCaptionLabel().setFont(createFont("arial", 9));

  for (int i=0; i<Serial.list ().length; i++) {
    d1.addItem(Serial.list()[i], i);
  }
  d1.addItem("Desconectar", Serial.list().length);
  d1.close();
  d1.setColorActive(color(255, 128));
};


void PintaSistema() {
  //leyenda
  textSize(12);
  fill(0, 0, 0);
  strokeWeight(2);
  stroke(255,0, 0);     
  line(460, 175, 500, 175);

  fill(0, 0, 0);
  text("Vueltas", 530, 180);


  //graphBox
  strokeWeight(0);
  //stroke(255, 255, 255);
  fill(150, 150, 150);
  rectMode(CORNERS);
  rect(48, 198, 702, 502);
  fill(255, 255, 255);
  rectMode(CORNERS);
  rect(50, 200, 700, 500);
  //Eje Ordenadas
  fill(0, 0, 0);
  strokeWeight(1);
  stroke(200, 200, 200);
  text(str(escala1*10).replace('.',','), 25, 200);
  line(50, 230, 700, 230);
  text(str(escala1*9).replace('.',','), 25, 230);
  line(50, 260, 700, 260);
  text(str(escala1*8).replace('.',','), 25, 260);
  line(50, 290, 700, 290);
  text(str(escala1*7).replace('.',','), 25, 290);
  line(50, 320, 700, 320);
  text(str(escala1*6).replace('.',','), 25, 320);
  line(50, 350, 700, 350);
  text(str(escala1*5).replace('.',','), 25, 350);
  line(50, 380, 700, 380);
  text(str(escala1*4).replace('.',','), 25, 380);
  line(50, 410, 700, 410);
  text(str(escala1*3).replace('.',','), 25, 410);
  line(50, 440, 700, 440);
  text(str(escala1*2).replace('.',','), 25, 440);
  line(50, 470, 700, 470);
  text(str(escala1*1).replace('.',','), 25, 470);
  text(str(escala1*0).replace('.',','), 25, 500);
  
  /*
  fill(0, 0, 255);
  text(str(escala2*10).replace('.',','), 710, 200);
  text(str(escala2*9).replace('.',','), 710, 230);
  text(str(escala2*8).replace('.',','), 710, 260);
  text(str(escala2*7).replace('.',','), 710, 290);
  text(str(escala2*6).replace('.',','), 710, 320);
  text(str(escala2*5).replace('.',','), 710, 350);
  text(str(escala2*4).replace('.',','), 710, 380);
  text(str(escala2*3).replace('.',','), 710, 410);
  text(str(escala2*2).replace('.',','), 710, 440);
  text(str(escala2*1).replace('.',','), 710, 470);
  text(str(escala2*0).replace('.',','), 710, 500);
  */
};



void escribeExcel() {
  //println( trim(CoorFunc[1].replace(".", ","))+";"+PasosAcumulados);
  output.println(trim(CoorFunc[1]).replace(".", ",")+";"+Puerta1Ant+";"+Puerta2Ant+";"+Puerta3Ant);
};


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    //println(theEvent.getController().getName()+" event from group : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    if (theEvent.getController().getName()=="myList-d1") {
      if (myPort1!=null) {//desconectar
        myPort1.stop();
        myPort1 = null;
        textError="";
        conectado_d1=false;
        myTextlabelSeriald1.setText("Desconectado");
        index=0;
      }
      if (theEvent.getController().getValue()<Serial.list().length) {//cuando es igual es para desconectar
        int i= int(theEvent.getController().getValue());
        try {
          myPort1 = new Serial(this, Serial.list()[i], BAUD_RATE);
          serialInited = true;
          textError="";
        } 
        catch (RuntimeException e) {
          textError=e.getMessage();
          //println(textError);
          myTextlabelSeriald1.setText(textError);
        };


        if (textError=="") {
          conectado_d1=true;
          myTextlabelSeriald1.setText("Conectado");
          myPort1.clear();
          myString = myPort1.readStringUntil(lf);
          myString = null;
        } else {
          conectado_d1=false;
          myPort1=null;
        };
      };
    };
  };
};

void Crear_Excel_y_grabar(int theValue) {
  if (AbrirExcel==true) {
    //println("a button event from colorA: "+theValue);
    nameCSV="dataProcess_"+year()+month()+day()+"_"+hour()+minute()+second()+".csv";
    //println(nameCSV);
    output = createWriter(nameCSV); 
    //print("tiempo en microsegundos;pasos");
    output.println( "tiempo en microsegundos;Puerta1 (0 abierta 1 cerrada);Puerta2 (0 abierta 1 cerrada);Puerta3 (0 abierta 1 cerrada);" );
    BotExcelAbrir.setCaptionLabel("Cerrar Excel y Guardar");
    AbrirExcel=false;
    CerrarExcel=true;
  }else{
    if(CerrarExcel==true){
       //println("a button event from colorA: "+theValue);
       output.flush();  // Writes the remaining data to the file
       output.close();  // Finishes the file
       output=null;
       BotExcelAbrir.setCaptionLabel("Crear Excel y Grabar");
       AbrirExcel=true;
       CerrarExcel=false;
      //println(dataPath(""));
      //println(sketchPath("")+nameCSV);
      launch(sketchPath("")+nameCSV);
       nameCSV="";
    }else{
      AbrirExcel=true;
    }
  };
};
//Programa para PinPanLab Jesús Vicente