<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<pg:fragment type="html">
		<!-- Begin Breadcrumbs -->
		<div id="breadCrumbs" class="floatLeft"> <a href="sd.do?isid=${infoStructure.id}">
		    <pg:url page="/sd.do" params="isid=${infoStructure.id}">Select a theme</pg:url> &rarr; 
		    <c:choose>
		      <c:when test="${infoObject != null}">
		          <pg:url page="/sdRoom.do" params="isid=${infoStructure.id}&ioid=${infoObject.id}">${infoObject.object}</pg:url>
		      </c:when>
		      <c:otherwise>
		          <pg:url page="/sdRoom.do" params="isid=${infoStructure.id}">All concern themes</pg:url>
		      </c:otherwise>
		    </c:choose>
		</div>
		<!-- End Breadcrumbs -->
		<!-- jump to other room selection menu -->
		<div class="floatRight"> Jump to:
			<select name="selecttheme" id="selecttheme" 
			onChange="javascript: location.href='sdRoom.do?isid=${infoStructure.id}&ioid=' + this.value;">
				<option value = "${object.id}">Select a theme</option>
				<option value = "">Discussion of all themes</option>
				<c:forEach var="infoObject" items="${infoStructure.infoObjects}">
					<option value="${infoObject.id}">${infoObject.object}</option>
				</c:forEach>
			</select>
		</div>
		<!-- end jump to other room selection menu -->
		

		<h3 class="headerColor clearBoth">Summarization of participant concerns about "${infoObject.object}"</h3>

			<!-- Begin voting tally menu -->
	<div id="votingMenu" class="floatLeft"><div id="voting-object${infoObject.id}">
		<div id="votingMenuTally" class="box1">
			<span id="structure_question_status">
				<h2>${infoObject.numAgree} of ${infoObject.numVote}</h2>
			agree with summary</div>
		</span>
		<p>Does this summary reflect the group's concerns?</p>
		<span id="structure_question">
			<c:choose>
				<c:when test="${voting == null}">
					<a href="javascript:io.setVote('object',${infoObject.id}, 'true');"><img src="images/btn_thumbsup_large.png" alt="YES" class="floatRight" style="margin-right:5px;"><a href="javascript:io.setVote('object', ${infoObject.id}, 'false');"><img src="images/btn_thumbsdown_large.png" alt="NO" class="floatLeft" style="margin-left:5px;"></a></span>
				</c:when>
				<c:otherwise>
					<div class="box3" style="text-align:left;padding:2px;">Your vote has been recorded. Thank you for your participation.</div>
				</c:otherwise>
			</c:choose>
		</span></div>
	</div>
		<!-- end voting tally menu -->



		<!-- begin summary -->
			<div id="summary" class="box3 floatLeft">
				<!--load summary here from javascript -->
			</div>
	  <!-- end summary -->
</pg:fragment>

<pg:fragment type="script">
	SDAgent.getSummary({isid: io.structureId, ioid: io.objectId},<pg:wfinfo/>, {  // change to getTarget()
		callback:function(data){
			if (data.successful){
				$('summary').innerHTML = data.source.html;
				displayIndicator(false);
				}else{
					alert(data.reason);
					displayIndicator(false);
				}
			},
			errorHandler:function(errorString, exception){
				alert("get targets error:" + errorString + exception);
			}
		});
</pg:fragment>