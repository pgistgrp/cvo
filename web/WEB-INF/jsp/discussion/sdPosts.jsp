<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>



<c:choose>
	<c:when test="${fn:length(posts) <= 0}">
		<div class="box2 padding5 centerAlign"><h3 class="headerColor">There aren't any topics yet!</h3><p>Why not <a href="javascript:Effect.toggle('newDiscussion','blind',{duration: 0.2});">start the first discussion</a>?</div>
	</c:when>
	<c:otherwise>
		
		
		<c:forEach var="post" items="${posts}" varStatus="loop">
		
			<div id="discussion${post.id}" class="discussionRow">
				<div class="discussion-left floatLeft">
						<c:choose>
								<c:when test="${baseuser.id == post.owner.id}">
									<div class="discussionRowHeader box6">			
								</c:when>
								<c:otherwise>
									<div class="discussionRowHeader box1">
								</c:otherwise>
						</c:choose>
						<div id="voting-post${post.id}" class="discussionVoting">
							${post.numAgree} of ${post.numVote} participants agree with this post
							<c:choose>
								<c:when test="${post.object == null}">
									<a href="javascript:infoObject.setVote('post',${post.id}, 'false');"><img src="/images/btn_thumbsdown.png" alt="I disagree!" border="0"/></a> 
									<a href="javascript:infoObject.setVote('post',${post.id}, 'true');"><img src="/images/btn_thumbsup.png" alt="I agree!" border="0"/></a>
								</c:when>
								<c:otherwise>
									<img src="images/btn_thumbsdown_off.png" alt="Disabled Button"/> <img src="images/btn_thumbsup_off.png" alt="Disabled Button"/>
								</c:otherwise>
							</c:choose>
						</div>
						<span class="discussionTitle">
							${post.title}
					</div>
					
						<c:choose>
								<c:when test="${baseuser.id == post.owner.id}">
									<div class="discussionBody box7">		
								</c:when>
								<c:otherwise>
									<div class="discussionBody">
								</c:otherwise>
						</c:choose>
						<div class="discussionText">
							<pg:show roles="moderator"><p align="right">Moderator Options: <input type="button" onClick="io.deletePost(${post.id});"  value="Delete"  /></p></pg:show>
							<p>${post.content}</p>
							<h3>- ${post.owner.loginname}</h3>
						</div>
						<div class="discussionComments">
							 <c:choose>
				  <c:when test="${fmtToday == fmtLastPostDate || fmtToday == fmtLastReplyDate }">
					<img src="/images/balloonactive2.gif" alt="Replies within the last 24 hours" /></c:when>
				  <c:otherwise>
					<img src="/images/ballooninactive2.gif" alt="No replies within the last 24 hours" /></c:otherwise>
				  </c:choose>&nbsp;
							<a href="sdThread.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}"><h3 style="display:inline;">${post.replies} Replies</h3></a> (${post.views} views)
						</div>
						<c:if test="${fn:length(post.tags) > 0}">
							<ul class="tagsInline">
								<li class="tagsInline"><strong>Tags:</strong> </li>
								<c:forEach var="tag" items="${post.tags}">
									<c:choose>
										<c:when test="${baseuser.id == post.owner.id}">
											<li class="box6 tagsInline">		
										</c:when>
										<c:otherwise>
											<li class="box8 tagsInline">
										</c:otherwise>
									</c:choose>
									<a href="javascript:io.getPosts(${tag.id},0,true);">${tag.name}</a></li>
								</c:forEach>
							</ul>
							<div style="clear: left;"></div>
						</c:if>
					</div>
				</div>
				<div class="discussion-right">
					<img src="images/icon_people_1.gif">
				</div>
			</div>
		
		
		<!-- End New Style -->
		</c:forEach>
		
				  <div class="pagination discussion-left">
				  		You are currently viewing page: ${setting.page} of ${setting.pageSize} &nbsp;
						<logic:equal name="setting" property="page" value="1">
							<img src="images/btn_prev_fade.gif" alt="No Previous Pages" />
						</logic:equal>
						<logic:notEqual name="setting" property="page" value="1">	
							<a href="javascript:io.goToPage(${setting.page}-1);"><img src="images/btn_prev_a.gif" alt="Prev" name="prev" class="button" id="prev" onMouseOver="MM_swapImage('prev','','images/btn_prev_b.gif',1)" onMouseOut="MM_swapImgRestore()"></a>
						</logic:notEqual>
						
						
						<logic:equal name="setting" property="page" value="${setting.pageSize}">
							<img src="images/btn_next_fade.gif" alt="No Additional Pages" />
						</logic:equal>
						<logic:notEqual name="setting" property="page" value="${setting.pageSize}">	
							<a href="javascript:io.goToPage(${setting.page}+1)"><img src="images/btn_next_a.gif" alt="Next" name="next" class="button" id="next" onMouseOver="MM_swapImage('next','','images/btn_next_b.gif',1)" onMouseOut="MM_swapImgRestore()"></a>
						</logic:notEqual>
		  			</div>


	</c:otherwise>

		
</c:choose>