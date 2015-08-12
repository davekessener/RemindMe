class RemindersController < ApplicationController
  def root
    redirect_to reminders_url
  end
  
  def index
    @reminders = Reminder.all
  end
  
  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.was_sent = false
    if @reminder.save
      flash.notice = "Successfully saved reminder for #{@reminder.send_at}!"
      redirect_to reminders_url
    else
      flash.alert = "Failed to save reminder :("
    end
  end
  
  def destroy
    @reminder = Reminder.find(params[:id])
    if @reminder.destroy
      flash.notice = "Reminder #{@reminder.id} on #{@reminder.send_at} was deleted."
      redirect_to reminders_url
    else
      flash.alert = "Remidner #{@reminder.id} coudn't be destroyed."
    end
  end
  
  private
  
    def reminder_params
      return params.require(:reminder).permit(:recipient, :title, :message, :send_at)
    end
end
