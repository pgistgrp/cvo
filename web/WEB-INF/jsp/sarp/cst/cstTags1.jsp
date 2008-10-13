<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>

<h4>Unrelated Keywords/phrases</h4>
<ul>
	<logic:iterate id="tag" name="tags">
    <pg:show condition="${(user.id==baseuser.id && !cst.closed) || modtool}">
		<li id="tag${tag.id}" style="list-style: none;">[<a href="javascript:relateTag(${tag.id});"><strong>&larr;</strong></a>]&nbsp;<a href="javascript:getConcerns(${tag.id});">${pg:purify(tag.tag.name)}</a></li>
    </pg:show>
    <pg:hide condition="${(user.id==baseuser.id && !cst.closed) || modtool}">
		<li id="tag${tag.id}" style="list-style: none;"><a href="javascript:getConcerns(${tag.id});">${pg:purify(tag.tag.name)}</a></li>
    </pg:hide>
	</logic:iterate>
</ul>
<h4>Orphan Keywords</h4>
<ul>
	<logic:iterate id="tag" name="orphanTags">
    <pg:show condition="${(user.id==baseuser.id && !cst.closed) || modtool}">
		<li id="tag${tag.id}" style="list-style: none;">[<a href="javascript:relateTag(${tag.id});"><strong>&larr;</strong></a>]&nbsp;[ ? ]&nbsp;<a href="javascript:getConcerns(${tag.id});">${pg:purify(tag.tag.name)}</a></li>
    </pg:show>
    <pg:hide condition="${(user.id==baseuser.id && !cst.closed) || modtool}">
		<li id="tag${tag.id}" style="list-style: none;">[ ? ]&nbsp;<a href="javascript:getConcerns(${tag.id});">${pg:purify(tag.tag.name)}</a></li>
    </pg:hide>
	</logic:iterate>
</ul>