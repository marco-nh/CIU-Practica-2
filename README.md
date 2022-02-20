# Memoria Practica 2 CIU - Prototipo que recoje puntos de un perfil del sólido de revolución
 Creado por Marco Nehuen Hernández Abba
 
 ![animacion](https://user-images.githubusercontent.com/47418876/154784343-57c93916-f4ab-4cf8-b4a6-e8f2dc8a8426.gif)

### Contenido
- Trabajo realizado
- Herramientas y Referencias

## Trabajo realizado
En esta aplicación puedes dibujar puntos por pantalla y servirán como el perfil del solido de revolución para generar objetos tridimensionales.
El codigo del programa se divide en tres secciones, no organizadas dentro del codigo pero si para el proposito de esta memoria.
### Interfaz
![image](https://user-images.githubusercontent.com/47418876/154868548-58e289d0-f362-4464-b63d-044342740864.png)
![image](https://user-images.githubusercontent.com/47418876/154868553-2bd97c16-ebb5-4b79-9eea-4f1162c367d8.png)

En primera instancia ves la linea de división necesaria para el funcionamiento del programa, atajos para ayuda del usuario y un tutorial con una letra de color llamativa que explica los pasos que tiene que hacer el usuario para el correcto uso de la aplicación.

He sustituido una pantalla con los controles por un tutorial interactivo que haga que el usuario aprenda los controles mientras los usa y siempre que tenga dudas puede acceder el tutorial pulsando H, también he añadido una tecla para saltarlo ya que el tutorial se ve cada vez que se ejecuta el programa.

Cuando se acaba el tutorial, pasa a verse la cantidad de caras por linea del objeto tridimensional (escrito para mayor comprensión del usuario de lo que esta haciendo en pantalla) y tipo de malla.

**Codigo de la interfaz**

```
void draw(){
  ...
  //linea divisoria roja
  fill(255,0,0);
  stroke(255,0,0);
  rect(-1,0,2,height);
  stroke(255);
  fill(0);
  
  ...
  
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
  
  ...
  
}
```
**Codigo del tutorial**
```
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
    
    //texto
    ...
    break;
    
    //texto
    ...
    
    case 5:
    text("Tutorial: Parte 5/5",30,110);
    //texto
    ...
    break;
    
  }
  fill(255);
  textSize(20);
  
  text("Q - Saltar el tutorial",30,60);
}
```
**Esquema del tutorial**

![image](https://user-images.githubusercontent.com/47418876/154868372-622cd5fb-b8a1-483d-b656-3c50b9a80e1a.png)

### Creacion del objeto tridimensional

Primero, se le pide al usuario que haga click como minimo 2 veces, con esa accion se almacenan al menos dos puntos, que en pantalla se ve como una linea, pero que en el programa no se usa.

Hay una variable boolean llamada **activado** que activa el algoritmo para crear el objeto.
Cuando se pulsa ENTER, **activado** pasa a true, permitiendo en draw() que empiece a recoger los clicks del usuario en la pantalla.

```
if(activado == true){
    if(finalizado == false){
      //recorre cada punto, y las rotaciones de cada punto durante 2pi
      //lo almacena en PVector()
      //tam es la cantidad de puntos en pantalla 
      //ang el que maneja cuanta sera la rotacion de cada punto hasta llegar acabar por el principio
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
```

La manera para generar el solido de revolución a partir del perfil es con la ecuacion de la guia de la practica 2,
se usa la función map() que permite generar el solido correctamente convirtiendo el 0 en -PI y ang-1 en PI.
```
float angulo = map(c,0,ang-1,PI,-PI);
```
![image](https://user-images.githubusercontent.com/47418876/154869499-2ed28a03-583b-4184-8c05-82a3d3203d53.png)


Una vez que acaba de recoger esos puntos y los almacena en un vector bidimensional de PVector (clase que recoge los valores x y z),
otra variable boolean llamado **finalizado** se activa, impidiendo que se recogan más clicks en pantalla despues de haber pulsado ENTER.
Posteriormente pasa a llamarse a la funcion dibujar(), que usa la variable de tipo PShape de la aplicación para generar la figura.

```
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
```

Todo se reiniciar cuando se pulsa la tecla R cuando se dibuja la figura.

## Herramientas y Referencias
**Gif Animator**

Para sacar el gif solicitado, con el siguiente codigo, comentado dentro de la practica.
```
void setup() {
  //gif
  //ficherogif = new GifMaker(this, "animacion.gif");
  //ficherogif.setRepeat(0);        // anima sin fin
}

void draw() {
  ...
  //ficherogif.setDelay(1000/60);
  //ficherogif.addFrame();
  }
```

**PeasyCam**

No era necesario el movimiento de la figura en pantalla, pero para permitir que se vea la figura mejor uso de la libreria para
generar una camara inactiva al recoger puntos y activa cuando se crea la figura.

Para poner la interfaz en esta practica, se uso beginHUD() para poner el texto y que no se moviese con la cámara.

```
void setup(){
 ...
 // camera
 camera = new PeasyCam(this,width/2,height/2,0,height*0.86);
 camera.setActive(false);
 ...
}

void draw(){
// inciso PeasyCam
camera.beginHUD();

//tutorial y los atajos en pantalla
...

camera.endHUD();
//
}

void keyPressed(){
  if(key == ' '){
    //con una linea vale
    if(tam > 1){
       activado = true;
       camera.setActive(true);
    }
    ...
  }
  //reiniciar la figura y la camara
  if((key == 'r' || key == 'R') && finalizado == true){
       ...
       camera.setActive(false);
       camera.reset();
       //recolocar camara (por si alguien decide aumentar o disminuir el tamaño de pantalla de la aplicación)
       camera.lookAt(width/2,height/2,0,height*0.86);
       ...
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

```

**Referencias**

 [Explicación practica 2](https://github.com/otsedom/otsedom.github.io/blob/main/CIU/P2/README.md)
 
 [Ejemplo recorrer mallas](https://youtu.be/RkuBWEkBrZA)

 [PeasyCam uso](https://mrfeinberg.com/peasycam/)
