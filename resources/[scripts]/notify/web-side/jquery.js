const preset = {
	"vermelho": {
		"color": "#e61a42",
		"background": "rgba(15,15,15,.5)",
		"lightBackground": "radial-gradient(50% 50% at 50% 50%,rgba(251,54,64,0.4) 0%,rgba(251,54,64,0.0375) 85.42%,rgba(251,54,64,0) 100%)"
	},

	"verde": {
		"color": "#a3c846",
		"background": "rgba(15,15,15,.5)",
		"lightBackground": "radial-gradient(50% 50% at 50% 50%,rgba(68,175,105,0.4) 0%,rgba(68,175,105,0.0375) 85.42%,rgba(68,175,105,0) 100%)"
	},

	"amarelo": {
		"color": "#ffb400",
		"background": "rgba(15,15,15,.5)",
		"lightBackground": "radial-gradient(50% 50% at 50% 50%,rgba(224,190,54,0.4) 0%,rgba(224,190,54,0.0375) 85.42%,rgba(224,190,54,0) 100%)"
	},

	"azul": {
		"color": "#669ae1",
		"background": "rgba(15,15,15,.5)",
		"lightBackground": "radial-gradient(50% 50% at 50% 50%,rgba(102,154,225,0.4) 0%,rgba(102,154,225,0.0375) 85.42%,rgba(102,154,225,0) 100%)"
	},

	"roxo": {
		"color": "#a27eba",
		"background": "rgba(15,15,15,.5)",
		"lightBackground": "radial-gradient(50% 50% at 50% 50%,rgba(102,154,225,0.4) 0%,rgba(102,154,225,0.0375) 85.42%,rgba(102,154,225,0) 100%)"
	},

	"sangramento": {
		"color": "#FB3640",
		"background": "rgba(15,15,15,.5)",
		"lightBackground": "radial-gradient(50% 50% at 50% 50%,rgba(251,54,64,0.4) 0%,rgba(251,54,64,0.0375) 85.42%,rgba(251,54,64,0) 100%)"
	},

	"fome": {
		"color": "#fc913a",
		"background": "rgba(15,15,15,.5)",
		"lightBackground": "radial-gradient(50% 50% at 50% 50%,rgba(241,115,0,0.4) 0%,rgba(241,115,0,0.0375) 85.42%,rgba(241,115,0,0) 100%)"
	},

	"sede": {
		"color": "#6fa9dc",
		"background": "rgba(15,15,15,.5)",
		"lightBackground": "radial-gradient(50% 50% at 50% 50%,rgba(102,154,225,0.4) 0%,rgba(102,154,225,0.0375) 85.42%,rgba(102,154,225,0) 100%)"
	}
};

window.addEventListener("message",async(event) => {
	switch (event["data"]["Action"]){
		case "Notify":
			var Html = `
				<div class="notify">
					<div class="notify_style" style="background: ${preset[event["data"]["Css"]]["background"]}">
						<div class="notify_light" style="background: ${preset[event["data"]["Css"]]["lightBackground"]}"></div>

						<div class="notify_content" style="flex-direction: ${(!event["data"]["Title"] ? "row" : "column")}; gap: ${!event["data"]["Title"] && "0.1vw"}">
							<div class="notify_title">
								${event["data"]["Title"] ? `<h1 style="color: ${preset[event["data"]["Css"]]["color"]}">${event["data"]["Title"]}</h1>` : ""}
							</div>
							<p class="notify_text">${event["data"]["Message"]}</p>
						</div>

						<div class="notify_bar">
							<div class="notify_fill" style="animation-duration: ${(event["data"]["Timer"] || 3000) / 1000 + "s"}; background: ${preset[event["data"]["Css"]]["color"]}"></div>
						</div>
					</div>
				</div>`;

			$("#notifys").animate({ scrollTop: $("#notifys").prop("scrollHeight") },100,"swing");
			$(Html).appendTo("#notifys").animate({ left: "0",opacity: 1 },{ duration: 500 }).delay(event["data"]["Timer"]).animate({ left: "-10vw",opacity: 0 },{ duration: 500,complete: function(){ this.remove() }});
		break;
	}
	
	if (event["data"]["shortcuts"] !== undefined){
		if (event["data"]["shortcuts"] == true){
			if ($("#Shortcuts").css("display") === "none"){
				$("#Shortcuts").css("display","flex");
			}

			if (event["data"]["shorts"][1] !== ""){
				$(".Shorts-1").css("background-image",`url(nui://vrp/config/inventory/${event["data"]["shorts"][1]}.png)`);
			} else {
				$(".Shorts-1").css("background-image","none");
			}

				if (event["data"]["shorts"][2] !== ""){
					$(".Shorts-2").css("background-image",`url(nui://vrp/config/inventory/${event["data"]["shorts"][2]}.png)`);
				} else {
					$(".Shorts-2").css("background-image","none");
				}

				if (event["data"]["shorts"][3] !== ""){
					$(".Shorts-3").css("background-image",`url(nui://vrp/config/inventory/${event["data"]["shorts"][3]}.png)`);
				} else {
					$(".Shorts-3").css("background-image","none");
				}

				if (event["data"]["shorts"][4] !== ""){
					$(".Shorts-4").css("background-image",`url(nui://vrp/config/inventory/${event["data"]["shorts"][4]}.png)`);
				} else {
					$(".Shorts-4").css("background-image","none");
				}

				if (event["data"]["shorts"][5] !== ""){
					$(".Shorts-5").css("background-image",`url(nui://vrp/config/inventory/${event["data"]["shorts"][5]}.png)`);
				} else {
					$(".Shorts-5").css("background-image","none");
				}
			} else {
				if ($("#Shortcuts").css("display") === "flex"){
					$("#Shortcuts").css("display","none");
				}
			}
		}
})