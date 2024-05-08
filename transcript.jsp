<%@ page import = "java.sql.*" 
%><%@ page import = "java.util.*" 
%><%@ page import = "nz.net.fromont.hexagon.*" 
%><%
{
   Page pg = (Page)request.getAttribute("page");
   nz.net.fromont.hexagon.Module module = pg.getModule();
   pg.setTitle("Transcript");
   int iAgId = Integer.parseInt(request.getParameter("ag_id"));
   String sTranscriptId = request.getParameter("transcript_id");
   pg.set("transcript_id", sTranscriptId);
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
      // which fields do we need to include in the page
      PreparedStatement sql = pg.prepareStatement(
	 "SELECT attribute, label "
	 +" FROM "+module+"_transcript_field"
	 +" WHERE display = 1"
	 +" ORDER BY display_order");
      ResultSet rs = sql.executeQuery();
      Vector vLabels = new Vector();
      pg.set("field_labels", vLabels);
      Vector vFields = new Vector();
      pg.set("field_names", vFields);
      Hashtable htFieldLookup = new Hashtable();
      pg.set("field_lookup", htFieldLookup);
      String sFieldList = "";
      String sJoin = "";
      while (rs.next())
      {
	 String sAttribute = rs.getString("attribute");
	 vFields.addElement(sAttribute);
	 String sLabel = rs.getString("label");
	 vLabels.addElement(sLabel);
	 htFieldLookup.put(sAttribute, sLabel);
	 sFieldList += ", " + "a_" + sAttribute + ".label AS " + sAttribute;
	 sJoin += " LEFT OUTER JOIN annotation_transcript a_" + sAttribute 
	    + " ON a_" + sAttribute + ".ag_id = t.ag_id"
	    + " AND a_" + sAttribute + ".layer = '" + sAttribute + "'";
      } // next dislay field
      rs.close();
      sql.close();
      
      sql = miner.prepareStatement(
	 "SELECT t.transcript_id "
	 + sFieldList
	 +" FROM transcript t"
	 + sJoin
	 +" WHERE t.ag_id = ?");
      sql.setInt(1, iAgId);
      rs = sql.executeQuery();
      if (rs.next()) pg.set("transcript", Page.HashtableFromResultSet(rs));
      rs.close();
      sql.close();
      
      // list of speakers
      
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
	    + " ON a_" + sAttribute + ".speaker_number = s.speaker_number"
	    + " AND a_" + sAttribute + ".layer = '" + sAttribute + "'";
      } // next dislay field
      
      rs.close();
      sql.close();
      
      sql = miner.prepareStatement(
	 "SELECT DISTINCT s.speaker_number, s.name"
	 + sFieldList
	 +" FROM speaker s"
	 +" INNER JOIN transcript_speaker ts"
	 +" ON s.speaker_number = ts.speaker_number"
	 +(bMainSpeakersOnly?
	 " AND ts.main_speaker = 1"
	 :"")
	 + sJoin
	 +" WHERE ts.ag_id = ?"
	 +" ORDER BY s.name");
      sql.setInt(1, iAgId);
      rs = sql.executeQuery();
      Vector vResults = Page.HashtableCollectionFromResultSet(rs);
      pg.set("speakers", vResults);
      rs.close();
      sql.close();
   }
   finally
   {
      miner.close();
   }

}
%>
