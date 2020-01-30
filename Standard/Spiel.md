# Spezifikation der Datentypen

## PropertyEnum
Das `PropertyEnum` dient dazu, alle Eigenschaften aus dem Listenheft in Kapitel 2.3 aufzulisten.

```java
enum PropertyEnum {
    FLINKHEIT,
    SCHWERFAELLIGKEIT,
    BEHAENDIGKEIT,
    AGILITAET,
    GLUECKSPILZ,
    PECHVOGEL,
    KLAMME_KLAMOTTEN,
    KONSTANT_KLAMME_KLAMOTTEN,
    ROBUSTER_MAGEN,
    ZAEHIGKEIT,
    BABYSITTER,
    HONEY_TRAP,
    BANG_AND_BURN,
    FLAPS_AND_SEALS,
    TRADECRAFT,
    OBSERVATION
}
```

Charaktere besitzen Eigenschaften. Operationen können Charaktereigenschaften ändern.

## GadgetEnum
Das `GadgetEnum` enthält alle möglichen Gadgets.

```java
enum GadgetEnum {
    AKKU_FOEHN,
    MAULWUERFEL,
    TECHNICOLOR_PRISMA,
    KLINGEN_HUT,
    MAGNETFELD_ARMBANDUHR,
    GIFTPILLEN_FLASCHE,
    LASER_PUDERDOSE,
    RAKETENWERFER_FUELLFEDERHALTER,
    GASPATRONEN_LIPPENSTIFT,
    MOTTENKUGEL_BEUTEL,
    NEBELDOSE,
    WURFHAKEN,
    JETPACK,
    WANZE_UND_OHRSTOEPSEL,
    CHICKEN_FEED,
    NUGGET,
    MIRROR_OF_WILDERNESS,
    POCKET_LITTER,
    DIAMANTHALSBAND_DER_WEISSEN_KATZE
}
```

## Gadget
Die Klasse `Gadget` implementiert die Eigenschaften eines spezifischen Gadgets.

```java
class Gadget {
    GadgetEnum gadgetID;
    Double probability;
    Integer usagesLeft;
    Integer damage;
    Integer range;
}
```

**TODO**
- Erstellung eines Datenmodells für alle Gadgets
- Es müssen Subklassen für jedes Gadget erstellt werden.

Das Folgende muss beachtet werden:
- Der Wert der `gadgetID` muss ihm Netzwerkstandard fix vergeben werden.
- Cocktails sind Gadgets.

Die Attribute haben den folgenden Nutzen:
- Das Attribut `gadgetID` definiert die Gadget UUID. Sie wird zur Referenzierung und Identifikation verwendet.
- Falls `probability` nicht `null` und im Bereich [0;1] ist, dann gibt dieses Attribut die (Miss-)Erfolgswahrscheinlichkeit an.
- Falls `usagesLeft` nicht `null` und >= 0 ist, dann gibt dieses Attribut die Anzahl der übrigen Verwendungsmöglichkeiten an.
- Falls das Gadget eine Waffe ist, gibt das Attribut `damage` den Schaden an.
- Falls das Gadget eine Waffe ist, gibt das Attribut `range` die Reichweite an.

## Character
Die Klasse `Character` implementiert die Eigenschaften eines spezifischen Charakters. Diese Klasse modelliert den Charakter-Zustand während des Spiels. Sie darf nicht mit der Charakter-Beschreibung verwechselt werden, die am Anfang des Spiels gesendet wird.

```java
class Character {
    UUID characterID;
    String name, desc;
    Point coordinates;
    Integer mp, ap, hp, ip, chips;
    // Boolean cocktail; // DEPRECATED
    List<PropertyEnum> properties;
    List<Gadget> gadgets;
    List<TileEnum> safeCombinations;
}
```

Die Attribute haben den folgenden Nutzen:
- Das Attribut `characterID` definiert die Charakter UUID. Sie wird zur Referenzierung und Identifikation verwendet.
- Die Attribute `name` und `desc` enthalten den Namen und die Beschreibung.
- Die Attribute `mp`, `ap`, `hp`, `ip` und `chips` geben die Bewegungs-, Aktions-, Health- und Intelligence-Punkte sowie die Anzahl der Chips an.
- (**DEPRECATED**) Das Attribut `cocktail` gibt an, ob der Charakter einen Cocktail in der Hand hält. Falls das Attribut `null` ist, wird es als `false` interpretiert.
- Das Attribut `properties` enthält alle Eigenschaften des Charakters.
- Das Attribut `gadgets` enthält alle Gadget UUIDs des Charakters.
- Das Attribut `safeCombinations` enthält alle Tresor-Kombinationen, die der Charakter kennt.

## State
Die Klasse `State` implementiert den aktuellen Spielstatus. Er umfasst alle Karten- bzw. Szenarioeigenschaften, alle Charaktereigenschaften und alle Gadgeteigenschaften.

```java
class State {
    FieldEnum[][] scenario;
    List<Character> characters;
    List<Gadget> gadgets;
}
```

Die Attribute haben den folgenden Nutzen:
- Das Attribut `scenario` enthält den Zustand der Karte bzw. des Szenarios. Die Arbeitsgruppe "Format der Szenarios" definiert das Szenario.
- Das Attribut `characters` enthält alle Charaktere mit deren Eigenschaften.
- Das Attribut `gadgets` enthält alle Gadgets mit deren Eigenschaften.

## OperationEnum
Das Enum `OperationEnum` definiert alle Operationsarten.

```java
enum OperationEnum {
    ACTION,
    MOVEMENT,
    RETIRE
}
```

## Operation
Die Klasse `Operation` stellt die Basisinformationen einer Operation. Sie bildet die Grundlage für spezialisierte Klassen, die von `Operation` erben. Eine Operation gibt Bewegungs- oder Aktionspunkte aus.

```java
abstract class Operation {
    OperationEnum type;
    UUID character;
}
```

Die Attribute haben den folgenden Nutzen:
- Das Attribut `type` definiert den Typ der Operation.
- Das Attribut `characterId` spezifiziert den Charakter, von dem die Operation begangen wurde.
- Das Attribut `successful` gibt an, ob die Aktion erfolgreich war.

Die Klasse `Action` implementiert eine Aktion.

```java
class Action extends Operation {
    UUID gadgetId;
    TileEnum target;
    Boolean successful;
}
```

Das Folgende muss beachtet werden:
- Hat die `gadgetId` den Wert `null`, dann ist es eine Roulette-, Cocktail-, Spionage oder Tresor-Aktion. Das Ziel legt die Art fest. Ist die `gadgetId` nicht `null`, dann ist es eine Gadget-Aktion.
- Das Attribut `successful` wird vom Server gesetzt und hat Bedeutung, wenn die Nachricht vom Server kommt.
- Der Server würfelt aus, ob eine Aktion erfolgreich war.

Die Attribute haben den folgenden Nutzen:
- Das Attribut `gadgetId` gibt die Gadget UUID an, falls die Aktion mit einem Gadget zu tun hat.
- Das Attribut `target` gibt das Ziel der Aktion an.
- Das Attribut `successful` gibt an, ob die Aktion erfolgreich war, wenn die Nachricht vom Server stammt.

**TODO**
- Erstellung eines Datenmodells für die verschiedenen Aktionen: Spionage, Tresorknacken, Gadget-Aktion
- Erinnerung: Cocktails sind Gadgets.

Die Klasse `Movement` implementiert eine Bewegung.

```java
class Movement extends Operation {
    Point from, to;
}
```

Die Attribute haben den folgenden Nutzen:
- Die Attribute `from` und `to` geben die Bewegung des Charakters an.

Die Klasse `Retire` stellt das vom Spieler ausgelöste Zugende dar.

```java
class Retire extends Operation {

}
```

RFC:

# Spezifikation der Nachrichten
Wir definieren hier den `body` der Nachrichten während eines Spiels. Wir treffen für die Nachrichten folgende Annahmen:
- Der Server vergibt jedem Nutzer eine `playerID` beim Verbinden.
- Im `head` ist der Nachrichtentyp enthalten.
- Im `head` ist ein Zeitstempel vorhanden, damit ein Client die Zugzeit ausrechnen kann.
- Die Charaktere und Gadgets sollten eine eindeutige UUID haben. Die UUID der Gadgets muss fix vom Netzwerkstandard festgelegt werden.
- Wir nehmen an, dass das Spiel durch eine Nachricht gestartet wurde. In dieser Nachricht sollte der Server die Spiel-Konfiguration und die verfügbaren Charaktere erhalten haben.

Im Spiel gibt es drei unterschiedliche Phasen:
- Wahlphase,
- Ausrüstungsphase und
- Spielphase.

Wir definieren im Folgendem die Nachrichten in den drei Phasen.

## Spielstart
Die Spieler befinden sich vor Start des Spiels in einer Lobby. Durch die `GAME_STARTED`-Nachricht mit dem gleichnamigen Nachrichtentyp wird dem Client mitgeteilt, dass das Spiel beginnt. Mit dieser Nachricht bekommt der Client die Partie-Konfiguration, die definierten Charaktere und das Szenario. Anders gesagt: Der Client bekommt alle Informationen, die zum Spielen benötigt werden.

Die Verbindungs-Arbeitsgruppe definiert die Nachricht zum Spielstart.

## Wahlphase
Die Spieler wählen ihre Charaktere und Gadgets in der Wahlphase. Insgesamt wählen sie acht Items, davon zwei bis vier Charaktere und vier bis sechs Gadgets. Wir bezeichnen Charaktere und Gadgets als Items.

### Charakter- und Gadgetangebot
In der Wahlphase offeriert der Server einem Client Charaktere und Gadgets. Die Nachricht, die das implementiert, hat den Nachrichtentyp `ITEM_REQUEST_CHOICE` im `head`. Der `body` besteht aus den folgenden Feldern.

```json
{
    "offerNr":           Integer,
    "offeredCharacters": List<UUID>,
    "offeredGadgets":    List<GadgetEnum>
}
```

Die Felder haben den folgenden Nutzen:
- Das Feld `offerNr` dient der Konsistenzerhaltung. Wenn eine Wahl nicht in Ordnung war, wird die Nachricht `ITEM_REQUEST_CHOICE` mit der gleichen Nummer nochmal an den Client gesendet.
- Das Feld `offeredCharacters` enthält die UUIDs aller angebotenen Charaktere.
- Das Feld `offeredGadgets` enthält die UUIDs aller angebotenen Gadgets.

RFC:

### Charakter- und Gadgetwahl
Nachdem der Client eine `ITEM_REQUEST_CHOICE`-Nachricht bekommen hat, muss er dem Spieler das Angebot anzeigen. Dieser wählt ein Gadget aus und der Client antwortet mit einer Nachricht, die dem Server die Wahl mitteilt. Diese Nachricht hat Nachrichtentyp `ITEM_CHOICE` im `head`. Der `body` besteht aus folgenden Feldern.

```json
{
    "offerNr":         Integer,
    "chosenCharacter": UUID,
    "chosenGadget":    GadgetEnum
}
```

Das Folgende muss bei dieser Nachricht beachtet werden:
- Eins der Felder `chosenCharacter` oder `chosenGadget` **muss** `null` oder nicht vorhanden sein. Falls der Client eine inkonsistente Wahl schickt, dann wiederholt der Server den Vorgang mit einer `ITEM_REQUEST_CHOICE`-Nachricht mit gleicher `offerNr`-Zahl. Zusätzlich bekommt der Client einen Strike.

Die Felder haben den folgenden Nutzen:
- Das Feld `offerNr` dient dazu, dass der Server weiß, auf welches Angebot sich der Client bezieht. Der Server kann so schnell kontrollieren, ob der Client sinnvolle Dinge tut.
- Wenn das Feld `chosenCharacter` vorhanden oder nicht `null` ist, dann enthält das Feld die UUID des gewählten Charakters aus der Liste der angebotenen Charaktere.
- Wenn das Feld `chosenGadget` vorhanden oder nicht `null` ist, dann enthält das Feld die UUID des gewählten Gadgets aus der Liste der angebotenen Gadgets.

RFC:

## Ausrüstungsphase
Nach dem beide Spieler alle acht Items gewählt haben, müssen sie ihre gewählten Charaktere mit den gewählten Gadgets ausrüsten.

### Ausrüstungsanfrage
Nach der Wahlphase bekommen die Clients eine `EQUIPMENT_REQUEST_CHOICE`-Nachricht. Diese Nachricht teilt den Clients mit, dass die Wahlphase beendet ist. Die Spieler müssen nun ihre Gadgets den Charakteren zuordnen. Der `body` hat die folgenden Felder.

```json
{
    "chosenCharacters": List<UUID>,
    "chosenGadgets":    List<GadgetEnum>
}
```

Die Felder haben den folgenden Nutzen:
- Das Feld `chosenCharacters` enthält die UUIDs aller Charaktere, die der jeweilige Spieler gewählt hat.
- Das Feld `chosenGadgets` enthält die UUIDs aller Gadgets, die der jeweilige Spieler gewählt hat.

RFC:

### Ausrüstungswahl
Nach der Ausrüstungsanfrage muss der Spieler seine Charaktere ausrüsten. Die dazugehörige Nachricht hat den Typ `EQUIPMENT_CHOICE` im `head`. Der `body` hat die folgenden Felder.

```json
{
    "equipment": Map<UUID, List<GadgetEnum>>
}
```

Die Felder haben den folgenden Nutzen:
- Das Feld `equipment` enthält eine Zuordnung von Charakter-UUIDs auf Gadgets. Die verwendeten UUIDs **müssen** aus der Liste der gewählten Charaktere und Gadgets sein. Wenn der Client sich nicht daran hält, bekommt er einen Strike und erneut eine Ausrüstungsanfrage.

## Spielphase
Das Spiel läuft in Runden ab. Eine Runde hat die folgenden Bestandteile:
- Mit dem Rundenstart beginnt die Vorbereitungsphase. In der Vorbereitungsphase werden Cocktails aufgefüllt, Ausfallswahrscheinlichkeitsproben für Gadgets gemacht und die Zugreihenfolge für die Charaktere ausgewürfelt.
- Danach kommen die Züge der Charaktere nach der Zugreihenfolge.

Ein Zug besteht aus mehreren Zugphasen:
- Zuerst werden die Bewegungs- und Aktionspunkte des aktiven Charakters für diese Runde bestimmt.
- Danach kann der Spieler die Bewegungs- und Aktionspunkte in einer beliebigen Reihenfolge ausgeben. Jedes Ausgeben stellt eine Zugphase dar. Der Server überprüft die Siegbedingungen nach jeder Zugphase.
- Wenn alle Punkte ausgegeben sind, wird der Zug vom Server beendet. Möchte der Spieler keine Aktion mehr ausführen, kann er den Zug auch beenden.

### Vorbereitungsphase und Züge
#### Vorbereitungs- und Zugphase
In der Vorbereitungsphase führt der Server die Ereignisse zu Rundenbeginn aus und sendet eine Nachricht vom Typ `GAME_STATUS`. Die Nachricht wird auch nach jeder Operation eines Charakters (d.h. als Antwort auf jede `GAME_OPERATION`-Nachricht) gesendet. Diese Nachricht sendet der Server an alle Clients. Der `body` hat die folgenden Felder.

```json
{
    "activeCharacter": UUID,
    "operations":      List<Operation>,
    "state":           State,
    "winnderId":       UUID
}
```

Das Folgende muss bei dieser Nachricht beachtet werden:
- Wenn der Client seine Zugzeit überschreitet, dann sendet der Server eine `GAME_STATUS`-Nachricht mit keiner Operation und dem nächsten aktiven Charakter. D.h. der Server beendet den Zug des Charakters.

Die Felder haben den folgenden Nutzen:
- Das `activeCharacter`-Feld spezifiziert den Charakter, der am Zug ist. Ist das Feld `null` oder nicht vorhanden, dann ist kein Charakter am Zug.
- Das Feld `operations` enthält alle Operationen seit der letzten `GAME_STATUS`-Nachricht, damit die Clients die Operationen animieren können.
- Das Feld `state` enthält den Zustand des Spiels. Es enthält auch die Aktions- und Bewegungspunkte des aktiven Charakters.
- Wenn das Feld `winnerId` vorhanden oder nicht `null` ist, dann enthält es die `userId` des Gewinners.

RFC:
- Man könnte eine Gewinnart angeben, sodass klar ist, wie der jeweilige Spieler gewonnen hat (Aufgabe, IPs, Diamanthalsband, ...). -Jo

#### Operationsnachricht
State enthält den Kartenzustand sowie die Charakter- und Gadgetzustände. Die Operationsnachricht hat den Typ `GAME_OPERATION`.

```json
{
    "operation": Operation
}
```

Die Felder haben den folgenden Nutzen:
- Das Feld `operation` spezifiziert die vom Spieler ausgeführte Operation. Es **muss** eine Operation des aktiven Charakters sein. Ist das nicht der Fall oder ist die Operation invalide, dann bekommt der Client einen Strike.

## Kontrollnachrichten
### Verlassensnachricht
Der Spieler kann dem Server mitteilen, dass er das Spiel verlassen und somit aufgeben möchte.

#### Mitteilung des Verlassens
Wenn der Spieler sich dazu entscheidet, das Spiel zu verlassen, dann sendet der jeweilige Client dem Server eine Nachricht mit dem Typ `GAME_LEAVE`. Die Nachricht hat einen leeren `body`, da klar ist, wer aufgibt.

#### Bestätigung des Verlassens
Der Server antwortet dem jeweiligen Client mit einer `GAME_LEFT`-Nachricht. Diese hat den folgenden `body`.

```json
{
    "leftUserId": UUID
}
```

### Pausierungsnachricht
Der Spielverlauf kann pausiert werden. Der Server stoppt die Timer der Zugzeiten.

#### Fortsetzungs- und Pausierungsanforderung
Die Clients können das Spiel mit einer Nachricht vom Typ `REQUEST_PAUSE` pausieren. Der `body` hat die Felder:

```json
{
    "gamePause": Boolean
}
```

Die Felder haben den folgenden Nutzen:
- Im Feld `gamePause` kann ein Wahrheitswert angegeben werden, der angibt, ob das Spiel pausiert oder fortgesetzt werden soll.

#### Fortsetzungs- und Pausierungsbestätigung
Nach der Pausierungsanfrage sendet der Server eine Bestätigung an alle Clients. Die Nachricht hat den Typ `GAME_PAUSE`.

```json
{
    "gamePaused": Boolean
}
```

RFC:
- Die Berechnung der verbleibenden Zugzeit ist im Client ein bisschen kompliziert. -Jo

### Anforderung der Konfiguration
Falls der Client die Konfiguration noch einmal anfördern möchte, kann er das mit einer Nachricht vom Typ `REQUEST_CONFIG` im `head` tun. Der Server antwortet dann erneut mit einer `GAME_STARTED`-Nachricht, in der die Konfiguration enthalten ist. Die Nachricht hat einen leeren `body`.

### Strike

**DEPRECATED**: Die Verbindungs-Arbeitsgruppe definiert die Strikes.

Wenn ein Client eine invalide Aktion ausführt und an den Server sendet, bekommt er einen Strike mit Begründung. Eine `STRIKE`-Nachricht hat den folgenden `body`.

```json
{
    "strikeNr":  Integer,
    "strikeMax": Integer,
    "reason":    String
}
```

Wenn die maximale Anzahl an Strikes erreicht wird, dann tut der Server so, als ob der jeweilige Spieler das Spiel verlassen hätte.
