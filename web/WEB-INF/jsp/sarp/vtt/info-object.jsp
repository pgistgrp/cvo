<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<style>
  .catSelected {
    background-color:#D6E7EF;
    cursor:pointer;
    font-weight:bold;
  }
  .catUnSelected {
    background-color:white;
    cursor:pointer;
    font-weight:normal;
  }
</style>
<div id="col-left" style="float:left;width:35%;overflow:auto;height:350px;border-right:1px solid #B4D579;">
  <c:set var="vtt" scope="request" value="${infoObject.target}"/>
  <jsp:include page="vttCatsTable.jsp" />
</div>

<div id="col-right" style="overflow:auto;height:350px;text-align:center;">
  <b>Units of Measurement Specialist Analysis and Selection:</b>
</div>

<div id="col-right2" style="overflow:hidden;clear:both;height:20px;border-top:1px solid #B4D579;">
  <div style="float:left;overflow:hidden;">
    Moderator Announcements: &nbsp;&nbsp;&nbsp;&nbsp;
    <span style="cursor:pointer;color:blue;text-decoration:underline;" onclick="infoObject.getAnnouncements();">Refresh</span>
  </div>
	<pg:show roles="moderator">
    <div style="float:right;clear:right;">
      <span style="cursor:pointer;color:blue;text-decoration:underline;" onclick="$('announceEditor').style.display = 'block';">Create Announcements</span>
    </div>
	</pg:show>
</div>
<div id="col-right3" style="overflow:auto;clear:both;height:270px;border-top:1px solid #B4D579;">
	<pg:show roles="moderator">
    <div id="announceEditor" style="display:none;position:relative;clear:both;width:98%;height:80%;">
    Title: <br><input id="announceEditor_title" type="text" size="32"><br>
    Description: <br><textarea id="announceEditor_description" rows="5" style="width:600px;"></textarea><br>
    <input type="button" value="Submit" onclick="infoObject.createAnnouncement();">
    <input type="button" value="Cancel" onclick="$('announceEditor').style.display = 'none';">
    </div>
	</pg:show>
  <center>
    <div id="announcements" style="clear:both;padding:2px;overflow:auto;width:98%;height:80%;">
      <jsp:include page="../drt/drtAnnouncements.jsp" />
    </div>
  </center>
</div>
