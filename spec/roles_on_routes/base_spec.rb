require 'roles_on_routes/base'
require 'ostruct'
require 'debugger'

class AnimalsController
end
class RatsController
end
class CatsController
end

describe RolesOnRoutes::Base do
  describe '#roles_for' do
    let(:routeset)    { ActionDispatch::Routing::RouteSet.new }
    let(:link_text)   { 'Link Text' }
    let(:action_view) { ActionView::Base.new }
    let(:path)        { '/animals' }
    let(:action)      { 'GET' }
    let(:roleset)     { [:staff] }

    before do
      r = roleset # Scoping problem when defining routes if only set in lets
      routeset.draw do
        scope roles: r do
          resources :animals, action_roles: { show: [:not_staff] } do
            resources :cats
            resources :rats, action_roles: { index: [:admin] }
            member do
              get :penguin, roles: [:woop]
            end
          end
        end
      end
      RolesOnRoutes::Configuration.routeset_containing_roles = routeset
    end

    subject { RolesOnRoutes::Base.roles_for(path, action) }

    context 'array' do
      let (:roleset) { [:staff] }
      it { should == roleset }
    end

    context 'symbol' do
      let (:roleset) { :staff }
      it { should == [roleset] }
    end

    context 'proc' do
      let (:path)    { '/animals/1/cats' }
      let (:roleset) { RolesOnRoutes::DynamicRoleset.new{|params| params[:animal_id] } }
      it { should == ['1'] }
    end

    context 'bad path' do
      let (:path) { '/donkey' }
      it { expect{ subject }.to raise_error }
    end

    context 'animals controller' do
      context 'cats index' do
        let (:path) { '/animals/1/cats' }
        it { should == [:staff] }
      end

      context 'cats show' do
        let (:path) { '/animals/1/cats/2' }
        it { should == [:staff] }
      end

      context 'rats index' do
        let (:path) { '/animals/1/rats' }
        it { should == [:admin] }
      end

      context 'rats show' do
        let (:path) { '/animals/1/rats/2' }
        it { should == [:staff] }
      end

      context 'penguin get' do
        let (:path) { '/animals/1/penguin' }
        it { should == [:woop] }
      end

      context 'animals index' do
        let (:path) { '/animals' }
        it { should == [:staff] }
      end

      context 'animals show' do
        let (:path) { '/animals/1' }
        it { should == [:not_staff] }
      end
    end
  end
end
