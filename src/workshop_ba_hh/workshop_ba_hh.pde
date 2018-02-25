/*
 * WORKSHOP
 * ______ _       _ _        _       ___  ___         _ _            
 * |  _  (_)     (_) |      | |      |  \/  |        | (_)           
 * | | | |_  __ _ _| |_ __ _| | ___  | .  . | ___  __| |_  ___ _ __  
 * | | | | |/ _` | | __/ _` | |/ _ \ | |\/| |/ _ \/ _` | |/ _ \ '_ \ 
 * | |/ /| | (_| | | || (_| | |  __/ | |  | |  __/ (_| | |  __/ | | |
 * |___/ |_|\__, |_|\__\__,_|_|\___| \_|  |_/\___|\__,_|_|\___|_| |_|
 *           __/ |                                                   
 *          |___/
 *
 * von Alexander Lehmann & Thorge Wandrei
 * an der Brand Academy - Hamburg 24.-25.2.2018
 *
 * -------
 *
 * Bitte in diesem Tab nichts am Code verändern, sonst läuft er später nicht mehr.
 * Dafür dürft ihr im nächsten Tab, YOUR_PROJECT, so viel experimentieren, wie ihr wollt.
 * Kaputt machen könnt ihr eh nichts, ist ja digital. ;)
 * Sprecht uns bei Fragen, oder wenn ihr Hilfe braucht, gerne sofort an.
 * Happy hacking!
 */


import ddf.minim.*;
Minim minim;
Performer hello;
PFont config;

void settings() {
  fullScreen(P3D);
}

void setup() {
  minim = new Minim(this);
  hello = new Hello();
  hello.setupEvents(this);
  hello.initialize();
  hello.rewind();
  config = createFont(sketchPath() + "/config/config.ttf", min(height, width) * 0.2);
}

void draw() {
  pushMatrix();
  hello.draw();
  popMatrix();
  osd();
}

abstract class Performer {
  protected AudioPlayer sample;
  protected float audioSum;
  protected PShape frame;
  protected long startTime; 
  protected PVector position, movement, rotation;
  protected ArrayList<Shape> shapes;
  protected PFont font, layoutFont;
  protected float deltaTime, lastTime;
  protected Table keyStrokes, keyStrokesRecording;
  protected int replayIndex;
  protected String tableName = "recording.csv";

  int SPACE = 32;
  int W = 87;
  int A = 65;
  int S = 83;
  int D = 68;
  int F = 70;
  int G = 71;

  protected void draw() {
  }

  public void setupEvents(PApplet parent) {
    parent.registerMethod("keyEvent", this);
  }

  public void keyEvent(KeyEvent event) {
    if (event.getAction() == KeyEvent.PRESS) {
      if (keyCode == 49) { // 1-Taste
        rewind();
      } else if (keyCode == 50) { // 2-Taste, speichern
        consolidateTables();
        saveTable(keyStrokes, "recording/" + tableName);
        rewind();
      } else if (keyCode == 51) { // 3-Taste, speichern
        keyStrokes = new Table();
        keyStrokesRecording = new Table();
        saveTable(keyStrokes, "recording/" + tableName);
        rewind();
      } else {
        TableRow newStroke = keyStrokesRecording.addRow();
        newStroke.setString(0, nf(int(getTime()), 6));
        newStroke.setString(1, str(keyCode));
        keyEvent(keyCode);
      }
    }
  }

  protected void keyEvent(int key) {
  }

  long getTime() {
    return millis() - startTime;
  }

  void initialize() {
    keyStrokes = new Table();
    keyStrokes.addColumn("time");
    keyStrokes.addColumn("key");
    String[] filesInFolder = new File(sketchPath() + "/recording/").list();
    if (filesInFolder.length > 0) {
      keyStrokes = loadTable("recording/" + tableName, "header");
    }
    keyStrokesRecording = new Table();
    textMode(SHAPE);
    delay(1000);
  }

  void rewind() {
    consolidateTables();
    replayIndex = 0;
    audioSum = 0;
    lastTime = 0;
    position = new PVector(0, 0, 0);
    rotation = new PVector(0, 0, 0);
    shapes = new ArrayList();
    sample.rewind();
    sample.play();
    startTime = millis();
  }

  void calculateDeltaTime() {
    deltaTime = getTime() - lastTime;
    lastTime = getTime();
  }

  void replayKeyStrokes() {
    for (int i = replayIndex; i < keyStrokes.getRowCount(); i++) {
      TableRow currentStroke = keyStrokes.getRow(i);
      if (currentStroke.getLong(0) < getTime()) {
        keyEvent(int(currentStroke.getString(1)));
        replayIndex = i+1;
      } else {
        break;
      }
    }
  }

  void consolidateTables() {
    for (int i = 0; i < keyStrokesRecording.getRowCount(); i++) {
      TableRow row = keyStrokesRecording.getRow(i);
      keyStrokes.addRow(row);
    }

    keyStrokesRecording = new Table();
    keyStrokesRecording.addColumn("time");
    keyStrokesRecording.addColumn("key");
    keyStrokes.sort(0);
  }

  abstract class Shape {
    protected PVector pos;
    protected long initTime;

    public void draw() {
    }
  }
}

float easing(float p, int type) {
  switch (type) {
  default:
  case 0:
    return Linear(p);
  case 1:
    return QuadraticEaseIn(p);
  case 2:
    return QuadraticEaseOut(p);
  case 3:
    return QuadraticEaseInOut(p);
  case 4:
    return ElasticEaseIn(p);
  case 5:
    return ElasticEaseOut(p);
  case 6:
    return ElasticEaseInOut(p);
  case 7:
    return BounceEaseOut(p);
  case 8:
    return BackEaseOut(p);
  case 9:
    return BackEaseInOut(p);
  }
}

float Linear(float p) {
  return p;
}

float QuadraticEaseIn(float p) {
  return p * p;
}

float QuadraticEaseOut(float p) {
  return -(p * (p - 2));
}

float QuadraticEaseInOut(float p) {
  if (p < 0.5f) {
    return 2 * p * p;
  } else {
    return (-2 * p * p) + (4 * p) - 1;
  }
}

float ElasticEaseIn(float p) {
  return sin(13 * HALF_PI * p) * pow(2, 10 * (p - 1));
}

float ElasticEaseOut(float p) {
  return sin(-13 * HALF_PI * (p + 1)) * pow(2, -10 * p) + 1;
}

float ElasticEaseInOut(float p) {
  if (p < 0.5f) {
    return 0.5f * sin(13 * HALF_PI * (2 * p)) * pow(2, 10 * ((2 * p) - 1));
  } else {
    return 0.5f * (sin(-13 * HALF_PI * ((2 * p - 1) + 1)) * pow(2, -10 * (2 * p - 1)) + 2);
  }
}

float BackEaseOut(float p) {
  float f = (1 - p);
  return 1 - (f * f * f - f * sin(f * PI));
}

float BackEaseInOut(float p) {
  if (p < 0.5f) {
    float f = 2 * p;
    return 0.5f * (f * f * f - f * sin(f * PI));
  } else {
    float f = (1 - (2*p - 1));
    return 0.5f * (1 - (f * f * f - f * sin(f * PI))) + 0.5f;
  }
}

float BounceEaseIn(float p) {
  return 1 - BounceEaseOut(1 - p);
}

float BounceEaseOut(float p) {
  if (p < 4/11.0f) {
    return (121 * p * p)/16.0f;
  } else if (p < 8/11.0f) {
    return (363/40.0f * p * p) - (99/10.0f * p) + 17/5.0f;
  } else if (p < 9/10.0f) {
    return (4356/361.0f * p * p) - (35442/1805.0f * p) + 16061/1805.0f;
  } else {
    return (54/5.0f * p * p) - (513/25.0f * p) + 268/25.0f;
  }
}

float BounceEaseInOut(float p)
{
  if (p < 0.5f) {
    return 0.5f * BounceEaseIn(p*2);
  } else {
    return 0.5f * BounceEaseOut(p * 2 - 1) + 0.5f;
  }
}

class OSD {
  String text;
  public long time;

  OSD(String text) {
    this.text = text;
    time = millis();
  }

  void show() {
    noStroke();
    rectMode(CORNER);
    fill(#000000, 128);
    rect(0, 0, width, height);
    textFont(config);
    textAlign(CENTER, CENTER);
    fill(#ffffff);
    text(text, width / 2, height / 2);
  }
}

ArrayList<OSD> screens = new ArrayList();

void keyPressed() {
  if (key == '1') {
    screens.add(new OSD("REWIND"));
  }
  if (key == '2') {
    screens.add(new OSD("SAVED"));
  }
  if (key == '3') {
    screens.add(new OSD("ERASED"));
  }
}

void osd() {
  for (int i = screens.size()-1; i >= 0; i--) {
    OSD screen = screens.get(i);
    screen.show();

    if (screen.time + 500 < millis()) {
      screens.remove(i);
    }
  }
}