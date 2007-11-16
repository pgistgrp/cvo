<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<c:choose>	
	<c:when test="${fn:length(announcements) == 0}">
		<p>No Announcements at this time.</p>
	</c:when>
	<c:otherwise>
		<c:forEach var="announcement" items="${announcements}" varStatus="loop">
			<p>
			<strong>${announcement.date}</strong> 
			&nbsp;${announcement.message}
			</p>
		</c:forEach>
	</c:otherwise>
</c:choose>

