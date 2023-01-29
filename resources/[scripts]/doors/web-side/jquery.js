window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Doors":
			if (event["data"]["Status"] == true){
				if ($("#Doors").css("display") === "none"){
					$("#Doors").css("display","block");
				}

				$("#Doors > .Text > b").html(event["data"]["Text"]);
			} else {
				if ($("#Doors").css("display") === "block"){
					$("#Doors").css("display","none");
				}
			}
		break;
	}
});