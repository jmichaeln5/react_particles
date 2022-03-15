rand(33..99).times do

  rand_title = [
    Faker::Quote.famous_last_words,
    Faker::Books::CultureSeries.book,
  ].sample

  rand_body = [
    Faker::Lorem.paragraphs(number: rand(3..13)).join(" "),
    Faker::Lorem.sentences(number: rand(8..25)).join(" "),
    Faker::TvShows::AquaTeenHungerForce.quote,
    Faker::TvShows::RickAndMorty.quote
  ].sample


  # post = ReactParticles::Post.create(title: rand_title, body: rand_body)
  post = Post.create(title: rand_title, body: rand_body)
end
