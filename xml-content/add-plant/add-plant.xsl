<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Kraftwerk hinzufügen</title>
                <link rel="stylesheet" type="text/css" href="../theme.css"/>
            </head>
            <body>
                <h1>Energiewerke Mittelland Reloaded - Kraftwerk hinzufügen</h1>
                <small><a href="../index.xml">Home</a></small>

                <br/><br/>

                <!-- Formular zum Erstellen eines neuen Kraftwerks -->
                <form action="/plants" method="post">
                    <label for="name">Kraftwerksname:</label>
                    <input type="text" id="name" name="name">
                        <xsl:attribute name="required">required</xsl:attribute>
                    </input>
                    <br/><br/>

                    <label for="status">Status:</label>
                    <select id="status" name="status">
                        <option value="true">Aktiv</option>
                        <option value="false">Inaktiv</option>
                    </select><br/><br/>

                    <h3>Preisstatistik hinzufügen</h3>

                    <label for="date">Datum:</label>
                    <input type="date" id="date" name="date">
                        <xsl:attribute name="required">required</xsl:attribute>
                    </input><br/><br/>

                    <label for="price">Preis (CHF):</label>
                    <input type="number" id="price" name="price" step="0.01">
                        <xsl:attribute name="required">required</xsl:attribute>
                    </input>
                    <br/><br/>

                    <button type="submit">Kraftwerk hinzufügen</button>
                </form>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
