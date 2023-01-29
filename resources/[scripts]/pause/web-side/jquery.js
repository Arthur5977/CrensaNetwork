window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Open":
			$("#Body").css("display","block");
		break;
	}
})

$(function(){
	$("#resume").click(function(){
		Close();
	});

	$("#map").click(function(){
		$.post("https://pause/Action",JSON.stringify({ action: "Map" }))
		Close();
	});

	$("#settings").click(function(){
		$.post("https://pause/Action",JSON.stringify({ action: "Settings" }));
		Close();
	});

	$("#shop").click(function(){
		$.post("https://pause/Action",JSON.stringify({ action: "Shop" }));
		Close();
	});

	$("#link").click(function(){
		window.invokeNative("openUrl","https://discord.gg/RCgdWDZNwU");
	});
})

function Close(){
	$("#Body").css("display","none");
	$.post("https://pause/Close");
}

document.addEventListener("keydown",event => {
    if (event["key"] === "Escape"){
		$("#Body").css("display","none");
		$.post("https://pause/Close");
    }
});