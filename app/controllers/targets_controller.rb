class TargetsController < ApplicationController
  # GET /targets.json
  def index
    @targets = Target.where(:goal_id => params[:goal_id])

    respond_to do |format|
      format.json { render json: @targets }
    end
  end

  # GET /targets/1.json
  def show
    @target = Target.where(:id => params[:id])

    respond_to do |format|
      format.json { render json: @target }
    end
  end

  # POST /targets.json
  def create
    @target = Target.new(params[:target])

    respond_to do |format|
      if @target.save
        format.json { render json: @target, status: :created }
      else
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /targets/1.json
  def update
    @target = Target.find(params[:id])

    respond_to do |format|
      if @target.update_attributes(params[:target])
        format.json { render json: @target, status: :updated }
      else
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /targets/1.json
  def destroy
    @target = Target.find(params[:id])
    @target.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
