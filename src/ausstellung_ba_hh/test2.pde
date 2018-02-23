public class Hello2 extends Performer {
  String NAME = "Alex 2";
  String TITLE = "Hello";
  String ARTIST = "World";
  String TRACK_FILE = "music.mp3";

  color FRAME = #212121;
  color BACKGROUND = #FAFAFA;

  color[] FLOATING_BACKGROUND = {#FFC15E, #EF6F6C};
  float FLOATING_BACKGROUND_SIZE = 1.0;
  float FLOATING_BACKGROUND_OFFSET = 1.0;
  float FLOATING_BACKGROUND_SPEED = 0.0001;
  float FLOATING_BACKGROUND_ROTATION = 1.0;
  int MOVEMENT_DETAIL = 3;

  String FONT_NAME = "font.otf";
  String LAYOUT_FONT_NAME = "layout-font.otf";
  color FONT = #FAFAFA;
  color LAYOUT_FONT = #555555;
  float FONT_SIZE = 0.2;
  float LAYOUT_FONT_SIZE = 0.017;
  float WORD_DURATION = 2.0;

  color SHAPE_FILL = #2D3047;
  float SHAPE_FILL_VISIBILITY = 0.0;
  color SHAPE_BORDER = #2D3047;
  float SHAPE_BORDER_VISIBILITY = 1.0;
  float SHAPE_BORDER_THICKNESS = 2.0;
  float SHAPE_SIZE = 0.5;
  float SHAPE_DURATION = 3.0;

  color SHUTTER = #FFC15E;
  float SHUTTER_DURATION = 1.0;
  float SHUTTER_SCALE = 1.5;

  float FRAME_MARGIN = 0.075;
  float COLOR_CHANGE_SPEED = 3.0;

  PVector MOVEMENT = new PVector(0, 0, -1000);
  PVector OFFSET = new PVector(0, 0, -1000);

  float AUDIO_SMOOTH_FACTOR = 0.03;

  void keyEvent(char key) {
    if (key == '1') {
      shapes.add(new Word("moooooin", 4));
    }
    if (key == '2') {
      shapes.add(new Word("hej", 2));
    }
    if (key == '3') {
      shapes.add(new Primitive(3));
    }
    if (key == '4') {
      shapes.add(new Primitive(4));
    }
    if (key == '5') {
      shapes.add(new Primitive(5));
    }
    if (key == '6') {
      shapes.add(new Primitive(6));
    }
    if (key == '7') {
      shapes.add(new Shutter(0));
    }
    if (key == '8') {
      shapes.add(new Shutter(1));
    }
    if (key == '9') {
      shapes.add(new Shutter(4));
    }
    if (key == '0') {
      movement.mult(-1);
    }
  }

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
      shape.stroke(SHAPE_BORDER, constrain(SHAPE_BORDER_VISIBILITY, 0, 1) * 255);
      if (SHAPE_FILL_VISIBILITY > 0.001) {
        shape.fill(SHAPE_FILL, constrain(SHAPE_FILL_VISIBILITY, 0, 1) * 255);
      } else {
        shape.noFill();
      }
      shape.strokeWeight(SHAPE_BORDER_THICKNESS);

      for (int i = 0; i < corners; i++) {
        float x = sin(float(i) / corners * TWO_PI);
        float y = cos(float(i) / corners * TWO_PI);
        shape.vertex(x * SHAPE_SIZE * min(width, height), y * SHAPE_SIZE * min(width, height));
      }

      shape.endShape(CLOSE);
    }

    public void draw() {
      if (getTime() > initTime && getTime() < initTime + SHAPE_DURATION * 1000) {
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        shape(shape);
        popMatrix();
      }
    }
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
          textSize(min(width, height) * FONT_SIZE * audioSum);
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
        } else{
          text(text, 0, 0);
        }
        popMatrix();
      }
    }
  }

  class Shutter extends Shape {
    int effectType;

    public Shutter(int effectType) {
      initTime = getTime();
      this.effectType = effectType;
      pos = PVector.add(position, OFFSET);
    }

    public void draw() {
      if (getTime() > initTime && getTime() < initTime + SHUTTER_DURATION * 1000) {
        float effect = map(getTime(), initTime, initTime + SHUTTER_DURATION * 1000, 1, 0);
        noStroke();
        fill(SHUTTER, effect * 255);
        rectMode(CENTER);
        pushMatrix();
        translate(pos.x, pos.y, pos.z);

        if (effectType == 0) {
          rect(0, 0, width * SHUTTER_SCALE, height * SHUTTER_SCALE);
        }
        if (effectType == 1) {
          rect(0, 0, width * SHUTTER_SCALE * easing(1 - effect, 7), height * SHUTTER_SCALE * easing(1 - effect, 7));
        }
        if (effectType == 2) {
          rect(0, 0, width * SHUTTER_SCALE * easing(effect, 6), height * SHUTTER_SCALE * easing(1 - effect, 7));
        }
        if (effectType == 3) {
          rect(0, 0, width * SHUTTER_SCALE * tan(effect), height * SHUTTER_SCALE * tan(effect));
        }
        if (effectType == 4) {
          rect(0, 0, width * SHUTTER_SCALE * tan(1-effect), height * SHUTTER_SCALE * tan(1-effect));
        }

        popMatrix();
      }
    }
  }
}