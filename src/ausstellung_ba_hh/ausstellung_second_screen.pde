public class PWindow extends PApplet {
  private PImage photo;

  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    //fullScreen(1);
    size(192, 108);
  }

  void setup() {
    noLoop();
  }

  void draw() {
    background(#FAFAFA);
    if (photo != null) {
      image(photo, 0, 0, width, height);
    }
  }

  public void loadPhoto(String filename) {
    photo = loadImage(filename);
    redraw();
  }
}
