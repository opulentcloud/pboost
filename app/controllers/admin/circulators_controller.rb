class Admin::CirculatorsController < ApplicationController
  before_filter :require_admin_user!
  before_action :set_circulator, only: [:show, :edit, :update, :destroy]

  # GET /circulators
  # GET /circulators.json
  def index
    @circulators = Circulator.order(:last_name).order(:first_name)
  end

  # GET /circulators/1
  # GET /circulators/1.json
  def show
  end

  # GET /circulators/new
  def new
    @circulator = Circulator.new
  end

  # GET /circulators/1/edit
  def edit
  end

  # POST /circulators
  # POST /circulators.json
  def create
    @circulator = Circulator.new(circulator_params)

    respond_to do |format|
      if @circulator.save
        format.html { redirect_to admin_circulator_path(@circulator), notice: 'Circulator was successfully created.' }
        format.json { render :show, status: :created, location: @circulator }
      else
        format.html { render :new }
        format.json { render json: @circulator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /circulators/1
  # PATCH/PUT /circulators/1.json
  def update
    respond_to do |format|
      if @circulator.update(circulator_params)
        format.html { redirect_to admin_circulator_path(@circulator), notice: 'Circulator was successfully updated.' }
        format.json { render :show, status: :ok, location: @circulator }
      else
        format.html { render :edit }
        format.json { render json: @circulator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /circulators/1
  # DELETE /circulators/1.json
  def destroy
    @circulator.destroy
    respond_to do |format|
      format.html { redirect_to admin_circulators_url, notice: 'Circulator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_circulator
      @circulator = Circulator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def circulator_params
      params.require(:circulator).permit(:first_name, :last_name, :address, :city, :state, 
        :zip, :phone_number, petition_header_ids: [])
    end
end
