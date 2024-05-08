<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%>
<h1>${page.title}</h1>
<form name="frmOnzeSearch" method="post">
  <div id="onze_search">${resources['Search:']}</div>
  <div id="onze_search_form"
       ><input type="text" 
	       name="search" 
	       value="${search}"
	       title="${resources['Enter the text you would like to search for here']}"></div>
  <div id="onze_search_button"><hex:linkbutton 
	   icon="${template_path}/icon/system-search.png"
	   title="${resources['Search']}"
	   text="${resources['Search']}"
	   url="javascript:document.frmOnzeSearch.submit();" /></div>
</form>

<c:if test="${!empty param['search']}">
  <table class="onze_search_results">
    <caption>${resources['Transcripts']}</caption>
    <thead>
      <tr>
	<th class="transcript">${resources['Transcript']}</th>
	<c:forEach items="${transcript_field_labels}" var="label"><th class="field">${label}</th></c:forEach>
	<th class="scrollbarspacer">&nbsp;</th>
      </tr>
    </thead>
    <tbody>
      <c:if test="${empty transcript_results}">
	<tr>
	  <td class="message" colspan="${fn:length(transcript_field_labels) + 1}">${resources['There are no results to display']}</td>
	</tr>
      </c:if>
      <c:forEach items="${transcript_results}" var="result">
	<tr>
	  <td class="transcript"><a href="transcript?ag_id=${result.ag_id}" title="${resources['Details']}">${result.transcript_id}</a></td>
	  <c:forEach items="${transcript_field_names}" var="field">
	    <td class="field">${result[field]}</td>
	  </c:forEach>
	</tr>
      </c:forEach><%-- results --%>
    </tbody>
  </table>

  <table class="onze_search_results">
    <caption>${resources['Speakers']}</caption>
    <thead>
      <tr>
	<th class="transcript">${resources['Speaker']}</th>
	<c:forEach items="${speaker_field_labels}" var="label"><th class="field">${label}</th></c:forEach>
	<th class="scrollbarspacer">&nbsp;</th>
      </tr>
    </thead>
    <tbody>
      <c:if test="${empty speaker_results}">
	<tr>
	  <td class="message" colspan="${fn:length(speaker_field_labels) + 1}">${resources['There are no results to display']}</td>
	</tr>
      </c:if>
      <c:forEach items="${speaker_results}" var="result">
	<tr>
	  <td class="transcript"><a href="speaker?speaker_number=${result.speaker_number}" title="${resources['Details']}">${result.name}</a></td>
	  <c:forEach items="${speaker_field_names}" var="field">
	    <td class="field">${result[field]}</td>
	  </c:forEach>
	</tr>
      </c:forEach><%-- results --%>
    </tbody>
  </table>
</c:if>
