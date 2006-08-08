<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>

<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>

<logic:iterate id="post" name="posts">
	<div class="disc_row_a">
		<div class="sidepadding">
		<div class="header_cat_title" ><a href="javascript:getPost(${post.id});">${post.title}</a></div><div class="header_cat_replies">5</div><div class="header_cat_author"><a href="#">${post.owner.loginname}</a></div><div class="header_cat_lastpost"><small>${post.createTime} by: ${post.owner.loginname}</small></div><div class="clear"></div>
	</div>
</logic:iterate>

<fmt:formatDate value="expression" pattern="expression" var="name" scope="scope"/>