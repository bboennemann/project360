
function newUserForecastEntry(timeEntry){
    $.ajax({
        url : '/user_forecasts/update_time_entry.json' ,
        data : { user_forecast: { user_id: timeEntry.data('user_id'), project_id: timeEntry.data('project_id'), forecast_id: timeEntry.data('forecast_id'), project_role_id: timeEntry.data('project_role_id'), time_entries_attributes: [{ entry_date: timeEntry.data('date'), hours: timeEntry.val() }] }},
        type : 'post',
        error : function(jqXHR, textStatus, errorThrown) {
            alert('There was a problem loading the requested content. Please try again later');
        },
        success : function(response, resultText) {
            $('#total_hours_' + timeEntry.data('project_role_id')).html(response['total_hours']);
            $('#total_amount_' + timeEntry.data('project_role_id')).html(response['total_amount']);
            $('#total_cost_' + timeEntry.data('project_role_id')).html(response['total_cost']);
            $('#total_result_' + timeEntry.data('project_role_id')).html(response['total_amount'] - response['total_cost']);
        }
    });
}

function publishForecast(forecast){
    $.ajax({
        url : '/forecasts/' + forecast.data('forecast_id') + '/publish.json' ,
        type : 'get',
        error : function(jqXHR, textStatus, errorThrown) {
            alert('There was a problem loading the requested content. Please try again later');
        },
        success : function(response, resultText) {
            $('#published_status').html(response['published']);
        }
    });
}

$(document).ready(function() {

	$('.forecast_entry').change(function(){
		newUserForecastEntry($(this));
	});

    $('#publish').click(function(){
        publishForecast($(this));
    });

});