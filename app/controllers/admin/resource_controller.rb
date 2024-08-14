class Admin::ResourceController < Admin::ApplicationController
  inherit_resources

  def create
    create! { collection_path }
  end

  def update
    update! { collection_path }
  end

  protected
  def collection
    @collection ||= end_of_association_chain.paginate(:page => params[:page])
  end

  def permitted_params
    params.permit!
  end
end
