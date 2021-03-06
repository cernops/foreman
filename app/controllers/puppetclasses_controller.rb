class PuppetclassesController < ApplicationController
  include Foreman::Controller::Environments
  include Foreman::Controller::AutoCompleteSearch
  before_filter :find_by_name, :only => [:edit, :update, :destroy, :assign]
  before_filter :setup_search_options, :only => :index
  before_filter :reset_redirect_to_url, :only => :index
  before_filter :store_redirect_to_url, :only => :edit

  def index
    begin
      values = Puppetclass.search_for(params[:search], :order => params[:order])
    rescue => e
      error e.to_s
      values = Puppetclass.search_for ""
    end
    @puppetclasses = values.paginate(:page => params[:page])
    @host_counter = Host.count(:group => :puppetclass_id, :joins => :puppetclasses, :conditions => {:puppetclasses => {:id => @puppetclasses.all}})
    @keys_counter = Puppetclass.joins(:class_params).select('distinct environment_classes.lookup_key_id').count(:group => 'name')
  end

  def new
    @puppetclass = Puppetclass.new
  end

  def create
    @puppetclass = Puppetclass.new(params[:puppetclass])
    if @puppetclass.save
      notice _("Successfully created puppetclass.")
      redirect_to puppetclasses_url
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @puppetclass.update_attributes(params[:puppetclass])
      notice _("Successfully updated puppetclass.")
      redirect_back_or_default(puppetclasses_url)
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @puppetclass.destroy
      notice _("Successfully destroyed puppetclass.")
    else
      error @puppetclass.errors.full_messages.join("<br/>")
    end
    redirect_to puppetclasses_url
  end

  # form AJAX methods
  def parameters
    puppetclass = Puppetclass.find(params[:id])
    render :partial => "puppetclasses/class_parameters", :locals => {
        :puppetclass => puppetclass,
        :obj => get_host_or_hostgroup}
  end

  private

  def get_host_or_hostgroup
    # params['host_id'] = 'null' if NEW since hosts/form and hostgroups/form has data-id="null"
    if params['host_id'] == 'null'
      @obj = Host::Managed.new(params['host']) if params['host']
      @obj ||= Hostgroup.new(params['hostgroup']) if params['hostgroup']
    else
      if params['host']
        @obj = Host::Base.find(params['host_id'])
        unless @obj.kind_of?(Host::Managed)
          @obj      = @obj.becomes(Host::Managed)
          @obj.type = "Host::Managed"
        end
        # puppetclass_ids is removed since it causes an insert on host_classes before form is submitted
        @obj.attributes = params['host'].except!(:puppetclass_ids)
      elsif params['hostgroup']
        # hostgroup.id is assigned to params['host_id'] by host_edit.js#load_puppet_class_parameters
        @obj = Hostgroup.find(params['host_id'])
        # puppetclass_ids is removed since it causes an insert on hostgroup_classes before form is submitted
        @obj.attributes = params['hostgroup'].except!(:puppetclass_ids)
      end
    end
    @obj
  end

  def reset_redirect_to_url
    session[:redirect_to_url] = nil
  end

  def store_redirect_to_url
    session[:redirect_to_url] ||= request.referer
  end

  def redirect_back_or_default(default)
    redirect_to(session[:redirect_to_url] || default)
    session[:redirect_to_url] = nil
  end


end
