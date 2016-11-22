function updateForecast(timeEntry){
    $.ajax({
        url : '/user_forecasts/' + timeEntry.data('user') ,
        data : { user_forecast: { hours: timeEntry }},
        type : 'put',
        error : function(jqXHR, textStatus, errorThrown) {
            alert('There was a problem loading the requested content. Please try again later');
        },
        success : function(html, resultText) {
            alert('success');
        }
    });
}

$(document).ready(function() {

	$('.forecast_entry').change(function(){
		alert($(this).data("user"));
		updateForecast(this);
	});

});