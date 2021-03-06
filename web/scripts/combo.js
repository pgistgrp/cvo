Effect.Yellow = function(element) {
	element = $(element);
	new Effect.Highlight(element, arguments[1] || {});	
}

Effect.Drop = function(element) {
	element = $(element);
	new Effect.DropOut(element, arguments[1] || {});	
}

Effect.FadeIn = function(element) {
	element = $(element);
	new Effect.Appear(element, arguments[1] || {});	
}


Effect.OpenUp = function(element) {
     element = $(element);
     new Effect.BlindDown(element, arguments[1] || {});
 }

 Effect.CloseDown = function(element) {
     element = $(element);
     new Effect.BlindUp(element, arguments[1] || {});
 }

 Effect.Combo = function(element) {
     element = $(element);
     if(element.style.display == 'none') { 
          new Effect.OpenUp(element, arguments[1] || {}); 
     }else { 
          new Effect.CloseDown(element, arguments[1] || {}); 
     }
 }