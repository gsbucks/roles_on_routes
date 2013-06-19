require 'roles_on_routes/base'
require 'ostruct'
require 'debugger'

class AnimalsController
end

describe 'ActionDispatch::Routing::Routeset#roles_for' do
  describe '#roles_for' do
    let(:routeset)    { ActionDispatch::Routing::RouteSet.new }
    let(:link_text)   { 'Link Text' }
    let(:action_view) { ActionView::Base.new }
    let(:path)        { '/animals' }
    let(:action)      { 'GET' }
    let(:params)      {{ left: 'right', up: 'down' }}

    before do
      r = roleset #Scoping issues during route evaling if roleset only in lets
      routeset.draw do
        resources :animals, roles: r
      end
      RolesOnRoutes::Configuration.routeset_containing_roles = routeset
    end

    subject { RolesOnRoutes::Base.roles_for(path, action, params) }

    context 'array' do
      let (:roleset) { [:staff] }
      it { should == roleset }
    end

    context 'symbol' do
      let (:roleset) { :staff }
      it { should == [roleset] }
    end

    context 'proc' do
      let (:roleset) { RolesOnRoutes::DynamicRoleset.new{|params| params.keys.first } }
      it { should == [:left] }
    end
  end
end
