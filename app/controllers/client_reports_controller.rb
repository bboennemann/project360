class ClientReportsController < ApplicationController
  def index
  	@client = Client.find(params[:client_id])

  	#@total_client_value = @client.total_value
  end

end
