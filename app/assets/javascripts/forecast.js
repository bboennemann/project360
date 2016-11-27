
function newUserForecastEntry(timeEntry){
    $.ajax({
        url : '/user_forecasts/update_time_entry.json' ,
        data : { user_forecast: { user_id: timeEntry.data('user_id'), forecast_id: timeEntry.data('forecast_id'), project_role_id: timeEntry.data('project_role_id'), time_entries_attributes: [{ entry_date: timeEntry.data('date'), hours: timeEntry.val() }] }},
        type : 'post',
        error : function(jqXHR, textStatus, errorThrown) {
            alert('There was a problem loading the requested content. Please try again later');
        },
        success : function(html, resultText) {
        }
    });
}

$(document).ready(function() {

	$('.forecast_entry').change(function(){
		newUserForecastEntry($(this));
	});

});