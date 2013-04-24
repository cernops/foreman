module Api
  module V1
    class HostgroupsController < V1::BaseController
      before_filter :find_resource, :only => %w{show update destroy}

      api :GET, "/hostgroups/", "List all hostgroups."
      param :search, String, :desc => "filter results"
      param :order, String, :desc => "sort results"
      param :page, String, :desc => "paginate results"
      param :per_page, String, :desc => "number of entries per request"

      def index
        if search_options.first.is_a?(String) && search_options.first.include?('label') 
          @hostgroups = Hostgroup.select { |hs| hs.label == search_options.first.split('=').last.gsub(/\"/, "") } 
        else
          @hostgroups = Hostgroup.includes(:hostgroup_classes, :group_parameters).
            search_for(*search_options).paginate(paginate_options)
        end
      end

      api :GET, "/hostgroups/:id/", "Show a hostgroup."
      param :id, :identifier, :required => true

      def show
      end

      api :POST, "/hostgroups/", "Create an hostgroup."
      param :hostgroup, Hash, :required => true do
        param :name, String, :required => true
        param :environment_id, :number
        param :operatingsystem_id, :number
        param :architecture_id, :number
        param :medium_id, :number
        param :ptable_id, :number
        param :puppet_ca_proxy_id, :number
        param :subnet_id, :number
        param :domain_id, :number
        param :puppet_proxy_id, :number
      end

      def create
        @hostgroup = Hostgroup.new(params[:hostgroup])
        process_response @hostgroup.save
      end

      api :PUT, "/hostgroups/:id/", "Update an hostgroup."
      param :id, :identifier, :required => true
      param :hostgroup, Hash, :required => true do
        param :name, String
        param :environment_id, :number
        param :operatingsystem_id, :number
        param :architecture_id, :number
        param :medium_id, :number
        param :ptable_id, :number
        param :puppet_ca_proxy_id, :number
        param :subnet_id, :number
        param :domain_id, :number
        param :puppet_proxy_id, :number
      end

      def update
        process_response @hostgroup.update_attributes(params[:hostgroup])
      end

      api :DELETE, "/hostgroups/:id/", "Delete an hostgroup."
      param :id, :identifier, :required => true

      def destroy
        process_response @hostgroup.destroy
      end

    end
  end
end
