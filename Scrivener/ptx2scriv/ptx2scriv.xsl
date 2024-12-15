<?xml version="1.0" encoding="UTF-8"?>  

<!-- This stylesheet will take a pretext file and create an srivener .scrivx file and the associated rtf files for import-->

<!DOCTYPE xsl:stylesheet [
    <!ENTITY % entities SYSTEM "/Users/whaynes/ptx/mathbook/xsl/entities.ent">
    %entities;
    <!ENTITY CONTAINERS "mathbook|pretext|article|book|docinfo|titlepage|abstract|colophon|introduction|conclusion|paragraphs|exercise">
    <!ENTITY FOLDERS   "&STRUCTURAL; | &EXAMPLE-LIKE;|&PROJECT-LIKE;|&CONTAINERS;">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:uuid="java:java.util.UUID" xmlns:xi="http://www.w3.org/2001/XInclude" version="2.0">
 <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
 <xsl:strip-space elements="*"/>

 <xsl:variable name="now" select="current-dateTime()"/>

 <xsl:template match="/">
  <!-- analyze ptx to find folders and text, and save in variable $structure-->
  <xsl:variable name="structure">
   <folder>
    <Title>Document</Title>
    <xsl:apply-templates/>
   </folder>
  </xsl:variable>
  <!-- save structure for debugging -->
  <xsl:result-document href="structure.xml">
   <xsl:copy-of select="$structure"/>
  </xsl:result-document>

  <!--  create binder and export files for Scrivener -->
  <xsl:variable name="uid" select="upper-case(uuid:randomUUID())"/>


  <!-- Create Children for top-level DraftFolder and write out associated rtf files -->
  <Children>
   <xsl:apply-templates select="$structure/*"/>
  </Children>
 </xsl:template>

 <!-- Make 'folders' for things selected by &FOLDERS; -->
 <xsl:template match="&FOLDERS;">
  <folder ptx="{name()}">
   <xsl:apply-templates select="@*"/>
   <Title>
    <xsl:if test="not(title)">
     <xsl:copy-of select="name()"/>
    </xsl:if>
    <xsl:if test="title">
     <xsl:copy-of select="title/* | title/text()"/>
    </xsl:if>
   </Title>
   <xsl:apply-templates/>
  </folder>
 </xsl:template>

 <!-- make 'items' to hold everything else -->
 <!-- adjacent items will be grouped into one BinderItem and correspoinding file -->
 <xsl:template match="element()">
  <item>
   <xsl:apply-templates select="." mode="dive"/>
  </item>
 </xsl:template>

 <!-- identity template for attributes -->
 <xsl:template match="@*">
  <xsl:copy-of select="."/>
 </xsl:template>

 <!-- already dealt with the title -->
 <xsl:template match="title"/>

 <!-- identity template to copy contents of items -->
 <xsl:template match="node() | @*" mode="dive">

  <xsl:message terminate="no"> Copied by Identity rule: <xsl:copy-of select="name()"/>
   <xsl:text> </xsl:text>
   <xsl:value-of select="."/>
  </xsl:message>

  <xsl:copy copy-namespaces="no">
   <xsl:apply-templates select="node() | @*" mode="dive"/>
  </xsl:copy>
 </xsl:template>

 <xsl:template match="comment()">
  <item>
   <xsl:comment><xsl:copy-of select="."/></xsl:comment>
  </item>
 </xsl:template>


 <!-- code above builds structure document -->
 <!-- code below builds binder and files for Scrivener -->

 <!-- This template create BinderItems and write out the files -->

 <xsl:template match="folder">
  <!-- make a binder item for each folder -->
  <xsl:variable name="uid" select="upper-case(uuid:randomUUID())"/>
  <BinderItem UUID="{$uid}" Type="Folder" ptx="{@ptx}" Created="{$now}">
   <Title>
    <xsl:value-of select="Title"/>
   </Title>
   <MetaData>
    <CustomMetaData>
     <MetaDataItem>
      <FieldID>ptx-container</FieldID>
      <Value>
       <xsl:value-of select="@ptx"/>
      </Value>
     </MetaDataItem>
     <MetaDataItem>
      <FieldID>xml:id</FieldID>
      <Value>
       <xsl:value-of select="@xml:id"/>
      </Value>
     </MetaDataItem>
     <MetaDataItem>
      <FieldID>Other Attributes</FieldID>
      <Value>
       <xsl:copy-of select="@* except @xml:id except @ptx"/>
      </Value>
     </MetaDataItem>
    </CustomMetaData>
   </MetaData>
   <!-- Add children to the folder -->
   <Children>
    <xsl:for-each-group select="*" group-adjacent="name()">
     <xsl:choose>
      <xsl:when test="current-grouping-key() = 'item'">
       <!-- If the folders starts with a group of items, put them in the folder's text contents -->
       <!-- otherwise, make a BinderItem for each group of adjacent items -->
       <!-- first group of items has position = 2 because folder's <Title> is  in position = 1-->

       <xsl:variable name="id">
        <xsl:choose>
         <xsl:when test="position() = 2">
          <!-- When items come first, use folder's ID -->
          <xsl:value-of select="$uid"/>
         </xsl:when>
         <xsl:otherwise>
          <!-- Just make a new ID -->
          <xsl:value-of select="upper-case(uuid:randomUUID())"/>
         </xsl:otherwise>
        </xsl:choose>
       </xsl:variable>


       <xsl:if test="position() > 2">
        <!-- make a new binderItem for the items -->
        <BinderItem UUID="{$id}" Type="Text" Created="{$now}">
         <Title/>
        </BinderItem>
       </xsl:if>


       <!-- Write out consecutive items after stripping off 'item' tags-->
       <!-- Text files produced here, to be converted to rtf by textutil -->
       <!-- write all adjacent items -->
       <xsl:result-document href="Data/{$id}/content.txt" method="xml" encoding="utf-8">

        <xsl:for-each select="current-group()">
         <!-- this strips item tags -->
         <xsl:copy-of select="node()" copy-namespaces="no"/>
         <xsl:text>&#10;</xsl:text>
        </xsl:for-each>

       </xsl:result-document>
       <!-- Also write out 'content.styles' alongside content in each folder -->
       <xsl:result-document href="Data/{$id}/content.styles" method="text" encoding="utf-8">
<styles>663188CF-EBA6-4570-8804-EB3248E3CD36,B4489571-F4C6-4899-B5ED-701E18305D9D,CE282CF4-3566-4BF6-AA2D-59455EF8FD9B,F0B5171F-65DC-47D0-BE7E-BB284F878CEB,6AF7BB1E-E655-4FF6-8A96-FD6A374F380D,D1B37D27-0DEA-46A9-B4F8-44ACBC20CA1B,3CF3B33D-0FB6-4FDE-B637-B4425C664610,A58C5FE7-B3C7-4940-A3CA-D5DF292FC880,B2CEDC4B-50F5-44D7-B386-5D074FA4CEB0,14298228-B953-41CE-A9A3-404DAED55843,CDD933AB-DDE9-4FE6-9461-9C97BD041F1E,8940DFDA-86AC-46FB-B36E-5E83171190CD</styles>
       </xsl:result-document>
      </xsl:when>

      <!-- Handle folders here -->
      <xsl:when test="current-grouping-key() = 'folder'">
       <!-- the group might contain more than one folder, so make a BinderItem for each one -->
       <xsl:for-each select="current-group()">
        <!-- recurse on folders -->
        <xsl:apply-templates select="current()"/>
       </xsl:for-each>
      </xsl:when>
     </xsl:choose>
    </xsl:for-each-group>
   </Children>
  </BinderItem>
 </xsl:template>

 <xsl:template name="binder-item-boilerplate">
  <MetaData>
   <IncludeInCompile>Yes</IncludeInCompile>
  </MetaData>
  <TextSettings>
   <TextSelection>0,0</TextSelection>
  </TextSettings>
 </xsl:template>


 <!--  To use this. -->
 <!-- 1. run xslt against ptx doc. -->
 <!-- 2. run makefile to convert files to rtf, move them where they belong and update binder -->
 <!-- 3. In scrivener option-command-s to 'save and rebuild search indexes -->


 <!-- TODO  Binder Item metadata shoud be created from Folder attributes -->
 <!-- TODO  Make Section Types work properly -->
 <!-- TODO  Make Srivener to PTX work so things round-trip -->



</xsl:stylesheet>
