$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "openNUI":
				updateGarages();
				$("body").fadeIn();
			break;

			case "closeNUI":
				$("body").fadeOut();
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://garages/close");
		}
	};
});
/* --------------------------------------------------- */
const updateGarages = () => {
	$.post("http://garages/myVehicles",JSON.stringify({}),(data) => {
		const nameList = data.vehicles.sort((a,b) => (a.name2 > b.name2) ? 1: -1);
		$("#displayHud").html(`
			<section class="list">
			${nameList.map((item) => (`
				<div class="item vehicle" data-name="${item.Model}">
					<div class="item-photo" style="background-image: url();">
					<div class="name-veh">
						<small>VEÍCULO</small>
						<span>${item.name}</span>
					</div>
					</div>
					<div class="item-info">
						<div class="column">
							<img src="./engine.png">
							<span>motor</span>
							<div class="bar"><div class="fill" style="width: ${item.engine}%"></div></div>
							<small>${item.engine}%</small>
						</div>
						<div class="column">
							<img src="./body.png">
							<span>lataria</span>
							<div class="bar"><div class="fill" style="width: ${item.body}%"></div></div>
							<small>${item.body}%</small>
						</div>
						<div class="column">
							<img src="./fuel.png">
							<span>gasolina</span>
							<div class="bar"><div class="fill" style="width: ${item.fuel}%"></div></div>
							<small>${item.fuel}%</small>
						</div>
					</div>
				</div>
			`)).join("")}
			</section>
		`);
	});
}
/* --------------------------------------------------- */
$(document).on("click",".vehicle",function(){
	let $el = $(this);
	let isActive = $el.hasClass("active");
	$(".vehicle").removeClass("active");
	if(!isActive) $el.addClass("active");
});
/* --------------------------------------------------- */
$(document).on("click","#spawnVehicle",debounce(function(){
	let $el = $(".vehicle.active").attr("data-name");
	if($el){
		$.post("http://garages/spawnVehicles",JSON.stringify({ name: $el }));
	}
}));
/* --------------------------------------------------- */
$(document).on("click","#transferVehicle",debounce(function(){
	let $el = $(".vehicle.active").attr("data-name");
	if($el){
		$.post("http://garages/transferVehicles",JSON.stringify({ name: $el }));
	}
}));
/* --------------------------------------------------- */
$(document).on("click","#taxVehicle",debounce(function(){
	let $el = $(".vehicle.active").attr("data-name");
	if($el){
		$.post("http://garages/taxVehicles",JSON.stringify({ name: $el }));
	}
}));
/* --------------------------------------------------- */
$(document).on("click","#sellVehicle",debounce(function(){
	let $el = $(".vehicle.active").attr("data-name");
	if($el){
		$.post("http://garages/sellVehicles",JSON.stringify({ name: $el }));
	}
}));
/* --------------------------------------------------- */
$(document).on("click","#storeVehicle",function(){
	$.post("http://garages/deleteVehicles");
});
/* ----------DEBOUNCE---------- */
function debounce(func,immediate){
	var timeout
	return function(){
		var context = this,args = arguments
		var later = function(){
			timeout = null
			if (!immediate) func.apply(context,args)
		}
		var callNow = immediate && !timeout
		clearTimeout(timeout)
		timeout = setTimeout(later,500)
		if (callNow) func.apply(context,args)
	}
}