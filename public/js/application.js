
$(document).ready(function(){
  	$(window).load(function(){
		$(".photo").width(180);
		var img_h = $("img.photo").height();
		var img_w = $("img.photo").width();
		var w = $(".get").width();
		var h = $(".get").height();
		
		
		$(".get > .photo").show().css("margin-top",(h-img_h)/2);
		$(".get > .photo").css("margin-left",(w-img_w)/2).hide();

	});
	
	
	$(".get").hover(function(){
		$(this).find(".map").hide();
		$(this).find(".photo").show();
	}, function(){
		$(this).find(".photo").hide();
		$(this).find(".map").show();
		
	});
	
	
	$("#welcome").click(function(){
		$(this).slideUp();
	});
	

});