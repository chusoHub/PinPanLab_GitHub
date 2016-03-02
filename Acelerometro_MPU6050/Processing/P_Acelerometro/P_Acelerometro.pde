import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
String textError="";
Serial myPort1=null;  // The serial port1
int BAUD_RATE=9600;
boolean serialInited;
boolean conectado_d1 = false;
PrintWriter output=null;
int winW             = 750;   // Window Width
int winH             = 600;   // Window Height
String nameCSV="";
String [] CoorFunc;
float [][] CoorFuncAcum=new float[650][6];
int lastMillis=0;
float floatNaN=Float.NaN;
int index=0;
import controlP5.*;
ControlP5 cp5;
color c = color(0, 160, 100);
boolean AbrirExcel=false;
boolean CerrarExcel=false;
boolean pinta=false;
//Drops para puertos seriales
ScrollableList d1;
Button BotExcelAbrir, BotExcelCerrar;
//Textos de error para puertos seriales
Textlabel myTextlabelSeriald1, myTextlabelTitulo;
Textfield myTextLeyenda1, myTextLeyenda2, myTextLeyenda3;

void setup() {
  size(750, 600);
  background(200);
  noStroke();
  smooth();
  frameRate(50);
  cp5 = new ControlP5(this);
  PintaTitulo ();
  PintarBotExcel();
  PintaTextLeyenda();
  PintaSeriales();
  PintaInfo();
};

void draw() {
  background(200);

  //fondo blaco para botón excel
  strokeWeight(0);
  fill(255, 255, 255);
  stroke(255, 255, 255);
  rectMode(CORNERS);
  rect(0, 0, winW, 51);
  rect(499, 59, 651, 101);

  PintaSistema();

  if (conectado_d1 == true) {

    if (myPort1.available ()>0) {
      myString = myPort1.readStringUntil(lf);

      if (myString != null) {
        CoorFunc = split(myString, ';');
        if (CoorFunc[0].equals("acelerometro") == true) {
          /*CoorFunc[2]=CoorFunc[2].replace(",", ".");
           CoorFunc[3]=CoorFunc[3].replace(",", ".");
           CoorFunc[4]=CoorFunc[4].replace(",", ".");
           */
          if (index<50) {
            index ++;
          } else {
            for (int i = 1; i <= index; i = i+1) {
              CoorFuncAcum[i-1][1]= CoorFuncAcum[i][1];
              CoorFuncAcum[i-1][2]= CoorFuncAcum[i][2];
              CoorFuncAcum[i-1][3]= CoorFuncAcum[i][3];
            }
          }
          CoorFuncAcum[index][1]=float(trim(CoorFunc[2]));
          CoorFuncAcum[index][2]=float(trim(CoorFunc[3]));
          CoorFuncAcum[index][3]=float(trim(CoorFunc[4]));
          strokeWeight(1.5);
          for (int k = 1; k <= index; k = k+1) {
            stroke(255, 0, 0);
            line(13*(k-1)+50, round(350-CoorFuncAcum[k-1][1]*150/4), 13*k+50, round(350-CoorFuncAcum[k][1]*150/4));
            stroke(0, 255, 0);
            line(13*(k-1)+50, round(350-CoorFuncAcum[k-1][2]*150/4), 13*k+50, round(350-CoorFuncAcum[k][2]*150/4));
            stroke(0, 0, 255);
            line(13*(k-1)+50, round(350-CoorFuncAcum[k-1][3]*150/4), 13*k+50, round(350-CoorFuncAcum[k][3]*150/4));
          }
          myTextLeyenda1.setText(CoorFunc[2]);
          myTextLeyenda2.setText(CoorFunc[3]);
          myTextLeyenda3.setText(CoorFunc[4]);

          if (output!=null) {
            escribeExcel();
          }
        }
      } else {
        strokeWeight(1.5);
        for (int k = 1; k <= index; k = k+1) {
          stroke(255, 0, 0);
          line(13*(k-1)+50, round(350-CoorFuncAcum[k-1][1]*150/4), 13*k+50, round(350-CoorFuncAcum[k][1]*150/4));
          stroke(0, 255, 0);
          line(13*(k-1)+50, round(350-CoorFuncAcum[k-1][2]*150/4), 13*k+50, round(350-CoorFuncAcum[k][2]*150/4));
          stroke(0, 0, 255);
          line(13*(k-1)+50, round(350-CoorFuncAcum[k-1][3]*150/4), 13*k+50, round(350-CoorFuncAcum[k][3]*150/4));
        }
      }
    } else {
      strokeWeight(1.5);
      for (int k = 1; k <= index; k = k+1) {
        stroke(255, 0, 0);
        line(13*(k-1)+50, round(350-CoorFuncAcum[k-1][1]*150/4), 13*k+50, round(350-CoorFuncAcum[k][1]*150/4));
        stroke(0, 255, 0);
        line(13*(k-1)+50, round(350-CoorFuncAcum[k-1][2]*150/4), 13*k+50, round(350-CoorFuncAcum[k][2]*150/4));
        stroke(0, 0, 255);
        line(13*(k-1)+50, round(350-CoorFuncAcum[k-1][3]*150/4), 13*k+50, round(350-CoorFuncAcum[k][3]*150/4));
      }
    };
  };
};

void PintaInfo() {
  Group g1 = cp5.addGroup("Info")
    .setPosition(50, 80)
    .setSize(50, 10)
    .setBackgroundHeight(0)
    .setColorBackground(color(40))
    //.setBackgroundColor(color(0))

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
    +" Bluetooth JYMCU-HC06"+char(10)
    +" Acelerómetro MPU6050 "+char(10)
    +" El arduino debe tener el correspondiente programa cargado"+char(10)
    +" El arduino con el acelerómetro se conecta al ordenador vía Bluetooth o USB y se abre éste programa." +char(10)
    +" Cuando se cambien las conexiones USB hay que cerrar y abrir el programa."+char(10)
    +" Una vez abierto el programa:"+char(10)
    +"    1º Se selecciona el puerto del acelerómetro."+char(10)
    +"    2º Se abre el Excel (CSV)."+char(10)
    +"    3º Se guarda el Excel (CSV). El archivo queda guardado en el mismo directorio del programa. Nombre del archivo:"+char(10)
    +"        'dataProcess_añomesdía_horaminutosegundo.csv'   El archivo se abre automáticamente."+char(10)
    +" ****************************************************************"+char(10)
    +" ***       Archivo Excel (CSV)                                          ***"+char(10)
    +" ****************************************************************"+char(10)
    +" Formato:"+ char(10)
    +" Tiempo en microsegundos | Aceleración Eje X (G) | Aceleración Eje Y (G) | Aceleración Eje Z (G) "+ char(10)
    +" ****************************************************************"+char(10)
    +" ***      Comunicación interna 'Processing - Arduino'     ***"+char(10)
    +" ***      Formatos de entrada y salida                             ***"+char(10)
    +" ****************************************************************"+char(10)
    +" Formato de entrada del puerto del acelerómetro:"+char(10)
    +" La primera palabra de cada línea es fija: 'acelerometro', después viene el  tiempo en microsegundos y luego vienen los  valores  de la aceleración en X, Y y Z en G." +char(10)
    +" Los campos están separados por ';' y de una línea a otra se pasa por salto de línea Char(10)."+char(10)
    +" Es decir:"+char(10)
    +" acelerómetro;tEnMicrosegundos;AcelXen G; AcelYen; AcelZen"+char(10)
    +" Ej.:"+char(10)
    +" acelerómetro;1000000;0,12;0,27;0,89"+char(10)
    );
};

void PintaTitulo() {
  String titulo="Acelerómetro 3 ejes";
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
    .setPosition(500, 60)
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

void PintaTextLeyenda() {
  myTextLeyenda1=cp5.addTextfield("TextLeyenda1")
    .setPosition(600, 127)
    .setSize(100, 18)
    .setFont(createFont("arial", 10))
    .setColor(color(0, 0, 0))
    .setColorBackground(color(255))
    .setAutoClear(false)
    .setCaptionLabel("") 
    .lock()
    ;
  myTextLeyenda2=cp5.addTextfield("TextLeyenda2")
    .setPosition(600, 147)
    .setSize(100, 18)
    .setFont(createFont("arial", 10))
    .setColor(color(0, 0, 0))
    .setColorBackground(color(255))
    .setAutoClear(false)
    .setCaptionLabel("") 
    .lock()
    ;
  myTextLeyenda3=cp5.addTextfield("TextLeyenda3")
    .setPosition(600, 167)
    .setSize(100, 18)
    .setFont(createFont("arial", 10))
    .setColor(color(0, 0, 0))
    .setColorBackground(color(255))
    .setAutoClear(false)
    .setCaptionLabel("") 
    .lock()
    ;
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
  textSize(10);
  fill(0, 0, 0);
  strokeWeight(1.5);
  stroke(255, 50, 20);     
  line(380, 135, 420, 135);
  stroke(0, 255, 0);     
  line(380, 155, 420, 155);
  stroke(0, 0, 255);     
  line(380, 175, 420, 175);
  text("Aceleración en el eje X en G", 440, 140);
  text("Aceleración en el eje Y en G", 440, 160);
  text("Aceleración en el eje Z en G", 440, 180);


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
  text("4", 35, 200);
  stroke(200, 200, 200);
  line(50, 237, 700, 237);
  text("3", 35, 237);
  line(50, 275, 700, 275);
  text("2", 35, 275);
  line(50, 312, 700, 312);
  text("1", 35, 312);
  line(50, 350, 700, 350);
  text("0", 35, 350);
  line(50, 387, 700, 387);
  text("-1", 30, 387);
  line(50, 425, 700, 425);
  text("-2", 30, 425);
  line(50, 462, 700, 462);
  text("-3", 30, 462);
  text("-4", 30, 500);
};



void escribeExcel() {
  //println(CoorFunc[1].replace(".", ",")+";"+CoorFunc[2].replace(".", ",")+";"+CoorFunc[3].replace(".", ",")+";"+trim(CoorFunc[4].replace(".", ",")));
  output.println( CoorFunc[1].replace(".", ",")+";"+CoorFunc[2].replace(".", ",")+";"+CoorFunc[3].replace(".", ",")+";"+trim(CoorFunc[4].replace(".", ",")));
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
    //print("tiempo en microsegundos;acelX en G;acelY en G; acelZ en G");
    output.println( "tiempo en microsegundos;acelX en G;acelY en G; acelZ en G" );
    BotExcelAbrir.setCaptionLabel("Cerrar Excel y Guardar");
    AbrirExcel=false;
    CerrarExcel=true;
  } else {
    if (CerrarExcel==true) {
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
    } else {
      AbrirExcel=true;
    }
  };
};