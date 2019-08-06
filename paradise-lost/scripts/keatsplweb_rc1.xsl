<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    

    <!-- Setup output and strip space --> 
    <xsl:output omit-xml-declaration="yes" indent="yes" encoding="UTF-8" method="html"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Defines variable for the stylesheet declaration. -->
    <xsl:variable name="docStylesheet">keatspl.css</xsl:variable>
    
    <!-- Defines a variable for a line break -->
    <xsl:variable name="return">
        <xsl:text>	
		</xsl:text>
    </xsl:variable>
    
    
    <!-- First matches everything-->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    
    
    
    <xsl:template match="tei:TEI">
        
        <!-- HTML 5.0 declaration -->
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
        </xsl:text>       
        <html>
            <head>
                <meta charset="UTF-8"/>
                <meta name="description" content="This html document generated from original XML master via XSLT."/>
                <meta name="description" content=""/>
                <meta name="keywords" content=""/>
                <script src="scripts/jquery-1.11.0.min.js"></script>
                <link rel="stylesheet" type="text/css" href="{$docStylesheet}"/>
                <link rel="stylesheet" type="text/css" href="/keatsl.css"/>
                <title><xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></title>
            </head>
            
            <body>
                
                <!-- Load the header !-->
                <div id="headerBar">
                    <xsl:text disable-output-escaping='yes'>
                    &lt;?php include '../head.php';?&gt;
                    </xsl:text>
                </div>
                
                
                <div id="contentWrapper">
                
                    <!-- Title -->
                    <div class="electronicTitle centeredText">
                        
                        <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/><br/>
                    
                    </div>
                    
                    
                    <!-- Main Body -->
                    
                    <div>
                    
                        <xsl:text disable-output-escaping='yes'>&lt;div class="empty_opener"&gt;</xsl:text>
                    
                        <xsl:apply-templates select="tei:text/tei:group/tei:text"/>
                        
                        <xsl:text disable-output-escaping='yes'>&lt;/div&gt;</xsl:text>
                        
                    </div>
            
                </div>
        
        
            </body>
        </html>
        
    </xsl:template>
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    <xsl:template match="tei:body">
        
        <xsl:apply-templates select="*"/>
        
    </xsl:template>
    
    
   
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    <!-- Renders all @rend attributes throughout the text, regardless of containing element -->
    
    <xsl:template match="//*[@rend]">
        
        <!-- Checks for an asterisk at a line, and applies appropriate formatting; otherwise, opens a span for the other @rend elements -->
        <xsl:choose>
            <xsl:when test="contains(@rend,'starred')">
                <!--<xsl:text disable-output-escaping='yes'>&lt;span style="position:relative;left:-5px;"&gt;*&lt;/span&gt;</xsl:text>-->
                <xsl:text disable-output-escaping='yes'>*</xsl:text>
                <xsl:call-template name="theLiner"/>
            </xsl:when>
            
            <xsl:when test="not(contains(@rend,'starred'))">
                
                <xsl:text disable-output-escaping='yes'>&lt;span class="</xsl:text>
                
            </xsl:when>
            
        </xsl:choose>
        
        
        
        <xsl:call-template name="cssMatcher">
            <xsl:with-param name="rendVal" select="@rend" />
        </xsl:call-template>
        
        
        
        
        <!-- Close up the span, if not a starred line -->
        
        <xsl:choose>
            
            <xsl:when test="not(contains(@rend,'starred'))">
            
                <xsl:text disable-output-escaping='yes'>"&gt;</xsl:text>
            
            </xsl:when>
        
        </xsl:choose>
        
        
        
        
        
        <!-- Now we add an indent for new verse paragraphs-->
        <!-- This gets a little sticky, but if the following conditions are true:
            1) The grandparent of the current node (<mod>) is <lg> ;
            2) The current node's parent (<l>) is the first child of the grandparent (<lg>) ;
            3) The current node does not have a preceding sibling (no <mod> before a <mod>) ; and 
            4) The @rend attribute of the current node (<mod>) is a vertical line ...
            ... then we insert three spaces for the indent of a verse paragraph
        -->
        <xsl:if test="
            (parent::*/parent::*[position()=last()][1]/name() = 'lg') 
            and not(parent::*/preceding-sibling::*[position()=last()][1]/name())
            and not(preceding-sibling::*/name())
            and (contains(@rend,'lv') or contains(@rend,'rv'))
            ">
            
                     
            <span class="tab_space">
            
            <!--<xsl:text disable-output-escaping="yes">&nbsp;&nbsp;&nbsp;</xsl:text>-->
            <xsl:text disable-output-escaping="yes">&#160;&#160;&#160;</xsl:text>
            
            </span>
            
        </xsl:if>
        
        
        <xsl:apply-templates/>
        
        <!-- If we're dealing with an asterisk at the start of a line -->
        <xsl:choose>
            <xsl:when test="contains(@rend,'starred')">
                <xsl:call-template name="theLineCloser"/>
            </xsl:when>
        </xsl:choose>
        
        
        <!-- Close up a rend tag if it's from a quotation, paragraph, emphasized text, title, or name ("confusion") -->
        <xsl:if test="name(.) = 'q' 
            or name(.) = 'p'
            or name(.) = 'emph'
            or name(.) = 'title'
            or name(.) = 'name'
            ">
            
            <xsl:text disable-output-escaping='yes'>&lt;/span&gt;</xsl:text>
            
        </xsl:if>
        
        <!-- And add a newline after a paragraph or a starred line-->
        <xsl:if test="name(.) = 'p'
            or name(.) = 'l'
            ">
            
            <br/>
            
        </xsl:if>
               
            
        
        
    </xsl:template> <!-- "rend" -->
    
    
    
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    <xsl:template match="tei:div">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    
    <xsl:template match="tei:lg">
        
        
        <xsl:apply-templates/>
        
        
    </xsl:template>
    
    
    
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    
    <xsl:template name="cssMatcher">
        
        <xsl:param name="rendVal" />
        
        <xsl:choose>
            
            <xsl:when test="contains($rendVal,'su')">
                <xsl:text>single_underline </xsl:text>                
            </xsl:when> 
            
            <xsl:when test="contains($rendVal,'du')">
                <xsl:text>double_underline </xsl:text>   
            </xsl:when>
            
            <xsl:when test="ends-with($rendVal,'lvs')">
                <xsl:text>left_vertical </xsl:text>   
            </xsl:when>
            
            <xsl:when test="contains($rendVal,'lvd')">
                <xsl:text>left_vertical_double </xsl:text>  
            </xsl:when>
            
            <xsl:when test="contains($rendVal,'lvt')">
                <xsl:text>left_vertical_triple </xsl:text>   
            </xsl:when>
            
            <xsl:when test="contains($rendVal,'rvs')">
                <xsl:text>right_vertical </xsl:text>   
            </xsl:when>
            
            <xsl:when test="contains($rendVal,'italic')">
                <xsl:text>italic_text </xsl:text>   
            </xsl:when>
            
        </xsl:choose>
        
    </xsl:template>
    
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    <xsl:template match="tei:l">    
        
        <xsl:call-template name="theLiner"/>
        
        <!--If we're at the first line in the line group, we indent-->
        <!--excepting the cases when the parent <lg> is the first <lg> -->
        <!--or when the poetry line has a marginal vertical line in Keats's hand (that is covered in the @rend match) -->
        <xsl:if test="position() = 1
            and (parent::*/preceding-sibling::*/name()='lg')
            and not(child::*/@rend = 'lvs')
            and not(child::*/@rend = 'lvd')
            and not(child::*/@rend = 'lvt')
            ">
            
            <span class="tab_space">
            
            <!--<xsl:text disable-output-escaping="yes">&nbsp;&nbsp;&nbsp;</xsl:text>-->
            <xsl:text disable-output-escaping="yes">&#160;&#160;&#160;</xsl:text>
            
            </span>
            
        </xsl:if>
        
        
        <xsl:apply-templates/>
        
        
        <xsl:call-template name="theLineCloser"/>
        
        <!-- New line in displayed text -->
        <br />
        
        <!-- For pretty printing of html, add a line-feed -->
        <xsl:text>&#xa;</xsl:text>
        
    </xsl:template> <!--tei:l-->
    
    
    
    
  
    
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    <xsl:template name="theLiner">               
        <!-- Finding the attributes BEFORE the currently line of poetry, so that we can open up the correct spans at the start of a <l> -->
        
        <!-- First, we make sure the line is in the content proper, not in the notes or paratexts. -->
        <xsl:variable name="lineParent" select="parent::*/name()" />
        <!--<xsl:text>Parent node: </xsl:text>
        <xsl:value-of select="$lineParent"/>
        <xsl:text>.  </xsl:text>-->
        
        
        <!-- If the line is in the content proper, apply the appropriate <spans> -->
        <xsl:if test="$lineParent = 'lg'">
        
            <!-- Find the numeric value of the most immediate previous anchor -->
            <xsl:variable name="last_anchor" select="(
                preceding::*/tei:anchor)[position()=last()][1]/@xml:id" />
            
            <!-- Regex to turn the xml:id into a digit -->
            <xsl:variable name="anchor_num" select="replace($last_anchor,'\D','')"/>        
    
            
            <!-- First, find any vertical line mods that go past the last anchor, and open a span with the appropriate styling-->
            <xsl:for-each select="
                preceding::*/tei:mod[position() &gt;= last()-7]
                ">
                
                <xsl:variable name="mod_num" select="replace(@spanTo,'\D','')"/>
                
                <xsl:if test="number($mod_num) &gt; number($anchor_num)">
                    
                    <xsl:if test="(@rend = 'lvs') or
                        (@rend = 'lvd') or
                        (@rend = 'lvt') or
                        (@rend = 'rvs')
                        ">
                        
                        <xsl:text disable-output-escaping='yes'>&lt;span class="</xsl:text>
                        <xsl:call-template name="cssMatcher">
                            <xsl:with-param name="rendVal" select="@rend" />
                        </xsl:call-template>
                        <xsl:text disable-output-escaping='yes'>"&gt;</xsl:text>
                        
                        
                    </xsl:if>
    
                </xsl:if>
                
            </xsl:for-each>
            
            
            <!-- Then, find any underline mods that go past the last anchor, and open a span with the appropriate styling-->
            <xsl:for-each select="
                preceding::*/tei:mod[position() &gt;= last()-7]
                ">
                
                <xsl:variable name="mod_num" select="replace(@spanTo,'\D','')"/>
                
                <xsl:if test="number($mod_num) &gt; number($anchor_num)">
                    
                    <xsl:if test="(@rend = 'su') or
                        (@rend = 'du')
                        ">
                        
                        <xsl:text disable-output-escaping='yes'>&lt;span class="</xsl:text>
                        <xsl:call-template name="cssMatcher">
                            <xsl:with-param name="rendVal" select="@rend" />
                        </xsl:call-template>
                        <xsl:text disable-output-escaping='yes'>"&gt;</xsl:text>
                        
                        
                    </xsl:if>
                    
                </xsl:if>
                
            </xsl:for-each>
            
        </xsl:if> <!-- test="$lineParent = 'lg'" -->
            
        
    </xsl:template> <!-- theLiner -->
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <xsl:template name="theLineCloser"> 
        <!-- Finds the mods and anchors INCLUDING AND BEFORE the current line of poetry, so that 
        we can close up the correct number of spans. -->
        
        

        <!-- Find the numeric value of the most immediate previous anchor -->
        <xsl:variable name="last_anchor" select="(
            self::*/tei:anchor | 
            preceding::*/tei:anchor)
            [position()=last()][1]/@xml:id" 
        />
        
        <!-- Regex to turn the xml:id into a digit -->
        <xsl:variable name="anchor_num" select="replace($last_anchor,'\D','')"/>
        
        
        
        <!-- For each mod from previous and current line that exceeds the last anchor number from the last current/previous anchor, add a closing span tag-->        
        <xsl:for-each select="(
            self::*/tei:mod |
            preceding::*/tei:mod[position() &gt;= last()-7]
            )">
            
            <xsl:variable name="mod_num" select="replace(@spanTo,'\D','')"/>
            
            <xsl:if test="number($mod_num) &gt; number($anchor_num)">
            
                <xsl:text disable-output-escaping='yes'>&lt;/span&gt;</xsl:text>
            
            </xsl:if>
            
            
        </xsl:for-each>
        
        
        
    </xsl:template> <!--theLineCloser-->
    
    
    
    
    
    
    
  
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    
    <!-- Closes single underlines -->
    <xsl:template match="tei:anchor
        [@xml:id]
        ">

        
        <!-- Closes up the span tag -->        
        <xsl:text disable-output-escaping='yes'>&lt;/span&gt;</xsl:text>
        
        
        
    </xsl:template>
    

    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    <xsl:template match="tei:desc">
        
        <!-- Do nothing, since we pull in tei:desc elsewhere -->
        
    </xsl:template>
    
    
    
    
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    <xsl:template match="tei:del">
        
        <xsl:text disable-output-escaping='yes'>&lt;span class="strikeThrough"&gt;</xsl:text>
        
        <xsl:apply-templates/>
        
        <xsl:text disable-output-escaping='yes'>&lt;/span&gt;</xsl:text>
        
    </xsl:template>
    
    
    
    
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    <xsl:template match="tei:lb">
        
        <xsl:text>&#xa;</xsl:text><br/><xsl:text>&#xa;</xsl:text>
        
        
        
    </xsl:template>
    
    
    
    
    
    
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    <xsl:template match="tei:pb">
        
        
        
        <!-- Loads in "pageID" the image filename -->
        <xsl:variable name="pageID">
            
            
            <xsl:value-of select="1"/>
            <!--<xsl:value-of select="$pageNum"/>-->
            
            <!--<xsl:text>book</xsl:text>
            <xsl:value-of select="ancestor::tei:div[1]/@n"/>
            <xsl:text>page</xsl:text>
            <xsl:value-of select="@n"/>-->
            
        </xsl:variable>
        
        
        <!--End the div of the previous page-->
        <xsl:text disable-output-escaping='yes'>&#xa;&lt;/div&gt;&#xa;&#xa;</xsl:text>

        
        <!-- New lines for pretty print in the html -->
        <br/><xsl:text>&#xa;</xsl:text>
        <br/><xsl:text>&#xa;</xsl:text>
        
        
        <!-- Open the new page div -->
        <xsl:text disable-output-escaping='yes'>&lt;div class="pageWrapper" id="kpl</xsl:text>
        
        <xsl:value-of select="count(preceding::tei:pb) + 1"/>
        
        <xsl:text disable-output-escaping='yes'>"&gt;</xsl:text>
        
        <xsl:text>&#xa;&#xa;</xsl:text>

        
        
        <!--DIV for the page number-->
        <xsl:text disable-output-escaping='yes'>&lt;div class="pageNumber"</xsl:text>            
        
            
        <!-- Hide the page number if it is in fact a number -->
        <xsl:if test="not(number(@n))">
            <xsl:text> style="visibility: hidden;"</xsl:text>                
        </xsl:if>
        
        <xsl:text disable-output-escaping='yes'>&gt;</xsl:text><xsl:value-of select="@n"/><xsl:text disable-output-escaping='yes'>&lt;/div&gt;&#xa;&#xa;</xsl:text>
        
        <br/><xsl:text>&#xa;</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        
        
        
        
        
        <!-- Now put in the page image -->
        
        <div class="imageFile">
            
                        
            <xsl:text disable-output-escaping='yes'>&lt;a href="https://curate.nd.edu/downloads/</xsl:text>
            
            <xsl:value-of select="@facs"/>
           
            <xsl:text disable-output-escaping='yes'>.jpg"&gt; 
            [Click for page image.]
            </xsl:text>
            
            
            <xsl:text disable-output-escaping='yes'>&lt;/a&gt;</xsl:text>
                
        </div>
        
        <xsl:text>&#xa;&#xa;</xsl:text>
        <br/>
        <xsl:text>&#xa;&#xa;</xsl:text>
        
        
        
        
        
        
        
        <xsl:variable name="pageID" select="@xml:id"/>
                            
                    
        
        <xsl:if test="@xml:id">
            
            
            
            <!--<xsl:text>Ok, this page has an ID. And here are all the notes nodes:</xsl:text>
            <xsl:value-of select="following::tei:note/@target"/>-->
                        
            <xsl:for-each select="following::tei:note">
                               
                <!--Two variables for matching the notes with the right pages-->
                <xsl:variable name="regexWord" select="string-join((replace($pageID,'\.','\\.'), '\W'), '')"/>
                <xsl:variable name="regexEnd" select="string-join((replace($pageID,'\.','\\.'), '$'), '')"/>
                
                <!-- See who wrote the author -->
                <xsl:variable name="noteAuthor" select="./@resp"/>
                
                
                <!-- When a note matches the page -->
                
                <xsl:if test="matches(current()/@target , $regexEnd) or matches(current()/@target , $regexWord)">
                    
                    
                    <div class = "writtenNote">
                    
                    
                        <!-- Select the correct header for Keats's note, or the editor's -->
                        <xsl:choose>
                            <xsl:when test="contains($noteAuthor,'Keats')">
                                <span class = "noteHeader">Note in Keats's Hand</span><br/>
                                <span class = "noteLocation"><xsl:value-of select="current()/tei:desc"/></span><br/><br/>
                            </xsl:when>
                            
                            <xsl:when test="contains($noteAuthor,'CharlesDilke')">
                                <span class = "noteHeader">Note in Charles Dilke's Hand</span><br/>
                                <span class = "noteLocation"><xsl:value-of select="current()/tei:desc"/></span><br/><br/>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                
                                <span class = "noteHeader">Editorial Note</span><br/><br/>
                                
                            </xsl:otherwise>
                            
                            
                        </xsl:choose>

                        
                        <span class = "noteContent"><xsl:apply-templates select="current()"/></span><br/>
                        
                        <br/>
                    
                    </div>
                    
                </xsl:if>
                
            </xsl:for-each>
            

            
            <xsl:text>&#xa;&#xa;</xsl:text>
            
        </xsl:if>
            
        
        


        
    </xsl:template>
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    <!-- ******************************************************************************* -->
    
    <xsl:template match="tei:q | tei:ref">
        
        <xsl:variable name="whichtag" select="name(.)"/>
        
        <!-- Depending on which tag we have, a different attribute contains the link -->
        <xsl:variable name="qsource">
            
            <xsl:choose>
                <xsl:when test="contains($whichtag,'q')">
                    
                    <xsl:value-of select="@source"/>
                    
                </xsl:when>
                
                <xsl:when test="contains($whichtag,'ref')">
                    
                    <xsl:value-of select="@target"/>
                    
                </xsl:when>                
                
            </xsl:choose>
            
            
        </xsl:variable>
        
        
        
        
        <!-- Add links only if the @source or @target has content -->        
        <xsl:choose>

        <xsl:when test="$qsource!=''">
            
                <!-- Regex to replace everything after a space with nothing,
                since we are effectively ignoring @source attributes that 
                contain more than one referenced location. -->
                <xsl:variable name="regexsourcefirst" select="string-join(replace($qsource,'\s(.*)',''), '')"/>
                
                <!--And now, strip out the number sign # -->
                <xsl:variable name="regexsource" select="string-join(replace($regexsourcefirst,'&#35;',''), '')"/>
                
                
                
                
                <xsl:variable name="idvalue">
        
                    <xsl:for-each select="preceding::*/tei:l">
                       
                        <xsl:choose>
                            
                            <xsl:when test="$qsource
                            and current()/@xml:id
                            and ($regexsource = current()/@xml:id)
                            ">
                                
                                <!--and not(contains($qsource,' '))-->
                                
                                <!-- Count up all the page breaks: this will give us the ID
                                we need for the page turner in the web edition -->
        
                                <xsl:value-of select="count(preceding::tei:pb)"/>
                                        
                            </xsl:when>
                        
                        </xsl:choose>
                       
                    </xsl:for-each>
                    
                    <!-- If we're dealing with a "ref", we may have reference to a page instead of a line of poetry -->
                    <xsl:choose>
                        
                        <xsl:when test="contains($whichtag,'ref')
                            and not(ends-with($regexsource,'l'))
                            ">
                            
                            <xsl:for-each select="preceding::*/tei:pb">
                                
                                <xsl:choose>
                                    
                                    <xsl:when test="$qsource
                                        and current()/@xml:id
                                        and ($regexsource = current()/@xml:id)
                                        ">
                                        
                                        <!--and contains($regexsource, current()/@xml:id)-->
                                        
                                        <!-- Count up all the page breaks: this will give us the ID
                                we need for the page turner in the web edition -->
                                        
                                        <xsl:value-of select="count(preceding::tei:pb) + 1"/>
                                        
                                    </xsl:when>
                                    
                                </xsl:choose>
                                
                            </xsl:for-each>
                            
                        </xsl:when>
                        
                    </xsl:choose>
                    
                </xsl:variable>
                
                
                
                <!--Plug in a link to the right page-->
                <xsl:if test="$idvalue!=''">
                    
                    <xsl:text disable-output-escaping='yes'>&lt;a href="#kpl</xsl:text>
                    
                    <xsl:value-of select="$idvalue"/>
                    
                    <xsl:text disable-output-escaping='yes'>"&gt;</xsl:text>
                    
                </xsl:if>
                
                
                
                <!--Or, if the ref target is a web page URL-->
                <xsl:if test="starts-with($regexsourcefirst,'http')">
                    
                    <xsl:text disable-output-escaping='yes'>&lt;a href="</xsl:text>
                    
                    <xsl:value-of select="$regexsourcefirst"/>
                    
                    <xsl:text disable-output-escaping='yes'>"&gt;</xsl:text>
                    
                </xsl:if>
                
                
                
                <xsl:apply-templates/>
                
                
                <xsl:if test="$idvalue!='' or
                    starts-with($regexsource,'http')
                    ">
                    
                    <xsl:text disable-output-escaping='yes'>&lt;/a&gt;</xsl:text>
                    
                </xsl:if>
                
                
                
                
            </xsl:when>
            
            
            <xsl:otherwise>
                
                <xsl:apply-templates/>
                
            </xsl:otherwise>
       
        </xsl:choose>
    
    </xsl:template>
    
    
    
    
    
    
    
    
    
    <xsl:template match="tei:p">
        
        
        <xsl:apply-templates/>
        <br/><br/>
        <!-- For pretty printing of html, add a line-feed -->
        <xsl:text>&#xa;</xsl:text>
        
        
    </xsl:template>
   
    
    

</xsl:stylesheet>