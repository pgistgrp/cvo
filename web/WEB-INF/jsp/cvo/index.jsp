<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html:html>
<head>
<title>CVO List</title>
<link rel="stylesheet" type="text/css" href="/styles/default.css'/>">
<script type='text/javascript' src='/scripts/base.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type='text/javascript' src='/dwr/interface/CVOAgent.js'></script>
<script>
  function openCreateCVO() {
    $('createCVODialog_name').value = '';
    $('createCVODialog_question').value = '';
    createCVODialog.popup();
    return false;
  }
  function createCVO() {
    CVOAgent.createCVO($('createCVODialog_name').value, $('createCVODialog_question').value, createCVO_callback);
  }
  function createCVO_callback(data) {
    if (data['result']=='true') {
      createCVODialog.close();
      var table = $('cvoListTable');
      n = table.rows.length;
      for (var i=0; i<n; i++) table.deleteRow(0);
      var row = table.insertRow(table.rows.length);
      var column = row.insertCell(0);
      column.innerHTML = '<span style="color:red;">Loading......</span>';
      CVOAgent.getCVOList(getCVOList_callback);
    } else {
      alert(data['alert']);
    }
  }
  function getCVOList_callback(data) {
    var table = $('cvoListTable');
    table.deleteRow(0);
    var list = data['cvoList'];
    for (var i=0; i<list.length; i++) {
      var cvo = list[i];
      var row = table.insertRow(table.rows.length);
      var column = row.insertCell(0);
      column.innerHTML = '<a href="<html:rewrite page="/cvoview.do"/>?id='+cvo['id']+'">'+cvo['name']+'</a>';
    }
  }
</script>
<event:pageunload />
</head>

<body>

<pg:dialog id="createCVODialog" width="300" height="200">
  <table width="100%" height="100%" cellpadding="0" cellspacing="0">
    <tr>
      <td>Please input the display name of this CVO:</td>
    </tr>
    <tr>
      <td><input type="text" id="createCVODialog_name" value="" class="inputbox" style="width:100%;"/></td>
    </tr>
    <tr>
      <td>Please input the QUESTION:</td>
    </tr>
    <tr>
      <td><textarea id="createCVODialog_question" style="width:100%;height:99%;" class="inputbox" value=""></textarea></td>
    </tr>
    <tr>
      <td align="center"><input type="button" value="Submit" onClick="createCVO();"/></td>
    </tr>
  </table>
</pg:dialog>

<html:form action="/cvolist.do" method="POST">
  <h2>CVO List</h2>
  <pg:show roles="moderator">
    <pg:hide roles="admin">
    <p><a href="#" onClick="openCreateCVO();">Create CVO</a>
    </pg:hide>
  </pg:show>
  <table id="cvoListTable" class="listtable" cellspacing="1" frame="box" rules="all" width="100%">
    <logic:iterate id="cvo" property="cvoList" name="cvoForm">
    <tr>
      <td><html:link action="/cvoview.do" paramId="id" paramName="cvo" paramProperty="id"><bean:write name="cvo" property="name"/></html:link></td>
    </tr>
    </logic:iterate>
  </table>
</html:form>

</body>
</html:html>

