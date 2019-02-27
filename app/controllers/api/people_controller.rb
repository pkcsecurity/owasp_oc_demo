class API::PeopleController < ApplicationController
    def index
    # http://0.0.0.0:3000/api/people?client_name=%25' OR Account.Client__r.SSN__c LIKE '%25
        client_name = params[:client_name]
        client = Restforce.new(username: ENV["SALESFORCE_USER"],
                               password: ENV["SALESFORCE_PW"],
                               security_token: ENV["SALESFORCE_SECURITY_TOKEN"],
                               client_id: ENV["SALESFORCE_CLIENT_ID"],
                               client_secret: ENV["SALESFORCE_CLIENT_SECRET"],
                               api_version: '45.0')
        accounts = client.query("select Id, Name from Account where Name = '#{client_name}'")
        account = accounts.first

        print account.Name
        render json: account.Name
    end
end