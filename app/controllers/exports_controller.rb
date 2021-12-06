class ExportsController < ApplicationController
    load_and_authorize_resource
    before_action :set_professionals
  # GET /exports/new
  def new
    @export = Export.new
    respond_to do |format|
      format.html
      format.pdf  { redirect_to :root }  
      end 
  end

  # POST /exports
  def create
    @export = Export.new(export_params)
    if @export.valid?
        respond_to do |format|
            format.html { render :action => 'new' }
            format.pdf do 
                pdf = ExportPdf.new(date: @export.date, professional: @export.professional, type: @export.type )
                send_data( pdf.render, filename: 
                    "Appointments_for_#{@export.type}_#{@export.date.strftime("%d/%m/%Y")}.pdf",
                    type: "application/pdf", status: "200 OK", disposition: "inline" ) 
                  
            end 
        end 
    else
        render :new, alert: 'Could not export file.'            
    end

  end


  private
  def set_professionals
    @professionals = Professional.all.order(:surname)
  end 
    # Only allow a list of trusted parameters through.
    def export_params
      params.require(:export).permit(:professional, :date, :type)
    end
end
