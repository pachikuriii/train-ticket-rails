# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :check_expiration, only: %i[edit update]

  def index
    redirect_to root_path
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_create_params)
    if @ticket.save
      redirect_to [:edit, @ticket], notice: '乗車しました。🚃'
    else
      render :new
    end
  end

  def show
    @ticket = Ticket.find(params[:id])
    redirect_to [:edit, @ticket]
  end

  def edit; end

  def update
    if Gate.find(params[:ticket][:exited_gate_id]).exit?(@ticket) && @ticket.update(ticket_update_params)
      redirect_to root_path, notice: '降車しました。😄'
    else
      flash[:alert] = '降車駅 では降車できません。'
      redirect_to [:edit, @ticket], alert: '降車駅 では降車できません。'
    end
  end

  private

  def ticket_create_params
    params.require(:ticket).permit(:fare, :entered_gate_id)
  end

  def ticket_update_params
    params.require(:ticket).permit(:exited_gate_id)
  end

  def check_expiration
    @ticket = Ticket.find(params[:id])
    redirect_to root_path, alert: '降車済みの切符です。' if @ticket.exited_gate_id
  end
end
