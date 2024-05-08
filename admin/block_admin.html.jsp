<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%><%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%>
<hex:blockmenu>
  <hex:blockmenuitem 
     urlModule="${block.module.moduleRoot}" 
     urlPath="admin/fields_speaker"
     title="${resources['Set which ONZE Miner meta-data fields appear where']}"
     text="${resources['Speaker meta-data']}" />
  <hex:blockmenuitem 
     urlModule="${block.module.moduleRoot}" 
     urlPath="admin/fields_transcript"
     title="${resources['Set which ONZE Miner meta-data fields appear where']}"
     text="${resources['Transcript meta-data']}" />
</hex:blockmenu>
