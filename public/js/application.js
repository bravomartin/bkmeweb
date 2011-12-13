
$(document).ready(function(){
  	$(window).load(function(){
		var img_w = $(".photo").width(180);
		var img_h = $(".photo").height();
		var img_w = $(".photo").width();
		var w = $(".get").width();
		var h = $(".get").height();
		
		$(".get > .photo").show().css("margin-top",h/2-img_h/2);
		$(".get > .photo").css("margin-left",w/2-img_w/2).hide();

	});
	
	
	$(".get").hover(function(){
		console.log("im over")
		$(this).find(".map").hide();
		$(this).find(".photo").show();
	}, function(){
		$(this).find(".photo").hide();
		$(this).find(".map").show();
		
	});
	

});