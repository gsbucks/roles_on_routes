require 'action_dispatch/routing/routeset_override'
require 'action_dispatch/routing/mapper_override'

class AnimalsController
end
class RatsController
end
class CatsController
end

describe 'ActionDispatch::Routing::Routeset#roles_for' do
  let (:routeset) { ActionDispatch::Routing::RouteSet.new }

  before do
    routeset.draw do
      scope roles: [:staff] do
        resources :animals, action_roles: { show: [:not_staff] } do
          resources :cats
          resources :rats, action_roles: { index: [:admin] }
          member do
            get :penguin, roles: [:woop]
          end
        end
      end
    end
  end

  subject { routeset.roles_for(path, 'get') }

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
