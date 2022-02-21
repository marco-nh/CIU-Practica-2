//Autor: Marco Nehuen Hernández Abba
//importar camara


import peasy.*;
//importar animacion
import gifAnimation.*;

// División de cada cara (2pi/ang)
int ang;
PVector[][] p;

//figura
PShape ps;
//camara 
PeasyCam camera;

//cantidad de puntos
int tam;

boolean activado;
boolean finalizado;
boolean barrido;

int shape;

int tutorial;

//grabar
GifMaker ficherogif;

void setup(){
  size(1600,900,P3D);
  background(0);
  stroke(255);
  ang = 20;
  
  activado = false;
  finalizado = false;
  
  // camera
  camera = new PeasyCam(this,width/2,height/2,0,height*0.86);
  camera.setActive(false);
  
  tam = 0;
  p = new PVector[500][640];
  ps = createShape();
  shape = 10;
  
  tutorial = 1;
  
  //gif
  //ficherogif = new GifMaker(this, "animacion.gif");
  //ficherogif.setRepeat(0);        // anima sin fin
}

void draw(){
  //este background limpia el HUD del programa
  background(0);
  if (barrido == true){
    borrado();
    
  }
  
  //transladar al medio los puntos para el solido de revolucion
  translate(width/2, 0);
  //cuando se pulsa ESPACIO, se activa... dibuja la figura
  if(activado == true){
    if(finalizado == false){
      //recorre cada punto, y las rotaciones de cada punto durante 2pi
      //lo almacena en PVector()
      for(int i = 0; i < tam; i++){
        PVector v = p[i][0];
        float x = v.x;
        float y = v.y;
        float z = v.z;
        for(int c = 0; c < ang; c++){
         float angulo = map(c,0,ang-1,PI,-PI);
         float x2 = x * cos(angulo) - z * sin(angulo);
         float z2 = x * sin(angulo) + z * cos(angulo);
         //point(x2,y,z2);
         p[i][c] = new PVector(x2,y,z2);
        }
      }
    }
    
    
    background(0);
    dibujar();
    shape(ps);
   
  }
  fill(255,0,0);
  stroke(255,0,0);
  rect(-1,0,2,height);
  stroke(255);
  fill(0);
  
  // inciso PeasyCam
  camera.beginHUD();
  fill(255);
  
  
  //tutorial
  if (tutorial < 6){
    tutorial();
  } else{
    text("H - Tutorial",30,60);
    text("Tipo de malla:",30,400);
    if(shape == 10){
      text("TRIANGULO",30,430);
    } else{
      text("CUADRADO",30,430);
    }
    text("Numero de caras por linea: ",30,460);
    text(ang-1,30,490);
  }
  if (activado == true){
    textAlign(CENTER);
    fill(150);
    text("R - Reiniciar figura",width/2,height-120);
    fill(255);
    textAlign(LEFT);
  }
  text("ESC - Salir de la aplicación",30,80);
  textSize(30);
  
  text("Creador de objetos tridimensionales a partir de puntos",30,30); 
  textSize(20);
  fill(0); 
  camera.endHUD();
  //
  
  if(activado == false){
    trayecto();
  }
  //ficherogif.setDelay(1000/30);
  //ficherogif.addFrame();
}

void mousePressed(){
  //añadir puntos con el click izquierdo
  if (mouseButton == LEFT && finalizado == false){
    //evitar el exceso de la cantidad de puntos máxima
    if(tam < 500){
      if(mouseX >= width/2){
        //tutorial: paso 1,2 y 3
        if (tutorial < 3){
          tutorial++;
        }
        //coge los puntos, teniendo en cuenta el translate
        float btX = mouseX-(width/2);
        float btY = mouseY;
        textSize(20);
        fill(255);
        //los almacena en la primera columna de cada matriz, [0][0] [1][0] ... [tam-1][0]
        p[tam][0] = new PVector(btX,btY,0);
        //a efecto visual se marca el punto
        
        //aumenta el tamaño
        tam++;
      }
    }  
  }
}
void keyPressed(){
  //con espacio se activa la camara
  if(key == ' '){
    //con una linea vale
    if(tam > 1){
       activado = true;
       camera.setActive(true);
    }
    //tutorial: paso 3,4
    if (tutorial == 3 || tutorial == 4){
          tutorial++;
    }
  }
  //caras por cada linea dibujada
  if(keyCode == UP){
    if(ang < 640){
      ang *= 2;
      finalizado = false;
      ps = createShape();
    }
    
  }
  if(keyCode == DOWN){
    if(ang > 5){
      ang /= 2;
      finalizado = false;
      ps = createShape();
    }
    
  }
  
  //modo TRIANGLE_STRIP o QUAD_STRIP
  if(keyCode == RIGHT){
    if (shape == 10){
      shape = 18;
    } else{
      shape = 10;
    }
    
    finalizado = false;
    ps = createShape();
  }
  
  //reiniciar la figura y la camara
  if((key == 'r' || key == 'R') && finalizado == true){
       barrido = true;
       ps = createShape();
       p = new PVector[200][640];
       tam = 0;
       //desactivar valores
       activado = false;
       finalizado = false;
       barrido = true;
       //desactivar camara
       camera.setActive(false);
       camera.reset();
       //recolocar camara (por si alguien decide aumentar o disminuir el tamaño de pantalla de la aplicación)
       camera.lookAt(width/2,height/2,0,height*0.86);
       
       if (tutorial == 5){
         tutorial = 6;  
       }
  }
  
  if (key == 'q' || key == 'Q'){
    tutorial = 6;  
  }
  if (key == 'h' || key == 'H'){
    if(tutorial < 2 || tutorial > 4){
      tutorial = 1;  
    }
  }
  //FINALIZA GIF
  if (key == 'g'){
    //ficherogif.finish();   
  }
}

//dibujar() permite crear los vertices para la figura (PSHAPE)
void dibujar(){
   if(finalizado == false){
     for(int i = 0; i < tam-1; i++){
     
       ps.beginShape(shape);
       ps.fill(255);
       ps.stroke(0);
       for(int j = 0; j < ang; j++){
         PVector v1 = p[i][j];
         ps.vertex(v1.x,v1.y,v1.z);
         PVector v2 = p[i+1][j];
         ps.vertex(v2.x,v2.y,v2.z);
       }
       ps.endShape();
     }
     stroke(255);
   }
   
   finalizado = true;
}

//trayecto almacena para proposito visual el recorrido cuando creas los puntos.
void trayecto(){
  fill(255);
  for (int i = 0; i < tam-1; i++){
    PVector tr = p[i][0];
    PVector tr2 = p[i+1][0];

    line(tr.x,tr.y,tr2.x,tr2.y);
  }
  
  for(int i = 0; i < tam; i++){
    PVector tr = p[i][0];
    point(tr.x, tr.y);
  }
  if(tam > 0){
    PVector tr = p[tam-1][0];
    float btX = mouseX-(width/2);
    float btY = mouseY;
    line(tr.x,tr.y,btX,btY);
  }
  
}

//evitar el sobredibujado de la linea roja con la camara reiniciada
void borrado(){
    // si se ha reseteado la rotacion, desactiva el borrado
    if(camera.getRotations()[0] == 0 && camera.getRotations()[1] == 0 && camera.getRotations()[2] == 0){
      barrido = false;
    }
    background(0);
}

void tutorial(){
  //FASE 1: Dibujar primer punto
  //FASE 2: Dibujar segundo punto,... (ya se puede usar modos de trazado y cantidad de lineas por cara)
  //FASE 3: Generar el objeto
  //FASE 4: Modo de malla y cantidad de caras por linea
  //FASE 5: Camara
  textSize(30);
  fill(255,200,0);
  switch (tutorial){
    case 1:
    text("Tutorial: Parte 1/5",30,110);
    text("Pulsa click izquierdo",30,140);
    text("al lado derecho de la ",30,170);
    fill(255,0,0);
    text("linea",300,170);
    fill(255,200,0);
    text("para generar un punto",30,200);
    break;
    
    case 2:
    text("Tutorial: Parte 2/5",30,110);
    text("Pulsa click izquierdo",30,140);
    text("de nuevo para",30,170);
    text("hacer una línea",30,200);
    
    break;
    
    case 3:
    text("Tutorial: Parte 3/5",30,110);
    text("Puedes hacer más lineas.",30,140);
    text("Cuando crees estar listo",30,180);
    text("ESPACIO - Generar el objeto 3D.",30,210);
    
    break;
    case 4:
    text("Tutorial: Parte 4/5",30,110);
    text("FLECHA DERECHA: ",30,150);
    text("cambiar tipo de mallado",30,180);
    text("FLECHA ARRIBA/ABAJO:",30,220);
    text("subir/bajar cantidad de ",30,250);
    text("caras de la malla por linea creada",30,280);
    text("ESPACIO - Siguiente parte",30,350);
    
    break;
    case 5:
    text("Tutorial: Parte 5/5",30,110);
    text("Manten click izquierdo para rotar la figura",30,140);
    text("Manten click central para mover la figura",30,170);
    text("Usa la rueda del raton para hacer zoom",30,210);
    text("Pulsa R para reiniciar la figura",30,250);
    text("y acabar el tutorial",30,280);
    break;
    
  }
  fill(255);
  textSize(20);
  
  text("Q - Saltar el tutorial",30,60);
}
