public class Hello extends Performer {

  /*
   * Willkommen in eurem Projekt!
   * Dieser Code unten ist eure kreative Sandbox für die nächsten Stunden.
   * Kaputt geht nichts, bei Fehlern meckert Processing von alleine
   * und sollte irgendwas gar nicht mehr gehen, basteln wir das schon wieder hin.
   *
   * Hier unten findet ihr erstmal jede Menge Paramter, mit denen man das Standard-Projekt,
   * das ihr bekommen habt, schon mal gewaltig aufhübschen kann.
   * Musik, Farben, Größen, Schriften, darum müsst ihr euch kümmern.
   * Dateien von euch, d. h. Schriften und Musik, kommen in den "data"-Ordner.
   * Nehmt euch einfach die Zeit zum tüfteln und im Zweifelsfall: Nachfragen.
   *
   * Grundsätzlich Makey Makey anschließen und performen!
   * Aber natürlich müsst ihr auch alles steuern können.
   * Das macht ihr mit drei Tasten auf eurer Tastatur:
   * Taste '1': Zurückspulen
   * Taste '2': Speichert eure Performance
   * Taste '3': Löschen des Speicherstands
   *
   * Viel Erfolg!
   */

  String NAME = "Alex";
  String TITLE = "The Less I Know The Better";
  String ARTIST = "Tame Impala";
  String TRACK_FILE = "tame.mp3";

  color BACKGROUND = #1B4079;
  color FRAME = #1B4079;
  float FRAME_MARGIN = 0.075;
  float COLOR_CHANGE_SPEED = 3.0;
  String LAYOUT_FONT_NAME = "layout-font.otf";
  color LAYOUT_FONT = #FAFAFA;
  float LAYOUT_FONT_SIZE = 0.017;

  float AUDIO_SMOOTH_FACTOR = 0.03;

  PVector MOVEMENT = new PVector(0, 0, -500);
  PVector OFFSET = new PVector(0, 0, -1000);

  color[] FLOATING_BACKGROUND = {#006E90, #3066BE};
  float FLOATING_BACKGROUND_SIZE = 0.5;
  float FLOATING_BACKGROUND_OFFSET = 1.0;
  float FLOATING_BACKGROUND_SPEED = 0.00001;
  float FLOATING_BACKGROUND_ROTATION = 1.0;
  int MOVEMENT_DETAIL = 3;

  String FONT_NAME = "brush.ttf";
  color FONT = #FAFAFA;
  float FONT_SIZE = 0.4;
  float WORD_DURATION = 0.4;

  color PRIMITIVE_FILL = #333333;
  float PRIMITIVE_FILL_VISIBILITY = 0.0;
  color PRIMITIVE_BORDER = #FFC857;
  float PRIMITIVE_BORDER_VISIBILITY = 1.0;
  float PRIMITIVE_BORDER_THICKNESS = 2.0;
  float PRIMITIVE_SIZE = 0.75;
  float PRIMITIVE_DURATION = 5.0;

  color BLOB_FILL = #333333;
  float BLOB_FILL_VISIBILITY = 0.0;
  color BLOB_BORDER = #FFC857;
  float BLOB_BORDER_VISIBILITY = 1.0;
  float BLOB_BORDER_THICKNESS = 2.0;
  float BLOB_SIZE = 0.1;
  float BLOB_DURATION = 1.0;
  float BLOB_OFFSET = 0.5;

  color PLANE = #FAFAFA;
  float PLANE_DURATION = 1.0;
  float PLANE_SCALE = 1.5;

  color SHUTTER = #FAFAFA;
  float SHUTTER_DURATION = 2.0;
  float SHUTTER_SCALE = 1.5;

  color WALL_FILL = #C5283D;
  float WALL_FILL_VISIBILITY = 1.0;
  color WALL_BORDER = #FFC857;
  float WALL_BORDER_VISIBILITY = 0.0;
  float WALL_BORDER_THICKNESS = 2.0;
  float WALL_SIZE = 0.75;
  float WALL_DURATION = 1.0;

  /*
   * Hier könnt ihr bestimmen, was passiert, wenn ihr Sachen am Makey Makey macht.
   * Im Grunde ist der Makey Makey wie eine Tastatur.
   * Die Tasten stehen alle auf dem Board.
   * Was dann passieren soll, das bestimmen die Funktionen.
   * Über die informieren wir euch aber.
   */

  void keyEvent(int key) {
    if (key == SPACE) {
      makeWall(4, 2);
    }
    if (key == LEFT) {
      makeWord("oooh", 1);
    }
    if (key == UP) {
      makeBlob(3);
    }
    if (key == RIGHT) {
      makeWord("nooo", 1);
    }
    if (key == DOWN) {
      makePlane(0);
    }
    if (key == W) {
      makeShutter(0);
    }
    if (key == A) {
      makePrimitive(3);
    }
    if (key == S) {
      makePrimitive(4);
    }
    if (key == D) {
      makePrimitive(5);
    }
    if (key == F) {
      movement.mult(-1);
    }
    if (key == G) {
      makeWall(2, 0);
    }
  }

  /*
   * Ab hier wird das alles ein bisschen trickreicher.
   * Spielt gerne mnit dem Code rum.
   * Im Grunde steht ab hier, was genau passiert.
   * Also, wie sich die Formen verhalten, wie sie konstruiert werden, etc.
   * Wenn ihr etwas bestimmtes möchtet und das nicht selbst hinbekommt:
   * Fragt uns einfach.
   * Wir haben hier Überblick.
   */

  void initialize() {
    super.initialize();
    noiseDetail(MOVEMENT_DETAIL);
    frame = createFrame();

    font = createFont(FONT_NAME, min(width, height));
    layoutFont = createFont(LAYOUT_FONT_NAME, min(width, height));
    sample = minim.loadFile(TRACK_FILE, 1024);
  }

  void rewind() {
    super.rewind();
    movement = MOVEMENT.copy();
  }

  void draw() {
    calculateDeltaTime();
    calculateRMS();
    replayKeyStrokes();

    hint(DISABLE_DEPTH_TEST);
    background(BACKGROUND);
    drawFloatingBackground();
    shape(frame);
    drawLayout();
    hint(ENABLE_DEPTH_TEST);

    moveCamera();
    drawShapes();
  }

  void moveCamera() {
    translate(width / 2, height / 2);
    float defaultCamDist = (height / 2.0) / tan(PI * 30.0 / 180.0);
    float proportionalCamDist = min(width, height) * tan(PI * 0.73);

    position.add(new PVector(
      movement.x * deltaTime / 1000.0, 
      movement.y * deltaTime / 1000.0, 
      movement.z * deltaTime / 1000.0
      ));

    //rotation.z = sin(getTime() * 0.001 * TWO_PI);
    //rotation.x = sin(getTime() * 0.0008) * 0.1;
    //rotation.y = cos(getTime() * 0.0008) * 0.1;
    //movement.z = sin(getTime() * 0.0085) * 10000;

    translate(0 - position.x, 0 - position.y, proportionalCamDist + defaultCamDist - position.z);
    rotateX(rotation.x);
    rotateY(rotation.y);
    rotateZ(rotation.z);
  }

  PShape createFrame() {
    PShape frame = createShape();
    float margin = min(height, width) * FRAME_MARGIN;

    frame.beginShape();
    frame.noStroke();
    frame.fill(FRAME);

    frame.vertex(0, 0);
    frame.vertex(width, 0);
    frame.vertex(width, height);
    frame.vertex(0, height);

    frame.beginContour();
    frame.vertex(0 + margin, 0 + margin);
    frame.vertex(0 + margin, height - margin);
    frame.vertex(width - margin, height - margin);
    frame.vertex(width - margin, 0 + margin);
    frame.endContour();

    frame.endShape();
    return frame;
  }

  void drawFloatingBackground() {
    rectMode(CENTER);
    noStroke();

    color currentColor = getColorFromArray(FLOATING_BACKGROUND);
    fill(currentColor);

    float rotation = noise(getTime() * FLOATING_BACKGROUND_SPEED + 0.44) * 12 * FLOATING_BACKGROUND_ROTATION;
    PVector offset = new PVector(
      (noise(getTime() * FLOATING_BACKGROUND_SPEED + 0.11) - 0.5) * width * FLOATING_BACKGROUND_OFFSET, 
      (noise(getTime() * FLOATING_BACKGROUND_SPEED + 3.43) - 0.5) * height * FLOATING_BACKGROUND_OFFSET, 
      noise(getTime() * FLOATING_BACKGROUND_SPEED + 2.77) * -min(width, height) * 0.5 * FLOATING_BACKGROUND_OFFSET * 0
      );

    pushMatrix();
    translate(offset.x + width / 2, offset.y + height / 2, offset.z);
    rotate(rotation);
    rect(0, 0, max(width, height) * (1 - audioSum) * FLOATING_BACKGROUND_SIZE, max(width, height) * (1 - audioSum) * FLOATING_BACKGROUND_SIZE);
    popMatrix();
  }

  void drawLayout() {    
    noStroke();
    textFont(layoutFont);
    textSize(LAYOUT_FONT_SIZE * min(height, width));
    textAlign(LEFT, BOTTOM);
    fill(LAYOUT_FONT);
    text(NAME + "\n" + TITLE + " by " + ARTIST, LAYOUT_FONT_SIZE * min(height, width), height - LAYOUT_FONT_SIZE * min(height, width));
  }

  void drawShapes() {
    for (int i = shapes.size()-1; i >= 0; i--) {
      Shape shape = shapes.get(i);
      shape.draw();
    }
  }

  color getColorFromArray(color[] colors) {
    int currentIndex = floor(getTime() * 0.001 / COLOR_CHANGE_SPEED) % colors.length;
    int nextIndex = (currentIndex + 1) % colors.length;
    float transition = map((getTime() * 0.001 / COLOR_CHANGE_SPEED) % colors.length, currentIndex, currentIndex + 1, 0, 1);
    return lerpColor(colors[currentIndex], colors[nextIndex], transition);
  }

  void calculateRMS() {
    audioSum = constrain(easing(abs(sample.left.get(0) * 4), 2) - audioSum, 0, 1) * AUDIO_SMOOTH_FACTOR + audioSum * (1 - AUDIO_SMOOTH_FACTOR);
  }

  class Primitive extends Shape {
    private PShape shape;

    public Primitive(int corners) {
      pos = PVector.add(position, OFFSET);
      corners = max(3, corners);
      makeShape(corners);
      initTime = getTime();
    }

    private void makeShape(int corners) {
      shape = createShape();

      shape.beginShape();
      shape.stroke(PRIMITIVE_BORDER, constrain(PRIMITIVE_BORDER_VISIBILITY, 0, 1) * 255);
      if (PRIMITIVE_FILL_VISIBILITY > 0.001) {
        shape.fill(PRIMITIVE_FILL, constrain(PRIMITIVE_FILL_VISIBILITY, 0, 1) * 255);
      } else {
        shape.noFill();
      }
      shape.strokeWeight(PRIMITIVE_BORDER_THICKNESS);

      for (int i = 0; i < corners; i++) {
        float x = sin(float(i) / corners * TWO_PI);
        float y = cos(float(i) / corners * TWO_PI);
        shape.vertex(x * PRIMITIVE_SIZE * min(width, height), y * PRIMITIVE_SIZE * min(width, height));
      }

      shape.endShape(CLOSE);
    }

    public void draw() {
      if (getTime() > initTime && getTime() < initTime + PRIMITIVE_DURATION * 1000) {
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        shape(shape);
        popMatrix();
      }
    }
  }

  void makePrimitive(int corners) {
    shapes.add(new Primitive(corners));
  }

  class Word extends Shape {
    private String text;
    private int effectType;

    public Word(String text, int effectType) {
      pos = PVector.add(position, OFFSET);
      this.text = text;
      this.effectType = effectType;
      initTime = getTime();
    }

    public void draw() {
      if (getTime() > initTime && getTime() < initTime + WORD_DURATION * 1000) {
        float effect = map(getTime(), initTime, initTime + WORD_DURATION * 1000, 1, 0);
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        noStroke();
        textFont(font);
        textAlign(CENTER, CENTER);
        fill(FONT, effect * 255);
        textSize(min(width, height) * FONT_SIZE);

        if (effectType == 1) {
          String effectText = "";
          for (int i = 0; i < text.length(); i++) {
            effectText += noise(getTime() * 0.0005 + i) > sq(effect) ? text.charAt(i) : "";
            effectText = effectText.length() > 0 ? effectText : str(text.charAt(0));
          }
          text(effectText, 0, 0);
        } else if (effectType == 2) {
          textSize(min(width, height) * FONT_SIZE * max(audioSum, 0.0001));
          text(text, 0, 0);
        } else if (effectType == 3) {
          String effectText = "";
          for (int i = 0; i < text.length(); i++) {
            if (sq(i / float(text.length()-1)) < audioSum) {
              effectText += text.charAt(i);
            }
          }
          text(effectText, 0, 0);
        } else if (effectType == 4) {
          textSize(min(width, height) * FONT_SIZE * easing(1 - effect, 7));
          text(text, 0, 0);
        } else {
          text(text, 0, 0);
        }
        popMatrix();
      }
    }
  }

  void makeWord(String text, int effectType) {
    shapes.add(new Word(text, effectType));
  }

  void makeWord(String text) {
    makeWord(text, 0);
  }

  class Plane extends Shape {
    int effectType;

    public Plane(int effectType) {
      initTime = getTime();
      this.effectType = effectType;
      pos = PVector.add(position, OFFSET);
    }

    public void draw() {
      if (getTime() > initTime && getTime() < initTime + PLANE_DURATION * 1000) {
        float effect = map(getTime(), initTime, initTime + PLANE_DURATION * 1000, 1, 0);
        noStroke();
        fill(PLANE, effect * 255);
        rectMode(CENTER);
        pushMatrix();
        translate(pos.x, pos.y, pos.z);

        if (effectType == 0) {
          rect(0, 0, width * PLANE_SCALE, height * PLANE_SCALE);
        }
        if (effectType == 1) {
          rect(0, 0, width * PLANE_SCALE * easing(1 - effect, 7), height * PLANE_SCALE * easing(1 - effect, 7));
        }
        if (effectType == 2) {
          rect(0, 0, width * PLANE_SCALE * easing(effect, 6), height * PLANE_SCALE * easing(1 - effect, 7));
        }
        if (effectType == 3) {
          rect(0, 0, width * PLANE_SCALE * tan(effect), height * PLANE_SCALE * tan(effect));
        }
        if (effectType == 4) {
          rect(0, 0, width * PLANE_SCALE * tan(1-effect), height * PLANE_SCALE * tan(1-effect));
        }

        popMatrix();
      }
    }
  }
  
  void makePlane(int effectType) {
    shapes.add(new Plane(effectType));
  }

  class Shutter extends Shape {
    int effectType;

    public Shutter(int effectType) {
      initTime = getTime();
      this.effectType = effectType;
    }

    public void draw() {
      if (getTime() > initTime && getTime() < initTime + SHUTTER_DURATION * 1000) {
        float effect = map(getTime(), initTime, initTime + SHUTTER_DURATION * 1000, 1, 0);
        noStroke();
        fill(SHUTTER, effect * 255);
        rectMode(CENTER);
        pushMatrix();
        translate(position.x, position.y, position.z);
        if (effectType == 0) {
          rect(0, 0, width * SHUTTER_SCALE, height * SHUTTER_SCALE);
        } else if (effectType == 1) {
          rect(width * 0.5 * easing(effect, 4), 0, width * SHUTTER_SCALE * 0.5, height * SHUTTER_SCALE);
        } else if (effectType == 2) {
          rect(-width * 0.5 * easing(effect, 4), 0, width * SHUTTER_SCALE * 0.5, height * SHUTTER_SCALE);
        } else if (effectType == 3) {
          rect(0, 0, width * SHUTTER_SCALE * easing(1-effect, 8), height * SHUTTER_SCALE * easing(1-effect, 8));
        } else if (effectType == 4) {
          rect(0, 0, width * SHUTTER_SCALE, height * SHUTTER_SCALE * easing(1-effect, 9));
        }
        popMatrix();
      }
    }
  }
  
  void makeShutter(int effectType) {
    shapes.add(new Shutter(effectType));
  }

  class Blob extends Shape {
    int effectType;
    PVector randomPosition;
    float random;

    public Blob(int effectType) {
      initTime = getTime();
      this.effectType = effectType;
      randomPosition = new PVector(random(-1, 1) * width * BLOB_OFFSET, random(-1, 1) * height * BLOB_OFFSET);
      random = random(10);
    }

    public void draw() {
      if (getTime() > initTime && getTime() < initTime + BLOB_DURATION * 1000) {
        float effect = map(getTime(), initTime, initTime + BLOB_DURATION * 1000, 1, 0);
        strokeWeight(BLOB_BORDER_THICKNESS);
        stroke(BLOB_BORDER, constrain(BLOB_BORDER_VISIBILITY, 0, 1) * 255 * effect);
        if (BLOB_FILL_VISIBILITY > 0.001) {
          fill(BLOB_FILL, constrain(BLOB_FILL_VISIBILITY, 0, 1) * 255 * effect);
        } else {
          noFill();
        }
        pushMatrix();
        translate(position.x + randomPosition.x, position.y + randomPosition.y, position.z);
        if (effectType == 0) {
          ellipse(0, 0, BLOB_SIZE * min(width, height) * easing(1-effect, 2), BLOB_SIZE * min(width, height) * easing(1-effect, 2));
        } else if (effectType == 1) {
          stroke(BLOB_BORDER, constrain(BLOB_BORDER_VISIBILITY, 0, 1) * 255);
          if (BLOB_FILL_VISIBILITY > 0.001) {
            fill(BLOB_FILL, constrain(BLOB_FILL_VISIBILITY, 0, 1) * 255);
          } else {
            noFill();
          }
          float mirror = effect > 0.5 ? map(effect, 1, 0.5, 0, 1) : map(effect, 0.5, 0, 1, 0);
          ellipse(0, 0, BLOB_SIZE * min(width, height) * easing(mirror, 2), BLOB_SIZE * min(width, height) * easing(mirror, 2));
        } else if (effectType == 2) {
          float mirror = effect > 0.5 ? map(effect, 1, 0.5, 0, 1) : map(effect, 0.5, 0, 1, 0);
          ellipse(0, 0, BLOB_SIZE * min(width, height) * easing(mirror, 5), BLOB_SIZE * min(width, height) * easing(mirror, 5));
        } else if (effectType == 3) {
          float mirror = effect > 0.5 ? map(effect, 1, 0.5, 0, 1) : map(effect, 0.5, 0, 1, 0);
          ellipse(0, 0, BLOB_SIZE * min(width, height) * easing(effect, 5), BLOB_SIZE * min(width, height) * easing(1-mirror, 5));
        } else if (effectType == 4) {
          float x = noise(FLOATING_BACKGROUND_SPEED * getTime() + 7.125 + random) * width * BLOB_OFFSET;
          float y = noise(FLOATING_BACKGROUND_SPEED * getTime() + 11.493 + random) * height * BLOB_OFFSET;
          ellipse(x, y, BLOB_SIZE * min(width, height) * easing(effect, 5), BLOB_SIZE * min(width, height) * easing(effect, 5));
        }
        popMatrix();
      }
    }
  }
  
  void makeBlob(int effectType) {
    shapes.add(new Blob(effectType));
  }

  class Wall extends Shape {
    int effectType;
    int direction;

    public Wall(int effectType) {
      direction = floor(random(4));
      initTime = getTime();
      this.effectType = effectType;
      pos = PVector.add(position, OFFSET);
    }

    public Wall(int effectType, int direction) {
      initTime = getTime();
      this.effectType = effectType;
      this.direction = direction;
      pos = PVector.add(position, OFFSET);
    }

    public void draw() {
      if (getTime() > initTime && getTime() < initTime + WALL_DURATION * 1000) {
        float effect = map(getTime(), initTime, initTime + WALL_DURATION * 1000, 1, 0);
        strokeWeight(WALL_BORDER_THICKNESS);
        stroke(WALL_BORDER, constrain(WALL_BORDER_VISIBILITY, 0, 1) * 255 * effect);
        if (WALL_FILL_VISIBILITY > 0.001) {
          fill(WALL_FILL, constrain(WALL_FILL_VISIBILITY, 0, 1) * 255 * effect);
        } else {
          noFill();
        }
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        rotateZ(direction * TWO_PI * 0.25);
        rotateX(0.25 * TWO_PI);
        translate(0, 0, max(width, height) * WALL_SIZE * 0.5);
        rectMode(CENTER);
        if (effectType == 0) {
          rect(0, 0, max(width, height) * WALL_SIZE, max(width, height) * WALL_SIZE);
        } else if (effectType == 1) {
          float rot = noise(FLOATING_BACKGROUND_SPEED * getTime() + 9.143) * 12;
          rotateZ(rot);
          rect(0, 0, max(width, height) * WALL_SIZE, max(width, height) * WALL_SIZE);
        } else if (effectType == 2) {
          float rot = easing(1-effect, 8) * TWO_PI;
          rotateZ(rot);
          rect(0, 0, max(width, height) * WALL_SIZE, max(width, height) * WALL_SIZE);
        } else if (effectType == 3) {
          rect(0, 0, max(width, height) * WALL_SIZE * easing(1-effect, 5), max(width, height) * WALL_SIZE * easing(1-effect, 5));
        } else if (effectType == 4) {
          float mirror = effect > 0.5 ? map(effect, 1, 0.5, 0, 1) : map(effect, 0.5, 0, 1, 0);
          rect(0, 0, max(width, height) * WALL_SIZE * easing(mirror, 2), max(width, height) * WALL_SIZE * easing(mirror, 2));
        }
        popMatrix();
      }
    }
  }
  
  void makeWall(int effectType) {
    shapes.add(new Wall(effectType));
  }
  
  void makeWall(int effectType, int direction) {
    shapes.add(new Wall(effectType, direction));
  }
}