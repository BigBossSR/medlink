class ConfirmationsController < Devise::ConfirmationsController
  def show
    @original_token = params[:confirmation_token]
    self.resource = resource_class.find_by_confirmation_token Devise.token_generator.
      digest(self, :confirmation_token, @original_token)
    super if resource.nil? or resource.confirmed?
  end

  def confirm
    @original_token = params[resource_name].try(:[], :confirmation_token)
    digested_token = Devise.token_generator.digest(self, :confirmation_token, @original_token)
    self.resource = resource_class.find_by_confirmation_token! digested_token
    resource.assign_attributes(permitted_params) unless params[resource_name].nil?

    if resource.valid?
      self.resource.confirm!
      set_flash_message :notice, :confirmed
      sign_in_and_redirect resource_name, resource
    else
      render action: :show
    end
  end

 private

   def permitted_params
     params.require(resource_name).permit(:confirmation_token, :password, :password_confirmation)
   end
end
