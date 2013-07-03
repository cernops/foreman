module Api
  module V2
    class InterfacesController < V2::BaseController

      include Api::Version2
      include Api::TaxonomyScope

      before_filter :find_resource, :only => [:show, :update, :destroy, :power, :boot, :lan]
      before_filter :find_nested_object

      api :GET, '/hosts/:host_id/interfaces', 'List all interfaces for host'
      param :host_id, String, :required => true, :desc => 'id or name of host'

      def index
        @interfaces = @nested_obj.interfaces.paginate(paginate_options)
      end

      api :GET, '/hosts/:host_id/interfaces/:id', 'Show an interface for host'
      param :host_id, String, :required => true, :desc => 'id or name of nested host'
      param :id, String, :required => true, :desc => 'id or name of interface'

      def show
      end

      api :POST, '/host/:host_id/interfaces', 'Create an interface linked to a host'
      param :host_id, String, :required => true, :desc => 'id or name of host'
      param :interface, Hash, :required => true, :desc => 'interface information' do
        param :mac, String, :required => true, :desc => 'MAC address of interface'
        param :ip, String, :required => true, :desc => 'IP address of interface'
        param :type, String, :required => true, :desc => 'Interface type, i.e: Nic::BMC'
        param :name, String, :required => true, :desc => 'Interface name'
        param :subnet_id, Fixnum, :desc => 'Foreman subnet id of interface'
        param :domain_id, Fixnum, :desc => 'Foreman domain id of interface'
        param :attrs, Hash, :required => true do
          param :username, String, :required => true
          param :password, String, :required => true
          param :provider, String, :required => true, :desc => 'Interface provider, i.e: IPMI'
        end
      end

      def create
        interface = @nested_obj.interfaces.new(params[:interface], :without_protection => true)  
        if interface.save
          render :json => interface, :status => 201
        else
          render :json => { :errors => interface.errors.full_messages }, :status => 422
        end
      end

      api :PUT, "/host/:host_id/interfaces/:id", "Update a nested parameter for host"
      param :host_id, String, :required => true, :desc => 'id or name of host'
      param :interface, Hash, :required => true, :desc => 'interface information' do
        param :mac, String, :desc => 'MAC address of interface'
        param :ip, String, :desc => 'IP address of interface'
        param :type, String, :desc => 'Interface type, i.e: Nic::BMC'
        param :name, String, :desc => 'Interface name'
        param :subnet_id, Fixnum, :desc => 'Foreman subnet id of interface'
        param :domain_id, Fixnum, :desc => 'Foreman domain id of interface'
        param :attrs, Hash, :required => true do
          param :username, String 
          param :password, String 
          param :provider, String, :required => true, :desc => 'Interface provider, i.e: IPMI'
        end
      end

      def update
        process_response @interface.update_attributes(params[:interface], :without_protection => true)  
      end

      api :DELETE, "/host/:host_id/interfaces/:id", "Delete a nested parameter for host"
      param :id, String, :required => true, :desc => "id of interface"

      def destroy
        process_response @interface.destroy
      end

      api :PUT, "/host/:host_id/interfaces/:id/power", "Run power operation on interface. "
      param :id, String, :required => true, :desc => "id of interface"
      param :power_action, String, :required => true, :desc => "power action, valid actions are on, off, soft, cycle, status"

      def power
        begin
          render :json => { :power => @interface.proxy.power(:action => params[:power_action]) } , :status => 200
        rescue NoMethodError
          render :json => { :error => "NoMethodError: Available methods are on, off, soft, cycle" }, :status => 422
        end
      end

      api :PUT, "/host/:host_id/interfaces/:id/boot", "Interface boots from specified device."
      param :id, String, :required => true, :desc => "id of interface"
      param :device, String, :required => true, :desc => "boot device, valid devices are disk, cdrom, pxe, bios"

      def boot 
        begin
          render :json => { :boot => @interface.proxy.boot(:function => 'bootdevice', :device => params[:device]) }, :status => 200
        rescue NoMethodError
          render :json => { :error => "NoMethodError: Available devices are disk, cdrom, pxe, bios" }, :status => 422
        end
      end

      api :PUT, "/host/:host_id/interfaces/:id/lan", "Run lan operation on interface."
      param :id, String, :required => true, :desc => "id of interface"
      param :lan_action, String, :required => true, :desc => "lan action, valid actions are ip, netmask, mac, gateway"

      def lan 
        begin
          render :json => { :lan => { params[:lan_action] => @interface.proxy.lan(:action => params[:lan_action]) } }, :status => 200
        rescue NoMethodError
          render :json => { :error => "NoMethodError: Available actions are ip, netmask, mac, gateway" }, :status => 422
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
        return @nested_obj if @nested_obj
        render_error 'not_found', :status => :not_found and return false
      end

      def resource_class
	Nic::BMC
      end
    end
  end
end
