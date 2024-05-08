<%@ page import = "java.sql.*" 
%><%@ page import = "java.util.*" 
%><%@ page import = "nz.net.fromont.hexagon.*" 
%><%
{
   Page pg = (Page)request.getAttribute("page");
   nz.net.fromont.hexagon.Module module = pg.getModule();
   if (request.getAttribute("search_module") != null)
   {
      return;
      //module = (Module) request.getAttribute("search_module");
   }
   pg.setTitle("Search");
   String sSearch = request.getParameter("search");
   pg.set("search", sSearch);
   boolean bMainSpeakersOnly = "1".equals(
      module.getProperties().getProperty("mainSpeakerOnly"));

   // connect
   DbProperties settings = module.getProperties();
   Class.forName (settings.getProperty("dbDriver")).newInstance();
   Connection miner = DriverManager.getConnection (
      settings.getProperty("dbConnectString"), 
      settings.getProperty("dbUser"), 
      settings.getProperty("dbPassword"));
   try
   {      
      if (sSearch != null && sSearch.length() > 0)
      {
	 
	 /// Transcripts
	 
	 // which fields do we need to include in the results
	 PreparedStatement sql = pg.prepareStatement(
	    "SELECT attribute, label "
	    +" FROM "+module+"_transcript_field"
	    +" WHERE search_results = 1"
	    +" ORDER BY display_order");
	 ResultSet rs = sql.executeQuery();
	 Vector vLabels = new Vector();
	 pg.set("transcript_field_labels", vLabels);
	 Vector vFields = new Vector();
	 pg.set("transcript_field_names", vFields);
	 String sFieldList = "";
	 String sJoin = "";
	 while (rs.next())
	 {
	    String sAttribute = rs.getString("attribute");
	    vFields.addElement(sAttribute);
	    vLabels.addElement(rs.getString("label"));
	    sFieldList += ", " + "a_" + sAttribute + ".value AS " + sAttribute;
	    sJoin += " LEFT OUTER JOIN transcript_attribute a_" + sAttribute 
	       + " ON a_" + sAttribute + ".ag_id = ta.ag_id"
	       + " AND a_" + sAttribute + ".name = '" + sAttribute + "'";
	 } // next dislay field
	 
	 rs.close();
	 sql.close();
	 
	 sql = miner.prepareStatement(
	    "SELECT DISTINCT ta.ag_id, t.transcript_id "
	    + sFieldList
	    +" FROM annotation_transcript ta"
	    +" INNER JOIN transcript t ON ta.ag_id = t.ag_id"
	    + sJoin
	    +" WHERE REPLACE(ta.label, '\\'', '') REGEXP REPLACE(?, '\\'', '')"
	    +" ORDER BY t.transcript_id");
	 String sPattern = sSearch; // TODO convert spaces to \s
	 sql.setString(1, sPattern);
	 rs = sql.executeQuery();
	 Vector vResults = Page.HashtableCollectionFromResultSet(rs);
	 pg.set("transcript_results", vResults);
	 rs.close();
	 sql.close();
	 
	 /// Speakers
	 
	 // which fields do we need to include in the results
	 sql = pg.prepareStatement(
	    "SELECT attribute, label "
	    +" FROM "+module+"_speaker_field"
	    +" WHERE search_results = 1"
	    +" ORDER BY display_order");
	 rs = sql.executeQuery();
	 vLabels = new Vector();
	 pg.set("speaker_field_labels", vLabels);
	 vFields = new Vector();
	 pg.set("speaker_field_names", vFields);
	 sFieldList = "";
	 sJoin = "";
	 while (rs.next())
	 {
	    String sAttribute = rs.getString("attribute");
	    vFields.addElement(sAttribute);
	    vLabels.addElement(rs.getString("label"));
	    sFieldList += ", " + "a_" + sAttribute + ".label AS " + sAttribute;
	    sJoin += " LEFT OUTER JOIN annotation_participant a_" + sAttribute 
	       + " ON a_" + sAttribute + ".speaker_number = sa.speaker_number"
	       + " AND a_" + sAttribute + ".layer = '" + sAttribute + "'";
	 } // next dislay field
	 
	 rs.close();
	 sql.close();
	 
	 sql = miner.prepareStatement(
	    "SELECT DISTINCT sa.speaker_number, s.name"
	    + sFieldList
	    +" FROM annotation_participant sa"
	    +" INNER JOIN speaker s ON sa.speaker_number = s.speaker_number"
	    +(bMainSpeakersOnly?
	    " INNER JOIN transcript_speaker ts"
	    +" ON s.speaker_number = ts.speaker_number"
	    +" AND ts.main_speaker = 1"
	    :"")
	    + sJoin
	    +" WHERE REPLACE(sa.label, '\\'', '') REGEXP REPLACE(?, '\\'', '')"
	    +" OR REPLACE(s.name, '\\'', '') REGEXP REPLACE(?, '\\'', '')"
	    +" ORDER BY s.name");
	 sPattern = sSearch; // TODO convert spaces to \s
	 sql.setString(1, sPattern);
	 sql.setString(2, sPattern);
	 rs = sql.executeQuery();
	 vResults = Page.HashtableCollectionFromResultSet(rs);
	 pg.set("speaker_results", vResults);
	 rs.close();
	 sql.close();
      }     
   }
   finally
   {
      miner.close();
   }
}
%>
