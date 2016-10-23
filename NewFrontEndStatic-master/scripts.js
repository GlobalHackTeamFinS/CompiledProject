$(document).ready(function () {

  $(".shelter-toggle" ).click(function() {
  	var parentComponent = $(this).parents('.shelter-list-component');
  	if ($(this).text() === 'SHOW LESS'){
  		parentComponent.find('.more-info').slideToggle('fast');
  		$(this).text('SHOW MORE');
  	} else {
  		parentComponent.find('.more-info').slideToggle('slow');
  		$(this).text('SHOW LESS');
  	}
  });

  $(document('.minutes')
});

//console.log($(window).scrollTop());

// if (1 === 1) {


//   function toTop(callback) {
//     $("html, body").animate({ scrollTop: $(document).height() }, 10000);
//     toTop(function (){
//       if (scrollTop === $(document).height()) {
//         $("html, body").animate({ scrollTop: 0 }, 10000);
//       };
//     });
//   }
  
// }