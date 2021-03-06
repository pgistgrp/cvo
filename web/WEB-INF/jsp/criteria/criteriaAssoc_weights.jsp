<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<p class="floatRight" id="remainingWeightP2"> <SMALL>Weight remaining: </SMALL><b id="remainingWeight2">
<!--load remaining weight here -->
</b></p><br class="clearBoth" />
<div id="critRowWrapper">
    <a href="javascript:Util.expandAll('objectives');">Expand all</a>
	<a href="javascript:Util.collapseAll('objectives');">Collapse all</a>
<div class="criteriaListHeader">
	<div class="weighCriteriaCol1 floatLeft">
		<h4>Improvement factor</h4>
	</div>
	<!--<div class="weighCriteriaCol2 floatLeft">
		<h4>Description</h4>
	</div>-->
	<div class="weighCriteriaCol3 floatLeft">
		<h4>Your weight</h4>
	</div>
	<div class="clearBoth"></div>
</div>
<!-- end criteria headers -->
	<c:forEach var="ref" items="${critSuite.references}" varStatus="loop">
		<c:if test="${ref.criterion.deleted == false}">
			<div id="criteria-${ref.criterion.id}" class="criteriaListRow row ${((loop.index % 2) == 0) ? 'even' : ''}">
				<div class="weighCriteriaCol1 floatLeft"><a href="#">
					<div class="floatLeft iconImg"> 
						<a href="javascript:Util.toggleRow(${loop.index});"> <img src="/images/plus.gif" id="icon${loop.index}"></a> 
					</div>
					<div class="floatLeft pfValue"><label for="icon${loop.index}" onclick="Util.toggleRow(${loop.index});">${ref.criterion.name}</label></div>
				</div>
				<!--<div class="weighCriteriaCol2 floatLeft">${ref.criterion.na}</div>-->
	
				<div class="weighCriteriaCol3 floatLeft">
					<!-- start slider bar -->
					<div id="track${ref.criterion.id}" class="track floatLeft" style="width:550px;height:9px;">
						<div id="track${ref.criterion.id}-left" class="track-left"></div>
						<div id="handle${ref.criterion.id}" style="cursor: col-resize; width:19px; height:20px;"> 
						<img src="images/slider-handle.png" alt="" style="float: left;"/> </div>
					</div>
					<div id="inputField" class="floatRight">
						<input type="text" tabIndex="${loop.index + 1}" size="3" 
						maxlength="3" id="input${ref.criterion.id}" 
						onchange="manualSliderChange(${ref.criterion.id}, this.value)" value = "0" />
					</div>
					<!-- end input -->
					<!-- end slider bar -->
					<!--weights-->
					<!-- end weights -->
					<div class="clearBoth"></div>
				</div>
				<div class="clearBoth"></div>
				<div class="objectives" id="row${loop.index}" style="display:none;">
					<p>To get a good grade in <strong>${ref.criterion.name}</strong>, a transportation project exhibit significant positive impacts in the following areas:</p>
					<ul><c:if test="${fn:length(ref.criterion.objectives) == 0}">
							<li>None Selected</li>
						</c:if>
						<c:forEach var="objective" items="${ref.criterion.objectives}" varStatus="loop">
							<li>${objective.description}</li>
						</c:forEach>
					</ul>
				</div>
				<div class="clearBoth"></div>
			</div>
		</c:if>
	</c:forEach>
</div>
</div>
</div>
<p id="remainingWeightP"><SMALL>Weight remaining: </SMALL><b id="remainingWeight">
<!--load remaining weight here -->
</b></p><br class="clearBoth" />