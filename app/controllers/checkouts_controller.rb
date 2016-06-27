class CheckoutsController < ApplicationController
  def create
  	values = {
        business: "arvindtransactions_api1.paypal.com",
        cmd: "4ZMDKRW8FAVHRCQ6",
        upload: 1,
        return: "localhost:3000",
        invoice: 1,
        amount: 10,
        item_name: 'Ticket',
        item_number: '1',
        quantity: '1'
    }
    redirect_to "#{ENV['paypal_host']}/cgi-bin/webscr?" + values.to_query

  end
end
