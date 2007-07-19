<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>



<pg:fragment type="html">
	<!--####
		Project: Let's Improve Transportation!
		Page: Object for Structured Discussion for Projects
		Description: This page will list and map out all of the projects in the given decision situation.
					 The javascript on this page will allow for map manipulation.  Clicking on a project
					 will 
		Author(s): Jordan Isip, Adam Hindman, John Le
		Todo Items:
			[x] Initial Skeleton Code (Jordan)
			[x] Integrate Structured Discussion (Jordan)
			[x] Integrate Project Tree (Jordan)
			[x] Integrate Layout (Adam) 
			[x] Ensure loop is working with backend (Jordan)
			[x] Ensure tree menu is working correctly (Jordan)
			[x] Test with backend contractor code (Jordan)
	#### -->
<!-- begin "overview and instructions" area -->

	<div id="overview" class="box2">
		<h3>Overview and instructions</h3>
		Learn about proposed projects for improving or expanding our regional transportation system.
		<ul>
			<li>Click on a project to view it on the map and read more about it.</li>
			<li>Discuss the benefits and drawbacks of any project in the discussion area below.</li>
		</ul>
			<p>When you are ready, feel free to <a class="FIXLINK" href="#">Review funding options</a> (Step 3b) and <a class="FIXLINK" href="#">Create your own package</a> (Step 3c). You have until <span class="FIXDATE"><strong>October 21</strong></span> to create your own package.</p>
				<a href="#" onclick="Effect.toggle('hiddenRM','blind'); return false">Read more about this step</a>
		<p id="hiddenRM" style="display:none">The proposed projects have been examined by a panel of transportation specialists who assigned scores for the improvement factors we reviewed in Step 2. (<a href="readmore.jsp">Read more about the scoring process</a>). After reviewing the proposed transportation projects (Step 3a) and funding options (Step 3b) you will have an opportunity to create your own transportation package by selecting the projects and funding options you like best. </p>
	</div>
	<!-- end overview -->
	<!-- begin Object -->
	<div id="object">
		<div id="rp3a-left" class="floatLeft">
			<!-- begin collapsible list of projects -->
			<div id="newtable">
				<table cellpadding=0 cellspacing=0>
					<tr class="tableHeading">
						<th colspan="2" class="first">Proposed improvement projects</th>
						<th class="right"><span id="hiddenLabel" style="visibility:hidden">Money needed</span></th>
					</tr>
					
				
					<c:forEach var="category" begin="1" end="2">
						<!-- start road projects -->
						<tr>
							<c:choose>
								<c:when test="${category == 1}">
									<td class="category" colspan="3"><strong>Road projects</strong></td>
								</c:when>
								<c:otherwise>
									<td class="category" colspan="3"><strong>Transit projects</strong></td>
								</c:otherwise>
							</c:choose>
						</tr>
						<!-- end CATEGORY LABEL -->
						<!-- ******* LOOP ENTIRE PROJECT ******** -->
						<c:forEach var="infoObject" items="${infoStructure.infoObjects}" varStatus="loop">
							<c:if test="${infoObject.object.project.transMode == category}">
								
								
								<!-- begin PROJECT -->
								<tr class="${(infoObject.object.project.inclusive) ? 'fundingType' : 'fundingType2'}">
									<td class="fundingSourceItem">${infoObject.object.project.name}</td>
									<td class="col2">&nbsp;</td>
									<td class="col3">&nbsp;</td>
								</tr>
								<!-- end PROJECT -->
								
								<!-- begin objectives -->
								<tr class="objectives" id="objective${loop.index}">
									<td colspan="3">
										<table>
											<c:set var="doNothing"value="true"/>
											<c:forEach var="altRef" items="${infoObject.object.altRefs}" varStatus="loop">
												<tr>
													<td>
													    <pg:url page="/projectAlt.do" params="altrefId=${altRef.id}">${altRef.alternative.name}</pg:url>
													</td>
													<td class="cost">
														$<fmt:formatNumber maxFractionDigits="0" value="${altRef.alternative.cost/1000000}" /> million
														</td>
												</tr>
												<c:if test="${pg:contains(userPkg.projAltRefs,altRef)}">
													<c:set var="doNothing"value="false"/>
												</c:if>
											</c:forEach>
										</table>
									</td>
								</tr>
								<!-- end objectives -->
							</c:if>
						</c:forEach>
						<!-- ******* END LOOP ENTIRE PROJECT ******** -->
					</c:forEach>
				</table>
			</div>

			<!-- end collapsible project list -->
		</div>
		<!-- end rp3a-left -->
	</div>
	<!-- begin cell containing Google Map object -->
	<!-- GUIRONG: This can be up to 420px wide -->
	<div id="map" class="floatRight">Project footprints are intended for location reference only.</div>
	<!-- end cell containing Google Map object -->
	<!-- begin firefox height hack -->
	<div class="clearBoth"></div>
	<!-- end firefox height hack -->
</div>
<!-- end Object-->

</pg:fragment>

<pg:fragment type="script">
	//All Javascript that is internal to this page must go here - not sdRoomMain.
	/* *************** load a dynamic javascript or css file ****************/

	io.loadDynamicFile = function(file){
		var start = file.indexOf('.') + 1
		var finish = file.length
		var type = file.substring(start,finish)
		
		var headElem = document.getElementsByTagName('head')[0];
		if(type == "css"){
			var cssLinkElem = document.createElement('link');
			cssLinkElem.setAttribute('href', file);
			cssLinkElem.setAttribute('type', 'text/css');
			cssLinkElem.setAttribute('rel', 'stylesheet');
			headElem.appendChild(cssLinkElem);
		}else{ //javascript
			var jsLinkElem = document.createElement('script');
			jsLinkElem.setAttribute('src', file);
			jsLinkElem.setAttribute('type', 'text/javascript');
			headElem.appendChild(jsLinkElem);
		}
		
	}
	
	io.expandAll = function(){
		var rows = document.getElementsByClassName('objectives');
		var icons = document.getElementsByClassName('icon');
		//alert('icons: ' + icons.length + ' rows: ' + rows.length);
		for (var i = 1;i <= rows.length; i++){
			var row = 'objective' + i;
			var icon = 'icon' + i;
			$(row).show();
			$(icon).src = "images/minus.gif";
		}
		$('hiddenLabel').style.visibility = "";
	}
	
	io.collapseAll = function(){
		var rows = document.getElementsByClassName('objectives');
		for (var i = 1;i <= rows.length; i++){
			var row = 'objective' + i;
			var icon = 'icon' + i;
			$(row).hide();
			$(icon).src = "images/plus.gif";
		}
		$('hiddenLabel').style.visibility = "hidden";
	}

	io.testOpenRows = function(){
		var rows = document.getElementsByClassName('objectives');
		hideLabels();
		for (var i = 1;i <= rows.length; i++){
			var row = 'objective' + i;
			if ($(row).style.display != "none"){
				io.showLabels();
			}else{}
		}
	}

	io.toggleRow = function(project,icon){
		Effect.toggle(project, 'appear', {duration: .4, afterFinish:
			function(){
				if ($(project).style.display != ""){
					$(icon).src = "images/plus.gif";
					io.testOpenRows();
					$('hiddenLabel').style.visibility = "hidden";
					}else{
						$(icon).src = "images/minus.gif";
						$('hiddenLabel').style.visibility = "";
					}
				}
		});
	}
	/* *************** loading on getTargets() in SDRoomMain *************** */
	io.loadDynamicFile('/styles/step3a-reviewprojects.css');
	io.loadDynamicFile('/styles/table.css');
	io.loadDynamicFile('/dwr/interface/ProjectAgent.js');

</pg:fragment>
