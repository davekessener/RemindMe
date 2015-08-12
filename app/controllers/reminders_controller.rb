class RemindersController < ApplicationController
  def index
    @reminders = Reminder.all
  end
  
  def create
    @reminder = Reminder.new(reminder_params)
    if @reminder.save
      flash[:success] = "Successfully saved reminder for #{@reminder.send_at}!"
      redirect_to reminders_url
    else
      flash[:error] = "Failed to save reminder :("
    end
  end
  
  private
  
    def reminder_params
      return params.require(:reminder).permit(:recipient, :title, :message, :send_at)
    end
end
