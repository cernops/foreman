require 'test_helper'

class Api::V2::InterfacesControllerTest < ActionController::TestCase
  set_fixture_class :nics => Nic::BMC
  fixtures :nics

  valid_attrs = { :name  => "test.foreman.com", :ip => "10.0.1.1", :mac => "AA:AA:AA:AA:AA:AA", 
                  :attrs => { :username => "foo", :password => "bar", :provider => "IPMI" } ,
                  :type  => "Nic::BMC" } 

  test "get index for specific host" do
    get :index, {:host_id => hosts(:one).name }
    assert_response :success
    assert_not_nil assigns(:interfaces)
    interfaces = ActiveSupport::JSON.decode(@response.body)
    assert !interfaces.empty?
  end

  test "show an interface" do
    get :show, { :host_id => hosts(:one).to_param, :id => nics(:bmc).to_param }
    assert_response :success
    show_response = ActiveSupport::JSON.decode(@response.body)
    assert !show_response.empty?
  end

  test "create interface" do
    host = hosts(:one)
    assert_difference('host.interfaces.count') do
      post :create, { :host_id => host.to_param, :interface => valid_attrs }
    end
    assert_response 201 
  end

  test "update a host interface" do
     nics(:bmc).update_attribute(:host_id, hosts(:one).id)
     put :update, { :host_id => hosts(:one).to_param, 
                    :id => nics(:bmc).to_param, 
                    :interface => valid_attrs.merge( { :host_id => hosts(:one).id } ) }
     assert_response :success
     assert_equal Host.find_by_name(hosts(:one).name).interfaces.order("nics.updated_at").last.ip, valid_attrs[:ip]
  end 

  test "destroy interface" do
    assert_difference('Nic::BMC.count', -1) do
      delete :destroy, { :host_id => hosts(:one).to_param, :id => nics(:bmc).to_param }
    end
    assert_response :success
  end


  context 'BMC proxy operations' do 
    setup :initialize_proxy_ops

    def initialize_proxy_ops
      User.current = users(:apiadmin)  
      smart_proxies(:bmc)
      nics(:bmc).update_attribute(:host_id, hosts(:one).id)
    end

    test "power call to interface" do
      ProxyAPI::BMC.any_instance.stubs(:power).with(:action => 'status').returns("on")
      put :power, { :host_id => hosts(:one).to_param, :id => nics(:bmc).to_param, :power_action => 'status' }
      assert_response :success
      assert @response.body =~ /on/
    end

    test "wrong power call fails gracefully" do
      put :power, { :host_id => hosts(:one).to_param, :id => nics(:bmc).to_param, :power_action => 'wrongmethod' }
      assert_response 422 
      assert @response.body =~ /Available methods are/
    end

    test "boot call to interface" do
      ProxyAPI::BMC.any_instance.stubs(:boot).with(:function => 'bootdevice', :device => 'bios').
                                              returns( { "action" => "bios", "result" => true } .to_json)
      put :boot, { :host_id => hosts(:one).to_param, :id => nics(:bmc).to_param, :device => 'bios' }
      assert_response :success
      assert @response.body =~ /true/
    end

    test "wrong boot call to interface fails gracefully" do
      put :boot, { :host_id => hosts(:one).to_param, :id => nics(:bmc).to_param, :device => 'wrongbootdevice' }
      assert_response 422 
      assert @response.body =~ /Available devices are/
    end

    test "lan call to interface" do
      ProxyAPI::BMC.any_instance.stubs(:lan).with(:action => 'mac').
                                              returns( { :mac => "aa:aa:aa:aa:aa:aa" } .to_json)
      put :lan, { :host_id => hosts(:one).to_param, :id => nics(:bmc).to_param, :lan_action => 'mac' }
      assert_response :success
      assert @response.body =~ /aa:aa:aa/
    end

    test "wrong lan call to interface fails gracefully" do
      put :lan, { :host_id => hosts(:one).to_param, :id => nics(:bmc).to_param, :lan_action => 'wronglanaction' }
      assert_response 422 
      assert @response.body =~ /Available actions are/
    end
  end
end
