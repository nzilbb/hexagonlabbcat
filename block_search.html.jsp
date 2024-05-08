<%@ taglib prefix="hex" tagdir="/WEB-INF/tags" 
%><form action="${site.root}/${block.module}/search" name="frmOnzeSearchBlock" method="post">
  <div id="onze_search">${resources['Search:']}</div>
  <div id="onze_search_form"><input type="text" name="search" title="${resources['Enter the text you would like to search for here']}"></div>
  <div id="onze_search_button"><hex:linkbutton 
	   icon="${template_path}/icon/system-search.png"
	   title="${resources['Search']}"
	   text="${resources['Search']}"
	   url="javascript:document.frmOnzeSearchBlock.submit();" /></div>
</form>
