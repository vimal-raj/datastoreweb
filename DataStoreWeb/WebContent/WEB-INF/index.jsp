<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.time.Instant" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.TimeZone" %>        
<%@ page import="xyz.navira.fworks.DataStore" %>
<%@ page import="xyz.navira.fworks.DataFile" %> 

<%

DataStore dS = (DataStore) request.getAttribute("datastore");
%>

<%!

public String getDateTimeFromTimestamp(long timestamp) {
    if (timestamp == 0)
      return null;
    LocalDateTime dT = LocalDateTime.ofInstant(Instant.ofEpochSecond(timestamp), TimeZone
        .getDefault().toZoneId());
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    return dT.format(formatter);
  }

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>DataStore</title>
</head>
<body style="background-color: #eaeaea;">

<h2>DataSource | <%= dS.getPath() %> | <%= (float) dS.sizeOnDisk() / 1000 %>KB</h2>

<% if(request.getAttribute("error") != null && !("".equals(request.getAttribute("error")))){
	
%>
<div style="color: red; padding: 10px;">

<%= request.getAttribute("error") %>

</div>
<% } %>
<table border=1 style=" border-collapse: collapse; padding: 4px;">
<thead>
<tr>
<td>S.No</td>
<td>Key</td>
<td>Value</td>
<td>Expires</td>
<td>Size</td>
</tr>
</thead>
<%

int i = 1;
for(DataFile dF :  dS.getFiles()){
	out.print("<tr>");
	out.print("<td>" + i++ + "</td>");
	out.print("<td>" + dF.getName() + "</td>");
	out.print("<td>" + dF.getContentAsString() + "</td>");
	out.print("<td>" + ((dF.getTtl() == -1) ? "Never" : getDateTimeFromTimestamp(dF.getTtl())) + "</td>");
	out.print("<td>" + (float) dF.getContentAsString().getBytes().length/1000 + "KB </td>");
	out.print("<td><a href='?delete=true&key="+dF.getName()+"'> Delete </a></td>");
	out.print("</tr>");	
}

%>
</tbody>
</table>

<br/>
<div>

<form action="" method="post">
	<input type="hidden" name="add" value="true">
	<input type="text" name="key" placeholder="Key" required="required" max-len="36"><br/>
	<input type="number" name="ttl" placeholder="Expires in (seconds)"><br/>
	<textarea name="value" placeholder="JSON String" required></textarea><br/>
	<input type="submit" value="Add">
</form>

</div>

</body>
</html>