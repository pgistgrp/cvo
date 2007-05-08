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
		     Front End: Jordan Isip, Adam Hindman, Issac Yang
		     Back End: Zhong Wang, John Le
		Todo Items:
			[x] Initial Skeleton Code (Jordan)
			[ ] Add JavaScript to get criteria (Jordan)
			[ ] Integrate Layout (Adam)
	#### -->
	<!-- begin "overview and instructions" area -->
	<div id="overview" class="box2">
		<h3 class="headerColor">Instructions</h3>
		<p>
			"Planning factors" are common used to help evaluate which proposed transportation improvement projects are best 
			suited to address problems with our transportation system.  Here we review and discuss nine planning factors. 
			In step 3 you will review proposed transportation projects which are evaluated based on the nine factors.
		</p>
		<p>
			To assist in your review of these factors, the moderator determined which concern themes are most closely related 
			to each factor.  Consider how well these factors address the range of concerns expressed by participants in Step 1.
			Consider also which factors may be more important to you in the evaluation of proposed transportation projects.
		</p>
			
		
	</div>
	<!-- end overview -->

	<h3 class="headerColor clearBoth">All planning factors and related concern themes</h3>

			<!-- Begin voting tally menu -->
	<div id="votingMenu" class="floatLeft"><div id="voting-structure${infoStructure.id}">
		<div id="votingMenuTally" class="box1">
			<span id="structure_question_status">
				<h2>${infoStructure.numAgree} of ${infoStructure.numVote}</h2>
			agree with that these planning factors adequately address the concerns expressed by participants in Step 1.</div>
		</span>
		<p>Do these planning factors adequately address the concerns expressed by participants in step 1?</p>
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
		<div class="criteriaListHeader">
		  <div class="criteriaCol1 floatLeft">
		    <h4 class="headerColor">Planning factor</h4>
		  </div>
		  <div class="criteriaCol2 floatLeft">
		    <h4 class="headerColor">Description</h4>
		  </div>
		  <div class="criteriaCol3 floatLeft">
		    <h4 class="headerColor">Related concern theme</h4>
		  </div>
		  <div class="clearBoth"></div>
		</div>
		<!-- end criteria headers -->
		<c:if test="${fn:length(infoStructure.infoObjects) == 0}">
		  <p>There are no planning factors created yet! How did you get to this page?</p>
		</c:if>
		<c:forEach var="criterion" items="${infoStructure.infoObjects}" varStatus="loop">
		  <div id="criteria-${criterion.id}" class="criteriaListRow row ${((loop.index % 2) == 0) ? 'even' : ''}">
		    <div class="criteriaCol1 floatLeft"><a href="#">
		      <div class="floatLeft"><a href="javascript:io.expandList('objectives${criterion.id}','icon${criterion.id}');"> <img src="/images/plus.gif" id="icon${criterion.id}"></a></div>
		      <div class="floatLeft"> ${criterion.name}

		          <!-- needs another variable to differentiate -->
		            <!-- show editing only to moderator -->
		            <small><br />[ <a href="javascript:editCriterionPopup(${criterion.id});">edit</a> ]
		            [ <a href="javascript:deleteCriterion(${criterion.id});">delete</a> ]</small>

		      </div>
		    </div>
		    <div class="criteriaCol2 floatLeft">${criterion.na}</div>
		    <div class="criteriaCol3 floatLeft">
		      <!--themes-->
		      <c:if test="${fn:length(criterion.themes) == 0}"> None
		        Selected </c:if>
		      <c:forEach var="theme" items="${criterion.themes}" varStatus="loop">
		        ${theme.title}<br />
		      </c:forEach>
		    </div>
		    <div class="clearBoth"></div>
		    <div class="objectives" id="criteriaEdit${criterion.id}">
		      <!--javascript will load edit form here -->
		    </div>
		    <div class="objectives" id="objectives${criterion.id}" style="display:none;"><br /><strong>Objectives:</strong>
		      <ul class="smallText">
		        <c:if test="${fn:length(criterion.objectives) == 0}">
		          <li>None Selected</li>
		        </c:if>
		        <c:forEach var="objective" items="${criterion.objectives}" varStatus="loop">
		          <li>${objective.description}</li>
		        </c:forEach>
		      </ul>
		    </div>
		  </div>
		</c:forEach>
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
		}else{ //javascript
			var jsLinkElem = document.createElement('script');
			jsLinkElem.setAttribute('src', file);
			jsLinkElem.setAttribute('type', 'text/javascript');
			headElem.appendChild(jsLinkElem);
		}
		
	}
	
	/* *************** loading on getTargets() in SDRoomMain *************** */
	io.loadDynamicFile('styles/step2.css');
	io.loadDynamicFile('/dwr/interface/CriteriaAgent.js');
	

</pg:fragment>