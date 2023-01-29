window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Show":
			var key = event["data"]["key"] !== undefined ? "<div id='key'>" + event["data"]["key"] + "</div>":""
	
			$("#displayNotify").html(key + "<div id='text'><b>" + event["data"]["title"] + "</b><br>" + event["data"]["legend"] + "</div>");
			$("#displayNotify").css("display","block");
		break;

		case "Hide":
			$("#displayNotify").css("display","none");
		break;
	}
});