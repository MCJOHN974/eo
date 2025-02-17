<?xml version="1.0" encoding="UTF-8"?>
<!--
The MIT License (MIT)

Copyright (c) 2016-2022 Objectionary.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" id="to-xembly" version="2.0">
  <xsl:output encoding="UTF-8" method="xml"/>
  <xsl:param name="testing"/>
  <xsl:variable name="EOL">
    <xsl:value-of select="'&#10;'"/>
  </xsl:variable>
  <xsl:variable name="TAB">
    <xsl:value-of select="$EOL"/>
    <xsl:value-of select="'  '"/>
  </xsl:variable>
  <xsl:template match="/gmi">
    <xsl:element name="xembly">
      <xsl:apply-templates select="i"/>
    </xsl:element>
  </xsl:template>
  <!-- ADD(V1) -->
  <xsl:template match="i[@name='ADD']">
    <xsl:if test="$testing = 'yes'">
      <!-- Validate the absence of vertex V1: -->
      <xsl:text>XPATH "/test/graph/v[@id='</xsl:text>
      <xsl:value-of select="a[1]"/>
      <xsl:text>']"; STRICT "0"; </xsl:text>
    </xsl:if>
    <!-- Add vertex V1: -->
    <xsl:text>XPATH "/test/graph"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ADD "v"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ATTR "id", "</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>";</xsl:text>
    <xsl:value-of select="$EOL"/>
  </xsl:template>
  <!-- BIND(E1, V1, V2, A) -->
  <xsl:template match="i[@name='BIND']">
    <xsl:if test="$testing = 'yes'">
      <!-- Validate the presence of vertex V2: -->
      <xsl:text>XPATH "/test/graph/v[@id='</xsl:text>
      <xsl:value-of select="a[3]"/>
      <xsl:text>']"; STRICT "1"; </xsl:text>
      <!-- Validate the absence of edge E1: -->
      <xsl:text>XPATH "/test/graph/v/e[@id='</xsl:text>
      <xsl:value-of select="a[1]"/>
      <xsl:text>']"; STRICT "0"; </xsl:text>
      <!-- Validate the absence of V1.A edge: -->
      <xsl:text>XPATH "/test/graph/v[@id='</xsl:text>
      <xsl:value-of select="a[2]"/>
      <xsl:text>']/e[@title='</xsl:text>
      <xsl:value-of select="a[4]"/>
      <xsl:text>']"; STRICT "0"; </xsl:text>
    </xsl:if>
    <!-- Go to V1: -->
    <xsl:text>XPATH "/test/graph/v[@id='</xsl:text>
    <xsl:value-of select="a[2]"/>
    <xsl:text>']"; STRICT "1"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <!-- Add edge E1: -->
    <xsl:text>ADD "e";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ATTR "id", "</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ATTR "to", "</xsl:text>
    <xsl:value-of select="a[3]"/>
    <xsl:text>"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ATTR "title", "</xsl:text>
    <xsl:value-of select="a[4]"/>
    <xsl:text>";</xsl:text>
    <xsl:value-of select="$EOL"/>
    <!-- Add backward ρ-edge and 𝜎-edge from V2 to V1: -->
    <xsl:variable name="i" select="."/>
    <xsl:for-each select="('ρ', '𝜎')">
      <xsl:text>XPATH "/test/graph/v[@id='</xsl:text>
      <xsl:value-of select="$i/a[3]"/>
      <xsl:text>' and not(e[@title='</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>'])]";</xsl:text>
      <xsl:value-of select="$TAB"/>
      <xsl:text>ADD "e";</xsl:text>
      <xsl:value-of select="$TAB"/>
      <xsl:text>ATTR "id", "</xsl:text>
      <xsl:value-of select="$i/a[1]"/>
      <xsl:text>.rho</xsl:text>
      <xsl:text>"; </xsl:text>
      <xsl:value-of select="$TAB"/>
      <xsl:text>ATTR "to", "</xsl:text>
      <xsl:value-of select="$i/a[2]"/>
      <xsl:text>"; </xsl:text>
      <xsl:value-of select="$TAB"/>
      <xsl:text>ATTR "title", "</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>"; </xsl:text>
      <xsl:value-of select="$EOL"/>
    </xsl:for-each>
  </xsl:template>
  <!-- DATA(V1, BYTES) -->
  <xsl:template match="i[@name='DATA']">
    <!-- Go to vertex V1: -->
    <xsl:text>XPATH "/test/graph/v[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']"; STRICT "1"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <!-- Set Bytes to V1: -->
    <xsl:text>ADD "data"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>SET "</xsl:text>
    <xsl:value-of select="a[2]"/>
    <xsl:text>";</xsl:text>
    <xsl:value-of select="$EOL"/>
  </xsl:template>
  <!-- ATOM(V1, LAMBDA) -->
  <xsl:template match="i[@name='ATOM']">
    <!-- Go to vertex V1: -->
    <xsl:text>XPATH "/test/graph/v[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']"; STRICT "1"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <!-- Set Lambda to V1: -->
    <xsl:text>ADD "lambda"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>SET "</xsl:text>
    <xsl:value-of select="a[2]"/>
    <xsl:text>";</xsl:text>
    <xsl:value-of select="$EOL"/>
  </xsl:template>
  <!-- COPY(E1, V3, E2) -->
  <!-- We assume here that E1 is an edge from V1 to V2 -->
  <xsl:template match="i[@name='COPY']">
    <xsl:if test="$testing = 'yes'">
      <!-- Validate the presence of the edge E1: -->
      <xsl:text>XPATH "/test/graph/v/e[@id='</xsl:text>
      <xsl:value-of select="a[1]"/>
      <xsl:text>']"; STRICT "1"; </xsl:text>
      <!-- Validate the absence of the vertex V3: -->
      <xsl:text>XPATH "/test/graph/v[@id='</xsl:text>
      <xsl:value-of select="a[2]"/>
      <xsl:text>']"; STRICT "0"; </xsl:text>
      <!-- Validate the absence of the edge E2: -->
      <xsl:text>XPATH "/test/graph/v/e[@id='</xsl:text>
      <xsl:value-of select="a[3]"/>
      <xsl:text>']"; STRICT "0"; </xsl:text>
      <xsl:value-of select="$TAB"/>
    </xsl:if>
    <!-- Rename V2 to V3: -->
    <xsl:text>XPATH "/test/graph/v[@id=/test/graph/v/e[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']/@to]"; STRICT "1";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ATTR "id", "</xsl:text>
    <xsl:value-of select="a[2]"/>
    <xsl:text>";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <!-- Add edge E2 from V1 to V3: -->
    <xsl:text>XPATH "/test/graph/v[e[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']]"; STRICT "1";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ADD "e";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ATTR "id", "</xsl:text>
    <xsl:value-of select="a[3]"/>
    <xsl:text>";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ATTR "to", "</xsl:text>
    <xsl:value-of select="a[2]"/>
    <xsl:text>";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>XATTR "title", "/test/graph/v/e[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']/@title</xsl:text>
    <xsl:text>";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <!-- Add new vertex V2: -->
    <xsl:text>XPATH "/test/graph"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ADD "v"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>XATTR "id", "/test/graph/v/e[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']/@to";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <!-- Move lambda from V3 to V2: -->
    <xsl:text>XPATH "/test/graph/v[@id=/test/graph/v/e[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']/@to]"; STRICT "1";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ADD "lambda";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>XSET "/test/graph/v[@id='</xsl:text>
    <xsl:value-of select="a[2]"/>
    <xsl:text>']/lambda";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>XPATH "/test/graph/v[@id=/test/graph/v/e[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']/@to]/lambda[.='']"; REMOVE;</xsl:text>
    <xsl:text>XPATH "/test/graph/v[@id='</xsl:text>
    <xsl:value-of select="a[2]"/>
    <xsl:text>']/lambda"; REMOVE;</xsl:text>
    <!-- Redirect all edges going to V2 to V3: -->
    <xsl:text>XPATH "/test/graph/v/e[@id != '</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>' and @to=/test/graph/v/e[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']/@to]";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ATTR "to", "</xsl:text>
    <xsl:value-of select="a[2]"/>
    <xsl:text>";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <!-- Add pi-edge from V3 to V2: -->
    <xsl:text>XPATH "/test/graph/v[@id='</xsl:text>
    <xsl:value-of select="a[2]"/>
    <xsl:text>']"; STRICT "1";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ADD "e"; </xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ATTR "id", "</xsl:text>
    <xsl:value-of select="a[3]"/>
    <xsl:text>.pi";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>XATTR "to", "/test/graph/v/e[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']/@to";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>ATTR "title", "π";</xsl:text>
    <xsl:value-of select="$TAB"/>
    <!-- Remove edge E1: -->
    <xsl:text>XPATH "/test/graph/v/e[@id='</xsl:text>
    <xsl:value-of select="a[1]"/>
    <xsl:text>']"; STRICT "1"; </xsl:text>
    <xsl:text>REMOVE;</xsl:text>
    <xsl:value-of select="$TAB"/>
  </xsl:template>
  <xsl:template match="i">
    <xsl:message terminate="yes">
      <xsl:text>Unknown GMI '</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>'</xsl:text>
    </xsl:message>
  </xsl:template>
</xsl:stylesheet>
