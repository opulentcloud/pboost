class Admin::PetitionHeadersController < ApplicationController
  before_filter :require_admin_user!
  before_action :set_petition_header, only: [:show, :edit, :update, :destroy]

  # GET /petition_headers
  # GET /petition_headers.json
  def index
    @petition_headers = PetitionHeader.order(:name)
  end

  # GET /petition_headers/1
  # GET /petition_headers/1.json
  def show
    @index_manage_users = false
    @index_manage_circulators = false
  end

  # GET /petition_headers/new
  def new
    @petition_header = PetitionHeader.new
  end

  # GET /petition_headers/1/edit
  def edit
  end

  # POST /petition_headers
  # POST /petition_headers.json
  def create
    @petition_header = PetitionHeader.new(petition_header_params)

    respond_to do |format|
      if @petition_header.save
        format.html { redirect_to admin_petition_header_path(@petition_header), notice: 'Petition header was successfully created.' }
        format.json { render :show, status: :created, location: @petition_header }
      else
        format.html { render :new }
        format.json { render json: @petition_header.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /petition_headers/1
  # PATCH/PUT /petition_headers/1.json
  def update
    respond_to do |format|
      if @petition_header.update(petition_header_params)
        format.html { redirect_to admin_petition_header_path(@petition_header), notice: 'Petition header was successfully updated.' }
        format.json { render :show, status: :ok, location: @petition_header }
      else
        format.html { render :edit }
        format.json { render json: @petition_header.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /petition_headers/1
  # DELETE /petition_headers/1.json
  def destroy
    @petition_header.destroy
    respond_to do |format|
      format.html { redirect_to admin_petition_headers_url, notice: 'Petition header was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_petition_header
      @petition_header = PetitionHeader.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def petition_header_params
      params.require(:petition_header).permit(:voters_of, :baltimore_city, :party_affiliation, 
        :unaffiliated, :name, :address, :office_and_district, :ltgov_name, :ltgov_address,
        circulator_ids: [], user_ids: [])
    end
end
