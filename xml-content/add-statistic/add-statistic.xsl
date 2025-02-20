<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Statistik hinzufügen</title>
                <link rel="stylesheet" type="text/css" href="../theme.css"/>
            </head>
            <body>
                <h1>Energiewerke Mittelland Reloaded - Statistik hinzufügen</h1>
                <small><a href="../index.xml">Home</a></small>
                <div class="content">
                    <form action="/plants/statistics" method="post">
                        <label for="plant">Kraftwerk wählen:</label>
                        <select id="plant" name="plantId">
                            <xsl:apply-templates select="document('../database/database.xml')/energie-data/energie-plant/plant"/>
                        </select>
                        <br/><br/>

                        <label for="date">Datum:</label>
                        <input type="date" id="date" name="date">
                            <xsl:attribute name="min">
                                <xsl:value-of select="document('../database/database.xml')/energie-data/energie-plant/plant/statistics/price[last()]/@date"/>
                            </xsl:attribute>
                            <xsl:attribute name="required">required</xsl:attribute>
                        </input>
                        <br/><br/>

                        <label for="price">Preis (CHF):</label>
                        <input type="number" id="price" name="price" step="0.01">
                            <xsl:attribute name="required">required</xsl:attribute>
                        </input><br/><br/>

                        <button type="submit">Statistik hinzufügen</button>
                    </form>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="plant">
        <option value="{id}">
            <xsl:value-of select="name"/>
        </option>
    </xsl:template>

</xsl:stylesheet>
