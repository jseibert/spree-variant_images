# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class VariantImagesExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/variant_images"

  # Please use variant_images/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate
    # admin.tabs.add "Variant Images", "/admin/variant_images", :after => "Layouts", :visibility => [:all]
    
    Variant.class_eval do
      has_many :images, :as => :viewable, :order => :position, :dependent => :destroy
    end
    
    Spree::BaseHelper.class_eval do
      def product_cart_description(product)
        truncate(product.description, :length => 90, :omission => "...")
      end
    end
    
    Admin::VariantsController.class_eval do
      after_filter :set_image, :only => [:create, :update]
      
      private
        def set_image
          return unless params[:image]
          return if params[:image][:attachment].blank?    
          image = Image.create params[:image] if params[:image]
          object.images << image
        end
    end
  end
end