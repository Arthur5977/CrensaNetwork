window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Show":
			$("#fuelMenu").css("display","block");
		break;

		case "Hide":
			$("#fuelMenu").css("display","none");
		break;

		case "Tank":
			$("#lts").html(event["data"]["lts"] + " ¢");
			$("#tank").html(parseInt(event["data"]["tank"]) + " %");
			$("#price").html("$" + parseInt(event["data"]["price"]));
		break;
	}
});