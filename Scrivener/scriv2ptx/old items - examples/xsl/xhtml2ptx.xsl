<?xml version="1.0" encoding="UTF-8"?>
<!-- I wrote these stylesheets to assist with transforming Jacob Moore's Adaptive Statics to ptx -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   exclude-result-prefixes="xs xd" version="2.0">
   <xsl:output method="xml" indent="yes"/>

   <xsl:template match="@* | node()">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
   </xsl:template>


   <xsl:template match="/">
      <mathbook>
         <article>
            
            <title>OER Statics</title>
            <section>
               <xsl:attribute name="xml:id">
                  <xsl:analyze-string select="document-uri(/)" regex=".*/(.*)\.html">
                     <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                     </xsl:matching-substring>
                  </xsl:analyze-string>
               </xsl:attribute>
               <xsl:apply-templates select="//div[@id = 'maincontent']/*"/>
            </section>
            <xsl:apply-templates select="//div[@id = 'workedproblems']"/>
         </article>
      </mathbook>
   </xsl:template>


   <xsl:template match="p">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="figure">
      <figure>
         <title>
            <xsl:value-of select="img/@alt"/>
         </title>
         <caption>
            <xsl:value-of select="figcaption"/>
         </caption>
         <image width="50%">
            <xsl:attribute name="source">
               <xsl:value-of select="img/@src"/>
            </xsl:attribute>
         </image>
      </figure>
   </xsl:template>


   <xsl:template match="div/h1">
      <title>
         <xsl:value-of select="."/>
      </title>
   </xsl:template>

   <xsl:template match="h2">
      <subsection>
         <title>
            <xsl:value-of select="."/>
         </title>
      </subsection>
   </xsl:template>

   <xsl:template match="h3">
      <subsubsection>
         <title>
            <xsl:value-of select="."/>
         </title>
      </subsubsection>
   </xsl:template>

   <xsl:template match="p">
      <p>
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="table[@class = &quot;figtable&quot;]">
      <xsl:apply-templates select="tr/td/figure"/>
   </xsl:template>

   <xsl:template match="strong">
      <em>
         <xsl:value-of select="."/>
      </em>
   </xsl:template>

   <xsl:template match="//div[@id = 'workedproblems']">
      <exercises>
         <xsl:apply-templates/>
      </exercises>
   </xsl:template>
   <xsl:template match="div[@id = 'problem']">
      <exercise>
         <statement>
            <xsl:for-each select="div/p">
               <xsl:copy-of select="."/>
            </xsl:for-each>
            <figure>
               <caption/>
               <image width="50%" source="{./div[@id='question']/img/@src}"/>
            </figure>
         </statement>
         <solution>
            <figure>
               <caption/>
               <image source="{./div[@id='solution']/div/a/@href}"/>
            </figure>
         </solution>
      </exercise>
   </xsl:template>
   <xsl:template match="script"/>
</xsl:stylesheet>
