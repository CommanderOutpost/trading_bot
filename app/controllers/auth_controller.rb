class AuthController < ApplicationController
  include Auth::Registrable
  include Auth::Authenticable
  include Auth::PasswordManageable
end
