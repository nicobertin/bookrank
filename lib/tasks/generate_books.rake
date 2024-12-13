namespace :generate do
    desc "Generate 10 books"
    task books: :environment do
        10.times do
            Book.create(title: Faker::Book.unique.title)
        end
        puts "10 books generated successfully."
    end
end