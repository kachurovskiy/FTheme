function addComment() {
	comment = $('#bodyTextArea').val();
	ownerType = $('input[name="ownerType"]').val();
	ownerName = $('input[name="ownerName"]').val();
	$.post("/addCommentAction", "ownerType=" + ownerType + "&ownerName=" + ownerName + 
		"&commentBody=" + encodeURIComponent(comment), refreshComments)
}

function deleteComment(id) {
	ok = confirm("Delete comment forever?");
	if (!ok)
		return false;
	
	comment = $('#bodyTextArea').val();
	ownerType = $('input[name="ownerType"]').val();
	ownerName = $('input[name="ownerName"]').val();
	$.get("/deleteComment?id=" + id, refreshComments);
		
	return false;
}

function refreshComments() {
	ownerType = $('input[name="ownerType"]').val();
	ownerName = $('input[name="ownerName"]').val();
	$.get("../includes/commentsbefb.html?ownerType=" + ownerType + "&ownerName=" + ownerName, onLoadComments)
}

function onLoadComments(data) {
	$('#commentsDiv').replaceWith(data)
}
