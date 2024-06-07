class Api::AccountsController < ApplicationController
    soap_service namespace: 'urn:WashOut'

    before_action :find_account, only: [:get_account, :update_account, :delete_account]

    # SOAP action to list all accounts
    soap_action "list_accounts", return: { accounts: [:id, :name, :email, :mobile_number] }

    def list_accounts
        accounts = Account.all
        render soap: { accounts: accounts.map { |account| { id: account.id, name: account.name, email: account.email, mobile_number: account.mobile_number } } }
    end
  
    # SOAP action to create account
    soap_action "create_account", args: { name: :string, email: :string, mobile_number: :string }, return: :integer

    def create_account
      account = Account.create(account_params)
      render soap: account.id
    end
  
    # SOAP action for retrieving an account
    soap_action "get_account", args: { id: :integer }, return: { id: :integer, name: :string, email: :string, mobile_number: :string }

    def get_account
      render soap: { id: @account.id, name: @account.name, email: @account.email, mobile_number: @account.mobile_number }
    end
  
    # SOAP action for updating an account
    soap_action "update_account", args: { id: :integer, name: :string, email: :string, mobile_number: :string }, return: :boolean

    def update_account
      result = @account.update(account_params)
      render soap: result
    end
  
    # SOAP action for deleting an account
    soap_action "delete_account", args: { id: :integer }, return: :boolean

    def delete_account
      result = @account.destroy
      render soap: result.destroyed?
    end

    private

    def account_params
        params.permit(:name, :email, :mobile_number)
    end

    def find_account
        @account = Account.find_by(id: params[:id])
        unless @account
            return render soap: { error: "Account not found" }, status: :not_found
        end
    end
end