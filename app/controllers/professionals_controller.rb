class ProfessionalsController < ApplicationController
  load_and_authorize_resource
  before_action :load_titles, only: [:new, :edit]

  # GET /professionals
  def index
    @professionals = Professional.all
  end

  # GET /professionals/1
  def show
  end

  # GET /professionals/new
  def new
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
  end

  # POST /professionals
  def create
    @professional = Professional.new(professional_params)

    if @professional.save
      redirect_to @professional, notice: 'Professional was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /professionals/1
  def update
    if @professional.update(professional_params)
      redirect_to @professional, notice: 'Professional was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /professionals/1
  def destroy
    if @professional.destroy
      redirect_to professionals_url, notice: 'Professional was successfully destroyed.'
    else
      redirect_to professionals_url, alert: @professional.errors.full_messages.join
    end
  end

  private

  def load_titles
    @titles = %w[Dr. Lic. Ing.]
  end

  # Only allow a list of trusted parameters through.
  def professional_params
    params.require(:professional).permit(:title, :name, :surname, :active)
  end
end
