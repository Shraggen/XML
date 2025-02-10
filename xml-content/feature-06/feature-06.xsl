<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg">
    <xsl:output method="xml" indent="yes" />
    
    <xsl:template match="feature">
        <svg:svg width="600" height="400">
            <xsl:apply-templates select="document('../database/database.xml')/energie-data/energie-plant/plant"/>
        </svg:svg>
    </xsl:template>
    
    <xsl:template match="plant">
        <xsl:variable name="plantName" select="name"/>
        <xsl:variable name="color" select="'blue'" />
        
        <svg:polyline fill="none" stroke="{$color}" stroke-width="2">
            <xsl:attribute name="points">
                <xsl:for-each select="statistics/price">
                    <xsl:variable name="x" select="position() * 50"/>
                    <xsl:variable name="y" select="300 - (text() * 10)"/>
                    <xsl:value-of select="concat($x, ',', $y, ' ')"/>
                </xsl:for-each>
            </xsl:attribute>
        </svg:polyline>
    </xsl:template>
</xsl:stylesheet>
