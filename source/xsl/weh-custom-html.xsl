<!DOCTYPE xsl:stylesheet [
    <!ENTITY % entities SYSTEM "entities.ent">
    %entities;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:exsl="http://exslt.org/common" exclude-result-prefixes="html" version="1.0">
  <!-- Thin layer on PreTeXt XML -->
  <xsl:import href="./core/pretext-html.xsl"/>


  <!--This template wraps @landscape='yes' figures with a link to the full size pdf image. -->
  <xsl:template match="image[../@landscape = 'yes']">
    <xsl:variable name="rtf-layout">
      <xsl:apply-templates select="." mode="layout-parameters"/>
    </xsl:variable>
    <xsl:variable name="layout" select="exsl:node-set($rtf-layout)"/>
    <!-- div is constraint/positioning for contained image -->
    <div class="image-box">
      <xsl:attribute name="style">
        <xsl:text>width: </xsl:text>
        <xsl:value-of select="$layout/width"/>
        <xsl:text>%;</xsl:text>
        <xsl:text> margin-left: </xsl:text>
        <xsl:value-of select="$layout/left-margin"/>
        <xsl:text>%;</xsl:text>
        <xsl:text> margin-right: </xsl:text>
        <xsl:value-of select="$layout/right-margin"/>
        <xsl:text>%;</xsl:text>
      </xsl:attribute>
      <a href="external/{@source}.pdf">
        <xsl:apply-templates select="." mode="image-inclusion"/>
      </a>
    </div>
  </xsl:template>
  
  <!-- This allows including entire pdf.  path 'external' is hard coded -->
  <xsl:template match="includepdf">
    <xsl:text>\includepdf[pages=-]{external/</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>}%&#xa;</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>
