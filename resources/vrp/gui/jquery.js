// -------------------------------------------------------------------------------------------
window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Display":
			$("#Survival").css("display",event["data"]["Mode"]);
		break;

		case "Message":
			$("#Survival").html(event["data"]["Message"]);
		break;
	}
});