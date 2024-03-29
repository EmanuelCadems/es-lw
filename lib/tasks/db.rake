namespace :db do
  desc "TODO"
  task indexs: :environment do
    Article.destroy_all
    Tire.index 'articles' do
      delete

      create :mappings => {
        :article => {
          :properties => {
            :id       => { :type => 'string', :index => 'not_analyzed', :include_in_all => false },
            :title    => { :type => 'string', :boost => 2.0,            :analyzer => 'snowball'  },
            :tags     => { :type => 'string', :analyzer => 'keyword'                             },
            :content  => { :type => 'string', :analyzer => 'czech'                               }
          }
        }
      }
    end
  end

end
