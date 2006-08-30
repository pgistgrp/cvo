<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>



<table width="100%" border="0" cellspacing="0">
	  <tr class="objectblue">
		<td width="40%"><a href="#">Discussion Title</a></td>
		<td width="10%" class="textcenter"><a href="#">Author</a></td>
		<td width="10%" class="textcenter"><a href="#">Last Post</a></td>
		<td width="20%" class="textcenter"><a href="#">Replies</a></td>
		<td width="15%" class="textcenter"><a href="#">Views</a></td>
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
			<td width="45%"><a href="sdThread.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=1">${post.title}</a></td>
			<td width="10%" class="textcenter">${post.replies}</td>
			<td width="10%" class="textcenter">${post.views}</td>	
			<td width="20%" class="textcenter"><a href="#">${post.owner.loginname}</a></td>
			<td width="15%">
			<span class="smallText">

		    <c:choose>
		      <c:when test="${post.lastReply == null }">
		     		<fmt:formatDate value="${post.createTime}" pattern="MM/dd/yy, hh:mm aaa"/> by: ${post.owner.loginname}
		      </c:when>
		
		      <c:otherwise>
		      		<fmt:formatDate value="${post.lastReply.createTime}" pattern="MM/dd/yy, hh:mm aaa"/> by: ${post.lastReply.owner.loginname}
		      </c:otherwise>
		    </c:choose>
				
			</span></td>
			<tr class="${((loop.index % 2) == 0) ? 'disc_row_a' : 'disc_row_b'}">
				<td colspan="5">
					<small>${fn:substring(post.content, 0, 250)}... </small>
					<!--
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
					-->
				</td>
			</tr>
		</tr>		
	</c:forEach>
</table>


	<c:if test="${setting.pageSize > 1}">
	More Pages: 
					<ul>
						<c:forEach var="i" begin="1" end="${setting.pageSize}" step="1">
							    <c:choose>
							      <c:when test="${setting.page == i }">
							     		<li class="activePage">${i}</li>
							      </c:when>
							      <c:otherwise>
							      		<li><a href="sdRoom.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=${i}">${i}</a></li>
							      </c:otherwise>
							    </c:choose>
						</c:forEach>
					</ul>
	
	<c:if test="${setting.page > 1}">
		<a href="sdRoom.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=${setting.page - 1}">&#171; prev page</a>
	</c:if>
	
	<logic:notEqual name="setting" property="page" value="${setting.pageSize}">	
		<a href="sdRoom.do?isid=${structure.id}&pid=${post.id}&ioid=${object.id}&page=${setting.page + 1}">next page &#187; </a>
	</logic:notEqual>
	</c:if>