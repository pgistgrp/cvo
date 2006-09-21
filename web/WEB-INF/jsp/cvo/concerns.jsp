<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<logic:equal name="showTitle" value="true">
	<span class="closeBox">[ <a href="javascript:goPage(${setting.page});">Clear Filter</a> ]</span>
	<br><span class="title_section">Concerns tagged with: </span>
		<span class="tagSize${tagRef.fontSize}"><a href="javascript:getConcernsByTag(${tagRef.id});">${tagRef.tag.name}</a></span>&nbsp;
	<p></p>
</logic:equal>

	<c:forEach var="concern" items="${concerns}" varStatus="loop">
			<div id="concernId${concern.id}" class="theConcern"><!--${((loop.index % 2) == 0) ? 'disc_row_a' : 'disc_row_a'}-->
						<logic:notEqual name="type" value="0">
							<span class="participantName"><a href="userProfile${concern.id}.jsp"><bean:write name="concern" property="author.loginname" /></a></span>&nbsp;said:
							<br>
						</logic:notEqual>
						<logic:equal name="type" value="0">
								<span class="concerns">
						</logic:equal>
						<logic:notEqual name="type" value="0">
							<span class="concerns">
						</logic:notEqual>
						"<bean:write name="concern" property="content" />"</span><br>
						
						<logic:iterate id="tagref" property="tags" name="concern">
							<span class="tags">
							<a href="javascript:getConcernsByTag(${tagref.id});">${tagref.tag.name}</a>
							</span>
						</logic:iterate>
						<logic:equal name="type" value="0">
						<div id=actionMenu class="actionMenu"><strong>Actions:</strong> <a href="javascript:editConcernPopup(${concern.id});">edit concern</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:editTagsPopup('${concern.id}');">edit tags</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:delConcern(${concern.id});">delete entire concern</a></div>
						<br>
						</logic:equal>
			</div>
	<p></p>
</c:forEach>



<logic:notEqual name="showTitle" value="true">
		<logic:notEqual name="showIcon" value="true">
			<p>
		  <div id="prevNext_container">
					
					<div id="previous"><span class="prevNext">
						<logic:equal name="setting" property="page" value="1">
							<a href="javascript:goPage(${setting.pageSize});">
						</logic:equal>
						
						<logic:notEqual name="setting" property="page" value="1">	
							<a href="javascript:goPage(${setting.page}-1);">
						</logic:notEqual>
						&#171; prev page</a></span>
					</div>

					<div id="next"><span class="prevNext">
						<logic:equal name="setting" property="page" value="${setting.pageSize}">
							<a href="javascript:goPage(1);">
						</logic:equal>
						
						<logic:notEqual name="setting" property="page" value="${setting.pageSize}">	
							<a href="javascript:goPage(${setting.page}+1);">
						</logic:notEqual>
						next page &#187; </a></span>
					</div>
		  </div>
			</p>
		</logic:notEqual>
</logic:notEqual>