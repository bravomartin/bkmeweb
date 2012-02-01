
$(document).ready(function(){
  	$(window).load(function(){
		$(".get").each(function(i){
		var img_h = $(this).find(".photo").height();
		var img_w = $(this).find(".photo").width();		
		var w = $(this).width();
		var h = $(this).height();
		if (img_h/img_w > 1) {
			$(this).find(".photo").width(w);
			img_h = $(this).find(".photo").height();
			$(this).find(".photo").css("margin-top",(h-img_h)/2).hide();
		} else {
			$(this).find(".photo").height(h);
			img_w = $(this).find("img.photo").width();
			$(this).find(".photo").css("margin-left",(w-img_w)/2).hide();
		}
		});

	});
	
	
	$(".cycle").cycle({
	    fx:     'scrollLeft',
		next: '.cycle',
		timeout: 4000,
		speed: 200,
		pause: 1
	});
	
	$(".get").hover(function(){
		$(this).find(".map").hide();
		$(this).find(".photo").show();
	}, function(){
		$(this).find(".photo").hide();
		$(this).find(".map").show();
		
	});
	
	
	$("#welcome").click(function(){
		// $(this).slideUp();
		$(this).animate({
		    left: '-=700',
		  }, 500, function() {
		    // Animation complete.
		  });
	});
	

});