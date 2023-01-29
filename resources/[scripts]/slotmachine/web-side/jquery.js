window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Show":
			$("#SlotMachine").css("display","block");
		break;

		case "Hide":
			$("#SlotMachine").css("display","none");
		break;
	}
});