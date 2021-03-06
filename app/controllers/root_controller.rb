class RootController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.pq_user?
      return redirect_to controller: 'dashboard', action: 'index'
    end

    if current_user.finance_user?
      return redirect_to controller: 'finance', action: 'questions'
    end

    return render :file => 'public/401.html', :status => :unauthorized
  end
end
