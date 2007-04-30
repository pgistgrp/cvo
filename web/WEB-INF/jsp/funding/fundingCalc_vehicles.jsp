<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.pgist.org/pgtaglib" prefix="pg" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:forEach var="vehicle" items="${vehicles}" varStatus="loop">
	<div id="vehicle${vehicle.id}" class="myVehiclesRow"> 
		<strong>Vehicle ${loop.index + 1}: </strong> Miles per
		gallon
		${vehicle.milesPerGallon}
		Approximate value
		${vehicle.approxValue}

		Miles driven per year
		${vehicle.milesPerYear}
		<small><a href="javascript:toggleEditField('vehicle',${vehicle.id});">Edit</a> | <a href="javascript:deleteVehicle(${vehicle.id})">Remove</a></small> 
	</div>
	<div id="vehicleEdit${vehicle.id}" class="myVehiclesRow" style="display: none;"> 
		<form id="editVehicle" action="javascript:editVehicle(${vehicle.id});">
		<strong>Vehicle ${loop.index + 1}: </strong> 
		Miles per gallon <input name="mpg" id="vehicleMpg${vehicle.id}" type="text" value="${vehicle.milesPerGallon}" />
		Approximate value <input name="value" id="vehicleValue${vehicle.id}" type="text" value="${vehicle.approxValue}" />
		Miles driven per year <input name="mpy" id="vehicleMpy${vehicle.id}" type="text" value="${vehicle.milesPerYear}" />

		<input type="submit" value="Update" /><small><a href="javascript:toggleEditField('vehicle',${vehicle.id});">Cancel</a></small>
		</form>
	</div>
</c:forEach>

<p><a href="javascript:Element.toggle('newVehicle');void(0);">Add vehicle</a> 
	<div id="newVehicle" class="myVehiclesRow" style="display:none;"> 
		<form id="addVehicle" action="javascript:addVehicle();">
		<strong>New Vehicle: </strong> Miles per gallon
		<input name="mpg" id="vehicleMpg" type="text" />
		Approximate value
		<input name="value" id="vehicleValue" type="text" />
		Miles driven per year
		<input name="mpy" id="vehicleMpy" type="text" />

		<input type="submit" value="Add" /><small><a href="javascript:Element.toggle('newVehicle');">Cancel</a></small>
		</form>
	</div>		
</p>