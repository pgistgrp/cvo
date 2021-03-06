<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="javascript" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!--####
	Project: Let's Improve Transportation!
	Page: Project Alternative Description
	Description: This page serves as an information page for a given project alternative. 
	Author: Jordan Isip, Adam Hindman
	Todo Items:
		[x] Initial Skeleton Code (Jordan)
		[ ] Get criteria average grades (Jordan and Matt)
		[ ] Get objective human readable grades (Jordan and Matt)
		[ ] Get total averages (Jordan and Matt)
		[ ] Integrate map or photo (Guirong)
		[ ] Rework tree menu (Adam or Jordan)
#### -->

<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html xmlns:v="urn:schemas-microsoft-com:vml">
	<head>
	<title>Let's Improve Transportation: ${reference.alternative.project.name} - ${reference.alternative.name}</title>
	<!-- Site Wide CSS -->
<style type="text/css" media="screen">
@import "styles/lit.css";
@import "styles/table.css";
@import "styles/step3a-singleproject.css";
@import "styles/table-grades.css";
</style>
<style type="text/css">
    v\:* {
      behavior:url(#default#VML);
    }
</style>
	<!-- Site Wide JS -->
	<script src="scripts/prototype.js" type="text/javascript"></script>
	<script src="scripts/scriptaculous.js?load=effects,dragdrop" type="text/javascript"></script>
	<script src="scripts/search.js" type="text/javascript"></script>
	<script src="scripts/qTip.js" type="text/javascript"></script>
	<script type='text/javascript' src='/dwr/engine.js'></script>
	<script type='text/javascript' src='/dwr/util.js'></script>
	<script type='text/javascript' src='/dwr/interface/PESAgent.js'></script>

<!-- data accessing js -->
<javascript:gmapjs />
<script type='text/javascript' src='/dwr/interface/ProjectAgent.js'></script>
<script src="scripts/pgistmap2.js"></script>
<script type="text/javascript" charset="utf-8">
    
// Loop through the 'objectives' divs, show them, and change the icon.
			function expandAll(){
				var rows = document.getElementsByClassName('objectives');
				var icons = document.getElementsByClassName('icon');
				for (var i = 0;i <= rows.length; i++){
					var row = 'objective' + i;
					var icon = 'icon' + i;
					$(row).show();
					$(icon).src = "/images/minus.gif";
				}
				showLabels();
			}

// Loop through all the 'objectives' divs, hide them, and change the icon.
			function collapseAll(){
				var rows = document.getElementsByClassName('objectives');
				for (var i = 0;i <= rows.length; i++){
					var row = 'objective' + i;
					var icon = 'icon' + i;
					$(row).hide();
					$(icon).src = "/images/plus.gif";
				}
				hideLabels();
			}

// Loop through all the column labels and make then visible.
			function showLabels(){
				var labels = document.getElementsByClassName('hiddenLabel')
				for (var i = 0;i < labels.length;i++){
					labels[i].style.visibility = "";
				}
			}

// Loop through all the column labels and set them invisible.
			function hideLabels(){
				var labels = document.getElementsByClassName('hiddenLabel')
				for (var i = 0;i < labels.length;i++){
					labels[i].style.visibility = "hidden";
				}
			}

// First, hide the labels. Then, for every objective that is open, show the labels.
			function testOpenRows(){
				hideLabels();
				var rows = document.getElementsByClassName('objectives');
				for (var i = 0;i <= rows.length; i++){
					var row = 'objective' + i;
					if ($(row).style.display != "none"){
						showLabels();
					}else{}
				}
			}
	
/* First, use Scriptaculous to toggle the objectives div.
Then, decide whether to show the plus or minus icon based on whether 
the div is displayed or not.  If the div is displayed, reveal
the column labels. */

			function toggleRow(project,icon){
				Effect.toggle(project, 'appear', {duration:.2, afterFinish:
					function(){
						if ($(project).style.display != ""){
							$(icon).src = "/images/plus.gif";
							testOpenRows();
							}else{
								$(icon).src = "/images/minus.gif";
								showLabels();
							}
						}
				});
			}
			
			function load(){
				pgistmap = new PGISTMapEditor('obj-right', 435, 485, false);
				getFootprintsByAltId(${reference.alternative.id});
			}
			var pgistmap = null;
			
	/* *************** Get footprints for a given project alternative id *************** */
	var transmode = "${reference.alternative.project.transMode}";
	var transcolor = (transmode==2)?"#00FF00":"#FF0000";
	function getFootprintsByAltId(id){
		ProjectAgent.getFootprintsByAltId({altid:id}, {
			callback:function(data){
				if (data.successful){
					for(fpid in data.footprints){
						if(data.footprints[fpid].geotype==0 ||
							data.footprints[fpid].geotype==2 || 
							data.footprints[fpid].geotype==5){ // line
							var points = pgistmap.makeGPoints(data.footprints[fpid].coords);
							for(var j=0; j<points.length; j++){
								pgistmap.map.addOverlay(
									new GPolyline(points[j], "#FFFFFF", 8, 0.6) );
								pgistmap.map.addOverlay(
									new GPolyline(points[j], transcolor, 4, 0.9) );
							}
							pgistmap.scaleToCoords(points);
							
							//pgistmap.recoverCoords(data.footprints[fpid].coords);
							//pgistmap.scaleToCoords();
							//pgistmap.drawLines();
						}else if(data.footprints[fpid].geotype==1 || 
							data.footprints[fpid].geotype==4){ // point
							pgistmap.recoverCoords(data.footprints[fpid].coords);
							pgistmap.scaleToCoords();
							pgistmap.drawPoints();	
						}else{ //polygon
							pgistmap.recoverCoords(data.footprints[fpid].coords);
							pgistmap.scaleToCoords();
							pgistmap.drawPolygons();	
							
						}
					}
				}else{
					alert("Something wrong happened, reason: " + data.reason);
				}
			},
			errorHandler:function(errorString, exception){ 
			alert("ProjectAgent.getFootprint( error:" + errorString + exception);
			}
		});
	}
	
	</script>
	<event:pageunload />
	</head>
	<body onLoad="load()" onUnload="pgistmap=null;GUnload();">
	<!-- #container is the container that wraps around all the main page content -->
	<div id="container">
	<!-- begin Object -->
	<div id="object">
		<h3  style="text-transform:none" id="project-title">${reference.alternative.project.name} - ${reference.alternative.name}</h3>
		<!-- begin cell containing Google Map object -->
		
	
		<!--GOOGLE MAPS GO HERE GMAN! -->
		<div id="obj-right" class="floatRight"> 
			<!--img src="/images/gmaps.gif"--> 
		</div>
		<!-- end GMAN -->
		
		
		<!-- end cell containing Google Map object -->
		
	
		<!--begin project description -->
		<p>
		<h4>Short description</h4>
		<span id="project-shortDescription">${reference.alternative.shortDesc}</span>
		</p>
		<p>
		<h4 style="display:inline">Money needed to complete this project</h4>
		<span id="project-moneyNeeded">$<fmt:formatNumber maxFractionDigits="0" value="${reference.alternative.cost/1000000}" />  million</span>
		</p>
		<p>
		<h4 style="display:inline">Sponsoring agency: </h4>
		<span id="project-sponsoringAgency">${reference.alternative.sponsor}</span>
		</p>
		<h4 style="display:inline">County: </h4>
		<span id="project-county">${reference.alternative.county}</span>
		</p>
		
		<p>
		<h4>Detailed description</h4>
		<span id="project-detailedDescription">
			<pg:termHighlight styleClass="glossHighlight" url="glossaryView.do?id=">
				${reference.alternative.detailedDesc}
			</pg:termHighlight>
		</span>
		<p>
		<h4>Links to additional information about this project</h4>
		<span id="project-links">
			${reference.alternative.links}
		</span>
		</p>
		<p>
		<h4>Statement for</h4>
		<span id="project-statementFor">${reference.alternative.statementFor}</span>
		</p>
		<p>
		<h4>Statement against</h4>
		<span id="project-statementAgainst">${reference.alternative.statementAgainst}</span>
		</p>
		<!-- end project description -->
		<div class="clearBoth"></div>
	</div>
	<!-- end obj-left -->
	<!-- begin firefox height hack -->
	<div class="clearBoth"></div>
	<!-- end firefox height hack -->
	<!-- Load separate file content starting here -->
	<!-- begin criteria  -->
	<c:choose>
		<c:when test="${fn:length(reference.gradedCriteria) == 0}">
			No planning factors have been associated yet!
		</c:when>
		<c:otherwise>
			<a href="javascript:expandAll();">Expand all</a>
			<a href="javascript:collapseAll();">Collapse all</a>

			<div id="newtable">
				<table border="0" cellpadding="0" cellspacing="0">
					<tr class="tableHeading">
						<th class="first">Improvement factor</th>
						<th><span class="hiddenLabel" style="visibility:hidden;">Specialist Panel Assessment</span></th>
						<th>Overall grade</th>
					</tr>
					<!--======================-->
					<c:forEach var="critGrade" items="${reference.gradedCriteria}" varStatus="loop">
						<!-- begin PROJECT -->
						<tr class="fundingType">
							<td class="fundingSourceItem">
									<a href="javascript:toggleRow('objective${loop.index}','icon${loop.index}');">
									<img src="/images/plus.gif" id="icon${loop.index}" class="icon"></a>
									<a href="javascript:toggleRow('objective${loop.index}','icon${loop.index}');" title="${critGrade.criteria.na}">${critGrade.criteria.name}</a></td>
							<td>&nbsp;</td>
							<td class="grade${pg:gradeSwitch(critGrade.grade)}">${critGrade.grade}</td>
						</tr>
						<!-- end PROJECT -->
					
						<!-- begin HIDDEN ROW of OPTIONS -->
						<tr style="display:none;" class="objectives" id="objective${loop.index}">
							<td colspan="3">
								<ul>
									<p><b>Objectives:</b></p>	
									<c:forEach var="gradeObj" items="${critGrade.objectives}" varStatus="loop">
								        <li>
								        									    <div class="rating"><c:choose>
									        <c:when test="${gradeObj.grade != null}">                                                    
    									        <c:out value="${pg:verboseGradeSwitch(gradeObj.grade)}"/>
    									    </c:when>
    									    <c:otherwise>
    									        No grade available.
									        </c:otherwise>
								        </c:choose></div>
								        ${gradeObj.objective.description}
								        </li>
									</c:forEach>
								</ul>
							</td>
						</tr>
						<!-- end HIDDEN ROW -->
					</c:forEach>
					<!--======================-->
					<!-- begin AVERAGES -->
					<tr class="headingColor">
						<td class="fundingSourceItem">
								Average</td>
						<td>&nbsp;</td>
						<td class="grade${pg:gradeSwitch(average)}">${average}</td>
					</tr>

					<tr class="headingColor">
						<td class="fundingSourceItem">
								Average weighted grade (based on your preferred factor weights)</td>
						<td>&nbsp;</td>
						<td class="grade${pg:gradeSwitch(personalAverage)}">${personalAverage}</td>
					</tr>

					<tr class="headingColor">
						<td class="fundingSourceItem">
								Average weighted grade (based on average of all participants' planning factor weights)</td>
						<td>&nbsp;</td>
						<td class="grade${pg:gradeSwitch(everyoneAverage)}">${everyoneAverage}</td>
					</tr>
					<!-- end AVERAGES -->


				</table>
			</div>
		</c:otherwise>
	</c:choose>
	</div>
	<!-- end container -->
	<!-- start feedback form -->
	<pg:feedback id="feedbackDiv" action="cctView.do"/>
	<!-- end feedback form -->
	</body>
</html>
