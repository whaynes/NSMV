<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

 <xsl:output indent="yes" method="xml"/>

 <xsl:template match="@* | node()">
  <xsl:copy>
   <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
 </xsl:template>

 <!-- this template copies the scrivener binder, but overwrites the drafts folder with the new items -->
 <!-- the items themselves are in the Files/Data directory -->
 <xsl:template match="ScrivenerProject/Binder/BinderItem[@Type = 'DraftFolder']">
  <xsl:copy>
   <xsl:apply-templates select="@* | node()"/>
   <xsl:apply-templates select="document('binder-out.xml')/Children"/>
  </xsl:copy>
 </xsl:template>
</xsl:stylesheet>
