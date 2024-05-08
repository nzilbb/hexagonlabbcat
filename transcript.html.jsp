<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" 
%><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" 
%>
<h1>${page.title}</h1>
<h2>${transcript_id}</h2>
<table class="onze_transcript">
  <tbody>
    <c:forEach items="${field_names}" var="field">
      <tr>
	<th class="field">${field_lookup[field]}</th>
	<td class="field">${transcript[field]}</td>
      </tr>
    </c:forEach>
    </tbody>
</table>

<table class="onze_transcript_speakers">
  <caption>${resources['Speakers']}</caption>
  <thead>
    <tr>
      <th class="transcript">${resources['Speaker']}</th>
      <c:forEach items="${speaker_field_labels}" var="label"><th class="field">${label}</th></c:forEach>
      <th class="scrollbarspacer">&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <c:if test="${empty speakers}">
      <tr>
	<td class="message" colspan="${fn:length(speaker_field_labels) + 1}">${resources['There are no speakers to display']}</td>
      </tr>
    </c:if>
    <c:forEach items="${speakers}" var="result">
      <tr>
	<td class="transcript"><a href="speaker?speaker_number=${result.speaker_number}" title="${resources['Details']}">${result.name}</a></td>
	<c:forEach items="${speaker_field_names}" var="field">
	  <td class="field">${result[field]}</td>
	</c:forEach>
      </tr>
    </c:forEach><%-- results --%>
  </tbody>
</table>
