class StatusesController < ApplicationController
  # GET /statuses
  # GET /statuses.json
  
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update,:destroy]
  
  def index
  #yash project
    #@statuses = Status.all
	@statuses = Status.page(params[:page]).order('created_at DESC')
	#@statuses = Status.order('created_at desc').all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statuses }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.json
  def new
    @status = Status.new
	@status.build_document
	 
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])	
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = Status.new(params[:status])

    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render json: @status, status: :created, location: @status }
      else
        format.html { render action: "new" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.json
  def update
    #@status = Status.find(params[:id])
	@status = current_user.statuses.find(params[:id])
	 @document = @status.document
	if params[:status] && params[:status].has_key?(:user_id)		
		params[:status].delete(:user_id) 
	end
    respond_to do |format|
      if @status.update_attributes(params[:status])&&
         @document && @document.update_attributes(params[:status][:document_attributes])
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status = Status.find(params[:id])
	#print @status
    @status.destroy

    respond_to do |format|
      format.html { redirect_to statuses_url }
      format.json { head :no_content }
	  format.js   { render :layout => false }
    end
  end
  
  def p_show
	@user = User.find(params[:id])	
	# @status = Status.find(params[:id])
		if @user
			#@statuses = Status.all
			@statuses = @user.statuses.all
			render action: :p_show
		else			 
			render file 'public/404', status: 404, formats: [:html]
		end
  end
end
