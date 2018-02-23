import ddf.minim.*;
Minim minim;
Performer performer;
PWindow photoDisplay;

void settings() {
  fullScreen(P3D, 2);
  size(1920, 1080, P3D);
}

void setup() {
  minim = new Minim(this);
  photoDisplay = new PWindow();
  init('1');
}


void draw() {
  performer.draw();
}

void keyPressed() {
  init(key);
}

void init(char key) {
  minim.stop();
  minim.dispose();

  switch (key) {
  case '1':
    performer = new Hello1();
    performer.tableName = "test1.csv";
    photoDisplay.loadPhoto(sketchPath() + "/photos/1.png");
    break;
  case '2':
    performer = new Hello2();
    performer.tableName = "test2.csv";
    photoDisplay.loadPhoto(sketchPath() + "/photos/2.png");
    break;
  case '3':
    break;
  case '4':
    break;
  }

  performer.initialize();
  performer.rewind();
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
  public String tableName = "recording.csv";

  protected void draw() {
  }

  public void setupEvents(PApplet parent) {
    parent.registerMethod("keyEvent", this);
  }

  public void keyEvent(KeyEvent event) {
    if (event.getAction() == KeyEvent.PRESS) {
      if (key == 'q') {
        rewind();
      } else if (key == 's') {
        consolidateTables();
        saveTable(keyStrokes, "recording/" + tableName);
        rewind();
      } else {
        TableRow newStroke = keyStrokesRecording.addRow();
        newStroke.setString(0, nf(int(getTime()), 6));
        newStroke.setString(1, str(key));
        keyEvent(key);
      }
    }
  }

  protected void keyEvent(char key) {
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
        keyEvent(currentStroke.getString(1).charAt(0));
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