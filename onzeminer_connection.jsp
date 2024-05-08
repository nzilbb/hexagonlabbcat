<%@ page import = "java.sql.*" 
%><%@ page import = "java.util.*" 
%><%@ page import = "nz.net.fromont.hexagon.*" 
%><%
{
   // ensure that there's a connection to the ONZE Miner database
   Page pg = (Page)request.getAttribute("page");
   Module module = pg.getModule();
   if (request.getSession().getAttribute("onzeMinerConnection") == null)
   {
      DbProperties settings = module.getProperties();
      
      // load db driver
      Class.forName (settings.getProperty("dbDriver")).newInstance();
      
      // connect
      request.getSession().setAttribute(
	 "onzeMinerConnection",
	 DriverManager.getConnection (
	    settings.getProperty("dbConnectString"), 
	    settings.getProperty("dbUser"), 
	    settings.getProperty("dbPassword")));
   }
}
%>