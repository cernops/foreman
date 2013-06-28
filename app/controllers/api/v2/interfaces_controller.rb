module Api
  module V2
    class InterfacesController < V2::BaseController

      include Api::Version2
      include Api::TaxonomyScope

      before_filter :find_nested_object

      api :GET, "/hosts/:host_id/interfaces", "List all puppetclasses for host"
      param :host_id, String, :desc => "id of nested host"

      def index
        @interface = nested_obj.interfaces
      end

      api :GET, "/hosts/:host_id/interfaces/:id", "Show a puppetclass for host"
      param :host_id, String, :desc => "id of nested host"
      param :id, String, :required => true, :desc => "id of puppetclass"

      def show
      end

      api :POST, "/host/:host_id/interfaces", "Create a nested parameter for host"
      param :host_id, String, :desc => "id of host"
      param :interface, Hash, :required => true do
        param :mac, String, :required => true
        param :ip, String, :required => true
        param :type, String, :required => true
        param :name, String, :required => true
        param :subnet_id, Fixnum
        param :domain_id, Fixnum
        param :attrs, Hash, :required => true do
          param :username, String, :required => true
          param :password, String, :required => true
          param :provider, String, :required => true
        end
      end

      def create
        interface = @nested_obj.interfaces.create(params[:interface])
        interface.attrs = params[:interface]['attrs'] # attrs cannot be mass assigned

        if interface.save
          render :json => interface, :status => 201
        else
          render :json => { :errors => interface.errors.full_messages }, :status => 422
        end
      end

      api :PUT, "/host/:host_id/interfaces/:id", "Update a nested parameter for host"
      param :id, String, :required => true, :desc => "id of parameter"
      param :interface, Hash, :required => true do
        param :mac, String
        param :ip, String
        param :type, String
        param :name, String
        param :subnet_id, Fixnum
        param :domain_id, Fixnum
        param :attrs, Hash do
          param :username, String
          param :password, String
          param :provider, String
        end
      end

      def update
        @interface = @nested_obj.interfaces.find_by_id(params[:id])

        if @interface.present?
          process_response @interface.update_attributes(params[:interface])  # find a way to do that..
# this wont work because of mass assignment of params, stack level too deep. etc
        else
          render_error 'not_found', :status => :not_found
        end
      end

      api :DELETE, "/host/:host_id/interfaces/:id", "Delete a nested parameter for host"
      param :id, String, :required => true, :desc => "id of parameter"

      def destroy
        @interface = @nested_obj.interfaces.find_by_id(params[:id])

        if @interface.present?
          process_response @interface.destroy
        else
          render_error 'not_found', :status => :not_found
        end
      end

      private
      attr_reader :nested_obj

      def find_nested_object
        params.keys.each do |param|
          if param =~ /(\w+)_id$/
            resource_identifying_attributes.each do |key|
              find_method = "find_by_#{key}"
              @nested_obj ||= $1.classify.constantize.send(find_method, params[param])
            end
          end
        end
        return nested_obj if nested_obj
        render_error 'not_found', :status => :not_found and return false
      end

    end
  end
end
