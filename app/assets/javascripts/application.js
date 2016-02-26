// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

$(document).ready(function() {
	$('#voting-star-rating').rating({
    step: 1,
    clearButton: "",
    starCaptions: {
    	0.5: 	'Nota 0.5',
    	1: 		'Nota 1',
    	1.5: 	'Nota 1.5',
    	2: 		'Nota 2',
    	2.5: 	'Nota 2.5',
    	3: 		'Nota 3',
    	3.5: 	'Nota 3.5',
    	4: 		'Nota 4',
    	4.5: 	'Nota 4.5',
    	5: 		'Nota 5'
    },
    starCaptionClasses: {
    	0.5: 'label label-danger',
    	1: 	 'label label-danger',
    	1.5: 'label label-danger',
    	2: 	 'label label-warning',
    	2.5: 'label label-warning',
    	3: 	 'label label-info',
    	3.5: 'label label-info',
    	4: 	 'label label-primary',
    	4.5: 'label label-primary',
    	5: 	 'label label-success'}
	});

	$('#voting-star-rating').on('rating.change', function(event, value, caption) {
		if (confirm('Tem certeza de que desejas avaliar com nota ' + value + '?')) {
	  	$("#voting-form").submit();
    } else {
    	$('#voting-star-rating').rating('clear');
    }
	});
});