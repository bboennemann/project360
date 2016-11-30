
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
            $('#total_result_' + timeEntry.data('project_role_id')).html(response['total_result']);
        }
    });
}

function approval(approval){
    $.ajax({
        url : '/forecasts/' + approval.data('forecast_id') + '/approval.json' ,
        type : 'post',
        data : { forecast: { approval_status: approval.data('approval_status') } },
        error : function(jqXHR, textStatus, errorThrown) {
            alert('There was a problem loading the requested content. Please try again later');
        },
        success : function(response, resultText) {
            $('#approval_status').html(response['approval_status']);
        }
    });
}


$(document).ready(function() {

	$('.forecast_entry').change(function(){
		newUserForecastEntry($(this));
	});

    $('#approval_request').click(function(){
        approval($(this));
    });


});