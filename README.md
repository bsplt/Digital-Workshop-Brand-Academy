# Workshop _Digitale Medien_
### Hier findet ihr alle Infos rund um den Workshop an der [Brand Academy](https://www.brand-acad.de/) am 24. und 25. Februar 2018.

![Banana Piano](https://bonnietdnguyen.files.wordpress.com/2015/07/bananas-comp1.jpg)

## Einleitung

Moin zusammen!

Heute haben wir mit euch etwas Ungewöhnliches vor.  Wir programmieren ein Musikvideo mit Bananen, Tesafilm und jeder Menge Kabeln.

Weil ihr hier im Workshop _Digitale Medien_ von _Alexander Lehmann_ und _Thorge Wandrei_ seid, kommt da jede Menge Technik auf euch zu, in der ihr euch kreativ zurechtfinden sollt. Das heißt nicht, dass ihr Programmieren können müsst, geschweige denn irgendwas ins Detail zu verstehen. Das tun nicht mal wir. Viel wichtiger ist es, dass ihr euch nicht von der Technik einschüchtern lasst und stattdessen die Chance nutzt, dieses Medium ästhetisch zu erkunden. Der Code ist überwältigend, aber Schritt für Schritt könnt ihr Kleinigkeiten ändern, bis plötzlich alles passt und ihr etwas Einzigartiges geschaffen habt.

Ihr könnt euch schon mal darauf vorbereiten, dass ihr Musik braucht. Und zwar die Musik, die _ihr_ gutfindet. Denn später baut ihr mit einem [Makey Makey](https://makeymakey.com/) eurer eigenes Interface, mit dem ihr dann visuelle Effekte, passend zum Song, erzeugt.

Bei Code als auch bei gestalterischen Frage stehen wir euch die ganze Zeit mit Rat und Tat zur Seite.

## Anleitung

### Schritt 1: Software

Diesen Schritt könnt ihr überspringen, wenn ihr die Anleitung während des Workshops lest, weil wir das vermutlich schon für euch erledigt haben.

Als aller erstes braucht ihr [Processing 3](https://processing.org/download/). Processing ist gleichzeitig eine einfache Entwicklungsumgebung und eine Programmiersprache, die für Designer, Künstler und Anfänger entwickelt wurde. Damit vereint sie alles, was ihr für euer erstes selbstgeschriebenes Programm braucht, in einem Download. Sehr praktisch, sehr gut und – vertraut uns – sehr einfach zu lernen. Aber das, wann anders. Heute benutzen wir Processing einfach nur als Werkzeug.

Außerdem braucht ihr die Erweiterung _minim_, die es Processing ermöglicht, Sound zu machen. Dafür geht ihr in Processing auf `Sketch`, dann `Library importieren` und schließlich `Library hinzufügen ...`. Ein neues Fenster öffnet sich, tippt `minim` in den Filter und klickt auf `Install`. Das wars.

Natürlich braucht ihr jetzt noch _unsere_ Software. Das ist ein Sketch in Processing, den wir schon mal für euch geschrieben haben. _Sketch_, das steht in Processing für den Code eines Programms. Den Sketch könnt ihr [hier](download/workshop_ba_hh.zip) direkt als zip-Datei downloaden und dann einfach mit Processing öffnen.

### Schritt 2: Was machen?

Jetzt habt ihr den Programmcode vor euch. Los geht es ganz einfach: Auf das Play-Symbol im Processing-Fenster klicken und das Programm läuft. Für die ganz fixen geht auch `CMD + r` auf Mac OS oder `STRG + r` auf Windows. Der Code wird jetzt vom Computer so umgebaut, dass er ihn ausführen kann, und das Programm öffnet sich im Vollbild. Wenn alles gut läuft, könnt ihr das Programm auch wieder mit `ESC` schließen.

Es ist an der Zeit den Makey Makey anzuschließen. Der Makey Makes ist _eigentlich_ eine Tastatur, die keine Tasten hat. Dafür könnt ihr anderen Gegenstände, die elektrisch leitend sind, als Tasten benutzen. Zum Beispiel Obst oder Alu-Folie. Das Gute: Wenn ihr noch mal zuhause rumtüfteln wollt, braucht ihr den Makey Makey gar nicht, denn es funktioniert auch einfach so mit eurer Tastatur. Also ab mit dem Makey Makey in den USB-Port. Die Funktion ist ganz einfach. Es gibt folgende Tasten am Makey Makey, die wir auch benutzen: `LEFT`, `RIGHT`, `UP`, `DOWN`, `SPACE`, `W`, `A`, `S`, `D`, `F` und `G`. Wenn ihr die leitenden Flächen dieser Tasten über Kabel oder Krokodilklemmen mit der großen Fläche elektrisch verbindet, die `EARTH` heißt, drückt ihr quasi die Taste.

__Euer Ziel ist es__, den Processing-Sketch soweit zu verändern, dass er zu eurer Musikauswahl ästhetisch passt, bewusst damit bricht, wie auch immer, vor allem aber interessant ist. Mit dem baut ihr einen Controller, über den ihr selbst das Musikvideo steuert. Das nehmen wir dann auf, um es den anderen zu zeigen.

Das heißt: Ihr müsst euch Gedanken um Musik machen und sie einbauen, nach Schriften suchen und downloaden, über Farben nachdenken, jede Menge Variablen verändern, vielleicht ein klitzekleines bisschen Programmieren und zum Schluss dann mit eurem selbstgebauten Werkzeug eine Performance aufzunehmen.

### Schritt 3: Manipulieren

Im Processing-Editor findet ihr zwei Tabs. Der vermutlich offene heißt `workshop_ba_hh`. Den lasst ihr bitte so, wie ihr ist. Stattdessen wechselt ihr rüber in den Tab, der `YOUR_PROJECT` heißt. Da findet ihr jetzt erstmal jede Menge Code.

Das erste, was ihr machen könnt: Spielt mit den Werten, die ihr oben in der Datei seht, die großgeschriebenen, wie bspw. die Zeile:
```
float FRAME_MARGIN = 0.075;
float COLOR_CHANGE_SPEED = 3.0;
```
Was passiert, wenn ihr sie so ändert?
```
float FRAME_MARGIN = 0.2;
float COLOR_CHANGE_SPEED = 1.0;
```

So könnt ihr gerne mit allen Werten rumspielen.

Grundsätzlich ist beim Programmieren zu beachten, dass es verschiedene Datentypen gibt. Das heißt, Processing unterscheidet beispielsweise, ob ihr einen Text oder eine Zahl eingebt. Hier ist eine kurze Zusammenfassung:

* __Text__ besteht aus mehreren Zeichen und irgendwer dachte sich mal, dass die wie aufgefädelt sind ... Darum speichern wir Text in einem `String`.
* __Farben__ haben in Processing ihren eigenen Datentypen. Der heißt `color` und nimmt Farben im Hex-Format. Damit codiert man den Rot-, Grün und Blau-Anteil einer Farbe in eine Zahl. Dann packen wir noch ein `#` davor, um das Format kenntlich zu machen. Beispielsweise ist `#FF0000` ein Rot und `#0000FF` ein Blau.
* __Zahlen__ werden in zwei verschiedenen Typen gespeichert. Braucht die Zahl keine Nachkommastellen, wie bspw. `7` oder `12345`, benutzen wir einen _Integer_, also `int`. Soll die Zahl doch Nachkommastellen haben (beachte, im Englischen ist es kein _Komma_, sondern ein _Punkt_), wie beispielsweise `0.5` oder `4.998`, dann benutzen wir _Fließkommazahlen_, also `float`. Das ist ein technischer Begriff, um den wir uns erstmal nicht kümmern brauchen.
* __Vektoren__ kennt ihr vermutlich noch aus dem Mathe-Unterricht. In Processing heißt das `PVector`. Damit können wir beispielsweise Richtungen oder Geschwindigkeiten speichern. Im Grunde ist ein Vektor nur eine Sammlung von beispielsweise drei Zahlen für den dreidimensionalen Raum.

Wenn man einen Wert mit einem Datentyp speichert, heißt das _Variable_. Wenn wir eine Variable definieren, dann schreiben wir den Datentypen dazu, damit Processing _explizit_ weiß, was wir verwenden wollen.

Dementsprechend passiert im nächsten Abschnitt folgendes: Wir erstellen eine Variable, die `BLOB_FILL` heißt und eine Farbe sein soll. Durch das `=` weisen wir der Variable die Farbe zu, die in diesem Fall `#333333`, also dunkelgrau, ist. Ganz wichtig: Eine Zeile ist in Processing beendet, wir ihr ein `;` benutzt – und das braucht Processing, um sich zurecht zu finden.
```
color BLOB_FILL = #333333;
```

Die ganzen Farben, Texte und Zahlen könnt und sollt ihr austauschen oder zumindest damit experimentieren.

Außerdem solltet ihr dort auch euren Namen usw. eintragen.

Nicht vergessen dürfen wir, dass ihr auch eure eigene Musik und Schriften in Processing benutzen sollt. Diese Dateien legt ihr in den `data`-Ordner. Den findet ihr in eurem Projekt-Ordner oder indem ihr in Processing einfach `CMD + k` auf Mac OS oder `STRG + k` auf Windows drückt. Habt ihr beispielsweise eine Musikdatei, die `hello_world.mp3` heißt, kopiert ihr sie einfach in den `data`-Ordner und ändert dann diese Zeile:
```
String TRACK_FILE = "music.mp3";
```
so, dass da euer Dateiname steht:
```
String TRACK_FILE = "hello_world.mp3";
```

Processing versteht die gängigsten Musikformate, beispielsweise `.mp3`, `.ogg`, `.wav` oder `.aiff`. Bitte darauf achten, dass ihr das auch richtig eintragt.

Bei den Schriften ist es genau der gleiche Vorgang. Wohlgemerkt, bei Schriften gibt es zwei verschiedene Dateiendungen, `.ttf` und `.otf`, beide funktionieren in Processing.

 ## Schritt 4: Hacken

Vielleicht merkt ihr es gleich, aber im Code passiert folgendes. Jedes mal, wenn ihr an eurem Makey Makey (oder an eurer Tastatur) eine Taste drückt, wird die Funktion `keyEvent` aufgerufen. Eine Funktion ist ein bestimmter Abschnitt an Code, der durch geschweifte Klammern gekennzeichnet ist, `{ ... }`, und unter ganz bestimmten Umständen aufgerufen wird. Im unseren Fall, wenn eine Taste gedrückt wird. Den Rest in der Funktion kann man fast wie Englisch lesen. Beispielsweise:
```
if (key == W) {
  makeShutter(0);
}
```
Das bedeutet, wenn die Taste `W` gedrückt wird, macht Processing einen neuen Shutter-Effekt vom Typ _0_. Den Typen bestimmen wir durch das Parameter, das wir hinten an `makeShutter` mit Klammern `( ... )` dran schreiben.

Wir haben folgende Effekte im Angebot:
* __Word__: Nimmt als ersten Parameter einen Text, bspw. `"Moin".` und als zweiten, optionalen Parameter einen von fünf Effekt-Typen. `makeWord("Moin")` oder `makeWord("Moin", 3)`. Bitte die Anführungszeichen für Strings beachten.
* __Primitive___: Erstellt eine _primitive_ Form, also beispielsweise ein Dreieck mit `makePrimitive(3)` oder ein Fünfeck mit `makePrimitive(5)`.
* __Shutter__ und __Plane__: Das sind beides Farbflächen. Beide haben jeweils fünf Effekt-Typen, die ihr ausprobieren könnt. Bspw: `makeShutter(2)` oder `makePlane(4)`.
* __Blob__: Ein kleiner (oder großer, wenn ihr das wollt) Kreis, der an einer zufälligen Stelle erscheint und wieder verschwindet. Hat auch fünf Effekt-Typen, bspw. `makeBlob(1)`.
* __Wall__: Dann gibt es noch diesen perspektivischen Effekt mit fünf Typen und einem optionalen Parameter für Richtung, in der er erscheinen soll. Also zum Beispiel `makeWall(0)` für eine zufällige Platzierung und Effekt-Typ _0_ oder `makeWall(1,2)` für den Effekt-Typ _0_ und eine Platzierung _unten_.

Diese ganzen _make_-Befehle könnt ihr also einfach an eine Taste ranhängen. Wenn ihr zum Beispiel oben im Code das schreibt:
```
float WALL_DURATION = 3.5;
```
und dann in der `keyEvent`-Funktion das:
```
if (key == SPACE) {
  makeWall(0);
}
```
dann würdet ihr beim Drücken der Leertaste, am Makey Makey oder an der Tastatur, einen perspektivischen Effekt erstellen, mit dem Effekt-Typen _0_ und zufälliger Ausrichtung, der nach 3,5 Sekunden wieder verschwunden ist.

Natürlich lässt sich das noch weiter ausreizen. Ihr könntet so etwas schreiben:
```
if (key == SPACE) {
  makeWall(1, 1);
  makeWall(1, 3);
}
```
Damit würden jedes Mal zwei Effekte erstellt werden, einer links und einer rechts.

Der Code gibt noch viel mehr her ... Wenn euch irgendwas nicht gefällt und ihr es gerne anders hättet, aber nicht wisst wie: Sprecht uns an, wir machen das. Dafür sind wir da. Das bezieht sich auf _Alles_, was ihr da auf eurem Bildschirm seht. Farben, Formen, Bewegungen, etc. Natürlich können wir auch nicht zaubern, aber einen Versucht ist es wert.

### Schritt 5: Performen

Wir haben hoffentlich genug Material, damit ihr euch kreativ verwirklichen könnt. Von Bananen bis Alu-Profilen ist alles dabei. Daraus baut ihr euch mit Hilfe des Makey Makeys ein Interface für euer Programm. Im Prinzip dürft ihr alles verwenden, ob es von uns kommt oder ihr Material in der Brand Academy findet.

Das ganze läuft dann so ein bisschen ab, wie _Guitar Hero_. Nur, dass niemand eure Punkte zählt, sondern es später auf kreative, spannende und ästhetische Ideen ankommt. Kurzgesagt: Ihr drückt die Tasten vom Makey Makey so zur Musik, dass es gut aussieht.

Natürlich haben wir euch eine Funktionalität eingebaut, die euch hilft, das Programm zu steuern. Die könnt ihr über folgende Ziffern auf eurer _echten_ Tastatur steuern:
* __Taste 1__: Zurückspulen. Dabei gehen eure Aufnahmen nicht verloren und ihr könnt zu eurer alten Aufnahme noch mehr hinzufügen und die Performance so Schritt für Schritt aufbauen.
* __Taste 2__: Speichern. Damit landet alles, was ihr performt habt in einer Datei. Wenn ihr nicht speichert, ist euer Fortschritt verloren, sobald ihr Processing schließt. Außerdem spult die Taste auch automaitsch zurück. Gespeicherte Performances werden automatisch geladen.
* __Taste 9__: Löschen. Seid ihr mit eurem Ergebnis unzufrieden, könnt ihr damit alles löschen – inklusive eurer Speicherdatei. Löschen heißt aber auch: Es ist wirklich alles weg.

### Schritt 6: Dokumentieren

Das wichtigste ist: Wenn der Workshop vorbei ist, solltet ihr uns einen Code hinterlassen haben, der funktioniert, sowie eine Performance, die ihr abgespeichert habt. Wir machen von euch ein Foto, wie ihr performt und bauen dann daraus die Ausstellung zusammen. Dann können alle sehen, wie ihr zu eurer Lieblingsmusik performt habt. Bloß kein Lampenfieber!

## Quellen

### Schriften:

* Auf [Fontsquriell](https://www.fontsquirrel.com/) findet ihr eine hervorragende, große Auswahl an freien Schriften
* Die Schriftschmiede [League of movable type](https://www.theleagueofmoveabletype.com/) bietet eine kleine, aber exzellente Auswahl an open-source Schriften
* [Google Fonts](https://fonts.google.com/) schafft einen guten Überblick über hochwertige, freie Schriftarten, bietet aber nicht immer einen direkten Download an. Den muss man sich dann manchmal selbst googlen.
* Soll es ein bisschen verrückter sein, oder gar kitschig, psychedelisch oder esoterisch? Auf [Dafont](https://www.dafont.com/de/) werdet ihr garantiert fündig!

### Farben:

* Wollt ihr euch Farben nach einem strengen System generieren? Da ist [Adobe Color](https://color.adobe.com/de/) das richtige Tool.
* Oder doch lieber die Farben ganz intuitiv zusammenstellen? Bei [Coolors](https://coolors.co/app) passt es immer.
* Noch immer uninspiriert? Schaut doch mal bei [ColourLovers](http://www.colourlovers.com/palettes/most-loved/all-time/meta) rein und sucht euch eine fertige Farbpalette.
* Am besten kombiniert man das natürlich alles, bis man die für sich _perfekte_ Farbpalette gefunden hat.

### Musik:
* Tja, wo ihr eure Lieblingsmusik als mp3 herbekommt, ist eine offene Frage. Vielleicht habt ihr sie dabei?
* Wenn nicht, dann helfen Dienste, wie [convert2mp3](http://convert2mp3.net/), die euch Musikdateien aus YouTube-Links erstellen. Diese Dienste sind alle etwas zwielichtig und mit Werbung bespickt, also vorsichtig sein, wo ihr hinklickt.

## Sonstiges

Interessiert euch Processing brennend, dann könnt ihr [hier](https://processing.org/exhibition/) nachsehen, was andere Leute damit gemacht haben, und [hier](https://processing.org/reference/), was Processing so alles kann.
