<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>



<table width="100%" border="0" cellspacing="0" class="tabledisc" >
	  <tr class="objectblue">
		<td><a href="#">Discussion Title</a></td>
		<td width="150" class="textcenter"><a href="#">Author</a></td>
		<td width="200"><a href="#">Last Post</a></td>
		<td width="100" class="textcenter"><a href="#">Replies</a></td>
		<td width="100" class="textcenter"><a href="#">Views</a></td>
	  </tr>

	<c:if test="${fn:length(posts) == 0}">
		<tr>
			<td colspan="5">
				<p>Currently there are no discussions for this concern theme.  If you would like to create a discussion, please click on the '<a href="javascript:new Effect.toggle('newDiscussion', 'blind', {duration: 0.5}); void(0);">new discussion</a>' above.</p><br />
			</td>
		</tr>
	</c:if>

	<c:forEach var="post" items="${posts}" varStatus="loop">
		<tr class="${((loop.index % 2) == 0) ? 'disc_row_a' : 'disc_row_b'}">
			<td><a href="sdThread.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=1">${post.title}</a><br /><span class="smalltext"  style="font-size: 80%;">${fn:substring(post.content, 0, 125)}... </span></td>
			<td width="150" class="textcenter"><a href="#">${post.owner.loginname}</a></td>
			<td width="200">
			<span class="smalltext" style="font-size: 80%;">

		    <c:choose>
		      <c:when test="${post.lastReply == null }">
		     		<a href="sdThread.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=1">${post.title}</a><br />
		     		Posted on: <fmt:formatDate value="${post.createTime}" pattern="MM/dd/yy, hh:mm aaa"/> by: ${post.owner.loginname}
		      </c:when>
		
		      <c:otherwise>
		      		<a href="sdThread.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=1#${post.lastReply.id}">${post.lastReply.title}</a><br />
		      		Posted on:  <fmt:formatDate value="${post.lastReply.createTime}" pattern="MM/dd/yy, hh:mm aaa"/> by: ${post.lastReply.owner.loginname}
		      </c:otherwise>
		    </c:choose>
				
			</span></td>
			<td width="100" class="textcenter">${post.replies}</td>	
			<td width="100" class="textcenter"><a href="sdThread.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=1">${post.views}</a></td>
			<!--<tr class="${((loop.index % 2) == 0) ? 'disc_row_a' : 'disc_row_b'}">
				<td colspan="5">
					<small>${fn:substring(post.content, 0, 250)}... </small>
					
					Quick Preview Toggle Mode: Call with: javascript:closeAllContentsExcept(${post.id}, 'quickPostContents')  -- Removed for better interaction.
					<div id="quickPostContents${post.id}" class="quickPostContents" style="display: none;">
					<p><b>Preview: </b>${fn:substring(post.content, 0, 250)} [ <a href="sdThread.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}">more</a>... ]</p>
					<ul class="tagsList">
						<logic:iterate id="tag" name="post" property="tags">
							<li class="tagsList"><small>${tag.name}</small></li>
						</logic:iterate>
						<small>- click on a tag to view concerns with the same tag.</small>
					</ul>
					<p><small><a href="sdThread.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}">${post.replies} Replies - Participate in this Discussion</a></small></p>
					</div>
					
				</td>
			</tr>-->
		</tr>		
	</c:forEach>
</table>


	<c:if test="${setting.pageSize > 1}">
		<div class="pages">
				More Pages: 
				<c:if test="${setting.page > 1}">
					<span class="pages_nextprev"><a href="sdRoom.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=${setting.page - 1}">&#171; prev page</a></span>
				</c:if>
								<ul>
									<c:forEach var="i" begin="1" end="${setting.pageSize}" step="1">
										    <c:choose>
										      <c:when test="${setting.page == i }">
										     		<li class="pages_current">${i}</li>
										      </c:when>
										      <c:otherwise>
										      		<li><a href="sdRoom.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=${i}">${i}</a></li>
										      </c:otherwise>
										    </c:choose>
									</c:forEach>
								</ul>
				
				<logic:notEqual name="setting" property="page" value="${setting.pageSize}">	
					<span class="pages_nextprev"><a href="sdRoom.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=${setting.page + 1}">next page &#187; </a></span>
				</logic:notEqual>
		</div>
	</c:if>
