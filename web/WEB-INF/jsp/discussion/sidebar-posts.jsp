<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<pg:fragment type="html">
	<c:choose>
		<c:when test="${fn:length(posts) == 0}">
				<p>No posts with your current filters could be found.  Try removing one of your filters.</p>
		</c:when>
		<c:otherwise>
			<c:forEach var="post" items="${posts}" varStatus="loop">
				<div id="contextpost${post.id}" class="replies">
						 <div id="replies_title" class="bluetitle-side">
						 	<span class="padding-sides"><strong><a href="/sdThread.do?isid=${structure.id}&ioid=${post.value.id}&pid=${post.id}">${post.title}</a></strong> - 
						 	<small><fmt:formatDate value="${post.createTime}" pattern="MM/dd/yy, hh:mm aaa"/>
						 	<strong>${post.owner.loginname}</strong>
						 	<c:if test="${post.value != null}"> 
						 		in discussion room <strong><a href="/sdRoom.do?isid=${structure.id}&ioid=${post.value.id}">${post.value.object.category.name}</a></strong>
						 	</c:if>
						 
						 	</small>
						 	</span>
						 </div>
						<div class="padding bluebody-side">
						<small>
						"${fn:substring(post.content, 0, 100)}"
								<c:if test="${fn:length(post.content) > 100}">
									 [...] 
						</c:if>
						</small>
						<br />
							<c:if test="${fn:length(post.tags) != 0}">
							<p>
							<ul class="tagsList smalltext"><strong>Tags: </strong>
								<c:forEach items="${post.tags}" var="tag">
										<li class="tagsList"><a href="javascript: sideBar.changeCurrentFilter(${tag.id});">${tag.name}</a></li>
								</c:forEach>
							</ul>
							</p>
							</c:if>
						</div>
				</div>
				<p></p>
		</c:forEach>

		  <div id="prevNext_container">
					
					<div id="next"><span class="textright">
						<logic:equal name="setting" property="page" value="${setting.pageSize}">
							<img src="images/btn_next_fade.gif" alt="No Additional Pages" />
						</logic:equal>
						
						<logic:notEqual name="setting" property="page" value="${setting.pageSize}">	
							<a href="javascript:sideBar.getContextPosts(${setting.page}+1);"><img src="images/btn_next_a.gif" alt="Next" name="next" class="button" id="next" onMouseOver="MM_swapImage('next','','images/btn_next_b.gif',1)" onMouseOut="MM_swapImgRestore()"></a>
						</logic:notEqual>
						</span>
					</div>
					
					
					<div id="previous">
						<logic:equal name="setting" property="page" value="1">
							<img src="images/btn_prev_fade.gif" alt="No Previous Pages" />
						</logic:equal>
						
						<logic:notEqual name="setting" property="page" value="1">	
							<a href="javascript:sideBar.getContextPosts(${setting.page}-1);"><img src="images/btn_prev_a.gif" alt="Prev" name="prev" class="button" id="prev" onMouseOver="MM_swapImage('prev','','images/btn_prev_b.gif',1)" onMouseOut="MM_swapImgRestore()"></a>
						</logic:notEqual>
						
					</div>

		  </div>
		</c:otherwise>
	</c:choose>

</pg:fragment>
