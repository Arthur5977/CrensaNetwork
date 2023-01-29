var Max = 0;
var Checkpoint = 0;
// -------------------------------------------------------------------------------------------
function MinimalTimers(Seconds){
	var Seconds = parseInt(Seconds / 1000)
	var Days = Math.floor(Seconds / 86400)
	Seconds = Seconds - Days * 86400
	var Hours = Math.floor(Seconds / 3600)
	Seconds = Seconds - Hours * 3600
	var Minutes = Math.floor(Seconds / 60)
	Seconds = Seconds - Minutes * 60

	const [D,H,M,S] = [Days,Hours,Minutes,Seconds].map(s => s.toString().padStart(2,0))

	if (Days > 0){
		return D + ":" + H
	} else if (Hours > 0){
		return H + ":" + M
	} else if (Minutes > 0){
		return M + ":" + S
	} else if (Seconds > 0){
		return "00:" + S
	} else {
		return "00:00"
	}
}
// -------------------------------------------------------------------------------------------
window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Display":
			if (event["data"]["Status"]){
				if ($("#Scoreboard").css("display") === "none"){
					$("#Scoreboard").css("display","block");
					Max = event["data"]["Max"];
					Checkpoint = 1;
				}
			} else {
				if ($("#Scoreboard").css("display") === "block"){
					$("#Scoreboard").css("display","none");
				}
			}
		break;

		case "Checkpoint":
			Checkpoint = Checkpoint + 1;
		break;

		case "Ranking":
			var Result = event["data"]["Ranking"];

			if (Result !== false){
				$("#Ranking").css("display","block");

				var Position = 0;
				$("#Ranking").html("");
				$("#Ranking").html(`
					<div id="raceTitle">RANKING</div>
					<div id="raceLegend">Lista dos 5 melhores colocados neste circuito.</div>
				`);

				$.each(Result,(k,v) => {
					$('#Ranking').append(`<div id="raceLine">
						<div class="racePosition">${Position = Position + 1}</div>
						<div class="raceName">${v["Name"]}</div>
						<div class="raceVehicle">${v["Vehicle"]}</div>
						<div class="racePoints">${MinimalTimers(v["Points"])}</div>
					</div>`);
				});

				$('#Ranking').append(`<div id="raceButtom">Pressionando a tecla <key>G</key> você fecha o ranking</div>`);
			} else {
				$("#Ranking").css("display","none");
			}
		break;

		case "Progress":
			$("#Scoreboard").html(`
				CHECKPOINTS <s>${Checkpoint} / ${Max}</s><br>
				PERCORRIDO <s>${MinimalTimers(event["data"]["Points"])}</s><br>
				TEMPO <s>${MinimalTimers(event["data"]["Timer"])}</s>
			`);
		break;
	}
});