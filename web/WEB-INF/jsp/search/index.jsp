<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html:html>
<head>
<title>PGIST Search</title>
</head>
<body bgcolor="white">

<html:form action="/search.do" method="post">

<table width="100%">
  <tr>
    <td><html:text property="queryStr" name="searchForm" maxlength="50" size="50"/><input type="submit" value="Search"></td>
  </tr>
</table>

</html:form>

</body>
</html:html>

