<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%>
<h1>${page.title}</h1>
<h2>${speaker.name}</h2>
<table class="onze_speaker">
  <tbody>
    <c:forEach items="${field_names}" var="field">
      <tr>
	<th class="field">${field_lookup[field]}</th>
	<td class="field">${speaker[field]}</td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<table class="onze_speaker_transcripts">
  <caption>${resources['Transcripts']}</caption>
  <thead>
    <tr>
      <th class="transcript">${resources['Transcript']}</th>
      <c:forEach items="${transcript_field_labels}" var="label"><th class="field">${label}</th></c:forEach>
      <th class="scrollbarspacer">&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <c:if test="${empty transcripts}">
      <tr>
	<td class="message" colspan="${fn:length(transcript_field_labels) + 1}">${resources['There are no transcripts to display']}</td>
      </tr>
    </c:if>
    <c:forEach items="${transcripts}" var="result">
      <tr>
	<td class="transcript"><a href="transcript?ag_id=${result.ag_id}" title="${resources['Details']}">${result.transcript_id}</a></td>
	<c:forEach items="${transcript_field_names}" var="field">
	  <td class="field">${result[field]}</td>
	</c:forEach>
      </tr>
    </c:forEach><%-- results --%>
  </tbody>
</table>

