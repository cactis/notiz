class InteractionsController < ApplicationController
  def index
    @interactions = Interaction.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @interactions }
    end
  end

  def show
    @interaction = Interaction.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @interaction }
    end
  end

  def new
    @interaction = Interaction.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @interaction }
    end
  end

  def edit
    @interaction = Interaction.find(params[:id])
  end

  def create
    @interaction = Interaction.new(params[:interaction])
    respond_to do |format|
      if @interaction.save
        format.html { redirect_to @interaction, notice: 'Interaction was successfully created.' }
        format.json { render json: @interaction, status: :created, location: @interaction }
      else
        format.html { render action: "new" }
        format.json { render json: @interaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @interaction = Interaction.find(params[:id])
    respond_to do |format|
      if @interaction.update_attributes(params[:interaction])
        format.html { redirect_to @interaction, notice: 'Interaction was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @interaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @interaction = Interaction.find(params[:id])
    @interaction.destroy
    respond_to do |format|
      format.html { redirect_to interactions_url }
      format.json { head :ok }
    end
  end
end
