# Spezifikation der Datentypen

## Das Enum PropertyEnum
```java
enum PropertyEnum {
    // TODO: Lastenheft 2.3
}
```

## Die Klasse GadgetProperty
// TODO: Erben oder eine Klasse alles
```java
class GadgetProperty {
    UUID gadgetId;
    List<PropertyEnum> properties;
    // successPropability // 1 3
    // usagesLeft // 2
    // asdf // 2 3
    // asdf
    // asdf
}
```

// TODO: IF erben THEN do this
```java
class AkkuFoehn extends GadgetProperty {
    
}
```

## Die Klasse CharacterProperty
```java
class CharacterProperty {
    UUID characterId;
    int bp, ap, hp, ip, chips;
    List<PropertyEnum> properties;
    List<UUID> gadgets;
    boolean cocktail;
}
```

## Die Klasse State
```java
class State {
    Map<TileEnum, TileStateEnum> map; // Map für die Karte
    Map<UUID, List<CharacterProperty>> characterProperties;
    Map<UUID, List<GadgetProperty>> gadgetProperties;
}
```

## Die Klasse Action
```java
class Action {
    ActionEnum type;
    
    // Felder für Bewegung
    TileEnum from, to; // Oder irgendwelche Koordinaten
    
    // Felder für Aktionen
    UUID character, gadget;
    TileEnum target;
}
```

# Spezifikation der Nachrichten
Wir definieren hier den `body` der Nachrichten während eines Spiels.

Wir nehmen an, dass das Spiel durch eine Nachricht gestartet wurde. In dieser Nachricht sollte der Server die Spiel-Konfiguration erhalten haben.

Die Charaktere und Gadgets sollten eine eindeutige UUID haben.

Im Spiel gibt es drei unterschiedliche Phasen:
- Wahlphase,
- Ausrüstungsphase und
- Spielphase.

Somit benötigen wir mindest drei unterschiedliche Nachrichtenarten.

## Spielstart
Die Spieler befinden sich vor Start des Spiels in einer Lobby. Durch die `GAME_STARTED`-Nachricht mit dem gleichnamigen `messageType`-Feld wird dem Client mitgeteilt, dass das Spiel beginnt. Diese Nachricht hat den folgenden `body`.

```json
{
    "gameId": UUID,
    "configuration": Configuration
}
```

## Wahlphase
Die Spieler wählen ihre Charaktere und Gadgets in der Wahlphase. Insgesamt wählen sie acht Items, davon zwei bis vier Charaktere und vier bis sechs Gadgets. Wir bezeichnen Charaktere und Gadgets als Items.

### Charakter- und Gadgetangebot
In der Wahlphase offeriert der Server einem Client Charaktere und Gadgets. Die Nachricht, die das implementiert, hat `messageType = REQUEST_ITEM_CHOICE` im `head`. Der `body` besteht aus den folgenden Feldern.

```json
{
    "gameId": UUID,
    "userId": UUID,
    "offerNr": Integer,
    "offeredCharacters": List<UUID>,
    "offeredGadgets": List<UUID>
}
```

Die Charaktere und Gadgets sollten in der Konfiguration übergeben werden. In den folgenden Nachrichten wird auf Charaktere und Gadgets mit ihrer UUID referenziert.

RFC: 
- Muss der Client wissen, dass der Gegner gerade wählt?
- Am Besten wäre eine Charakter- und Gadget-ID.
- Die Felder "characters" und "gadgets" zu "offeredItems" machen mit dem Datentyp UUID.

### Charakter- und Gadgetwahl
Nachdem der Client eine `REQUEST_ITEM_CHOICE`-Nachricht bekommen hat, muss er dem Spieler das Angebot anzeigen. Dieser wählt ein Gadget aus und der Client antwortet mit einer Nachricht, die dem Server die Wahl mitteilt. Diese Nachricht hat `messageType = ITEM_CHOICE` im `head`. Der `body` besteht aus folgenden Feldern.

```json
{
    "gameId": UUID,
    "userId": UUID,
    "offerNr": Integer,
    "chosenCharacter": UUID,
    "chosenGadget": UUID
}
```

RFC:
- Ist das Feld "offerNr" nötig?
- Kann man den Typ des Felds "choice" besser auflösen, zum Beispiel mit zwei Feldern?
- Das Feld "choice" zu "chosenItem" machen mit Datentyp UUID.

## Ausrüstungsphase
Nach dem beide Spieler alle acht Items gewählt haben, müssen sie ihre gewählten Charaktere mit den gewählten Gadgets ausrüsten.

### Ausrüstungsanfrage
Nach der Wahlphase bekommen die Clients eine `REQUEST_EQUIPMENT_CHOICE`-Nachricht. Diese Nachricht teilt den Clients mit, dass die Wahlphase beendet ist. Sie hat `messageType = REQUEST_EQUIPMENT_CHOICE` im `head`. Der `body` hat die folgenden Felder.

```json
{
    "chosenCharacters": List<UUID>,
    "chosenGadgets": List<UUID>
}
```

RFC:
- Benötigt diese Nachricht überhaupt Felder im Body?

### Ausrüstungswahl
Nach der Ausrüstungsanfrage muss der Spieler seine Charaktere ausrüsten. Die dazugehörige Nachricht hat `messageType = EQUIPMENT_CHOICE` im `head`. Der `body` hat die folgenden Felder.

```json
{
    "equipment": Map<UUID; UUID>
}
```

Die Map verknüpft Charakter-UUID mit Gadget-UUID.

## Spielphase
Das Spiel läuft in Runden ab. Eine Runde hat die folgenden Phasen:
- Vorbereitungsphase (z.B. Auffüllen der Cocktails, Ausfallswahrscheinlichkeitsproben für Gadgets),
- Zugphase und
- Nachbereitungsphase (Überprüfung der Siegbedingung).

### Vorbereitungs- und Zugphase
#### Spielstatusnachricht
In der Vorbereitungsphase führt der Server die Ereignisse zu Rundenbeginn aus und sendet eine Nachricht vom Typ `GAME_STATUS`. Der `body` hat die folgenden Felder. Diese Nachricht sendet der Server an die Clients.

Wenn der Client eine Zeitüberschreitung macht, dann sendet der Server eine Spielstatusnachricht mit keiner Aktion und dem nächsten aktiven Charakter (und eventuell einen Strike).

```json
{
    "gameId": UUID,
    "activeCharacter": UUID,
    "actions": List<Action>,
    "state": State,
    "winnderId": UUID
}
```

#### Aktionsnachricht
State enthält den Kartenzustand sowie die Charakter- und Gadgetzustände. Die Aktionsnachricht hat den Typ `GAME_ACTION`.

```json
{
    "gameId": UUID,
    "userId": UUID,
    "action": Action
}
```

## Kontrollnachrichten
### Verlassensnachricht
#### Informieren des Servers über das Verlassen
Wenn der Spieler sich dazu entscheidet, das Spiel zu verlassen, dann sendet der jeweilige Client dem Server eine Nachricht mit dem Typ `GAME_LEAVE`.

```json
{
    "userId": UUID
}
```

#### Informieren der Clients über das Verlassen
Die Nachricht hat den Typ `GAME_LEFT`. Sie hat einen leeren `body`.

### Pausierungsnachricht
#### Fortsetzungs- und Pausierungsanforderung
Die Clients können das Spiel pausieren mit einer Nachricht vom Typ `REQUEST_PAUSE`.

```json
{
    "userId": UUID,
    "gamePause": Boolean
}
```

#### Fortsetzungs- und Pausierungsbestätigung
Nach der Pausierungsanfrage sendet der Server eine Bestätigung an alle Clients. Die Nachricht hat den Typ `GAMWE_PAUSE`.

```json
{
    "gamePaused": Boolean
}
```

### Anforderung der Konfiguration
// TODO

### Strike
Wenn ein Client eine invalide Aktion ausführt und an den Server sendet, bekommt er einen Strike mit Begründung.
