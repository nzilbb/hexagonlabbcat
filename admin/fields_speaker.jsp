<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib prefix="db" uri="/WEB-INF/dbtags.tld" 
%><%@ page import = "java.sql.*" 
%><%@ page import = "java.util.*" 
%><%@ page import = "nz.net.fromont.hexagon.*" 
%><%
{
   Page pg = (Page)request.getAttribute("page");
   nz.net.fromont.hexagon.Module module = pg.getModule();
   pg.setTitle("Speaker Meta-data");
   String sSearch = request.getParameter("search");
   pg.set("search", sSearch);

   // connect
   DbProperties settings = module.getProperties();
   Class.forName (settings.getProperty("dbDriver")).newInstance();
   Connection miner = DriverManager.getConnection (
      settings.getProperty("dbConnectString"), 
      settings.getProperty("dbUser"), 
      settings.getProperty("dbPassword"));
   try
   {
      // first, ensure that all fields in ONZE Miner are in the local database
      PreparedStatement sqlDetectField = pg.prepareStatement(
	 "SELECT attribute"
	 +" FROM "+module+"_speaker_field"
	 +" WHERE attribute = ?");
      PreparedStatement sqlInsertField = pg.prepareStatement(
	 "INSERT INTO "+module+"_speaker_field"
	 +" (attribute, data_type, label, description, display_order,"
	 +" searchable, search_results, display)"
	 +" VALUES (?, ?, ?, ?, ?,?,?,?)");
      PreparedStatement sqlOnzeMiner = miner.prepareStatement(
	 "SELECT *"
	 +" FROM attribute_definition"
	 +" WHERE class_id = 'speaker'"
	 +" ORDER BY `display_order`");
      ResultSet rsOnzeMiner = sqlOnzeMiner.executeQuery();
      String sAttributesList = "";
      while (rsOnzeMiner.next())
      {
	 sqlDetectField.setString(1, rsOnzeMiner.getString("attribute"));
	 if (sAttributesList.length() > 0) sAttributesList += ",";
	 sAttributesList += "'" 
	    + rsOnzeMiner.getString("attribute").replaceAll("'", "''") + "'";
	 ResultSet rsDetectField = sqlDetectField.executeQuery();
	 if (!rsDetectField.next())
	 {
	    // it's not in our setting table, so add it
	    sqlInsertField.setString(1, rsOnzeMiner.getString("attribute"));
	    sqlInsertField.setString(2, rsOnzeMiner.getString("type"));
	    sqlInsertField.setString(3, rsOnzeMiner.getString("label"));
	    sqlInsertField.setString(4, rsOnzeMiner.getString("description"));
	    sqlInsertField.setInt(5, rsOnzeMiner.getInt("display_order"));
	    sqlInsertField.setInt(6, rsOnzeMiner.getInt("searchable"));
	    sqlInsertField.setInt(7, rsOnzeMiner.getInt("searchable"));
	    sqlInsertField.setInt(8, rsOnzeMiner.getInt("access"));
	    sqlInsertField.executeUpdate();
	 }
	 rsDetectField.close();
      } // next ONZE Miner field
      // delete those that have been deleted in ONZE Miner
      PreparedStatement sqlDeleteFields = pg.prepareStatement(
	 "DELETE FROM "+module+"_speaker_field"
	 +" WHERE attribute NOT IN (" + sAttributesList + ")");
      sqlDeleteFields.executeUpdate();
      sqlDeleteFields.close();
      rsOnzeMiner.close();
      sqlOnzeMiner.close();
      sqlDetectField.close();
      sqlInsertField.close();
   }
   finally
   {
      miner.close();
   }
}
%><c:set var="db_table" scope="request"
	 ><db:table 
	     type="editdelete" insert="false" view="list"
	     tableName="${module}_speaker_field" 
	     title="${page.title}"
	     connection="${page.connection}"
	     htmlTableProperties="border=0 cellpadding=0 cellspacing=5 width=300"
	     deleteButton="${template_path}icon/user-trash.png"
	     insertButton="${template_path}icon/document-new.png"
	     saveButton="${template_path}icon/document-save.png"
	     >
    <db:field
       name="attribute"
       type="string" access="read" isId="true" required="true"
       linkAs="attribute"
       />
    <db:field
       name="label"
       type="string" access="readwrite" required="true"
       />
    <db:field
       name="description"
       type="string" access="readwrite" required="false"
       />
    <db:field
       name="display_order" label="Display Order"
       type="integer" access="readwrite" required="true"
       size="2"
       order="0"
       />
    <db:field
       name="searchable" label="${resources['Search']}"
       description="${resources['Is this field searchable?']}"
       type="integer" access="readwrite" required="true"
       optionValues="${resources['0:No|1:Yes']}"
       />
    <db:field
       name="search_results" label="${resources['Listing']}"
       description="${resources['Does this field appear in the search results table?']}"
       type="integer" access="readwrite" required="true"
       optionValues="${resources['0:No|1:Yes']}"
       />
    <db:field
       name="display" label="${resources['Details']}"
       description="${resources['Does this field appear in the details page?']}"
       type="integer" access="readwrite" required="true"
       optionValues="${resources['0:No|1:Yes']}"
       />
  </db:table></c:set>
