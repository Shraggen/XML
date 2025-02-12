# XML Fact Sheet

## Problemstellung
Durch den aktuellen Gas- und Strommangel steigen die Energiepreise ins Unermessliche. Die sich stets ändernden Energiepreise müssen erfasst, publiziert, ausgewertet und überwacht werden. Diese Aufgaben stellen die Energiekonzerne sowie die Bevölkerung vor eine grosse Herausforderung.

## Lösungsidee
Es soll eine Plattform erschaffen werden, welche die Konzerne sowie die Verbraucher mit nützlichen Features während der Energiekrise unterstützt. Die Plattform sollte auf bestehender Infrastruktur und möglichst kostengünstig implementiert werden.

## Lösung
Wir erstellen die Plattform mit der kostengünstigen Variante XML. Die Plattform soll mit folgenden Features den Konzernen sowie Verbrauchern in der laufenden Energiekrise helfen und Klarheit verschaffen.

### Feature 1 - CRUD API
Mithilfe der CRUD API kann der Benutzer Kraftwerke und Preise hinzufügen und bearbeiten.

#### Create
Um Daten hinzuzufügen, lädt der Benutzer eine XML Datei hoch, welche von der Applikation gegen ein XSD Schema geprüft wird. So wird sichergestellt, dass keine fehlerhaften Inputs möglich sind.

#### Read
Die Daten können auf der Plattform dynamisch angezeigt werden. Mithilfe einer XSLT-Transformation sind Filterungen nach Status oder Sortierungen nach Preis möglich.

#### Update / Delete
Das Bearbeiten oder Löschen von Daten wurde bewusst nicht implementiert. Dadurch dass die Daten immutable sind wird eine maximale Transparenz der Energiepreise erzielt.

### Feature 2 - Visualisierung
Die Applikation ermöglicht es dem Benutzer, die Preisdaten von Kraftwerken in Form eines Diagramms darzustellen. Das Diagramm zeigt auf der Y-Achse die Höhe des Energiepreises in CHF und auf der X-Achse das Datum der Erfassung. Jeder Graph innerhalb des Diagramms repräsentiert dabei ein Kraftwerk. Die Achsenbeschreibungen, die farbliche Differenzierung der Kraftwerke und die Legende machen das Diagramm übersichtlich und einfach zu verstehen.

## Technische Architektur
### Datenhaltung
Die Daten zu den Kraftwerken sowie Preisen werden in XML gelagert (database.xml).

### Datenvalidierung
Die Datenvalidierung ist mit XSD umgesetzt. Sobald der Benutzer ein XML hochlädt, wird dieses gegen ein XSD Schema geprüft. So wird sichergestellt, dass die hochgeladenen Daten im korrekten Format sind.

### Datenverarbeitung und Präsentation
XSLT & JavaScript

### Visualisierung
Um die XML Daten zu visualisieren, wird ein SVG Diagramm generiert.

### Webserver
Node.js und Express

## Verwendete Frameworks
JavaScript, CSS

## Technische Stolpersteine
TODO

## Rechtfertigung für jeden Einsatz von Nicht-XML Technologien
### Sortierung und Filtrierung von Plants


## Fazit
TODO