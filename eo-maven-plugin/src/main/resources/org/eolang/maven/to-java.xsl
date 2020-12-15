<?xml version="1.0"?>
<!--
The MIT License (MIT)

Copyright (c) 2016-2020 Yegor Bugayenko

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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:eo="https://www.eolang.org" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
  <xsl:strip-space elements="*"/>
  <xsl:import href="/org/eolang/compiler/_funcs.xsl"/>
  <xsl:variable name="EOL">
    <xsl:value-of select="'&#10;'"/>
  </xsl:variable>
  <xsl:variable name="TAB">
    <xsl:text>  </xsl:text>
  </xsl:variable>
  <xsl:function name="eo:base-of">
    <xsl:param name="root"/>
    <xsl:param name="o"/>
    <xsl:choose>
      <xsl:when test="$o/@base and $o/@ref">
        <xsl:copy-of select="eo:base-of($root, $root//o[@name=$o/@base and @line=$o/@ref])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$o"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:function name="eo:class-name" as="xs:string">
    <xsl:param name="n" as="xs:string"/>
    <xsl:variable name="parts" select="tokenize($n, '\.')"/>
    <xsl:variable name="p">
      <xsl:for-each select="$parts">
        <xsl:if test="position()!=last()">
          <xsl:value-of select="."/>
          <xsl:text>.</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="c">
      <xsl:choose>
        <xsl:when test="$parts[last()]">
          <xsl:value-of select="$parts[last()]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$parts"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat($p, 'EO', replace($c, '\$', '\$EO'))"/>
  </xsl:function>
  <xsl:template match="@name">
    <xsl:attribute name="name">
      <xsl:value-of select="."/>
    </xsl:attribute>
    <xsl:attribute name="java-name">
      <xsl:value-of select="eo:class-name(.)"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="o[eo:abstract(.) and not(@atom)]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:element name="java">
        <xsl:value-of select="$EOL"/>
        <xsl:apply-templates select="/program" mode="license"/>
        <xsl:apply-templates select="/program/metas/meta[head='package']"/>
        <xsl:text>import org.eolang.*;</xsl:text>
        <xsl:value-of select="$EOL"/>
        <xsl:value-of select="$EOL"/>
        <xsl:text>public class </xsl:text>
        <xsl:value-of select="eo:class-name(@name)"/>
        <xsl:if test="o[@name='@']">
          <xsl:text> extends </xsl:text>
          <xsl:value-of select="eo:class-name(o[@name='@']/@base)"/>
        </xsl:if>
        <xsl:text> {</xsl:text>
        <xsl:value-of select="$EOL"/>
        <xsl:for-each select="o[@name and not(@base) and not(o)]">
          <xsl:value-of select="$TAB"/>
          <xsl:text>private Object </xsl:text>
          <xsl:value-of select="@name"/>
          <xsl:text>;</xsl:text>
          <xsl:value-of select="$EOL"/>
        </xsl:for-each>
        <xsl:value-of select="$TAB"/>
        <xsl:text>private </xsl:text>
        <xsl:value-of select="eo:class-name(@name)"/>
        <xsl:text>() {</xsl:text>
        <xsl:value-of select="$EOL"/>
        <xsl:value-of select="$TAB"/>
        <xsl:value-of select="$TAB"/>
        <xsl:text>// Intentionally empty</xsl:text>
        <xsl:value-of select="$EOL"/>
        <xsl:value-of select="$TAB"/>
        <xsl:text>}</xsl:text>
        <xsl:value-of select="$EOL"/>
        <xsl:apply-templates select="." mode="_copy"/>
        <xsl:apply-templates select="." mode="_init"/>
        <xsl:apply-templates select="o[@name and @base]" mode="method">
          <xsl:with-param name="indent">
            <xsl:value-of select="$TAB"/>
          </xsl:with-param>
        </xsl:apply-templates>
        <xsl:text>}</xsl:text>
      </xsl:element>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="o" mode="_copy">
    <xsl:value-of select="$TAB"/>
    <xsl:text>public </xsl:text>
    <xsl:value-of select="eo:class-name(@name)"/>
    <xsl:text> _copy() {</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:value-of select="$TAB"/>
    <xsl:value-of select="$TAB"/>
    <xsl:text>return new </xsl:text>
    <xsl:value-of select="eo:class-name(@name)"/>
    <xsl:text>();</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:value-of select="$TAB"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$EOL"/>
  </xsl:template>
  <xsl:template match="o" mode="_init">
    <xsl:value-of select="$TAB"/>
    <xsl:text>public void _init(</xsl:text>
    <xsl:for-each select="o[@name and not(@base)]">
      <xsl:if test="position() &gt; 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:text>final Object </xsl:text>
      <xsl:value-of select="@name"/>
    </xsl:for-each>
    <xsl:text>) {</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:for-each select="o[@name and not(@base)]">
      <xsl:value-of select="$TAB"/>
      <xsl:value-of select="$TAB"/>
      <xsl:text>this.</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text> = </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>;</xsl:text>
      <xsl:value-of select="$EOL"/>
    </xsl:for-each>
    <xsl:value-of select="$TAB"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$EOL"/>
  </xsl:template>
  <xsl:template match="o" mode="method">
    <xsl:param name="indent"/>
    <xsl:value-of select="$indent"/>
    <xsl:text>public </xsl:text>
    <xsl:value-of select="eo:class-name(@base)"/>
    <xsl:text> </xsl:text>
    <xsl:choose>
      <xsl:when test="@name='@'">
        <xsl:text>_origin</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>eo</xsl:text>
        <xsl:value-of select="@name"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>() {</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:apply-templates select=".">
      <xsl:with-param name="indent">
        <xsl:value-of select="$indent"/>
        <xsl:value-of select="$TAB"/>
      </xsl:with-param>
      <xsl:with-param name="name" select="'ret'"/>
    </xsl:apply-templates>
    <xsl:value-of select="$indent"/>
    <xsl:value-of select="$TAB"/>
    <xsl:text>return ret;</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:value-of select="$indent"/>
    <xsl:text>}</xsl:text>
    <xsl:value-of select="$EOL"/>
  </xsl:template>
  <xsl:template match="o[@base]">
    <xsl:param name="indent"/>
    <xsl:param name="name" select="'o'"/>
    <xsl:variable name="o" select="."/>
    <xsl:variable name="b" select="eo:base-of(/, $o)"/>
    <xsl:if test="not($b)">
      <xsl:message terminate="yes">
        <xsl:text>Can't find what "</xsl:text>
        <xsl:value-of select="@base"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="@ref"/>
        <xsl:text>" is pointing to</xsl:text>
      </xsl:message>
    </xsl:if>
    <xsl:value-of select="$indent"/>
    <xsl:choose>
      <xsl:when test="not($b) or not(eo:abstract($b))">
        <xsl:text>Object</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="eo:class-name($b/@name)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text> = </xsl:text>
    <xsl:choose>
      <xsl:when test="$b and eo:abstract($b)">
        <xsl:text>new </xsl:text>
        <xsl:value-of select="eo:class-name($b/@name)"/>
        <xsl:text>()</xsl:text>
      </xsl:when>
      <xsl:when test="$b[@name and not(@base)]">
        <xsl:text>this.</xsl:text>
        <xsl:value-of select="@base"/>
        <xsl:if test="o">
          <xsl:text>._copy()</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>this.</xsl:text>
        <xsl:text>eo</xsl:text>
        <xsl:value-of select="@base"/>
        <xsl:text>()</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>;</xsl:text>
    <xsl:text> // "</xsl:text>
    <xsl:value-of select="$b/@name"/>
    <xsl:text>" at line #</xsl:text>
    <xsl:value-of select="$b/@line"/>
    <xsl:value-of select="$EOL"/>
    <xsl:for-each select="o">
      <xsl:variable name="n">
        <xsl:value-of select="$name"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="position()"/>
      </xsl:variable>
      <xsl:apply-templates select=".">
        <xsl:with-param name="name" select="$n"/>
        <xsl:with-param name="indent">
          <xsl:value-of select="$indent"/>
          <xsl:value-of select="$TAB"/>
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:for-each>
    <xsl:if test="o">
      <xsl:value-of select="$indent"/>
      <xsl:value-of select="$TAB"/>
      <xsl:value-of select="$name"/>
      <xsl:text>._init(</xsl:text>
      <xsl:for-each select="o">
        <xsl:if test="position() &gt; 1">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:value-of select="$name"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="position()"/>
      </xsl:for-each>
      <xsl:text>);</xsl:text>
      <xsl:value-of select="$EOL"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="o[starts-with(@base, '.') and o]">
    <xsl:param name="indent"/>
    <!--    <xsl:apply-templates select="o[1]">-->
    <!--      <xsl:with-param name="indent">-->
    <!--        <xsl:value-of select="$indent"/>-->
    <!--      </xsl:with-param>-->
    <!--    </xsl:apply-templates>-->
    <xsl:value-of select="@base"/>
    <xsl:text>(</xsl:text>
    <xsl:text>)</xsl:text>
  </xsl:template>
  <xsl:template match="o[@base='org.eolang.string' and not(*) and normalize-space()]">
    <xsl:text>new EOstring(</xsl:text>
    <xsl:text>"</xsl:text>
    <xsl:value-of select="text()"/>
    <xsl:text>"</xsl:text>
    <xsl:text>)</xsl:text>
  </xsl:template>
  <xsl:template match="o[@base='org.eolang.int' and not(*) and normalize-space()]">
    <xsl:text>new EOinteger(</xsl:text>
    <xsl:value-of select="text()"/>
    <xsl:text>L)</xsl:text>
  </xsl:template>
  <xsl:template match="o[@base='org.eolang.float' and not(*) and normalize-space()]">
    <xsl:text>new EOfloat(</xsl:text>
    <xsl:value-of select="text()"/>
    <xsl:text>d)</xsl:text>
  </xsl:template>
  <xsl:template match="o[@base='org.eolang.char' and not(*) and normalize-space()]">
    <xsl:text>new EOchar(</xsl:text>
    <xsl:text>'</xsl:text>
    <xsl:value-of select="text()"/>
    <xsl:text>')</xsl:text>
  </xsl:template>
  <xsl:template match="o[@base='org.eolang.bool' and not(*) and normalize-space()]">
    <xsl:text>new EObool(</xsl:text>
    <xsl:value-of select="text()"/>
    <xsl:text>)</xsl:text>
  </xsl:template>
  <xsl:template match="/program/metas/meta[head='package']" mode="#all">
    <xsl:text>package </xsl:text>
    <xsl:value-of select="tail"/>
    <xsl:text>;</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:value-of select="$EOL"/>
  </xsl:template>
  <xsl:template match="/program" mode="license">
    <xsl:text>/*</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:text> * This file was auto-generated by eolang-maven-plugin</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:text> * on </xsl:text>
    <xsl:value-of select="current-dateTime()"/>
    <xsl:text>. Don't edit it,</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:text> * your changes will be discarded on the next build.</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:text> * The sources were compiled to XML on </xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:text> * </xsl:text>
    <xsl:value-of select="@time"/>
    <xsl:text> by the EO compiler v.</xsl:text>
    <xsl:value-of select="@version"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:text> */</xsl:text>
    <xsl:value-of select="$EOL"/>
    <xsl:value-of select="$EOL"/>
  </xsl:template>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
