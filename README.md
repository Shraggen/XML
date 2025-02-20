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
Ein technischer Stolperstein war, dass wir die Filter- und Sortierfunktionen nicht über XSLT umgesetzt haben. Da wir von Anfang an geplant hatten, diese Funktionalitäten über unser API mit JavaScript zu realisieren, stellte dies letztlich kein Problem dar.

## Rechtfertigung für jeden Einsatz von Nicht-XML Technologien
### Sortierung und Filtrierung von Plants
Im Rahmen unseres Projekts haben wir uns bewusst dazu entschieden, **Nicht-XML-Technologien** – konkret JavaScript – für die dynamische Sortierung und Filterung der Kraftwerke („Plants“) einzusetzen. 
Wir haben uns aus folgenden Begründungen für diesen Ansatz entschieden:

1. **Interaktive Benutzeroberfläche und Asynchronität:**  
   Die Anforderung sieht vor, dass der Benutzer die Liste der Kraftwerke in Echtzeit sortieren und filtern kann, ohne dass die gesamte Seite neu geladen werden muss. JavaScript in Verbindung mit AJAX ermöglicht es, asynchron Daten vom Server abzurufen und die Darstellung sofort anzupassen. Dies führt zu einer deutlich reaktionsfähigeren und benutzerfreundlicheren Oberfläche, als es mit rein statischen XML/XSLT-Lösungen möglich wäre.

2. **Komplexitätsreduktion:**  
   Zwar bieten XML-Technologien wie XSLT prinzipiell Möglichkeiten zur Transformation und sogar zu einfachen Filterungs- bzw. Sortieroperationen, jedoch ist deren Einsatz für dynamische und interaktive Funktionalitäten oftmals mit einer erhöhten Komplexität verbunden. Die Umsetzung einer vollständig dynamischen Filter- und Sortierlogik in XSLT (oder mittels XQuery) wäre umständlicher und weniger intuitiv, als wenn man diese Logik in JavaScript abbildet. Durch den Einsatz von JavaScript können wir die interaktive Funktionalität klar trennen und in einer Sprache umsetzen, die für solche clientseitigen Aufgaben gemacht ist.

3. **Effizienz und Wartbarkeit:**  
   Die Aufteilung der Verantwortlichkeiten – XML als reine Datenhaltung und Validierung, XSLT für die initiale Darstellung und JavaScript für die Interaktion – sorgt für eine klare Architektur. Das Resultat ist ein wartungsfreundlicher Code, in dem Änderungen an der Interaktionslogik (Sortierung, Filterung) ohne Anpassungen am XML- oder XSLT-Code vorgenommen werden können. Zudem kann durch clientseitige Sortierung und Filterung die Serverlast reduziert werden, da nicht für jeden Benutzerwechsel eine komplette Transformation auf Serverseite notwendig ist.

4. **Auftragsanforderungen und praxisgerechte Umsetzung:**  
   Gemäss dem Auftrag war vorgesehen, ein teilvollständiges CRUD-API zu entwickeln, das XML-Daten verwendet, aber dennoch interaktive und dynamische Features bieten soll. Die Nutzung von JavaScript zur Implementierung der Sortier- und Filterfunktionen entspricht genau dieser Anforderung: Es wird ein modernes Benutzererlebnis ermöglicht, während gleichzeitig die XML-basierte Datenhaltung und -validierung beibehalten wird. Diese Kombination erlaubt es, die Vorteile beider Welten – strukturierte, valide Daten im XML-Format und flexible, reaktive Interaktionen im Browser – optimal auszunutzen.

**Zusammengefasst** lässt sich sagen:  
Die Entscheidung, JavaScript für die Sortierung und Filterung der „Plants“ einzusetzen, basiert auf der Notwendigkeit, eine dynamische, reaktionsfähige Benutzeroberfläche zu schaffen, die mit asynchronen Datenabrufen und Echtzeit-Interaktionen überzeugen kann. Gleichzeitig bleibt der Kern der Datenhaltung und -validierung im XML-Bereich, sodass die prinzipielle Architektur des Systems – XML als Grundlage und JavaScript als Interaktionsschicht – klar getrennt und effizient realisiert wird.

## Fazit
Die entwickelte Plattform ist eine einfache und günstige Lösung, um Energiepreise während der aktuellen Krise zu erfassen, anzuzeigen und zu überwachen. Mit XML als Datenformat können die Daten sauber und einheitlich gespeichert werden. Dank der Prüfung mit XSD wird sichergestellt, dass keine fehlerhaften Daten hochgeladen werden.

Die Entscheidung, JavaScript für die Sortier- und Filterfunktionen zu verwenden, hat sich als sinnvoll erwiesen. So können Nutzer die Daten schnell und unkompliziert anpassen, ohne die Seite neu laden zu müssen. Das macht die Plattform benutzerfreundlich und reaktionsschnell. Die Preisdaten werden übersichtlich in einem Diagramm dargestellt, sodass Preisänderungen leicht erkennbar sind.

Auch wenn es kleinere Herausforderungen bei der Umsetzung gab, konnte eine funktionale Lösung bereitgestellt werden. Die klare Trennung zwischen Datenhaltung (XML), Prüfung (XSD), Anzeige (XSLT) und Bedienung (JavaScript) macht das System übersichtlich und leicht erweiterbar.

Insgesamt erfüllt die Plattform die Anforderungen und bietet sowohl Energieunternehmen als auch Verbrauchern einen hilfreichen Überblick über die Energiepreise.
