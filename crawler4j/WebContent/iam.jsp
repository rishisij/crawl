<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" %>
<%@ page import="java.sql.PreparedStatement"  %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Pagination of JSP page</title>
<script type="text/javascript" src="/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript">
function functionsql()
{   
	var xmlhttp;
	if(document.getElementById("edit").checked) 
	{
		alert("You Really want to edit Its may be Hoax!! Check Once!")
			if(window.XMLHttpRequest)
				{
				xmlhttp= new XMLHttpRequest();
				}
			else
				{
				xmlhttp=new ActiceXObject("Microsoft.XMLHTTP");
				}
			xmlhttp.onreadystatechange=function()
			{
				if(xmlhttp.readystate==4&&xmlhttp.status==200)
					{
					document.getElementById("edit").innerHTML=xmlhttp.responseText;
					}
			}
			
			
			
			edit=document.getElementById("edit").value;
			url=document.getElementById("url").value;
			word=document.getElementById("word").value;
		}
	else if(document.getElementById("delete").checked) 
	{
		alert("You Really want to Delete Its all depend on you May be you Out of your mind :)!")
		if(window.XMLHttpRequest)
			{
			xmlhttp= new XMLHttpRequest();
			}
		else
			{
			xmlhttp=new ActiceXObject("Microsoft.XMLHTTP");
			}
		xmlhttp.onreadystatechange=function()
		{
			if(xmlhttp.readystate==4&&xmlhttp.status==200)
				{
				document.getElementById("delete").innerHTML=xmlhttp.responseText;
				}
		}
		
		
		edit=document.getElementById("delete").value;
		url=document.getElementById("url").value;
		word=document.getElementById("word").value;
	}
	xmlhttp.open("post","ajaxsql.jsp?sql="+edit+" "+url+" "+word,true);
	xmlhttp.send();
	alert("Completed");
	document.getElementById("delete").target="_blank";
	document.getElementById("edit").innerHTML = ""; 
}
</script>


<%!
public int nullIntconv(String str)
{   
    int conv=0;
    if(str==null)
    {
        str="0";
    }
    else if((str.trim()).equals("null"))
    {
        str="0";
    }
    else if(str.equals(""))
    {
        str="0";
    }
    try{
        conv=Integer.parseInt(str);
    }
    catch(Exception e)
    {
    }
    return conv;
}
%>
<%

    Connection conn = null;
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    conn = DriverManager.getConnection("jdbc:mysql://10.0.1.92:3306/words","root", "root");

    ResultSet rsPagination = null;
    ResultSet rsRowCnt = null;
    
    PreparedStatement psPagination=null;
    PreparedStatement psRowCnt=null;
    
    int iShowRows=50;  // Number of records show on per page
    int iTotalSearchRecords=10;  // Number of pages index shown
    
    int iTotalRows=nullIntconv(request.getParameter("iTotalRows"));
    int iTotalPages=nullIntconv(request.getParameter("iTotalPages"));
    int iPageNo=nullIntconv(request.getParameter("iPageNo"));
    int cPageNo=nullIntconv(request.getParameter("cPageNo"));
    
    int iStartResultNo=0;
    int iEndResultNo=0;
    
    if(iPageNo==0)
    {
        iPageNo=0;
    }
    else{
        iPageNo=Math.abs((iPageNo-1)*iShowRows);
    }
    

    
    String sqlPagination="SELECT SQL_CALC_FOUND_ROWS * FROM taxo limit "+iPageNo+","+iShowRows+"";

    psPagination=conn.prepareStatement(sqlPagination);
    rsPagination=psPagination.executeQuery();
    
    //// this will count total number of rows
     String sqlRowCnt="SELECT FOUND_ROWS() as cnt";
     psRowCnt=conn.prepareStatement(sqlRowCnt);
     rsRowCnt=psRowCnt.executeQuery();
     
     if(rsRowCnt.next())
      {
         iTotalRows=rsRowCnt.getInt("cnt");
      }
%>

</head>
<body>

<form name="frm">
<input type="hidden" name="iPageNo" value="<%=iPageNo%>">
<input type="hidden" name="cPageNo" value="<%=cPageNo%>">
<input type="hidden" name="iShowRows" value="<%=iShowRows%>">
<table width="100%" cellpadding="2" cellspacing="2" border="2" >
<tr>
<td>Name</td>
<td>Batch</td>
<td>Address</td>
</tr>
<%
  while(rsPagination.next())
  {
  %>
  
    <tr id="<%=rsPagination.getString("id")%>">
    
      <td><input type="hidden" id="id" value="<%=rsPagination.getString("id")%>"><%=rsPagination.getString("id")%></td>
      <td><input type="text" name="url" id="url" size="100%" value="<%=rsPagination.getString("url")%>"></td>
      <td><input type="text" name="word" id="word" size="100%" value="<%=rsPagination.getString("word")%>"></td>
      <td><input type="radio" name="edit<%=rsPagination.getString("id")%>" id="edit" Value="Edit@<%=rsPagination.getString("id")%>" onclick="functionsql()">Edit</td>
      <td><input type="radio" name="edit<%=rsPagination.getString("id")%>" id="delete" Value="Delete@<%=rsPagination.getString("id")%>" onclick="functionsql()">Delete</td>
    </tr>
  
    <% 
 }
 %>
 
<%
  //// calculate next record start record  and end record 
        try{
            if(iTotalRows<(iPageNo+iShowRows))
            {
                iEndResultNo=iTotalRows;
            }
            else
            {
                iEndResultNo=(iPageNo+iShowRows);
            }
           
            iStartResultNo=(iPageNo+1);
            iTotalPages=((int)(Math.ceil((double)iTotalRows/iShowRows)));
        
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }

%>
<tr>
<td colspan="3">
<div>
<%
        //// index of pages 
        
        int i=0;
        int cPage=0;
        if(iTotalRows!=0)
        {
        cPage=((int)(Math.ceil((double)iEndResultNo/(iTotalSearchRecords*iShowRows))));
        
        int prePageNo=(cPage*iTotalSearchRecords)-((iTotalSearchRecords-1)+iTotalSearchRecords);
        if((cPage*iTotalSearchRecords)-(iTotalSearchRecords)>0)
        {
         %>
          <a href="iam.jsp?iPageNo=<%=prePageNo%>&cPageNo=<%=prePageNo%>">s Previous</a>
         <%
        }
        
        for(i=((cPage*iTotalSearchRecords)-(iTotalSearchRecords-1));i<=(cPage*iTotalSearchRecords);i++)
        {
          if(i==((iPageNo/iShowRows)+1))
          {
          %>
           <a href="iam.jsp?iPageNo=<%=i%>" style="cursor:pointer;color: red"><b><%=i%></b></a>
          <%
          }
          else if(i<=iTotalPages)
          {
          %>
           <a href="iam.jsp?iPageNo=<%=i%>"><%=i%></a>
          <% 
          }
        }
        if(iTotalPages>iTotalSearchRecords && i<iTotalPages)
        {
         %>
         <a href="iam.jsp?iPageNo=<%=i%>&cPageNo=<%=i%>">  Next</a> 
         <%
        }
        }
      %>
<b>Rows <%=iStartResultNo%> - <%=iEndResultNo%>   Total Result  <%=iTotalRows%> </b>
</div>
</td>
</tr>
</table>
</form>
</body>

</html>
<%
    try{
         if(psPagination!=null){
             psPagination.close();
         }
         if(rsPagination!=null){
             rsPagination.close();
         }
         
         if(psRowCnt!=null){
             psRowCnt.close();
         }
         if(rsRowCnt!=null){
             rsRowCnt.close();
         }
         
         if(conn!=null){
          conn.close();
         }
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
%>