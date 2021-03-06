<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>



<pg:fragment type="html">
	<!--####
		Project: Let's Improve Transportation!
		Page: SDCrit Structure Target
		Description: This is the object in the SDcriteria discussion room
		Author(s): 
		     Front End: Jordan Isip, Adam Hindman
		     Back End: John Le, Zhong Wang
	#### -->
	<!-- begin "overview and instructions" area -->
	<div id="overview" class="box2">
		<h3 class="headerColor">Overview and instructions</h3>
		<c:set var="current" value="${requestScope['org.pgist.wfengine.CURRENT']}" />
		Here we assess nine "improvement factors" that will be used in Step 3 to evaluate proposed transportation improvement projects. 
		<ul>
			<li>Review the improvement factors below and discuss with other participants their importance</li>
			<li>Cast your vote in the poll</li>
		</ul>
		<p>When you are ready, move on to <strong>Weigh improvement factors (Step 2b)</strong>.</p>
		<a href="#" onclick="Effect.toggle('hiddenRM','blind'); return false">Read more about this step</a>
		<p id="hiddenRM" style="display:none">Transportation specialists often define specific transportation improvement factors to help systematically evaluate which proposed transportation improvement projects are best suited to address our transportation needs. To assist in your review of these improvement factors, the moderator determined which concern themes are most closely related to each factor. Consider how well these improvement factors address the range of concerns expressed by participants in Step 1. Consider also which improvement factors may be more important to you in the evaluation of proposed transportation projects. In Step 2b you will weigh the relative importance of each of these improvement factors. This will help you evaluate proposed transportation improvement projects in Step 3.</p>
	</div>
	<!-- end overview -->

	<!-- Begin voting tally menu -->
	<div id="votingMenu" class="floatLeft"><div id="voting-structure${infoStructure.id}">
		<div id="votingMenuTally" class="box1">
			<span id="structure_question_status">
			<h2>${infoStructure.numAgree} of ${infoStructure.numVote}</h2>
			agree with that these improvement factors adequately address the concerns expressed by participants in Step 1.</div>
		</span>
		<p>Do these improvement factors adequately address the concerns expressed by participants in Step 1?</p>
		<span id="structure_question">
			<c:choose>
				<c:when test="${voting == null}">
					<a href="javascript:io.setVote('structure','${infoStructure.id}', 'true');"><img src="images/btn_thumbsup_large.png" alt="YES" class="floatRight" style="margin-right:5px;"><a href="javascript:io.setVote('structure', '${infoStructure.id}', 'false');"><img src="images/btn_thumbsdown_large.png" alt="NO" class="floatLeft" style="margin-left:5px;"></a></span>
				</c:when>
				<c:otherwise>
					Your vote has been recorded. Thank you for your participation.
				</c:otherwise>
			</c:choose>
		</span></div>
	</div>
		<!-- end voting tally menu -->

	<div id="criteria" class="box3 floatLeft">
	    <a href="javascript:Util.expandAll('objectives');">Expand all</a>
    	<a href="javascript:Util.collapseAll('objectives');">Collapse all</a>
		<div class="criteriaListHeader">
		  <div class="criteriaCol1 floatLeft">
		    <h4 class="headerColor">Improvement factor</h4>
		  </div>
		  <div class="criteriaCol3 floatLeft">
		    <h4 class="headerColor">Related concern theme(s)</h4>
		  </div>
		  <div class="clearBoth"></div>
		</div>
		<!-- end criteria headers -->
		<c:if test="${fn:length(infoStructure.infoObjects) == 0}">
		  <p>There are no improvement factors created for this study yet! How did you get to this page?</p>
		</c:if>
		<pg:sort name="infoObjects" items="${infoStructure.infoObjects}" key="object.criterion.name" />
		<c:forEach var="infoObj" items="${infoObjects}" varStatus="loop">
		  <div id="criteria-${infoObj.object.criterion.id}" class="criteriaListRow row ${((loop.index % 2) == 0) ? 'even' : ''}">
		    <div class="criteriaCol1 floatLeft">
				<div class="floatLeft"><a href="javascript:Util.toggleRow(${loop.index});"> <img src="/images/plus.gif" id="icon${loop.index}"></a></div>
		      <div class="floatLeft"> ${infoObj.object.criterion.name}</div>
		    </div>
		    <div class="criteriaCol3 floatLeft">
		      <!--themes-->
              <c:if test="${fn:length(infoObj.object.criterion.infoObjects) == 0}"> &nbsp; </c:if>
              <c:forEach var="themeRef" items="${infoObj.object.criterion.infoObjects}" varStatus="loop2">
                ${themeRef.object.theme.title}<br />
              </c:forEach>
		    </div>
		    <div class="clearBoth"></div>
		    <div class="objectives" id="criteriaEdit${infoObj.object.criterion.id}">
		      <!--javascript will load edit form here -->
		    </div>
		    <div class="objectives" id="row${loop.index}" style="display:none;"><br /><strong>Related impacts:</strong>
		      <ul class="smallText">
		        <c:if test="${fn:length(infoObj.object.criterion.objectives) == 0}">
		          <li>&nbsp;</li>
		        </c:if>
		        <pg:sort name="objectives" items="${infoObj.object.criterion.objectives}" key="description" />
		        <c:forEach var="objective" items="${objectives}" varStatus="loop">
		          <li>${objective.description}</li>
		        </c:forEach>
		      </ul>
		    </div>
		  </div>
		</c:forEach>
		<div id="orphanThemes">
	    <!-- loaded by js -->
		</div>
		<div class="clearBoth"></div>
	</div>
	
</pg:fragment>

<pg:fragment type="script">

	/* *************** Toggle Tree Node to view Asscociated Objectives for a Given Criterion *************** */
	io.expandList = function(objective,icon){
		Effect.toggle(objective, 'appear', {duration: .5, afterFinish:
			//window.setTimeout(toggleIcon,100);
			function(){
				if ($(objective).style.display != ""){
						$(icon).src = "/images/plus.gif";
					}else{
						$(icon).src = "/images/minus.gif";
					}
				}
		});
	};

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
		}else{
			var jsLinkElem = document.createElement('script');
			jsLinkElem.setAttribute('src', file);
			jsLinkElem.setAttribute('type', 'text/javascript');
			//headElem.appendChild(jsLinkElem);
		}
		
	}


	
	/* *************** loading on getTargets() in SDRoomMain *************** */
	io.loadDynamicFile('/styles/step2.css');
	//io.loadDynamicFile('/dwr/interface/CriteriaAgent.js');
    
    
    function getOrphanInfoObjects(){
		//alert("critSuiteId: " + io.critSuiteId + " isid: " + io.structureId); 
		CriteriaAgent.getOrphanInfoObjects({critSuiteId:io.critSuiteId,isid:io.structureId}, {
			callback:function(data){
				if (data.successful){
          var themes = [];
					data.infoObjects.each(function(infoObject){
					  themes.push("<a href='sdRoom.do?"+io.wfInfo+"&isid="+io.structureId+"&ioid="+infoObject.id+"'>"+ infoObject.object.theme.title +"</a>");
					});
					$('orphanThemes').innerHTML = "Concern themes that the moderator has determined are unrelated to any of these improvement factors include:"
					 + themes.toString();
				}else{
					alert(data.reason);
				}
			},
			errorHandler:function(errorString, exception){ 
			  alert("CriteriaAgent.getOrphanThemes( error:" + errorString + exception);
			}
		});
	}
	getOrphanInfoObjects();

</pg:fragment>