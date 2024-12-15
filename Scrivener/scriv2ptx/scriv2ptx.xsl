<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
 <xsl:strip-space elements="*"/>
 <xsl:preserve-space elements="slate"/>
 <xsl:template match="chapter | backmatter | frontmatter">
  <!-- add chapters to book.xml all in one place and
  <xsl:copy>
   <xsl:apply-templates select="@*"/>
   <xsl:apply-templates/>
  </xsl:copy> -->

  <!-- copy each chapter in source book.xml to its own file 
    uncomment to produce individual chapter files-->
  <xsl:result-document href="{@xml:id}.ptx">
   <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
   </xsl:copy>
  </xsl:result-document>
 </xsl:template>
<!--
Same for docinfo, but xml:id is not valid there.-->
  <xsl:template match="docinfo">
  <xsl:result-document href="docinfo.ptx">
    <xsl:copy-of select="."/>
  </xsl:result-document>
  </xsl:template>
  

 <!-- IdentityTransform -->
 <xsl:template match="node() | @*">
  <xsl:copy>
   <xsl:apply-templates select="node() | @*"/>
  </xsl:copy>
 </xsl:template>
 <!-- this template will create @xml:id for any nodes which have empty ones -->
 <!-- Can override this by explicitly adding Scrivener's metadata -->
 <!-- Rejects invalid characters, replaces spaces with -, and lower-cases it-->
 <!-- xml:id can't start with digits (not enforced here) -->
 <xsl:template match="@xml:id[. = '']">
  <xsl:attribute name="xml:id">
   <xsl:apply-templates select="./ancestor::chapter/@xml:id"/>   
   <xsl:text>-</xsl:text>
   <xsl:if test="name(..) = 'example'">
    <xsl:text>example-</xsl:text>
   </xsl:if>
    <xsl:value-of select="replace(translate(lower-case(../title), ' ', '-'), '[^a-zA-z0-9_-]', '-')"/>
  </xsl:attribute>
 </xsl:template>
 <!-- This template adds the ggb filename to the figure caption in the interactives.ptx file only.-->
 <xsl:template match="chapter[@xml:id = 'interactives']//caption">
  <xsl:copy>
   <xsl:value-of select="."/>
   <xsl:text> Source: </xsl:text>
   <xsl:value-of select="substring(../interactive/slate/@source, 8, 100)"/>
  </xsl:copy>
 </xsl:template>
 <!-- Format output to my liking -->
 <xsl:template match="title | caption">
  <!-- empty line prior to these elements -->
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:copy>
   <xsl:apply-templates/>
  </xsl:copy>
  <xsl:text>&#xa;&#xa;</xsl:text>
 </xsl:template>
 <xsl:template match="p | li | row | mrow">
  <!-- starts on new line -->
  <xsl:text>&#xa;</xsl:text>
  <xsl:copy>
   <xsl:apply-templates select="node() | @*"/>
  </xsl:copy>
 </xsl:template>
</xsl:stylesheet>
