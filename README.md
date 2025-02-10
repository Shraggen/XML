# XML Fact Sheet

## Problemstellung
Durch den aktuellen Gas- und Strommangel steigen die Energiepreise ins Unermessliche. Die sich stets ändernden Energiepreise müssen erfasst, publiziert, ausgewertet und überwacht werden. Diese Aufgaben stellen die Energiekonzerne sowie die Bevölkerung vor eine grosse Herausforderung.

## Lösungsidee
Es soll eine Plattform erschaffen werden, welche die Konzerne sowie die Verbraucher mit nützlichen Features während der Energiekrise unterstützt. Die Plattform sollte auf bestehender Infrastruktur und möglichst kostengünstig implementiert werden.

## Lösung
Wir erstellen die Plattform mit der kostengünstigen Variante XML. Die Plattform soll mit folgenden Features den Konzernen sowie Verbrauchern in der laufenden Energiekrise helfen und Klarheit verschaffen.

### Feature 1 - CRUD API
Die CRUD API

- Verwaltung von Kraftwerken und Preisen
- Datenvalidierung durch XSD: Kein fehlerhafter Input möglich
- Dynamische Anzeige der Daten in HTML
- XSLT-Transformation für Abfragen:
    - Sortierung nach Preis, Standort, oder Kraftwerkstyp

### Feature 2 - Visualisierung
Mögliche Optionen:
- Liniendiagramm für Preisentwicklung über Zeit
- Kreisdiagramm für Energietyp-Verteilung
- Geografische Preisverteilung als Heatmap

Umsetzung mit XSLT und SVG

## Technische Architektur
### Datenhaltung
Die Daten zu den Kraftwerken sowie Preisen werden in XML gelagert (database.xml).

### Datenvalidierung
XSD (Stellt sicher, dass Daten korrekt sind)

### Datenverarbeitung und Präsentation
XSLT & JavaScript

### Visualisierung
SVG für Diagramm

### Webserver
Node.js und Express

## Verwendete Frameworks
TODO
CSS

## Technische Stolpersteine
TODO

## Rechtfertigung für jeden (!) Einsatz von Nicht-XML Technologien
TODO (am beste direkt alles mit XML mache denn hemmer nüt zum rechtfertige)

## Fazit
TODO

## Links
Google Drive (Präsentationen & Dokumentation) https://drive.google.com/drive/folders/1NxGOdgPpk6-I_cvQMEawxTL95Z5DnEBA
