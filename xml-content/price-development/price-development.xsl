<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <xsl:template match="feature">
        <html>
            <head>
                <title>Preisentwicklung</title>
                <link rel="stylesheet" type="text/css" href="theme.css"/>
            </head>
            <body>
                <h1>Energiewerke Mittelland Reloaded - Preisentwicklung</h1>
                <div class="content">
                    <svg:svg width="800" height="500">
                        <svg:line x1="50" y1="450" x2="750" y2="450" stroke="yellowgreen" stroke-width="2"/>
                        <svg:line x1="50" y1="50" x2="50" y2="450" stroke="yellowgreen" stroke-width="2"/>

                        <svg:text x="380" y="490" font-size="16" fill="white">Preisentwicklung</svg:text>
                        <svg:text x="10" y="250" font-size="16" fill="white" transform="rotate(-90,10,250)">CHF</svg:text>

                        <xsl:for-each select="document('../database/database.xml')/energie-data/energie-plant/plant[1]/statistics/price">
                            <xsl:variable name="x" select="50 + ((position() - 1) * 70)" />
                            <svg:text x="{$x}" y="470" font-size="12" fill="white" text-anchor="middle">
                                <xsl:value-of select="position() - 1"/>
                            </svg:text>
                        </xsl:for-each>

                        <xsl:call-template name="y-axis-labels"/>
                        <xsl:apply-templates select="document('../database/database.xml')/energie-data/energie-plant/plant" />
                    </svg:svg>
                </div>

            </body>
        </html>
    </xsl:template>

    <xsl:template name="y-axis-labels">
        <xsl:param name="value" select="0"/>
        <xsl:param name="yPos" select="450"/>
        
        <svg:text x="30" y="{$yPos}" font-size="12" fill="white" text-anchor="end">
            <xsl:value-of select="$value"/>
        </svg:text>

        <xsl:if test="$value &lt; 100">
            <xsl:call-template name="y-axis-labels">
                <xsl:with-param name="value" select="$value + 10"/>
                <xsl:with-param name="yPos" select="$yPos - 100"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="plant">
        <xsl:variable name="plantIndex" select="position() mod 5" />
        
        <xsl:variable name="color">
            <xsl:choose>
                <xsl:when test="$plantIndex = 0">red</xsl:when>
                <xsl:when test="$plantIndex = 1">blue</xsl:when>
                <xsl:when test="$plantIndex = 2">green</xsl:when>
                <xsl:when test="$plantIndex = 3">orange</xsl:when>
                <xsl:when test="$plantIndex = 4">purple</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <svg:polyline fill="none" stroke="{$color}" stroke-width="2">
            <xsl:attribute name="points">
                <xsl:for-each select="statistics/price">
                    <xsl:variable name="x" select="50 + ((position() - 1) * 70)"/>
                    <xsl:variable name="y" select="450 - (text() * 10)"/>
                    <xsl:value-of select="concat($x, ',', $y, ' ')"/>
                </xsl:for-each>
            </xsl:attribute>
        </svg:polyline>
    </xsl:template>

</xsl:stylesheet>
