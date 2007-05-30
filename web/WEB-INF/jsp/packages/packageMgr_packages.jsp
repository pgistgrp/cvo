<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<table border="0" cellspacing="0" width="100%" class="box12">
	<tr>
		<th>Package</th>
		<th>Total</th>
		<th>Total Cost to Average Resident</th>
	</tr>
	<c:forEach var="package" items="${packages}" varStatus="loop">
		<tr>
			<td class="col1"><a target="_blank" href="package.do?pkgId=${package.id}&fundSuiteId=${fundSuiteId}&projSuiteId=${projSuiteId}&critSuiteId=${critSuiteId}&pkgSuiteId=${pkgSuiteId}">Package ${package.id} ** ${(package.id == usersClusteredPkgId) ? "YES": "NO"}</a></td>
			<td>$${package.totalCost} Million</td>
			<td>$${package.avgResidentCost}/year</td>
		</tr>
	</c:forEach>
</table>