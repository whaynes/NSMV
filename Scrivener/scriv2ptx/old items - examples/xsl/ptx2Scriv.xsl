<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xi="http://www.w3.org/2001/XInclude" exclude-result-prefixes="xs xd xi" version="1.0">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>
  <!-- This stylesheet will take a pretext file and create markdown headings for
      chapter/section/subsectin/subsubsection which can then be imported and split 
      to import it into Scrivener.  I don't think that it is possible to round trip this, 
      but it needs to be tested to find out.  1/28/19 weh -->

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="chapter | newsletter">
    <xsl:text>&#10;&#10;## </xsl:text>
    <xsl:value-of select="title"/>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="section">
    <xsl:text>&#10;&#10;### </xsl:text>
    <xsl:value-of select="title"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="subsection">
    <xsl:text>&#10;&#10;#### </xsl:text>
    <xsl:value-of select="title"/>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="mathbook | book  | introduction | article | pretext">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="title"/>

  <xsl:template match="p">
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

</xsl:stylesheet>
