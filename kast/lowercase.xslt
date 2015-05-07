<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output exclude-result-prefixes="xsl xs" indent="yes"/>

  <xsl:template match="*">
    <xsl:element name="{translate(local-name(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')}">
    <!--<xsl:element name="{lower-case(local-name())}">-->
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

    <!-- <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>  
    </xsl:template> -->

</xsl:stylesheet>
